# Flow App - Deployment Configuration Guide

## Overview

This guide explains how to configure and deploy the Flow EdTech application with proper environment configuration, API keys, and crash reporting.

## Environment Variables

The application uses `--dart-define` flags for environment-specific configuration. This approach:
- ✅ Keeps sensitive data out of source code
- ✅ Allows different configurations per environment
- ✅ Works with CI/CD pipelines
- ✅ Compile-time constants (no runtime overhead)

## Required Configuration

### 1. Supabase Configuration

**Required for:** Database, Authentication, Storage

```bash
--dart-define=SUPABASE_URL=your_supabase_project_url
--dart-define=SUPABASE_ANON_KEY=your_supabase_anon_key
```

**Where to find:**
- Login to [Supabase Dashboard](https://app.supabase.com)
- Go to Project Settings > API
- Copy the Project URL and anon/public key

**Note:** The anon key is safe for client-side use. Never use the service_role key in Flutter.

### 2. Sentry Configuration (Optional but Recommended)

**Required for:** Crash reporting and error monitoring

```bash
--dart-define=SENTRY_DSN=your_sentry_dsn
```

**Where to find:**
- Login to [Sentry Dashboard](https://sentry.io)
- Create a Flutter project (if not exists)
- Go to Settings > Projects > [Your Project] > Client Keys (DSN)
- Copy the DSN URL

**Benefits:**
- Real-time crash reports
- Error tracking in production
- Performance monitoring
- User feedback collection

## Deployment Commands

### Development Build

```bash
# Run with development settings (uses default values from code)
flutter run

# Run with production Supabase but no Sentry
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_key_here
```

### Production Web Build

```bash
# Full production build with all environment variables
flutter build web \
  --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key \
  --dart-define=SENTRY_DSN=https://your_dsn@sentry.io/project_id

# The built files will be in build/web/
```

### Android Production Build

```bash
flutter build apk \
  --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key \
  --dart-define=SENTRY_DSN=https://your_dsn@sentry.io/project_id

# Or for App Bundle (recommended for Play Store)
flutter build appbundle \
  --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key \
  --dart-define=SENTRY_DSN=https://your_dsn@sentry.io/project_id
```

### iOS Production Build

```bash
flutter build ios \
  --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key \
  --dart-define=SENTRY_DSN=https://your_dsn@sentry.io/project_id
```

## CI/CD Configuration

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.2'

      - name: Install dependencies
        run: flutter pub get

      - name: Build web
        env:
          SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}
          SENTRY_DSN: ${{ secrets.SENTRY_DSN }}
        run: |
          flutter build web \
            --release \
            --dart-define=SUPABASE_URL=$SUPABASE_URL \
            --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
            --dart-define=SENTRY_DSN=$SENTRY_DSN

      - name: Deploy to hosting
        # Add your deployment steps here
        run: echo "Deploy build/web/ to your hosting"
```

**Required GitHub Secrets:**
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SENTRY_DSN`

### Railway Deployment

Railway can deploy the web app directly. Add a `railway.toml`:

```toml
[build]
builder = "NIXPACKS"
buildCommand = "flutter build web --release --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY --dart-define=SENTRY_DSN=$SENTRY_DSN"

[deploy]
startCommand = "python -m http.server 8080 --directory build/web"
```

Set environment variables in Railway dashboard:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SENTRY_DSN`

## Environment-Specific Configuration

### Development
- Uses default values from `api_config.dart`
- Logging level: ALL
- Sentry: Disabled (empty DSN)
- API base URL: `http://localhost:8000`

### Staging
- Uses provided Supabase credentials
- Logging level: INFO and above
- Sentry: Enabled with staging DSN
- API base URL: Your staging backend

### Production
- Uses provided Supabase credentials
- Logging level: WARNING and above
- Sentry: Enabled with production DSN
- API base URL: `https://web-production-51e34.up.railway.app`

## Security Best Practices

### ✅ DO:
- Use `--dart-define` for all sensitive configuration
- Store secrets in CI/CD secret management
- Use different Supabase projects for dev/staging/prod
- Enable Sentry error tracking in production
- Rotate API keys periodically
- Use environment-specific Sentry DSNs

### ❌ DON'T:
- Hardcode API keys in source code
- Commit `.env` files to version control
- Use production keys in development
- Share API keys in chat/email
- Use service_role keys in Flutter (backend only!)

## Verification Steps

After deployment, verify:

1. **Supabase Connection:**
   - Open app and try to login/register
   - Check Supabase logs for requests
   - Verify authentication works

2. **Sentry Integration:**
   - Trigger an error in the app
   - Check Sentry dashboard for error report
   - Verify environment is correctly tagged

3. **API Communication:**
   - Test API calls to backend
   - Check network tab in browser DevTools
   - Verify correct base URL is used

## Troubleshooting

### Issue: "Supabase client not initialized"
**Solution:** Ensure `SUPABASE_URL` and `SUPABASE_ANON_KEY` are provided during build.

### Issue: No crash reports in Sentry
**Solution:**
- Check `SENTRY_DSN` is correct
- Verify Sentry project exists
- Check app is running in production mode

### Issue: API calls fail
**Solution:**
- Verify `isProduction` flag in `api_config.dart`
- Check backend is running and accessible
- Verify CORS is configured on backend

## Logging Configuration

The app uses the `logging` package with Sentry integration:

```dart
// In main.dart
Logger.root.level = Level.ALL; // Adjust based on environment
Logger.root.onRecord.listen((record) {
  // Development: Print to console
  debugPrint('[${record.level.name}] ${record.loggerName}: ${record.message}');

  // Production: Sent to Sentry automatically
});
```

**Log Levels:**
- `FINE`: Debug information (dev only)
- `INFO`: General information
- `WARNING`: Warnings that need attention
- `SEVERE`: Errors that need immediate attention

## Monitoring Setup

### Sentry Dashboard
1. Go to Sentry project
2. View real-time errors
3. Set up alerts for critical errors
4. Monitor performance metrics

### Supabase Dashboard
1. Monitor authentication events
2. Check database queries
3. Review storage usage
4. Monitor real-time connections

## Support

For issues with:
- **Deployment:** Check this guide and Railway/hosting docs
- **Supabase:** Visit [Supabase Documentation](https://supabase.com/docs)
- **Sentry:** Visit [Sentry Documentation](https://docs.sentry.io)
- **Flutter:** Visit [Flutter Documentation](https://docs.flutter.dev)
