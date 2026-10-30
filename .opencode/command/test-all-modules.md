---
description: Test all application modules
agent: build
---

Test all modules of the application.

Steps:
1. Inventory modules from `src/components/`, `src/services/`, `src/utils/`, `src/store.js`, and `server.js`.
2. Map each to its existing test coverage in `scripts/` and `tests/`.
3. Run `npm run lint`, `npm test`, and `npm run build`.
4. For modules without coverage, perform a focused manual or scripted check of the main path and one error path.
5. Note untested modules and the risk they represent.

Report a coverage matrix: module, test type, result, gaps. Do not claim coverage that does not exist.
