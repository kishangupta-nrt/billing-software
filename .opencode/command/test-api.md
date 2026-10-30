---
description: Test API responses and behavior
agent: build
---

Test the HTTP API surface described by: `$ARGUMENTS` (all routes if empty).

Steps:
1. Enumerate routes in `server.js`.
2. Start the server (`npm run server`) on a safe local port.
3. Exercise each route with valid, invalid, and malformed input; check status codes, content type, and body shape.
4. Verify error responses do not leak stack traces or file paths.
5. Check CORS/headers behavior if relevant.
6. Stop the server afterward.

Report a table of route, case, expected vs actual, and pass/fail. Do not modify code unless asked.
