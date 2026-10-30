---
description: Validate the production build
agent: build
---

Validate the production build.

Steps:
1. Run `npm run build` (this triggers `prebuild` Tesseract bundling).
2. Confirm `dist/` contains `index.html`, hashed JS/CSS, manifest, service worker, icons, and required assets.
3. Check for build warnings, missing chunks, and unexpectedly large bundles.
4. Verify no source maps or debug values leak secrets.
5. Run `npm run preview` (or serve `dist/` with `npm run server`) and confirm the app loads and a core flow works.
6. Confirm PWA installability assets resolve.

Report pass/fail with evidence and blocking issues. Do not deploy.
