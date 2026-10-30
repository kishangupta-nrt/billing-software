---
description: Execute the unit test suite
agent: build
---

Run the unit tests and report results.

Steps:
1. Run `npm run test:unit` (executes `scripts/tax-test.mjs`, `scripts/discount-modes-test.mjs`, `scripts/csv-test.mjs`).
2. Capture pass/fail counts and the exact failing assertions.
3. If a test fails, identify whether the cause is the test or the implementation; do not alter tests just to make them pass.
4. Re-run the specific failing script after fixes.
5. Report command, results, and any code changes made.

Run `$ARGUMENTS` specifically if provided; otherwise run the full unit suite.
