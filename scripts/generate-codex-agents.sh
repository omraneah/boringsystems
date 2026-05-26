#!/usr/bin/env bash
# generate-codex-agents.sh — build .codex/agents/*.toml from canonical sources
#                             and sync .agent-skills/ → .agents/skills/
#
# Sources of truth:
#   .agent-personas/<name>.md  — full persona body
#   .claude/agents/<name>.md   — frontmatter (description, effort)
# Output:
#   .codex/agents/<name>.toml  — Codex agent definitions
#   .agents/skills/            — committed copy of .agent-skills/ for Codex cloud VMs
#
# No dependencies beyond bash, awk, sed, rsync (all POSIX/standard).
# Run manually or called by .claude/git-hooks/pre-commit before each commit.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(cd "$SCRIPT_DIR/.." && pwd)"

CLAUDE_AGENTS="$WORKSPACE/.claude/agents"
PERSONAS="$WORKSPACE/.agent-personas"
CODEX_AGENTS="$WORKSPACE/.codex/agents"
AGENT_SKILLS="$WORKSPACE/.agent-skills"
AGENTS_SKILLS_DST="$WORKSPACE/.agents/skills"

if [ ! -d "$CLAUDE_AGENTS" ]; then
  echo "ERROR: $CLAUDE_AGENTS not found" >&2; exit 1
fi
if [ ! -d "$PERSONAS" ]; then
  echo "ERROR: $PERSONAS not found" >&2; exit 1
fi

mkdir -p "$CODEX_AGENTS"

# Effort mapping — Codex accepts: low medium high xhigh. "max" → xhigh.
map_effort() {
  case "$1" in
    max|xhigh) echo "xhigh" ;;
    high)      echo "high"  ;;
    medium)    echo "medium" ;;
    low)       echo "low"   ;;
    *)         echo "xhigh" ;;
  esac
}

generated=0

for claude_path in "$CLAUDE_AGENTS"/*.md; do
  filename="$(basename "$claude_path")"
  [ "$filename" = "README.md" ] && continue

  name="${filename%.md}"
  persona_path="$PERSONAS/${name}.md"
  toml_path="$CODEX_AGENTS/${name}.toml"

  if [ ! -f "$persona_path" ]; then
    echo "ERROR: persona missing for $name: $persona_path" >&2; exit 1
  fi

  # Parse frontmatter (between first and second ---)
  description=$(awk '/^---$/{c++; next} c==1 && /^description:/{sub(/^description:[[:space:]]*/,""); print; exit}' "$claude_path")
  effort_raw=$(awk '/^---$/{c++; next} c==1 && /^effort:/{sub(/^effort:[[:space:]]*/,""); print; exit}' "$claude_path")
  effort=$(map_effort "$effort_raw")

  # Escape backslashes then double-quotes for TOML basic string
  description_escaped=$(printf '%s' "$description" | sed 's/\\/\\\\/g; s/"/\\"/g')

  # Persona files are pure markdown — no frontmatter to strip
  persona=$(cat "$persona_path")

  # Guard: persona must not contain """ (would break TOML basic multiline string)
  if printf '%s' "$persona" | grep -qF '"""'; then
    echo "ERROR: persona $name contains \"\"\" which breaks TOML basic strings" >&2; exit 1
  fi

  {
    printf '# GENERATED — do not edit. Source: .agent-personas/%s.md + .claude/agents/%s.md\n' "$name" "$name"
    printf 'name = "%s"\n' "$name"
    printf 'description = "%s"\n' "$description_escaped"
    printf 'model_reasoning_effort = "%s"\n' "$effort"
    printf 'developer_instructions = """\n'
    printf '%s\n' "$persona"
    printf '"""\n'
  } > "$toml_path"

  echo "  ${name}.toml"
  generated=$((generated + 1))
done

echo "Generated $generated Codex agent TOML files in $CODEX_AGENTS"

# Sync .agent-skills/ → .agents/skills/ (committed copy for Codex cloud VMs)
if [ -d "$AGENT_SKILLS" ]; then
  mkdir -p "$AGENTS_SKILLS_DST"
  rsync -a --delete "$AGENT_SKILLS/" "$AGENTS_SKILLS_DST/"
  echo "Synced: .agent-skills/ → .agents/skills/ ($(ls "$AGENTS_SKILLS_DST" | wc -l | tr -d ' ') skills)"
fi
