# UBI Variants

This directory contains Dockerfiles for different UBI variants, each optimized for specific use cases.

## Structure

```
variants/
├── minimal/        # Minimal variant - smallest footprint
│   └── Dockerfile
├── python/         # Python variant - Python development tools
│   └── Dockerfile
├── node/           # Node variant - Node.js development tools
│   └── Dockerfile
└── full/           # Full variant - all tools included
    └── Dockerfile
```

## Variants

### Minimal
- **Dockerfile:** `variants/minimal/Dockerfile`
- **Image:** `ghcr.io/egohygiene/ubi:latest-minimal`
- **Description:** Lightweight with only foundational environment variables and XDG directory structure
- **Use case:** Specialized containers with minimal dependencies

### Python
- **Dockerfile:** `variants/python/Dockerfile`
- **Image:** `ghcr.io/egohygiene/ubi:latest-python`
- **Description:** Python development tools including Python 3.13, pip, poetry, and build dependencies
- **Use case:** Python applications and data science projects

### Node
- **Dockerfile:** `variants/node/Dockerfile`
- **Image:** `ghcr.io/egohygiene/ubi:latest-node`
- **Description:** Node.js development tools including Node.js v20, npm, pnpm, and yarn
- **Use case:** JavaScript/TypeScript applications

### Full
- **Dockerfile:** `variants/full/Dockerfile`
- **Image:** `ghcr.io/egohygiene/ubi:latest-full`
- **Description:** Full-featured with both Python and Node.js tools
- **Use case:** Polyglot projects and maximum flexibility

## Building Variants Locally

Build a specific variant:

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

## Testing Variants

Test a variant after building:

```bash
# Test minimal
docker run --rm ubi:minimal bash -c 'echo $XDG_CONFIG_HOME && ls /opt/universal'

# Test python
docker run --rm ubi:python bash -c 'python3 --version && pip3 --version'

# Test node
docker run --rm ubi:node bash -c 'node --version && npm --version'

# Test full
docker run --rm ubi:full bash -c 'python3 --version && node --version'
```

## CI/CD

All variants are automatically built and published by the GitHub Actions workflows:

- **Build & Publish:** `.github/workflows/publish.yml`
- **Testing:** `.github/workflows/test-image.yml`

Each variant is built for multiple architectures (linux/amd64, linux/arm64) and published to GHCR with appropriate tags.

## Documentation

For detailed information about each variant, see:
- [docs/variants.md](../docs/variants.md) - Complete variant documentation
- [README.md](../README.md) - Main project documentation

## Contributing

To modify or add a variant:

1. Create or update the Dockerfile in the appropriate subdirectory
2. Ensure the variant follows UBI's XDG structure and environment variable conventions
3. Update the workflows to include the new variant in the build matrix
4. Update documentation in `docs/variants.md`
5. Test locally before submitting a PR

See [CONTRIBUTING.md](../CONTRIBUTING.md) for detailed contribution guidelines.
