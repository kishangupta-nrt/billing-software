---
description: Check existing functionality for regressions
agent: build
---

Run the regression suite after recent changes.

Steps:
1. Review the current diff and identify affected areas.
2. Run `npm run lint`, `npm run test:unit`, `npm test`, and `npm run build`.
3. Exercise the primary flows affected by the change (invoice creation, tax/discount calculation, import/export, persistence).
4. Compare behavior against the previous working state; flag any difference.
5. If something regressed, identify the cause and fix it only if asked; otherwise report clearly.

Report: commands run, pass/fail, regressions found, and recommended next steps.
