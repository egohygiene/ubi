#!/usr/bin/env bash
# =============================================================================
# Unit Tests for python-cli Example
# =============================================================================

set -euo pipefail

echo "🧪 Testing python-cli example..."
FAILURES=0

check() {
  if "$@" &>/dev/null; then echo "✅ $1"; else echo "❌ $1"; ((FAILURES++)); fi
}

echo "📂 Testing python-cli structure..."
check "example directory exists" test -d examples/python-cli
check "setup.py exists" test -f examples/python-cli/setup.py
check "README.md exists" test -f examples/python-cli/README.md
check "greet_cli package exists" test -d examples/python-cli/greet_cli
check "greet_cli/__init__.py exists" test -f examples/python-cli/greet_cli/__init__.py
check "greet_cli/cli.py exists" test -f examples/python-cli/greet_cli/cli.py
check "devcontainer.json exists" test -f examples/python-cli/.devcontainer/devcontainer.json

if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All python-cli tests passed!"
  exit 0
else
  echo "❌ $FAILURES test(s) failed!"
  exit 1
fi
