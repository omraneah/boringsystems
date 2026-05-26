---
name: tmp-cleanup
description: Clean up the tmp/ folder — delete all files except .gitkeep and README.md. Triggered when Ahmed says "tmp cleanup", "clean up tmp", "wipe tmp", "clear tmp", or any explicit request to clear the tmp/ folder. Never auto-fires; always operator-directed. tmp/ is render buffer — files matter only if Ahmed has promoted them to a permanent home (Linear card, memory file, repo file). By default, tmp/ contents are wipeable on demand.
model: sonnet
effort: medium
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash
---

# /tmp-cleanup — Clear the tmp/ render buffer

The companion to `/github-cleanup`. Different surface, same shape: explicit operator request → mechanical action → one-line confirmation.

## When to fire

Auto-fire on any explicit variant:

- "tmp cleanup"
- "clean up tmp"
- "wipe tmp"
- "clear tmp"
- "/tmp-cleanup"
- Any unambiguous operator request to clear tmp/.

Do NOT fire on:

- Session start, /clear, or any non-explicit signal.
- "cleanup" alone (that's `/github-cleanup`).
- A vague mention of tmp/ ("tmp is full") — ask first.

## Steps

1. List what's currently in tmp/ (excluding `.gitkeep` and `README.md`).
2. If anything looks load-bearing (analysis, narrative, raw material the operator might still need), ask once: "About to delete N files including <names>. Anything to preserve before I wipe?"
3. If the trigger was unambiguous and contents look routine, proceed without asking.
4. Run: `find "$CLAUDE_PROJECT_DIR/tmp" -mindepth 1 -not -name '.gitkeep' -not -name 'README.md' -delete`
5. Confirm in chat: `Cleaned tmp/. N files removed.`

## Guardrails

- Never wipe outside `$CLAUDE_PROJECT_DIR/tmp/`.
- Never use `rm -rf`. The `find ... -delete` approach is safe and surgical.
- Never run on session start. The whole point of this skill is to replace the SessionStart hook with operator control.
