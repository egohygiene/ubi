/**
 * Express API server for the polyglot example
 *
 * This server coordinates between Python processing and provides
 * a REST API for the overall system.
 */

import express from "express";
import { spawn } from "child_process";
import { promises as fs } from "fs";
import { join } from "path";
import { homedir } from "os";

const app = express();

// Middleware
app.use(express.json());

// Request logging
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${req.method} ${req.path}`);
  next();
});

// Root endpoint
app.get("/", (req, res) => {
  res.json({
    message: "Welcome to the UBI Polyglot Example!",
    description:
      "This demonstrates Python + Node.js + Bash working together in UBI",
    version: "0.1.0",
    endpoints: {
      health: "/api/health",
      process: "POST /api/process",
      results: "/api/results",
      environment: "/api/env",
    },
    components: {
      api: "Node.js Express (this server)",
      processor: "Python data processor",
      orchestration: "Bash scripts",
    },
  });
});

// Health check
app.get("/api/health", (req, res) => {
  res.json({
    status: "healthy",
    timestamp: new Date().toISOString(),
    components: {
      node: {
        status: "running",
        version: process.version,
      },
      python: {
        status: "available",
        path: "/usr/local/bin/python",
      },
    },
  });
});

// Trigger Python processing
app.post("/api/process", async (req, res) => {
  const { input = "Sample data from API" } = req.body;

  try {
    console.log("🔄 Triggering Python processor...");

    const result = await runPythonProcessor(input);

    res.json({
      status: "success",
      message: "Processing completed",
      timestamp: new Date().toISOString(),
      result: result,
    });
  } catch (error) {
    console.error("Error running processor:", error);
    res.status(500).json({
      status: "error",
      message: error.message,
    });
  }
});

// Get processing results
app.get("/api/results", async (req, res) => {
  try {
    const xdgDataHome =
      process.env.XDG_DATA_HOME || join(homedir(), ".local", "share");
    const resultPath = join(xdgDataHome, "polyglot-example", "result.txt");

    const content = await fs.readFile(resultPath, "utf-8");

    res.json({
      status: "success",
      result: content,
      file: resultPath,
    });
  } catch (error) {
    res.status(404).json({
      status: "error",
      message: "No results found. Try POST /api/process first.",
      error: error.message,
    });
  }
});

// Environment information
app.get("/api/env", (req, res) => {
  const xdgVars = {
    XDG_CONFIG_HOME: process.env.XDG_CONFIG_HOME,
    XDG_CACHE_HOME: process.env.XDG_CACHE_HOME,
    XDG_DATA_HOME: process.env.XDG_DATA_HOME,
    XDG_STATE_HOME: process.env.XDG_STATE_HOME,
    XDG_RUNTIME_DIR: process.env.XDG_RUNTIME_DIR,
  };

  res.json({
    message: "Polyglot Environment Information",
    xdg: xdgVars,
    node: {
      version: process.version,
      platform: process.platform,
      arch: process.arch,
    },
    python: {
      available: true,
      path: "/usr/local/bin/python",
    },
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: "Not Found",
    message: `The requested resource ${req.path} was not found`,
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

/**
 * Run the Python processor with given input
 */
function runPythonProcessor(input) {
  return new Promise((resolve, reject) => {
    const pythonProcess = spawn("python", [
      "-m",
      "processor.main",
      "--input",
      input,
    ], {
      cwd: join(process.cwd(), "..", "python"),
    });

    let stdout = "";
    let stderr = "";

    pythonProcess.stdout.on("data", (data) => {
      stdout += data.toString();
    });

    pythonProcess.stderr.on("data", (data) => {
      stderr += data.toString();
    });

    pythonProcess.on("close", (code) => {
      if (code !== 0) {
        reject(new Error(`Python processor failed: ${stderr}`));
      } else {
        resolve({
          output: stdout,
          input: input,
        });
      }
    });

    pythonProcess.on("error", (error) => {
      reject(error);
    });
  });
}

export default app;
