#!/usr/bin/env node
/**
 * Server entry point
 *
 * Starts the Express server on the configured port.
 */

import app from "./app.js";

const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || "0.0.0.0";

const server = app.listen(PORT, HOST, () => {
  console.log("\n🚀 Server started successfully!");
  console.log(`📍 Listening on http://${HOST}:${PORT}`);
  console.log(`🌐 UBI Node.js Express Example`);
  console.log(`\nAvailable endpoints:`);
  console.log(`  GET  /                 - Welcome message`);
  console.log(`  GET  /api/health       - Health check`);
  console.log(`  GET  /api/greet/:name  - Personalized greeting`);
  console.log(`  GET  /api/env          - Environment information`);
  console.log(`\nPress Ctrl+C to stop\n`);
});

// Graceful shutdown
process.on("SIGTERM", () => {
  console.log("\n⏸️  SIGTERM received, shutting down gracefully...");
  server.close(() => {
    console.log("✅ Server closed");
    process.exit(0);
  });
});

process.on("SIGINT", () => {
  console.log("\n⏸️  SIGINT received, shutting down gracefully...");
  server.close(() => {
    console.log("✅ Server closed");
    process.exit(0);
  });
});
