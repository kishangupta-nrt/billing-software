---
description: Prevent sensitive data leaking through logs
agent: build
---

Review logging and error reporting for sensitive-data leakage. This is read-only unless fixes are requested.

Steps:
1. Search for `console.log`, `console.error`, server logging, and any telemetry across `src/`, `server.js`, and scripts.
2. Identify logs that could include credentials, tokens, GSTINs, customer PII, invoice contents, or full request bodies.
3. Check error responses and stack traces returned to clients.
4. Verify production builds do not ship verbose debug logging.
5. Check third-party scripts/trackers that could exfiltrate data, consistent with the app's privacy claims.

Report each risky log with `file:line`, what it exposes, and a safe alternative.
