# Goss Container Testing

This directory contains [Goss](https://goss.rocks/) test specifications for validating the UBI (Universal Base Image) container environment.

## Overview

Goss is a YAML-based serverless testing tool for validating server configurations. We use it to ensure the UBI container has the correct:

- Filesystem structure
- Environment variables
- Command-line tools
- File permissions
- User/group configurations

## Files

- `goss.yaml` - Main Goss test specification covering all container validations

## Running Tests Locally

### Prerequisites

Install Goss:

```bash
# Download and install goss
curl -fsSL https://goss.rocks/install | GOSS_VER=v0.4.8 sh

# Or download from GitHub releases
curl -fsSL https://github.com/goss-org/goss/releases/download/v0.4.8/goss-linux-amd64 \
  -o /usr/local/bin/goss
chmod +rx /usr/local/bin/goss
```

### Run Tests with dgoss

The easiest way to run Goss tests against the UBI container:

```bash
# Install dgoss (Docker wrapper for Goss)
curl -fsSL -o /usr/local/bin/dgoss \
  https://raw.githubusercontent.com/goss-org/goss/v0.4.8/extras/dgoss/dgoss
chmod +rx /usr/local/bin/dgoss

# Build the UBI image
docker build -t ubi:test -f .devcontainer/Dockerfile .

# Run dgoss tests
GOSS_FILES_PATH=tests/goss GOSS_FILE=tests/goss/goss.yaml dgoss run ubi:test
```

### Run Tests Manually Inside Container

```bash
# Run container with goss.yaml mounted
docker run --rm -v $(pwd)/tests/goss:/goss ubi:test bash -c '
  curl -fsSL https://github.com/goss-org/goss/releases/download/v0.4.8/goss-linux-amd64 \
    -o /usr/local/bin/goss && \
  chmod +x /usr/local/bin/goss && \
  goss --gossfile /goss/goss.yaml validate --format documentation
'
```

### Generate JSON Report

```bash
docker run --rm -v $(pwd)/tests/goss:/goss ubi:test bash -c '
  curl -fsSL https://github.com/goss-org/goss/releases/download/v0.4.8/goss-linux-amd64 \
    -o /usr/local/bin/goss && \
  chmod +x /usr/local/bin/goss && \
  goss --gossfile /goss/goss.yaml validate --format json
' > goss-report.json
```

## Test Categories

### Filesystem Structure Tests

Validates the `/opt/universal/*` directory hierarchy:

- `/opt/universal/bin` - Universal binaries
- `/opt/universal/toolbox` - Data files (XDG_DATA_HOME)
- `/opt/universal/cache` - Cache directory (XDG_CACHE_HOME)
- `/opt/universal/logs` - Centralized logs
- `/opt/universal/config` - Configuration files (XDG_CONFIG_HOME)
- `/opt/universal/lib` - Libraries
- `/opt/universal/locks` - Lock files
- `/opt/universal/fonts` - Font files
- `/opt/universal/runtime` - Runtime state (XDG_STATE_HOME)
- `/opt/universal/apps` - Application resources
- `/opt/universal/reports` - Generated reports

Each directory is tested for:

- Existence
- Correct permissions (0755)
- Correct ownership (vscode:vscode)
- File type (directory)

### Command Availability Tests

Validates that essential CLI tools are installed and functional:

- **Shell**: bash, sh
- **Coreutils**: ls, cat, touch, echo, grep, sed, awk, find, which, whoami, pwd, mkdir, rm, cp, mv
- **Network Tools**: curl, wget
- **Version Control**: git
- **Editor/Pager**: less, vi, nano

### Environment Variable Tests

Validates critical environment variables:

- **XDG Base Directory Specification**:
  - `XDG_CONFIG_HOME=/opt/universal/config`
  - `XDG_CACHE_HOME=/opt/universal/cache`
  - `XDG_DATA_HOME=/opt/universal/toolbox`
  - `XDG_STATE_HOME=/opt/universal/runtime`

- **Locale Configuration**:
  - `LANG=en_US.utf8`
  - `LC_ALL=en_US.utf8`

- **Telemetry Opt-Out Variables**:
  - `DO_NOT_TRACK=1`
  - `TELEMETRY_ENABLED=0`
  - `NEXT_TELEMETRY_DISABLED=1`
  - `DOTNET_CLI_TELEMETRY_OPTOUT=1`
  - `GATSBY_TELEMETRY_DISABLED=1`
  - `NUXT_TELEMETRY_DISABLED=1`
  - `STRIPE_CLI_TELEMETRY_OPTOUT=1`

- **Universal Directory Variables**:
  - `UNIVERSAL_HOME`, `UNIVERSAL_BIN`, `UNIVERSAL_TOOLBOX`, etc.

- **Editor/Terminal Configuration**:
  - `EDITOR=code`, `VISUAL=code`, `PAGER=less`
  - `TERM=xterm`, `COLORTERM=truecolor`

### User/Group Tests

Validates the vscode user configuration:

- User `vscode` exists with UID 1000
- Group `vscode` exists with GID 1000
- Home directory is `/home/vscode`

### Package Tests

Validates that required packages are installed:

- bash, coreutils, curl, wget, git, nano, less

## CI/CD Integration

Tests are automatically run in GitHub Actions via the `.github/workflows/test-unified.yml` workflow:

- Triggered on PRs and pushes to main/master branches
- Builds the UBI image for all variants
- Runs Goss tests on the base variant
- Runs additional sanity tests on all variants
- Fails the build if any test fails
- Generates structured test reports (JSON + Markdown) as artifacts

## Troubleshooting

### Test Failures

If tests fail, check:

1. **Directory permissions**: Ensure all `/opt/universal/*` directories are owned by `vscode:vscode`
2. **Environment variables**: Verify they are set in the Dockerfile
3. **Package availability**: Check if required packages are installed in the base image
4. **Command execution**: Test commands manually in the container

### Adding New Tests

To add new tests, edit `goss.yaml` and add entries under the appropriate section:

```yaml
file:
  /path/to/test:
    exists: true
    filetype: directory
    owner: vscode

command:
  my-command:
    exit-status: 0
    exec: "my-command --version"

env:
  MY_VAR:
    contains:
      - "expected-value"
```

Then validate locally before committing.

## References

- [Goss Documentation](https://goss.rocks/)
- [Goss GitHub Repository](https://github.com/goss-org/goss)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
