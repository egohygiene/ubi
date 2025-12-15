#!/usr/bin/env bash
# =============================================================================
# Unit Tests for tasks/tools.yml
# =============================================================================
# Tests tool installation tasks
# =============================================================================

set -euo pipefail

echo "🧪 Testing tasks/tools.yml tasks..."
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

# Test bash is available
echo "🔧 Testing bash availability..."
check "bash is available" command -v bash
echo ""

# Test taskfile structure
echo "📂 Testing tasks directory structure..."
check "tasks/tools.yml exists" test -f tasks/tools.yml
check "tasks/utils.yml exists" test -f tasks/utils.yml
check "tasks/lint.yml exists" test -f tasks/lint.yml
check "Taskfile.yml exists" test -f Taskfile.yml
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All tools tasks tests passed!"
  exit 0
else
  echo "❌ $FAILURES test(s) failed!"
  exit 1
fi
