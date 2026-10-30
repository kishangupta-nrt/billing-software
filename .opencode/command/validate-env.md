---
description: Validate required environment variables
agent: build
---

Validate environment variable configuration.

Steps:
1. Inventory every env var referenced in `src/`, `server.js`, `vite.config.js`, and scripts.
2. For each, record: name, required/optional, consumer (client/server), format, and safe default.
3. Check for typos, unused variables, and client/server prefix mistakes (`VITE_` is public).
4. Recommend or implement startup validation (fail fast with a clear message, without printing secret values).
5. Test startup with variables missing and with invalid values.
6. Update `.env.example` to match reality.

Do not print secret values in output or logs.
