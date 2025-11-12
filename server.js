const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

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
