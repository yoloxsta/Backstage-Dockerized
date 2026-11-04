# ${{ values.name }}

${{ values.description }}

## Overview

This service was generated from the Backstage CI/CD template.

## Tech Stack

- **Language**: ${{ values.language }}
- **CI/CD**: GitHub Actions
- **Containerization**: Docker

## Getting Started

### Prerequisites

${{ values.language == 'nodejs' && '- Node.js 20+
- npm' || '' }}

${{ values.language == 'python' && '- Python 3.11+
- pip' || '' }}

${{ values.language == 'go' && '- Go 1.21+' || '' }}

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_ORG/${{ values.name }}.git
cd ${{ values.name }}

${{ values.language == 'nodejs' && '# Install dependencies
npm install

# Run locally
npm run dev' || '' }}

${{ values.language == 'python' && '# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\\Scripts\\activate

# Install dependencies
pip install -r requirements.txt

# Run locally
python app.py' || '' }}

${{ values.language == 'go' && '# Install dependencies
go mod download

# Run locally
go run .' || '' }}
```

## CI/CD Pipeline

This project includes a GitHub Actions workflow that:

1. Runs tests on every push and PR
2. Builds Docker image on main branch
3. Deploys to Kubernetes (if enabled)

### Required Secrets

| Secret | Description |
|--------|-------------|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_PASSWORD` | Docker Hub password/token |
| `KUBE_CONFIG` | Base64-encoded kubeconfig |

## Docker

```bash
# Build
docker build -t ${{ values.name }}:latest .

# Run
docker run -p 3000:3000 ${{ values.name }}:latest
```

## License

MIT
