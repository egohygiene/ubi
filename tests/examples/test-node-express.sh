#!/usr/bin/env bash
# =============================================================================
# Unit Tests for node-express Example
# =============================================================================

set -euo pipefail

echo "🧪 Testing node-express example..."
FAILURES=0

check() {
  if "$@" &>/dev/null; then echo "✅ $1"; else echo "❌ $1"; ((FAILURES++)); fi
}

echo "📂 Testing node-express structure..."
check "example directory exists" test -d examples/node-express
check "package.json exists" test -f examples/node-express/package.json
check "README.md exists" test -f examples/node-express/README.md
check "src directory exists" test -d examples/node-express/src
check "src/app.js exists" test -f examples/node-express/src/app.js
check "src/server.js exists" test -f examples/node-express/src/server.js
check "devcontainer.json exists" test -f examples/node-express/.devcontainer/devcontainer.json

if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All node-express tests passed!"
  exit 0
else
  echo "❌ $FAILURES test(s) failed!"
  exit 1
fi
