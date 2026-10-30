---
description: Verify the application builds successfully
agent: build
---

Verify the build.

Steps:
1. Run `npm run lint` and fix only issues introduced by current work.
2. Run `npm run build` (Vite production build; `prebuild` bundles Tesseract assets).
3. Confirm `dist/` contains the expected assets, service worker, and manifest.
4. Check for build warnings: large chunks, unresolved imports, missing assets, and source-map/security concerns.
5. Optionally run `npm run preview` and verify the app loads.
6. Report build status, warnings, output size, and anything that could block release.

Do not change build configuration unless the build is actually broken.
