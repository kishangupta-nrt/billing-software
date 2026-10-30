---
description: Fix confirmed bugs with test coverage
agent: build
---

Fix the confirmed bug(s): `$ARGUMENTS`

Steps:
1. Reproduce the bug first and record the failing scenario.
2. Locate the root cause; avoid patching symptoms in multiple places.
3. Make the smallest fix that preserves existing behavior elsewhere.
4. Add a regression test in the existing style (`scripts/*-test.mjs` or `tests/smoke.mjs`) that fails before and passes after.
5. Run `npm run lint`, `npm test`, and `npm run build`.
6. Report root cause, change, and verification. Do not commit unless asked.

If the bug cannot be reproduced, stop and report what you tried instead of guessing.
