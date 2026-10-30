---
description: Detect accidental environment exposure
agent: build
---

Detect environment/secret leakage. This is read-only unless fixes are requested.

Steps:
1. Confirm `.env`, `.env.local`, `.env.staging`, and `.env.production` are gitignored; only `.env.example` should be tracked.
2. Search the repo and git history for committed env files or secret-like values.
3. Inspect `dist/` and built assets for sensitive `VITE_*` values.
4. Check server code for accidentally serving env files or debug dumps.
5. Check logs and client error reporting for env leakage.

Report findings with redacted evidence, whether rotation is required, and remediation. Never echo full secret values.
