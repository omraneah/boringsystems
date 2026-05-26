#!/bin/bash
# setup.sh — wire ~/.claude/ to this workspace on a new machine.
# Run once after cloning: bash /path/to/Workspace/.claude/setup.sh
# Also run by session-start.sh to keep the harness in sync each session.

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
# Memory: tiered architecture lives at workspace root (memory/long-term, /medium-term, /short-term).
# Claude Code reads from ~/.claude/projects/<sanitized-workspace-path>/memory; we symlink that to here.
MEMORY_SRC="$WORKSPACE_DIR/memory"
MEMORY_DST="$CLAUDE_DIR/projects/$(echo "$WORKSPACE_DIR" | tr '/' '-')/memory"

echo "Workspace: $WORKSPACE_DIR"

# 1. Skills: symlink ~/.claude/skills → .agent-skills/ (canonical cross-agent location)
SKILLS_SRC="$WORKSPACE_DIR/.agent-skills"
SKILLS_DST="$CLAUDE_DIR/skills"
if [ -L "$SKILLS_DST" ]; then
  EXISTING_TARGET="$(readlink "$SKILLS_DST")"
  if [ "$EXISTING_TARGET" = "$SKILLS_SRC" ]; then
    echo "skills symlink already correct — skipping"
  else
    echo "Updating skills symlink: $EXISTING_TARGET → $SKILLS_SRC"
    rm "$SKILLS_DST"
    ln -s "$SKILLS_SRC" "$SKILLS_DST"
  fi
elif [ -d "$SKILLS_DST" ]; then
  BACKUP="$SKILLS_DST.bak.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing skills/ → $(basename "$BACKUP")"
  mv "$SKILLS_DST" "$BACKUP"
  ln -s "$SKILLS_SRC" "$SKILLS_DST"
  echo "Created: ~/.claude/skills → .agent-skills/"
else
  ln -s "$SKILLS_SRC" "$SKILLS_DST"
  echo "Created: ~/.claude/skills → .agent-skills/"
fi

# 2. Sync skills to Codex path (.agents/skills/) — copy, not symlink (Codex cloud VMs)
CODEX_SKILLS_DIR="$WORKSPACE_DIR/.agents/skills"
if [ -d "$WORKSPACE_DIR/.agent-skills" ]; then
  mkdir -p "$CODEX_SKILLS_DIR"
  rsync -a --delete "$WORKSPACE_DIR/.agent-skills/" "$CODEX_SKILLS_DIR/"
  echo "Synced: .agent-skills/ → .agents/skills/ ($(ls "$CODEX_SKILLS_DIR" | wc -l | tr -d ' ') skills)"
fi

# 3. Generate Codex agent TOML files from canonical personas
if command -v python3 >/dev/null 2>&1; then
  python3 "$WORKSPACE_DIR/scripts/generate-codex-agents.py"
else
  echo "WARN: python3 not found — skipping Codex TOML generation (committed copies still active)"
fi

# 4. Settings: symlink ~/.claude/settings.json to workspace canonical
SETTINGS_SRC="$WORKSPACE_DIR/.claude/settings.json"
SETTINGS_DST="$CLAUDE_DIR/settings.json"
if [ -L "$SETTINGS_DST" ]; then
  EXISTING_TARGET="$(readlink "$SETTINGS_DST")"
  if [ "$EXISTING_TARGET" = "$SETTINGS_SRC" ]; then
    echo "settings symlink already correct — skipping"
  else
    echo "Updating settings symlink: $EXISTING_TARGET → $SETTINGS_SRC"
    rm "$SETTINGS_DST"
    ln -s "$SETTINGS_SRC" "$SETTINGS_DST"
  fi
elif [ -f "$SETTINGS_DST" ]; then
  echo "Backing up existing settings.json → settings.json.bak"
  mv "$SETTINGS_DST" "$SETTINGS_DST.bak"
  ln -s "$SETTINGS_SRC" "$SETTINGS_DST"
  echo "Created: ~/.claude/settings.json → .claude/settings.json"
else
  ln -s "$SETTINGS_SRC" "$SETTINGS_DST"
  echo "Created: ~/.claude/settings.json → .claude/settings.json"
fi

# 5. Memory: symlink Claude Code's auto-memory location to workspace memory tier root
if [ -L "$MEMORY_DST" ]; then
  EXISTING_TARGET="$(readlink "$MEMORY_DST")"
  if [ "$EXISTING_TARGET" = "$MEMORY_SRC" ]; then
    echo "memory symlink already correct — skipping"
  else
    echo "Updating memory symlink: $EXISTING_TARGET → $MEMORY_SRC"
    rm "$MEMORY_DST"
    ln -s "$MEMORY_SRC" "$MEMORY_DST"
  fi
elif [ -d "$MEMORY_DST" ]; then
  echo "ERROR: $MEMORY_DST is a real directory. Move/back it up first."
  exit 1
else
  mkdir -p "$(dirname "$MEMORY_DST")"
  ln -s "$MEMORY_SRC" "$MEMORY_DST"
  echo "Created: $MEMORY_DST → workspace/memory"
fi

# 6. Git hooks: point core.hooksPath at tracked hook directory so the
#    pre-push audit check travels with the repo. Idempotent.
if git -C "$WORKSPACE_DIR" rev-parse --git-dir >/dev/null 2>&1; then
  current_path="$(git -C "$WORKSPACE_DIR" config --get core.hooksPath || true)"
  if [ "$current_path" = ".claude/git-hooks" ]; then
    echo "git hooks path already wired — skipping"
  else
    git -C "$WORKSPACE_DIR" config core.hooksPath .claude/git-hooks
    echo "Configured: core.hooksPath → .claude/git-hooks"
  fi
fi

# 7. AGENTS.md size guard — Codex silently truncates at 32 KiB.
AGENTS_SIZE=$(wc -c < "$WORKSPACE_DIR/AGENTS.md" | tr -d ' ')
if [ "$AGENTS_SIZE" -gt 30720 ]; then
  echo "WARN: AGENTS.md is ${AGENTS_SIZE} bytes — approaching Codex 32 KiB hard cap. Trim or split."
fi

# 8. Codex project trust reminder (first-run only — check for trust marker).
CODEX_TRUST_MARKER="$WORKSPACE_DIR/.codex/.trusted"
if [ ! -f "$CODEX_TRUST_MARKER" ]; then
  echo ""
  echo "── Codex setup ────────────────────────────────────────────────────────"
  echo "  Codex project hooks (.codex/hooks.json) require explicit trust to fire."
  echo "  In Codex, run: /trust  (or equivalent trust command for your version)"
  echo "  Once trusted, hooks enforce branch protection and brevity rules."
  echo "  Touch '$CODEX_TRUST_MARKER' to suppress this reminder."
  echo "────────────────────────────────────────────────────────────────────────"
fi

# 9. Marky: canonical reader for long Claude output (ADR-003).
#    macOS + Homebrew only. Non-fatal — Marky is UX, not load-bearing.
if [ "$(uname -s)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
  if command -v marky >/dev/null 2>&1; then
    echo "marky already installed — skipping"
  else
    echo "Installing Marky (canonical reader for tmp/, ADR-003)..."
    if brew tap | grep -q '^grvydev/tap$'; then
      echo "  tap already added"
    else
      brew tap GRVYDEV/tap || echo "WARN: brew tap GRVYDEV/tap failed — Marky install skipped"
    fi
    if brew tap | grep -q '^grvydev/tap$'; then
      brew install --cask GRVYDEV/tap/marky || echo "WARN: marky cask install failed — install manually if needed"
      if [ -d "/Applications/Marky.app" ]; then
        xattr -cr /Applications/Marky.app 2>/dev/null || true
        echo "  cleared Gatekeeper quarantine on Marky.app"
      fi
    fi
  fi
else
  echo "Skipping Marky install (not macOS or no Homebrew)"
fi

echo "Setup complete."
