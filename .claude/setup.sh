#!/bin/bash
# setup.sh — wire ~/.claude/ to this workspace on a new machine.
# Run once after cloning: bash /path/to/Workspace/.claude/setup.sh

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
MEMORY_SRC="$WORKSPACE_DIR/.claude/projects/-Users-ahmedomrane-Workspace/memory"
MEMORY_DST="$CLAUDE_DIR/projects/-Users-ahmedomrane-Workspace/memory"

echo "Workspace: $WORKSPACE_DIR"

# 1. Skills: single directory symlink
if [ -L "$CLAUDE_DIR/skills" ]; then
  echo "skills symlink already exists — skipping"
elif [ -d "$CLAUDE_DIR/skills" ]; then
  echo "ERROR: $CLAUDE_DIR/skills is a real directory. Remove it first."
  exit 1
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

# 3. Memory: symlink for workspace project memory
if [ -L "$MEMORY_DST" ]; then
  echo "memory symlink already exists — skipping"
elif [ -d "$MEMORY_DST" ]; then
  echo "ERROR: $MEMORY_DST is a real directory. Remove it first."
  exit 1
else
  mkdir -p "$(dirname "$MEMORY_DST")"
  ln -s "$MEMORY_SRC" "$MEMORY_DST"
  echo "Created: workspace memory symlink"
fi

echo "Setup complete."
