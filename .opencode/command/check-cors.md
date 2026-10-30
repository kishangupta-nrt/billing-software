---
description: Review CORS configuration
agent: build
---

Review CORS configuration. This is read-only unless fixes are requested.

Steps:
1. Inspect `server.js` and any middleware for `cors` options, allowed origins, methods, headers, and credentials.
2. Check whether the server reflects arbitrary origins or allows `*` with credentials.
3. Determine the intended deployment: localhost, LAN, or hosted (Vercel/Railway). Tailor the recommendation.
4. Verify preflight handling and whether static PWA assets need different rules.
5. Test the effective behavior by inspecting responses if the server can be run.

Report the current behavior, risk, and a minimal correct configuration with `file:line`.
