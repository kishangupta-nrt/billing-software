---
description: Improve accessibility
agent: build
---

Improve accessibility for: `$ARGUMENTS`

Steps:
1. Audit the affected UI for: labels, roles, keyboard navigation, focus management, contrast, error announcements, and touch target size.
2. Prefer native semantic elements over ARIA; add ARIA only when necessary and correct.
3. Check dialogs, dropdowns, tables, invoice forms, and print/preview flows.
4. Ensure dynamic updates and validation errors are announced to screen readers.
5. Verify keyboard-only operation and visible focus states.
6. Run `npm run lint` and `npm run build`.

Report issues found, fixes made, and anything that still needs manual assistive-technology testing.
