# UBI Variants

UBI provides multiple image variants optimized for different use cases. Each variant is built from the same base but includes different sets of tools and runtimes.

---

## Available Variants

### 🔹 Base (Default)
**Image:** `ghcr.io/egohygiene/ubi:latest` or `ghcr.io/egohygiene/ubi:0.1.5`

The original UBI image as defined in `.devcontainer/Dockerfile`. This is the default variant and provides a general-purpose development environment with all the foundational XDG directory structure and environment variables.

**Use this when:**
- You need the standard UBI experience
- You're already using UBI and don't need specialized tooling
- You want consistency with existing projects

**What's included:**
- XDG-compliant directory structure (`/opt/universal/*`)
- Comprehensive environment variables for locale, colors, and tooling
- Base devcontainer utilities
- All telemetry disabled by default

---

### 🔹 Minimal
**Image:** `ghcr.io/egohygiene/ubi:latest-minimal` or `ghcr.io/egohygiene/ubi:0.1.5-minimal`

The most lightweight variant with only foundational environment variables and XDG directory structure. No language runtimes or heavy tools.

**Use this when:**
- You need the smallest possible image size
- You want to add only specific tools you need
- Security surface reduction is a priority
- Building specialized containers with minimal dependencies

**What's included:**
- XDG-compliant directory structure (`/opt/universal/*`)
- Essential environment variables (locale, colors, basic tooling)
- Telemetry controls
- Minimal system utilities

**What's NOT included:**
- Python runtime or tools
- Node.js runtime or tools
- Language-specific package managers
- Additional development tools

**Image size:** Smallest (~500MB base)

---

### 🔹 Python
**Image:** `ghcr.io/egohygiene/ubi:latest-python` or `ghcr.io/egohygiene/ubi:0.1.5-python`

Python-focused variant with Python runtime, pip, poetry, and pyenv for version management.

**Use this when:**
- Building Python applications or data science projects
- Need multiple Python versions (via pyenv)
- Require Python package management (pip, poetry)
- Working with Python-based workflows

**What's included:**
- Everything from Minimal variant
- Python 3 runtime and development headers
- pip (Python package installer)
- Poetry (dependency management)
- pyenv (Python version manager) at `$UNIVERSAL_TOOLBOX/pyenv`
- Python build dependencies (libssl-dev, zlib1g-dev, etc.)
- Python-specific environment variables

**Image size:** Medium (~1.2GB)

---

### 🔹 Node
**Image:** `ghcr.io/egohygiene/ubi:latest-node` or `ghcr.io/egohygiene/ubi:0.1.5-node`

Node.js-focused variant with Node.js runtime, npm, pnpm, yarn, and nvm for version management.

**Use this when:**
- Building JavaScript/TypeScript applications
- Need multiple Node.js versions (via nvm)
- Require Node package management (npm, pnpm, yarn)
- Working with modern JavaScript tooling

**What's included:**
- Everything from Minimal variant
- Node.js LTS runtime via nvm
- nvm (Node Version Manager) at `$UNIVERSAL_TOOLBOX/nvm`
- npm (Node package manager)
- pnpm (fast, disk space efficient package manager)
- yarn (alternative package manager)
- Node.js build dependencies
- Node-specific environment variables (NODE_OPTIONS)

**Image size:** Medium (~1.1GB)

---

### 🔹 Full
**Image:** `ghcr.io/egohygiene/ubi:latest-full` or `ghcr.io/egohygiene/ubi:0.1.5-full`

The full-featured "kitchen sink" variant with all development tools and runtimes included. Combines Python and Node.js variants.

**Use this when:**
- Working in polyglot environments
- Need maximum flexibility for heavy workflows
- Building devcontainers for large, multi-language projects
- Want everything available without additional setup

**What's included:**
- Everything from Minimal variant
- Everything from Python variant
- Everything from Node variant
- All language runtimes and package managers
- Complete development toolchain

**Image size:** Largest (~2.0GB+)

---

## Choosing a Variant

| Variant | Size | Python | Node.js | Best For |
|---------|------|--------|---------|----------|
| **Base** | Medium | ❌ | ❌ | General purpose, current UBI users |
| **Minimal** | Smallest | ❌ | ❌ | Specialized containers, minimal footprint |
| **Python** | Medium | ✅ | ❌ | Python applications, data science |
| **Node** | Medium | ❌ | ✅ | JavaScript/TypeScript applications |
| **Full** | Largest | ✅ | ✅ | Polyglot projects, maximum flexibility |

---

## Usage Examples

### Using in devcontainer.json

```json
{
  "name": "My Python Project",
  "image": "ghcr.io/egohygiene/ubi:latest-python",
  "features": {
    // Add your devcontainer features here
  }
}
```

### Using in Dockerfile

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.5-node

# Your project-specific setup
WORKDIR /workspace
COPY package.json .
RUN npm install
```

### Building Locally

```bash
# Build minimal variant
docker build -f variants/minimal/Dockerfile -t ubi:minimal .

# Build python variant
docker build -f variants/python/Dockerfile -t ubi:python .

# Build node variant
docker build -f variants/node/Dockerfile -t ubi:node .

# Build full variant
docker build -f variants/full/Dockerfile -t ubi:full .
```

---

## Version Pinning

All variants follow the same versioning scheme as the base UBI image. Always pin to a specific version for reproducible builds:

```dockerfile
# Good: Pinned to specific version
FROM ghcr.io/egohygiene/ubi:0.1.5-python

# Avoid: Using 'latest' in production
FROM ghcr.io/egohygiene/ubi:latest-python
```

---

## Architecture Support

All variants are built for multiple architectures:
- `linux/amd64` (x86_64)
- `linux/arm64` (ARM64/Apple Silicon)

Docker will automatically pull the correct architecture for your platform.

---

## Security Considerations

- **Minimal variant:** Smallest attack surface, recommended for production
- **Specialized variants (Python/Node):** Include only necessary runtimes
- **Full variant:** Largest attack surface, best for development only

All variants:
- Are regularly scanned for vulnerabilities with Trivy
- Have SBOMs (Software Bill of Materials) generated during publish
- Are signed with Cosign for image verification
- Receive the same security updates as the base image

---

## Contributing

To add a new variant or update existing ones:

1. Create or modify Dockerfile in `variants/<name>/Dockerfile`
2. Update the publish workflow (`.github/workflows/publish.yml`)
3. Update the test workflow (`.github/workflows/test-image.yml`)
4. Update this documentation
5. Test locally before submitting PR

See [CONTRIBUTING.md](../CONTRIBUTING.md) for detailed contribution guidelines.

---

## Related Documentation

- [Architecture Overview](architecture.md) - UBI design and XDG structure
- [Getting Started](getting-started/quick-start.md) - Quick start guide
- [Security Overview](security-overview.md) - Security practices
- [README](../README.md) - Main project documentation
