# fixowl e2e sandbox

Throwaway repository for fixowl's end-to-end tests.

The e2e jobs (in the main `fixowl` repo) seed temporary `for: agent` issues here,
let fixowl run against this repo - open one PR per issue, respect `blocked-by`
ordering, gate on CI - assert on the result, then tear the fixtures down again
under `if: always()`.

Do not rely on the contents below: the default branch is the only stable state,
and everything else is transient test fixtures.

<!-- fixowl-e2e: the agent appends its trivial edits below this line -->
codex smoke test - 2026-09-10

<!-- AGENTOK free-34586993283-1-agent-error -->
