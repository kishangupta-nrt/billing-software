---
description: Identify and reproduce application bugs
agent: build
---

Find bugs in the area: `$ARGUMENTS` (whole app if empty). This is primarily read-only.

Steps:
1. Read the relevant code paths and look for logic errors, edge cases, unsafe assumptions, and broken state transitions.
2. Focus on high-value areas: tax/GST calculations, discounts, rounding, currency, invoice numbering, import/export, backup/restore, persistence, and offline behavior.
3. Reproduce each suspected bug with a concrete scenario or small script before reporting it.
4. Rank by severity and user impact.
5. Do not fix unless the user asks; do not report speculative issues as confirmed.

Report: title, steps to reproduce, expected vs actual, evidence (`file:line`), severity.
