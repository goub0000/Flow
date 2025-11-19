# Flutter Web Build Instructions

## Problem
The production app shows: `ERROR: SUPABASE_URL not configured`

This happens because the Flutter web build was compiled without the required credentials.

## Solution: Rebuild with Credentials

### Option 1: Quick Rebuild (Windows)

1. **Update credentials** in `.env.production`:
   ```bash
   # Edit the file and verify your Supabase URL and keys
   notepad .env.production
   ```

2. **Run the build script**:
   ```bash
   build_production.bat
   ```

3. **Test locally** (optional):
   ```bash
   cd build/web
   python -m http.server 8080
   # Open http://localhost:8080 in browser
   ```

4. **Deploy to Railway**:
   ```bash
   git add build/web
   git commit -m "Rebuild Flutter web with production credentials"
   git push
   ```

### Option 2: Manual Build (Any OS)

1. **Set environment variables** (PowerShell):
   ```powershell
   $env:SUPABASE_URL="https://wmuarotbdjhqbyjyslqg.supabase.co"
   $env:SUPABASE_ANON_KEY="your_anon_key_here"
   $env:API_BASE_URL="https://your-api.railway.app"
   ```

2. **Run Flutter build**:
   ```bash
   flutter clean
   flutter pub get
   flutter build web --release --dart-define=SUPABASE_URL=$env:SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$env:SUPABASE_ANON_KEY --dart-define=API_BASE_URL=$env:API_BASE_URL
   ```

### Option 3: Using build.sh (Linux/Mac/Git Bash)

1. **Set environment variables**:
   ```bash
   export SUPABASE_URL="https://wmuarotbdjhqbyjyslqg.supabase.co"
   export SUPABASE_ANON_KEY="your_anon_key_here"
   export API_BASE_URL="https://your-api.railway.app"
   ```

2. **Run build script**:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

## Getting Your Supabase Credentials

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: `wmuarotbdjhqbyjyslqg`
3. Go to **Settings** → **API**
4. Copy:
   - **Project URL** → `SUPABASE_URL`
   - **anon/public key** → `SUPABASE_ANON_KEY`

## Getting Your Railway API URL

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Find your recommendation service project
3. Go to **Settings** → **Domains**
4. Copy the domain (e.g., `https://web-production-xyz.up.railway.app`)
5. Use it as `API_BASE_URL`

## Verifying the Build

After rebuilding, check that credentials are embedded:

```bash
# Search for Supabase URL in compiled JavaScript
grep -o "wmuarotbdjhqbyjyslqg" build/web/main.dart.js

# Should return matches if credentials are embedded
```

## Troubleshooting

### Error: "SUPABASE_URL not configured"
- **Cause**: Build was done without --dart-define flags
- **Fix**: Rebuild using one of the methods above

### Error: "Cannot connect to Supabase"
- **Cause**: Incorrect Supabase URL or key
- **Fix**: Double-check credentials in Supabase dashboard

### Error: "CORS error" when calling API
- **Cause**: Recommendation service CORS not configured
- **Fix**: See IMPLEMENTATION_PLAN_FIXES.md → Section 1 (CORS Configuration)

## Railway Auto-Deploy Configuration

To avoid manual deployments, set Railway environment variables:

1. Go to Railway project → **Variables**
2. Add these variables:
   ```
   SUPABASE_URL=https://wmuarotbdjhqbyjyslqg.supabase.co
   SUPABASE_ANON_KEY=your_key_here
   API_BASE_URL=https://your-api.railway.app
   ```
3. Create `railway.toml`:
   ```toml
   [build]
   builder = "NIXPACKS"
   buildCommand = "flutter clean && flutter pub get && flutter build web --release --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY --dart-define=API_BASE_URL=$API_BASE_URL"

   [deploy]
   startCommand = "node server.js"
   ```

## Next Steps

After successful rebuild:
1. ✅ Test the app locally
2. ✅ Deploy to Railway
3. ✅ Fix CORS issues (see IMPLEMENTATION_PLAN_FIXES.md)
4. ✅ Configure recommendation service database
