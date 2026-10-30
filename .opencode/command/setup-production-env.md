---
description: Prepare production environment configuration
agent: build
---

Prepare production configuration without exposing secrets.

Steps:
1. Enumerate the variables production needs from actual code (`process.env`, `import.meta.env.VITE_*`).
2. Document each variable and its expected shape in `.env.example` with placeholders.
3. Designate that production values come from the hosting provider's secret manager or server environment, never a committed file.
4. Confirm browser-visible `VITE_*` values contain no secrets.
5. Add startup validation for required production variables and safe failure behavior.
6. Confirm debug/verbose logging is disabled in production.

Do not create or commit a real `.env.production`. Do not invent credentials.
