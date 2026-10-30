---
description: Verify production security readiness
agent: build
---

Assess production security readiness. This is read-only unless fixes are requested.

Checklist:
1. Build config: production sourcemaps, minification, debug flags, and exposed env vars.
2. Server: security headers (CSP, HSTS, X-Content-Type-Options, frame options), CORS, body limits, and error handling.
3. Secrets: none in the client bundle or repo; `.env` ignored; placeholders documented.
4. Dependencies: `npm audit --omit=dev` results and known reachable advisories.
5. PWA: service worker cache scope, update behavior, and no caching of sensitive responses.
6. Data: backup/export handling, local storage exposure, and privacy claims matching implementation.
7. Deployment assumptions (localhost vs hosted) stated explicitly.

Produce a go/no-go summary with blocking issues, `file:line` evidence, and fixes. Do not modify files unless asked.
