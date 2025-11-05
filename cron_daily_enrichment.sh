#!/bin/bash
# Daily enrichment cron job
# Runs daily enrichment via API endpoint

# Get the API URL from environment or use default
API_URL="${RAILWAY_PUBLIC_DOMAIN:-localhost:8000}"

echo "Running daily enrichment at $(date)"
echo "API URL: $API_URL"

# Call the daily enrichment endpoint
curl -X POST "https://${API_URL}/api/v1/enrichment/daily" \
  -H "Content-Type: application/json" \
  --max-time 600

echo "Daily enrichment triggered successfully"
