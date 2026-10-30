---
description: Install and verify project dependencies
agent: build
---

Install and verify dependencies for this repo.

Steps:
1. Read `package.json` and confirm the Node engine requirement (`>=18`).
2. Run `npm install` (its `postinstall` bundles Tesseract assets via `scripts/bundle-tesseract-assets.mjs`).
3. Verify the lockfile is consistent and report any install warnings/errors.
4. Run `npm run lint` and `npm run build` to confirm the toolchain works.
5. Do not perform major version upgrades or remove packages without asking. Never commit secrets or `.env` files.

Report what was installed, anything that failed, and next steps.
