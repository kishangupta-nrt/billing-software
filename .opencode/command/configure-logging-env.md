---
description: Configure logging per environment
agent: build
---

Configure environment-appropriate logging.

Steps:
1. Inventory existing logging (`console.*`, server logs, error reporting) in `src/`, `server.js`, and scripts.
2. Define behavior per environment: verbose/debug locally, structured and minimal in staging, warnings/errors only in production.
3. Ensure logs never contain secrets, tokens, GSTINs, customer PII, or full invoice payloads.
4. Gate debug logging behind a configured level or `import.meta.env.DEV`/`process.env.NODE_ENV`.
5. Ensure client production builds do not ship verbose logs.
6. Document the logging variables in `.env.example`.

Do not add a logging service or send data off-device without explicit approval.
