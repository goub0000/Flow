"""
Security Headers Middleware
Adds essential security headers to all HTTP responses
"""
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response
import logging

logger = logging.getLogger(__name__)


class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    """
    Middleware to add security headers to all responses

    Headers added:
    - X-Content-Type-Options: Prevents MIME type sniffing
    - X-Frame-Options: Prevents clickjacking attacks
    - X-XSS-Protection: Enables browser XSS filtering
    - Strict-Transport-Security (HSTS): Forces HTTPS connections
    - Content-Security-Policy (CSP): Controls resource loading
    - Referrer-Policy: Controls referrer information
    - Permissions-Policy: Controls browser features

    These headers protect against common web vulnerabilities:
    - Clickjacking
    - Cross-site scripting (XSS)
    - MIME type sniffing
    - Man-in-the-middle attacks
    """

    async def dispatch(self, request: Request, call_next):
        """Add security headers to response"""
        response: Response = await call_next(request)

        # Prevent MIME type sniffing
        # Ensures browsers respect declared content types
        response.headers["X-Content-Type-Options"] = "nosniff"

        # Prevent clickjacking by disallowing iframe embedding
        # SAMEORIGIN allows embedding on same domain only
        response.headers["X-Frame-Options"] = "SAMEORIGIN"

        # Enable browser's XSS filter (legacy, but still useful for older browsers)
        # Modern browsers use CSP instead, but this provides defense in depth
        response.headers["X-XSS-Protection"] = "1; mode=block"

        # Strict Transport Security (HSTS)
        # Forces browsers to use HTTPS for 1 year
        # includeSubDomains applies to all subdomains
        # preload allows inclusion in browser HSTS preload lists
        response.headers["Strict-Transport-Security"] = (
            "max-age=31536000; includeSubDomains; preload"
        )

        # Content Security Policy (CSP)
        # Controls what resources can be loaded and from where
        # This is a restrictive policy - adjust based on your needs
        csp_directives = [
            "default-src 'self'",  # Only load from same origin by default
            "script-src 'self' 'unsafe-inline' 'unsafe-eval'",  # Allow inline scripts (needed for Swagger/FastAPI docs)
            "style-src 'self' 'unsafe-inline'",  # Allow inline styles (needed for Swagger/FastAPI docs)
            "img-src 'self' data: https:",  # Allow images from self, data URIs, and HTTPS
            "font-src 'self' data:",  # Allow fonts from self and data URIs
            "connect-src 'self'",  # Only allow API calls to same origin
            "frame-ancestors 'self'",  # Only allow embedding from same origin
            "base-uri 'self'",  # Restrict base tag to same origin
            "form-action 'self'",  # Only allow form submissions to same origin
        ]
        response.headers["Content-Security-Policy"] = "; ".join(csp_directives)

        # Referrer Policy
        # Controls how much referrer information is sent with requests
        # strict-origin-when-cross-origin: Send full referrer for same-origin, origin only for cross-origin
        response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"

        # Permissions Policy (formerly Feature-Policy)
        # Controls which browser features can be used
        # Disable potentially sensitive features by default
        permissions_directives = [
            "geolocation=()",  # Disable geolocation
            "microphone=()",   # Disable microphone
            "camera=()",       # Disable camera
            "payment=()",      # Disable payment API
            "usb=()",          # Disable USB access
            "magnetometer=()", # Disable magnetometer
            "gyroscope=()",    # Disable gyroscope
        ]
        response.headers["Permissions-Policy"] = ", ".join(permissions_directives)

        return response


def log_security_headers_status():
    """Log that security headers middleware is active"""
    logger.info("Security headers middleware enabled - protecting against:")
    logger.info("  - Clickjacking (X-Frame-Options, CSP)")
    logger.info("  - XSS attacks (X-XSS-Protection, CSP)")
    logger.info("  - MIME sniffing (X-Content-Type-Options)")
    logger.info("  - Man-in-the-middle (HSTS)")
    logger.info("  - Unauthorized feature access (Permissions-Policy)")
