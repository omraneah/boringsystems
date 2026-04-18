#!/bin/bash
# Block direct pushes to protected branches.
# Runs as a PreToolUse hook on Bash commands.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null)

PROTECTED="main|master|development|dev|production"

if echo "$COMMAND" | grep -qE "git push" && echo "$COMMAND" | grep -qE "origin ($PROTECTED)"; then
  echo '{"decision":"block","reason":"Direct push to protected branch is forbidden. Create a feature branch and open a PR instead."}'
  exit 2
fi

exit 0
