#!/bin/bash
# Block protected-branch Git operations.
# Runs as a PreToolUse hook on Bash commands.
# Shared across all agents — stateless, no agent-specific env vars required.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null)

PROTECTED="main|master|development|dev|production"

# Only check the first line — avoids false positives from heredoc bodies
FIRST_LINE=$(echo "$COMMAND" | head -1)

if echo "$FIRST_LINE" | grep -qE "^\s*git push" && echo "$FIRST_LINE" | grep -qE "origin\s+($PROTECTED)\b"; then
  echo '{"decision":"block","reason":"Direct push to protected branch is forbidden. Create a feature branch and open a PR instead."}'
  exit 2
fi

if echo "$FIRST_LINE" | grep -qE "^\s*git push\b" && echo "$FIRST_LINE" | grep -qE "(-f|--force|--force-with-lease)" && echo "$FIRST_LINE" | grep -qE "\b($PROTECTED)\b"; then
  echo '{"decision":"block","reason":"Force-pushing to a protected branch is forbidden."}'
  exit 2
fi

if echo "$FIRST_LINE" | grep -qE "^\s*git branch\s+-[dD]\b" && echo "$FIRST_LINE" | grep -qE "\b($PROTECTED)\b"; then
  echo '{"decision":"block","reason":"Deleting protected branches locally is forbidden. Protected branches: main, master, development, dev, production."}'
  exit 2
fi

if echo "$FIRST_LINE" | grep -qE "^\s*git push\b" && echo "$FIRST_LINE" | grep -qE "((--delete|:)[[:space:]]*[^[:space:]]*)\b($PROTECTED)\b|\b($PROTECTED)\b.*(--delete|:))"; then
  echo '{"decision":"block","reason":"Deleting protected branches on remote is forbidden."}'
  exit 2
fi

exit 0
