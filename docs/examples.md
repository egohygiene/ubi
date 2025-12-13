# Examples

This page provides practical examples of using UBI in various scenarios.

---

## Basic Usage

### Using UBI as a Devcontainer Base

The simplest way to use UBI is as your devcontainer base image:

```json title=".devcontainer/devcontainer.json"
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "customizations": {
    "vscode": {
      "extensions": [
        "dbaeumer.vscode-eslint"
      ]
    }
  }
}
```

### Using UBI as a Dockerfile Base

You can also extend UBI in your own Dockerfile:

```dockerfile title="Dockerfile"
FROM ghcr.io/egohygiene/ubi:0.1.5

# Install project-specific dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy project files
COPY . .

# Install dependencies
RUN npm install
```

---

## Advanced Examples

### Multi-Stage Build with UBI

Use UBI as a build environment and create a minimal runtime image:

```dockerfile title="Dockerfile"
# Build stage using UBI
FROM ghcr.io/egohygiene/ubi:0.1.5 AS builder

WORKDIR /build
COPY . .
RUN make build

# Runtime stage
FROM debian:bookworm-slim

# Copy artifacts from builder
COPY --from=builder /build/dist /app

ENTRYPOINT ["/app/myapp"]
```

### Using XDG Paths

Leverage UBI's XDG-compliant directory structure:

```bash title="example-script.sh"
#!/bin/bash

# Use XDG environment variables
CONFIG_FILE="${XDG_CONFIG_HOME}/myapp/config.yml"
CACHE_DIR="${XDG_CACHE_HOME}/myapp"
DATA_DIR="${XDG_DATA_HOME}/myapp"

# Create directories if they don't exist
mkdir -p "$(dirname "$CONFIG_FILE")"
mkdir -p "$CACHE_DIR"
mkdir -p "$DATA_DIR"

# Write configuration
cat > "$CONFIG_FILE" <<EOF
app:
  name: MyApp
  cache_dir: $CACHE_DIR
  data_dir: $DATA_DIR
EOF
```

### Custom Environment Variables

Add your own environment variables while preserving UBI's defaults:

```json title=".devcontainer/devcontainer.json"
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "containerEnv": {
    "MY_APP_ENV": "development",
    "MY_APP_DEBUG": "true"
  }
}
```

---

## Project-Specific Examples

### Python Project

```dockerfile title="Dockerfile"
FROM ghcr.io/egohygiene/ubi:0.1.5

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Set Python path to use XDG directories
ENV PYTHONUSERBASE="${XDG_DATA_HOME}/python"
ENV PATH="${PYTHONUSERBASE}/bin:${PATH}"

WORKDIR /workspace
COPY . .
```

### Node.js Project

```dockerfile title="Dockerfile"
FROM ghcr.io/egohygiene/ubi:0.1.5

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Configure npm to use XDG directories
ENV NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
ENV NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
ENV NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"

WORKDIR /workspace
COPY package*.json ./
RUN npm install

COPY . .
```

### Go Project

```dockerfile title="Dockerfile"
FROM ghcr.io/egohygiene/ubi:0.1.5

# Install Go
ARG GO_VERSION=1.22.0
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

# Configure Go to use XDG directories
ENV GOPATH="${XDG_DATA_HOME}/go"
ENV GOCACHE="${XDG_CACHE_HOME}/go-build"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

WORKDIR /workspace
COPY go.* ./
RUN go mod download

COPY . .
RUN go build -o /app/myapp
```

---

## CI/CD Examples

### GitHub Actions

Use UBI in your GitHub Actions workflows:

```yaml title=".github/workflows/ci.yml"
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/egohygiene/ubi:0.1.5
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: |
          make test
```

### Docker Compose

Use UBI with Docker Compose for local development:

```yaml title="docker-compose.yml"
version: '3.8'

services:
  app:
    image: ghcr.io/egohygiene/ubi:0.1.5
    volumes:
      - .:/workspace
      - ubi-cache:/opt/universal/cache
      - ubi-config:/opt/universal/config
    working_dir: /workspace
    command: bash

volumes:
  ubi-cache:
  ubi-config:
```

---

## Testing Examples

### Local Testing

Test your changes with UBI locally:

```bash
# Build your custom image
docker build -f Dockerfile -t myapp:test .

# Run interactively
docker run -it --rm myapp:test bash

# Verify XDG paths
docker run --rm myapp:test bash -c 'echo $XDG_CONFIG_HOME'

# Check directory structure
docker run --rm myapp:test ls -la /opt/universal/
```

### Integration Testing

Test your application with UBI in CI:

```yaml title=".github/workflows/integration.yml"
name: Integration Tests

on: [push, pull_request]

jobs:
  integration:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Build test image
        run: docker build -f Dockerfile -t myapp:test .
      
      - name: Run integration tests
        run: |
          docker run --rm myapp:test make integration-test
```

---

## Best Practices

### Version Pinning

Always pin to a specific version in production:

```dockerfile
# ✅ Good - pinned version
FROM ghcr.io/egohygiene/ubi:0.1.5

# ❌ Avoid - using latest in production
FROM ghcr.io/egohygiene/ubi:latest
```

### Layer Optimization

Optimize your Dockerfile layers:

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.5

# Combine RUN commands to reduce layers
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    package3 \
    && rm -rf /var/lib/apt/lists/*

# Use .dockerignore to exclude unnecessary files
COPY . .
```

### Security

Keep security in mind:

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.5

# Don't run as root
USER vscode

# Use COPY instead of ADD
COPY --chown=vscode:vscode . /workspace

# Clean up sensitive data
RUN rm -rf /tmp/* /var/tmp/*
```

---

## Troubleshooting Examples

### Permission Issues

If you encounter permission issues:

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.5

# Ensure proper ownership
RUN chown -R vscode:vscode /opt/universal/

# Or run as root temporarily
USER root
RUN apt-get update && apt-get install -y mypackage
USER vscode
```

### Missing Dependencies

Install missing dependencies:

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.5

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*
```

---

## Additional Resources

- [Architecture Documentation](architecture.md)
- [Troubleshooting Guide](troubleshooting.md)
- [Contributing Guide](contributing/README.md)

For more examples and use cases, check the [examples directory](examples/README.md) in the repository.
