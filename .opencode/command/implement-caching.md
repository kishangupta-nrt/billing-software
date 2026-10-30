---
description: Introduce appropriate caching
agent: build
---

Add caching for: `$ARGUMENTS`

Steps:
1. Identify what is expensive and stable enough to cache (computed totals, parsed reference data, HTTP responses, static assets).
2. Choose the right layer: memoization, in-memory cache, HTTP cache headers, or PWA/service-worker caching.
3. Define invalidation precisely; never serve stale financial data where correctness matters.
4. Do not cache sensitive user data in shared caches.
5. Add tests for cache hit/miss/invalidation behavior.
6. Verify with `npm run lint`, `npm test`, `npm run build`.

Report the cache design, invalidation rules, and trade-offs.
