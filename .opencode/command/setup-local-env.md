---
description: Configure the local development environment
agent: build
---

Set up local environment configuration.

Steps:
1. Inspect `vite.config.js`, `server.js`, and the codebase for existing env usage (`import.meta.env`, `process.env`).
2. Create or update `.env.example` with placeholder values only; never put real secrets in it.
3. For local defaults, document how to create `.env.local` (Vite loads it) and any server-side variables.
4. Remember: only `VITE_`-prefixed variables reach the browser and are public. Server secrets must not use that prefix.
5. Confirm `.gitignore` excludes `.env*` except `.env.example`.
6. Verify the app starts with `npm run dev:win` or `npm run dev` and report the required variables.

Do not copy production credentials anywhere. Do not commit `.env` files.
