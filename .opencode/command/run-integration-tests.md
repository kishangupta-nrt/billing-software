---
description: Test integrations between modules and services
agent: build
---

Test integration paths in the app.

Steps:
1. Identify integrations: store/persistence, CSV/XLSX import-export, backup/restore, Google Drive sync, Express server routes, PDF generation, OCR.
2. For the target of `$ARGUMENTS` (or all if empty), exercise real round trips rather than mocked units.
3. Use existing scripts in `scripts/` and `tests/smoke.mjs` as the starting point; add a focused integration script if missing.
4. Verify failure handling: missing files, corrupt data, offline mode, invalid server responses.
5. Run `npm run lint` and `npm test`.

Report what was exercised, results, and any gaps that need automated coverage.
