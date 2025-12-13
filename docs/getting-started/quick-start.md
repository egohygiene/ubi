# Quick Start

Get up and running with UBI in minutes! This guide provides the fastest path to using UBI in your projects.

---

## 🚀 5-Minute Quick Start

### Option 1: VS Code + Devcontainer (Recommended)

The fastest way to get started:

#### 1. Create Configuration File

Create `.devcontainer/devcontainer.json` in your project root:

```json
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:latest"
}
```

#### 2. Open in Container

1. Open your project in VS Code
2. Press `F1` (or `Ctrl+Shift+P` / `Cmd+Shift+P`)
3. Type: **Dev Containers: Reopen in Container**
4. Press Enter

VS Code will automatically:
- Pull the UBI image
- Start the container
- Open your project inside the container

✅ **Done!** You're now working in UBI.

---

### Option 2: Docker Command Line

For command-line users:

```bash
# Pull the image
docker pull ghcr.io/egohygiene/ubi:latest

# Run interactively
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/egohygiene/ubi:latest \
  bash
```

✅ **Done!** You're now in a UBI shell.

---

## 📋 Basic Usage

### Explore the Environment

Once inside UBI, explore the environment:

```bash
# Check version
cat /VERSION

# List XDG directories
ls -la /opt/universal/

# View environment variables
env | grep XDG

# Check installed tools
git --version
curl --version
```

### Use XDG Directories

UBI provides standardized directories:

```bash
# Configuration directory
echo $XDG_CONFIG_HOME
# Output: /opt/universal/config

# Cache directory
echo $XDG_CACHE_HOME
# Output: /opt/universal/cache

# Data directory
echo $XDG_DATA_HOME
# Output: /opt/universal/toolbox
```

---

## 🛠️ Common Tasks

### Install Additional Tools

```bash
# Update package list
sudo apt-get update

# Install tools
sudo apt-get install -y nodejs npm

# Verify installation
node --version
npm --version
```

### Run Your Project

```bash
# Navigate to your workspace
cd /workspace

# Install dependencies (example: Node.js)
npm install

# Run your application
npm start
```

### Configure Your Shell

```bash
# ZSH is already configured, but you can customize
vim ~/.zshrc

# Or use your preferred editor
code ~/.zshrc
```

---

## 📚 Project Templates

### Python Project

```json title=".devcontainer/devcontainer.json"
{
  "name": "Python Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "postCreateCommand": "pip install -r requirements.txt",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance"
      ]
    }
  }
}
```

### Node.js Project

```json title=".devcontainer/devcontainer.json"
{
  "name": "Node.js Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "postCreateCommand": "npm install",
  "forwardPorts": [3000],
  "customizations": {
    "vscode": {
      "extensions": [
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode"
      ]
    }
  }
}
```

### Go Project

```json title=".devcontainer/devcontainer.json"
{
  "name": "Go Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "postCreateCommand": "go mod download",
  "customizations": {
    "vscode": {
      "extensions": [
        "golang.go"
      ]
    }
  }
}
```

---

## 🔧 Customization

### Add Environment Variables

```json title=".devcontainer/devcontainer.json"
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "containerEnv": {
    "DATABASE_URL": "postgresql://localhost:5432/mydb",
    "API_KEY": "${localEnv:API_KEY}"
  }
}
```

### Mount Additional Volumes

```json title=".devcontainer/devcontainer.json"
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "mounts": [
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,readonly",
    "source=${localEnv:HOME}/.gitconfig,target=/home/vscode/.gitconfig,type=bind"
  ]
}
```

### Forward Ports

```json title=".devcontainer/devcontainer.json"
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "forwardPorts": [3000, 8080, 5432]
}
```

---

## 🎯 Next Steps

Now that you have UBI running, explore these resources:

### Learn More

- **[Installation Guide](installation.md)** - Detailed installation instructions
- **[Examples](../examples.md)** - Practical examples and use cases
- **[Architecture](../architecture.md)** - Understand UBI's design

### Build Your Project

- **[Troubleshooting](../troubleshooting.md)** - Solutions to common issues
- **[Best Practices](../best-practices/README.md)** - Recommendations for using UBI
- **[Contributing](../contributing/README.md)** - Contribute to UBI

### Stay Updated

- **[Changelog](../changelog.md)** - See what's new
- **[Release Process](../release-process.md)** - Understand versioning
- **[Security](../security-overview.md)** - Security practices

---

## ⚡ Pro Tips

### Use Version Pinning in Production

```json
{
  "name": "Production App",
  "image": "ghcr.io/egohygiene/ubi:0.1.5"  // Pin specific version
}
```

### Cache Dependencies

Use named volumes to persist caches:

```json
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "mounts": [
    "source=ubi-cache,target=/opt/universal/cache,type=volume"
  ]
}
```

### Enable Git Credential Helper

```bash
# Inside the container
git config --global credential.helper store
```

### Use Pre-commit Hooks

```bash
# Inside the container
pip install pre-commit
pre-commit install
```

---

## 🆘 Getting Help

### Troubleshooting

If something doesn't work:

1. Check the [Troubleshooting Guide](../troubleshooting.md)
2. Search [existing issues](https://github.com/egohygiene/ubi/issues)
3. Ask in [Discussions](https://github.com/egohygiene/ubi/discussions)

### Common Issues

**Container won't start?**
- Ensure Docker is running
- Check Docker has enough resources (4GB+ RAM)
- Try rebuilding: `F1 -> Dev Containers: Rebuild Container`

**Can't see your files?**
- Check `workspaceFolder` and `workspaceMount` settings
- Ensure volume permissions are correct

**Slow performance?**
- On macOS/Windows, use named volumes for node_modules
- Increase Docker resource limits

---

## 🎉 You're Ready!

You now have UBI running and know the basics. Start building your project with confidence!

For more detailed information, explore the rest of the documentation.
