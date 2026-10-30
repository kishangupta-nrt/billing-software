---
description: Check production configuration readiness
agent: build
---

Validate production readiness of configuration. This is read-only unless fixes are requested.

Checklist:
1. Required server env vars present and validated at startup; no defaults that are unsafe in production.
2. Only non-secret `VITE_*` values are exposed to the client; no secrets in the bundle.
3. Debug mode, source maps, and verbose logging set appropriately.
4. API URLs point to production and use HTTPS.
5. `.env` files are not committed; `.env.example` is current.
6. Build succeeds with `npm run build`; PWA configuration is correct.
7. Startup fails fast and clearly on misconfiguration.

Produce a go/no-go report with evidence and blocking issues. Do not deploy.
