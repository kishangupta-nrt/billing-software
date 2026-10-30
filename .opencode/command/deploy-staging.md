---
description: Deploy the staging version
agent: build
---

Deploy to staging.

Preconditions:
1. Read `docs/DEPLOY_ONLINE.md` and confirm the actual staging target with the user if it is not documented.
2. Ensure `npm run lint`, `npm test`, and `npm run build` pass.
3. Confirm staging credentials/environment variables are available and are not production values.
4. Confirm no secrets are committed.

Deploy:
5. Follow the documented staging deployment mechanism exactly (hosting CLI, CI workflow, or manual upload).
6. Record the version/commit deployed.

If credentials or a documented target are missing, stop and report what is needed. Do not guess, and do not deploy to production.
