#!/bin/bash
# Sync canonical workspace permissions into agent-specific adapters.

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CANONICAL_RULES="$WORKSPACE_DIR/.agent-permissions/command-prefixes.rules"
CODEX_RULES="$WORKSPACE_DIR/.codex/rules/default.rules"
CLAUDE_SETTINGS="$WORKSPACE_DIR/.claude/settings.json"

if [ ! -f "$CANONICAL_RULES" ]; then
  echo "ERROR: missing $CANONICAL_RULES"
  exit 1
fi

mkdir -p "$(dirname "$CODEX_RULES")"
cp "$CANONICAL_RULES" "$CODEX_RULES"

python3 - "$CLAUDE_SETTINGS" <<'PY'
import json
import sys

settings_path = sys.argv[1]
required = {"Bash", "Edit", "Write", "NotebookEdit"}

with open(settings_path, "r", encoding="utf-8") as f:
    settings = json.load(f)

allowed = set(settings.get("permissions", {}).get("allow", []))
missing = sorted(required - allowed)

if missing:
    print(f"ERROR: {settings_path} missing permissions.allow entries: {', '.join(missing)}")
    sys.exit(1)
PY

echo "Agent permissions synced."
