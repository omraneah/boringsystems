#!/bin/bash
# setup.sh — wire Codex runtime config for this workspace only.
# Installs workspace-owned command approval rules into Codex's runtime rules file
# without replacing existing approvals. Source of truth stays in this repo.

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
RULES_SRC="$WORKSPACE_DIR/.agents/permissions/command-prefixes.rules"
RULES_DST="$CODEX_DIR/rules/default.rules"

echo "Workspace: $WORKSPACE_DIR"
echo "Scope: this workspace checkout only"

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

if [ -f "$WORKSPACE_DIR/.codex/hooks.json" ] && [ -x "$WORKSPACE_DIR/.agents/hooks/enforce-feature-branch.sh" ] && [ -x "$WORKSPACE_DIR/.agents/hooks/block-protected-push.sh" ]; then
  echo "Codex hook audit: hooks.json present; guard scripts executable."
fi

TMPDIR="$(mktemp -d "${TMPDIR:-/tmp}/codex-hook-smoke.XXXXXX" 2>/dev/null || true)"
if [ -n "$TMPDIR" ]; then
  trap 'rm -rf "$TMPDIR"' EXIT
  git -C "$TMPDIR" init -q 2>/dev/null || true
  git -C "$TMPDIR" checkout -b main -q 2>/dev/null || true
  touch "$TMPDIR/README.md"
  git -C "$TMPDIR" add README.md 2>/dev/null || true
  git -C "$TMPDIR" -c user.email=codex-smoke@example.com -c user.name=CodexSmoke commit -m init -q 2>/dev/null || true

  EDIT_SMOKE="$(printf '%s' "{\"cwd\":\"$TMPDIR\",\"tool_input\":{\"command\":\"*** Begin Patch\n*** Update File: README.md\n@@\n-test\n+test2\n*** End Patch\"}}" | bash "$WORKSPACE_DIR/.agents/hooks/enforce-feature-branch.sh" 2>/dev/null || true)"
  PUSH_SMOKE="$(printf '%s' '{"tool_input":{"cmd":"git push origin main"}}' | bash "$WORKSPACE_DIR/.agents/hooks/block-protected-push.sh" 2>/dev/null || true)"

  if printf '%s\n' "$EDIT_SMOKE" | grep -q '"permissionDecision":"deny"' && printf '%s\n' "$PUSH_SMOKE" | grep -q '"permissionDecision":"deny"'; then
    echo "Codex hook smoke: protected-branch guard responds to VM-style inputs."
  else
    echo "WARN: Codex hook smoke did not observe expected deny output."
  fi
fi

echo "Codex setup complete."
