# 🌐 UBI - Universal Base Image

## The foundational developer platform for all Ego Hygiene projects

Your all-in-one dev environment: reproducible builds, universal tooling, and cohesive DX. 🛠️✨

---

## 📘 What is UBI?

**UBI (Universal Base Image)** is the baseline container environment for all Ego Hygiene projects. It provides a reproducible, stable, and developer-experience-optimized foundation that every devcontainer and project in the organization builds upon.

Instead of each project maintaining its own environment setup, UBI serves as the single source of truth — ensuring:

- **Consistency**: Every developer works in an identical environment
- **Reproducibility**: Builds are deterministic and versioned
- **Developer Happiness**: Pre-configured with sensible defaults and modern tooling
- **Maintainability**: Update the base once, benefit everywhere

UBI is distributed via [GitHub Container Registry (GHCR)](https://ghcr.io/egohygiene/ubi) and consumed by other repositories as their base image.

---

## ✨ Features

### 🗂️ Fully XDG-Aligned Filesystem

Adheres to the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) for predictable configuration and data locations.

### 📁 `/opt/universal/*` Hierarchy

Standardized paths for binaries, configs, caches, logs, and more:

- `/opt/universal/bin` - Universal binaries
- `/opt/universal/config` - Configuration files (XDG_CONFIG_HOME)
- `/opt/universal/cache` - Cache directory (XDG_CACHE_HOME)
- `/opt/universal/toolbox` - Data files (XDG_DATA_HOME)
- `/opt/universal/runtime` - Runtime state (XDG_STATE_HOME)
- `/opt/universal/logs` - Centralized logs
- `/opt/universal/apps` - Application resources

### ⚙️ Predictable Runtime Environment

Pre-configured environment variables for consistent behavior across all projects and CI/CD pipelines.

### 🔒 Security First

- Pinned base images with digest verification
- Automated vulnerability scanning with Trivy
- SBOM generation for supply chain transparency
- Regular security updates

### 🚀 Developer Experience

- Modern terminal configuration
- Sensible defaults
- Telemetry disabled by default
- Comprehensive documentation

---

## 🚀 Quick Start

### Using in Your Devcontainer

Reference UBI in your `.devcontainer/devcontainer.json`:

```json
{
  "name": "My Project",
  "image": "ghcr.io/egohygiene/ubi:latest",
  "features": {
    // Add your project-specific features
  }
}
```

### Using as a Base Image

Reference UBI in your `Dockerfile`:

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.5

# Add your project-specific layers
```

### Version Pinning

For maximum reproducibility, pin to a specific version:

```dockerfile
# Pin to specific version
FROM ghcr.io/egohygiene/ubi:0.1.5

# Or pin to exact commit SHA
FROM ghcr.io/egohygiene/ubi:sha-abc123
```

---

## 📚 Documentation

### Core Documentation

- **[Architecture](architecture.md)** - Design principles and implementation details
- **[Troubleshooting](troubleshooting.md)** - Solutions to common issues
- **[Release Process](release-process.md)** - Version management and publishing workflow
- **[Security Overview](security-overview.md)** - Security practices and policies

### Getting Started

- **[Installation](getting-started/installation.md)** - How to install and use UBI
- **[Quick Start](getting-started/quick-start.md)** - Get up and running quickly

### Examples

- **[Examples](examples.md)** - Practical examples and use cases

### Contributing

- **[Contributing Guide](contributing/README.md)** - How to contribute to UBI
- **[Best Practices](best-practices/README.md)** - Recommendations for using UBI

---

## 🏷 Version & Release

**Current Version**: 0.1.5

UBI follows [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes to environment or filesystem structure
- **MINOR**: New features, tools, or non-breaking enhancements
- **PATCH**: Bug fixes and minor updates

See the [Changelog](changelog.md) for detailed release history.

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](contributing/README.md) for details.

### Quick Links

- [GitHub Repository](https://github.com/egohygiene/ubi)
- [Issues](https://github.com/egohygiene/ubi/issues)
- [Discussions](https://github.com/egohygiene/ubi/discussions)
- [Container Registry](https://ghcr.io/egohygiene/ubi)

---

## 📄 License

This project is licensed under the MIT License - see the [License](license.md) file for details.

---

## 🔗 Additional Resources

- [Main README](https://github.com/egohygiene/ubi/blob/main/README.md)
- [Security Policy](https://github.com/egohygiene/ubi/blob/main/SECURITY.md)
- [DevContainer Configuration](https://github.com/egohygiene/ubi/tree/main/.devcontainer)
- [GitHub Actions Workflows](https://github.com/egohygiene/ubi/actions)

---

**Last Updated**: 2025-12-13  
**Documentation Version**: 0.1.5
