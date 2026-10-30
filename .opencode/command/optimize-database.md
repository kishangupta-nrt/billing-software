---
description: Optimize persistence and storage access
agent: build
---

Optimize data storage performance. There is no server database; storage is localStorage via `src/store.js`.

Steps:
1. Identify expensive patterns: full-store reads/writes per change, repeated JSON parsing, large synchronous writes, redundant copies.
2. Review how invoices, customers, and products are indexed/filtered in memory.
3. Reduce write frequency and payload size where safe; keep data integrity and migration compatibility.
4. Watch for localStorage quota limits and degrade gracefully.
5. Measure before/after with realistic data sizes; run `npm test` and `npm run build`.

Report changes, measured impact, and any data-compatibility considerations.
