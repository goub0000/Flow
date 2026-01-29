const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Resolve env var by name, tolerating leading/trailing whitespace in key names.
// Railway stored some variables with accidental spaces in their names
// (e.g. " SUPABASE_ANON_KEY" instead of "SUPABASE_ANON_KEY").
function env(name) {
  if (process.env[name]) return process.env[name];
  for (const key of Object.keys(process.env)) {
    if (key.trim() === name) return process.env[key];
  }
  return '';
}

// Health check endpoint for Railway
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Runtime config: expose env vars to Flutter web app as a JS global.
// Loaded synchronously by index.html before flutter_bootstrap.js.
app.get('/env-config.js', (req, res) => {
  res.setHeader('Content-Type', 'application/javascript');
  res.setHeader('Cache-Control', 'no-store');
  res.send(
    `window.FLOW_CONFIG={` +
    `SUPABASE_URL:${JSON.stringify(env('SUPABASE_URL'))},` +
    `SUPABASE_ANON_KEY:${JSON.stringify(env('SUPABASE_ANON_KEY'))},` +
    `API_BASE_URL:${JSON.stringify(env('API_BASE_URL'))}` +
    `};`
  );
});

// Serve static files from Flutter web build with explicit options
app.use(express.static(path.join(__dirname, 'build', 'web'), {
  setHeaders: (res, filePath) => {
    // Set proper content types for common file extensions
    if (filePath.endsWith('.json')) {
      res.setHeader('Content-Type', 'application/json');
    }
  }
}));

// Only serve index.html for navigation routes (not files with extensions)
app.get('*', (req, res, next) => {
  // If the request has a file extension, let static middleware handle it
  if (path.extname(req.path)) {
    return next();
  }
  // Otherwise, serve index.html for client-side routing
  res.sendFile(path.join(__dirname, 'build', 'web', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Flow EdTech Web Server running on port ${PORT}`);
});
