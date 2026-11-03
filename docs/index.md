# Backstage Dockerized

A dockerized Backstage instance for learning and experimentation.

## Overview

This project provides a fully containerized Backstage IDP (Internal Developer Portal) setup with:

- PostgreSQL database
- GitHub integration
- TechDocs support
- Software templates

## Getting Started

### Prerequisites

- Docker Desktop
- GitHub account
- GitHub Personal Access Token

### Running Locally

```bash
# Build and start
docker compose up -d

# Access Backstage
open http://localhost:7007
```

### Configuration

1. Create a `.env` file with your GitHub token:
   ```
   GITHUB_TOKEN=your_token_here
   ```

2. Rebuild and restart:
   ```bash
   docker compose down
   docker build -t backstage:latest .
   docker compose up -d
   ```

## Features

| Feature | Status |
|---------|--------|
| GitHub Integration | ✅ |
| Software Catalog | ✅ |
| TechDocs | ✅ |
| Software Templates | ✅ |
| PostgreSQL Database | ✅ |

## Project Structure

```
backstage-lab/
├── packages/
│   ├── app/          # Frontend application
│   └── backend/      # Backend service
├── examples/         # Sample entities and templates
├── docs/             # Documentation (this file)
├── app-config.yaml   # Main configuration
└── docker-compose.yml
```

## License

MIT
