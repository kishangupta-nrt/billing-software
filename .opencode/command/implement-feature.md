---
description: Implement a complete feature end to end
agent: build
---

Implement this feature: `$ARGUMENTS`

Steps:
1. Explore the relevant areas: `src/components/`, `src/services/`, `src/utils/`, `src/store.js`, `server.js`, and existing tests/docs.
2. Write a short plan covering UI, state/persistence, validation, offline behavior, and tests.
3. Implement the smallest coherent change following existing patterns; avoid new dependencies unless justified.
4. Handle empty, error, and offline states; keep user data safe.
5. Add tests in the existing style (`scripts/*-test.mjs`, `tests/smoke.mjs`).
6. Update user-facing docs if behavior changed.
7. Run `npm run lint`, `npm test`, and `npm run build`.

Report the changes and any follow-ups. Do not commit unless asked.
