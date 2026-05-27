#!/usr/bin/env bash
# generate-agents.sh — build per-agent persona adapters from the single
#                      canonical source: .agents/personas/<name>.md
#
# Single source of truth:
#   .agents/personas/<name>.md  — YAML frontmatter (name, description, model,
#                                 effort, tools) + persona body.
# Per-agent adapters (do not hand-edit):
#   .claude/agents/<name>.md    — SYMLINK to the canonical persona. Claude reads
#                                 .md directly, so no copy is generated — the
#                                 persona file IS the Claude subagent file.
#   .codex/agents/<name>.toml   — GENERATED. Codex needs TOML, so this is a real
#                                 transform: name/description/effort + body.
#
# Skills are NOT copied here: .agents/skills/ is canonical and read natively by
# Codex; Claude reads it through the ~/.claude/skills symlink (see .claude/setup.sh).
#
# No dependencies beyond bash, awk, sed. Run manually or via .claude/git-hooks/pre-commit.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(cd "$SCRIPT_DIR/.." && pwd)"

PERSONAS="$WORKSPACE/.agents/personas"
CLAUDE_AGENTS="$WORKSPACE/.claude/agents"
CODEX_AGENTS="$WORKSPACE/.codex/agents"

[ -d "$PERSONAS" ] || { echo "ERROR: $PERSONAS not found" >&2; exit 1; }
mkdir -p "$CLAUDE_AGENTS" "$CODEX_AGENTS"

# Codex accepts: low medium high xhigh. "max" → xhigh.
map_effort() {
  case "$1" in
    max|xhigh) echo "xhigh" ;;
    high)      echo "high"  ;;
    medium)    echo "medium" ;;
    low)       echo "low"   ;;
    *)         echo "xhigh" ;;
  esac
}

# Read one frontmatter field value (first match) from a persona file.
fm_field() { awk -v k="$1" '
  /^---$/{c++; next}
  c==1 && $0 ~ "^"k":" { sub("^"k":[[:space:]]*",""); print; exit }
' "$2"; }

generated=0

for persona_path in "$PERSONAS"/*.md; do
  filename="$(basename "$persona_path")"
  [ "$filename" = "README.md" ] && continue
  name="${filename%.md}"

  head -1 "$persona_path" | grep -q '^---$' || {
    echo "ERROR: $persona_path has no frontmatter" >&2; exit 1; }

  description="$(fm_field description "$persona_path")"
  effort_raw="$(fm_field effort "$persona_path")"
  effort="$(map_effort "$effort_raw")"

  # Body = everything after the closing (second) ---, leading blank lines trimmed.
  body="$(awk 'BEGIN{c=0} /^---$/{if(c<2){c++; next}} c>=2{print}' "$persona_path" \
    | awk 'NF{p=1} p{print}')"

  # --- Claude adapter: symlink to the canonical persona ---
  # Claude reads markdown directly and the persona file already IS a valid
  # subagent file (frontmatter + body). A relative, in-repo symlink keeps a
  # single source of truth, survives clone/cloud, and respects symlink hygiene.
  ln -sfn "../../.agents/personas/${name}.md" "$CLAUDE_AGENTS/${name}.md"

  # --- Codex adapter: TOML (real transform — Codex needs TOML, not markdown) ---
  # Body goes in a TOML literal multiline string ('''), which preserves content
  # verbatim — no backslash or double-quote escaping needed. Only constraint:
  # the body must not itself contain the ''' delimiter.
  if printf '%s' "$body" | grep -qF "'''"; then
    echo "ERROR: persona $name body contains ''' which breaks TOML literal strings" >&2; exit 1
  fi
  description_escaped="$(printf '%s' "$description" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  {
    printf '# GENERATED — do not edit. Source: .agents/personas/%s.md\n' "$name"
    printf 'name = "%s"\n' "$name"
    printf 'description = "%s"\n' "$description_escaped"
    printf 'model_reasoning_effort = "%s"\n' "$effort"
    printf "developer_instructions = '''\n"
    printf '%s\n' "$body"
    printf "'''\n"
  } > "$CODEX_AGENTS/${name}.toml"

  echo "  ${name}: .claude/agents/${name}.md (symlink) + .codex/agents/${name}.toml"
  generated=$((generated + 1))
done

echo "Wired $generated personas → Claude symlinks + generated Codex TOML"
