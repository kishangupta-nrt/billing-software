---
description: Reduce unnecessary network requests
agent: build
---

Reduce network requests for: `$ARGUMENTS`

Steps:
1. Inventory network calls in `src/services/`, `src/utils/`, and `server.js` (including Google Drive, updates, fonts, and icons).
2. Identify duplicate, chatty, or blocking requests, and requests that fail the offline-first requirement.
3. Batch or debounce where appropriate; cache stable data; prefer same-origin and local assets.
4. Ensure the app remains fully usable offline.
5. Verify request count and behavior with devtools or logs; run `npm run lint` and `npm test`.

Report requests removed/reduced and any behavior trade-offs.
