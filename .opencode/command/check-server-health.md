---
description: Check server health
agent: build
---

Check the health of the app server.

Steps:
1. Inspect `server.js` for existing health/status endpoints; use them if present.
2. Start the server locally if needed (`npm run server`) and verify it responds, serves the SPA, and returns correct status codes.
3. Check basic resource signals: error logs, startup warnings, port binding, and static asset availability.
4. If a deployed server is in scope, verify its health endpoint and response time without load testing.
5. Report status, checks performed, and any anomalies.

Do not run stress tests against production.
