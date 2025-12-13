# Python CLI Example

This example demonstrates using UBI as a base for a simple Python command-line application.

## What's Included

- **Simple CLI app**: A greeting tool that demonstrates Python CLI best practices
- **pyproject.toml**: Modern Python dependency management
- **XDG compliance**: Uses UBI's XDG directory structure for configuration
- **Devcontainer configuration**: Ready-to-use VS Code devcontainer setup

## Prerequisites

- Docker installed
- VS Code with Remote-Containers extension (recommended)

## Getting Started

### Option 1: Open in VS Code (Recommended)

1. Open this directory in VS Code
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and start
4. You're ready to go!

### Option 2: Manual Docker Build

```bash
# Build the container
docker build -f .devcontainer/Dockerfile -t python-cli-example .

# Run interactively
docker run -it --rm python-cli-example bash
```

## Running the Application

Once inside the container:

```bash
# Install dependencies
pip install -e .

# Run the CLI tool
greet --help
greet --name "Developer"

# Or run directly
python -m greet_cli --name "World"
```

## Project Structure

```
python-cli/
├── .devcontainer/
│   └── devcontainer.json    # VS Code devcontainer configuration
├── greet_cli/
│   ├── __init__.py          # Package initialization
│   └── cli.py               # Main CLI application
├── pyproject.toml           # Python project configuration
└── README.md                # This file
```

## What This Example Demonstrates

1. **UBI as Base Image**: Using `ghcr.io/egohygiene/ubi:0.1.5` as the foundation
2. **Python Development**: Modern Python tooling with pyproject.toml
3. **CLI Applications**: Using Click for command-line interfaces
4. **XDG Compliance**: Leveraging UBI's XDG directory structure
5. **Developer Experience**: Quick setup with minimal configuration

## Customizing for Your Project

To adapt this example for your own Python project:

1. Update `pyproject.toml` with your project name and dependencies
2. Modify the CLI code in `greet_cli/` to match your application logic
3. Adjust the devcontainer configuration as needed
4. Add any additional Python dependencies your project requires

## Next Steps

- Explore other examples: [Node.js](../node-express/), [Polyglot](../polyglot/)
- Learn more about UBI: [Main Documentation](../../README.md)
- Understand the architecture: [Architecture Docs](../../docs/architecture.md)
