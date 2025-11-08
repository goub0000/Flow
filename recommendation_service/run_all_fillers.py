"""
Orchestrator - Run All Data Fillers Simultaneously
Coordinates multiple specialized data filling programs in parallel
"""

import subprocess
import logging
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Dict, List

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


class FillerOrchestrator:
    """Runs multiple data fillers in parallel"""

    def __init__(self):
        self.fillers = [
            # Priority 1: Core fields that can run in parallel
            {
                'name': 'Website',
                'script': 'auto_fill_website.py',
                'limit': 500,
                'priority': 1,  # Needed by logo filler
            },
            {
                'name': 'Students',
                'script': 'auto_fill_students.py',
                'limit': 500,
                'priority': 1,
            },
            {
                'name': 'University Type',
                'script': 'auto_fill_university_type.py',
                'limit': 500,
                'priority': 1,
            },
            {
                'name': 'Location Type',
                'script': 'auto_fill_location_type.py',
                'limit': 500,
                'priority': 1,
            },
            # Priority 2: Fields that can run after priority 1
            {
                'name': 'Logo',
                'script': 'auto_fill_logo.py',
                'limit': 500,
                'priority': 2,  # Needs website first
            },
            {
                'name': 'Acceptance Rate',
                'script': 'auto_fill_acceptance_rate.py',
                'limit': 500,
                'priority': 2,
            },
            # Priority 3: US-specific fields (lower volume)
            {
                'name': 'Tuition',
                'script': 'auto_fill_tuition.py',
                'limit': 300,
                'priority': 3,  # US only
            },
            {
                'name': 'Graduation Rate',
                'script': 'auto_fill_graduation_rate.py',
                'limit': 300,
                'priority': 3,  # US only
            },
        ]

    def run_all(self, max_workers: int = 4):
        """Run all fillers in parallel"""
        logger.info("=" * 80)
        logger.info("DATA FILLING ORCHESTRATOR")
        logger.info("=" * 80)
        logger.info(f"\nRunning {len(self.fillers)} fillers with {max_workers} workers")
        logger.info("")

        # Sort by priority
        self.fillers.sort(key=lambda x: x['priority'])

        results = {}

        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Submit all jobs
            future_to_filler = {
                executor.submit(self._run_filler, filler): filler
                for filler in self.fillers
            }

            # Collect results as they complete
            for future in as_completed(future_to_filler):
                filler = future_to_filler[future]
                try:
                    result = future.result()
                    results[filler['name']] = result
                    logger.info(f"\n✓ Completed: {filler['name']}")
                    logger.info(f"  {result}")
                except Exception as e:
                    logger.error(f"\n✗ Failed: {filler['name']} - {e}")
                    results[filler['name']] = f"Error: {e}"

        self._print_summary(results)

    def _run_filler(self, filler: Dict) -> str:
        """Run a single filler script"""
        logger.info(f"\nStarting: {filler['name']} ({filler['script']})")

        cmd = ['python', filler['script'], '--limit', str(filler['limit'])]

        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=3600  # 1 hour timeout
            )

            if result.returncode == 0:
                # Extract summary from output
                output_lines = result.stderr.split('\n')
                summary_lines = [line for line in output_lines if 'filled' in line.lower() or 'success' in line.lower()]
                return ' | '.join(summary_lines[-3:]) if summary_lines else "Completed successfully"
            else:
                return f"Failed with code {result.returncode}"

        except subprocess.TimeoutExpired:
            return "Timeout after 1 hour"
        except Exception as e:
            return f"Error: {e}"

    def _print_summary(self, results: Dict):
        """Print final summary"""
        logger.info("\n" + "=" * 80)
        logger.info("ORCHESTRATOR SUMMARY")
        logger.info("=" * 80)

        for filler_name, result in results.items():
            logger.info(f"\n{filler_name}:")
            logger.info(f"  {result}")

        logger.info("\n" + "=" * 80)


def main():
    import argparse

    parser = argparse.ArgumentParser(description='Run all data fillers in parallel')
    parser.add_argument(
        '--workers',
        type=int,
        default=3,
        help='Number of parallel workers (default: 3)'
    )

    args = parser.parse_args()

    orchestrator = FillerOrchestrator()
    orchestrator.run_all(max_workers=args.workers)


if __name__ == "__main__":
    main()
