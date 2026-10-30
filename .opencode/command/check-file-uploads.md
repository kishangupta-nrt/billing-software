---
description: Review file upload and import security
agent: build
---

Review file handling security. This app imports backups, logos, and images for OCR; it does not have a general upload server.

Steps:
1. Find all file input and import paths (backup restore, CSV/XLSX, logo/image, OCR).
2. Check size limits, accepted MIME/extensions, and verification of actual content.
3. Review JSON backup parsing for schema validation, prototype pollution, and unsafe object handling.
4. Check image/PDF processing for decompression bombs or oversized inputs.
5. Verify errors do not leak local file paths and that imported data cannot execute code.
6. If a server upload route exists, check storage location, filename sanitization, and access control.

Report findings with `file:line`, impact, and remediation.
