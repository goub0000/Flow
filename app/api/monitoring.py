"""
Monitoring Dashboard API
Provides system health, statistics, and performance metrics
Phase 3 Enhancement - Original Plan
"""

from fastapi import APIRouter, Depends, HTTPException
from supabase import Client
from app.database.config import get_db
from datetime import datetime, timedelta
from typing import Dict, Any, List
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.get("/monitoring/health")
def get_system_health(db: Client = Depends(get_db)):
    """
    Get overall system health status

    Returns:
        System health metrics including database connectivity, data freshness
    """
    try:
        health = {
            "status": "healthy",
            "timestamp": datetime.now().isoformat(),
            "components": {}
        }

        # Check database connectivity
        try:
            response = db.table('universities').select('id', count='exact').limit(1).execute()
            health["components"]["database"] = {
                "status": "healthy",
                "total_universities": response.count if hasattr(response, 'count') else 0
            }
        except Exception as e:
            health["components"]["database"] = {
                "status": "unhealthy",
                "error": str(e)
            }
            health["status"] = "degraded"

        # Check cache table
        try:
            response = db.table('page_cache').select('url_hash', count='exact').limit(1).execute()
            health["components"]["cache"] = {
                "status": "healthy",
                "cached_pages": response.count if hasattr(response, 'count') else 0
            }
        except Exception as e:
            health["components"]["cache"] = {
                "status": "unhealthy",
                "error": str(e)
            }

        # Check logs table
        try:
            response = db.table('system_logs').select('id', count='exact').limit(1).execute()
            health["components"]["logging"] = {
                "status": "healthy",
                "total_logs": response.count if hasattr(response, 'count') else 0
            }
        except Exception as e:
            health["components"]["logging"] = {
                "status": "unhealthy",
                "error": str(e)
            }

        return health

    except Exception as e:
        logger.error(f"Error checking system health: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/monitoring/statistics")
def get_system_statistics(db: Client = Depends(get_db)):
    """
    Get comprehensive system statistics

    Returns:
        System-wide statistics including data coverage, quality metrics
    """
    try:
        stats = {
            "timestamp": datetime.now().isoformat(),
            "universities": {},
            "programs": {},
            "students": {},
            "recommendations": {},
            "cache": {},
            "logs": {}
        }

        # University statistics
        try:
            response = db.table('universities').select('*', count='exact').execute()
            universities = response.data
            total = response.count if hasattr(response, 'count') else len(universities)

            # Count universities with key fields
            with_acceptance = sum(1 for u in universities if u.get('acceptance_rate'))
            with_tuition = sum(1 for u in universities if u.get('tuition_out_state'))
            with_ranking = sum(1 for u in universities if u.get('ranking_national'))

            stats["universities"] = {
                "total": total,
                "with_acceptance_rate": with_acceptance,
                "with_tuition": with_tuition,
                "with_ranking": with_ranking,
                "data_completeness": {
                    "acceptance_rate": round(with_acceptance / total * 100, 1) if total > 0 else 0,
                    "tuition": round(with_tuition / total * 100, 1) if total > 0 else 0,
                    "ranking": round(with_ranking / total * 100, 1) if total > 0 else 0
                }
            }
        except Exception as e:
            logger.error(f"Error getting university stats: {e}")
            stats["universities"]["error"] = str(e)

        # Programs statistics
        try:
            response = db.table('programs').select('id', count='exact').execute()
            stats["programs"] = {
                "total": response.count if hasattr(response, 'count') else 0
            }
        except Exception as e:
            stats["programs"]["error"] = str(e)

        # Student profiles statistics
        try:
            response = db.table('student_profiles').select('id', count='exact').execute()
            stats["students"] = {
                "total_profiles": response.count if hasattr(response, 'count') else 0
            }
        except Exception as e:
            stats["students"]["error"] = str(e)

        # Recommendations statistics
        try:
            response = db.table('recommendations').select('*', count='exact').execute()
            recommendations = response.data
            total_recs = response.count if hasattr(response, 'count') else len(recommendations)

            favorited = sum(1 for r in recommendations if r.get('favorited') == 1)

            stats["recommendations"] = {
                "total": total_recs,
                "favorited": favorited,
                "by_category": {
                    "safety": sum(1 for r in recommendations if r.get('category') == 'Safety'),
                    "match": sum(1 for r in recommendations if r.get('category') == 'Match'),
                    "reach": sum(1 for r in recommendations if r.get('category') == 'Reach')
                }
            }
        except Exception as e:
            stats["recommendations"]["error"] = str(e)

        # Cache statistics
        try:
            response = db.table('page_cache').select('*', count='exact').execute()
            cache_entries = response.data
            total_cache = response.count if hasattr(response, 'count') else len(cache_entries)

            # Count expired vs active
            now = datetime.now()
            expired = sum(1 for e in cache_entries
                         if datetime.fromisoformat(e.get('expires_at', '').replace('Z', '+00:00')) < now.replace(tzinfo=datetime.fromisoformat(e.get('expires_at', '').replace('Z', '+00:00')).tzinfo))

            stats["cache"] = {
                "total_entries": total_cache,
                "active": total_cache - expired,
                "expired": expired
            }
        except Exception as e:
            stats["cache"]["error"] = str(e)

        # Logs statistics (last 24 hours)
        try:
            yesterday = (datetime.now() - timedelta(days=1)).isoformat()
            response = db.table('system_logs').select('level', count='exact').gte('timestamp', yesterday).execute()
            logs = response.data

            stats["logs"] = {
                "last_24h": {
                    "total": len(logs),
                    "error": sum(1 for log in logs if log.get('level') == 'ERROR'),
                    "warning": sum(1 for log in logs if log.get('level') == 'WARNING'),
                    "info": sum(1 for log in logs if log.get('level') == 'INFO')
                }
            }
        except Exception as e:
            stats["logs"]["error"] = str(e)

        return stats

    except Exception as e:
        logger.error(f"Error getting system statistics: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/monitoring/data-quality")
def get_data_quality_metrics(db: Client = Depends(get_db)):
    """
    Get data quality metrics

    Returns:
        Quality metrics including confidence scores, source tracking
    """
    try:
        response = db.table('universities').select('*').execute()
        universities = response.data

        if not universities:
            return {"error": "No universities found"}

        # Calculate quality metrics
        total = len(universities)

        # Fields to check
        critical_fields = [
            'name', 'website', 'country', 'state',
            'acceptance_rate', 'tuition_out_state', 'total_students'
        ]

        field_coverage = {}
        for field in critical_fields:
            count = sum(1 for u in universities if u.get(field))
            field_coverage[field] = {
                "count": count,
                "percentage": round(count / total * 100, 1)
            }

        # Overall completeness score
        total_fields = len(critical_fields)
        total_filled = sum(field_coverage[f]["count"] for f in critical_fields)
        max_possible = total * total_fields
        overall_score = round(total_filled / max_possible * 100, 1)

        return {
            "total_universities": total,
            "overall_completeness": overall_score,
            "field_coverage": field_coverage,
            "quality_score": overall_score
        }

    except Exception as e:
        logger.error(f"Error getting data quality metrics: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/monitoring/recent-errors")
def get_recent_errors(limit: int = 50, db: Client = Depends(get_db)):
    """
    Get recent error logs

    Args:
        limit: Maximum number of errors to return

    Returns:
        Recent error log entries
    """
    try:
        response = db.table('system_logs').select(
            'timestamp', 'logger_name', 'message', 'exception_type', 'exception_message', 'stack_trace'
        ).eq('level', 'ERROR').order('timestamp', desc=True).limit(limit).execute()

        errors = response.data

        return {
            "total": len(errors),
            "errors": errors
        }

    except Exception as e:
        logger.error(f"Error getting recent errors: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/monitoring/performance")
def get_performance_metrics(db: Client = Depends(get_db)):
    """
    Get system performance metrics

    Returns:
        Performance metrics including cache hit rate, API usage
    """
    try:
        metrics = {
            "timestamp": datetime.now().isoformat(),
            "cache_performance": {},
            "database_size": {},
            "api_health": {}
        }

        # Cache hit rate (based on logs if available)
        try:
            # Get cache-related logs from last hour
            one_hour_ago = (datetime.now() - timedelta(hours=1)).isoformat()
            response = db.table('system_logs').select('message').gte('timestamp', one_hour_ago).ilike('message', '%cache%').execute()
            logs = response.data

            hits = sum(1 for log in logs if 'HIT' in log.get('message', '').upper())
            misses = sum(1 for log in logs if 'MISS' in log.get('message', '').upper())
            total = hits + misses

            metrics["cache_performance"] = {
                "last_hour": {
                    "hits": hits,
                    "misses": misses,
                    "hit_rate": round(hits / total * 100, 1) if total > 0 else 0
                }
            }
        except Exception as e:
            metrics["cache_performance"]["error"] = str(e)

        # Database size estimates
        try:
            unis = db.table('universities').select('id', count='exact').execute()
            progs = db.table('programs').select('id', count='exact').execute()
            students = db.table('student_profiles').select('id', count='exact').execute()
            recs = db.table('recommendations').select('id', count='exact').execute()

            metrics["database_size"] = {
                "universities": unis.count if hasattr(unis, 'count') else 0,
                "programs": progs.count if hasattr(progs, 'count') else 0,
                "student_profiles": students.count if hasattr(students, 'count') else 0,
                "recommendations": recs.count if hasattr(recs, 'count') else 0
            }
        except Exception as e:
            metrics["database_size"]["error"] = str(e)

        metrics["api_health"] = {
            "status": "operational",
            "uptime": "cloud-based"
        }

        return metrics

    except Exception as e:
        logger.error(f"Error getting performance metrics: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/monitoring/dashboard")
def get_dashboard_overview(db: Client = Depends(get_db)):
    """
    Get complete dashboard overview

    Returns:
        Comprehensive dashboard data combining all metrics
    """
    try:
        dashboard = {
            "timestamp": datetime.now().isoformat(),
            "health": get_system_health(db),
            "statistics": get_system_statistics(db),
            "data_quality": get_data_quality_metrics(db),
            "performance": get_performance_metrics(db)
        }

        return dashboard

    except Exception as e:
        logger.error(f"Error getting dashboard overview: {e}")
        raise HTTPException(status_code=500, detail=str(e))
