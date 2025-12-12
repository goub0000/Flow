# Multi-stage Dockerfile for Flutter Web
# Stage 1: Build Flutter web app
FROM debian:latest AS build-env

# Install Flutter dependencies
RUN apt-get update && \
    apt-get install -y curl git wget unzip gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 && \
    apt-get clean

# Clone Flutter repository
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set Flutter environment variables
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable Flutter web
RUN flutter channel stable && \
    flutter upgrade && \
    flutter config --enable-web

# Create app directory
WORKDIR /app

# Copy source code
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# Build arguments for environment variables
ARG SUPABASE_URL
ARG SUPABASE_ANON_KEY
ARG API_BASE_URL

# Build Flutter web app with environment variables
RUN flutter build web --release \
    --dart-define=SUPABASE_URL=${SUPABASE_URL} \
    --dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY} \
    --dart-define=API_BASE_URL=${API_BASE_URL}

# Stage 2: Serve the app with Node.js
FROM node:18-alpine

WORKDIR /app

# Copy built Flutter web files from build stage
COPY --from=build-env /app/build/web /app/build/web

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
