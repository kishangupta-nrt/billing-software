---
description: Reduce JavaScript bundle size
agent: build
---

Optimize the JavaScript bundle.

Steps:
1. Run `npm run build` and inspect the chunk size report/warnings.
2. Identify large dependencies (`jspdf`, `html2canvas`, `tesseract.js`, `pdf-lib`, etc.) and whether they are loaded eagerly.
3. Lazy-load heavy features (OCR, PDF export, XLSX import) at the point of use with dynamic `import()`.
4. Remove unused imports and dead code; do not add dependencies to solve bundle size.
5. Verify functionality still works after code splitting, then run `npm run lint`, `npm test`, `npm run build`.

Report before/after bundle sizes and which chunks changed.
