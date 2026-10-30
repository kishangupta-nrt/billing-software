---
description: Test data persistence and migrations
agent: build
---

Test the app's storage layer (browser localStorage via `src/store.js`; there is no server database).

Steps:
1. Inventory persisted entities and storage keys.
2. Test create/read/update/delete for invoices, customers, products, and business profiles.
3. Test reload persistence and profile isolation.
4. Test backup export -> import round trip, including older schemas and corrupt/malformed backups.
5. Test migration behavior when stored data is missing fields or has an older version.
6. Test quota/failure handling where feasible.

Report scenarios, results, and data-loss risks. Add tests in the existing plain-Node style if requested.
