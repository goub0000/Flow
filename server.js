const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from Flutter web build
app.use(express.static(path.join(__dirname, 'build', 'web')));

// Handle all routes by serving index.html (for Flutter routing)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build', 'web', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Flow EdTech Web Server running on port ${PORT}`);
});
