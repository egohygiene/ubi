#!/usr/bin/env bash
# =============================================================================
# Unit Tests for polyglot Example
# =============================================================================

set -euo pipefail

echo "🧪 Testing polyglot example..."
FAILURES=0

check() {
  if "$@" &>/dev/null; then echo "✅ $1"; else echo "❌ $1"; ((FAILURES++)); fi
}

echo "📂 Testing polyglot structure..."
check "example directory exists" test -d examples/polyglot
check "README.md exists" test -f examples/polyglot/README.md
check "python directory exists" test -d examples/polyglot/python
check "node directory exists" test -d examples/polyglot/node
check "scripts directory exists" test -d examples/polyglot/scripts
check "setup.sh exists" test -f examples/polyglot/scripts/setup.sh
check "env-info.sh exists" test -f examples/polyglot/scripts/env-info.sh
check "status.sh exists" test -f examples/polyglot/scripts/status.sh
check "devcontainer.json exists" test -f examples/polyglot/.devcontainer/devcontainer.json

if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All polyglot tests passed!"
  exit 0
else
  echo "❌ $FAILURES test(s) failed!"
  exit 1
fi
