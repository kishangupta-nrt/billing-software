---
description: Implement data models, persistence, and migrations
agent: build
---

Implement the data/persistence change described by: `$ARGUMENTS`

Important: this app has no server database. Data lives in the browser (localStorage) and is accessed through `src/store.js`, with backup/import utilities in `src/utils/`.

Steps:
1. Inspect `src/store.js`, backup/export code, and any schema/version fields.
2. Model the change in the store with safe defaults and backward-compatible migrations for existing local data.
3. Never lose or silently discard user data; handle corrupt/missing records gracefully.
4. Update import/export/backup code if the schema changes.
5. Add or extend tests for migration and round-trip persistence.
6. Run `npm run lint` and `npm run build`.

Do not introduce a server database or new storage backend without explicit approval.
