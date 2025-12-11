# 🌐 UBI - Universal Base Image

**The foundational developer platform for all Ego Hygiene projects**

Your all-in-one dev environment: reproducible builds, universal tooling, and cohesive DX. 🛠️✨

[![Build & Publish](https://github.com/egohygiene/ubi/actions/workflows/publish.yml/badge.svg)](https://github.com/egohygiene/ubi/actions/workflows/publish.yml)
[![Latest Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/egohygiene/ubi/blob/main/VERSION)
[![Container Registry](https://img.shields.io/badge/ghcr.io-egohygiene%2Fubi-brightgreen.svg)](https://ghcr.io/egohygiene/ubi)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 📘 What is UBI?

**UBI (Universal Base Image)** is the baseline container environment for all Ego Hygiene projects. It provides a reproducible, stable, and developer-experience-optimized foundation that every devcontainer and project in the organization builds upon.

Instead of each project maintaining its own environment setup, UBI serves as the single source of truth — ensuring:

- **Consistency**: Every developer works in an identical environment
- **Reproducibility**: Builds are deterministic and versioned
- **Developer Happiness**: Pre-configured with sensible defaults and modern tooling
- **Maintainability**: Update the base once, benefit everywhere

UBI is distributed via GitHub Container Registry (GHCR) and consumed by other repositories as their base image.

---

## ✨ Features

- 🗂️ **Fully XDG-Aligned Filesystem**  
  Adheres to the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) for predictable configuration and data locations.

- 📁 **`/opt/universal/*` Hierarchy**  
  Standardized paths for binaries, configs, caches, logs, and more:
  - `/opt/universal/bin` - Universal binaries
  - `/opt/universal/config` - Configuration files (XDG_CONFIG_HOME)
  - `/opt/universal/cache` - Cache directory (XDG_CACHE_HOME)
  - `/opt/universal/toolbox` - Data files (XDG_DATA_HOME)
  - `/opt/universal/runtime` - Runtime state (XDG_STATE_HOME)
  - `/opt/universal/logs` - Centralized logs
  - `/opt/universal/apps` - Application resources
  - And more...

- ⚙️ **Predictable Runtime Environment**  
  Pre-configured environment variables for consistent behavior across:
  - Locale and timezone settings
  - Editor and pager preferences (VS Code, less)
  - Color and terminal settings
  - Python, Node.js, and Rust configurations
  - Telemetry opt-outs for privacy

- 🎛️ **Configurable via Build Arguments**  
  Customize behavior at build time with Docker ARGs for locale, timezone, editor preferences, and more.

- 🔄 **Reproducible Builds & Semantic Versioning**  
  Every release is tagged with a semantic version, ensuring immutable and auditable deployments.

- 📦 **Distributed via GHCR**  
  Pull from GitHub Container Registry for fast, reliable access:  
  `ghcr.io/egohygiene/ubi`

- 🚀 **Optimized for Developer Experience**  
  Sensible defaults that "just work" — less configuration, more productivity.

---

## 🚀 Getting Started

### Using UBI in Your Devcontainer

The simplest way to consume UBI is via a devcontainer configuration:

```json
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "features": {
    // Add your devcontainer features here
  }
}
```

### Using UBI in a Dockerfile

Build your project-specific image on top of UBI:

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.0

# Install project-specific dependencies
RUN apt-get update && apt-get install -y \
    your-package-here

# Copy your application code
COPY . /workspace

# Set up your project
RUN npm install  # or pip install, cargo build, etc.
```

### Pulling the Latest Image

```bash
docker pull ghcr.io/egohygiene/ubi:latest
```

### Running Interactively

```bash
docker run -it --rm ghcr.io/egohygiene/ubi:latest bash
```

---

## 📦 Versioning

UBI follows **Semantic Versioning (SemVer)**: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes to the environment or filesystem structure
- **MINOR**: New features, tools, or non-breaking enhancements
- **PATCH**: Bug fixes and minor updates

### Version File

The current version is defined in the [`VERSION`](./VERSION) file at the root of this repository:

```
0.1.0
```

### Tags

Every release publishes multiple tags to GHCR:

- `ghcr.io/egohygiene/ubi:latest` — Always points to the most recent stable release
- `ghcr.io/egohygiene/ubi:0.1.0` — Specific version for pinned deployments
- `ghcr.io/egohygiene/ubi:sha-<commit>` — Git commit SHA for exact reproducibility

**Recommendation**: Use specific version tags (e.g., `0.1.0`) in production and `latest` for development.

### Changelog

For detailed release notes and change history, see the [CHANGELOG.md](./CHANGELOG.md).

---

## 🏗️ Architecture

UBI is built on top of the official [Microsoft DevContainers base image](https://mcr.microsoft.com/en-us/product/devcontainers/base/about), which provides a solid foundation with common development tools.

### Key Components

1. **Base Image**: `mcr.microsoft.com/devcontainers/base:latest`
2. **Environment Configuration**: Extensive ENV vars for consistent behavior
3. **XDG Directory Structure**: `/opt/universal/*` hierarchy
4. **Build Arguments**: Customizable settings at build time
5. **Multi-Stage Build**: Organized into `base`, `environment`, and `final` stages

### Build Process

The image is automatically built and published via GitHub Actions on every push to `main` or when the `VERSION` file changes. See [`.github/workflows/publish.yml`](.github/workflows/publish.yml) for details.

---

## 🔧 Development

### Local Build

To build UBI locally:

```bash
docker build -f .devcontainer/Dockerfile -t ubi:local .
```

### Testing Changes

1. Build the image locally
2. Update your devcontainer to use `ubi:local`
3. Rebuild your devcontainer and test your changes
4. Once validated, update `VERSION` and push to trigger a new release

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Report Issues**: Found a bug or have a feature request? [Open an issue](https://github.com/egohygiene/ubi/issues)
2. **Submit PRs**: Fix bugs, improve documentation, or add features
3. **Share Feedback**: Let us know how UBI can better serve your needs

### Guidelines

- Keep changes minimal and focused
- Update documentation for any environment changes
- Bump the `VERSION` file according to SemVer for breaking or feature changes
- Update the [CHANGELOG.md](./CHANGELOG.md) with your changes under the `[Unreleased]` section
- Test your changes locally before submitting

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](./LICENSE) file for details.

---

## 🙏 Acknowledgments

Built with ❤️ by the [Ego Hygiene](https://github.com/egohygiene) team.

Special thanks to:
- [Microsoft DevContainers](https://github.com/devcontainers) for the excellent base image
- The [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/) community
- All contributors who help make UBI better

---

## 📬 Support

- **Issues**: [github.com/egohygiene/ubi/issues](https://github.com/egohygiene/ubi/issues)
- **Discussions**: [github.com/egohygiene/ubi/discussions](https://github.com/egohygiene/ubi/discussions)
- **Organization**: [github.com/egohygiene](https://github.com/egohygiene)

---

<div align="center">

**[⬆ back to top](#-ubi---universal-base-image)**

Made with 🛠️ by Ego Hygiene | Powered by 🌐 Universal Base Image

</div>
