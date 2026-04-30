#!/bin/bash
# Block file edits on protected branches.
# Forces feature-branch discipline for any Write/Edit/NotebookEdit operation.
# Companion to block-protected-push.sh — same protected list, applied earlier.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Walk up to find an existing parent directory (file may not exist yet)
DIR="$FILE_PATH"
while [ ! -d "$DIR" ] && [ "$DIR" != "/" ]; do
  DIR=$(dirname "$DIR")
done

REPO_ROOT=$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null)
if [ -z "$REPO_ROOT" ]; then
  exit 0
fi

BRANCH=$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null)

case "$BRANCH" in
  main|master|development|dev|production)
    echo "{\"decision\":\"block\",\"reason\":\"Edits forbidden on protected branch '$BRANCH' in $REPO_ROOT. Create a feature branch first (e.g. 'git -C $REPO_ROOT checkout -b omraneah/<short-task-name>') and retry the edit. If a feature branch already exists for this session in this repo, switch to it — do not create siblings.\"}"
    exit 2
    ;;
esac

exit 0
