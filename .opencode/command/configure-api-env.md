---
description: Configure API URLs per environment
agent: build
---

Configure environment-specific API endpoints.

Steps:
1. Find all API base URLs and network calls in `src/`, `src/services/`, and `server.js`.
2. Replace hardcoded URLs with configuration (`import.meta.env.VITE_*` for public URLs, `process.env` for server-only values).
3. Provide safe local defaults (for example same-origin or localhost) so the offline-first app still works.
4. Add the variables to `.env.example` with placeholders.
5. Validate URLs at startup and handle offline/unreachable services gracefully.
6. Run `npm run lint` and `npm run build`.

Never put API secrets in `VITE_` variables. Do not commit real endpoints if they are private.
