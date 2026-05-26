#!/bin/bash
# UserPromptSubmit hook — injects a brevity reminder at every turn.
# Executive register: outcomes and open questions only, no essays.
# Shared across all agents — stateless, no agent-specific env vars required.
# See: memory/short-term/feedback/stable/feedback_brevity.md

set -euo pipefail

cat <<'EOF'
[brevity] Executive register. Shortest form that carries the point. Outcomes and open questions only — no preamble, no trailing summary, no narrative. If Ahmed says "too long" → cut by half, no explanation.
EOF

exit 0
