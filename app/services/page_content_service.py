"""
Page Content Service - Business logic for CMS
Handles CRUD operations for admin-editable pages
"""
from typing import Optional, Dict, Any, List
from datetime import datetime
import logging

from app.database.config import get_supabase
from app.schemas.page_content import (
    PageContentCreate,
    PageContentUpdate,
    PageContentResponse,
    PageContentListItem,
    PageContentPublicResponse,
    VALID_PAGE_SLUGS,
    PAGE_CONTENT_TEMPLATES
)

logger = logging.getLogger(__name__)


class PageContentService:
    """
    Service for managing page content
    """

    def __init__(self):
        self.db = get_supabase()
        self.table_name = "page_contents"

    async def get_published_page(self, slug: str) -> Optional[PageContentPublicResponse]:
        """
        Get a published page by slug (public access)
        Returns None if page doesn't exist or is not published
        """
        try:
            response = self.db.table(self.table_name).select(
                "page_slug, title, subtitle, content, meta_description"
            ).eq("page_slug", slug).eq("status", "published").single().execute()

            if not response.data:
                return None

            return PageContentPublicResponse(**response.data)

        except Exception as e:
            logger.error(f"Error fetching published page {slug}: {e}")
            return None

    async def get_all_published_pages(self) -> List[PageContentPublicResponse]:
        """
        Get all published pages (public access)
        """
        try:
            response = self.db.table(self.table_name).select(
                "page_slug, title, subtitle, content, meta_description"
            ).eq("status", "published").execute()

            if not response.data:
                return []

            return [PageContentPublicResponse(**item) for item in response.data]

        except Exception as e:
            logger.error(f"Error fetching all published pages: {e}")
            return []

    async def get_page_for_admin(self, slug: str) -> Optional[PageContentResponse]:
        """
        Get page by slug for admin editing (includes all fields and all statuses)
        """
        try:
            response = self.db.table(self.table_name).select("*").eq("page_slug", slug).single().execute()

            if not response.data:
                return None

            return PageContentResponse(**response.data)

        except Exception as e:
            logger.error(f"Error fetching page for admin {slug}: {e}")
            return None

    async def list_all_pages(self) -> List[PageContentListItem]:
        """
        List all pages for admin dashboard
        """
        try:
            response = self.db.table(self.table_name).select(
                "id, page_slug, title, status, updated_at"
            ).order("page_slug").execute()

            if not response.data:
                return []

            return [PageContentListItem(**item) for item in response.data]

        except Exception as e:
            logger.error(f"Error listing all pages: {e}")
            return []

    async def create_page(
        self,
        page_data: PageContentCreate,
        user_id: str
    ) -> PageContentResponse:
        """
        Create a new page (admin only)
        """
        try:
            # Validate slug
            if page_data.page_slug not in VALID_PAGE_SLUGS:
                raise ValueError(f"Invalid page slug: {page_data.page_slug}")

            # Check if page already exists
            existing = self.db.table(self.table_name).select("id").eq(
                "page_slug", page_data.page_slug
            ).execute()

            if existing.data:
                raise ValueError(f"Page with slug '{page_data.page_slug}' already exists")

            # Create page
            insert_data = {
                "page_slug": page_data.page_slug,
                "title": page_data.title,
                "subtitle": page_data.subtitle,
                "content": page_data.content or PAGE_CONTENT_TEMPLATES.get(page_data.page_slug, {}),
                "meta_description": page_data.meta_description,
                "status": page_data.status,
                "created_by": user_id,
                "updated_by": user_id
            }

            response = self.db.table(self.table_name).insert(insert_data).execute()

            if not response.data:
                raise Exception("Failed to create page")

            logger.info(f"Created page: {page_data.page_slug} by user {user_id}")
            return PageContentResponse(**response.data[0])

        except ValueError:
            raise
        except Exception as e:
            logger.error(f"Error creating page: {e}")
            raise Exception(f"Failed to create page: {str(e)}")

    async def update_page(
        self,
        slug: str,
        page_data: PageContentUpdate,
        user_id: str
    ) -> PageContentResponse:
        """
        Update an existing page (admin only)
        """
        try:
            # Check if page exists
            existing = self.db.table(self.table_name).select("id").eq("page_slug", slug).execute()

            if not existing.data:
                raise ValueError(f"Page with slug '{slug}' not found")

            # Build update data (only include non-None fields)
            update_data = {"updated_by": user_id}

            if page_data.title is not None:
                update_data["title"] = page_data.title

            if page_data.subtitle is not None:
                update_data["subtitle"] = page_data.subtitle

            if page_data.content is not None:
                update_data["content"] = page_data.content

            if page_data.meta_description is not None:
                update_data["meta_description"] = page_data.meta_description

            if page_data.status is not None:
                if page_data.status not in ["draft", "published", "archived"]:
                    raise ValueError(f"Invalid status: {page_data.status}")
                update_data["status"] = page_data.status

            # Update page
            response = self.db.table(self.table_name).update(update_data).eq("page_slug", slug).execute()

            if not response.data:
                raise Exception("Failed to update page")

            logger.info(f"Updated page: {slug} by user {user_id}")
            return PageContentResponse(**response.data[0])

        except ValueError:
            raise
        except Exception as e:
            logger.error(f"Error updating page {slug}: {e}")
            raise Exception(f"Failed to update page: {str(e)}")

    async def publish_page(self, slug: str, user_id: str) -> PageContentResponse:
        """
        Publish a page (set status to 'published')
        """
        try:
            response = self.db.table(self.table_name).update({
                "status": "published",
                "updated_by": user_id
            }).eq("page_slug", slug).execute()

            if not response.data:
                raise ValueError(f"Page with slug '{slug}' not found")

            logger.info(f"Published page: {slug} by user {user_id}")
            return PageContentResponse(**response.data[0])

        except ValueError:
            raise
        except Exception as e:
            logger.error(f"Error publishing page {slug}: {e}")
            raise Exception(f"Failed to publish page: {str(e)}")

    async def unpublish_page(self, slug: str, user_id: str) -> PageContentResponse:
        """
        Unpublish a page (set status to 'draft')
        """
        try:
            response = self.db.table(self.table_name).update({
                "status": "draft",
                "updated_by": user_id
            }).eq("page_slug", slug).execute()

            if not response.data:
                raise ValueError(f"Page with slug '{slug}' not found")

            logger.info(f"Unpublished page: {slug} by user {user_id}")
            return PageContentResponse(**response.data[0])

        except ValueError:
            raise
        except Exception as e:
            logger.error(f"Error unpublishing page {slug}: {e}")
            raise Exception(f"Failed to unpublish page: {str(e)}")

    async def get_content_template(self, slug: str) -> Dict[str, Any]:
        """
        Get the content template for a specific page type
        """
        if slug not in PAGE_CONTENT_TEMPLATES:
            raise ValueError(f"No template available for slug: {slug}")

        return PAGE_CONTENT_TEMPLATES[slug]

    async def get_valid_slugs(self) -> List[str]:
        """
        Get list of valid page slugs
        """
        return VALID_PAGE_SLUGS


# Singleton instance
_page_content_service: Optional[PageContentService] = None


def get_page_content_service() -> PageContentService:
    """Get or create PageContentService singleton"""
    global _page_content_service
    if _page_content_service is None:
        _page_content_service = PageContentService()
    return _page_content_service
