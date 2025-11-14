"""
Check Railway deployment status by testing cache endpoints
Monitors deployment progress and reports when new version is live
"""
import requests
import time
import sys
from datetime import datetime

API_URL = "https://web-production-51e34.up.railway.app/api/v1/enrichment"

def check_deployment():
    """Check if cache endpoints are available"""
    try:
        response = requests.get(f"{API_URL}/cache/stats", timeout=5)

        if response.status_code == 200:
            return True, "Cache endpoints are live!"
        elif response.status_code == 404:
            return False, "Endpoints not found (old deployment)"
        else:
            return False, f"Unexpected status: {response.status_code}"
    except requests.exceptions.RequestException as e:
        return False, f"Connection error: {str(e)[:50]}"

def monitor_deployment(max_wait_minutes=10, check_interval_seconds=15):
    """Monitor deployment until it's live or timeout"""
    print("=" * 70)
    print("RAILWAY DEPLOYMENT MONITOR")
    print("=" * 70)
    print(f"\nChecking: {API_URL}/cache/stats")
    print(f"Max wait time: {max_wait_minutes} minutes")
    print(f"Check interval: {check_interval_seconds} seconds\n")

    start_time = time.time()
    max_wait_seconds = max_wait_minutes * 60
    attempt = 0

    while (time.time() - start_time) < max_wait_seconds:
        attempt += 1
        elapsed = int(time.time() - start_time)

        print(f"[{elapsed:03d}s] Attempt {attempt}: ", end="", flush=True)

        is_live, message = check_deployment()

        if is_live:
            print(f"✅ {message}")
            print("\n" + "=" * 70)
            print("🎉 DEPLOYMENT SUCCESSFUL!")
            print("=" * 70)
            print(f"\nTime to deploy: {elapsed} seconds ({elapsed//60}m {elapsed%60}s)")
            print(f"\nCache API is now available at:")
            print(f"  - GET  {API_URL}/cache/stats")
            print(f"  - GET  {API_URL}/cache/health")
            print(f"  - POST {API_URL}/cache/cleanup")
            return 0
        else:
            print(f"⏳ {message}")

        time.sleep(check_interval_seconds)

    print("\n" + "=" * 70)
    print("⚠️  TIMEOUT - Deployment not detected within time limit")
    print("=" * 70)
    print("\nPossible reasons:")
    print("  1. Railway is still building (check Railway dashboard)")
    print("  2. Build failed (check Railway logs)")
    print("  3. Network issues")
    print(f"\nYou can manually check: {API_URL}/cache/stats")
    return 1

if __name__ == "__main__":
    exit_code = monitor_deployment(max_wait_minutes=10, check_interval_seconds=15)
    sys.exit(exit_code)
