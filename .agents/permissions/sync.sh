#!/bin/bash
# Sync canonical workspace permissions into agent-specific adapters.
# Pure bash + jq. No Python.

set -e

WORKSPACE_DIR="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"
CANONICAL_RULES="$WORKSPACE_DIR/.agents/permissions/command-prefixes.rules"
CLAUDE_MCP_ALLOW="$WORKSPACE_DIR/.agents/permissions/claude-mcp-allow.txt"
CODEX_RULES="$WORKSPACE_DIR/.codex/rules/default.rules"
CLAUDE_SETTINGS="$WORKSPACE_DIR/.claude/settings.json"

if [ ! -f "$CANONICAL_RULES" ]; then
  echo "ERROR: missing $CANONICAL_RULES"
  exit 1
fi

# Codex shell-rules adapter: byte-copy when stale.
mkdir -p "$(dirname "$CODEX_RULES")"
if [ ! -f "$CODEX_RULES" ] || ! cmp -s "$CANONICAL_RULES" "$CODEX_RULES"; then
  cp "$CANONICAL_RULES" "$CODEX_RULES"
fi

# Validate Claude settings has the required tool-class entries.
REQUIRED=(Bash Edit Write NotebookEdit)
MISSING=()
for tool in "${REQUIRED[@]}"; do
  if ! jq -e --arg t "$tool" '(.permissions.allow // []) | index($t) != null' "$CLAUDE_SETTINGS" >/dev/null 2>&1; then
    MISSING+=("$tool")
  fi
done
if [ ${#MISSING[@]} -gt 0 ]; then
  echo "ERROR: $CLAUDE_SETTINGS missing permissions.allow entries: ${MISSING[*]}"
  exit 1
fi

# Inject any missing MCP allowlist entries from the canonical list.
if [ -f "$CLAUDE_MCP_ALLOW" ]; then
  while IFS= read -r tool || [ -n "$tool" ]; do
    [ -z "$tool" ] && continue
    case "$tool" in \#*) continue ;; esac
    if ! jq -e --arg t "$tool" '(.permissions.allow // []) | index($t) != null' "$CLAUDE_SETTINGS" >/dev/null 2>&1; then
      tmp="$(mktemp)"
      jq --arg t "$tool" '.permissions.allow += [$t]' "$CLAUDE_SETTINGS" > "$tmp" && mv "$tmp" "$CLAUDE_SETTINGS"
    fi
  done < "$CLAUDE_MCP_ALLOW"
fi

echo "Agent permissions synced."
