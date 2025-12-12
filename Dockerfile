# Dockerfile for Flutter Web (Pre-built)
# Uses pre-built Flutter web files from build/web directory

FROM node:18-alpine

WORKDIR /app

# Copy pre-built Flutter web files
COPY build/web /app/build/web

# Copy server and dependencies
COPY server.js package.json ./

# Install Node.js dependencies
RUN npm install --production

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Start the server
CMD ["node", "server.js"]
