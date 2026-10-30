---
description: Prepare container configuration
agent: build
---

Prepare Docker configuration for this app.

First inspect: there is currently no `Dockerfile` or compose file. The app is a Vite SPA plus an optional Express server (`server.js`).

Steps:
1. Confirm the intended container use case (local self-hosting vs hosted server) with the user if unclear.
2. Create a minimal multi-stage `Dockerfile`: build with Node >= 18, run the Express server or a static server.
3. Add `.dockerignore` for `node_modules`, `dist`, `.git`, env files, and local data.
4. Keep secrets out of image layers; use runtime environment variables.
5. Add a compose example only if useful, with non-production defaults and no committed secrets.
6. Build the image and verify the app starts; document commands.

Do not change application behavior to fit Docker.
