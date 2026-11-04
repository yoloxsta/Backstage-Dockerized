# ${{ values.name }}

${{ values.description }}

## Architecture

This service follows a standard microservices architecture with:

- Source code in ${{ values.language }}
- CI/CD via GitHub Actions
- Containerized with Docker

## Development

See [README.md](../README.md) for setup instructions.

## CI/CD Pipeline

The pipeline includes:

1. **Build**: Compile and test the application
2. **Docker**: Build and push container image
3. **Deploy**: Deploy to Kubernetes cluster

## Monitoring

Check the CI/CD tab in Backstage for build status and deployment history.
