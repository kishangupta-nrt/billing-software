---
description: Implement API endpoints
agent: build
---

Implement the API endpoint(s) described by: `$ARGUMENTS`

Steps:
1. Inspect `server.js` and `src/services/` to see whether the operation belongs server-side or client-side.
2. Define the request/response JSON shape and validate all inputs (types, ranges, required fields).
3. Apply consistent status codes and error envelopes; never leak stack traces.
4. Add authentication/authorization only if the app already has a model for it; otherwise flag the assumption.
5. Update the client caller and document the endpoint in the relevant docs.
6. Test with a running server, then run `npm run lint`.

Do not add secrets to the repo. Do not commit.
