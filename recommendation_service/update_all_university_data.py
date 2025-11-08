"""
Comprehensive University Database Update Script
Runs all data importers in sequence to keep the database up-to-date

This script should be scheduled to run:
- Weekly for QS/THE rankings updates
- Daily for Wikipedia updates
- Monthly for College Scorecard updates
"""

import logging
import sys
import subprocess
from datetime import datetime
from pathlib import Path
import json

# Configure logging
log_dir = Path(__file__).parent / "logs"
log_dir.mkdir(exist_ok=True)

log_file = log_dir / f"database_update_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(log_file),
        logging.StreamHandler(sys.stdout)
    ]
)

logger = logging.getLogger(__name__)


class DatabaseUpdater:
    """Orchestrates all university data import processes"""

    def __init__(self):
        self.script_dir = Path(__file__).parent
        self.results = {
            'start_time': datetime.now().isoformat(),
            'end_time': None,
            'duration_seconds': 0,
            'imports': {}
        }

    def run_import_script(self, script_name: str, description: str, timeout: int = 3600) -> bool:
        """
        Run a Python import script and capture results

        Args:
            script_name: Name of the script file
            description: Human-readable description
            timeout: Timeout in seconds (default 1 hour)

        Returns:
            True if successful, False otherwise
        """
        logger.info("=" * 80)
        logger.info(f"Starting: {description}")
        logger.info("=" * 80)

        script_path = self.script_dir / script_name
        start_time = datetime.now()

        try:
            result = subprocess.run(
                [sys.executable, str(script_path)],
                capture_output=True,
                text=True,
                timeout=timeout,
                cwd=str(self.script_dir)
            )

            end_time = datetime.now()
            duration = (end_time - start_time).total_seconds()

            self.results['imports'][script_name] = {
                'description': description,
                'success': result.returncode == 0,
                'duration_seconds': duration,
                'return_code': result.returncode,
                'start_time': start_time.isoformat(),
                'end_time': end_time.isoformat()
            }

            if result.returncode == 0:
                logger.info(f"✓ {description} completed successfully in {duration:.1f}s")
                logger.info(f"Output: {result.stdout[-500:]}" if result.stdout else "No output")
                return True
            else:
                logger.error(f"✗ {description} failed with return code {result.returncode}")
                logger.error(f"Error: {result.stderr[-500:]}" if result.stderr else "No error output")
                return False

        except subprocess.TimeoutExpired:
            logger.error(f"✗ {description} timed out after {timeout}s")
            self.results['imports'][script_name] = {
                'description': description,
                'success': False,
                'error': 'Timeout',
                'duration_seconds': timeout
            }
            return False

        except Exception as e:
            logger.error(f"✗ {description} failed with exception: {e}")
            self.results['imports'][script_name] = {
                'description': description,
                'success': False,
                'error': str(e),
                'duration_seconds': 0
            }
            return False

    def run_all_updates(self):
        """Run all import scripts in sequence"""
        logger.info("=" * 80)
        logger.info("COMPREHENSIVE DATABASE UPDATE - START")
        logger.info("=" * 80)
        logger.info(f"Started at: {self.results['start_time']}")
        logger.info("")

        # 1. QS Rankings (Top universities with global ranks)
        self.run_import_script(
            'import_to_supabase.py',
            'QS World University Rankings',
            timeout=600  # 10 minutes
        )

        # 2. THE Rankings (Additional top universities)
        self.run_import_script(
            'import_the_rankings.py',
            'THE World University Rankings',
            timeout=600  # 10 minutes
        )

        # 3. Universities List API (Global coverage)
        self.run_import_script(
            'import_universities_list_api.py',
            'Universities List API (Hipolabs)',
            timeout=1800  # 30 minutes
        )

        # 4. College Scorecard (US universities with detailed data)
        self.run_import_script(
            'import_college_scorecard_to_supabase.py',
            'US College Scorecard Data',
            timeout=1800  # 30 minutes
        )

        # 5. Wikipedia Scraper (Non-ranked universities from underrepresented regions)
        self.run_import_script(
            'import_wikipedia_universities.py',
            'Wikipedia University Lists (47 countries)',
            timeout=3600  # 1 hour
        )

        # 6. Data Enrichment (Fill missing city, state, website data)
        self.run_import_script(
            'enrich_university_data.py',
            'Data Enrichment (Fill NULL values)',
            timeout=3600  # 1 hour - processes 1000 universities
        )

        # Finalize results
        end_time = datetime.now()
        self.results['end_time'] = end_time.isoformat()
        start = datetime.fromisoformat(self.results['start_time'])
        self.results['duration_seconds'] = (end_time - start).total_seconds()

        # Save results to JSON
        self.save_results()

        # Print summary
        self.print_summary()

    def save_results(self):
        """Save import results to JSON file"""
        results_file = log_dir / f"update_results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"

        try:
            with open(results_file, 'w') as f:
                json.dump(self.results, f, indent=2)
            logger.info(f"Results saved to: {results_file}")
        except Exception as e:
            logger.error(f"Failed to save results: {e}")

    def print_summary(self):
        """Print summary of all imports"""
        logger.info("")
        logger.info("=" * 80)
        logger.info("DATABASE UPDATE SUMMARY")
        logger.info("=" * 80)

        total_imports = len(self.results['imports'])
        successful = sum(1 for imp in self.results['imports'].values() if imp.get('success', False))
        failed = total_imports - successful

        logger.info(f"Total imports: {total_imports}")
        logger.info(f"Successful: {successful}")
        logger.info(f"Failed: {failed}")
        logger.info(f"Total duration: {self.results['duration_seconds']:.1f}s ({self.results['duration_seconds']/60:.1f} minutes)")
        logger.info("")

        # Detail each import
        logger.info("Import Details:")
        logger.info("-" * 80)

        for script_name, result in self.results['imports'].items():
            status = "✓ SUCCESS" if result.get('success', False) else "✗ FAILED"
            duration = result.get('duration_seconds', 0)
            logger.info(f"{status:12} | {duration:6.1f}s | {result['description']}")

        logger.info("=" * 80)

        # Exit code based on results
        if failed > 0:
            logger.warning(f"Update completed with {failed} failures")
            return 1
        else:
            logger.info("All updates completed successfully!")
            return 0


def main():
    """Main entry point"""
    updater = DatabaseUpdater()

    try:
        exit_code = updater.run_all_updates()
        sys.exit(exit_code)
    except KeyboardInterrupt:
        logger.warning("Update cancelled by user")
        sys.exit(1)
    except Exception as e:
        logger.error(f"Update failed with exception: {e}", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
