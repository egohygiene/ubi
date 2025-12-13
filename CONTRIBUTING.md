# Contributing to UBI

Thank you for your interest in contributing to **UBI (Universal Base Image)**! 🎉

This document provides comprehensive guidance on how to contribute to the project, including setup instructions, development workflows, coding standards, and release processes.

---

## Table of Contents

- [How to Work in This Repo](#how-to-work-in-this-repo)
  - [Prerequisites](#prerequisites)
  - [Cloning the Repository](#cloning-the-repository)
  - [Opening in VS Code with Devcontainer](#opening-in-vs-code-with-devcontainer)
  - [Recommended Extensions](#recommended-extensions)
  - [Local Container Builds](#local-container-builds)
- [Versioning Workflow](#versioning-workflow)
  - [How VERSION and pyproject.toml Interact](#how-version-and-pyprojecttoml-interact)
  - [Manual Version Bumps](#manual-version-bumps)
  - [Automated Release Pipeline](#automated-release-pipeline)
- [Development Workflow](#development-workflow)
  - [Running Tests](#running-tests)
  - [Linting and Formatting](#linting-and-formatting)
  - [Updating CHANGELOG](#updating-changelog)
  - [Commit Message Conventions](#commit-message-conventions)
- [Pull Requests](#pull-requests)
  - [PR Expectations](#pr-expectations)
  - [Required Checks](#required-checks)
  - [Review Process](#review-process)
  - [Branching Strategy](#branching-strategy)
- [Style Guides](#style-guides)
  - [Python Style](#python-style)
  - [File Naming Conventions](#file-naming-conventions)
  - [Documentation Standards](#documentation-standards)
    - [Building Documentation](#building-documentation)
- [Local Build and Test Commands](#local-build-and-test-commands)
  - [Docker Build Commands](#docker-build-commands)
  - [Bump-my-version Dry-Runs](#bump-my-version-dry-runs)
  - [Devcontainer Troubleshooting](#devcontainer-troubleshooting)
- [Security and Reporting](#security-and-reporting)
- [Getting Help](#getting-help)

---

## How to Work in This Repo

### Prerequisites

Before you begin, ensure you have the following installed:

- **Git**: For version control
- **Docker**: For building and testing container images
- **Visual Studio Code**: Recommended IDE for devcontainer support
- **VS Code Remote - Containers Extension**: For working with devcontainers

### Cloning the Repository

```bash
# Clone the repository
git clone https://github.com/egohygiene/ubi.git

# Navigate into the repository
cd ubi
```

### Opening in VS Code with Devcontainer

UBI uses VS Code devcontainers to provide a consistent development environment. This approach is **highly recommended** as it ensures all developers work in an identical environment.

#### Steps

1. **Open VS Code** in the repository directory:

   ```bash
   code .
   ```

2. **Reopen in Container**:
   - VS Code should detect the `.devcontainer` configuration and prompt you to **"Reopen in Container"**
   - Click the prompt, or manually trigger it via the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`):
     - Select: **"Dev Containers: Reopen in Container"**

3. **Wait for Build**:
   - The first time, VS Code will build the devcontainer image (this may take a few minutes)
   - Subsequent launches will be much faster

4. **Verify Setup**:
   - Once inside the container, open a terminal in VS Code
   - Verify the environment:

     ```bash
     echo $XDG_CONFIG_HOME  # Should output /opt/universal/config
     ls -la /opt/universal/  # Should show the UBI directory structure
     ```

### Recommended Extensions

The repository includes a list of recommended VS Code extensions in `.vscode/extensions.json`. These will be suggested automatically when you open the project:

**Key Extensions:**

- **Code Spell Checker**: Spell checking for code and docs
- **EditorConfig**: Enforce consistent coding styles
- **Prettier**: Code formatting for YAML, JSON, Markdown, etc.
- **GitHub Actions**: Syntax highlighting and validation for workflows
- **ShellCheck**: Linting for shell scripts
- **Even Better TOML**: Enhanced support for `pyproject.toml`
- **YAML**: YAML language support with schema validation

Install all recommended extensions by:

1. Opening the Extensions view (`Ctrl+Shift+X` / `Cmd+Shift+X`)
2. Typing `@recommended` in the search bar
3. Installing all suggested extensions

### Local Container Builds

To build the UBI container image locally for testing:

```bash
# Build the image
docker build -f .devcontainer/Dockerfile -t ubi:local .

# Test the image interactively
docker run -it --rm ubi:local bash

# Inside the container, verify the environment
ls -la /opt/universal/
echo $XDG_CONFIG_HOME
```

---

## Versioning Workflow

UBI follows **Semantic Versioning (SemVer)**: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes to the environment or filesystem structure
- **MINOR**: New features, tools, or non-breaking enhancements
- **PATCH**: Bug fixes and minor updates

### How VERSION and pyproject.toml Interact

UBI uses **three interconnected version sources**:

1. **`VERSION` file** (root of repository):
   - The **single source of truth** for the current version
   - Contains only the version number (e.g., `0.1.5`)

2. **`pyproject.toml`**:
   - Contains Poetry metadata (`tool.poetry.version`)
   - Contains bump-my-version configuration (`tool.bumpversion`)
   - Both sections **must stay in sync** with the VERSION file

3. **`CHANGELOG.md`**:
   - Automatically updated by bump-my-version to add new version sections

### Manual Version Bumps

Use **bump-my-version** to bump the version locally and ensure all files stay synchronized.

#### Installation

```bash
# Install bump-my-version
pip install bump-my-version
```

#### Bump Commands

**Always test with a dry-run first (recommended!):**

```bash
# Dry-run to preview a patch bump (0.1.5 → 0.1.6)
bump-my-version bump patch --dry-run --verbose

# Dry-run to preview a minor bump (0.1.5 → 0.2.0)
bump-my-version bump minor --dry-run --verbose

# Dry-run to preview a major bump (0.1.5 → 1.0.0)
bump-my-version bump major --dry-run --verbose
```

**After verifying the dry-run, execute the actual bump:**

```bash
# Bump patch version (0.1.5 → 0.1.6)
bump-my-version bump patch

# Bump minor version (0.1.5 → 0.2.0)
bump-my-version bump minor

# Bump major version (0.1.5 → 1.0.0)
bump-my-version bump major
```

#### What Happens During a Bump

When you run `bump-my-version bump <type>`:

1. **VERSION file** is updated with the new version
2. **CHANGELOG.md** gets a new version section prepended at the top
3. A **git commit** is created with message: `chore: bump version to X.Y.Z`
4. **No git tag is created** (tagging is handled by CI/CD)

### Automated Release Pipeline

UBI uses GitHub Actions to automate the release process:

#### Option 1: Trigger Manual Bump via GitHub Actions

1. Go to: **Actions** → **"🔼 Bump UBI Version"** workflow
2. Click **"Run workflow"**
3. Select bump type: `major`, `minor`, or `patch`
4. Click **"Run workflow"**

**What happens:**

- The workflow runs `bump-my-version`
- Commits and tags the new version
- Pushes the commit and tag to `main`
- Triggers the **"🚀 Publish UBI Image"** workflow automatically

#### Option 2: Manual Local Bump + Push

If you prefer to bump locally:

```bash
# Bump version locally
bump-my-version bump patch

# Push the commit and tags
git push origin main --follow-tags
```

**What happens:**

- The push triggers the **"🚀 Publish UBI Image"** workflow
- The image is built and published to GHCR with tags:
  - `ghcr.io/egohygiene/ubi:latest`
  - `ghcr.io/egohygiene/ubi:X.Y.Z` (specific version)
  - `ghcr.io/egohygiene/ubi:sha-<commit>` (git SHA)

#### Option 3: Automated Semantic Release (Recommended)

UBI now supports **semantic-release** for fully automated versioning and CHANGELOG management based on commit messages.

**How it works:**

1. **Commit using Conventional Commits** (see [Commit Message Conventions](#commit-message-conventions)):
   - `feat:` → triggers a **minor** version bump (0.1.5 → 0.2.0)
   - `fix:`, `perf:`, `refactor:` → triggers a **patch** version bump (0.1.5 → 0.1.6)
   - `BREAKING CHANGE:` in commit body → triggers a **major** version bump (0.1.5 → 1.0.0)
   - `docs:`, `style:`, `chore:`, `test:`, `ci:` → no version bump

2. **Push to main branch**:
   - The **"🤖 Semantic Release"** workflow automatically runs
   - Analyzes commits since the last release
   - Determines the next version based on commit types
   - Updates `VERSION`, `CHANGELOG.md`, and `package.json`
   - Creates a git tag and GitHub release
   - Triggers the **"🚀 Publish UBI Image"** workflow

**Example workflow:**

```bash
# Make changes and commit with conventional format
git commit -m "feat(environment): add custom cache directory support"
git commit -m "fix(dockerfile): correct permissions for /opt/universal/bin"

# Push to main (or merge PR to main)
git push origin main

# semantic-release automatically:
# - Detects 1 feat + 1 fix = minor version bump
# - Updates VERSION from 0.1.5 → 0.2.0
# - Generates CHANGELOG.md entry with commit details
# - Creates tag 0.2.0 and GitHub release
# - Triggers image publish workflow
```

**Benefits:**

- **Zero manual intervention** for versioning
- **Automatic CHANGELOG** generation from commits
- **Consistent releases** based on commit history
- **GitHub Releases** with detailed release notes
- **Enforces conventional commits** for clear history

**Testing semantic-release locally:**

```bash
# Install dependencies
npm install

# Dry-run to see what would happen (without making changes)
npx semantic-release --dry-run --no-ci

# Check commit messages locally
npx semantic-release --dry-run --branches $(git branch --show-current)
```

---

## Development Workflow

### Running Tests

UBI includes automated image testing via the **"🧪 Image Testing Workflow"** (`.github/workflows/test-image.yml`).

#### Tests Included

1. **Universal Directory Structure**: Validates `/opt/universal/*` paths exist
2. **Environment Variables**: Checks XDG paths and other ENV vars
3. **Sanity Checks**: Confirms basic container functionality

#### Run Tests Locally

```bash
# Build the image
docker build -f .devcontainer/Dockerfile -t ubi:test .

# Run basic sanity checks
docker run --rm ubi:test bash -c 'ls -la /opt/universal/ && echo $XDG_CONFIG_HOME'

# Run a more comprehensive test
docker run --rm ubi:test bash -c '
  set -e
  echo "Testing /opt/universal/* structure..."
  test -d /opt/universal/bin
  test -d /opt/universal/config
  test -d /opt/universal/cache
  test -d /opt/universal/toolbox
  test -d /opt/universal/runtime
  test -d /opt/universal/logs
  test -d /opt/universal/apps
  echo "✅ All directories exist!"
'
```

#### CI/CD Tests

Tests run automatically on:

- **Pull Requests** to `main`
- **Pushes** to `main`
- **Tagged releases**

### Linting and Formatting

UBI uses **Ruff** and **Black** for Python code quality, and various linters for other file types. We also use **pre-commit hooks** to automatically check your code before committing.

#### Pre-Commit Hooks (Recommended)

Pre-commit hooks automatically run linting and formatting checks before you commit changes, catching issues early and ensuring consistent code quality.

**Installation:**

```bash
# Install pre-commit (if not already installed)
pip install pre-commit

# Install the git hooks
pre-commit install
```

**Usage:**

Once installed, pre-commit will automatically run on every `git commit`. You can also run it manually:

```bash
# Run on all files
pre-commit run --all-files

# Run on staged files only
pre-commit run

# Run a specific hook
pre-commit run <hook-id>

# Update hooks to latest versions
pre-commit autoupdate
```

**What hooks are included:**

- **Core formatting**: trailing whitespace, end-of-file fixes, line ending normalization
- **File checks**: large files, merge conflicts, YAML/JSON/TOML syntax
- **YAML linting**: yamllint with custom rules
- **Markdown linting**: markdownlint for documentation
- **Dockerfile linting**: hadolint for container best practices
- **Shell script linting**: shellcheck (when shell scripts are present)
- **Python**: Black formatting and Ruff linting
- **Secrets detection**: detect-secrets to prevent committing sensitive data

**Bypassing hooks (not recommended):**

If you absolutely need to bypass hooks (e.g., for a work-in-progress commit):

```bash
git commit --no-verify
```

**Note:** CI may still enforce these checks, so it's better to fix issues locally.

#### Python Linting with Ruff

```bash
# Lint all Python files
ruff check .

# Auto-fix issues
ruff check . --fix

# Check specific file
ruff check path/to/file.py
```

#### Python Formatting with Black

```bash
# Format all Python files
black .

# Check formatting without making changes
black . --check

# Format specific file
black path/to/file.py
```

#### Configuration

Both Ruff and Black are configured in `pyproject.toml`:

- **Line length**: 88 characters
- **Target Python**: 3.12+
- **Ruff**: Enforces comprehensive linting rules (PEP8, security, best practices)
- **Black**: Google-style docstrings via Ruff

#### Other Linters

- **ShellCheck**: For shell scripts (runs automatically in VS Code if extension is installed)
- **Prettier**: For YAML, JSON, Markdown (configured in `.vscode/settings.json`)
- **actionlint**: For GitHub Actions workflows (see `.github/actionlint.yaml`)

### Updating CHANGELOG

The `CHANGELOG.md` is automatically updated by **bump-my-version** when you bump the version.

#### Workflow

1. **Make your changes** and commit them to a feature branch
2. **Open a Pull Request**
3. **In your PR description**, document your changes clearly
4. **When ready to release**, run `bump-my-version` (locally or via GitHub Actions)
5. **bump-my-version will automatically**:
   - Add a new version section at the top of `CHANGELOG.md`
   - Include the date and a comparison link
   - Commit the changes

#### Manual CHANGELOG Edits

If you need to manually edit the CHANGELOG (e.g., adding more detailed release notes):

1. **Wait until after the version bump** (so the version section exists)
2. Edit the CHANGELOG to add details under the appropriate categories:
   - **Added**: New features
   - **Changed**: Changes to existing functionality
   - **Deprecated**: Soon-to-be removed features
   - **Removed**: Removed features
   - **Fixed**: Bug fixes
   - **Security**: Security improvements
3. Commit your CHANGELOG edits separately

**Example CHANGELOG entry:**

```markdown
## 0.2.0 (2025-12-15)
[Compare the full difference.](https://github.com/egohygiene/ubi/compare/0.1.5...0.2.0)

### Added
- New environment variable for custom cache location
- Support for additional XDG directories

### Changed
- Updated base image to DevContainers 2.2.0
- Improved directory permission handling

### Fixed
- Fixed PATH ordering for /opt/universal/bin
```

### Commit Message Conventions

UBI follows **Conventional Commits** for clear and consistent commit history. This is **especially important** with semantic-release, as commit messages directly determine version bumps and CHANGELOG entries.

#### Format

```
<type>(<scope>): <short summary>

<optional body>

<optional footer>
```

#### Types (and their semantic-release impact)

- `feat`: New feature → **minor** version bump (0.1.5 → 0.2.0)
- `fix`: Bug fix → **patch** version bump (0.1.5 → 0.1.6)
- `perf`: Performance improvement → **patch** version bump
- `refactor`: Code refactoring → **patch** version bump
- `docs`: Documentation changes → **no** version bump
- `style`: Code style changes (formatting) → **no** version bump
- `test`: Adding or updating tests → **no** version bump
- `chore`: Maintenance tasks → **no** version bump
- `ci`: CI/CD changes → **no** version bump
- `build`: Build system changes → **patch** version bump

#### Breaking Changes

To trigger a **major** version bump (0.1.5 → 1.0.0), include `BREAKING CHANGE:` in the commit body or footer:

```
feat(api)!: remove deprecated endpoints

BREAKING CHANGE: The /v1/old-endpoint has been removed. Use /v2/new-endpoint instead.
```

Or use the `!` suffix:

```
feat(api)!: redesign authentication flow
```

#### Examples

```bash
# New feature
git commit -m "feat(environment): add custom SHELL environment variable"

# Bug fix
git commit -m "fix(dockerfile): correct XDG_STATE_HOME path"

# Documentation
git commit -m "docs(readme): update installation instructions"

# Chore (bump handled automatically by bump-my-version)
git commit -m "chore: bump version to 0.2.0"

# CI change
git commit -m "ci(publish): add support for multi-arch builds"
```

---

## Pull Requests

### PR Expectations

When submitting a Pull Request, please:

1. **Use the PR template** (`.github/pull_request_template.md`):
   - Provide a clear description of your changes
   - Mark the type of change (bug fix, feature, docs, etc.)
   - Complete the checklist

2. **Keep changes focused**:
   - One PR = One logical change
   - Avoid mixing unrelated changes

3. **Test your changes**:
   - Build the image locally and verify it works
   - Run relevant tests
   - Document how you tested

4. **Update documentation**:
   - Update `README.md` if your changes affect user-facing behavior
   - Update this `CONTRIBUTING.md` if you change development workflows
   - Document changes in your PR description for CHANGELOG updates

5. **Version and CHANGELOG**:
   - **Do NOT** bump the version in your PR
   - **Do NOT** manually add entries to CHANGELOG.md
   - **Instead**: Clearly describe your changes in the PR description
   - Maintainers will handle version bumps and CHANGELOG updates during release

### Required Checks

All PRs must pass the following automated checks:

1. **🧪 Image Testing Workflow** (`.github/workflows/test-image.yml`):
   - Builds the UBI image
   - Runs container sanity tests
   - Validates directory structure and environment

2. **🔒 Trivy Security Scan** (`.github/workflows/trivy-scan.yml`):
   - Scans for vulnerabilities in base image and dependencies
   - Fails on CRITICAL or HIGH severity issues

3. **📋 CHANGELOG Validation** (`.github/workflows/validate-changelog.yml`):
   - Ensures CHANGELOG.md follows the expected format

4. **🛡️ GitHub Code Scanning**:
   - Automated security and quality checks

### Review Process

1. **Submit your PR**:
   - Push your branch to GitHub
   - Open a PR against `main`
   - Fill out the PR template

2. **Automated checks run**:
   - Wait for all CI/CD checks to pass (green checkmarks)
   - Fix any failing checks

3. **Code review**:
   - A maintainer will review your PR
   - Address any requested changes
   - Push additional commits to your branch

4. **Approval and merge**:
   - Once approved and all checks pass, a maintainer will merge your PR
   - Your changes will be included in the next release

### Branching Strategy

UBI uses a simple **trunk-based development** workflow:

- **`main` branch**: The primary branch, always stable and deployable
- **Feature branches**: Created from `main` for new work
  - Naming: `feature/<descriptive-name>` or `fix/<descriptive-name>`
  - Example: `feature/add-node-env`, `fix/xdg-permissions`
- **No long-lived branches**: Feature branches are short-lived and merged quickly

#### Workflow

```bash
# Create a feature branch from main
git checkout main
git pull origin main
git checkout -b feature/my-new-feature

# Make your changes and commit
git add .
git commit -m "feat(feature): add my new feature"

# Push your branch
git push origin feature/my-new-feature

# Open a PR on GitHub
```

---

## Style Guides

### Python Style

UBI enforces Python code quality using **Black** and **Ruff**.

#### Black (Formatter)

- **Line length**: 88 characters
- **Style**: Opinionated, minimal configuration
- **Run**: `black .`

#### Ruff (Linter)

- **Comprehensive rules**: PEP8, security, best practices, import sorting
- **Docstring style**: Google-style
- **Configuration**: Defined in `pyproject.toml`
- **Run**: `ruff check .` (or `ruff check . --fix` for auto-fixes)

#### Key Guidelines

- Use type hints for function signatures
- Write docstrings for all public functions, classes, and modules
- Follow PEP8 naming conventions:
  - `snake_case` for functions and variables
  - `PascalCase` for classes
  - `UPPER_CASE` for constants
- Avoid mutable default arguments
- Use `pathlib` for file path operations

### File Naming Conventions

- **Python files**: `snake_case.py`
- **Markdown files**: `UPPER_CASE.md` for top-level docs (e.g., `README.md`, `CONTRIBUTING.md`)
- **Markdown files**: `kebab-case.md` for nested docs (e.g., `docs/quick-start.md`)
- **Configuration files**: Follow standard conventions:
  - `.gitignore`, `.dockerignore`, `.prettierrc`, etc.
  - `pyproject.toml`, `poetry.toml`, etc.
- **Dockerfiles**: `Dockerfile` (capitalized, no extension)
- **Shell scripts**: `kebab-case.sh` or no extension if executable

### Documentation Standards

- **Markdown files**:
  - Use ATX-style headers (`#`, `##`, `###`)
  - One blank line before and after headers
  - Use fenced code blocks with language specifiers
  - Use relative links for internal docs
  - Keep line length reasonable (~80-100 characters for readability)

- **Code comments**:
  - Use comments sparingly — write self-documenting code
  - Explain **why**, not **what** (the code shows what it does)
  - Use `TODO:` for known issues or planned improvements
  - Use `FIXME:` for bugs that need fixing

- **Docstrings**:
  - Use Google-style docstrings for Python
  - Include:
    - Brief one-line summary
    - Detailed description (if needed)
    - `Args:` section for parameters
    - `Returns:` section for return values
    - `Raises:` section for exceptions

**Example Python docstring:**

```python
def calculate_xdg_path(base: str, subdir: str) -> str:
    """Calculate the full XDG directory path.

    Args:
        base: The base XDG directory (e.g., '/opt/universal').
        subdir: The subdirectory name (e.g., 'config').

    Returns:
        The full path as a string.

    Raises:
        ValueError: If base or subdir is empty.
    """
    if not base or not subdir:
        raise ValueError("base and subdir must be non-empty")
    return f"{base}/{subdir}"
```

#### Building Documentation

The project uses **MkDocs** with the **Material theme** for documentation.

**Install dependencies:**

```bash
# Using pip
pip install mkdocs mkdocs-material

# Or using the project's pyproject.toml
pip install -e ".[docs]"
```

**Build and serve locally:**

```bash
# Serve docs locally with live reload
mkdocs serve

# Open http://127.0.0.1:8000 in your browser
```

**Build static site:**

```bash
# Build the documentation site
mkdocs build

# Output will be in the site/ directory
```

**Deploy to GitHub Pages:**

The documentation is automatically deployed to GitHub Pages when changes are pushed to the `main` branch. The workflow is defined in `.github/workflows/docs.yml`.

Manual deployment (if needed):

```bash
# Deploy to gh-pages branch
mkdocs gh-deploy
```

**Documentation structure:**

- `mkdocs.yml` - MkDocs configuration
- `docs/index.md` - Home page
- `docs/*.md` - Individual documentation pages
- `docs/getting-started/` - Getting started guides
- `docs/examples.md` - Examples and use cases
- `docs/security/` - Security documentation

**Tips for writing documentation:**

- Use Markdown with MkDocs extensions (admonitions, code blocks, etc.)
- Test locally with `mkdocs serve` before pushing
- Follow the existing documentation structure
- Add new pages to `mkdocs.yml` nav section
- Use relative links for internal documentation

---

## Local Build and Test Commands

### Docker Build Commands

#### Basic Build

```bash
# Build the UBI image
docker build -f .devcontainer/Dockerfile -t ubi:local .
```

#### Build with No Cache (clean build)

```bash
# Rebuild from scratch (useful after base image updates)
docker build -f .devcontainer/Dockerfile -t ubi:local . --no-cache
```

#### Build and Run Interactively

```bash
# Build and run in one command
docker build -f .devcontainer/Dockerfile -t ubi:local . && \
docker run -it --rm ubi:local bash
```

#### Test the Published Image

```bash
# Pull and test the latest published image
docker pull ghcr.io/egohygiene/ubi:latest
docker run -it --rm ghcr.io/egohygiene/ubi:latest bash

# Pull and test a specific version
docker pull ghcr.io/egohygiene/ubi:0.1.5
docker run -it --rm ghcr.io/egohygiene/ubi:0.1.5 bash
```

#### Build with Custom Arguments

```bash
# Build with custom locale (example)
docker build -f .devcontainer/Dockerfile -t ubi:custom \
  --build-arg LANG=de_DE.UTF-8 \
  .
```

### Bump-my-version Dry-Runs

Always test version bumps with `--dry-run` before committing:

```bash
# Preview a patch bump
bump-my-version bump patch --dry-run --verbose

# Preview a minor bump
bump-my-version bump minor --dry-run --verbose

# Preview a major bump
bump-my-version bump major --dry-run --verbose
```

#### What to Look For

1. **VERSION file**: Check the new version number
2. **CHANGELOG.md**: Verify the new section is added correctly at the top
3. **Commit message**: Confirm it follows the expected format

If everything looks good, run without `--dry-run`:

```bash
bump-my-version bump patch
```

### Devcontainer Troubleshooting

#### Issue: "Failed to build devcontainer"

**Solution:**

1. **Check Docker is running**:

   ```bash
   docker ps
   ```

2. **Clean up Docker resources**:

   ```bash
   docker system prune -a
   ```

3. **Rebuild without cache**:
   - In VS Code Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`):
     - Select: **"Dev Containers: Rebuild Container Without Cache"**

4. **Check Docker logs**:
   - In VS Code, open the Output panel
   - Select "Dev Containers" from the dropdown
   - Look for error messages

#### Issue: "Extensions not installing in devcontainer"

**Solution:**

1. **Check `.devcontainer/devcontainer.json`** (if it exists) for extension configuration
2. **Manually install extensions** after container is running
3. **Rebuild the container** and wait for extensions to install

#### Issue: "Environment variables not set correctly"

**Solution:**

1. **Verify inside the container**:

   ```bash
   env | grep XDG
   ```

2. **Check Dockerfile** for ENV declarations
3. **Rebuild the container** to pick up ENV changes

#### Issue: "Slow container startup"

**Solution:**

1. **Subsequent startups are much faster** (first build takes longer)
2. **Use Docker layer caching** (automatically enabled)
3. **Consider increasing Docker resources** (RAM/CPU):
   - Docker Desktop → Settings → Resources

#### Issue: "Permission issues with mounted volumes"

**Solution:**

1. **Check user inside container**:

   ```bash
   whoami
   id
   ```

2. **Verify file ownership**:

   ```bash
   ls -la /workspace
   ```

3. **Fix permissions if needed** (usually not required with devcontainers base image)

---

## Security and Reporting

### Reporting Security Vulnerabilities

If you discover a security vulnerability in UBI, please **do not** open a public issue. Instead:

1. **Use GitHub Security Advisories** (preferred):
   - [Report a vulnerability →](https://github.com/egohygiene/ubi/security/advisories/new)

2. **Or email**: [security@egohygiene.com](mailto:security@egohygiene.com)

For detailed information on our security policy, response timelines, and responsible disclosure guidelines, see:

**[SECURITY.md](./SECURITY.md)**

### Security Best Practices for Contributors

- **Never commit secrets** (passwords, API keys, tokens) to the repository
- **Use pinned base images** with digests (already implemented in Dockerfile)
- **Test security updates** before proposing changes to base images
- **Review Trivy scan results** and address HIGH/CRITICAL vulnerabilities
- **Keep dependencies up to date** by monitoring upstream releases

---

## Getting Help

Need assistance or have questions?

- **Issues**: [github.com/egohygiene/ubi/issues](https://github.com/egohygiene/ubi/issues)
  - Check existing issues first
  - Provide clear reproduction steps for bugs
  - Use issue templates when available

- **Discussions**: [github.com/egohygiene/ubi/discussions](https://github.com/egohygiene/ubi/discussions)
  - Ask general questions
  - Share ideas for features
  - Discuss development workflows

- **Pull Requests**: [github.com/egohygiene/ubi/pulls](https://github.com/egohygiene/ubi/pulls)
  - See what's being worked on
  - Review others' contributions

---

## Thank You! 🙏

Thank you for contributing to UBI! Your efforts help improve the developer experience for the entire Ego Hygiene organization.

**Together, we're building a better foundation for all projects.** 🚀

---

**[⬆ back to top](#contributing-to-ubi)**
