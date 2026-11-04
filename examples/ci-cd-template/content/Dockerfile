# Dockerfile for ${{ values.name }}
FROM ${{ values.language == 'nodejs' && 'node:20-alpine' || values.language == 'python' && 'python:3.11-slim' || 'golang:1.21-alpine' }}

WORKDIR /app

${{ values.language == 'nodejs' && '# Node.js setup
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]' || '' }}

${{ values.language == 'python' && '# Python setup
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["python", "app.py"]' || '' }}

${{ values.language == 'go' && '# Go setup
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o main .
EXPOSE 8080
CMD ["./main"]' || '' }}
