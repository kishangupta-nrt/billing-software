---
description: Test the staging deployment
agent: build
---

Verify the staging deployment.

Steps:
1. Confirm the staging URL and deployed version/commit.
2. Smoke test: app loads, assets and PWA manifest resolve, no console errors.
3. Core flows: create/edit an invoice, tax and discount calculation, save/reload persistence, print/PDF, import/export.
4. Verify staging-specific configuration is used (API URLs, storage, logging) and no production data is touched.
5. Check security basics: HTTPS, no secrets in the bundle, sane headers.
6. Report pass/fail per check with evidence and blocking issues.

Do not modify production or run destructive tests against real user data.
