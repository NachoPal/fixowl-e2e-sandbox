# fixowl e2e sandbox image.
FROM node:24-bookworm-slim
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates git \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g @anthropic-ai/claude-code
# TEST FIXTURE (#96 failed-slot): shim claude to force the agent to fail, so this
# scheduled-fallback run ends as a FAILED scheduled-slot run. REVERT after.
RUN set -eux; \
    target="$(command -v claude)"; \
    printf '#!/bin/sh\necho "FIXOWL-TEST: forced fail for #96 failed-slot fixture" >&2\nexit 1\n' > "$target"; \
    chmod +x "$target"
WORKDIR /workspace
