#!/usr/bin/env bash
#
# Setup script for the polyglot example
# Installs all dependencies for Python and Node.js components
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Setting up Polyglot Example${NC}"
echo -e "${BLUE}================================${NC}\n"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Install Python dependencies
echo -e "${YELLOW}📦 Installing Python dependencies...${NC}"
cd "$PROJECT_ROOT/python"
if command -v pip &> /dev/null; then
    pip install -r requirements.txt
    echo -e "${GREEN}✅ Python dependencies installed${NC}\n"
else
    echo -e "${RED}❌ pip not found. Please install Python and pip.${NC}\n"
    exit 1
fi

# Install Node.js dependencies
echo -e "${YELLOW}📦 Installing Node.js dependencies...${NC}"
cd "$PROJECT_ROOT/node"
if command -v npm &> /dev/null; then
    npm install
    echo -e "${GREEN}✅ Node.js dependencies installed${NC}\n"
else
    echo -e "${RED}❌ npm not found. Please install Node.js and npm.${NC}\n"
    exit 1
fi

# Display XDG directories
echo -e "${BLUE}📁 XDG Directories:${NC}"
echo -e "  Config: ${XDG_CONFIG_HOME:-~/.config}"
echo -e "  Cache:  ${XDG_CACHE_HOME:-~/.cache}"
echo -e "  Data:   ${XDG_DATA_HOME:-~/.local/share}"

echo -e "\n${GREEN}✨ Setup complete!${NC}"
echo -e "${BLUE}Run './scripts/start-all.sh' to start all services${NC}\n"
