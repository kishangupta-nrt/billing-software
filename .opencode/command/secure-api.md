---
description: Check API security
agent: build
---

Audit the HTTP/API surface. This is read-only unless fixes are requested.

Steps:
1. Enumerate routes in `server.js` and any client-side service calls.
2. Check input validation, method handling, error responses, and stack-trace leakage.
3. Review CORS configuration (`cors` middleware), security headers, body-size limits, and static file serving.
4. Confirm state-changing endpoints are not exposed without appropriate protection.
5. Check for path traversal in any file-serving or import endpoints.

Report each finding with severity, `file:line`, impact, and fix.
