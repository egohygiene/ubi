# UBI Documentation

Welcome to the UBI (Universal Base Image) documentation.

**[📖 View the full documentation site →](https://egohygiene.github.io/ubi/)**

The documentation is also available as a beautifully formatted website built with MkDocs Material theme, featuring:
- 🔍 Full-text search
- 📱 Mobile-responsive design
- 🌓 Light/dark mode
- 📑 Organized navigation
- ⚡ Fast and modern UI

---

## Core Documentation

### [Architecture](./architecture.md)

Learn about UBI's design, goals, and implementation:

- UBI goals and philosophy
- XDG Base Directory strategy
- Universal filesystem layout (`/opt/universal`)
- Devcontainer and CI/CD architecture
- Multi-stage build process
- Environment configuration

### [Troubleshooting](./troubleshooting.md)

Solutions to common issues:

- Devcontainer build problems
- Docker layer caching
- Version bump issues
- CHANGELOG fix instructions
- Environment variable problems
- Permission issues

### [Release Process](./release-process.md)

Complete guide to releasing new versions:

- VERSION file rules
- Semantic versioning guidelines
- bump-my-version workflow
- Publish pipeline (tag → GHCR)
- SBOM generation
- Release checklist

### [Security Overview](./security-overview.md)

Security practices and policies:

- Security philosophy and threat model
- Container security (no privileged mode)
- Vulnerability scanning with Trivy
- SBOM generation and usage
- Supply chain security
- Future: Cosign signing

---

## Security

### [Security Documentation](./security/)

Security-related documentation, audits, and decisions:

- **[Privileged Mode Analysis](./security/privileged-mode.md)** - Investigation and removal of privileged mode from devcontainer

---

## Development & Automation

### [Copilot Agent Environment](./dev/copilot-environment.md)

GitHub Copilot Agent configuration for automated workflows:

- Copilot Agent architecture and lifecycle
- Pre-installation workflow setup
- Allowlist configuration for external domains
- Tool installation and caching strategy
- Security considerations
- Troubleshooting guide

---

## Future Documentation (Under Construction)

The following sections are placeholders for future expansion:

### [Contributing](./contributing/)

Contributing guidelines and development workflows *(coming soon)*

### [Examples](./examples/)

Practical examples of using UBI in various scenarios *(coming soon)*

### [Best Practices](./best-practices/)

Recommendations for using UBI effectively *(coming soon)*

---

## Quick Links

### Project Resources

- [Main README](../README.md) - Project overview and getting started
- [Changelog](../CHANGELOG.md) - Version history and release notes (canonical source)
- [Security Policy](../SECURITY.md) - Security vulnerability reporting
- [Contributing Guidelines](../CONTRIBUTING.md) - How to contribute
- [DevContainer Configuration](../.devcontainer/) - Development environment setup
- [Metrics Documentation](../metrics/README.md) - Build metrics and observability
- [Benchmarks Documentation](../benchmarks/README.md) - Performance benchmarking

### Documentation Guidelines

- [Source of Truth Guidelines](source-of-truth.md) - Canonical documentation locations and anti-duplication rules

### External Links

- [GitHub Repository](https://github.com/egohygiene/ubi)
- [Container Registry](https://ghcr.io/egohygiene/ubi)
- [GitHub Actions Workflows](https://github.com/egohygiene/ubi/actions)
- [Security Scan Results](https://github.com/egohygiene/ubi/security/code-scanning)
- [Security Audit Reports](../audit/)

---

## Documentation Roadmap

We're continuously improving our documentation. Planned additions include:

- **MkDocs Site**: A full documentation website with search and navigation
- **Video Tutorials**: Visual guides for common tasks
- **Architecture Diagrams**: Visual representations of UBI's design
- **Migration Guides**: Guides for moving from other base images
- **Performance Tuning**: Advanced optimization techniques
- **Integration Guides**: Detailed guides for specific CI/CD platforms

---

## Contributing to Documentation

Documentation improvements are always welcome! To contribute:

1. Check existing documentation for accuracy
2. Identify gaps or unclear sections
3. Submit a PR with improvements
4. Follow markdown best practices
5. Keep examples practical and tested

See [CONTRIBUTING.md](../CONTRIBUTING.md) for general contribution guidelines.

---

## Getting Help

If you can't find what you're looking for:

1. **Search Issues**: Check [existing issues](https://github.com/egohygiene/ubi/issues)
2. **Ask a Question**: Open a [discussion](https://github.com/egohygiene/ubi/discussions)
3. **Report a Problem**: Create an [issue](https://github.com/egohygiene/ubi/issues/new)

---

**Last Updated**: 2025-12-13  
**Documentation Version**: 0.1.5
