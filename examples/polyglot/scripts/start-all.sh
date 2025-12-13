#!/usr/bin/env bash
#
# Start all components of the polyglot example
#

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Starting Polyglot Example${NC}"
echo -e "${BLUE}============================${NC}\n"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Ensure dependencies are installed
if [ ! -d "$PROJECT_ROOT/node/node_modules" ]; then
    echo -e "${YELLOW}⚠️  Node.js dependencies not found. Running setup...${NC}"
    "$SCRIPT_DIR/setup.sh"
fi

# Start Node.js API server
echo -e "${GREEN}📡 Starting Node.js API server on port 4000...${NC}"
cd "$PROJECT_ROOT/node"
npm start &
NODE_PID=$!
echo -e "${GREEN}✅ Node.js server started (PID: $NODE_PID)${NC}\n"

# Wait a moment for the server to start
sleep 2

# Test the Python processor
echo -e "${GREEN}🐍 Testing Python processor...${NC}"
cd "$PROJECT_ROOT/python"
python -m processor.main --input "Test data from startup script"
echo ""

echo -e "${BLUE}========================${NC}"
echo -e "${GREEN}✨ All components started!${NC}"
echo -e "${BLUE}========================${NC}\n"
echo -e "API Server: http://localhost:4000"
echo -e "Node.js PID: $NODE_PID"
echo -e "\nPress Ctrl+C to stop all services\n"

# Wait for the Node.js process
wait $NODE_PID
