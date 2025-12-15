#!/usr/bin/env bash
# =============================================================================
# Comprehensive Environment Variable Tests
# =============================================================================
# Validates all environment variables across UBI variants
# =============================================================================

set -euo pipefail

echo "🧪 Testing UBI Environment Variables..."
echo ""

FAILURES=0

check() {
  local test_name="$1"
  local expected="$2"
  local actual="${!3:-NOTSET}"
  
  if [[ "$actual" == "$expected" ]]; then
    echo "✅ $test_name = $expected"
  else
    echo "❌ $test_name (expected: $expected, got: $actual)"
    ((FAILURES++))
  fi
}

check_contains() {
  local test_name="$1"
  local pattern="$2"
  local actual="${!3:-NOTSET}"
  
  if [[ "$actual" == *"$pattern"* ]]; then
    echo "✅ $test_name contains $pattern"
  else
    echo "❌ $test_name (expected to contain: $pattern, got: $actual)"
    ((FAILURES++))
  fi
}

check_set() {
  local test_name="$1"
  local varname="$2"
  
  if [[ -n "${!varname:-}" ]]; then
    echo "✅ $test_name is set"
  else
    echo "❌ $test_name is not set"
    ((FAILURES++))
  fi
}

# =============================================================================
# XDG Base Directory Specification
# =============================================================================
echo "📂 Testing XDG Base Directory Specification..."
check "XDG_CONFIG_HOME" "/opt/universal/config" XDG_CONFIG_HOME
check "XDG_CACHE_HOME" "/opt/universal/cache" XDG_CACHE_HOME
check "XDG_DATA_HOME" "/opt/universal/toolbox" XDG_DATA_HOME
check "XDG_STATE_HOME" "/opt/universal/runtime" XDG_STATE_HOME
echo ""

# =============================================================================
# Locale Configuration
# =============================================================================
echo "🌍 Testing Locale Configuration..."
check "LANG" "en_US.UTF-8" LANG
check "LC_ALL" "en_US.UTF-8" LC_ALL
check_set "LANGUAGE" LANGUAGE
echo ""

# =============================================================================
# Universal Directory Variables
# =============================================================================
echo "📁 Testing Universal Directory Variables..."
check "UNIVERSAL_HOME" "/opt/universal" UNIVERSAL_HOME
check "UNIVERSAL_BIN" "/opt/universal/bin" UNIVERSAL_BIN
check "UNIVERSAL_TOOLBOX" "/opt/universal/toolbox" UNIVERSAL_TOOLBOX
check "UNIVERSAL_CACHE" "/opt/universal/cache" UNIVERSAL_CACHE
check "UNIVERSAL_LOGS" "/opt/universal/logs" UNIVERSAL_LOGS
check "UNIVERSAL_CONFIG" "/opt/universal/config" UNIVERSAL_CONFIG
echo ""

# =============================================================================
# Editor and Pager Configuration
# =============================================================================
echo "✏️  Testing Editor and Pager Configuration..."
check "EDITOR" "code" EDITOR
check "VISUAL" "code" VISUAL
check "PAGER" "less" PAGER
echo ""

# =============================================================================
# Terminal Configuration
# =============================================================================
echo "🖥️  Testing Terminal Configuration..."
check_contains "TERM" "xterm" TERM
check "COLORTERM" "truecolor" COLORTERM
check "CLICOLOR" "1" CLICOLOR
check "CLICOLOR_FORCE" "1" CLICOLOR_FORCE
check "FORCE_COLOR" "1" FORCE_COLOR
echo ""

# =============================================================================
# Telemetry Opt-Out Variables
# =============================================================================
echo "🔕 Testing Telemetry Opt-Out Variables..."
check "DO_NOT_TRACK" "1" DO_NOT_TRACK
check "TELEMETRY_ENABLED" "0" TELEMETRY_ENABLED
check "NEXT_TELEMETRY_DISABLED" "1" NEXT_TELEMETRY_DISABLED
check "DOTNET_CLI_TELEMETRY_OPTOUT" "1" DOTNET_CLI_TELEMETRY_OPTOUT
check "GATSBY_TELEMETRY_DISABLED" "1" GATSBY_TELEMETRY_DISABLED
check "NUXT_TELEMETRY_DISABLED" "1" NUXT_TELEMETRY_DISABLED
check "STRIPE_CLI_TELEMETRY_OPTOUT" "1" STRIPE_CLI_TELEMETRY_OPTOUT
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All environment variable tests passed!"
  exit 0
else
  echo "❌ $FAILURES environment variable test(s) failed!"
  exit 1
fi
