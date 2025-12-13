# Installation

This guide covers how to install and start using UBI in your projects.

---

## Prerequisites

Before using UBI, ensure you have:

- **Docker** - Version 20.10 or higher
- **VS Code** (optional) - For devcontainer support
- **Dev Containers extension** (optional) - For VS Code integration

---

## Installation Methods

### Method 1: Using as a Devcontainer Base

This is the recommended method for most projects.

#### Step 1: Create Devcontainer Configuration

Create a `.devcontainer/devcontainer.json` file in your project:

```json
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:latest"
}
```

#### Step 2: Open in VS Code

1. Open your project in VS Code
2. Press `F1` and select **Dev Containers: Reopen in Container**
3. VS Code will pull the UBI image and start your devcontainer

### Method 2: Using as a Dockerfile Base

Extend UBI in your own Dockerfile:

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.5

# Add your project-specific layers
RUN apt-get update && apt-get install -y \
    your-dependencies \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
```

Build your image:

```bash
docker build -t myproject:latest .
```

### Method 3: Direct Docker Usage

Pull and run UBI directly:

```bash
# Pull the image
docker pull ghcr.io/egohygiene/ubi:latest

# Run interactively
docker run -it --rm ghcr.io/egohygiene/ubi:latest bash
```

---

## Version Selection

UBI provides multiple version tags:

### Latest Version

```dockerfile
FROM ghcr.io/egohygiene/ubi:latest
```

**Use for**: Development and testing

### Specific Version (Recommended for Production)

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.5
```

**Use for**: Production deployments, reproducible builds

### Commit SHA (Maximum Reproducibility)

```dockerfile
FROM ghcr.io/egohygiene/ubi:sha-abc123
```

**Use for**: Auditing, compliance, maximum reproducibility

---

## Verifying Installation

After pulling UBI, verify the installation:

```bash
# Check version
docker run --rm ghcr.io/egohygiene/ubi:latest cat /VERSION

# Verify XDG directories
docker run --rm ghcr.io/egohygiene/ubi:latest ls -la /opt/universal/

# Check environment variables
docker run --rm ghcr.io/egohygiene/ubi:latest env | grep XDG
```

Expected output:

```
XDG_CONFIG_HOME=/opt/universal/config
XDG_CACHE_HOME=/opt/universal/cache
XDG_DATA_HOME=/opt/universal/toolbox
XDG_STATE_HOME=/opt/universal/runtime
```

---

## Configuration

### Basic Configuration

Minimal devcontainer configuration:

```json title=".devcontainer/devcontainer.json"
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:0.1.5",
  "workspaceFolder": "/workspace",
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind"
}
```

### Advanced Configuration

With additional features and customizations:

```json title=".devcontainer/devcontainer.json"
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:0.1.5",
  "workspaceFolder": "/workspace",
  
  // Add VS Code extensions
  "customizations": {
    "vscode": {
      "extensions": [
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode"
      ],
      "settings": {
        "terminal.integrated.defaultProfile.linux": "bash"
      }
    }
  },
  
  // Set environment variables
  "containerEnv": {
    "MY_ENV_VAR": "value"
  },
  
  // Mount additional volumes
  "mounts": [
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=cached"
  ],
  
  // Port forwarding
  "forwardPorts": [3000, 8080],
  
  // Post-create command
  "postCreateCommand": "npm install"
}
```

---

## Docker Compose Integration

Use UBI with Docker Compose:

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
    environment:
      - NODE_ENV=development
    command: bash
    tty: true
    stdin_open: true

volumes:
  ubi-cache:
  ubi-config:
```

Run with:

```bash
docker-compose up -d
docker-compose exec app bash
```

---

## Offline Installation

For environments without internet access:

### Step 1: Pull Image on Connected Machine

```bash
docker pull ghcr.io/egohygiene/ubi:0.1.5
docker save ghcr.io/egohygiene/ubi:0.1.5 -o ubi-0.1.5.tar
```

### Step 2: Transfer to Offline Machine

Transfer `ubi-0.1.5.tar` to your offline machine.

### Step 3: Load Image

```bash
docker load -i ubi-0.1.5.tar
```

---

## Updating UBI

### Manual Update

```bash
# Pull latest version
docker pull ghcr.io/egohygiene/ubi:latest

# Or pull specific version
docker pull ghcr.io/egohygiene/ubi:0.1.5

# Rebuild your devcontainer
# In VS Code: F1 -> Dev Containers: Rebuild Container
```

### Automated Update

Set up Dependabot to automatically update your UBI version:

```yaml title=".github/dependabot.yml"
version: 2
updates:
  - package-ecosystem: "docker"
    directory: "/.devcontainer"
    schedule:
      interval: "weekly"
```

---

## Uninstalling

To remove UBI from your system:

```bash
# Remove all UBI images
docker rmi ghcr.io/egohygiene/ubi:latest
docker rmi ghcr.io/egohygiene/ubi:0.1.5

# Remove all unused images
docker image prune -a
```

---

## Next Steps

- Read the [Quick Start Guide](quick-start.md)
- Explore [Examples](../examples.md)
- Learn about [Architecture](../architecture.md)
- See [Troubleshooting](../troubleshooting.md) if you encounter issues

---

## Getting Help

If you encounter issues during installation:

1. Check the [Troubleshooting Guide](../troubleshooting.md)
2. Search [existing issues](https://github.com/egohygiene/ubi/issues)
3. Open a [new issue](https://github.com/egohygiene/ubi/issues/new)
4. Join the [discussion](https://github.com/egohygiene/ubi/discussions)
