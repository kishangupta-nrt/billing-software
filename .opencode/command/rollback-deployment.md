---
description: Restore the previous stable release
agent: build
---

Roll back to the previous stable release. Confirm the target version and get explicit approval before taking action.

Steps:
1. Identify the last known-good release/commit (git tags, GitHub releases, deployment history).
2. Determine the rollback method for the actual target (redeploy previous build, revert hosting release, republish prior ZIP).
3. Confirm data compatibility: rollbacks must not corrupt user localStorage or backups.
4. Execute the documented rollback procedure and record the version/commit restored.
5. Verify the app loads and core flows work after rollback.
6. Report what was rolled back, why, and follow-up actions.

Do not rewrite git history, force-push, or delete releases without explicit approval.
