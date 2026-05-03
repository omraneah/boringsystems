#!/bin/bash
# setup.sh — wire ~/.claude/ to this workspace on a new machine.
# Run once after cloning: bash /path/to/Workspace/.claude/setup.sh

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
# Memory: tiered architecture lives at workspace root (memory/long-term, /medium-term, /short-term).
# Claude Code reads from ~/.claude/projects/<sanitized-workspace-path>/memory; we symlink that to here.
MEMORY_SRC="$WORKSPACE_DIR/memory"
MEMORY_DST="$CLAUDE_DIR/projects/$(echo "$WORKSPACE_DIR" | tr '/' '-')/memory"

echo "Workspace: $WORKSPACE_DIR"

# 1. Skills: single directory symlink
if [ -L "$CLAUDE_DIR/skills" ]; then
  echo "skills symlink already exists — skipping"
elif [ -d "$CLAUDE_DIR/skills" ]; then
  echo "Backing up existing skills/ → skills.bak"
  rm -rf "$CLAUDE_DIR/skills.bak"
  mv "$CLAUDE_DIR/skills" "$CLAUDE_DIR/skills.bak"
  ln -s "$WORKSPACE_DIR/.claude/personal-skills" "$CLAUDE_DIR/skills"
  echo "Created: ~/.claude/skills → personal-skills/"
else
  ln -s "$WORKSPACE_DIR/.claude/personal-skills" "$CLAUDE_DIR/skills"
  echo "Created: ~/.claude/skills → personal-skills/"
fi

# 2. Settings: symlink ~/.claude/settings.json to workspace canonical
SETTINGS_SRC="$WORKSPACE_DIR/.claude/settings.json"
SETTINGS_DST="$CLAUDE_DIR/settings.json"
if [ -L "$SETTINGS_DST" ]; then
  echo "settings symlink already exists — skipping"
elif [ -f "$SETTINGS_DST" ]; then
  echo "Backing up existing settings.json → settings.json.bak"
  mv "$SETTINGS_DST" "$SETTINGS_DST.bak"
  ln -s "$SETTINGS_SRC" "$SETTINGS_DST"
  echo "Created: ~/.claude/settings.json → .claude/settings.json"
else
  ln -s "$SETTINGS_SRC" "$SETTINGS_DST"
  echo "Created: ~/.claude/settings.json → .claude/settings.json"
fi

# 3. Memory: symlink Claude Code's auto-memory location to workspace memory tier root
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

# 4. Git hooks: point core.hooksPath at tracked hook directory so the
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

# 5. Marky: canonical reader for long Claude output (ADR-003).
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
