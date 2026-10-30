---
description: Ensure environments are isolated
agent: build
---

Review and enforce isolation between local, staging, and production.

Steps:
1. Identify how configuration is loaded in this Vite + Express app (Vite modes, server `process.env`, hosting injection).
2. Check for shared endpoints, credentials, storage keys, or data that could cross environments.
3. Ensure localStorage/IndexedDB names or backup targets are environment-scoped where needed.
4. Ensure production/staging secrets cannot be loaded by a local run.
5. Document the precedence and loading order clearly in `.env.example` or docs.
6. Verify no environment file with real values is tracked.

Report the isolation model and any gaps with `file:line`.
