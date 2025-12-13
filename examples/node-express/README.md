# Node.js Express Example

This example demonstrates using UBI as a base for a Node.js Express application.

## What's Included

- **Express web server**: A simple REST API with multiple endpoints
- **package.json**: Modern Node.js dependency management
- **XDG compliance**: Uses UBI's XDG directory structure
- **Devcontainer configuration**: Ready-to-use VS Code devcontainer setup

## Prerequisites

- Docker installed
- VS Code with Remote-Containers extension (recommended)

## Getting Started

### Option 1: Open in VS Code (Recommended)

1. Open this directory in VS Code
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and start
4. The server will start automatically on port 3000

### Option 2: Manual Docker Build

```bash
# Build the container
docker build -f .devcontainer/Dockerfile -t node-express-example .

# Run interactively
docker run -it --rm -p 3000:3000 node-express-example bash
```

## Running the Application

Once inside the container:

```bash
# Install dependencies (if not already installed)
npm install

# Start the development server
npm run dev

# Or start in production mode
npm start
```

The server will be available at http://localhost:3000

## API Endpoints

- `GET /` - Welcome message
- `GET /api/health` - Health check endpoint
- `GET /api/greet/:name` - Personalized greeting
- `GET /api/env` - Display UBI environment information

Try them out:

```bash
# Welcome message
curl http://localhost:3000/

# Health check
curl http://localhost:3000/api/health

# Get a greeting
curl http://localhost:3000/api/greet/Developer

# View environment info
curl http://localhost:3000/api/env
```

## Project Structure

```
node-express/
├── .devcontainer/
│   └── devcontainer.json    # VS Code devcontainer configuration
├── src/
│   ├── app.js               # Express application setup
│   └── server.js            # Server entry point
├── package.json             # Node.js project configuration
└── README.md                # This file
```

## What This Example Demonstrates

1. **UBI as Base Image**: Using `ghcr.io/egohygiene/ubi:0.1.5` as the foundation
2. **Node.js Development**: Modern Node.js with Express framework
3. **REST API**: Simple REST endpoints demonstrating common patterns
4. **XDG Compliance**: Leveraging UBI's XDG directory structure
5. **Developer Experience**: Hot-reload development with nodemon

## Customizing for Your Project

To adapt this example for your own Node.js project:

1. Update `package.json` with your project name and dependencies
2. Modify the Express routes in `src/app.js` to match your API
3. Adjust the devcontainer configuration as needed
4. Add any additional Node.js dependencies your project requires
5. Consider adding a database or other services via docker-compose

## Next Steps

- Explore other examples: [Python](../python-cli/), [Polyglot](../polyglot/)
- Learn more about UBI: [Main Documentation](../../README.md)
- Understand the architecture: [Architecture Docs](../../docs/architecture.md)
