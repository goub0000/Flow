"""
Notifications Service
Business logic for push notifications and in-app notifications
"""
from typing import Optional, List, Dict, Any
from datetime import datetime
import logging
from uuid import uuid4

from app.database.config import get_supabase
from app.schemas.notifications import (
    NotificationCreateRequest,
    NotificationResponse,
    NotificationListResponse,
    BulkNotificationCreateRequest,
    BroadcastNotificationRequest,
    MarkNotificationsReadRequest,
    NotificationPreferencesUpdate,
    NotificationPreferencesResponse,
    NotificationStats,
    NotificationPriority,
    NotificationChannel
)

logger = logging.getLogger(__name__)


class NotificationsService:
    """Service for managing notifications"""

    def __init__(self):
        self.db = get_supabase()

    async def create_notification(
        self,
        notification_data: NotificationCreateRequest
    ) -> NotificationResponse:
        """Create a single notification"""
        try:
            # Check user's notification preferences
            prefs = await self._get_user_preferences(notification_data.user_id)

            # Check if notification type is enabled
            if prefs and not prefs.get('in_app_enabled', True):
                logger.info(f"Notification skipped: in-app disabled for user {notification_data.user_id}")
                raise Exception("User has disabled in-app notifications")

            notification = {
                "id": str(uuid4()),
                "user_id": notification_data.user_id,
                "notification_type": notification_data.notification_type.value,
                "title": notification_data.title,
                "message": notification_data.message,
                "priority": notification_data.priority.value,
                "channels": [ch.value for ch in notification_data.channels],
                "action_url": notification_data.action_url,
                "action_text": notification_data.action_text,
                "image_url": notification_data.image_url,
                "is_read": False,
                "is_delivered": True,
                "delivered_at": datetime.utcnow().isoformat(),
                "metadata": notification_data.metadata or {},
                "expires_at": notification_data.expires_at,
                "scheduled_for": notification_data.scheduled_for,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('notifications').insert(notification).execute()

            if not response.data:
                raise Exception("Failed to create notification")

            logger.info(f"Notification created: {response.data[0]['id']} for user {notification_data.user_id}")

            # Note: Supabase Realtime will broadcast this to subscribed clients
            return NotificationResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Create notification error: {e}")
            raise Exception(f"Failed to create notification: {str(e)}")

    async def create_bulk_notifications(
        self,
        bulk_data: BulkNotificationCreateRequest
    ) -> Dict[str, Any]:
        """Create notifications for multiple users"""
        try:
            created_count = 0
            failed_users = []

            for user_id in bulk_data.user_ids:
                try:
                    notification = NotificationCreateRequest(
                        user_id=user_id,
                        notification_type=bulk_data.notification_type,
                        title=bulk_data.title,
                        message=bulk_data.message,
                        priority=bulk_data.priority,
                        channels=bulk_data.channels,
                        action_url=bulk_data.action_url,
                        action_text=bulk_data.action_text,
                        image_url=bulk_data.image_url,
                        metadata=bulk_data.metadata,
                        scheduled_for=bulk_data.scheduled_for
                    )

                    await self.create_notification(notification)
                    created_count += 1

                except Exception as e:
                    logger.error(f"Failed to create notification for user {user_id}: {e}")
                    failed_users.append(user_id)

            logger.info(f"Bulk notifications: {created_count} created, {len(failed_users)} failed")

            return {
                "success": True,
                "created_count": created_count,
                "failed_count": len(failed_users),
                "failed_users": failed_users
            }

        except Exception as e:
            logger.error(f"Bulk notifications error: {e}")
            raise Exception(f"Failed to create bulk notifications: {str(e)}")

    async def broadcast_notification(
        self,
        broadcast_data: BroadcastNotificationRequest
    ) -> Dict[str, Any]:
        """Broadcast notification to all users or specific roles"""
        try:
            # Get target users
            if broadcast_data.target_roles:
                # Query users with specific roles
                # Note: This assumes users table has a 'roles' array field
                users_query = self.db.table('users').select('id')
                users = []

                for role in broadcast_data.target_roles:
                    role_users = users_query.contains('roles', [role]).execute()
                    if role_users.data:
                        users.extend(role_users.data)

                # Remove duplicates
                user_ids = list(set([u['id'] for u in users]))
            else:
                # Broadcast to all users
                all_users = self.db.table('users').select('id').execute()
                user_ids = [u['id'] for u in all_users.data] if all_users.data else []

            if not user_ids:
                raise Exception("No target users found")

            # Create bulk notifications
            bulk_data = BulkNotificationCreateRequest(
                user_ids=user_ids,
                notification_type=broadcast_data.notification_type,
                title=broadcast_data.title,
                message=broadcast_data.message,
                priority=broadcast_data.priority,
                channels=broadcast_data.channels,
                action_url=broadcast_data.action_url,
                action_text=broadcast_data.action_text,
                image_url=broadcast_data.image_url,
                metadata=broadcast_data.metadata,
                scheduled_for=broadcast_data.scheduled_for
            )

            result = await self.create_bulk_notifications(bulk_data)

            logger.info(f"Broadcast notification sent to {result['created_count']} users")

            return result

        except Exception as e:
            logger.error(f"Broadcast notification error: {e}")
            raise Exception(f"Failed to broadcast notification: {str(e)}")

    async def get_notification(
        self,
        notification_id: str,
        user_id: str
    ) -> NotificationResponse:
        """Get notification by ID"""
        try:
            response = self.db.table('notifications').select('*').eq('id', notification_id).single().execute()

            if not response.data:
                raise Exception("Notification not found")

            # Verify ownership
            if response.data['user_id'] != user_id:
                raise Exception("Not authorized to access this notification")

            return NotificationResponse(**response.data)

        except Exception as e:
            logger.error(f"Get notification error: {e}")
            raise Exception(f"Failed to fetch notification: {str(e)}")

    async def list_user_notifications(
        self,
        user_id: str,
        page: int = 1,
        page_size: int = 20,
        unread_only: bool = False
    ) -> NotificationListResponse:
        """List notifications for a user"""
        try:
            query = self.db.table('notifications').select('*', count='exact').eq('user_id', user_id)

            if unread_only:
                query = query.eq('is_read', False)

            # Filter out expired notifications
            query = query.or_(f"expires_at.is.null,expires_at.gt.{datetime.utcnow().isoformat()}")

            offset = (page - 1) * page_size
            query = query.order('created_at', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            # Get unread count
            unread_response = self.db.table('notifications').select('id', count='exact').eq(
                'user_id', user_id
            ).eq('is_read', False).execute()

            notifications = [NotificationResponse(**n) for n in response.data] if response.data else []
            total = response.count or 0
            unread_count = unread_response.count or 0

            return NotificationListResponse(
                notifications=notifications,
                total=total,
                unread_count=unread_count,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List notifications error: {e}")
            raise Exception(f"Failed to list notifications: {str(e)}")

    async def mark_notifications_as_read(
        self,
        user_id: str,
        mark_data: MarkNotificationsReadRequest
    ) -> Dict[str, Any]:
        """Mark notifications as read"""
        try:
            updated_count = 0

            for notification_id in mark_data.notification_ids:
                # Verify ownership
                notification = self.db.table('notifications').select('user_id').eq('id', notification_id).single().execute()

                if not notification.data or notification.data['user_id'] != user_id:
                    continue

                update = {
                    "is_read": True,
                    "read_at": datetime.utcnow().isoformat(),
                    "updated_at": datetime.utcnow().isoformat()
                }

                self.db.table('notifications').update(update).eq('id', notification_id).execute()
                updated_count += 1

            logger.info(f"Marked {updated_count} notifications as read for user {user_id}")

            return {
                "success": True,
                "marked_count": updated_count
            }

        except Exception as e:
            logger.error(f"Mark notifications as read error: {e}")
            raise Exception(f"Failed to mark notifications as read: {str(e)}")

    async def mark_all_as_read(self, user_id: str) -> Dict[str, Any]:
        """Mark all notifications as read for a user"""
        try:
            update = {
                "is_read": True,
                "read_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('notifications').update(update).eq('user_id', user_id).eq('is_read', False).execute()

            count = len(response.data) if response.data else 0

            logger.info(f"Marked all ({count}) notifications as read for user {user_id}")

            return {
                "success": True,
                "marked_count": count
            }

        except Exception as e:
            logger.error(f"Mark all as read error: {e}")
            raise Exception(f"Failed to mark all notifications as read: {str(e)}")

    async def delete_notification(
        self,
        notification_id: str,
        user_id: str
    ) -> Dict[str, Any]:
        """Delete a notification"""
        try:
            # Verify ownership
            notification = await self.get_notification(notification_id, user_id)

            self.db.table('notifications').delete().eq('id', notification_id).execute()

            logger.info(f"Notification deleted: {notification_id}")

            return {"success": True}

        except Exception as e:
            logger.error(f"Delete notification error: {e}")
            raise Exception(f"Failed to delete notification: {str(e)}")

    async def get_notification_preferences(
        self,
        user_id: str
    ) -> NotificationPreferencesResponse:
        """Get user's notification preferences"""
        try:
            response = self.db.table('notification_preferences').select('*').eq('user_id', user_id).single().execute()

            if not response.data:
                # Create default preferences
                return await self._create_default_preferences(user_id)

            return NotificationPreferencesResponse(**response.data)

        except Exception as e:
            logger.error(f"Get notification preferences error: {e}")
            # Return default preferences on error
            return await self._create_default_preferences(user_id)

    async def update_notification_preferences(
        self,
        user_id: str,
        update_data: NotificationPreferencesUpdate
    ) -> NotificationPreferencesResponse:
        """Update user's notification preferences"""
        try:
            # Get existing preferences or create default
            existing = await self.get_notification_preferences(user_id)

            # Build update dict
            update = {"updated_at": datetime.utcnow().isoformat()}

            if update_data.email_enabled is not None:
                update["email_enabled"] = update_data.email_enabled
            if update_data.push_enabled is not None:
                update["push_enabled"] = update_data.push_enabled
            if update_data.sms_enabled is not None:
                update["sms_enabled"] = update_data.sms_enabled
            if update_data.in_app_enabled is not None:
                update["in_app_enabled"] = update_data.in_app_enabled
            if update_data.notification_types is not None:
                update["notification_types"] = update_data.notification_types
            if update_data.quiet_hours_start is not None:
                update["quiet_hours_start"] = update_data.quiet_hours_start
            if update_data.quiet_hours_end is not None:
                update["quiet_hours_end"] = update_data.quiet_hours_end

            response = self.db.table('notification_preferences').update(update).eq('id', existing.id).execute()

            if not response.data:
                raise Exception("Failed to update preferences")

            logger.info(f"Notification preferences updated for user {user_id}")

            return NotificationPreferencesResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Update notification preferences error: {e}")
            raise Exception(f"Failed to update notification preferences: {str(e)}")

    async def get_notification_stats(self, user_id: str) -> NotificationStats:
        """Get notification statistics for a user"""
        try:
            all_notifications = self.db.table('notifications').select('*').eq('user_id', user_id).execute()

            notifications = all_notifications.data if all_notifications.data else []

            total = len(notifications)
            unread = len([n for n in notifications if not n.get('is_read')])
            read = total - unread

            # Group by type
            by_type = {}
            for n in notifications:
                ntype = n.get('notification_type', 'unknown')
                by_type[ntype] = by_type.get(ntype, 0) + 1

            # Group by priority
            by_priority = {}
            for n in notifications:
                priority = n.get('priority', 'normal')
                by_priority[priority] = by_priority.get(priority, 0) + 1

            # Recent activity (last 10 notifications)
            recent = sorted(notifications, key=lambda x: x.get('created_at', ''), reverse=True)[:10]
            recent_activity = [
                {
                    "id": n.get('id'),
                    "type": n.get('notification_type'),
                    "title": n.get('title'),
                    "created_at": n.get('created_at'),
                    "is_read": n.get('is_read')
                }
                for n in recent
            ]

            return NotificationStats(
                total_notifications=total,
                unread_count=unread,
                read_count=read,
                by_type=by_type,
                by_priority=by_priority,
                recent_activity=recent_activity
            )

        except Exception as e:
            logger.error(f"Get notification stats error: {e}")
            raise Exception(f"Failed to get notification stats: {str(e)}")

    async def mark_as_unread(
        self,
        notification_id: str,
        user_id: str
    ) -> Dict[str, Any]:
        """Mark a notification as unread"""
        try:
            # Verify ownership
            notification = await self.get_notification(notification_id, user_id)

            update = {
                "is_read": False,
                "read_at": None,
                "updated_at": datetime.utcnow().isoformat()
            }

            self.db.table('notifications').update(update).eq('id', notification_id).execute()

            logger.info(f"Notification marked as unread: {notification_id}")

            return {"success": True}

        except Exception as e:
            logger.error(f"Mark notification as unread error: {e}")
            raise Exception(f"Failed to mark notification as unread: {str(e)}")

    async def archive_notification(
        self,
        notification_id: str,
        user_id: str
    ) -> Dict[str, Any]:
        """Archive a notification"""
        try:
            # Verify ownership
            notification = await self.get_notification(notification_id, user_id)

            update = {
                "is_archived": True,
                "archived_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            self.db.table('notifications').update(update).eq('id', notification_id).execute()

            logger.info(f"Notification archived: {notification_id}")

            return {"success": True}

        except Exception as e:
            logger.error(f"Archive notification error: {e}")
            raise Exception(f"Failed to archive notification: {str(e)}")

    async def unarchive_notification(
        self,
        notification_id: str,
        user_id: str
    ) -> Dict[str, Any]:
        """Unarchive a notification"""
        try:
            # Verify ownership
            notification = await self.get_notification(notification_id, user_id)

            update = {
                "is_archived": False,
                "archived_at": None,
                "updated_at": datetime.utcnow().isoformat()
            }

            self.db.table('notifications').update(update).eq('id', notification_id).execute()

            logger.info(f"Notification unarchived: {notification_id}")

            return {"success": True}

        except Exception as e:
            logger.error(f"Unarchive notification error: {e}")
            raise Exception(f"Failed to unarchive notification: {str(e)}")

    async def create_default_notification_preferences(self, user_id: str) -> Dict[str, Any]:
        """Create default notification preferences for all notification types"""
        try:
            notification_types = [
                'application_status',
                'grade_posted',
                'message_received',
                'meeting_scheduled',
                'meeting_reminder',
                'achievement_earned',
                'deadline_reminder',
                'recommendation_ready',
                'system_announcement',
                'comment_received',
                'mention',
                'event_reminder'
            ]

            preferences_records = []
            for notification_type in notification_types:
                preferences_records.append({
                    "user_id": user_id,
                    "notification_type": notification_type,
                    "in_app_enabled": True,
                    "email_enabled": True,
                    "push_enabled": True,
                    "created_at": datetime.utcnow().isoformat(),
                    "updated_at": datetime.utcnow().isoformat(),
                })

            # Use upsert to handle duplicates
            response = self.db.table('notification_preferences').upsert(preferences_records).execute()

            logger.info(f"Created default notification preferences for user {user_id}")

            return {
                "success": True,
                "message": f"Created {len(notification_types)} default notification preferences"
            }

        except Exception as e:
            logger.error(f"Create default notification preferences error: {e}")
            raise Exception(f"Failed to create default notification preferences: {str(e)}")

    async def _get_user_preferences(self, user_id: str) -> Optional[Dict[str, Any]]:
        """Internal: Get user preferences"""
        try:
            response = self.db.table('notification_preferences').select('*').eq('user_id', user_id).single().execute()
            return response.data if response.data else None
        except:
            return None

    async def _create_default_preferences(self, user_id: str) -> NotificationPreferencesResponse:
        """Internal: Create default notification preferences"""
        try:
            preferences = {
                "id": str(uuid4()),
                "user_id": user_id,
                "email_enabled": True,
                "push_enabled": True,
                "sms_enabled": False,
                "in_app_enabled": True,
                "notification_types": {},
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('notification_preferences').insert(preferences).execute()

            if response.data:
                return NotificationPreferencesResponse(**response.data[0])
            else:
                # Return default response
                return NotificationPreferencesResponse(**preferences)

        except Exception as e:
            logger.error(f"Create default preferences error: {e}")
            # Return default response on error
            return NotificationPreferencesResponse(**preferences)
