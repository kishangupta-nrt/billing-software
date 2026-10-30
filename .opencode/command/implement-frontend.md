---
description: Build frontend functionality
agent: build
---

Build the frontend feature described by: `$ARGUMENTS`

Guidelines:
- Work in `src/` (React 19 function components, hooks, existing CSS in `src/index.css`).
- Follow existing component and naming conventions; use `lucide-react` icons as already used.
- Keep the offline-first behavior: no hard dependency on network calls.
- Preserve accessibility (labels, keyboard use, focus states) and responsive layout.
- Reuse `src/store.js`, `src/utils/`, and `src/services/` instead of duplicating logic.
- Run `npm run lint` and `npm run build`; fix any issues you introduce.

Do not refactor unrelated code or add heavy dependencies without approval.
