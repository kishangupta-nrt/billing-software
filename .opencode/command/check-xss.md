---
description: Review cross-site scripting risks
agent: build
---

Review XSS risk. This is read-only unless fixes are requested.

Steps:
1. Search for `dangerouslySetInnerHTML`, `innerHTML`, `outerHTML`, `document.write`, and HTML-rendering of user data.
2. Verify DOMPurify (`dompurify` dependency) is applied consistently to rich-text terms and any HTML content.
3. Check invoice/customer fields, imported CSV/XLSX data, OCR text, template previews, and URL-driven content for unsanitized rendering.
4. Review PDF/print HTML generation for injection into generated documents.
5. Check the PWA/service worker and any postMessage handlers.

Report each sink with `file:line`, whether input is user-controlled, and the fix. Do not assume React escaping covers `dangerouslySetInnerHTML` or generated HTML.
