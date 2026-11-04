# Production Dockerfile - Node 20 for toSorted support
# Build: yarn build:backend
# Docker: docker build -t backstage:latest .

FROM node:20-bookworm-slim

# Install Python and mkdocs for TechDocs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir --break-system-packages \
    mkdocs \
    mkdocs-material \
    mkdocs-techdocs-core

USER node
WORKDIR /app

ENV NODE_ENV=production

# Copy pre-built artifacts
COPY --chown=node:node packages/backend/dist/skeleton.tar.gz ./
RUN tar xzf skeleton.tar.gz && rm skeleton.tar.gz

COPY --chown=node:node packages/backend/dist/bundle.tar.gz ./
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz

# Copy Yarn files
COPY --chown=node:node .yarn ./.yarn
COPY --chown=node:node .yarnrc.yml ./
COPY --chown=node:node yarn.lock package.json backstage.json ./

# Install production dependencies without running build scripts
# This skips native package compilation (better-sqlite3, cpu-features)
ENV YARN_ENABLE_SCRIPTS=false
RUN yarn workspaces focus --all --production

# Copy config
COPY --chown=node:node app-config.yaml app-config.production.yaml ./
COPY --chown=node:node examples ./examples

EXPOSE 7007

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD node -e "require('http').get('http://localhost:7007/healthcheck', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
