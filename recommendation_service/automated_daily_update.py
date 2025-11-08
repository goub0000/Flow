"""
Automated Daily Update Script
Runs critical priority updates automatically
Part of Phase 2 Enhancement
"""

import logging
import sys
from pathlib import Path
from datetime import datetime
from smart_update_runner import SmartUpdateRunner

# Setup logging to file
log_dir = Path("logs/automated")
log_dir.mkdir(parents=True, exist_ok=True)

log_file = log_dir / f"daily_update_{datetime.now().strftime('%Y%m%d')}.log"

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(log_file),
        logging.StreamHandler(sys.stdout)
    ]
)

logger = logging.getLogger(__name__)


def main():
    """Run daily automated update"""
    logger.info("=" * 80)
    logger.info("AUTOMATED DAILY UPDATE - CRITICAL PRIORITY")
    logger.info("=" * 80)
    logger.info(f"Log file: {log_file}")

    try:
        # Run critical priority update (30 universities per day)
        runner = SmartUpdateRunner(rate_limit=5.0)

        runner.run_priority_update(
            priority='critical',
            limit=30
        )

        logger.info("\n" + "=" * 80)
        logger.info("DAILY UPDATE COMPLETED SUCCESSFULLY")
        logger.info("=" * 80)

        return 0

    except Exception as e:
        logger.error(f"Daily update failed: {e}", exc_info=True)
        return 1


if __name__ == "__main__":
    sys.exit(main())
