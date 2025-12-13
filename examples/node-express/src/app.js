/**
 * Express application setup
 *
 * This demonstrates a simple Express REST API running in UBI with:
 * - Multiple endpoints
 * - XDG-compliant directory usage
 * - Environment information display
 */

import express from "express";

const app = express();

// Middleware
app.use(express.json());

// Request logging middleware
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${req.method} ${req.path}`);
  next();
});

// Root endpoint
app.get("/", (req, res) => {
  res.json({
    message: "Welcome to the UBI Node.js Express Example!",
    version: "0.1.0",
    endpoints: {
      health: "/api/health",
      greeting: "/api/greet/:name",
      environment: "/api/env",
    },
    documentation: "See README.md for more information",
  });
});

// Health check endpoint
app.get("/api/health", (req, res) => {
  res.json({
    status: "healthy",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || "development",
  });
});

// Greeting endpoint
app.get("/api/greet/:name?", (req, res) => {
  const name = req.params.name || "World";
  const excited = req.query.excited === "true";
  const greeting = req.query.greeting || "Hello";

  const punctuation = excited ? "!" : ".";
  const message = `${greeting}, ${name}${punctuation}`;

  // Demonstrate XDG directory usage
  const configHome = process.env.XDG_CONFIG_HOME || "~/.config";

  res.json({
    message,
    metadata: {
      name,
      greeting,
      excited,
      configDir: `${configHome}/node-express-example/`,
    },
  });
});

// Environment information endpoint
app.get("/api/env", (req, res) => {
  // XDG Base Directory variables
  const xdgVars = {
    XDG_CONFIG_HOME: process.env.XDG_CONFIG_HOME,
    XDG_CACHE_HOME: process.env.XDG_CACHE_HOME,
    XDG_DATA_HOME: process.env.XDG_DATA_HOME,
    XDG_STATE_HOME: process.env.XDG_STATE_HOME,
    XDG_RUNTIME_DIR: process.env.XDG_RUNTIME_DIR,
  };

  // Node.js specific variables
  const nodeVars = {
    NODE_VERSION: process.version,
    NODE_ENV: process.env.NODE_ENV,
    npm_config_userconfig: process.env.npm_config_userconfig,
    npm_config_cache: process.env.npm_config_cache,
    npm_config_prefix: process.env.npm_config_prefix,
  };

  // General environment
  const generalVars = {
    LANG: process.env.LANG,
    EDITOR: process.env.EDITOR,
    SHELL: process.env.SHELL,
    HOME: process.env.HOME,
    USER: process.env.USER,
  };

  res.json({
    message: "UBI Environment Information",
    xdg: xdgVars,
    node: nodeVars,
    general: generalVars,
    platform: {
      platform: process.platform,
      arch: process.arch,
      pid: process.pid,
      uptime: process.uptime(),
      memory: process.memoryUsage(),
    },
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: "Not Found",
    message: `The requested resource ${req.path} was not found`,
    availableEndpoints: ["/", "/api/health", "/api/greet/:name", "/api/env"],
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error("Error:", err);
  res.status(500).json({
    error: "Internal Server Error",
    message: err.message,
  });
});

export default app;
