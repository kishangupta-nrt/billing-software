---
description: Verify the live production application
agent: build
---

Verify production after deployment.

Steps:
1. Confirm the live URL, deployed version, and commit.
2. Smoke test: page loads over HTTPS, assets/manifest/service worker resolve, no console errors.
3. Run a safe read-only core flow: open an invoice form, verify calculations, check persistence in a fresh browser profile; avoid creating real business data.
4. Verify production configuration: correct API URLs, debug off, no secrets exposed in the bundle.
5. Check security headers and that the PWA updates correctly.
6. Report results and immediately flag any blocker; recommend rollback if critical issues are found.

Do not run destructive tests against live data.
