"""
Page Content API endpoints - CMS for footer pages
Provides public read access and admin management endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status
from typing import List, Dict, Any
import logging

from app.schemas.page_content import (
    PageContentCreate,
    PageContentUpdate,
    PageContentResponse,
    PageContentListItem,
    PageContentPublicResponse,
    VALID_PAGE_SLUGS
)
from app.services.page_content_service import get_page_content_service, PageContentService
from app.utils.security import get_current_user, require_admin, CurrentUser

logger = logging.getLogger(__name__)

router = APIRouter()


# ============================================
# PUBLIC ENDPOINTS (No authentication required)
# ============================================

@router.get("/pages/{slug}", response_model=PageContentPublicResponse)
async def get_public_page(slug: str):
    """
    Get published page content by slug (public access)
    Returns 404 if page is not found or not published
    """
    service = get_page_content_service()
    page = await service.get_published_page(slug)

    if not page:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Page '{slug}' not found or not published"
        )

    return page


@router.get("/pages", response_model=List[PageContentPublicResponse])
async def get_all_public_pages():
    """
    Get all published pages (public access)
    """
    service = get_page_content_service()
    return await service.get_all_published_pages()


# ============================================
# ADMIN ENDPOINTS (Authentication required)
# ============================================

@router.get("/admin/pages", response_model=List[PageContentListItem])
async def list_all_pages_admin(
    current_user: CurrentUser = Depends(require_admin)
):
    """
    List all pages for admin dashboard
    Shows all pages regardless of status
    """
    service = get_page_content_service()
    return await service.list_all_pages()


@router.get("/admin/pages/slugs", response_model=List[str])
async def get_valid_page_slugs(
    current_user: CurrentUser = Depends(require_admin)
):
    """
    Get list of valid page slugs
    """
    return VALID_PAGE_SLUGS


@router.get("/admin/pages/template/{slug}", response_model=Dict[str, Any])
async def get_page_template(
    slug: str,
    current_user: CurrentUser = Depends(require_admin)
):
    """
    Get the content template structure for a specific page type
    Useful for understanding expected content structure
    """
    service = get_page_content_service()
    try:
        return await service.get_content_template(slug)
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )


@router.get("/admin/pages/{slug}", response_model=PageContentResponse)
async def get_page_for_editing(
    slug: str,
    current_user: CurrentUser = Depends(require_admin)
):
    """
    Get page content for admin editing
    Returns full page data including all statuses
    """
    service = get_page_content_service()
    page = await service.get_page_for_admin(slug)

    if not page:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Page '{slug}' not found"
        )

    return page


@router.post("/admin/pages", response_model=PageContentResponse)
async def create_page(
    page_data: PageContentCreate,
    current_user: CurrentUser = Depends(require_admin)
):
    """
    Create a new page
    Note: Pages should typically be seeded via database migration
    """
    service = get_page_content_service()
    try:
        return await service.create_page(page_data, current_user.id)
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        logger.error(f"Error creating page: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create page"
        )


@router.put("/admin/pages/{slug}", response_model=PageContentResponse)
async def update_page(
    slug: str,
    page_data: PageContentUpdate,
    current_user: CurrentUser = Depends(require_admin)
):
    """
    Update page content
    """
    service = get_page_content_service()
    try:
        return await service.update_page(slug, page_data, current_user.id)
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        logger.error(f"Error updating page: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update page"
        )


@router.post("/admin/pages/{slug}/publish", response_model=PageContentResponse)
async def publish_page(
    slug: str,
    current_user: CurrentUser = Depends(require_admin)
):
    """
    Publish a page (set status to 'published')
    """
    service = get_page_content_service()
    try:
        return await service.publish_page(slug, current_user.id)
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )
    except Exception as e:
        logger.error(f"Error publishing page: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to publish page"
        )


@router.post("/admin/pages/{slug}/unpublish", response_model=PageContentResponse)
async def unpublish_page(
    slug: str,
    current_user: CurrentUser = Depends(require_admin)
):
    """
    Unpublish a page (set status to 'draft')
    """
    service = get_page_content_service()
    try:
        return await service.unpublish_page(slug, current_user.id)
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e)
        )
    except Exception as e:
        logger.error(f"Error unpublishing page: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to unpublish page"
        )
