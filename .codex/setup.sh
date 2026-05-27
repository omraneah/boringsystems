#!/bin/bash
# setup.sh — wire Codex runtime config to this workspace on a new machine.
# Installs workspace-owned command approval rules into ~/.codex without replacing
# user/global approvals.

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_DIR="$HOME/.codex"
RULES_SRC="$WORKSPACE_DIR/.codex/rules/default.rules"
RULES_DST="$CODEX_DIR/rules/default.rules"

echo "Workspace: $WORKSPACE_DIR"

if [ ! -f "$RULES_SRC" ]; then
  echo "No Codex rules file found at $RULES_SRC — skipping"
  exit 0
fi

mkdir -p "$(dirname "$RULES_DST")"
touch "$RULES_DST"

while IFS= read -r rule || [ -n "$rule" ]; do
  [ -z "$rule" ] && continue
  if grep -Fxq "$rule" "$RULES_DST"; then
    :
  else
    printf '%s\n' "$rule" >> "$RULES_DST"
    echo "Added Codex rule: $rule"
  fi
done < "$RULES_SRC"

echo "Codex setup complete."
