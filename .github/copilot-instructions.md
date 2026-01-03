# Copilot Instructions for UBI

This file provides context and guidelines for GitHub Copilot when working in the UBI (Universal Base Image) repository.

## Project Overview

**UBI (Universal Base Image)** is the foundational container environment for all Ego Hygiene projects. It provides a reproducible, stable, and developer-experience-optimized foundation that every devcontainer and project in the organization builds upon.

### Purpose
- **Consistency**: Every developer works in an identical environment
- **Reproducibility**: Builds are deterministic and versioned
- **Developer Happiness**: Pre-configured with sensible defaults and modern tooling
- **Maintainability**: Update the base once, benefit everywhere

### Distribution
- Published to GitHub Container Registry (GHCR) at `ghcr.io/egohygiene/ubi`
- Follows Semantic Versioning (SemVer): `MAJOR.MINOR.PATCH`
- Base image: `mcr.microsoft.com/devcontainers/base`

## Tech Stack & Tooling

### Core Technologies
- **Container**: Docker-based container image
- **Base**: Microsoft DevContainers base image (pinned with digest)
- **Package Management**: Poetry (Python project metadata)
- **Version Management**: bump-my-version (automated version bumping)
- **CI/CD**: GitHub Actions

### Python Tools (for automation/scripts)
- **Python**: 3.12+
- **Linting**: Ruff (comprehensive linting rules)
- **Formatting**: Black (88 character line length)
- **Configuration**: pyproject.toml

### Other Tools
- **Security Scanning**: Trivy (container vulnerability scanning)
- **Image Signing**: Cosign (Sigstore keyless signing)
- **Linting**: actionlint (GitHub Actions), ShellCheck (shell scripts), Prettier (YAML/JSON/Markdown)

## Directory Structure

```
/
├── .devcontainer/          # Devcontainer configuration
│   ├── Dockerfile          # Main UBI Dockerfile (source of truth)
│   ├── devcontainer.json   # VS Code devcontainer config
│   └── docker-compose.yml  # Docker Compose config
├── .github/
│   ├── workflows/          # CI/CD workflows
│   │   ├── publish.yml     # Image build & publish
│   │   ├── test-unified.yml # Unified container testing (Goss + image validation)
│   │   ├── trivy-scan.yml  # Security scanning
│   │   ├── sanity.yml      # Basic CI sanity check
│   │   ├── bump-version.yml # Automated version bumps
│   │   ├── validate-changelog.yml # CHANGELOG validation
│   │   ├── copilot-setup-steps.yml # Copilot Agent environment setup
│   │   └── validate-copilot-setup.yml # Copilot setup validation
│   ├── linters/            # Linter configurations
│   ├── pull_request_template.md
│   ├── CODEOWNERS
│   ├── COPILOT_ALLOWLIST.md # Domain allowlist for Copilot Agents
│   ├── copilot-instructions.md # This file
│   └── FUNDING.yml
├── docs/                   # Documentation
│   ├── README.md           # Documentation index
│   ├── architecture.md     # Architecture & design
│   ├── release-process.md  # Release workflow
│   ├── security-overview.md # Security practices
│   ├── troubleshooting.md  # Common issues
│   ├── best-practices/     # Best practices guides
│   ├── contributing/       # Contributing guides
│   ├── examples/           # Example configurations
│   └── security/           # Security documentation
├── audit/                  # Audit logs and reports
├── README.md               # Main project README
├── CONTRIBUTING.md         # Contributor guide
├── CHANGELOG.md            # Release changelog
├── SECURITY.md             # Security policy
├── VERSION                 # Single source of truth for version (e.g., "0.1.5")
├── pyproject.toml          # Python project & tool configuration
├── poetry.toml             # Poetry configuration
└── ubi.code-workspace      # VS Code workspace config
```

### Key Concepts

#### XDG Directory Structure
UBI implements the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) with a `/opt/universal/*` hierarchy:

- `/opt/universal/bin` - Universal binaries (XDG_BIN_HOME)
- `/opt/universal/config` - Configuration files (XDG_CONFIG_HOME)
- `/opt/universal/cache` - Cache directory (XDG_CACHE_HOME)
- `/opt/universal/toolbox` - Data files (XDG_DATA_HOME)
- `/opt/universal/runtime` - Runtime state (XDG_STATE_HOME)
- `/opt/universal/logs` - Centralized logs
- `/opt/universal/apps` - Application resources
- And more...

#### Versioning
- **VERSION file**: Single source of truth (e.g., `0.1.5`)
- **pyproject.toml**: Contains Poetry version and bump-my-version config
- **CHANGELOG.md**: Automatically updated by bump-my-version
- All three files must stay in sync

## Development Workflow

### Local Development
1. **Clone the repository**
   ```bash
   git clone https://github.com/egohygiene/ubi.git
   cd ubi
   ```

2. **Open in VS Code with devcontainer** (recommended)
   - VS Code will detect `.devcontainer/devcontainer.json`
   - Choose "Reopen in Container"

3. **Or build locally**
   ```bash
   docker build -f .devcontainer/Dockerfile -t ubi:local .
   docker run -it --rm ubi:local bash
   ```

### Making Changes

#### For Dockerfile Changes
1. Edit `.devcontainer/Dockerfile`
2. Build locally to test: `docker build -f .devcontainer/Dockerfile -t ubi:test .`
3. Test the image: `docker run -it --rm ubi:test bash`
4. Verify environment variables and directory structure
5. Submit PR

#### For Documentation Changes
1. Edit relevant `.md` files in `docs/` or root
2. Follow markdown conventions (ATX headers, fenced code blocks)
3. Test locally if rendering is important
4. Submit PR

#### For CI/CD Workflow Changes
1. Edit files in `.github/workflows/`
2. Use actionlint for validation: `actionlint`
3. Test changes in a feature branch
4. Submit PR

### Branching Strategy
- **`main` branch**: Primary branch, always stable
- **Feature branches**: `feature/<name>` or `fix/<name>`
- **Trunk-based development**: Short-lived feature branches

### Version Bumping
**Use bump-my-version** to ensure all version files stay in sync:

```bash
# Dry run first (recommended)
bump-my-version bump patch --dry-run --verbose

# Actual bump
bump-my-version bump patch  # 0.1.5 → 0.1.6
bump-my-version bump minor  # 0.1.5 → 0.2.0
bump-my-version bump major  # 0.1.5 → 1.0.0
```

**What happens:**
1. VERSION file is updated
2. pyproject.toml is updated
3. CHANGELOG.md gets a new version section
4. Git commit is created (no tag - handled by CI)

**Or use GitHub Actions:**
- Go to Actions → "🔼 Bump UBI Version" → "Run workflow"
- Select bump type and run

### Testing

#### Local Testing
```bash
# Build the image
docker build -f .devcontainer/Dockerfile -t ubi:test .

# Run sanity checks
docker run --rm ubi:test bash -c 'ls -la /opt/universal/ && echo $XDG_CONFIG_HOME'

# Test directory structure
docker run --rm ubi:test bash -c '
  test -d /opt/universal/bin &&
  test -d /opt/universal/config &&
  test -d /opt/universal/cache &&
  echo "✅ All directories exist!"
'
```

#### CI/CD Testing
- **Unified Container Testing**: `.github/workflows/test-unified.yml` (runs on PRs and pushes, includes Goss validation and image sanity tests)
- **Security Scanning**: `.github/workflows/trivy-scan.yml` (runs on PRs, pushes, and weekly)
- **CHANGELOG Validation**: `.github/workflows/validate-changelog.yml`

### Linting & Formatting

#### Python Code
```bash
# Lint with Ruff
ruff check .
ruff check . --fix  # Auto-fix

# Format with Black
black .
black . --check  # Check only
```

#### Other Files
- **Shell scripts**: Use ShellCheck
- **YAML/JSON/Markdown**: Use Prettier
- **GitHub Actions**: Use actionlint

## Code Style & Conventions

### Python
- **Line length**: 88 characters
- **Docstring style**: Google-style
- **Naming**:
  - `snake_case` for functions and variables
  - `PascalCase` for classes
  - `UPPER_CASE` for constants
- **Type hints**: Required for function signatures
- **Imports**: Sorted and organized by Ruff

### Commit Messages
Follow **Conventional Commits**:
```
<type>(<scope>): <short summary>

<optional body>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`

**Examples:**
- `feat(environment): add custom SHELL environment variable`
- `fix(dockerfile): correct XDG_STATE_HOME path`
- `docs(readme): update installation instructions`
- `chore: bump version to 0.2.0`

### File Naming
- **Python**: `snake_case.py`
- **Markdown (top-level)**: `UPPER_CASE.md` (e.g., `README.md`, `CONTRIBUTING.md`)
- **Markdown (nested)**: `kebab-case.md` (e.g., `docs/quick-start.md`)
- **Dockerfiles**: `Dockerfile` (capitalized, no extension)
- **Shell scripts**: `kebab-case.sh` or no extension

## Pull Request Guidelines

### PR Expectations
1. **Use the PR template** (`.github/pull_request_template.md`)
2. **Keep changes focused**: One PR = One logical change
3. **Test your changes**: Build locally and verify
4. **Update documentation**: If changes affect user-facing behavior
5. **DO NOT bump version or edit CHANGELOG**: Describe changes in PR description instead

### Required Checks
All PRs must pass:
1. **🧪 Unified Container Testing Workflow** (`.github/workflows/test-unified.yml`): Comprehensive container tests including Goss validation, directory structure, XDG environment variables, permissions, locale, and fundamental tools across all variants
2. **🔒 Trivy Security Scan** (`.github/workflows/trivy-scan.yml`): Vulnerability scanning
3. **📋 CHANGELOG Validation** (`.github/workflows/validate-changelog.yml`): Format validation
4. **🛡️ GitHub Code Scanning**: Security and quality checks

## Important Guidelines

### When Editing the Dockerfile
- **Base image**: Always pinned with digest for reproducibility
- **Multi-stage build**: Organized into `base`, `environment`, and `final` stages
- **Environment variables**: Extensive ENV vars for consistent behavior
- **XDG compliance**: Maintain `/opt/universal/*` hierarchy
- **Test thoroughly**: Build and test locally before submitting

### When Updating Dependencies
- **Base image updates**: Follow process in CONTRIBUTING.md
  1. Check for new releases
  2. Pull and inspect new version
  3. Update Dockerfile with new version and digest
  4. Test thoroughly
  5. Update documentation and CHANGELOG
- **Python dependencies**: Update via Poetry

### Version Bumping Rules
- **MAJOR**: Breaking changes to environment or filesystem structure
- **MINOR**: New features, tools, or non-breaking enhancements
- **PATCH**: Bug fixes and minor updates
- **Always use bump-my-version**: Never manually edit VERSION, pyproject.toml, or CHANGELOG.md

### Security Considerations
- **Never commit secrets**: Passwords, API keys, tokens
- **Use pinned base images**: With digests (already implemented)
- **Address Trivy findings**: Fix HIGH/CRITICAL vulnerabilities
- **Report vulnerabilities**: Use GitHub Security Advisories or email security@egohygiene.com

## Release Process

### Automated Pipeline
1. **Version bump**: Via bump-my-version (local or GitHub Actions)
2. **Push to main**: Triggers publish workflow
3. **Workflow steps**:
   - Builds UBI image
   - Runs tests
   - Scans for vulnerabilities
   - Publishes to GHCR
   - Tags image: `latest`, `X.Y.Z`, `sha-<commit>`
   - Signs image with Cosign

### Published Tags
- `ghcr.io/egohygiene/ubi:latest` - Most recent stable release
- `ghcr.io/egohygiene/ubi:X.Y.Z` - Specific version (pinned)
- `ghcr.io/egohygiene/ubi:sha-<commit>` - Git commit SHA (exact reproducibility)

## Common Tasks for Copilot

### Adding a New Environment Variable
1. Edit `.devcontainer/Dockerfile`
2. Add `ENV` statement in appropriate section
3. Document in README.md if user-facing
4. Test locally
5. Submit PR

### Updating the Base Image
1. Find new version on [devcontainers/images releases](https://github.com/devcontainers/images/releases)
2. Pull new version: `docker pull mcr.microsoft.com/devcontainers/base:<version>`
3. Get digest: `docker inspect mcr.microsoft.com/devcontainers/base:<version> --format='{{index .RepoDigests 0}}'`
4. Update Dockerfile `FROM` line with new version and digest
5. Update "LAST UPDATED" comment
6. Test thoroughly with `--no-cache`
7. Update README.md and document in PR description

### Adding Documentation
1. Determine appropriate location (`docs/` or root)
2. Follow existing markdown style and conventions
3. Add to `docs/README.md` index if adding new doc
4. Use relative links for internal docs
5. Submit PR

### Fixing Security Vulnerabilities
1. Review Trivy scan results
2. Identify affected package or dependency
3. Check if newer version has fix
4. Update dependency or base image
5. Re-run Trivy locally: `trivy image ubi:local`
6. Document fix in PR description
7. Submit PR

## Copilot Agent Environment

### Overview
This repository has a pre-configured Copilot Agent environment that ensures all required tools are available before the Copilot firewall activates. This enables automated workflows without network access errors.

### Key Workflows
- **copilot-setup-steps.yml**: Installs all tools before Copilot Agent execution
  - Language runtimes: Node.js 20, Python 3.12
  - Package managers: npm, Poetry, pip
  - Testing tools: Goss, dgoss
  - Security scanners: Trivy
  - Linters: Hadolint, actionlint, ShellCheck
  - Utilities: jq, yq, Cosign, bump-my-version
  
- **validate-copilot-setup.yml**: Validates the setup configuration
  - Runs weekly and on workflow changes
  - Tests tool installations and functionality
  - Verifies firewall configuration

### Caching Strategy
- npm: Cached via `actions/setup-node@v4` with `cache: 'npm'`
- Python/pip: Cached via `actions/setup-python@v5` with `cache: 'pip'`
- Poetry: Virtual environment cached with `actions/cache@v4`
- Results in 30-50% faster workflow execution

### Documentation
- **docs/dev/copilot-environment.md**: Complete environment documentation
- **.github/COPILOT_ALLOWLIST.md**: Domain allowlist configuration
- **README.md**: Copilot Agent Automation section

### Important Notes
- The job in copilot-setup-steps.yml MUST be named `copilot-setup-steps`
- All tools are installed before Copilot's firewall activates
- Tool versions are pinned for reproducibility
- Domain allowlist must be configured by repository admins

## Documentation Resources

- **README.md**: Main project documentation
- **CONTRIBUTING.md**: Contributor guide with detailed workflows
- **docs/architecture.md**: Design, XDG strategy, filesystem layout
- **docs/security-overview.md**: Security practices, scanning, SBOM
- **docs/release-process.md**: Version management and publishing
- **docs/troubleshooting.md**: Common issues and solutions
- **docs/dev/copilot-environment.md**: Copilot Agent environment setup

## Getting Help

- **Issues**: https://github.com/egohygiene/ubi/issues
- **Discussions**: https://github.com/egohygiene/ubi/discussions
- **Security**: https://github.com/egohygiene/ubi/security/advisories/new

---

This file helps GitHub Copilot provide better suggestions by understanding the project's context, conventions, and workflows. Keep it updated as the project evolves.
