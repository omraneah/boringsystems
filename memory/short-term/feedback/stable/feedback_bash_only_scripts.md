---
name: feedback_bash_only_scripts
description: Standalone scripts must be Bash (.sh). No standalone .py/.rb/.js etc. Inline `python3 -c` snippets inside `.sh` are allowed only as a documented escape valve for JSON emission of arbitrary text. Anything else requires explicit permission from Ahmed.
type: feedback
---

**Default for all scripting in this workspace is Bash (`.sh`).** Standalone scripts in any other language (Python, Ruby, Node, etc.) are forbidden without explicit permission from Ahmed. CLI utility binaries (`jq`, `awk`, `sed`, `grep`, `git`) are tools, not scripting languages, and are encouraged.

**Inline `python3 -c "…"` inside a `.sh` is the documented escape valve** — allowed for the specific case where bash + jq + printf cannot do the job safely. Use sparingly, with a code comment explaining why bash alone is unsafe.

**Why:** consistency, one mental model, one fresh-machine toolchain. The workspace ships bash + awk + sed + jq everywhere; introducing a second scripting language doubles surface area without earning its keep most of the time. Codified 2026-05-28 after Ahmed corrected mid-session, and after I made the same mistake (created `_block-check.py` then rewrote in bash same day).

**Why the escape valve and not strict:** bash JSON emission via `printf '...%s...' "$ESCAPED"` with `sed 's/\\/\\\\/g; s/"/\\"/g'` escapes only `\` and `"` — it does NOT handle newlines, tabs, carriage returns, or non-ASCII characters. For static strings we author (the brevity reminder, fixed deny reasons), this is fine. For arbitrary text (a user-supplied prompt echoed back, a file path or commit message that may contain control chars), `printf`+`sed` produces invalid JSON. `python3 -c "import json,sys; print(json.dumps(sys.argv[1]))"` does it correctly. Considered strict no-Python-ever; pulled back because the marginal portability win is small (python3 ships universally, same as jq) and the bash-only JSON-emit corner is real brittleness for low gain.

**How to apply:**
- New standalone scripts (anywhere — `scripts/`, `.agents/hooks/`, `.claude/git-hooks/`, project-local) MUST be `.sh`. Default to `#!/bin/bash`.
- For JSON parse: use `jq -r '.path // ""'` from stdin.
- For JSON emit of **static** strings we author: `printf '{"key":"%s"}\n' "$(sed 's/\\/\\\\/g; s/"/\\"/g' <<< "$VAL")"`. Adequate.
- For JSON emit of **arbitrary** text (user input, file paths, commit messages, anything we don't control): use `python3 -c 'import json,sys; print(json.dumps({...}))'`. Document why in the script.
- If a task truly requires standalone Python (libs with no bash equivalent, complex data manipulation), **stop and ask Ahmed** before writing it.
- When ambiguous, ask one one-line clarifier rather than guess.
