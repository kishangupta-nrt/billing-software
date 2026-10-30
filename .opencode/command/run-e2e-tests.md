---
description: Test complete user journeys with a browser
agent: build
---

Run end-to-end tests for the journey described by: `$ARGUMENTS`

Setup:
1. Inspect `scripts/test-update-unix.mjs`, `tests/`, and `playwright` usage to follow the existing approach.
2. Install the browser if needed with `npm run test:install` (firefox) or the equivalent.
3. Start the app (`npm run dev:win` on Windows or `npm run dev`) and wait for it to be ready.

Test:
4. Cover the real user flow: create invoice, add customer/item, tax calculation, save, print/PDF, export/backup where relevant.
5. Assert on visible behavior and persisted data, not implementation details.
6. Capture failures with steps to reproduce and screenshots/logs.

Report results per journey. Add or update E2E coverage only if requested.
