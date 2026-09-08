# fixowl e2e sandbox image. The coding agent (and the trivial verify check) run
# inside this container, so it must contain the `claude` CLI, git, and node.
# Mirrors the main fixowl repo's Dockerfile, minus the pnpm toolchain this
# sandbox does not need. Versioned with the repo; evolve it via normal PRs.

# Node 24 (bookworm-slim keeps the image small with a glibc userland).
FROM node:24-bookworm-slim

# git is expected in the working tree. (Commits/pushes happen on the host,
# outside the container, per fixowl's security model.)
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
  && rm -rf /var/lib/apt/lists/*

# The coding agent CLI (Claude Code); the adapter execs `claude` in-container.
RUN npm install -g @anthropic-ai/claude-code

# TEST FIXTURE (#46 real-agent-error test): shadow the `claude` CLI with a shim
# that exits non-zero with a distinctive real error, to prove fixowl surfaces
# the agent's REAL error in the night-run summary (not just "exited with code
# N"). REVERT this RUN step after the test.
RUN set -eux; \
    target="$(command -v claude)"; \
    printf '#!/bin/sh\necho "FIXOWL-TEST-AGENT-ERROR: simulated agent failure - session limit reached, resets 6pm UTC" >&2\nexit 1\n' > "$target"; \
    chmod +x "$target"

WORKDIR /workspace
