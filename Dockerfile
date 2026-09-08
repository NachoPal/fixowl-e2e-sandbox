# fixowl e2e sandbox image.
FROM node:24-bookworm-slim
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates git \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g @anthropic-ai/claude-code
# TEST FIXTURE (#94 >1h token refresh): shim claude to sleep ~65min (crossing the
# GitHub App installation token's 1h expiry) then produce a change, so fixowl's
# push/PR-open happens AFTER expiry and must use a REFRESHED token. REVERT after.
RUN set -eux; \
    target="$(command -v claude)"; \
    printf '#!/bin/sh\nsleep 3900\necho "long-run change for #94 token-refresh test" > LONGRUN.md\nexit 0\n' > "$target"; \
    chmod +x "$target"
WORKDIR /workspace
