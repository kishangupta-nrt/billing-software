---
description: Deploy an approved production release
agent: build
---

Deploy to production. This is a high-impact action: confirm explicit user approval and the exact version/target before proceeding.

Preconditions:
1. Staging verified and release approved.
2. `npm run lint`, `npm test`, `npm run build`, and `npm run verify:release` (if applicable) pass.
3. Version is bumped and release notes/CHANGELOG updated.
4. Production secrets are supplied by the hosting environment, never committed.
5. Rollback plan is known.

Deploy:
6. Follow the documented production process in `docs/DEPLOY_ONLINE.md` / `docs/RELEASE_CHECKLIST.md`.
7. Record deployed version/commit and timestamp.

If any precondition fails or credentials are missing, stop. Do not force, skip checks, or deploy unapproved changes.
