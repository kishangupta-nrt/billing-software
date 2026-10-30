---
description: Refactor code without changing behavior
agent: build
---

Refactor the target described by: `$ARGUMENTS`

Rules:
1. Establish a baseline first: run `npm run lint`, `npm test`, and the relevant manual flow.
2. Preserve observable behavior, public APIs, storage schema, and UI output.
3. Make small, focused changes; do not mix in feature work or dependency upgrades.
4. Reuse existing helpers and remove duplication only where it is clearly safe.
5. Keep or add tests that lock in existing behavior.
6. Re-run `npm run lint`, `npm test`, and `npm run build` to prove no regressions.

If a behavior change is unavoidable, stop and explain why before proceeding.
