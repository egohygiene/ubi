<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# 🌐 UBI - Universal Base Image

## The foundational developer platform for all Ego Hygiene projects

Your all-in-one dev environment: reproducible builds, universal tooling, and cohesive DX. 🛠️✨

[![Build & Publish][build-badge]][build-link]
[![Security Scan][security-badge]][security-link]
[![Latest Version][version-badge]][version-link]
[![Container Registry][registry-badge]][registry-link]
[![License: MIT][license-badge]][license-link]

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

- 🏗️ **Multi-Architecture Support**
  Native support for multiple CPU architectures:
  - `linux/amd64` (x86_64) - Intel/AMD processors
  - `linux/arm64` (ARM64) - Apple Silicon (M1/M2/M3), AWS Graviton, Raspberry Pi
  
  Docker automatically pulls the correct architecture for your platform. To verify or explicitly specify:
  ```bash
  docker pull --platform=linux/arm64 ghcr.io/egohygiene/ubi:latest
  ```

- 🏥 **Built-in Health Checks**
  All variants include Docker HEALTHCHECK instructions for improved observability and runtime stability:
  - Validates essential tools (bash, python3, node) are operational
  - Enables container orchestrators to monitor and restart unhealthy containers
  - Improves CI testing accuracy with health status validation

- 📦 **Distributed via GHCR**
  Pull from GitHub Container Registry for fast, reliable access:
  `ghcr.io/egohygiene/ubi`

- 🚀 **Optimized for Developer Experience**
  Sensible defaults that "just work" — less configuration, more productivity.

---

## 🚀 Getting Started

### Choosing a Variant

UBI provides multiple image variants optimized for different use cases:

- **Base** (`ubi:latest`) - Default general-purpose image
- **Minimal** (`ubi:latest-minimal`) - Lightweight with only essentials
- **Python** (`ubi:latest-python`) - Includes Python, pip, poetry, pyenv
- **Node** (`ubi:latest-node`) - Includes Node.js, npm, pnpm, yarn, nvm
- **Full** (`ubi:latest-full`) - All tools and runtimes included

📖 **[See the full variants documentation →](docs/variants.md)**

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

Or use a specialized variant:

```json
{
  "name": "My Python Project",
  "image": "ghcr.io/egohygiene/ubi:latest-python",
  "features": {
    // Add your devcontainer features here
  }
}
```

### Using UBI in a Dockerfile

Build your project-specific image on top of UBI:

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.5

# Install project-specific dependencies
RUN apt-get update && apt-get install -y \
    your-package-here

# Copy your application code
COPY . /workspace

# Set up your project
RUN npm install  # or pip install, cargo build, etc.
```

Or use a specialized variant:

```dockerfile
FROM ghcr.io/egohygiene/ubi:0.1.5-python

# Your Python project is ready to go!
COPY . /workspace
RUN poetry install
```

### Pulling the Latest Image

```bash
docker pull ghcr.io/egohygiene/ubi:latest
```

### Running Interactively

```bash
docker run -it --rm ghcr.io/egohygiene/ubi:latest bash
```

### 📚 Example Projects

Want to see UBI in action? Check out our [example projects](./examples/):

- **[Python CLI](./examples/python-cli/)** - Command-line tool with Click
- **[Node.js Express](./examples/node-express/)** - REST API server
- **[Polyglot](./examples/polyglot/)** - Multi-language project (Python + Node.js + Bash)

Each example is fully documented and ready to run. They demonstrate:
- Real-world usage patterns
- XDG directory compliance
- Modern development workflows
- Multi-language support

👉 **[Browse all examples →](./examples/)**

### 🔏 Verifying Image Signatures

UBI images are signed with [Sigstore Cosign](https://docs.sigstore.dev/cosign/overview/) using keyless signing. This provides cryptographic proof that images are authentic and haven't been tampered with.

#### Installing Cosign

```bash
# macOS
brew install cosign

# Linux
curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
sudo chmod +x /usr/local/bin/cosign

# Or use the official container
alias cosign="docker run --rm gcr.io/projectsigstore/cosign:latest"
```

#### Verifying an Image

To verify the signature of a UBI image:

```bash
# Verify the latest image
cosign verify \
  --certificate-identity-regexp="https://github.com/egohygiene/ubi/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/egohygiene/ubi:latest

# Verify a specific version
cosign verify \
  --certificate-identity-regexp="https://github.com/egohygiene/ubi/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/egohygiene/ubi:0.1.5

# Verify by digest (most secure)
cosign verify \
  --certificate-identity-regexp="https://github.com/egohygiene/ubi/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/egohygiene/ubi@sha256:<digest>
```

**What does this verify?**

- ✅ The image was built by an official UBI GitHub Actions workflow
- ✅ The image hasn't been modified since signing
- ✅ The signature is backed by Sigstore's transparency log
- ✅ The build is traceable to a specific GitHub workflow run

**Note**: Verification will fail if the image has been tampered with or wasn't signed by an official workflow. This is a security feature, not a bug!

---

## 📦 Versioning

UBI follows **Semantic Versioning (SemVer)**: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes to the environment or filesystem structure
- **MINOR**: New features, tools, or non-breaking enhancements
- **PATCH**: Bug fixes and minor updates

### Automated Releases

UBI uses **semantic-release** for fully automated versioning, CHANGELOG generation, and GitHub releases based on [Conventional Commits](https://www.conventionalcommits.org/). This means:

- Commits with `feat:` trigger minor version bumps
- Commits with `fix:`, `perf:`, or `refactor:` trigger patch version bumps
- Commits with `BREAKING CHANGE:` trigger major version bumps
- Version, CHANGELOG, and GitHub releases are automatically managed

See [CONTRIBUTING.md](./CONTRIBUTING.md) for details on the release workflow.

### Version File

The current version is defined in the [`VERSION`](./VERSION) file at the root of this repository (for example `0.1.0`):

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

1. **Base Image**: `mcr.microsoft.com/devcontainers/base:2.1.2` (pinned with digest for reproducibility)
2. **Environment Configuration**: Extensive ENV vars for consistent behavior
3. **XDG Directory Structure**: `/opt/universal/*` hierarchy
4. **Build Arguments**: Customizable settings at build time
5. **Multi-Stage Build**: Organized into `base`, `environment`, and `final` stages

### Build Process

The image is automatically built and published via GitHub Actions on every push to `main` or when the `VERSION` file changes. See [`.github/workflows/publish.yml`](.github/workflows/publish.yml) for details.

### Learn More

For detailed architecture documentation, see [docs/architecture.md](./docs/architecture.md).

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

### Updating the Base Image

UBI's base image is pinned to a specific version with a digest for reproducibility and stability. To update it:

#### 1. Check for New Releases

Visit the official sources to find the latest stable version:

- **GitHub Releases**: [devcontainers/images releases](https://github.com/devcontainers/images/releases)
- **MCR Tag List**: Query available tags from the Microsoft Container Registry API:

  ```bash
  # List all available tags (returns JSON)
  curl -s https://mcr.microsoft.com/v2/devcontainers/base/tags/list | jq -r '.tags[]'

  # Or filter for version tags only
  curl -s https://mcr.microsoft.com/v2/devcontainers/base/tags/list | \
    jq -r '.tags[] | select(. | test("^[0-9]+\\.[0-9]+"))' | sort -V | tail -10
  ```

- **Docker Hub Alternative**: Search directly with Docker:

  ```bash
  docker search mcr.microsoft.com/devcontainers/base
  ```

#### 2. Pull and Inspect the New Version

```bash
# Pull the desired version
docker pull mcr.microsoft.com/devcontainers/base:<version>

# Get the digest
docker inspect mcr.microsoft.com/devcontainers/base:<version> \
  --format='{{index .RepoDigests 0}}'
```

#### 3. Update the Dockerfile

Edit `.devcontainer/Dockerfile` and update the `FROM` line with:

- The new version tag
- The corresponding digest (from step 2)
- The `LAST UPDATED` date in the comment block

#### 4. Test Thoroughly

```bash
# Build with no cache to ensure clean build
docker build -f .devcontainer/Dockerfile -t ubi:test . --no-cache

# Test the container
docker run -it --rm ubi:test bash
```

#### 5. Update Documentation and Changelog

- Update the base image version in `README.md` (Architecture > Key Components)
- Document the base image update in `CHANGELOG.md` by creating a new version section or note the change in your PR description for the maintainers to include in the next release
- Document any breaking changes or notable updates from the upstream base image

#### 6. When to Update

Evaluate base image updates when:

- **Security patches** are released (high priority)
- **New stable versions** are available (evaluate breaking changes)
- **Quarterly review** (best practice for staying current)
- **CI/CD issues** arise from upstream changes (investigate and update if needed)

**Note**: Always review the [devcontainers release notes](https://github.com/devcontainers/images/releases) before updating to understand what's changing.

---

## 🔒 Security Scanning

UBI includes automated container vulnerability scanning using [Trivy](https://github.com/aquasecurity/trivy) to ensure supply chain security and detect CVEs in the base image and dependencies.

### How It Works

The Trivy scanner runs automatically on:

- **Pull Requests**: Every PR is scanned to catch vulnerabilities before merging
- **Push to main**: Scans verify security after each merge
- **Weekly Schedule**: Every Monday at 00:00 UTC for continuous monitoring
- **Manual Trigger**: Can be run on-demand via GitHub Actions

### What Gets Scanned

- Base image layers and OS packages
- Installed system dependencies
- Known CVEs from the [National Vulnerability Database (NVD)](https://nvd.nist.gov/)

### CI/CD Integration

The workflow:

1. Builds the UBI image from the Dockerfile
2. Scans it with Trivy for vulnerabilities
3. **Fails the build** if critical or high-severity CVEs are found
4. Uploads results to GitHub Security tab (SARIF format)
5. Generates a human-readable report available as an artifact

### Viewing Scan Results

**GitHub Security Tab**: View all detected vulnerabilities at:  
[`https://github.com/egohygiene/ubi/security/code-scanning`](https://github.com/egohygiene/ubi/security/code-scanning)

**Workflow Artifacts**: Download detailed reports from the [Trivy Scan workflow](https://github.com/egohygiene/ubi/actions/workflows/trivy-scan.yml) runs.

### Running Trivy Locally

To scan the UBI image locally before pushing changes:

#### 1. Install Trivy

```bash
# macOS
brew install trivy

# Linux
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update && sudo apt-get install trivy

# Or use Docker
docker pull aquasec/trivy:latest
```

#### 2. Build the Image Locally

```bash
docker build -f .devcontainer/Dockerfile -t ubi:local .
```

#### 3. Scan the Image

```bash
# Basic scan (CRITICAL and HIGH only)
trivy image --severity CRITICAL,HIGH ubi:local

# Detailed scan (all severities)
trivy image ubi:local

# Generate a report
trivy image --format table --output trivy-report.txt ubi:local

# Or using Docker
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image --severity CRITICAL,HIGH ubi:local
```

#### 4. Scan Published Images

```bash
# Scan the latest published image
trivy image ghcr.io/egohygiene/ubi:latest

# Scan a specific version
trivy image ghcr.io/egohygiene/ubi:0.1.5
```

### Addressing Vulnerabilities

If the scan detects vulnerabilities:

1. **Review the findings**: Check if they're false positives or real issues
2. **Update dependencies**: Bump versions of affected packages if patches are available
3. **Update base image**: Check if a newer version of the DevContainers base image has fixes
4. **Document exceptions**: If a vulnerability can't be fixed immediately, document why and track it

### Security Best Practices

- **Pin base image versions** with digests for reproducibility (already implemented)
- **Regularly update** the base image to get security patches
- **Monitor the Security tab** for new vulnerabilities
- **Subscribe to notifications** for the repository to get alerts
- **Review weekly scan results** to stay proactive

---

## 📈 Metrics & Observability

UBI includes automated metrics collection to track image size, build performance, and layer distribution over time. This helps identify performance regressions, optimize image size, and monitor build trends.

### What Gets Tracked

- **Image Size Metrics**:
  - Compressed and uncompressed size per architecture (amd64, arm64)
  - Layer count and distribution
  - Size trends over time

- **Build Metadata**:
  - Version, commit SHA, and timestamp
  - Workflow run information
  - Build duration and runner details

- **Layer Analysis**:
  - Per-layer size breakdown
  - Command history for each layer
  - Identification of largest layers for optimization

### Accessing Metrics

Metrics are automatically collected on every tagged release and push to main:

1. **Workflow Artifacts**: Download from the [Metrics Workflow](https://github.com/egohygiene/ubi/actions/workflows/metrics.yml) runs
2. **Historical Data**: View the [`metrics/build-metrics.jsonl`](./metrics/build-metrics.jsonl) file for trends
3. **Detailed Reports**: Check version-specific reports in the `metrics/` directory

### Metrics Reports

Each build generates:

- **JSON Report** (`metrics-report.json`): Complete metrics in structured format
- **Markdown Report** (`metrics-report.md`): Human-readable summary
- **Layer Breakdown** (`layers-amd64.json`): Detailed layer analysis
- **Historical Log** (`build-metrics.jsonl`): Append-only history in JSON Lines format

### Analyzing Trends

```bash
# View latest metrics
tail -1 metrics/build-metrics.jsonl | jq '.'

# Compare sizes over time
jq -r '[.version, .timestamp, .amd64_size_mb] | @tsv' metrics/build-metrics.jsonl

# Find largest build
jq -s 'max_by(.amd64_size_mb | tonumber)' metrics/build-metrics.jsonl

# Track layer count trends
jq -r '[.version, .amd64_layer_count] | @tsv' metrics/build-metrics.jsonl
```

### Manual Collection

You can manually trigger metrics collection:

1. Go to **Actions** → **📈 Collect Build Metrics & Observability Data**
2. Click **Run workflow**
3. Optionally enable **commit_metrics** to save results to the repository

See the [metrics documentation](./metrics/README.md) for more details.

---

## ⚡ Performance Benchmarking

UBI includes automated performance benchmarking to track container startup times, resource usage, and overall performance characteristics across releases. This helps detect performance regressions and validate optimizations.

### What Gets Benchmarked

- **Startup Performance**:
  - Cold start time (no cached layers)
  - Warm start time (cached layers)
  - Time to first command execution

- **Resource Usage**:
  - CPU utilization during startup
  - Memory footprint at idle
  - Resource efficiency metrics

- **Image Characteristics**:
  - Compressed and uncompressed size
  - Layer count and distribution
  - Per-architecture metrics (amd64, arm64)

### Running Benchmarks

Benchmarks can be triggered manually or run automatically on tagged releases:

1. Go to **Actions** → **⚡ Performance Benchmarking**
2. Click **Run workflow**
3. Select the branch to benchmark (default: main)
4. Optionally enable **commit_results** to save results to the repository

### Accessing Results

Benchmark results are available in multiple formats:

1. **Workflow Artifacts**: Download from the [Benchmark Workflow](https://github.com/egohygiene/ubi/actions/workflows/benchmark.yml) runs
2. **Historical Data**: View the [`benchmarks/benchmark-results.jsonl`](./benchmarks/benchmark-results.jsonl) file for trends
3. **Detailed Reports**: Check version-specific reports in the `benchmarks/` directory

### Benchmark Reports

Each benchmark run generates:

- **JSON Report** (`benchmark-{version}.json`): Complete results in structured format
- **Markdown Report** (`benchmark-{version}.md`): Human-readable summary
- **Historical Log** (`benchmark-results.jsonl`): Append-only history in JSON Lines format

### Analyzing Performance

```bash
# View latest benchmark
tail -1 benchmarks/benchmark-results.jsonl | jq '.'

# Compare startup times over releases
jq -r '[.version, .cold_start_seconds, .warm_start_seconds] | @tsv' \
  benchmarks/benchmark-results.jsonl

# Find slowest startup
jq -s 'max_by(.cold_start_seconds)' benchmarks/benchmark-results.jsonl

# Average memory usage
jq -s 'map(.memory_mb) | add/length' benchmarks/benchmark-results.jsonl
```

### Performance Targets

These are informal goals for UBI performance:

| Metric | Target | Rationale |
|--------|--------|-----------|
| Cold Start | < 3s | Fast developer feedback |
| Warm Start | < 1s | Instant iteration |
| Memory at Idle | < 100 MB | Efficient resource usage |
| Image Size | < 500 MB | Reasonable download time |

See the [benchmarks documentation](./benchmarks/README.md) for more details.

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
- Document your changes in your PR description; the CHANGELOG.md is updated automatically during releases
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

## 📚 Documentation

**[📖 Visit the full documentation site →](https://egohygiene.github.io/ubi/)**

Comprehensive documentation is also available in the [docs/](./docs/) directory:

- **[Architecture](./docs/architecture.md)** - Design, XDG strategy, filesystem layout, and CI/CD
- **[Troubleshooting](./docs/troubleshooting.md)** - Common issues and solutions
- **[Release Process](./docs/release-process.md)** - Version management and publishing workflow
- **[Security Overview](./docs/security-overview.md)** - Security practices, scanning, and SBOM

See the [Documentation Index](./docs/README.md) for a complete overview.

---

## 📬 Support

- **Issues**: [github.com/egohygiene/ubi/issues](https://github.com/egohygiene/ubi/issues)
- **Discussions**: [github.com/egohygiene/ubi/discussions](https://github.com/egohygiene/ubi/discussions)
- **Documentation**: [egohygiene.github.io/ubi](https://egohygiene.github.io/ubi/)
- **Organization**: [github.com/egohygiene](https://github.com/egohygiene)

---

<div align="center">

**[⬆ back to top](#-ubi---universal-base-image)**

Made with 🛠️ by Ego Hygiene | Powered by 🌐 Universal Base Image

</div>

</div>

<!-- Badge References -->
[build-badge]: https://img.shields.io/github/actions/workflow/status/egohygiene/ubi/publish.yml?style=for-the-badge
[build-link]: https://github.com/egohygiene/ubi/actions/workflows/publish.yml

[security-badge]: https://img.shields.io/github/actions/workflow/status/egohygiene/ubi/trivy-scan.yml?style=for-the-badge&label=security
[security-link]: https://github.com/egohygiene/ubi/actions/workflows/trivy-scan.yml

[version-badge]: https://img.shields.io/github/v/tag/egohygiene/ubi?sort=semver&style=for-the-badge
[version-link]: https://github.com/egohygiene/ubi/tags

[registry-badge]: https://img.shields.io/badge/ghcr.io-egohygiene%2Fubi-brightgreen.svg?style=for-the-badge
[registry-link]: https://ghcr.io/egohygiene/ubi

[license-badge]: https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge
[license-link]: https://opensource.org/licenses/MIT
