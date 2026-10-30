---
description: Find exposed API keys and credentials
agent: build
---

Search the repository for exposed secrets. This is read-only.

Steps:
1. Check tracked files for `.env`, `.pem`, `.key`, tokens, OAuth client secrets, and hardcoded passwords/API keys. Exclude `node_modules/`.
2. Inspect build output (`dist/`) and `public/` for accidentally bundled secrets.
3. Check `server.js`, `vite.config.js`, service integrations, and scripts for `VITE_` variables that carry secrets (these are public in the browser).
4. Review `.gitignore` to confirm `.env*` (except `.env.example`) is ignored.
5. Verify whether any secret is in git history; if so, recommend rotation, not just deletion.

Report each finding with `file:line`, exposure path (client vs server vs history), and remediation. Never print full secret values; redact them.
