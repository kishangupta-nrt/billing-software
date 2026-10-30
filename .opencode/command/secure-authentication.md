---
description: Review login and session security
agent: build
---

Review authentication and session security. This is read-only unless the user asks for fixes.

Steps:
1. Search for login, session, token, cookie, password, and OTP code across `src/` and `server.js`.
2. If the app has no authentication, state that plainly and describe the security implications of a local single-user model (device access, shared machines, backups).
3. If auth exists, check: password hashing, credential storage, session expiry/rotation, cookie flags (`HttpOnly`, `Secure`, `SameSite`), token leakage, and logout behavior.
4. Check that no credentials are stored in localStorage or exposed in client bundles.

Report findings with severity, `file:line`, and concrete remediation.
