#!/usr/bin/env bash
# =============================================================================
# Test UBI Minimal Variant Inheritance
# =============================================================================
# This script validates that the minimal variant:
# - Inherits base XDG directory structure
# - Does NOT include Python or Node.js
# - Has only minimal base system tools
# =============================================================================

set -euo pipefail

echo "🧪 Testing UBI Minimal Variant Inheritance..."
echo ""

# Track failures
FAILURES=0

# Function to report test results
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

# Function to check command does not exist
command_not_exists() {
  local cmd="$1"
  ! command -v "$cmd" >/dev/null 2>&1
}

# Function to check command exists
command_exists() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1
}

# =============================================================================
# TEST: Base system tools exist
# =============================================================================
echo "📦 Testing base system tools..."
check "bash is available" command_exists bash
check "git is available" command_exists git
check "curl is available" command_exists curl
check "wget is available" command_exists wget
echo ""

# =============================================================================
# TEST: Python should NOT be available in minimal variant
# =============================================================================
echo "🐍 Testing Python is NOT available (minimal variant)..."
check "python3 is NOT available" command_not_exists python3
check "pip3 is NOT available" command_not_exists pip3
check "python is NOT available" command_not_exists python
check "pip is NOT available" command_not_exists pip
check "poetry is NOT available" command_not_exists poetry
echo ""

# =============================================================================
# TEST: Node.js should NOT be available in minimal variant
# =============================================================================
echo "🟢 Testing Node.js is NOT available (minimal variant)..."
check "node is NOT available" command_not_exists node
check "npm is NOT available" command_not_exists npm
check "npx is NOT available" command_not_exists npx
check "pnpm is NOT available" command_not_exists pnpm
check "yarn is NOT available" command_not_exists yarn
echo ""

# =============================================================================
# TEST: XDG directories exist and are writable
# =============================================================================
echo "📂 Testing XDG directory structure inheritance..."
check "XDG_CONFIG_HOME directory exists" test -d "$XDG_CONFIG_HOME"
check "XDG_CACHE_HOME directory exists" test -d "$XDG_CACHE_HOME"
check "XDG_DATA_HOME directory exists" test -d "$XDG_DATA_HOME"
check "XDG_STATE_HOME directory exists" test -d "$XDG_STATE_HOME"

# Test write permissions
check "XDG_CONFIG_HOME is writable" test -w "$XDG_CONFIG_HOME"
check "XDG_CACHE_HOME is writable" test -w "$XDG_CACHE_HOME"
check "XDG_DATA_HOME is writable" test -w "$XDG_DATA_HOME"
check "XDG_STATE_HOME is writable" test -w "$XDG_STATE_HOME"
echo ""

# =============================================================================
# TEST: Environment variables are set correctly
# =============================================================================
echo "🌍 Testing environment variable inheritance..."
check "LANG is set to en_US.utf8" test "$LANG" = "en_US.utf8"
check "LC_ALL is set to en_US.utf8" test "$LC_ALL" = "en_US.utf8"
check "DO_NOT_TRACK is set to 1" test "$DO_NOT_TRACK" = "1"
check "TELEMETRY_ENABLED is set to 0" test "$TELEMETRY_ENABLED" = "0"
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All minimal variant tests passed!"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 0
else
  echo "❌ $FAILURES minimal variant test(s) failed!"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 1
fi
