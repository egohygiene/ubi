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
- Docker HEALTHCHECK validates bash availability

---

### 🔹 Minimal
**Image:** `ghcr.io/egohygiene/ubi:latest-minimal` or `ghcr.io/egohygiene/ubi:0.1.5-minimal`

The most lightweight variant with only foundational environment variables and XDG directory structure. No language runtimes, build tools, or package managers.

**Use this when:**
- You need the smallest possible image size
- You want to add only specific tools you need
- Security surface reduction is a priority
- Building specialized containers with minimal dependencies

**What's included:**
- XDG-compliant directory structure (`/opt/universal/*`)
- Essential environment variables (locale, colors, basic tooling)
- Telemetry controls
- Basic system utilities from the devcontainer base
- Docker HEALTHCHECK validates bash availability

**What's NOT included:**
- Python runtime, pip, or development tools
- Node.js runtime, npm, or package managers
- Language-specific build dependencies (build-essential, compilers, etc.)
- Version managers (pyenv, nvm, etc.)

**Image size:** Smallest (~500MB base)

---

### 🔹 Python
**Image:** `ghcr.io/egohygiene/ubi:latest-python` or `ghcr.io/egohygiene/ubi:0.1.5-python`

Python-focused variant with Python runtime and package management tools.

**Use this when:**
- Building Python applications or data science projects
- Require Python package management (pip, poetry)
- Working with Python-based workflows
- Need Python build tools and dependencies

**What's included:**
- Everything from Minimal variant
- Python 3.13.5 runtime and development headers
- pip 25.1.1 (Python package installer)
- poetry (dependency management) - best-effort install via pip
- Python build dependencies (build-essential, libssl-dev, zlib1g-dev, libbz2-dev, libreadline-dev, libsqlite3-dev, libxml2-dev, libxmlsec1-dev, libffi-dev, liblzma-dev, etc.)
- Python-specific environment variables (PYTHONUNBUFFERED, PYTHONUTF8, PIP_NO_CACHE_DIR, etc.)
- pyenv environment variables pre-configured at `$UNIVERSAL_TOOLBOX/pyenv` (install pyenv manually if needed)
- Docker HEALTHCHECK validates bash and python3 availability

**Image size:** Medium (~1.2GB)

**Note:** Poetry installation may fail in restricted environments but the core Python tooling (python3, pip, venv) is always available. You can install additional version managers like pyenv manually if needed.

---

### 🔹 Node
**Image:** `ghcr.io/egohygiene/ubi:latest-node` or `ghcr.io/egohygiene/ubi:0.1.5-node`

Node.js-focused variant with Node.js runtime and package management tools.

**Use this when:**
- Building JavaScript/TypeScript applications
- Require Node package management (npm, pnpm, yarn)
- Working with modern JavaScript tooling
- Need Node.js build tools

**What's included:**
- Everything from Minimal variant
- Node.js v20.19.2 (LTS) runtime
- npm 9.2.0 (Node package manager)
- pnpm (fast, disk space efficient package manager) - best-effort install via npm
- yarn (alternative package manager) - best-effort install via npm
- Node.js build dependencies (build-essential, libssl-dev)
- Node-specific environment variables (NODE_OPTIONS, telemetry controls)
- nvm environment variables pre-configured at `$UNIVERSAL_TOOLBOX/nvm` (install nvm manually if needed)
- Docker HEALTHCHECK validates bash and node availability

**Image size:** Medium (~1.1GB)

**Note:** pnpm and yarn installation may fail in restricted environments but the core Node.js tooling (node, npm) is always available. You can install additional version managers like nvm or volta manually if needed.

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
- Docker HEALTHCHECK validates bash, python3, and node availability

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
3. Update the test workflow (`.github/workflows/test-unified.yml`)
4. Update this documentation
5. Test locally before submitting PR

See [CONTRIBUTING.md](../CONTRIBUTING.md) for detailed contribution guidelines.

---

## Related Documentation

- [Architecture Overview](architecture.md) - UBI design and XDG structure
- [Getting Started](getting-started/quick-start.md) - Quick start guide
- [Security Overview](security-overview.md) - Security practices
- [README](../README.md) - Main project documentation
