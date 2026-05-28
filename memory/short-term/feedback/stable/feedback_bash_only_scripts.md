---
name: feedback_bash_only_scripts
description: All scripts in this workspace must be Bash (.sh). No Python, no other scripting language, no inline `python3 -c` snippets either. Anything else requires explicit permission from Ahmed.
type: feedback
---

All scripting in this workspace is **Bash (`.sh`)** — both standalone script files AND inline interpreter snippets inside `.sh` files. No Python, no Ruby, no Node scripts. CLI utility binaries (`jq`, `awk`, `sed`, `grep`, `git`) are NOT covered by this rule — they're tools, not scripting languages.

**Why:** consistency across the harness, one mental model for the operator, and one toolchain dependency for fresh-machine setup. The workspace already has bash + awk + sed + jq available everywhere; introducing a second scripting language doubles the surface area for "does this work on the new machine" without earning its keep most of the time. Codified 2026-05-28 after Ahmed corrected mid-session, and after I made the same mistake by creating a `_block-check.py` helper (rewritten in bash + removed the same session).

**How to apply:**
- New standalone scripts (anywhere — `scripts/`, `.agents/hooks/`, `.claude/git-hooks/`, project-local) MUST be `.sh`. Default to `#!/bin/bash`.
- **Inline `python3 -c "…"` inside a `.sh` is NOT a borrow — it is also forbidden.** Use `jq` for JSON, `awk`/`sed` for regex, bash parameter expansion for string ops.
- If a task truly requires Python or another language (e.g., libraries that genuinely have no bash equivalent), **stop and ask Ahmed** before writing it. Surface the specific reason it cannot reasonably be done in bash + standard tools.
- `jq` is the canonical JSON tool. macOS ships it bundled (`/usr/bin/jq`); Linux distros provide it via the package manager.
- When ambiguous, ask one one-line clarifier rather than guess.
