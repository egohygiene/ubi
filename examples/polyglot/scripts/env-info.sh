#!/usr/bin/env bash
#
# Display detailed environment information
#

set -euo pipefail

# Colors
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}🌐 UBI Polyglot Environment Information${NC}"
echo -e "${CYAN}========================================${NC}\n"

# XDG Base Directory variables
echo -e "${YELLOW}📁 XDG Base Directories:${NC}"
echo "  XDG_CONFIG_HOME: ${XDG_CONFIG_HOME:-Not set}"
echo "  XDG_CACHE_HOME: ${XDG_CACHE_HOME:-Not set}"
echo "  XDG_DATA_HOME: ${XDG_DATA_HOME:-Not set}"
echo "  XDG_STATE_HOME: ${XDG_STATE_HOME:-Not set}"
echo "  XDG_RUNTIME_DIR: ${XDG_RUNTIME_DIR:-Not set}"
echo ""

# Python environment
echo -e "${YELLOW}🐍 Python Environment:${NC}"
if command -v python &> /dev/null; then
    echo "  Python: $(python --version 2>&1)"
    echo "  Location: $(which python)"
    echo "  PYTHONUSERBASE: ${PYTHONUSERBASE:-Not set}"
    echo "  PYTHONPATH: ${PYTHONPATH:-Not set}"
else
    echo "  Python: Not available"
fi
echo ""

# Node.js environment
echo -e "${YELLOW}📦 Node.js Environment:${NC}"
if command -v node &> /dev/null; then
    echo "  Node.js: $(node --version 2>&1)"
    echo "  Location: $(which node)"
    echo "  npm: $(npm --version 2>&1)"
    echo "  npm config userconfig: ${npm_config_userconfig:-Not set}"
    echo "  npm config cache: ${npm_config_cache:-Not set}"
else
    echo "  Node.js: Not available"
fi
echo ""

# General environment
echo -e "${YELLOW}⚙️  General Environment:${NC}"
echo "  LANG: ${LANG:-Not set}"
echo "  EDITOR: ${EDITOR:-Not set}"
echo "  SHELL: ${SHELL:-Not set}"
echo "  HOME: ${HOME:-Not set}"
echo "  USER: ${USER:-Not set}"
echo "  PATH: ${PATH:-Not set}"
echo ""

# System information
echo -e "${YELLOW}💻 System Information:${NC}"
echo "  OS: $(uname -s)"
echo "  Architecture: $(uname -m)"
echo "  Kernel: $(uname -r)"
if command -v bash &> /dev/null; then
    echo "  Bash: $(bash --version | head -n1)"
fi
echo ""

echo -e "${CYAN}========================================${NC}\n"
