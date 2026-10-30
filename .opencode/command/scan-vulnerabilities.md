---
description: Identify vulnerable or outdated dependencies
agent: build
---

Scan the dependency tree for vulnerabilities and supply-chain risk. This is read-only.

Steps:
1. Run `npm audit` (and `npm audit --omit=dev` for production-only impact).
2. Run `npm outdated` to surface stale direct dependencies.
3. Review `package.json`, `package-lock.json`, and `scripts/bundle-tesseract-assets.mjs` for unusual install-time behavior.
4. For each advisory, state whether the vulnerable path is actually reachable in this app (Vite build, Express server, browser bundle).
5. Recommend the safest upgrade path; do not upgrade automatically.

Report: package, severity, advisory, reachability, and recommended action.
