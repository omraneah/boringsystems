#!/bin/bash
# Sync canonical workspace permissions into agent-specific adapters.

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CANONICAL_RULES="$WORKSPACE_DIR/.agent-permissions/command-prefixes.rules"
CLAUDE_MCP_ALLOW="$WORKSPACE_DIR/.agent-permissions/claude-mcp-allow.txt"
CODEX_RULES="$WORKSPACE_DIR/.codex/rules/default.rules"
CLAUDE_SETTINGS="$WORKSPACE_DIR/.claude/settings.json"

if [ ! -f "$CANONICAL_RULES" ]; then
  echo "ERROR: missing $CANONICAL_RULES"
  exit 1
fi

mkdir -p "$(dirname "$CODEX_RULES")"
if [ ! -f "$CODEX_RULES" ] || ! cmp -s "$CANONICAL_RULES" "$CODEX_RULES"; then
  cp "$CANONICAL_RULES" "$CODEX_RULES"
fi

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

python3 - "$CLAUDE_SETTINGS" "$CLAUDE_MCP_ALLOW" <<'PY'
import json
import sys

settings_path, allow_path = sys.argv[1], sys.argv[2]

with open(settings_path, "r", encoding="utf-8") as f:
    settings = json.load(f)

with open(allow_path, "r", encoding="utf-8") as f:
    required = [line.strip() for line in f if line.strip() and not line.startswith("#")]

allowed = settings.setdefault("permissions", {}).setdefault("allow", [])
seen = set(allowed)
changed = False

for tool in required:
    if tool not in seen:
        allowed.append(tool)
        seen.add(tool)
        changed = True

if changed:
    with open(settings_path, "w", encoding="utf-8") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
PY

echo "Agent permissions synced."
