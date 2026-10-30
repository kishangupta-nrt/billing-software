---
description: Generate a QA/test report
agent: build
---

Generate a test report for: `$ARGUMENTS` (latest full run if empty).

Steps:
1. Run the applicable suites: `npm run lint`, `npm run test:unit`, `npm test`, `npm run build`; include E2E if requested and runnable.
2. Collect results, timings, failures, and environment details (OS, Node version, app version from `package.json`).
3. Summarize coverage by module and list gaps/untested areas honestly.
4. Include a prioritized defects section with reproduction steps for failures.
5. Write the report to `docs/qa/<YYYY-MM-DD>-test-report.md` (create the folder if needed) and give a short summary in chat.

Do not fabricate results; clearly mark anything not run as "not run".
