---
name: render
description: Take the last substantive assistant message in the conversation, write it verbatim to `tmp/<slug>.md`, and open it in Marky for rendered reading outside the terminal. Trigger when Ahmed says any variant of "render this with Marky", "render this outside the terminal", "go render this", "open this in Marky", "render the last answer", "render that". Default scope is the LAST assistant message; if Ahmed names a different scope ("render the linear table", "render the recap"), scope to that prior content instead. Write `tmp/<slug>.md`, then `marky <path>`. One-line confirmation. Nothing else.
model: sonnet
effort: medium
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(marky *), Bash(open *), Bash(mkdir *), Write
---

On-demand render of long assistant output. Solves the pain point: Ahmed hates reading long markdown in the terminal. The `tmp/` folder is workspace short-term RAM; Marky is the reader. This skill is the bridge — writes the content, opens the viewer.

Do not announce the skill invocation. Just do the work.

## When to invoke

Auto-fire on any variant of:

- "render this with Marky"
- "render this outside the terminal"
- "go render this"
- "open this in Marky"
- "render the last answer"
- "render that"
- "send this to Marky"

Voice-to-text drift to handle: "Marquee", "Markey", "Marki" → all mean Marky. Fire anyway.

Do NOT invoke when:

- Ahmed names a specific file path to render (`render tmp/foo.md` is just `marky tmp/foo.md` — one Bash call, no skill needed).
- The last assistant message was already a one-line confirmation, link drop, or short answer (< ~150 words). Rendering trivial output is noise. Tell Ahmed: "Last message was short — nothing worth rendering. Confirm if you want it anyway."

## Steps

### Step 1 — Identify scope

Default scope is **the last substantive assistant message** in the conversation. Substantive = the most recent message that contained the content Ahmed is reacting to. Skip past one-line confirmations and notifications to find the real content.

If Ahmed names a scope ("render the linear table", "render the recap", "render the marky comparison"), scope to that prior content instead — find it in conversation history and use that.

### Step 2 — Pick a slug

Generate a short kebab-case slug from the content's topic. Two to four words. Examples:

- Linear board read → `linear-board-read`
- Marky comparison → `marky-vs-alternatives`
- Session recap → `session-recap`

If a file with that slug already exists in `tmp/`, append a `-2`, `-3`, etc. Do not overwrite — Ahmed may still have the previous one open.

### Step 3 — Write the file

Write `~/Workspace/tmp/<slug>.md` with the content **verbatim**. Do not edit, summarise, or restructure. The whole point is "what Claude just said, but rendered." If the original message had a brief lead-in line followed by the substantive content, drop the lead-in and keep the content. If the content benefits from a top H1 it doesn't already have, add one — but no other transformation.

### Step 4 — Open in Marky

```bash
marky ~/Workspace/tmp/<slug>.md
```

Run in background (the GUI app forks and returns). If `marky` is missing from PATH, fall back to `open -a Marky ~/Workspace/tmp/<slug>.md`. If both fail, tell Ahmed and stop — do not silently degrade to terminal output.

### Step 5 — Confirm

One line. Path only. Example:

```
Rendered → tmp/linear-board-read.md
```

No recap of what was rendered. The link IS the recap (workspace rule: feedback_no_recap_after_link).

## Edge cases

- **Marky window already open on `tmp/`.** The new file appears in the sidebar live (folder watch). Running `marky <path>` on a specific file may focus the existing window or open a second view — both are fine. Don't try to detect; just fire the command.
- **Content is short but Ahmed insists.** Render it anyway. Don't lecture. The "< 150 words" rule is for proactive auto-fire, not for explicit user requests.
- **Content is multi-message.** If Ahmed says "render the last few answers", concatenate the last 2–3 substantive assistant messages with a `---` separator, single H1 at top.
- **Code-heavy content.** Marky has Shiki syntax highlighting; preserve the original ` ```lang ` fences exactly. Do not unwrap or reflow.

## Guardrails

- **Verbatim.** Never paraphrase or "improve" the content during writing. Ahmed asked for the last message rendered, not a polished version.
- **Never fabricate.** If you cannot identify a clear "last substantive message" (e.g., the conversation just started, or the last messages were all tool calls), ask one one-line clarifier: "render which part?"
- **Never write outside `~/Workspace/tmp/`.** This skill's output is ephemeral by definition.
- **Never recap after the link.** One line, path, done.
- **Never auto-fire without a trigger phrase.** This is a user-driven skill, not a proactive one. Do not preemptively render long answers — Ahmed asks when he wants to read off-terminal.
