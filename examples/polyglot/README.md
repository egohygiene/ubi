# Polyglot Example

This example demonstrates using UBI as a base for a multi-language project that combines Python, Node.js, and Bash scripting.

## What's Included

- **Python data processor**: Processes data and generates reports
- **Node.js API server**: REST API for interacting with the system
- **Bash orchestration**: Scripts to coordinate between components
- **XDG compliance**: All components use UBI's XDG directory structure
- **Devcontainer configuration**: Ready-to-use VS Code devcontainer setup

## Prerequisites

- Docker installed
- VS Code with Remote-Containers extension (recommended)

## Getting Started

### Option 1: Open in VS Code (Recommended)

1. Open this directory in VS Code
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and start
4. All dependencies will be installed automatically

### Option 2: Manual Docker Build

```bash
# Build the container
docker build -f .devcontainer/Dockerfile -t polyglot-example .

# Run interactively
docker run -it --rm -p 4000:4000 polyglot-example bash
```

## Running the Application

Once inside the container:

```bash
# Install all dependencies
./scripts/setup.sh

# Start the full stack
./scripts/start-all.sh

# Or run components individually:

# Start the Node.js API server
cd node && npm start &

# Run the Python data processor
cd python && python -m processor.main

# Check system status
./scripts/status.sh
```

The API server will be available at http://localhost:4000

## Project Structure

```
polyglot/
├── .devcontainer/
│   └── devcontainer.json    # VS Code devcontainer configuration
├── python/
│   ├── processor/           # Python data processing module
│   │   ├── __init__.py
│   │   ├── main.py          # Main processor
│   │   └── utils.py         # Utility functions
│   ├── requirements.txt     # Python dependencies
│   └── pyproject.toml       # Python project configuration
├── node/
│   ├── src/
│   │   ├── app.js           # Express application
│   │   └── server.js        # Server entry point
│   └── package.json         # Node.js dependencies
├── scripts/
│   ├── setup.sh             # Install all dependencies
│   ├── start-all.sh         # Start all services
│   ├── status.sh            # Check service status
│   └── env-info.sh          # Display environment info
└── README.md                # This file
```

## API Endpoints

- `GET /` - Welcome and status information
- `GET /api/health` - Health check for all services
- `POST /api/process` - Trigger Python data processing
- `GET /api/results` - Get processing results
- `GET /api/env` - Display environment information

Try them out:

```bash
# Welcome and status
curl http://localhost:4000/

# Health check
curl http://localhost:4000/api/health

# Trigger processing
curl -X POST http://localhost:4000/api/process \
  -H "Content-Type: application/json" \
  -d '{"input": "sample data"}'

# Get results
curl http://localhost:4000/api/results

# Environment info
curl http://localhost:4000/api/env
```

## What This Example Demonstrates

1. **Multi-Language Support**: Python, Node.js, and Bash working together
2. **Language Interoperability**: Components communicate via files and processes
3. **XDG Compliance**: All components respect UBI's XDG directory structure
4. **Unified Environment**: Single container runs multiple technology stacks
5. **Orchestration**: Bash scripts coordinate the different components
6. **Modern Tooling**: Each language uses its best practices and tools

## Use Cases

This pattern is ideal for:

- **Data pipelines**: Process data with Python, serve with Node.js
- **Full-stack applications**: Backend logic in Python, frontend API in Node.js
- **DevOps automation**: Orchestrate multi-language tools
- **Microservices**: Multiple services in one development environment
- **Monorepo projects**: Different languages for different components

## Customizing for Your Project

To adapt this example for your own polyglot project:

1. Add additional language components as needed
2. Update dependencies in respective `package.json`, `requirements.txt`, etc.
3. Modify orchestration scripts to match your workflow
4. Adjust the devcontainer configuration for your tools
5. Consider splitting into separate containers for production

## Scripts Reference

### `setup.sh`
Installs all dependencies for Python and Node.js components.

```bash
./scripts/setup.sh
```

### `start-all.sh`
Starts all services in the background.

```bash
./scripts/start-all.sh
```

### `status.sh`
Checks the status of all running services.

```bash
./scripts/status.sh
```

### `env-info.sh`
Displays detailed environment information.

```bash
./scripts/env-info.sh
```

## Next Steps

- Explore other examples: [Python](../python-cli/), [Node.js](../node-express/)
- Learn more about UBI: [Main Documentation](../../README.md)
- Understand the architecture: [Architecture Docs](../../docs/architecture.md)
