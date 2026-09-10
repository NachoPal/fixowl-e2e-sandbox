# fixowl e2e sandbox image. The coding agent (and the trivial verify check) run
# inside this container, so it must contain the coding-agent CLIs (`claude` and
# `codex`), git, and node. Mirrors the main fixowl repo's Dockerfile, minus the
# pnpm toolchain this sandbox does not need. Versioned with the repo; evolve it
# via normal PRs.

# Node 24 (bookworm-slim keeps the image small with a glibc userland).
FROM node:24-bookworm-slim

# git is expected in the working tree. (Commits/pushes happen on the host,
# outside the container, per fixowl's security model.)
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
  && rm -rf /var/lib/apt/lists/*

# The coding-agent CLIs the adapters exec in-container. Install the ones you use:
#   - claude: the `claude` agent (Anthropic)
#   - codex:  the `codex` agent (OpenAI API key)
RUN npm install -g @anthropic-ai/claude-code
RUN npm install -g @openai/codex@0.153.4

WORKDIR /workspace
