---
description: Prepare a deployment checklist
agent: build
---

Prepare a deployment checklist. Read `docs/DEPLOY_ONLINE.md`, `docs/RELEASE_CHECKLIST.md`, `package.json`, and `vite.config.js` first.

Checklist to verify and report:
1. Version bumped consistently in `package.json` and release notes.
2. `npm run lint`, `npm test`, and `npm run build` pass.
3. `npm run verify:release` / release ZIP flow succeeds if this is a ZIP release.
4. Environment variables documented in `.env.example`; no secrets committed.
5. PWA manifest, service worker, and icons are correct.
6. Known issues and rollback plan documented.
7. Target environment (local/ZIP, Vercel, Railway, other) confirmed with the user.

Output an actionable checklist with pass/fail/blocked items. Do not deploy anything.
