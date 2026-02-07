# Flow EdTech Platform — Project Reference

## Overview

Flow is an African EdTech platform. Flutter web frontend + Python/FastAPI backend + Supabase (PostgreSQL).

- **Repo**: github.com/goub0000/Flow (public)
- **Frontend**: https://web-production-bcafe.up.railway.app
- **Backend API**: https://web-production-51e34.up.railway.app
- **Supabase**: project ref `wmuarotbdjhqbyjyslqg` (East US Ohio)

## Architecture

```
Flow/                          ← Git root (github.com/goub0000/Flow)
├── lib/                       ← Flutter app (Dart, Riverpod 2.x, feature-first)
│   ├── core/                  ← Shared: api/, models/, error/, services/
│   └── features/              ← admin/, authentication/, counselor/, parent/, shared/, student/
├── recommendation_service/    ← Python backend (FastAPI + Uvicorn)
│   ├── app/main.py            ← 34 route modules, CORS for both Railway domains
│   └── railway.json           ← Nixpacks builder
├── supabase/                  ← Supabase CLI managed
│   ├── config.toml            ← project_id = "Flow"
│   └── migrations/            ← Baseline: 73 tables, future migrations go here
├── Dockerfile                 ← Multi-stage: Flutter build → Node.js serve
├── .dockerignore
├── server.js                  ← Express SPA server (serves build/web/)
├── railway.json               ← Dockerfile builder for frontend
└── build_production.bat       ← Local build script (reads .env.production)
```

## Railway Services (Two Separate Projects)

### Frontend — "charming-emotion"
- **Project ID**: `d53a8f07-e2a7-4ffe-b2bf-ed5e70780042`
- **Service ID**: `da96cca7-75ae-40ce-a080-1d85a57f20b3`
- **Builder**: Dockerfile (multi-stage)
- **Domain**: web-production-bcafe.up.railway.app
- **Env vars on Railway**: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `API_BASE_URL`, `GEMINI_API_KEY`
- Credentials reach the Flutter app via runtime injection (`server.js` → `/env-config.js` → `window.FLOW_CONFIG`), NOT Docker build args

### Backend — "spirited-abundance"
- **Project ID**: `53fccafe-1dfc-419f-8907-8e7766d28738`
- **Service ID**: `5744f039-e05c-4382-a918-c6a03a0e3b07`
- **Builder**: Nixpacks (Python)
- **Start**: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
- **Domain**: web-production-51e34.up.railway.app

## Build & Deploy Pipeline

### How the frontend builds (on Railway)
1. Push to `main` triggers Railway
2. Railway runs the multi-stage `Dockerfile`:
   - **Stage 1** (debian:bookworm-slim): Installs Flutter 3.35.6, runs `flutter build web --release` (no credentials at build time)
   - **Stage 2** (node:18-alpine): Copies `build/web/` output, runs `node server.js` (Express with SPA fallback)
3. Health check at `/health`
4. Container starts → `server.js` reads Railway env vars at runtime

### How credentials reach the Flutter app (runtime injection)
Credentials are NOT baked in at build time. They are injected at runtime:

1. `server.js` exposes a `/env-config.js` endpoint that reads `process.env` and returns a JS file setting `window.FLOW_CONFIG`
2. `web/index.html` loads `/env-config.js` synchronously before `flutter_bootstrap.js`
3. `lib/core/api/api_config.dart` reads `window.FLOW_CONFIG` via `dart:js` (`js.context['FLOW_CONFIG']`) as a fallback when `String.fromEnvironment()` returns empty
4. Resolution order: compile-time `--dart-define` (local dev) → runtime `window.FLOW_CONFIG` (production)

**Why not Docker build args?** Railway's build arg injection is unreliable — during testing, only `SUPABASE_URL` was passed while `SUPABASE_ANON_KEY` and `API_BASE_URL` arrived empty. Runtime injection via `server.js` is deterministic.

**Known Railway quirk:** Some env var names were stored with accidental whitespace (e.g. ` SUPABASE_ANON_KEY` with a leading space). The `env()` helper in `server.js` trims keys when resolving. If adding new Railway variables, verify with `railway variables --json` that names have no stray spaces.

### Local development build
```bash
# Option 1: Use the batch script (reads .env.production)
build_production.bat

# Option 2: Manual
flutter run -d chrome \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=... \
  --dart-define=API_BASE_URL=http://localhost:8000
```
Local builds use `--dart-define` which sets compile-time constants. The runtime fallback is only needed on Railway.

## Git Strategy

- **Branching**: Git Flow — `develop` (default branch, day-to-day), `main` (production releases)
- **Deploy trigger**: Push/merge to `main` triggers Railway deployment
- `build/web/` is gitignored — all builds happen inside Docker on Railway
- No branch protection rules currently set

## Supabase

- **CLI linked**: `supabase link --project-ref wmuarotbdjhqbyjyslqg`
- **Migrations**: `supabase/migrations/` — baseline schema pulled with `supabase db pull`
- **New migrations**: `supabase migration new <name>` then `supabase db push`
- **73 tables** including: universities, programs, users, courses, enrollments, applications, etc.
- **Database version**: PostgreSQL 17

## Tech Stack Summary

| Layer       | Technology                                    |
|-------------|-----------------------------------------------|
| Frontend    | Flutter 3.35.6, Dart 3.9.2, Riverpod 2.x     |
| Backend     | Python, FastAPI, Uvicorn                       |
| Database    | Supabase (PostgreSQL 17)                       |
| Hosting     | Railway (2 services)                           |
| Auth        | Supabase Auth                                  |
| Storage     | Supabase Storage                               |
| Navigation  | go_router 17.x                                 |
| State       | flutter_riverpod + riverpod_annotation          |
| Serialization | freezed + json_serializable                  |

## Critical Files

- `lib/core/api/api_config.dart` — API endpoints + credential resolution (compile-time → runtime fallback via `dart:js`)
- `server.js` — Express SPA server + `/env-config.js` runtime config endpoint + `env()` helper for whitespace-tolerant env var lookup
- `web/index.html` — Loads `/env-config.js` synchronously before Flutter bootstrap
- `Dockerfile` — Multi-stage build (Flutter compile → Node.js serve). No build args needed.
- `railway.json` — Frontend Railway config (Dockerfile builder)
- `recommendation_service/railway.json` — Backend Railway config (Nixpacks)
- `recommendation_service/app/main.py` — FastAPI entry point
- `.env.production` — Local-only secrets (gitignored)
- `recommendation_service/.env` — Backend secrets including service_role key (gitignored)

## Rules

- NEVER commit `.env` files, Supabase service_role keys, or any secrets
- NEVER remove the `/env-config.js` route or `env()` helper from `server.js` — production depends on runtime credential injection
- NEVER remove the `<script src="/env-config.js"></script>` tag from `web/index.html` — it must load before Flutter boots
- Always develop on `develop`, merge to `main` only for production releases
- `build/web/` is gitignored; builds happen in Docker on Railway
- Run `supabase migration new <name>` for schema changes, never edit production DB directly
- When adding Railway env vars, verify with `railway variables --json` that names have no whitespace
