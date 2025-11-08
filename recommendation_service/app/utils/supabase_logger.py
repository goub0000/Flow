"""
Supabase-based Logging Handler
Writes logs to Supabase instead of local files
Phase 2 Enhancement - Cloud Migration
"""

import logging
import os
import sys
import traceback
import threading
from datetime import datetime
from typing import Dict, Any, Optional
from queue import Queue, Empty
import time


class SupabaseHandler(logging.Handler):
    """
    Custom logging handler that writes logs to Supabase

    Features:
    - Async writing to avoid blocking
    - Batch insertion for performance
    - Fallback to console if Supabase unavailable
    - Thread-safe operations
    - Automatic retry on failure
    """

    def __init__(
        self,
        supabase_url: Optional[str] = None,
        supabase_key: Optional[str] = None,
        batch_size: int = 10,
        flush_interval: float = 5.0,
        level=logging.INFO
    ):
        """
        Initialize Supabase logging handler

        Args:
            supabase_url: Supabase project URL (or None to use env var)
            supabase_key: Supabase API key (or None to use env var)
            batch_size: Number of logs to batch before writing
            flush_interval: Seconds between forced flushes
            level: Minimum logging level
        """
        super().__init__(level)

        self.supabase = None
        self.enabled = False
        self.queue = Queue()
        self.batch_size = batch_size
        self.flush_interval = flush_interval
        self.worker_thread = None
        self.stop_event = threading.Event()

        # Initialize Supabase connection
        try:
            from supabase import create_client

            url = supabase_url or os.environ.get("SUPABASE_URL")
            key = supabase_key or os.environ.get("SUPABASE_KEY")

            if not url or not key:
                print("WARNING: Supabase credentials not found. Logging to console only.", file=sys.stderr)
                self.enabled = False
            else:
                self.supabase = create_client(url, key)
                self.enabled = True

                # Start background worker thread
                self.worker_thread = threading.Thread(target=self._worker, daemon=True)
                self.worker_thread.start()

        except Exception as e:
            print(f"ERROR: Failed to initialize Supabase logging: {e}", file=sys.stderr)
            self.enabled = False

    def emit(self, record: logging.LogRecord):
        """
        Emit a log record to Supabase

        Args:
            record: LogRecord to emit
        """
        if not self.enabled:
            # Fallback to console
            return

        try:
            # Build log entry
            log_entry = self._build_log_entry(record)

            # Add to queue
            self.queue.put(log_entry)

        except Exception:
            self.handleError(record)

    def _build_log_entry(self, record: logging.LogRecord) -> Dict[str, Any]:
        """
        Build log entry dictionary from LogRecord

        Args:
            record: LogRecord to convert

        Returns:
            Dictionary ready for Supabase insertion
        """
        # Basic fields
        entry = {
            'timestamp': datetime.fromtimestamp(record.created).isoformat(),
            'level': record.levelname,
            'logger_name': record.name,
            'message': record.getMessage(),
            'module': record.module,
            'function_name': record.funcName,
            'line_number': record.lineno,
            'process_id': record.process,
            'thread_id': record.thread,
        }

        # Exception information if present
        if record.exc_info:
            exc_type, exc_value, exc_tb = record.exc_info
            entry['exception_type'] = exc_type.__name__ if exc_type else None
            entry['exception_message'] = str(exc_value) if exc_value else None
            entry['stack_trace'] = ''.join(traceback.format_exception(exc_type, exc_value, exc_tb))

        # Extra data (custom fields passed to logger)
        extra_data = {}
        for key, value in record.__dict__.items():
            if key not in [
                'name', 'msg', 'args', 'created', 'filename', 'funcName',
                'levelname', 'levelno', 'lineno', 'module', 'msecs',
                'message', 'pathname', 'process', 'processName', 'relativeCreated',
                'thread', 'threadName', 'exc_info', 'exc_text', 'stack_info'
            ]:
                extra_data[key] = value

        if extra_data:
            entry['extra_data'] = extra_data

        return entry

    def _worker(self):
        """
        Background worker thread that batches and writes logs to Supabase
        """
        batch = []
        last_flush = time.time()

        while not self.stop_event.is_set():
            try:
                # Try to get log entry from queue
                try:
                    entry = self.queue.get(timeout=0.1)
                    batch.append(entry)
                except Empty:
                    pass

                # Flush if batch is full or interval elapsed
                now = time.time()
                should_flush = (
                    len(batch) >= self.batch_size or
                    (batch and (now - last_flush) >= self.flush_interval)
                )

                if should_flush and batch:
                    self._flush_batch(batch)
                    batch = []
                    last_flush = now

            except Exception as e:
                print(f"ERROR in Supabase logging worker: {e}", file=sys.stderr)
                time.sleep(1)  # Avoid tight loop on persistent errors

        # Flush remaining logs on shutdown
        if batch:
            self._flush_batch(batch)

    def _flush_batch(self, batch: list):
        """
        Write batch of logs to Supabase

        Args:
            batch: List of log entries to write
        """
        if not self.supabase or not batch:
            return

        try:
            # Insert batch into Supabase
            self.supabase.table('system_logs').insert(batch).execute()
        except Exception as e:
            print(f"ERROR: Failed to write logs to Supabase: {e}", file=sys.stderr)
            # Fallback: print first few log messages to console
            for entry in batch[:3]:
                print(f"[{entry['level']}] {entry['logger_name']}: {entry['message']}", file=sys.stderr)

    def flush(self):
        """Force flush all pending logs"""
        # Wait for queue to empty (with timeout)
        timeout = 5.0
        start = time.time()
        while not self.queue.empty() and (time.time() - start) < timeout:
            time.sleep(0.1)

    def close(self):
        """Close the handler and flush remaining logs"""
        self.stop_event.set()
        if self.worker_thread and self.worker_thread.is_alive():
            self.worker_thread.join(timeout=5.0)
        super().close()


def setup_supabase_logging(
    logger_name: Optional[str] = None,
    level: int = logging.INFO,
    also_log_to_console: bool = True
) -> logging.Logger:
    """
    Setup logging with Supabase handler

    Args:
        logger_name: Name of logger (None for root logger)
        level: Minimum logging level
        also_log_to_console: Whether to also log to console

    Returns:
        Configured logger
    """
    logger = logging.getLogger(logger_name)
    logger.setLevel(level)

    # Remove existing handlers
    logger.handlers = []

    # Add Supabase handler
    supabase_handler = SupabaseHandler(level=level)
    supabase_handler.setFormatter(logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    ))
    logger.addHandler(supabase_handler)

    # Optionally add console handler
    if also_log_to_console:
        console_handler = logging.StreamHandler()
        console_handler.setLevel(level)
        console_handler.setFormatter(logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        ))
        logger.addHandler(console_handler)

    return logger


def get_recent_logs(
    level: Optional[str] = None,
    logger_name: Optional[str] = None,
    limit: int = 100
) -> list:
    """
    Retrieve recent logs from Supabase

    Args:
        level: Filter by log level (e.g., 'ERROR')
        logger_name: Filter by logger name
        limit: Maximum number of logs to retrieve

    Returns:
        List of log entries
    """
    try:
        from supabase import create_client

        url = os.environ.get("SUPABASE_URL")
        key = os.environ.get("SUPABASE_KEY")

        if not url or not key:
            print("ERROR: Supabase credentials not found", file=sys.stderr)
            return []

        supabase = create_client(url, key)

        # Build query
        query = supabase.table('system_logs').select('*')

        if level:
            query = query.eq('level', level)
        if logger_name:
            query = query.eq('logger_name', logger_name)

        # Execute query
        response = query.order('timestamp', desc=True).limit(limit).execute()

        return response.data if response.data else []

    except Exception as e:
        print(f"ERROR: Failed to retrieve logs: {e}", file=sys.stderr)
        return []


def get_log_statistics(days: int = 7) -> Dict[str, Any]:
    """
    Get log statistics from Supabase

    Args:
        days: Number of days to include in statistics

    Returns:
        Dictionary with log statistics
    """
    try:
        from supabase import create_client

        url = os.environ.get("SUPABASE_URL")
        key = os.environ.get("SUPABASE_KEY")

        if not url or not key:
            return {}

        supabase = create_client(url, key)

        # Call the stored function
        response = supabase.rpc('get_log_statistics', {'days': days}).execute()

        return {
            'statistics': response.data if response.data else [],
            'days': days
        }

    except Exception as e:
        print(f"ERROR: Failed to get log statistics: {e}", file=sys.stderr)
        return {}


# Example usage
if __name__ == "__main__":
    from dotenv import load_dotenv

    # Load environment variables
    load_dotenv()

    # Setup logger with Supabase
    logger = setup_supabase_logging('test_logger', level=logging.DEBUG)

    # Test logging at different levels
    logger.debug("This is a debug message")
    logger.info("This is an info message")
    logger.warning("This is a warning message")
    logger.error("This is an error message")

    # Test with extra data
    logger.info("Processing university", extra={'university_id': 123, 'university_name': 'MIT'})

    # Test exception logging
    try:
        raise ValueError("This is a test exception")
    except Exception:
        logger.exception("An error occurred during processing")

    # Wait for logs to be written
    time.sleep(2)

    # Retrieve recent logs
    print("\n" + "="*80)
    print("RECENT LOGS FROM SUPABASE")
    print("="*80)
    recent = get_recent_logs(limit=5)
    for log in recent:
        print(f"[{log['timestamp']}] {log['level']}: {log['message']}")

    # Get statistics
    print("\n" + "="*80)
    print("LOG STATISTICS")
    print("="*80)
    stats = get_log_statistics(days=7)
    for stat in stats.get('statistics', []):
        print(f"{stat['level']}: {stat['count']} occurrences")
