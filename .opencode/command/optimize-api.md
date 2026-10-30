---
description: Reduce API latency
agent: build
---

Optimize API latency for: `$ARGUMENTS`

Steps:
1. Measure current response times for the relevant routes in `server.js`.
2. Identify avoidable work: repeated I/O, redundant serialization, unnecessary middleware, and chatty client calls.
3. Reduce round trips and payload sizes; add caching only where correctness allows.
4. Preserve error semantics and offline behavior.
5. Re-measure and run `npm run lint`.

Report baseline vs optimized timings and remaining bottlenecks. Do not add external infrastructure without approval.
