# UBI Usage Examples

This directory contains practical examples demonstrating how to use UBI (Universal Base Image) in various real-world scenarios.

## 📚 Available Examples

### 1. [Python CLI](./python-cli/)
A simple command-line interface application built with Python and Click.

**Demonstrates:**
- Python development environment
- CLI tool creation with Click
- XDG-compliant directory usage
- Modern Python packaging with pyproject.toml

**Use Cases:**
- Command-line tools
- Data processing scripts
- Automation utilities

---

### 2. [Node.js Express](./node-express/)
A REST API server built with Express.js.

**Demonstrates:**
- Node.js development environment
- REST API development
- Express.js best practices
- XDG-compliant configuration

**Use Cases:**
- Web APIs
- Microservices
- Backend applications

---

### 3. [Polyglot](./polyglot/)
A multi-language project combining Python, Node.js, and Bash.

**Demonstrates:**
- Multi-language development
- Inter-process communication
- Bash orchestration scripts
- Unified development environment
- Component coordination

**Use Cases:**
- Full-stack applications
- Data pipelines
- Complex workflows
- Microservices architectures

---

## 🚀 Quick Start

Each example is self-contained and can be opened directly in VS Code:

```bash
# Navigate to an example
cd examples/python-cli

# Open in VS Code
code .

# When prompted, click "Reopen in Container"
```

Alternatively, you can use Docker directly:

```bash
cd examples/python-cli
docker run -it --rm -v $(pwd):/workspace ghcr.io/egohygiene/ubi:0.1.5 bash
```

## 📖 What These Examples Show

### Common Patterns

All examples demonstrate:

1. **Using UBI as a base image** - Simple devcontainer configuration
2. **XDG compliance** - Proper use of XDG directory structure
3. **Modern tooling** - Current best practices for each language
4. **Developer experience** - Quick setup with minimal configuration
5. **Clear documentation** - Each example has comprehensive README

### Progressive Complexity

- **Python CLI** - Simplest example, single language, CLI-focused
- **Node.js Express** - Web server, REST API patterns
- **Polyglot** - Most complex, multiple languages and coordination

## 🎯 Learning Path

We recommend exploring the examples in this order:

1. **Start with Python CLI** to understand the basics of UBI and devcontainers
2. **Try Node.js Express** to see how web applications work in UBI
3. **Explore Polyglot** to understand multi-language projects

## 🛠️ Requirements

To use these examples, you'll need:

- **Docker** (20.10+) or **Podman** (3.0+)
- **VS Code** (1.75+) with Remote-Containers extension (recommended)
- Basic familiarity with the programming languages used

## 📂 Example Structure

Each example follows a consistent structure:

```
example-name/
├── .devcontainer/
│   └── devcontainer.json    # VS Code devcontainer config
├── src/                      # Source code
├── package.json             # (Node.js) or
├── pyproject.toml           # (Python) dependencies
└── README.md                # Detailed instructions
```

## 🔧 Customizing for Your Project

These examples are templates you can adapt:

1. **Copy an example** that matches your use case
2. **Update dependencies** in package.json, pyproject.toml, etc.
3. **Modify the code** to match your application logic
4. **Adjust devcontainer.json** for your specific tools
5. **Test thoroughly** in the UBI environment

## 🌟 Best Practices Demonstrated

### Version Pinning
All examples pin to a specific UBI version (`0.1.5`) for reproducibility. In production, always use:

```json
"image": "ghcr.io/egohygiene/ubi:0.1.5"
```

Rather than:

```json
"image": "ghcr.io/egohygiene/ubi:latest"
```

### XDG Directory Usage
Examples show how to use UBI's XDG-compliant directory structure:

- `$XDG_CONFIG_HOME` - Configuration files
- `$XDG_CACHE_HOME` - Cache data
- `$XDG_DATA_HOME` - Application data
- `$XDG_STATE_HOME` - State files

### Minimal Configuration
Examples use minimal devcontainer configuration, relying on UBI's defaults.

## 📚 Additional Resources

- [UBI Documentation](../README.md) - Main documentation
- [Architecture Overview](../docs/architecture.md) - Understanding UBI's design
- [Contributing Guide](../CONTRIBUTING.md) - How to contribute
- [Troubleshooting](../docs/troubleshooting.md) - Common issues and solutions

## 💡 Tips

### Testing Changes
```bash
# Build locally to test changes
docker build -f .devcontainer/Dockerfile -t my-example:test .

# Run interactively
docker run -it --rm my-example:test bash
```

### Debugging
```bash
# Check environment variables
printenv | grep XDG

# Verify directory structure
ls -la /opt/universal/

# Check installed tools
python --version
node --version
```

### Performance
- Use named volumes for package caches (npm, pip) to speed up rebuilds
- Consider using `postCreateCommand` for one-time setup
- Use `postStartCommand` for services that need to run

## 🤝 Contributing

Found an issue or want to add an example?

1. Check existing [issues](https://github.com/egohygiene/ubi/issues)
2. Open a new issue or PR
3. Follow the [Contributing Guide](../CONTRIBUTING.md)

## 📄 License

These examples are part of the UBI project and are licensed under the MIT License. See [LICENSE](../LICENSE) for details.

---

**Questions?** Open an [issue](https://github.com/egohygiene/ubi/issues) or start a [discussion](https://github.com/egohygiene/ubi/discussions).
