"""
Pydantic schemas for page content management (CMS)
"""
from pydantic import BaseModel, Field
from typing import Optional, Dict, Any, List
from datetime import datetime


class PageContentBase(BaseModel):
    """Base schema for page content"""
    title: str = Field(..., max_length=200)
    subtitle: Optional[str] = Field(None, max_length=500)
    content: Dict[str, Any] = Field(default_factory=dict)
    meta_description: Optional[str] = Field(None, max_length=300)


class PageContentCreate(PageContentBase):
    """Schema for creating new page content"""
    page_slug: str = Field(..., max_length=50)
    status: str = Field(default="draft")


class PageContentUpdate(BaseModel):
    """Schema for updating page content"""
    title: Optional[str] = Field(None, max_length=200)
    subtitle: Optional[str] = Field(None, max_length=500)
    content: Optional[Dict[str, Any]] = None
    meta_description: Optional[str] = Field(None, max_length=300)
    status: Optional[str] = None


class PageContentResponse(PageContentBase):
    """Response schema for page content"""
    id: str
    page_slug: str
    status: str
    created_at: datetime
    updated_at: datetime
    created_by: Optional[str] = None
    updated_by: Optional[str] = None

    class Config:
        from_attributes = True


class PageContentListItem(BaseModel):
    """Simplified schema for listing pages"""
    id: str
    page_slug: str
    title: str
    status: str
    updated_at: datetime

    class Config:
        from_attributes = True


class PageContentPublicResponse(BaseModel):
    """Public response schema (minimal data for frontend)"""
    page_slug: str
    title: str
    subtitle: Optional[str] = None
    content: Dict[str, Any]
    meta_description: Optional[str] = None

    class Config:
        from_attributes = True


# Content type templates for different page types
PAGE_CONTENT_TEMPLATES = {
    "about": {
        "mission": "",
        "vision": "",
        "story": "",
        "team": [],
        "values": []
    },
    "contact": {
        "email": "",
        "phone": "",
        "address": {},
        "social_links": {},
        "support_hours": "",
        "response_time": ""
    },
    "privacy": {
        "last_updated": "",
        "sections": []
    },
    "terms": {
        "last_updated": "",
        "sections": []
    },
    "cookies": {
        "last_updated": "",
        "sections": []
    },
    "data-protection": {
        "last_updated": "",
        "sections": []
    },
    "compliance": {
        "last_updated": "",
        "sections": []
    },
    "careers": {
        "intro": "",
        "benefits": [],
        "positions": [],
        "application_email": ""
    },
    "press": {
        "intro": "",
        "kit_url": "",
        "contacts": [],
        "releases": [],
        "media_assets": {}
    },
    "partners": {
        "intro": "",
        "partner_types": [],
        "current_partners": [],
        "contact_email": ""
    },
    "help": {
        "intro": "",
        "faqs": [],
        "support_email": "",
        "support_hours": ""
    },
    "docs": {
        "intro": "",
        "sections": []
    },
    "api-docs": {
        "intro": "",
        "base_url": "",
        "authentication": "",
        "sections": [],
        "support_email": ""
    },
    "community": {
        "intro": "",
        "forums": [],
        "events": [],
        "social_links": {},
        "newsletter_signup": False
    },
    "blog": {
        "intro": "",
        "categories": [],
        "featured_posts": [],
        "subscribe_cta": ""
    },
    "mobile-apps": {
        "intro": "",
        "features": [],
        "requirements": {},
        "download_links": {},
        "qr_codes": {}
    }
}

# List of all valid page slugs
VALID_PAGE_SLUGS = list(PAGE_CONTENT_TEMPLATES.keys())
