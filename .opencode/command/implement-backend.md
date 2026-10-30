---
description: Build backend functionality in the Express server
agent: build
---

Implement the backend behavior described by: `$ARGUMENTS`

Context: `server.js` is an Express 5 server that serves the built SPA and small local APIs. The app is offline-first; keep server dependency optional so the UI still works.

Steps:
1. Read `server.js` and existing routes before changing anything.
2. Add routes/handlers following current patterns, with input validation and safe error responses.
3. Never hardcode secrets; read configuration from `process.env` and document variables in `.env.example`.
4. Do not expose filesystem paths or sensitive data in responses.
5. Verify by starting the server (`npm run server`) and exercising the endpoint; run `npm run lint`.
6. Do not commit.
