# UBI Test Suite

This directory contains the comprehensive test suite for the Universal Base Image (UBI) project.

## Overview

The test suite has grown from 3 test files to **20+ test files**, providing comprehensive coverage across:
- All 5 container variants (base, minimal, python, node, full)
- Example projects (python-cli, node-express, polyglot)
- Task scripts and utilities
- Negative tests for variant isolation
- Environment variable validation
- Telemetry opt-out verification

## Directory Structure

```
tests/
├── README.md                           # This file
├── validate-semantic-release.sh        # Semantic release validation
│
├── goss/                               # Goss container specification tests
│   ├── README.md                       # Goss testing documentation
│   ├── goss.yaml                       # Base variant Goss specs
│   ├── goss-minimal.yaml               # Minimal variant Goss specs
│   ├── goss-python.yaml                # Python variant Goss specs
│   ├── goss-node.yaml                  # Node variant Goss specs
│   └── goss-full.yaml                  # Full variant Goss specs
│
├── integration/                        # Integration tests
│   ├── test-variant-minimal.sh         # Minimal variant inheritance tests
│   ├── test-variant-python.sh          # Python variant inheritance tests
│   ├── test-variant-node.sh            # Node variant inheritance tests
│   ├── test-variant-full.sh            # Full variant inheritance tests
│   ├── test-env-vars.sh                # Comprehensive env var validation
│   └── test-telemetry.sh               # Telemetry opt-out validation
│
├── unit/                               # Unit tests for task scripts
│   ├── test-tasks-utils.sh             # Tests for tasks/utils.yml
│   ├── test-tasks-lint.sh              # Tests for tasks/lint.yml
│   └── test-tasks-tools.sh             # Tests for tasks/tools.yml
│
├── examples/                           # Tests for example projects
│   ├── test-python-cli.sh              # Python CLI example tests
│   ├── test-node-express.sh            # Node Express example tests
│   └── test-polyglot.sh                # Polyglot example tests
│
└── negative/                           # Negative tests (restrictions)
    └── test-restrictions.sh            # Variant isolation & security tests
```

## Test Categories

### 1. Goss Container Tests (`goss/`)

Goss is a YAML-based serverless testing tool for validating server configurations. Each variant has its own Goss specification file.

**Coverage:**
- Filesystem structure (`/opt/universal/*` directories)
- Command availability (bash, git, python, node, etc.)
- Environment variables (XDG paths, locale, telemetry)
- User/group configuration (vscode user)
- Package installation validation

**Files:**
- `goss.yaml` - Base variant (most comprehensive)
- `goss-minimal.yaml` - Minimal variant (base tools only, no python/node)
- `goss-python.yaml` - Python variant (base + Python 3.13+, pip)
- `goss-node.yaml` - Node variant (base + Node.js v20, npm)
- `goss-full.yaml` - Full variant (base + Python + Node.js)

**Run locally:**
```bash
# Build image
docker build -f variants/python/Dockerfile -t ubi:test-python .

# Run Goss tests
GOSS_FILES_PATH=tests/goss GOSS_FILE=tests/goss/goss-python.yaml \
  dgoss run ubi:test-python
```

### 2. Integration Tests (`integration/`)

Integration tests validate variant inheritance, environment configuration, and cross-cutting concerns.

**Variant Inheritance Tests:**
- `test-variant-minimal.sh` - Validates minimal variant (no python/node)
- `test-variant-python.sh` - Validates Python variant (has python, no node)
- `test-variant-node.sh` - Validates Node variant (has node, no python)
- `test-variant-full.sh` - Validates Full variant (has both python and node)

**Environment Tests:**
- `test-env-vars.sh` - Comprehensive environment variable validation
  - XDG Base Directory Specification
  - Locale configuration
  - Universal directory variables
  - Editor/pager configuration
  - Terminal configuration
  - Telemetry opt-out variables

- `test-telemetry.sh` - Telemetry opt-out validation
  - Universal telemetry opt-out (DO_NOT_TRACK, TELEMETRY_ENABLED)
  - Framework-specific opt-out (Next.js, .NET, Gatsby, Nuxt, Stripe)
  - Privacy configuration validation

**Run locally:**
```bash
# Run inside container
docker run --rm -v $(pwd)/tests/integration/test-variant-python.sh:/test.sh:ro \
  ubi:test-python bash /test.sh
```

### 3. Unit Tests (`unit/`)

Unit tests validate that task scripts and utilities work correctly.

**Coverage:**
- `test-tasks-utils.sh` - Tests for `tasks/utils.yml` (git, file operations, etc.)
- `test-tasks-lint.sh` - Tests for `tasks/lint.yml` (linter availability)
- `test-tasks-tools.sh` - Tests for `tasks/tools.yml` (tool installation)

**Run locally:**
```bash
# Run in repository root
bash tests/unit/test-tasks-utils.sh
```

### 4. Example Project Tests (`examples/`)

Tests validate that example projects have correct structure and configuration.

**Coverage:**
- `test-python-cli.sh` - Validates python-cli example structure
- `test-node-express.sh` - Validates node-express example structure
- `test-polyglot.sh` - Validates polyglot example structure

**Run locally:**
```bash
# Run in repository root
bash tests/examples/test-python-cli.sh
```

### 5. Negative Tests (`negative/`)

Negative tests ensure variant isolation and security restrictions are enforced.

**Coverage:**
- `test-restrictions.sh` - Validates:
  - Minimal variant doesn't have python/node
  - Python variant doesn't have node
  - Node variant doesn't have python
  - No suspicious files (/.env, /root/.ssh)
  - No build artifacts (__pycache__, node_modules, .pytest_cache)

**Run locally:**
```bash
# Run inside container
docker run --rm -v $(pwd)/tests/negative/test-restrictions.sh:/test.sh:ro \
  ubi:test-minimal bash /test.sh
```

## CI/CD Integration

All tests are integrated into the `.github/workflows/test-unified.yml` workflow, which:

1. Builds all 5 variants in parallel
2. Runs variant-specific Goss tests
3. Runs sanity tests (directory structure, XDG vars, permissions, locale, tools)
4. Runs variant inheritance tests
5. Runs environment variable tests
6. Runs telemetry opt-out tests
7. Runs negative tests (restrictions)
8. Generates comprehensive test reports
9. Uploads test artifacts

Example projects are tested separately in `.github/workflows/test-examples.yml`.

## Test Execution Order

When the workflow runs, tests execute in this order:

1. **Build Phase**: Docker image built for each variant
2. **Goss Tests**: Variant-specific Goss specs validated
3. **Sanity Tests**: Directory structure, XDG vars, permissions, locale, fundamental tools
4. **Variant Inheritance Tests**: Toolchain and inheritance validation
5. **Environment Variable Tests**: Comprehensive env var validation
6. **Telemetry Tests**: Telemetry opt-out verification
7. **Negative Tests**: Restrictions and security validation
8. **Summary Generation**: Test report and artifact upload

## Adding New Tests

### Adding a Goss Test

1. Create or edit the appropriate `goss-{variant}.yaml` file in `tests/goss/`
2. Add your test under the appropriate section (file, command, env, etc.)
3. Run locally with dgoss to validate
4. Commit and push

### Adding an Integration Test

1. Create a new shell script in `tests/integration/`
2. Use the existing test scripts as templates
3. Make the script executable: `chmod +x tests/integration/test-my-new-test.sh`
4. Add a step in `.github/workflows/test-unified.yml` to run it
5. Commit and push

### Adding a Unit Test

1. Create a new shell script in `tests/unit/`
2. Follow the pattern of existing unit tests
3. Make the script executable: `chmod +x tests/unit/test-my-unit.sh`
4. Run locally to validate
5. Commit and push

## Test Standards

All test scripts should:

1. **Use strict error handling**: `set -euo pipefail`
2. **Track failures**: Use a `FAILURES` counter variable
3. **Provide clear output**: Use emojis and consistent formatting (✅ ❌)
4. **Return proper exit codes**: `exit 0` for success, `exit 1` for failure
5. **Be idempotent**: Can be run multiple times safely
6. **Be self-contained**: Don't depend on external state
7. **Document purpose**: Include header comments explaining what's being tested

### Example Test Script Template

```bash
#!/usr/bin/env bash
# =============================================================================
# Test Description
# =============================================================================
# This script validates...
# =============================================================================

set -euo pipefail

echo "🧪 Testing My Feature..."
echo ""

FAILURES=0

check() {
  local test_name="$1"
  shift
  
  if "$@" &>/dev/null; then
    echo "✅ $test_name"
  else
    echo "❌ $test_name"
    ((FAILURES++))
  fi
}

# Your tests here
check "Test 1" test -d /some/directory
check "Test 2" command -v some-command

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All tests passed!"
  exit 0
else
  echo "❌ $FAILURES test(s) failed!"
  exit 1
fi
```

## Troubleshooting

### Goss Tests Failing

1. Check the Goss report artifact in GitHub Actions
2. Run locally with `dgoss run` to see detailed output
3. Verify the Goss file syntax is correct (YAML validation)
4. Ensure the expected commands/files/env vars exist in the variant

### Integration Tests Failing

1. Check the test logs in GitHub Actions
2. Run the test locally inside the container
3. Verify environment variables are set correctly
4. Check if the variant has the expected toolchain installed

### Negative Tests Failing

1. Verify variant isolation is correct
2. Check if unwanted tools are accidentally installed
3. Validate security restrictions are enforced

## References

- [Goss Documentation](https://goss.rocks/)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
- [GitHub Actions Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
