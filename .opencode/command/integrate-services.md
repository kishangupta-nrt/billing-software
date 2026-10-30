---
description: Integrate an external service safely
agent: build
---

Integrate the external service described by: `$ARGUMENTS`

Steps:
1. Identify an existing integration pattern (for example Google Drive backup or other network calls in `src/services/` and `server.js`).
2. Keep API secrets on the server or in user-provided credentials; never embed them in client code or commit them.
3. Read configuration from environment variables and add placeholders to `.env.example`.
4. Implement timeouts, error handling, and graceful degradation so the offline-first app still works.
5. Document required setup steps and scopes/permissions.
6. Run `npm run lint` and `npm run build`; test the failure path too.

Do not send user data to a third party without explicit, documented consent.
