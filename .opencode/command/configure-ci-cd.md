---
description: Configure automated build and deployment
agent: build
---

Configure CI/CD for this repository.

Current state: `.github/` has only Dependabot; there are no workflows or container files.

Steps:
1. Confirm the deployment target and required secrets with the user before adding deployment steps.
2. Create a minimal GitHub Actions workflow that runs on PRs: install, `npm run lint`, `npm test`, `npm run build`.
3. Add release/deploy steps only for the confirmed target, using repository secrets (never hardcoded values).
4. Pin action versions and set least-privilege `permissions`.
5. Cache npm dependencies safely.
6. Verify workflow YAML syntax and document required secrets in `docs/`.

Do not enable automatic production deploys or commit credentials without explicit approval.
