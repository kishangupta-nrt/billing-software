---
description: Test authentication flows
agent: build
---

Test authentication for the scope: `$ARGUMENTS`

Steps:
1. First confirm whether authentication exists at all (search `src/` and `server.js`). This app is local and single-user, so it may not.
2. If none exists, report that clearly and list the flows that are therefore untested/not applicable.
3. If it exists, test: valid login, invalid credentials, lockout/rate limiting, session expiry, logout, refresh, and password change.
4. Verify credentials are never exposed in the client, localStorage, or logs.
5. Report pass/fail with evidence and security observations.

Do not implement an auth system as part of testing unless explicitly asked.
