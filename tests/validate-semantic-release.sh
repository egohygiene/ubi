#!/usr/bin/env bash
# =============================================================================
# Validate semantic-release Configuration
# =============================================================================
# This script validates that the semantic-release setup is correct and all
# required files and configurations are in place.

set -euo pipefail

echo "🔍 Validating semantic-release configuration..."
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

# Function to check file exists
file_exists() {
  local file="$1"
  [[ -f "$file" ]]
}

# Function to check command exists
command_exists() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1
}

# Check required files
echo "📁 Checking required files..."
check "package.json exists" file_exists package.json
check "package-lock.json exists" file_exists package-lock.json
check ".releaserc.yml exists" file_exists .releaserc.yml
check ".github/workflows/semantic-release.yml exists" file_exists .github/workflows/semantic-release.yml
check "VERSION file exists" file_exists VERSION
check "CHANGELOG.md exists" file_exists CHANGELOG.md
echo ""

# Check package.json content
echo "📦 Checking package.json configuration..."
check "semantic-release in devDependencies" grep -q semantic-release package.json
check "@semantic-release/changelog in devDependencies" grep -q @semantic-release/changelog package.json
check "@semantic-release/git in devDependencies" grep -q @semantic-release/git package.json
check "@semantic-release/github in devDependencies" grep -q @semantic-release/github package.json
check "@semantic-release/commit-analyzer in devDependencies" grep -q @semantic-release/commit-analyzer package.json
check "@semantic-release/release-notes-generator in devDependencies" grep -q @semantic-release/release-notes-generator package.json
check "@semantic-release/exec in devDependencies" grep -q @semantic-release/exec package.json
echo ""

# Check .releaserc.yml content
echo "⚙️  Checking .releaserc.yml configuration..."
check "branches configuration" grep -q branches: .releaserc.yml
check "plugins configuration" grep -q plugins: .releaserc.yml
check "commit-analyzer plugin" grep -q @semantic-release/commit-analyzer .releaserc.yml
check "release-notes-generator plugin" grep -q @semantic-release/release-notes-generator .releaserc.yml
check "changelog plugin" grep -q @semantic-release/changelog .releaserc.yml
check "exec plugin" grep -q @semantic-release/exec .releaserc.yml
check "git plugin" grep -q @semantic-release/git .releaserc.yml
check "github plugin" grep -q @semantic-release/github .releaserc.yml
check "conventionalcommits preset" grep -q conventionalcommits .releaserc.yml
echo ""

# Check if Node.js and npm are available (optional, for local testing)
echo "🔧 Checking Node.js tooling (optional)..."
if command_exists node; then
  echo "✅ Node.js available: $(node --version)"
  if command_exists npm; then
    echo "✅ npm available: $(npm --version)"
    
    # Check if dependencies are installed
    if [[ -d "node_modules" ]]; then
      echo "✅ node_modules directory exists"
      
      # Check if semantic-release binary exists
      if [[ -f "node_modules/.bin/semantic-release" ]]; then
        echo "✅ semantic-release binary installed"
      else
        echo "⚠️  semantic-release binary not found (run 'npm install')"
      fi
    else
      echo "⚠️  node_modules not found (run 'npm install' to install dependencies)"
    fi
  else
    echo "⚠️  npm not available"
  fi
else
  echo "⚠️  Node.js not available (optional for local testing)"
fi
echo ""

# Check workflow file content
echo "🔄 Checking GitHub Actions workflow..."
check "workflow name" grep -q "name.*Semantic Release" .github/workflows/semantic-release.yml
check "trigger on push to main" grep -q main .github/workflows/semantic-release.yml
check "checkout step" grep -q checkout .github/workflows/semantic-release.yml
check "setup node step" grep -q setup-node .github/workflows/semantic-release.yml
check "npm ci command" grep -q "npm ci" .github/workflows/semantic-release.yml
check "semantic-release execution" grep -q semantic-release .github/workflows/semantic-release.yml
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAILURES -eq 0 ]]; then
  echo "✅ All validation checks passed!"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 0
else
  echo "❌ $FAILURES validation check(s) failed!"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 1
fi
