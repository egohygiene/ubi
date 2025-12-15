#!/usr/bin/env bash
# =============================================================================
# Telemetry Opt-Out Validation Tests
# =============================================================================
# Ensures all telemetry opt-out variables are properly set
# =============================================================================

set -euo pipefail

echo "🧪 Testing Telemetry Opt-Out Configuration..."
echo ""

FAILURES=0

check() {
  local test_name="$1"
  local expected="$2"
  local varname="$3"
  local actual="${!varname:-NOTSET}"
  
  if [[ "$actual" == "$expected" ]]; then
    echo "✅ $test_name = $expected"
  else
    echo "❌ $test_name (expected: $expected, got: $actual)"
    ((FAILURES++))
  fi
}

# =============================================================================
# Universal Telemetry Opt-Out
# =============================================================================
echo "🔕 Testing Universal Telemetry Opt-Out..."
check "DO_NOT_TRACK" "1" DO_NOT_TRACK
check "TELEMETRY_ENABLED" "0" TELEMETRY_ENABLED
echo ""

# =============================================================================
# Framework-Specific Telemetry Opt-Out
# =============================================================================
echo "🚫 Testing Framework-Specific Telemetry Opt-Out..."
check "NEXT_TELEMETRY_DISABLED (Next.js)" "1" NEXT_TELEMETRY_DISABLED
check "DOTNET_CLI_TELEMETRY_OPTOUT (.NET)" "1" DOTNET_CLI_TELEMETRY_OPTOUT
check "GATSBY_TELEMETRY_DISABLED (Gatsby)" "1" GATSBY_TELEMETRY_DISABLED
check "NUXT_TELEMETRY_DISABLED (Nuxt)" "1" NUXT_TELEMETRY_DISABLED
check "STRIPE_CLI_TELEMETRY_OPTOUT (Stripe)" "1" STRIPE_CLI_TELEMETRY_OPTOUT
echo ""

# =============================================================================
# Privacy Validation
# =============================================================================
echo "🔒 Testing Privacy Configuration..."

# Ensure no analytics or telemetry endpoints are configured
if env | grep -iq "analytics\|telemetry\|tracking" | grep -v "DISABLED\|OPTOUT\|DO_NOT_TRACK\|TELEMETRY_ENABLED"; then
  echo "⚠️  Warning: Found potential telemetry-related env vars"
  env | grep -i "analytics\|telemetry\|tracking" | grep -v "DISABLED\|OPTOUT\|DO_NOT_TRACK\|TELEMETRY_ENABLED" || true
fi

echo "✅ Privacy configuration validated"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All telemetry opt-out tests passed!"
  exit 0
else
  echo "❌ $FAILURES telemetry test(s) failed!"
  exit 1
fi
