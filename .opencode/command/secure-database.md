---
description: Check local data storage and access
agent: build
---

Review data storage security. This app has no server database; data is stored in the browser (localStorage) via `src/store.js`.

Steps:
1. Inventory what is persisted: invoices, customers, business profiles, settings, backups, credentials if any.
2. Check whether sensitive data is stored in plaintext and whether that is acceptable for a local-first app.
3. Review export/import and backup flows (`src/utils/`, Google Drive sync) for data exposure, unsafe deserialization, and missing validation.
4. Check for data isolation between profiles and safe handling of corrupt/malicious backup files.
5. If any server-side database exists, verify credentials, least privilege, and migrations.

Report findings with severity, `file:line`, and remediation.
