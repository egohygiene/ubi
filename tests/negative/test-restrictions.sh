#!/usr/bin/env bash
# =============================================================================
# Negative Tests - Things That Should NOT Exist
# =============================================================================
# Tests that validate proper isolation between variants
# =============================================================================

set -euo pipefail

echo "🧪 Running negative tests (restrictions validation)..."
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

# Helper function - command should NOT exist
command_not_exists() {
  ! command -v "$1" >/dev/null 2>&1
}

# =============================================================================
# TEST: Detect which variant we're running in
# =============================================================================
VARIANT="unknown"
if command -v python3 >/dev/null 2>&1 && command -v node >/dev/null 2>&1; then
  VARIANT="full"
elif command -v python3 >/dev/null 2>&1; then
  VARIANT="python"
elif command -v node >/dev/null 2>&1; then
  VARIANT="node"
else
  VARIANT="minimal"
fi

echo "🔍 Detected variant: $VARIANT"
echo ""

# =============================================================================
# TEST: Minimal variant restrictions
# =============================================================================
if [[ "$VARIANT" == "minimal" ]]; then
  echo "🔒 Testing minimal variant restrictions..."
  check "python3 NOT in minimal" command_not_exists python3
  check "pip NOT in minimal" command_not_exists pip
  check "node NOT in minimal" command_not_exists node
  check "npm NOT in minimal" command_not_exists npm
  check "poetry NOT in minimal" command_not_exists poetry
  check "pnpm NOT in minimal" command_not_exists pnpm
  check "yarn NOT in minimal" command_not_exists yarn
  echo ""
fi

# =============================================================================
# TEST: Python variant restrictions
# =============================================================================
if [[ "$VARIANT" == "python" ]]; then
  echo "🔒 Testing python variant restrictions..."
  check "node NOT in python variant" command_not_exists node
  check "npm NOT in python variant" command_not_exists npm
  check "npx NOT in python variant" command_not_exists npx
  echo ""
fi

# =============================================================================
# TEST: Node variant restrictions
# =============================================================================
if [[ "$VARIANT" == "node" ]]; then
  echo "🔒 Testing node variant restrictions..."
  check "python3 NOT in node variant" command_not_exists python3
  check "pip NOT in node variant" command_not_exists pip
  check "pip3 NOT in node variant" command_not_exists pip3
  echo ""
fi

# =============================================================================
# TEST: Security - No suspicious files
# =============================================================================
echo "🔒 Testing security restrictions..."
check "No .env files in root" test ! -f /.env
check "No .git directory in /opt" test ! -d /opt/.git

# Check that /root/.ssh either doesn't exist or is not readable
if [ -d /root/.ssh ] && [ -r /root/.ssh ]; then
  echo "❌ No root .ssh directory exposed"
  ((FAILURES++))
else
  echo "✅ No root .ssh directory exposed"
fi
echo ""

# =============================================================================
# TEST: No unnecessary build artifacts
# =============================================================================
echo "🧹 Testing no build artifacts left behind..."
check "No __pycache__ in /opt" test -z "$(find /opt -name __pycache__ 2>/dev/null)"
check "No node_modules in /opt/universal" test ! -d /opt/universal/node_modules
check "No .pytest_cache in /opt" test -z "$(find /opt -name .pytest_cache 2>/dev/null)"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All negative tests passed!"
  exit 0
else
  echo "❌ $FAILURES negative test(s) failed!"
  exit 1
fi
