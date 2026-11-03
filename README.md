# Backstage IDP Lab

A dockerized Backstage Internal Developer Portal for learning and experimentation.

## What is Backstage?

Backstage is an open-source platform for building developer portals. It provides:
- **Software Catalog**: Track all your software (services, APIs, websites, resources)
- **Software Templates**: Scaffold new projects with standardized templates
- **TechDocs**: Documentation-as-code using Markdown
- **Plugin Ecosystem**: Extend with 100+ community plugins

## Why This Lab?

This lab provides a fully self-hosted Backstage instance without external dependencies:
- No GitHub OAuth required (uses guest authentication)
- No external database required (uses PostgreSQL in Docker)
- Single command to start everything

## Project Structure

```
backstage-lab/
├── packages/
│   ├── app/                    # Frontend React application
│   │   └── src/
│   │       └── modules/        # Custom UI modules
│   └── backend/                # Backend Node.js application
│       └── src/
│           └── index.ts        # Backend entry point
├── examples/
│   ├── entities.yaml           # Sample catalog entities
│   ├── org.yaml                # Sample organization (users/groups)
│   └── template/               # Software templates
├── plugins/                    # Custom plugins directory
├── app-config.yaml             # Main configuration
├── app-config.production.yaml  # Production overrides
├── docker-compose.yml          # Docker Compose setup
└── Dockerfile                  # Production image
```

## Quick Start

### Prerequisites
- Docker Desktop installed and running
- PowerShell terminal

### Start Backstage

```powershell
cd C:\Users\User\Documents\port\backstage-lab

# Start PostgreSQL + Backstage
docker compose up -d

# Wait for services to be healthy (30-60 seconds)
docker compose ps

# Open browser
start http://localhost:7007
```

### Stop Backstage

```powershell
docker compose down
```

### Stop and Remove All Data

```powershell
docker compose down -v
```

## Architecture Flow

```
┌─────────────────────────────────────────────────────────────┐
│                     Browser (localhost:7007)                 │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                  Backstage Container                         │
│  ┌─────────────────┐    ┌─────────────────────────────┐    │
│  │  Frontend (App) │◄──►│  Backend (Node.js)          │    │
│  │  React SPA      │    │  - REST API                 │    │
│  │  Port 7007      │    │  - Auth (Guest Provider)    │    │
│  │                 │    │  - Catalog API              │    │
│  │                 │    │  - Scaffolder API           │    │
│  └─────────────────┘    └──────────┬──────────────────┘    │
└─────────────────────────────────────┼───────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────┐
│                 PostgreSQL Container                          │
│  - Database: backstage                                       │
│  - Tables: entities, locations, relations, sessions, etc.   │
│  - Port: 5432 (internal only)                                │
└─────────────────────────────────────────────────────────────┘
```

## Issues Fixed During Setup

### Issue 1: Native Package Compilation Failed

**Problem**: Docker build failed with errors:
```
better-sqlite3@npm:12.11.1 couldn't be built successfully (exit code 1)
cpu-features@npm:0.0.10 couldn't be built successfully (exit code 1)
```

**Root Cause**: Native packages require C++ compilation tools (python3, make, g++) missing from `node:18-bookworm-slim` image.

**Fix**: Skip native package builds by setting environment variable:
```dockerfile
ENV YARN_ENABLE_SCRIPTS=false
RUN yarn workspaces focus --all --production
```

### Issue 2: Node.js Compatibility Error

**Problem**: Backend crashed with:
```
TypeError: options.pluginIds.toSorted is not a function
```

**Root Cause**: `toSorted()` was added in Node.js 20+. Backstage requires Node 20+.

**Fix**: Changed Dockerfile to use `node:20-bookworm-slim` instead of `node:18-bookworm-slim`.

### Issue 3: Database Tables Not Created

**Problem**: Backend started successfully but database had no tables. Migrations weren't running.

**Root Cause**: 
1. Environment variables in config (`${POSTGRES_HOST}`) weren't being expanded
2. Knex migrations weren't triggered automatically

**Fix**: 
1. Hardcoded database connection values in `app-config.production.yaml`
2. Ran migrations manually using a script that executes `knex.migrate.latest()` for each plugin

### Issue 4: Guest Auth Forbidden

**Problem**: `/api/auth/guest/refresh` returned 403 Forbidden:
```json
{"error":{"message":"The guest provider cannot be used outside of a development environment unless 'auth.providers.guest.dangerouslyAllowOutsideDevelopment' is enabled"}}
```

**Root Cause**: Guest authentication is disabled by default in production (NODE_ENV=production).

**Fix**: Added to `app-config.production.yaml`:
```yaml
auth:
  providers:
    guest:
      dangerouslyAllowOutsideDevelopment: true
```

## Configuration

### app-config.yaml
Base configuration with:
- App title and baseUrl
- Backend listen port (7007)
- Catalog locations (example entities)
- Guest auth provider

### app-config.production.yaml
Production overrides:
- PostgreSQL database connection
- Backend auth secret for service-to-service auth
- Guest auth enabled for production

## Database Migrations

If you need to run migrations manually (first-time setup):

```powershell
# Create migration script and run
docker cp run-migrations.js backstage:/app/
docker exec backstage node /app/run-migrations.js
```

## Customization

### Add Catalog Entities

1. Edit `examples/entities.yaml` to add your services
2. Or register existing components via UI: Catalog → Register Existing Component

### Add Software Templates

1. Create template in `examples/template/`
2. Add location to `app-config.yaml`

### Add Plugins

1. Install plugin: `yarn add --cwd packages/backend @backstage/plugin-xyz-backend`
2. Add to `packages/backend/src/index.ts`: `backend.add(import('@backstage/plugin-xyz-backend'))`
3. Rebuild Docker image: `docker build -t backstage:latest .`

## Troubleshooting

### Container Not Starting

```powershell
# Check logs
docker logs backstage

# Check if PostgreSQL is healthy
docker logs backstage-postgres
```

### 401 Unauthorized Errors

1. Clear browser cookies/cache
2. Hard refresh: Ctrl+Shift+R
3. Check auth config: `docker exec backstage cat /app/app-config.production.yaml`

### Database Connection Issues

```powershell
# Test connection
docker exec backstage-postgres psql -U backstage -d backstage -c "\dt"
```

### Rebuild Everything

```powershell
# Stop and remove all containers/volumes
docker compose down -v

# Rebuild image
docker build --no-cache -t backstage:latest .

# Start fresh
docker compose up -d --wait
```

## Useful Commands

```powershell
# View logs
docker compose logs -f backstage

# Check container status
docker compose ps

# Execute command in container
docker exec -it backstage sh

# Check database tables
docker exec backstage-postgres psql -U backstage -d backstage -c "\dt"
```

## References

- [Backstage Documentation](https://backstage.io/docs)
- [Backstage Getting Started](https://backstage.io/docs/getting-started/)
- [Software Catalog](https://backstage.io/docs/features/software-catalog/)
- [Software Templates](https://backstage.io/docs/features/software-templates/)
- [TechDocs](https://backstage.io/docs/features/techdocs/)
