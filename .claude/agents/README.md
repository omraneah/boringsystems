# Persona Subagents

Specialized expert personas Ahmed can switch into for focused conversations across distinct dimensions of his current professional life: GTM, market research, engineering, and inner-game/career.

## Current personas

| Agent | Role | Invoke for |
|---|---|---|
| `gtm-strategist` | **Naomi Renard** — senior GTM strategist, French-market grounded, distribution craft | Positioning, narrative, prior-tenure rebrand, offer stress-testing, pitch shape, LinkedIn/DM drafting, inbound reads |
| `market-strategist` | **Sofia Marchetti** — market strategist + research operator, EU operator graph native, AI-forward, first-principles | Landscape maps, white-space, positioning bets, cohort/altitude/format hypotheses, adversarial reads on the thesis with evidence |
| `principal-engineer` | **Daniel Kovac** — 25y principal engineer, pragmatic-purist, AI-coding-agent aware | Architecture, AI-agent code review, stack choices, debugging, knowing when to abstract, designing the rails AI agents run on |
| `career-coach` | **Hadi Bensoussan** — INTJ technologist-mentor, depth psychology, future-Ahmed-if-built-well | Limiting beliefs, emotional charge during transition, structuring tangled thoughts, identity coherence as forms shift |
| `copy-craftsperson` | **Camille Brodeur** — copywriter & attention architect, British craft-school + American direct-response | Naming, copy, domain comparisons, line-by-line audits, polarization timing, reader-state diagnostics, detail-stacking that compounds trust |

## Invocation

- **Whole session as a persona:** `claude --agent <name>`
- **Within a session:** `@<name> <ask>` — or natural-language delegation when the description matches
- **List / discover:** `/agents`

## Calibration disclaimer (load-bearing)

> **These personas are not set in stone — they are first drafts.**
>
> The voices, backstories, and reference figures (April Dunford, Gary Vee, Atomico, MicroConf-Europe, Camille Fournier, Charity Majors, Jung, etc.) were chosen by Claude as plausible archetypes for the depth and craft Ahmed described. **Ahmed has not vetted the reference figures himself** and may find on actual use that one or more personas:
> - Sound off in voice or tone
> - Anchor to a reference figure he doesn't actually align with
> - Are too forward / too restrained / too domain-narrow / too domain-wide
> - Need a different cultural or professional background to land
> - Anchor too heavily to a pre-AI playbook when the operating mode should be AI-forward and first-principles
>
> **After each substantive session with a persona, Ahmed should ask himself: did this voice serve me, or did it get in the way?** Iterate the agent file based on the answer. Don't preserve a voice that isn't working — rewrite it. Personas evolve as Ahmed's way of working with them evolves; the goal is fit, not consistency.

## How to iterate a persona

1. Open the agent file directly (`.claude/agents/<name>.md`).
2. Adjust the **Who you are** section (backstory, reference anchors), the **How you show up** section (voice, defaults), or the **Operating constraints** section (what they refuse / what governs them).
3. The `@imports` block lists what the agent preloads. Move heavy files to "read on demand" if startup feels slow.
4. Commit the change in its own small PR — easier to roll back if the new voice is worse.

## Adding a new persona

1. Write `.claude/agents/<name>.md` following the structure of the existing three.
2. Frontmatter: `name`, `description` (third-person, when-to-invoke), `model: opus`, `tools: Read, Edit, Write, Bash, Grep, Glob, WebSearch, WebFetch` (or a subset if the persona shouldn't touch the repo).
3. Body sections: identity / how they show up / what governs them / operating constraints / what they're for / what they're NOT for / output style.
4. Use `@imports` for files the persona should preload as substrate.
5. Update this README's table.

## Design principles (for whoever rewrites these)

- **Forward-focused.** Past is raw material, not a place to camp. The exit chapter is closed.
- **TLDR by default.** Ahmed reads fast. Personas state the recommendation first, depth on request.
- **Each persona knows what they're NOT for.** They hand off rather than overreach.
- **Constraints inherit the strategic-advisor doctrine** (re-entry primacy, no PMF reframes, French-market tone) where relevant.
- **Personas are workspace-scoped, git-committed, and laptop-agnostic.** No local state.
