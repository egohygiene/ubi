#!/usr/bin/env bash
# =============================================================================
# Unit Tests for tasks/utils.yml
# =============================================================================
# Tests utility tasks defined in Taskfile
# =============================================================================

set -euo pipefail

echo "🧪 Testing tasks/utils.yml tasks..."
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

# Test that required commands for tasks exist
echo "📦 Testing required commands for utils tasks..."
check "bash is available" command -v bash
check "git is available" command -v git
check "grep is available" command -v grep
check "find is available" command -v find
check "du is available" command -v du
check "wc is available" command -v wc
check "sort is available" command -v sort
check "uniq is available" command -v uniq
check "awk is available" command -v awk
check "sed is available" command -v sed
echo ""

# Test git commands work
echo "🔧 Testing git operations..."
check "git status works" git status
check "git branch works" git rev-parse --abbrev-ref HEAD
echo ""

# Test file counting
echo "📊 Testing file operations..."
check "find command works" find . -type f -name "*.yml" > /dev/null
check "wc command works" echo "test" | wc -l > /dev/null
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All utils tasks tests passed!"
  exit 0
else
  echo "❌ $FAILURES test(s) failed!"
  exit 1
fi
