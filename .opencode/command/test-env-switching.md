---
description: Verify environment switching works correctly
agent: build
---

Verify that switching between local, staging, and production configuration behaves correctly.

Steps:
1. Identify the supported mechanisms (Vite `--mode`, `.env.*` files, hosting-injected variables).
2. For each environment, confirm the app resolves the right API URLs, storage settings, logging level, and debug flags.
3. Build for each mode and inspect for leaked/incorrect values.
4. Confirm data does not bleed between environments and that production fails safely when variables are missing.
5. Run `npm run lint`, `npm test`, and the relevant `npm run build`.

Report the matrix of environments, what was verified, and any mismatches. Do not deploy anything.
