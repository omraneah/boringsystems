# ADR-003 — Marky as canonical reader for long Claude output; `/render` operationalises the loop

**Status:** Accepted (2026-04-28)
**Supersedes:** —
**Superseded by:** —

## Context

The `tmp/` folder was codified on 2026-04-27 as workspace short-term RAM (rule now lives in `docs/agent-ops/workspace-workflow.md` § tmp/ workspace short-term RAM). The rule: when Claude generates more than ~400 words of dense analysis the user will read in full, write it to `tmp/<name>.md` and reference the path. Folder tracked, contents gitignored, wiped at session boundaries.

That rule fixed the *write* half of the problem. It did not address the *read* half. Once content lived in `tmp/`, Ahmed still had to:

- `cat tmp/foo.md` (still terminal — defeats the purpose)
- `open tmp/foo.md` (opens in Finder/default app — friction-laden, no live reload)
- Pull the file into a separate editor or viewer (context switch, no file-watch)

The friction meant the rule was partially unobserved. Long output kept landing in chat scrollback because the cost of moving it out exceeded the cost of squinting through terminal markdown.

Ahmed surfaced the pain explicitly in the 2026-04-28 session and asked for the 2026 AI-native answer. Initial recommendations (Marked 2 — paid, MacMD Viewer — paid, glow — terminal-bound) were rejected. He named Obsidian as one reference point and was open to building a custom viewer over `tmp/`.

Web research surfaced **Marky** (`github.com/GRVYDEV/marky`, shipped April 2026) — a markdown viewer purpose-built for agentic coding workflows. Free, open source, Tauri/Rust/React, ~15 MB, ARM-only (matches Ahmed's M-series Mac), live-reload as files change on disk, Obsidian-style folder workspaces, fuzzy search across the workspace, Shiki syntax highlighting, KaTeX math, Mermaid diagrams. Installed via the project's Homebrew tap. The off-the-shelf version of the app Ahmed offered to build.

## Decision

Adopt Marky as the canonical reader for long Claude-generated output. Codify the workflow as a skill (`/render`) so the verb is normalised and re-derivation is eliminated.

**The loop:**

```
Claude generates >400-word analysis
   ↓
Write verbatim to ~/Workspace/tmp/<slug>.md      (existing rule)
   ↓
Ahmed says "render this with Marky" / etc.
   ↓
/render skill writes (if not already) + opens marky <path>
   ↓
Native window renders rich markdown (Shiki + KaTeX + Mermaid)
   ↓
Live-reload as Claude writes follow-ups
```

**Components:**

| Layer | Artifact | Role |
|---|---|---|
| Reader | Marky (Homebrew tap `GRVYDEV/tap`) | Native renderer, live-watch on `tmp/` |
| Storage | `~/Workspace/tmp/` | Workspace short-term RAM (existing) |
| Verb | `/render` skill (`.agents/skills/render/SKILL.md`) | One-step: verbatim write + open |
| Rule | Graduated to `docs/agent-ops/collaboration.md` and `docs/agent-ops/workspace-workflow.md` | Trigger phrases, voice-drift handling, fallback path |

**Trigger phrases that auto-fire `/render`:** "render this with Marky", "render outside the terminal", "go render this", "open this in Marky", "render the last answer", "render that". Voice-to-text drift on the proper noun ("Marquee", "Markey", "Marki") resolved inline per `docs/agent-ops/collaboration.md` § Voice-dictation disambiguation.

**Default scope:** the last substantive assistant message. Ahmed can override ("render the linear table", "render the recap") to scope to earlier content in the conversation.

**Output discipline:** one line, path only — `Rendered → tmp/<slug>.md`. No content recap. The link IS the recap, per `docs/agent-ops/collaboration.md` § No recap after link.

## Why

- **The write rule was incomplete without a reader.** A short-term RAM is only useful if it has a CPU pulling from it. Marky is the CPU. Without it, `tmp/` was a write-only sink that Ahmed didn't read from, which meant content kept staying in chat scrollback.
- **Solved problem, off the shelf.** Marky was shipped specifically for this workflow in April 2026. Building it ourselves would have been ~100 lines of Next.js + websockets + react-markdown — and would have lacked Mermaid, KaTeX, fuzzy search, syntax highlighting. The build path was strictly inferior to adoption.
- **Free, open, native, light.** ~15 MB Tauri binary. No subscription, no electron bloat, no App Store opacity. Matches every constraint Ahmed named (free, AI-frontier-built, Mac-native, lightweight).
- **Verb normalisation.** Ahmed will say "render this" frequently. Without a skill, every invocation is re-derivation: pick a slug, write, open, confirm. With the skill, it's one trigger phrase. The skill is the difference between a rule that holds and a rule that erodes.
- **ARM-native + brew tap = laptop-agnostic.** Workspace's top constraint is fresh-machine reproducibility (see `AGENTS.md` § Top constraint and `docs/governance/knowledge-governance.md` § G10). The install path is `brew tap GRVYDEV/tap && brew install --cask GRVYDEV/tap/marky` — survives clone-and-setup. The tap is captured in this ADR for `setup.sh` to pick up if Ahmed wants the install automated. Caveat: the binary is currently unsigned (Apple developer review pending), requiring a one-time `xattr -cr /Applications/Marky.app` to clear the Gatekeeper quarantine.

## Consequences

**Net positive:**

- Long Claude output reads in a native window with proper rendering. Tables, code blocks, math, diagrams all visible.
- Live-reload means Claude can stream into a file Ahmed is already watching — no refresh dance.
- The `/render` verb becomes reflexive. Friction collapses.

**Net cost / risk:**

- Marky is unsigned (developer review pending). One-time `xattr` step required at install. If Apple developer signing lands, this footnote disappears.
- Marky is ARM-only at v0.1.3. If Ahmed ever ships from an Intel Mac, fall back to Obsidian vault on `tmp/`. (Currently moot — workspace machine is M-series.)
- Marky is a v0.1.3 project from a small developer. If maintenance lapses, fallback is Obsidian (free, mature, same loop). The skill abstracts the reader: change the `marky <path>` line to `obsidian://open?vault=tmp&file=<slug>` and the rest of the loop survives.

**Reversibility:** High. The rule is mechanical, the skill is one file, the install is one tap. If Marky stops working tomorrow, swap the reader and the rest of the workflow is unchanged. The architectural commitment is to **the loop**, not to the specific reader.

## When to revisit

- Marky shipping a major breaking change, abandoning the project, or losing live-reload.
- Apple developer signing lands (drop the `xattr` step from setup).
- Obsidian + a Claude Code MCP plugin produces a tighter loop than Marky (e.g., bidirectional editing back to Claude). Currently weaker — Obsidian is heavier and slower for read-only viewing.
- Cross-machine non-ARM scenarios emerge (would force the Obsidian fallback as default).

## References

- Skill: `.agents/skills/render/SKILL.md`
- Decision log: `memory/decisions/DECISIONS.md` (2026-04-28 entry)
- Companion rules (graduated): `docs/agent-ops/workspace-workflow.md` (tmp-as-RAM rule), `docs/agent-ops/collaboration.md` § No recap after link
- Marky upstream: [github.com/GRVYDEV/marky](https://github.com/GRVYDEV/marky)
- Install path: `brew tap GRVYDEV/tap && brew install --cask GRVYDEV/tap/marky && xattr -cr /Applications/Marky.app`
