---
name: Render long output via /render → Marky
description: When Ahmed asks to render the last answer outside the terminal, fire /render skill — writes verbatim to tmp/<slug>.md and opens in Marky. Voice-drift "Marquee/Markey/Marki" all mean Marky.
type: feedback
---

When Ahmed says any variant of "render this with Marky", "render this outside the terminal", "go render this", "open this in Marky", "render the last answer", "send this to Marky" — fire the `/render` skill. It writes the last substantive assistant message verbatim to `~/Workspace/tmp/<slug>.md` and opens it with `marky <path>`.

**Why:** Long markdown is painful to read in terminal scrollback. The `tmp/` folder was already established as workspace short-term RAM (`feedback_tmp_as_ram.md`) for long Claude output, but the *reader* half of the loop was missing — Ahmed had to manually `cat` or `open` the file. Marky (free, open source, Tauri/Rust, live-reload, folder workspaces) was installed 2026-04-28 as the canonical reader. This rule operationalises the second half of that loop.

**How to apply:**

- Trigger phrases auto-fire `/render`. Voice-drift "Marquee/Markey/Marki" → still Marky, fire anyway.
- Default scope is the last substantive assistant message. If Ahmed names a different scope ("render the linear table", "render the recap"), scope to that.
- Output is one line: `Rendered → tmp/<slug>.md`. No content recap (link IS the recap — `feedback_no_recap_after_link`).
- Do NOT auto-fire without a trigger phrase. This is user-driven, not proactive. Long output goes to `tmp/` per the existing rule; rendering is opt-in.
- If Marky is not on PATH, fall back to `open -a Marky <path>`. If both fail, surface and stop — do not silently degrade to terminal.

**Cross-references:**
- Skill: `.claude/personal-skills/render/SKILL.md`
- ADR: `docs/adr-003-marky-as-canonical-reader.md`
- Companion rule: `feedback_tmp_as_ram.md` (write half), `feedback_no_recap_after_link.md` (output discipline)
- Voice-drift rule: `feedback_voice_dictation_disambiguation.md`
