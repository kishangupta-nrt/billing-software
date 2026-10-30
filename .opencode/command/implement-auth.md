---
description: Assess or implement authentication
agent: build
---

Handle the authentication request: `$ARGUMENTS`

First assess reality: this is a local, offline-first, single-user PWA with no server-side accounts. Do not assume an auth system exists.

Steps:
1. Search for existing login/session/token code before writing anything.
2. If no auth model exists, report that clearly and describe the trade-offs of adding one (privacy, offline use, data-at-rest).
3. If implementing, keep credentials server-side, hash passwords with a modern algorithm, use secure session cookies or short-lived tokens, and never store plaintext secrets in localStorage.
4. Preserve offline functionality and existing data access.
5. Add focused tests and run `npm run lint`.

Never commit credentials or `.env` files. Do not weaken existing protections.
