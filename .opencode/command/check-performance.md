---
description: Run a performance analysis
agent: build
---

Analyze performance for: `$ARGUMENTS` (whole app if empty). This is read-only unless fixes are requested.

Steps:
1. Build and inspect Vite output: chunk sizes, warnings, and asset weights.
2. Review startup path: what loads before first render, heavy dependencies, and blocking work.
3. Review runtime hot paths: invoice recalculation, large lists, PDF/OCR, import/export.
4. Check PWA caching and offline startup behavior.
5. If feasible, capture browser performance traces or basic timings; otherwise clearly mark estimates.
6. Report prioritized opportunities with expected impact and effort. Do not fabricate measurements.
