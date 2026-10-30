---
description: Generate deployment documentation/report
agent: build
---

Generate a deployment report for: `$ARGUMENTS`

Include:
1. Version and commit deployed, target environment, and timestamp.
2. Pre-deployment checks and their results (lint, tests, build, release verification).
3. Deployment steps performed and by which mechanism.
4. Post-deployment verification results and any issues observed.
5. Rollback reference (previous stable version/commit and procedure).
6. Open risks and follow-ups.

Write the report to `docs/deployments/<YYYY-MM-DD>-<environment>.md` (create the folder if needed) and summarize in chat.

Base it on actual evidence; mark anything not performed as "not run". Do not invent deployment results.
