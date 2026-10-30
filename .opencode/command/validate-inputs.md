---
description: Review input validation and injection risks
agent: build
---

Review input validation across the app. This is read-only unless fixes are requested.

Steps:
1. Find all user-controlled inputs: invoice/customer forms, CSV/XLSX imports, backup restore, OCR images, search fields, rich-text terms, URL params.
2. Check that numeric, date, currency, GSTIN, and enum fields are validated at the boundary.
3. Check for injection surfaces: HTML rendering (`dangerouslySetInnerHTML`, DOMPurify usage), CSV formula injection, and any dynamic server query/path construction.
4. Verify imported files have size, type, and shape limits.
5. Check that validation errors are handled without breaking persistence.

Report gaps with `file:line`, realistic impact, and recommended validation.
