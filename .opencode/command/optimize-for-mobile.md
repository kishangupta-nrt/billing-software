---
description: Improve mobile performance and usability
agent: build
---

Optimize the mobile experience for: `$ARGUMENTS`

Steps:
1. Review responsive layout, touch targets, viewport settings, and mobile-specific flows (invoice form, tables, print/PDF).
2. Identify heavy work that hurts low-end devices: large bundles, synchronous calculations, PDF/canvas/OCR usage.
3. Lazy-load heavy features and reduce initial payload.
4. Ensure forms are usable with on-screen keyboards and small screens.
5. Verify PWA install/offline behavior on mobile.
6. Run `npm run lint` and `npm run build`; test with a narrow viewport if possible.

Report changes and any remaining mobile limitations.
