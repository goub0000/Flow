# =============================================================================
# Multi-stage Dockerfile for Flow EdTech Flutter Web
# Stage 1: Build Flutter web app from source
# Stage 2: Serve with Node.js Express
# =============================================================================

# ---------------------------------------------------------------------------
# Stage 1: Flutter Build
# ---------------------------------------------------------------------------
FROM debian:bookworm-slim AS build

# Install dependencies for Flutter
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git unzip xz-utils ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter SDK (stable channel, matching local dev environment)
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"
RUN git clone --depth 1 --branch 3.35.6 https://github.com/flutter/flutter.git ${FLUTTER_HOME} \
    && flutter precache --web \
    && flutter doctor -v

WORKDIR /app

# Copy dependency files first for better layer caching
COPY pubspec.yaml pubspec.lock ./

# Get Flutter dependencies
RUN flutter pub get

# Copy the rest of the source code
COPY lib/ lib/
COPY assets/ assets/
COPY web/ web/
COPY analysis_options.yaml ./

# Build args - Railway injects all service variables as Docker build args
ARG SUPABASE_URL
ARG SUPABASE_ANON_KEY
ARG API_BASE_URL

# Verify build args were received (lengths only — no secrets in logs)
RUN echo "Build-arg check: SUPABASE_URL=${#SUPABASE_URL} chars, ANON_KEY=${#SUPABASE_ANON_KEY} chars, API_BASE_URL=${#API_BASE_URL} chars"

# Build Flutter web with credentials injected at build time
RUN flutter build web --release \
  --dart-define="SUPABASE_URL=${SUPABASE_URL}" \
  --dart-define="SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}" \
  --dart-define="API_BASE_URL=${API_BASE_URL}"

# ---------------------------------------------------------------------------
# Stage 2: Serve with Node.js
# ---------------------------------------------------------------------------
FROM node:18-alpine

WORKDIR /app

# Copy the built Flutter web output from stage 1
COPY --from=build /app/build/web /app/build/web

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
