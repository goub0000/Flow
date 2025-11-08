# Flow EdTech Platform - Frontend Deployment

This repository contains the production build of the Flow EdTech Platform frontend, ready for deployment to Railway.

## What's Inside

- **Flutter Web Build**: Pre-compiled Flutter web application
- **Express Server**: Node.js server to serve static files
- **Production Ready**: Optimized and minified assets

## Deployment to Railway

### Prerequisites
- GitHub account
- Railway account (https://railway.app)

### Steps

1. **Push to GitHub**:
   ```bash
   cd "C:\Flow_App (1)\Flow\build\web"
   git add .
   git commit -m "Initial frontend deployment"
   git branch -M main
   git remote add origin YOUR_GITHUB_REPO_URL
   git push -u origin main
   ```

2. **Deploy to Railway**:
   - Go to https://railway.app
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Select your repository
   - Railway will automatically detect the Node.js project

3. **Environment Variables** (if needed):
   - No environment variables required for basic deployment
   - Backend API URL is already configured in the Flutter app

4. **Verify Deployment**:
   - Railway will provide a public URL
   - Access the URL to verify the frontend is working
   - Test login and other features

## Backend Integration

The frontend is configured to connect to:
- Backend API: https://web-production-bcafe.up.railway.app

### Update Backend CORS

After deployment, you'll need to update the backend CORS settings to allow your new Railway frontend URL:

1. Go to your Railway backend project
2. Add the new frontend URL to the CORS allowed origins
3. Redeploy the backend

## Local Development

To run this build locally:

```bash
npm install
npm start
```

The app will be available at http://localhost:3000

## Updating the Build

When you make changes to the Flutter app:

1. Build the Flutter app:
   ```bash
   cd "C:\Flow_App (1)\Flow"
   flutter build web --release
   ```

2. Commit and push changes:
   ```bash
   cd build/web
   git add .
   git commit -m "Update frontend build"
   git push
   ```

3. Railway will automatically redeploy

## Technical Details

- **Framework**: Flutter Web
- **Server**: Express.js (Node.js)
- **Node Version**: >=16.x
- **Build Mode**: Release (optimized)
- **Routing**: Client-side routing with fallback to index.html

## Support

For issues or questions, refer to the main Flow EdTech Platform repository.
