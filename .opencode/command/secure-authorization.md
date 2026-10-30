---
description: Review access permissions and data isolation
agent: build
---

Review authorization and access control. This is read-only unless fixes are requested.

Steps:
1. Map who can access what: business profiles, invoices, customers, backups, and server routes.
2. Check whether access checks are enforced in logic, not just hidden in the UI.
3. Verify cross-profile/business isolation and confirm no route can read or modify another profile's data.
4. Check server routes in `server.js` for missing ownership checks or unauthenticated data access.
5. If the app is intentionally single-user/local, document that assumption and its limits.

Report findings by severity with `file:line` and remediation.
