# Simple Dockerfile - installs dependencies and runs
# Build: yarn install && yarn build:backend

FROM node:18-bookworm-slim

USER node
WORKDIR /app

# Copy package files for installation
COPY --chown=node:node package.json yarn.lock backstage.json ./
COPY --chown=node:node .yarn ./.yarn
COPY --chown=node:node .yarnrc.yml ./

# Copy the built backend
COPY --chown=node:node packages/backend/dist ./packages/backend/dist
COPY --chown=node:node packages/backend/package.json ./packages/backend/

# Copy app package (needed for workspace)
COPY --chown=node:node packages/app/package.json ./packages/app/

# Set production mode
ENV NODE_ENV=production

# Install production dependencies
RUN yarn install

# Copy config files
COPY --chown=node:node app-config.yaml app-config.production.yaml ./
COPY --chown=node:node examples ./examples

EXPOSE 7007

CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
