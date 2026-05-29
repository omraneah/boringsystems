# Knowledge governance — 9 guardrails

Concise reference. Each guardrail has a mechanism. For full context, follow the linked source.

---

## G1 — 200-line ceiling on always-loaded files

`AGENTS.md`, `CLAUDE.md`, `memory/MEMORY.md` load every turn. Hard block at >200 lines; warn at ≥160.
**Mechanism:** H1 in `.agents/git-hooks/pre-commit`.

---

## G2 — Hooks over instructions

Behavioral rules that can be automated must be encoded as hooks, not left as prose instructions. Prose drifts; hooks enforce.
**Canonical paths:** `.agents/git-hooks/` (git-level), `.agents/hooks/` (agent-level).
**Rule source:** `memory/medium-term/project-management/workspace-workflow.md` § Harness work

---

## G3 — Twice=flag, thrice=human-gated promotion

A manual task that happens twice in a session is flagged for codification. A pattern that repeats a third time must be promoted into a hook, skill, or SOP before it can recur.
**Rule source:** `memory/medium-term/project-management/workspace-workflow.md` § Twice-is-a-pattern

---

## G4 — Two-lane consolidation autonomy

Every lifecycle move in `/consolidate-week` is assigned to exactly one lane before execution:

- **Mechanical** (auto): prune already-distilled raw dailies (`git rm`), dedupe byte-identical files. No signal lost.
- **Staged** (Ahmed-gated): promotions, graduations, doctrine edits, signal-deleting moves.

Mechanical runs strictly AFTER Staged has classified all observations. Prune never races classification.
**Skill:** `.agents/skills/consolidate-week/SKILL.md`

---

## G5 — Prune = `git rm` (git is the archive)

When content has been distilled and the raw source is no longer needed, remove it with `git rm`. Git history is the recoverable archive. No `_archive/` graveyard. Commit convention: `distill: prune <description>`.
**Rationale:** graveyard folders re-accrete; git history doesn't bloat the live tree.

---

## G6 — Conflict = append-then-invalidate (never silent overwrite)

When a new observation contradicts an existing medium-term or long-term doc, the workflow is:
1. Append the contradiction as a drift flag in the current consolidation.
2. Ahmed decides which version wins.
3. The losing version is explicitly invalidated (edited out or archived), never silently overwritten.

**Rule source:** `docs/governance/knowledge-governance.md` § G11

---

## G7 — 4-question gate before any corpus change

Before editing or promoting any memory content, answer:
1. **Scope**: does this belong in this tier (long/medium/short)?
2. **Freshness**: is this still accurate as of today?
3. **Conflict**: does it contradict anything already in the target tier?
4. **Trust**: is the source reliable enough for the target tier's durability requirement?

All four must be satisfied. Uncertainty on any → HELD state (see `/consolidate-week` two-lane model).

---

## G8 — Injection guard (never auto-promote untrusted content into doctrine)

Content from external sources (web, emails, recruiter messages, inbound signals) must not be auto-promoted into `memory/medium-term/` or `memory/long-term/` doctrine without Ahmed's explicit review. Short-term episodic entries are the intake; the consolidation gate is the filter.
**Rule source:** `META-PRINCIPLES.md` § Corpus malleability.

---

## G9 — One-topic-per-doc + AGENTS.md as hub

Each doc covers one topic. AGENTS.md is the hub that routes to detail docs — it does not contain the detail itself. When a doc starts covering two topics, split it.
**Current hub:** `AGENTS.md` → `docs/`, `memory/medium-term/project-management/`
**Mechanism:** H1 ceiling (G1) + code-review feedback enforce this indirectly.

---

## G10 — Agent-agnostic and hardware-agnostic by default (7-test checklist)

Every decision and every piece of infrastructure must pass all seven tests:

1. **Fresh-machine test.** Clone + active-agent setup + `git submodule update --init --recursive` = full working state. If not, the change is not done — fix the agent's setup script or document the missing step.
2. **Cloud-agent test.** A Claude Code or Codex cloud agent has everything it needs *in the repo*: skills, docs, config, conventions. No references to a broader local root or untracked global config.
3. **No-token test.** Works without Ahmed handing out API keys, running `gh auth login`, installing a local CLI, or doing any manual auth. If not, route through claude.ai connectors.
4. **Commit-or-it-doesn't-exist test.** Every piece of config is version-controlled: hooks, skills, settings, memory, decisions, CLAUDE.md. If it only lives at `~/.something` with no symlink back to a tracked file, it's not real.
5. **Agent-boundary test.** Agent-specific runtime setup belongs under that agent's folder (`.claude/` for Claude Code, `.codex/` for Codex). Never make one agent depend on another agent's setup script.
6. **Workspace-scope test.** Setup may configure this workspace checkout. It must not configure `/Users/<user>`, the home directory, or any broader root.
7. **Symlink hygiene.** Symlinks from `~/` into a git-tracked workspace path are fine when platform requires them and reproducible via setup script. Symlinks from git → outside the repo are not.

When an exception is noticed (a step that requires manual X on a new machine), surface it immediately — not later.

---

## G11 — Living doctrines are appended, never forked

When Ahmed's practice deepens on a topic that already has a **living doctrine file** in `memory/long-term/inner-game/` (a file whose own frontmatter names it as "living" / "enriched across sessions"), the next round **appends to that file**. It does not create siblings, parallel notes, or fresh forks.

**Why:** Living doctrines are the mechanism for letting depth compound across sessions. Forking breaks the compounding — the second round risks landing in a daily entry, a tmp/ file, or a new sibling doctrine, and the compounding promise breaks on first re-entry.

**How to apply:**
- Before writing any new doctrine-shaped material, check `memory/long-term/inner-game/` for an existing living doctrine on the topic. If one exists, append.
- Living-doctrine detection: frontmatter contains `seeded:` + `last_reviewed:`, status block names the file "living" or "enriched across sessions," or the file has an "How this doctrine evolves" section.
- Append shape: add a new dated subsection inside the relevant existing section. Preserve previous content verbatim — the older articulation is part of the arc.
- Update `last_reviewed:` in frontmatter. Leave `seeded:` alone.
- Daily entry still gets per-round capture; the doctrine is where the *codified* form lives. Don't duplicate codification in the daily entry — link to the doctrine.
