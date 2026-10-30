---
description: Configure the staging environment
agent: build
---

Prepare staging environment configuration.

Steps:
1. Identify the staging deployment target from `docs/`, `.github/`, and `vite.config.js`.
2. Define staging variables with non-production credentials and staging URLs; document them in `.env.example` or deployment docs.
3. Ensure staging is isolated from production data and services.
4. Add or update startup validation so missing staging variables fail fast.
5. Verify `.env.staging` (if used locally) is gitignored and that hosting-injected variables are the source of truth.

Never reuse production secrets in staging. Do not commit environment files with values.
