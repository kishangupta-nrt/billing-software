---
description: Review abuse protection and rate limiting
agent: build
---

Check for API abuse and rate-limiting exposure. This is read-only unless fixes are requested.

Steps:
1. Enumerate server endpoints in `server.js`, especially any that do work, touch the filesystem, or call external services.
2. Determine whether the server is localhost-only or network-exposed; state the actual deployment assumption.
3. Check for missing body-size limits, timeouts, and rate limiting on expensive routes (OCR, PDF, backup, sync).
4. Assess whether client-side-only protections can be bypassed.

Report applicability honestly: if the app is local-only and single-user, say so, then note residual risks (shared network, misconfiguration). Provide concrete fixes where relevant.
