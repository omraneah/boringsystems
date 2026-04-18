#!/bin/bash
# Block direct pushes to protected branches.
# Runs as a PreToolUse hook on Bash commands.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null)

PROTECTED="main|master|development|dev|production"

# Only check the first line — avoids false positives from heredoc bodies
FIRST_LINE=$(echo "$COMMAND" | head -1)

if echo "$FIRST_LINE" | grep -qE "^\s*git push" && echo "$FIRST_LINE" | grep -qE "origin\s+($PROTECTED)\b"; then
  echo '{"decision":"block","reason":"Direct push to protected branch is forbidden. Create a feature branch and open a PR instead."}'
  exit 2
fi

exit 0
