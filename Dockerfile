# Multi-stage build for Flutter web app

# Stage 1: Build Flutter web app
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Set working directory
WORKDIR /app

# Copy Flutter project files
COPY pubspec.yaml pubspec.lock ./
COPY lib ./lib
COPY web ./web
COPY assets ./assets

# Get Flutter dependencies
RUN flutter pub get

# Build web app with environment variables from Railway
ARG SUPABASE_URL
ARG SUPABASE_ANON_KEY
ARG API_BASE_URL

RUN flutter build web --release \
    --dart-define=SUPABASE_URL=${SUPABASE_URL} \
    --dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY} \
    --dart-define=API_BASE_URL=${API_BASE_URL}

# Stage 2: Serve with Node.js
FROM node:18-alpine

WORKDIR /app

# Copy built web app from build stage
COPY --from=build /app/build/web ./build/web

# Copy server files
COPY package.json package-lock.json* ./
COPY server.js ./

# Install production dependencies
RUN npm install --production

# Expose port (Railway uses PORT env var)
EXPOSE 8080

# Start server
CMD ["node", "server.js"]
