---
description: Reduce memory consumption
agent: build
---

Reduce memory usage for: `$ARGUMENTS`

Steps:
1. Identify likely sources: large in-memory invoice/customer lists, PDF/canvas rendering, OCR processing, unbounded caches, and listeners that are never removed.
2. Check for leaks: event listeners, timers, observers, and stale closures in React effects.
3. Prefer releasing large buffers and avoiding duplicate copies of serialized data.
4. Measure with browser devtools or Node where feasible; include realistic data sizes.
5. Run `npm run lint`, relevant tests, and `npm run build`.

Report findings, changes, and measured impact. Do not guess at numbers.
