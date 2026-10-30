---
description: Configure environment-specific data storage
agent: build
---

Configure per-environment data storage. This app uses browser localStorage, not a server database.

Steps:
1. Confirm there is no server database; inspect `src/store.js` for storage keys and any version/schema.
2. Decide whether local/staging/production should use distinct storage namespaces to avoid data mixing (careful: changing keys must migrate existing data).
3. Implement environment-aware storage keys or backup target paths only if it does not risk user data loss.
4. Update backup/export logic and migration handling accordingly.
5. Add tests for reading old data under the new configuration.
6. Run `npm run lint` and `npm test`.

Do not introduce a database or credentials that the app does not need.
