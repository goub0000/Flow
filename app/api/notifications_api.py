"""
Notifications API Endpoints
RESTful API for push notifications and in-app notifications
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query

from app.services.notifications_service import NotificationsService
from app.schemas.notifications import (
    NotificationCreateRequest,
    NotificationResponse,
    NotificationListResponse,
    BulkNotificationCreateRequest,
    BroadcastNotificationRequest,
    MarkNotificationsReadRequest,
    NotificationPreferencesUpdate,
    NotificationPreferencesResponse,
    NotificationStats
)
from app.utils.security import get_current_user, RoleChecker, UserRole, CurrentUser

router = APIRouter()


@router.get("/notifications")
async def list_notifications(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    unread_only: bool = Query(False),
    current_user: CurrentUser = Depends(get_current_user)
) -> NotificationListResponse:
    """
    List user's notifications

    **Requires:** Authentication

    **Query Parameters:**
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    - unread_only: Show only unread notifications (default: false)

    **Returns:**
    - Paginated list of notifications with unread count

    **Note:** Expired notifications are automatically filtered out
    """
    try:
        service = NotificationsService()
        result = await service.list_user_notifications(current_user.id, page, page_size, unread_only)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/notifications/{notification_id}")
async def get_notification(
    notification_id: str,
    current_user: CurrentUser = Depends(get_current_user)
) -> NotificationResponse:
    """
    Get notification by ID

    **Requires:** Authentication (must be notification owner)

    **Path Parameters:**
    - notification_id: Notification ID

    **Returns:**
    - Notification data
    """
    try:
        service = NotificationsService()
        result = await service.get_notification(notification_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


@router.post("/notifications/read")
async def mark_notifications_as_read(
    mark_data: MarkNotificationsReadRequest,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Mark notifications as read

    **Requires:** Authentication

    **Request Body:**
    - notification_ids: List of notification IDs to mark as read

    **Returns:**
    - Success status and count of marked notifications
    """
    try:
        service = NotificationsService()
        result = await service.mark_notifications_as_read(current_user.id, mark_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/notifications/read-all")
async def mark_all_as_read(
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Mark all notifications as read

    **Requires:** Authentication

    **Returns:**
    - Success status and count of marked notifications
    """
    try:
        service = NotificationsService()
        result = await service.mark_all_as_read(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.delete("/notifications/{notification_id}")
async def delete_notification(
    notification_id: str,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Delete a notification

    **Requires:** Authentication (must be notification owner)

    **Path Parameters:**
    - notification_id: Notification ID

    **Returns:**
    - Success status
    """
    try:
        service = NotificationsService()
        result = await service.delete_notification(notification_id, current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/notifications/preferences/me")
async def get_notification_preferences(
    current_user: CurrentUser = Depends(get_current_user)
) -> NotificationPreferencesResponse:
    """
    Get current user's notification preferences

    **Requires:** Authentication

    **Returns:**
    - Notification preferences including channel settings and quiet hours
    """
    try:
        service = NotificationsService()
        result = await service.get_notification_preferences(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.put("/notifications/preferences/me")
async def update_notification_preferences(
    update_data: NotificationPreferencesUpdate,
    current_user: CurrentUser = Depends(get_current_user)
) -> NotificationPreferencesResponse:
    """
    Update notification preferences

    **Requires:** Authentication

    **Request Body:**
    - email_enabled: Enable/disable email notifications
    - push_enabled: Enable/disable push notifications
    - sms_enabled: Enable/disable SMS notifications
    - in_app_enabled: Enable/disable in-app notifications
    - notification_types: Enable/disable specific notification types
    - quiet_hours_start: Start time for quiet hours (HH:MM format)
    - quiet_hours_end: End time for quiet hours (HH:MM format)

    **Returns:**
    - Updated notification preferences
    """
    try:
        service = NotificationsService()
        result = await service.update_notification_preferences(current_user.id, update_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/notifications/stats/me")
async def get_notification_stats(
    current_user: CurrentUser = Depends(get_current_user)
) -> NotificationStats:
    """
    Get notification statistics

    **Requires:** Authentication

    **Returns:**
    - total_notifications: Total count
    - unread_count: Unread count
    - read_count: Read count
    - by_type: Count by notification type
    - by_priority: Count by priority level
    - recent_activity: Last 10 notifications
    """
    try:
        service = NotificationsService()
        result = await service.get_notification_stats(current_user.id)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


# Admin Endpoints
@router.post("/notifications/send", status_code=status.HTTP_201_CREATED)
async def send_notification(
    notification_data: NotificationCreateRequest,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.ADMIN_SUPER, UserRole.ADMIN_CONTENT]))
) -> NotificationResponse:
    """
    Send a notification to a specific user (Admin only)

    **Requires:** Admin authentication

    **Request Body:**
    - user_id: Target user ID
    - notification_type: Type of notification
    - title: Notification title
    - message: Notification message
    - priority: Priority level (low, normal, high, urgent)
    - channels: Delivery channels (in_app, push, email, sms)
    - action_url: Optional deep link or URL
    - action_text: Optional button text
    - image_url: Optional image
    - metadata: Optional additional data
    - expires_at: Optional expiration timestamp
    - scheduled_for: Optional scheduled delivery time

    **Returns:**
    - Created notification data

    **Note:** Supabase Realtime will broadcast this to the user
    """
    try:
        service = NotificationsService()
        result = await service.create_notification(notification_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/notifications/bulk")
async def send_bulk_notifications(
    bulk_data: BulkNotificationCreateRequest,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.ADMIN_SUPER, UserRole.ADMIN_CONTENT]))
):
    """
    Send notifications to multiple users (Admin only)

    **Requires:** Admin authentication

    **Request Body:**
    - user_ids: List of target user IDs
    - notification_type: Type of notification
    - title: Notification title
    - message: Notification message
    - priority: Priority level
    - channels: Delivery channels
    - action_url: Optional deep link
    - action_text: Optional button text
    - image_url: Optional image
    - metadata: Optional additional data
    - scheduled_for: Optional scheduled delivery time

    **Returns:**
    - created_count: Number of notifications created
    - failed_count: Number of failures
    - failed_users: List of user IDs that failed
    """
    try:
        service = NotificationsService()
        result = await service.create_bulk_notifications(bulk_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/notifications/broadcast")
async def broadcast_notification(
    broadcast_data: BroadcastNotificationRequest,
    current_user: CurrentUser = Depends(RoleChecker([UserRole.ADMIN_SUPER]))
):
    """
    Broadcast notification to all users or specific roles (Super Admin only)

    **Requires:** Super Admin authentication

    **Request Body:**
    - notification_type: Type of notification
    - title: Notification title
    - message: Notification message
    - priority: Priority level
    - channels: Delivery channels
    - target_roles: Optional list of roles (null = all users)
    - action_url: Optional deep link
    - action_text: Optional button text
    - image_url: Optional image
    - metadata: Optional additional data
    - scheduled_for: Optional scheduled delivery time

    **Returns:**
    - created_count: Number of notifications created
    - failed_count: Number of failures
    - failed_users: List of user IDs that failed

    **Warning:** Use with caution. This can send notifications to all users.
    """
    try:
        service = NotificationsService()
        result = await service.broadcast_notification(broadcast_data)
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
