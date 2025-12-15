#!/usr/bin/env bash
# =============================================================================
# Unit Tests for tasks/lint.yml
# =============================================================================
# Tests lint tasks defined in Taskfile
# =============================================================================

set -euo pipefail

echo "🧪 Testing tasks/lint.yml tasks..."
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

# Test that Docker is available for MegaLinter
echo "🐳 Testing Docker availability..."
check "docker command exists" command -v docker
check "docker version works" docker --version
echo ""

# Test shell script is available
echo "📂 Testing lint configuration exists..."
check ".megalinter.yml exists" test -f .megalinter.yml
check ".editorconfig exists" test -f .editorconfig
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All lint tasks tests passed!"
  exit 0
else
  echo "❌ $FAILURES test(s) failed!"
  exit 1
fi
