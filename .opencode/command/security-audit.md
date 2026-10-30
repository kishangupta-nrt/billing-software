---
description: Complete a project security assessment (read-only)
agent: build
---

Perform a read-only security assessment of this repository.

Scope: React/Vite client (`src/`), Express server (`server.js`), PWA/service worker config, build scripts, dependency supply chain, and local data handling.

Steps:
1. Map trust boundaries: browser storage, imported/exported files, network calls, server routes, third-party services.
2. Review authentication/authorization reality, input handling, XSS/HTML rendering, CORS, headers, file imports, logging, secrets, and dependencies.
3. Confirm findings by reading the actual code; do not speculate.
4. Rank findings Critical/High/Medium/Low with concrete `file:line` references and exploit preconditions.

Output a report with: scope reviewed, findings by severity, evidence, and recommended fixes. Do not modify files unless the user explicitly asks to fix.
