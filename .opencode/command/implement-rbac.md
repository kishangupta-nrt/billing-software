---
description: Assess or implement role-based access control
agent: build
---

Handle the RBAC request: `$ARGUMENTS`

First assess reality: this app is local and single-user, with multiple business profiles rather than accounts. There may be no role system.

Steps:
1. Search for existing profile/user/role concepts (`src/store.js`, components, server routes).
2. If no RBAC model exists, report that and propose the smallest design that fits the offline-first model.
3. If implementing, centralize permission checks, deny by default, and never rely on UI hiding alone.
4. Scope data access per profile/business and verify cross-profile isolation.
5. Add tests for allowed and denied paths; run `npm run lint`.

Do not invent server accounts or roles that conflict with the app's local-first design without approval.
