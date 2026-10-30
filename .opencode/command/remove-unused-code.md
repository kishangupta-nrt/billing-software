---
description: Identify and safely remove unused code
agent: build
---

Remove unused code for: `$ARGUMENTS`

Steps:
1. Establish a baseline: `npm run lint`, `npm test`, `npm run build`.
2. Identify unused files, exports, imports, CSS, dependencies, and assets using search (not guesswork).
3. Confirm each candidate is truly unused, including dynamic imports, string references, service-worker caches, and build scripts.
4. Remove in small, reviewable batches; keep public/entry points intact.
5. Re-run lint, tests, and build after each batch.
6. Report removed items and any dependency removals, noting bundle-size impact.

Do not remove code merely because it looks unused; verify first.
