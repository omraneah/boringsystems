#!/usr/bin/env python3
"""
Generate .codex/agents/*.toml from .claude/agents/*.md + .agent-personas/*.md.

Source of truth for persona content: .agent-personas/<name>.md
Source of truth for frontmatter (description, effort): .claude/agents/<name>.md
Output: .codex/agents/<name>.toml

Run at session start via setup.sh, or manually after editing personas.

Note: @file references in persona content (e.g., @memory/..., @cross-stack-...)
appear as literal text in Codex TOML — Codex does not expand them. This is a
known limitation: Claude Code sub-agents get full @file expansion; Codex agents
get the AGENTS.md workspace context loaded natively but not the per-agent files.
"""

import os
import re
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE = os.path.dirname(SCRIPT_DIR)

CLAUDE_AGENTS_DIR = os.path.join(WORKSPACE, ".claude", "agents")
PERSONAS_DIR = os.path.join(WORKSPACE, ".agent-personas")
CODEX_AGENTS_DIR = os.path.join(WORKSPACE, ".codex", "agents")

EFFORT_MAP = {
    "max": "max",
    "xhigh": "xhigh",
    "high": "high",
    "medium": "medium",
    "low": "low",
}


def parse_frontmatter(content):
    match = re.match(r"^---\n(.*?)\n---\n", content, re.DOTALL)
    if not match:
        return {}
    fm = {}
    for line in match.group(1).split("\n"):
        if ":" in line:
            key, _, value = line.partition(":")
            fm[key.strip()] = value.strip()
    return fm


def escape_toml_basic_string(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')


def main():
    if not os.path.isdir(CLAUDE_AGENTS_DIR):
        print(f"ERROR: {CLAUDE_AGENTS_DIR} not found", file=sys.stderr)
        sys.exit(1)
    if not os.path.isdir(PERSONAS_DIR):
        print(f"ERROR: {PERSONAS_DIR} not found", file=sys.stderr)
        sys.exit(1)

    os.makedirs(CODEX_AGENTS_DIR, exist_ok=True)

    generated = 0
    for filename in sorted(os.listdir(CLAUDE_AGENTS_DIR)):
        if not filename.endswith(".md") or filename == "README.md":
            continue

        name = filename[:-3]
        claude_path = os.path.join(CLAUDE_AGENTS_DIR, filename)
        persona_path = os.path.join(PERSONAS_DIR, filename)
        toml_path = os.path.join(CODEX_AGENTS_DIR, f"{name}.toml")

        with open(claude_path) as f:
            claude_content = f.read()
        fm = parse_frontmatter(claude_content)

        description = escape_toml_basic_string(fm.get("description", ""))
        effort = EFFORT_MAP.get(fm.get("effort", "xhigh"), "xhigh")

        developer_instructions = ""
        if os.path.exists(persona_path):
            with open(persona_path) as f:
                developer_instructions = f.read().strip()

        # Escape """ sequences inside the multiline string to avoid TOML parse errors
        developer_instructions_safe = developer_instructions.replace('"""', '""\\"')

        toml_content = (
            f'name = "{name}"\n'
            f'description = "{description}"\n'
            f'model_reasoning_effort = "{effort}"\n'
            'developer_instructions = """\n'
            + developer_instructions_safe
            + '\n"""\n'
        )

        with open(toml_path, "w") as f:
            f.write(toml_content)

        print(f"  {name}.toml")
        generated += 1

    print(f"Generated {generated} Codex agent TOML files in {CODEX_AGENTS_DIR}")


if __name__ == "__main__":
    main()
