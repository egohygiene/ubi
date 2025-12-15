#!/usr/bin/env bash
set -euo pipefail
echo "🧪 Testing UBI Python Variant Inheritance..."
FAILURES=0
check() { if "$@" &>/dev/null; then echo "✅ $1"; else echo "❌ $1"; ((FAILURES++)); fi; }
command_exists() { command -v "$1" >/dev/null 2>&1; }
command_not_exists() { ! command -v "$1" >/dev/null 2>&1; }

echo "📦 Testing base tools..."
check "bash available" command_exists bash
check "git available" command_exists git
check "🐍 python3 available" command_exists python3
check "pip3 available" command_exists pip3
check "🟢 node NOT available" command_not_exists node
check "npm NOT available" command_not_exists npm
check "XDG_CONFIG_HOME exists" test -d "$XDG_CONFIG_HOME"
check "PYTHONDONTWRITEBYTECODE=1" test "${PYTHONDONTWRITEBYTECODE:-}" = "1"
check "PYTHONUNBUFFERED=1" test "${PYTHONUNBUFFERED:-}" = "1"

if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All python variant tests passed!"
  exit 0
else
  echo "❌ $FAILURES test(s) failed!"
  exit 1
fi
