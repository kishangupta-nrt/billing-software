---
description: Improve server resource utilization
agent: build
---

Optimize `server.js` resource usage for: `$ARGUMENTS`

Steps:
1. Review process behavior: static file serving, compression, caching headers, and per-request work.
2. Identify unnecessary memory retention, repeated file reads, and blocking synchronous calls.
3. Set safe limits (body size, timeouts) and avoid unbounded growth.
4. Keep the server lightweight; this app is designed to run locally on modest hardware.
5. Measure with repeated requests where feasible and verify routes still work.
6. Run `npm run lint`.

Report changes and measured impact. Do not add a reverse proxy/queue/worker system without approval.
