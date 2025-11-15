#!/bin/bash

# Flutter Web Build Script with Environment Variables
# This script builds the Flutter web app with the required environment variables

echo "========================================="
echo "Building Flutter Web with Environment Variables"
echo "========================================="

# Check if environment variables are set
if [ -z "$SUPABASE_URL" ]; then
  echo "ERROR: SUPABASE_URL environment variable is not set"
  exit 1
fi

if [ -z "$SUPABASE_ANON_KEY" ]; then
  echo "ERROR: SUPABASE_ANON_KEY environment variable is not set"
  exit 1
fi

if [ -z "$API_BASE_URL" ]; then
  echo "ERROR: API_BASE_URL environment variable is not set"
  exit 1
fi

echo "Environment variables detected:"
echo "  - SUPABASE_URL: ${SUPABASE_URL:0:30}..."
echo "  - SUPABASE_ANON_KEY: ${SUPABASE_ANON_KEY:0:20}..."
echo "  - API_BASE_URL: $API_BASE_URL"

# Optional: SENTRY_DSN for production error tracking
SENTRY_FLAG=""
if [ -n "$SENTRY_DSN" ]; then
  echo "  - SENTRY_DSN: ${SENTRY_DSN:0:30}..."
  SENTRY_FLAG="--dart-define=SENTRY_DSN=$SENTRY_DSN"
fi

echo ""
echo "Running Flutter build web..."

# Build Flutter web with environment variables
flutter build web --release \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
  --dart-define=API_BASE_URL="$API_BASE_URL" \
  $SENTRY_FLAG

# Check if build was successful
if [ $? -eq 0 ]; then
  echo ""
  echo "========================================="
  echo "Build completed successfully!"
  echo "Output directory: build/web"
  echo "========================================="
else
  echo ""
  echo "========================================="
  echo "Build failed!"
  echo "========================================="
  exit 1
fi
