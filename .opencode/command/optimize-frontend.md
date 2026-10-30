---
description: Reduce frontend rendering and loading overhead
agent: build
---

Optimize frontend performance for: `$ARGUMENTS`

Steps:
1. Measure first: build, inspect bundle output, and identify slow renders/re-renders in `src/`.
2. Look for unnecessary work on render, missing memoization of expensive lists, large component trees, and blocking synchronous work.
3. Prefer structural fixes (splitting components, derived-state calculation, lazy loading) over blanket `useMemo`/`useCallback`.
4. Preserve behavior, offline support, and accessibility.
5. Re-measure and run `npm run lint`, `npm test`, `npm run build`.

Report before/after metrics and the reasoning for each change. Do not optimize without evidence.
