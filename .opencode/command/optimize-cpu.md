---
description: Reduce unnecessary CPU work
agent: build
---

Reduce CPU usage for: `$ARGUMENTS`

Steps:
1. Look for repeated calculations during render, synchronous work on the main thread, expensive sorting/filtering, and recomputation of derived invoice totals.
2. Move work off hot paths or memoize only when measurements show benefit.
3. Consider debouncing expensive user-triggered operations (search, recalculation, preview generation).
4. Keep calculations deterministic and covered by tests.
5. Measure before/after and run `npm run lint`, `npm test`.

Report hot paths found, changes, and measured or estimated impact.
