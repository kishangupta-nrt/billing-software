---
description: Improve backend execution performance
agent: build
---

Optimize backend performance for: `$ARGUMENTS`

Steps:
1. Inspect `server.js` for synchronous filesystem work, repeated parsing, blocking middleware, and unnecessary work per request.
2. Measure where possible (timing logs locally, repeated requests) before changing code.
3. Cache safely where data is stable; avoid caching user-sensitive responses incorrectly.
4. Keep the server optional and the app functional offline.
5. Verify with `npm run server`, exercise routes, and run `npm run lint`.

Report measured impact and any trade-offs (memory, staleness). Do not add infrastructure the app does not need.
