---
description: Configure environment-specific storage
agent: build
---

Configure storage per environment.

Steps:
1. Inventory storage used: localStorage keys, backup folders/paths, Google Drive sync, and any cached files.
2. Ensure local, staging, and production do not share data or credentials.
3. Add configuration for paths/buckets/folders via env vars where applicable, with safe local defaults.
4. Preserve backward compatibility for existing local data; migrate rather than discard.
5. Update `.env.example` and deployment docs.
6. Verify export/import still works and run `npm run lint`.

Never embed storage credentials in client code or commit them.
