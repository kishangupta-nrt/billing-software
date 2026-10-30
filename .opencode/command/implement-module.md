---
description: Implement or extend an application module
agent: build
---

Implement the module described by: `$ARGUMENTS`

Context: React 19 + Vite SPA in `src/` (`App.jsx`, `components/`, `services/`, `utils/`, `store.js`), Express 5 in `server.js`, localStorage-backed offline-first PWA.

Steps:
1. Find the closest existing module and mirror its structure, naming, styling, and state patterns.
2. Reuse existing utilities in `src/utils/` and the store in `src/store.js`; avoid new dependencies unless necessary.
3. Handle offline behavior, validation, and persistence consistently with the rest of the app.
4. Add or update focused tests under `scripts/` or `tests/` following the existing plain-Node test style.
5. Run `npm run lint`, relevant tests, and `npm run build`.
6. Do not touch unrelated files. Do not commit.
