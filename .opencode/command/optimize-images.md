---
description: Optimize image delivery and assets
agent: build
---

Optimize images for: `$ARGUMENTS` (all assets if empty).

Steps:
1. Inventory images in `public/`, `src/`, `docs/`, and generated assets.
2. Identify oversized files, missing responsive sizes, and formats that could be smaller (WebP/AVIF where supported).
3. Optimize build-time assets (logos, icons, screenshots) without breaking references; `sharp` is available as a devDependency.
4. Ensure the PWA manifest icons remain valid and correctly sized.
5. Do not degrade visual quality noticeably.
6. Verify with `npm run build` and check output sizes.

Report files changed and size savings. Do not alter screenshots that documentation depends on without confirmation.
