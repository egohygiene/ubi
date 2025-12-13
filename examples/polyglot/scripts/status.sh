#!/usr/bin/env bash
#
# Check status of all components
#

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📊 Polyglot Example Status${NC}"
echo -e "${BLUE}==========================${NC}\n"

# Check Node.js server
echo -e "${YELLOW}📡 Node.js API Server:${NC}"
if pgrep -f "node.*src/server.js" > /dev/null; then
    PID=$(pgrep -f "node.*src/server.js")
    echo -e "  Status: ${GREEN}Running${NC} (PID: $PID)"
    
    # Try to query the health endpoint
    if command -v curl &> /dev/null; then
        if curl -s http://localhost:4000/api/health > /dev/null 2>&1; then
            echo -e "  Health: ${GREEN}Healthy${NC}"
        else
            echo -e "  Health: ${RED}Not responding${NC}"
        fi
    fi
else
    echo -e "  Status: ${RED}Not running${NC}"
fi
echo ""

# Check Python availability
echo -e "${YELLOW}🐍 Python Processor:${NC}"
if command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version 2>&1)
    echo -e "  Available: ${GREEN}Yes${NC}"
    echo -e "  Version: $PYTHON_VERSION"
    
    # Check if processor module is available
    if python -c "import processor" 2>/dev/null; then
        echo -e "  Module: ${GREEN}Installed${NC}"
    else
        echo -e "  Module: ${RED}Not installed${NC}"
    fi
else
    echo -e "  Available: ${RED}No${NC}"
fi
echo ""

# Check Bash
echo -e "${YELLOW}🔧 Bash:${NC}"
if command -v bash &> /dev/null; then
    BASH_VERSION=$(bash --version | head -n1)
    echo -e "  Available: ${GREEN}Yes${NC}"
    echo -e "  Version: $BASH_VERSION"
else
    echo -e "  Available: ${RED}No${NC}"
fi
echo ""

# XDG directories
echo -e "${YELLOW}📁 XDG Directories:${NC}"
echo -e "  Config: ${XDG_CONFIG_HOME:-~/.config}"
echo -e "  Cache:  ${XDG_CACHE_HOME:-~/.cache}"
echo -e "  Data:   ${XDG_DATA_HOME:-~/.local/share}"
echo ""

# Check for results
RESULT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/polyglot-example"
if [ -d "$RESULT_DIR" ]; then
    echo -e "${YELLOW}📄 Processing Results:${NC}"
    if [ -f "$RESULT_DIR/result.txt" ]; then
        echo -e "  Latest: ${GREEN}Found${NC} ($RESULT_DIR/result.txt)"
        # Check OS for appropriate stat command
        if [[ "$OSTYPE" == "darwin"* ]]; then
            MODIFIED=$(stat -f %Sm "$RESULT_DIR/result.txt" 2>/dev/null || echo "Unknown")
        else
            MODIFIED=$(stat -c %y "$RESULT_DIR/result.txt" 2>/dev/null || echo "Unknown")
        fi
        echo -e "  Modified: $MODIFIED"
    else
        echo -e "  Latest: ${YELLOW}No results yet${NC}"
    fi
else
    echo -e "${YELLOW}📄 Processing Results:${NC}"
    echo -e "  Directory: ${YELLOW}Not created yet${NC}"
fi

echo -e "\n${BLUE}==========================${NC}\n"
