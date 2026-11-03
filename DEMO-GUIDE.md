# Backstage Portal Demo Guide

This guide walks you through using your Backstage IDP portal with hands-on examples.

---

## Access the Portal

1. Open browser: **http://localhost:7007**
2. You're automatically logged in as **Guest** (development mode)

---

## Demo 1: Explore the Software Catalog

The Software Catalog is the heart of Backstage - it tracks all your software components.

### Step 1: View All Components

1. Click **Catalog** in the left sidebar
2. You'll see the catalog view with filters on the left
3. By default, it shows **All** entity types

**What you'll see:**
- **Components**: Services, websites, applications
- **APIs**: API definitions (REST, GraphQL, gRPC)
- **Systems**: Logical groups of components
- **Resources**: Infrastructure, databases, etc.
- **Templates**: Software scaffolding templates

### Step 2: Filter by Entity Type

1. Click **Component** in the left filter panel
2. You should see **example-website**

### Step 3: View Entity Details

1. Click on **example-website**
2. Explore the tabs:
   - **Overview**: Description, owner, lifecycle, type
   - **API**: APIs provided by this component
   - **Dependencies**: What this component depends on
   - **Diagram**: Visual dependency graph

---

## Demo 2: Explore API Catalog

1. Click **APIs** in the left sidebar
2. You'll see **example-grpc-api**
3. Click on it to view:
   - API type (gRPC)
   - Definition (proto file)
   - Owner (guests group)

---

## Demo 3: View Organization Structure

1. Click **Catalog** → Filter by **User** or **Group**
2. You'll see:
   - **User**: guest
   - **Group**: guests

This shows how Backstage can model your organization's teams.

---

## Demo 4: Use the Catalog Graph

The Catalog Graph shows relationships between entities visually.

1. Click **Catalog Graph** in the left sidebar
2. You'll see a visual graph showing:
   - **System**: examples (center)
   - **Component**: example-website (connected to system)
   - **API**: example-grpc-api (connected to component)
3. Hover over nodes to see connections
4. Click nodes to navigate to entity details

---

## Demo 5: Create a New Component (Software Template)

Software Templates let you scaffold new projects from predefined templates.

### Step 1: Access Templates

1. Click **Create** in the left sidebar
2. You'll see available templates
3. Click **Register Existing Component** if you have existing code

### Step 2: Use a Template

Currently you have the **example-nodejs-template**. To use it:

1. Click on the template
2. Fill in the form:
   - **Name**: my-new-service
   - **Description**: My first Backstage scaffolded service
   - **Owner**: guests
3. Click **Next** → **Create**

**Note**: This template creates a repository in GitHub. You need to configure GitHub integration for this to work.

---

## Demo 6: Explore TechDocs

TechDocs provides documentation-as-code using Markdown.

1. Click **Docs** in the left sidebar
2. Currently empty - you need to add documentation

**To add docs for a component:**
1. Add to your component's `catalog-info.yaml`:
   ```yaml
   metadata:
     annotations:
       backstage.io/techdocs-ref: dir:.
   ```
2. Create a `docs/index.md` file in your repository

---

## Demo 7: Search

Backstage has a powerful search across all entities.

1. Click the **search icon** (magnifying glass) in the top right
2. Type "example"
3. Results will show matching components, APIs, etc.

---

## Demo 8: Register Your Own Component

Let's say you have an existing service you want to add to the catalog.

### Step 1: Prepare Your Repository

Create a `catalog-info.yaml` in your repo root:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: my-awesome-service
  description: My awesome microservice
  annotations:
    github.com/project-slug: myorg/my-awesome-service
spec:
  type: service
  lifecycle: production
  owner: guests
  system: examples
```

### Step 2: Register in Backstage

1. Click **Catalog** → **Register Existing Component**
2. Enter the URL to your `catalog-info.yaml`
3. Click **Analyze** → **Import**

---

## Current Catalog Entities

Your lab comes pre-loaded with these entities:

### System: examples
```yaml
kind: System
name: examples
description: Example system containing demo components
owner: guests
```

### Component: example-website
```yaml
kind: Component
name: example-website
type: website
lifecycle: experimental
owner: guests
system: examples
providesApis: [example-grpc-api]
```

### API: example-grpc-api
```yaml
kind: API
name: example-grpc-api
type: grpc
lifecycle: experimental
owner: guests
system: examples
```

### User: guest
```yaml
kind: User
name: guest
profile:
  displayName: Guest User
memberOf: [guests]
```

### Group: guests
```yaml
kind: Group
name: guests
description: Guests team
type: team
members: [guest]
```

---

## Next Steps

### 1. Add Your Real Services

Edit `examples/entities.yaml` or create new files:

```yaml
# Add a new microservice
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: user-service
  description: User management service
  tags:
    - java
    - spring-boot
spec:
  type: service
  lifecycle: production
  owner: team-backend
  system: core-services
  providesApis:
    - user-api
```

### 2. Add a System

Group related components:

```yaml
apiVersion: backstage.io/v1alpha1
kind: System
metadata:
  name: core-services
  description: Core backend services
spec:
  owner: team-backend
```

### 3. Add an API

Document your APIs:

```yaml
apiVersion: backstage.io/v1alpha1
kind: API
metadata:
  name: user-api
  description: User management REST API
spec:
  type: openapi
  lifecycle: production
  owner: team-backend
  system: core-services
  definition:
    $text: ./openapi.yaml
```

### 4. Customize the UI

Edit `packages/app/src/App.tsx` to:
- Change logo and branding
- Add custom pages
- Configure navigation

### 5. Add Plugins

Popular plugins to explore:
- **Kubernetes**: View K8s resources
- **GitHub**: See repo info, PRs, issues
- **Jenkins**: View build status
- **PagerDuty**: On-call information
- **Datadog**: Metrics and dashboards

---

## Useful URLs

| Endpoint | Description |
|----------|-------------|
| http://localhost:7007 | Main UI |
| http://localhost:7007/api/catalog/entities | Catalog API |
| http://localhost:7007/healthcheck | Health check |

---

## Troubleshooting

### Empty Catalog?

If you see no entities:

1. Wait 30-60 seconds for catalog to process
2. Hard refresh browser: **Ctrl+Shift+R**
3. Check logs: `docker logs backstage`

### 401 Unauthorized?

1. Clear browser cookies for localhost
2. Hard refresh: **Ctrl+Shift+R**

### Want to Start Fresh?

```powershell
# Remove all data
docker compose down -v

# Restart
docker compose up -d

# Wait 1 minute for startup
```
