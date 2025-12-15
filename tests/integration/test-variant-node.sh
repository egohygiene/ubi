#!/usr/bin/env bash
set -euo pipefail
echo "🧪 Testing UBI Node Variant Inheritance..."
FAILURES=0
check() { if "$@" &>/dev/null; then echo "✅ $1"; else echo "❌ $1"; ((FAILURES++)); fi; }
command_exists() { command -v "$1" >/dev/null 2>&1; }
command_not_exists() { ! command -v "$1" >/dev/null 2>&1; }

echo "📦 Testing base tools..."
check "bash available" command_exists bash
check "git available" command_exists git
check "🟢 node available" command_exists node
check "npm available" command_exists npm
check "🐍 python3 NOT available" command_not_exists python3
check "pip3 NOT available" command_not_exists pip3
check "XDG_CONFIG_HOME exists" test -d "$XDG_CONFIG_HOME"
check "NODE_ENV set" test -n "${NODE_ENV:-}"
check "NEXT_TELEMETRY_DISABLED=1" test "${NEXT_TELEMETRY_DISABLED:-}" = "1"

if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All node variant tests passed!"
  exit 0
else
  echo "❌ $FAILURES test(s) failed!"
  exit 1
fi
