#!/usr/bin/env node
/**
 * Server entry point for the polyglot API
 */

import app from "./app.js";

const PORT = process.env.PORT || 4000;
const HOST = process.env.HOST || "0.0.0.0";

const server = app.listen(PORT, HOST, () => {
  console.log("\n🚀 Polyglot API Server started!");
  console.log(`📍 Listening on http://${HOST}:${PORT}`);
  console.log(`🌐 UBI Polyglot Example`);
  console.log(`\nComponents:`);
  console.log(`  ✓ Node.js API Server (this)`);
  console.log(`  ✓ Python Data Processor`);
  console.log(`  ✓ Bash Orchestration Scripts`);
  console.log(`\nAvailable endpoints:`);
  console.log(`  GET  /                 - Welcome and info`);
  console.log(`  GET  /api/health       - Health check`);
  console.log(`  POST /api/process      - Trigger Python processing`);
  console.log(`  GET  /api/results      - Get processing results`);
  console.log(`  GET  /api/env          - Environment information`);
  console.log(`\nPress Ctrl+C to stop\n`);
});

// Graceful shutdown
const shutdown = () => {
  console.log("\n⏸️  Shutting down gracefully...");
  server.close(() => {
    console.log("✅ Server closed");
    process.exit(0);
  });
};

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
