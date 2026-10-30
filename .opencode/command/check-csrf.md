---
description: Review CSRF protection where applicable
agent: build
---

Review CSRF exposure. First determine whether it applies.

Steps:
1. Enumerate state-changing server routes in `server.js` and how the client authenticates (cookies, tokens, or none).
2. If there is no cookie-based authentication and the server is localhost-only, state that CSRF is largely not applicable and explain the assumption.
3. If cookies are used, check `SameSite`, `Secure`, `HttpOnly`, origin/referer checks, and CSRF tokens.
4. Check whether any cross-origin HTML form or fetch could trigger a destructive action.
5. Note browser/local-app threat models that differ from a normal web app.

Report applicability, findings, and fixes. Do not add a CSRF framework where the threat model does not justify it.
