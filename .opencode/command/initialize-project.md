---
description: Verify the existing project is set up and ready to work on
agent: build
---

Initialize/verify this repository for development. This is an existing app, not a blank project.

Context: Free GST Billing Software is a React 19 + Vite 7 SPA (`src/`) with an Express 5 server (`server.js`), offline-first PWA, data persisted in localStorage via `src/store.js`.

Steps:
1. Inspect `package.json`, lockfile, `vite.config.js`, `server.js`, `src/`, `tests/`, and existing docs.
2. Confirm Node >= 18, install state, and that scripts `dev:win`, `build`, `lint`, `test` exist and work.
3. Check for missing environment/docs scaffolding (`.env.example`, `AGENTS.md`) without overwriting existing files.
4. Report a concise readiness summary: available commands, missing pieces, and risks.
5. Do not scaffold over or delete existing code. Do not commit anything.
