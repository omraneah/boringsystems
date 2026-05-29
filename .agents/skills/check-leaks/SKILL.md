---
name: check-leaks
description: >
  Two-surface leak sweep in one skill. Surface A (--docs, default): sweep stable workspace docs
  (READMEs, MEMORY.md, CLAUDE.md, skill files, ADRs, decision registry) for transient references
  — Linear card URLs/identifiers, tmp/ paths, transient per-instance filenames, and @-imports
  pointing at deprecated paths. Surface B (--cards): sweep open Linear card descriptions and
  comments for path references to workspace files that no longer resolve. Run before opening any
  PR that touches stable docs, or as a pre-commit safety check. Merged from check-stable-docs-leaks
  + check-linear-card-paths (same shape, different surface — filesystem vs Linear API).
model: sonnet
effort: medium
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash, Read
argument-hint: "[--docs | --cards | --all] [--fix] [--card BOR-NN] [--team <name>]"
---

# /check-leaks — Two-surface leak sweep

Unified skill covering two complementary sweeps:

- **Surface A (`--docs`)**: stable workspace docs must NOT contain transient references (Linear cards, `tmp/` paths, transient filenames, deprecated `@-imports`).
- **Surface B (`--cards`)**: open Linear cards must NOT reference workspace paths that no longer resolve.

Both are "path-references-must-be-valid": Surface A checks *forbidden* references in repo docs; Surface B checks *broken* references in Linear cards. Inverse directions — do not conflate.

**Invocation modes:**
- `/check-leaks` — runs Surface A (docs) by default.
- `/check-leaks --docs` — Surface A explicitly.
- `/check-leaks --cards` — Surface B only.
- `/check-leaks --all` — both surfaces.
- `/check-leaks --fix` — Surface A with automated fix-mode (Surface B fix-mode also available; see Surface B section).

Natural-language triggers still route here:
- "check for leaks", "stable doc audit", "lint stable docs", "check leaks before PR" → Surface A.
- "check Linear card paths", "are any cards pointing at renamed files?", "stale card references" → Surface B.

---

## Surface A — Stable docs sweep (`--docs`, default)

Stable docs (READMEs, MEMORY.md, CLAUDE.md, skill files, ADRs, decision registry) must reference only stable folders and concepts. They must NOT reference:

- **Linear cards** (`https://linear.app/...`, `BOR-NN`, `LIN-NN`) — project-management ephemera; cards get worked on and forgotten.
- **`tmp/` paths** — `tmp/` is render buffer; contents are wipeable on demand.
- **Transient per-instance filenames** — per-week consolidation files (`consolidation.md` in a specific week), specific daily entries, specific deferred audit files. Reference the folder or category instead.
- **`@<deprecated-path>` imports** — any `@-import` pointing at a folder being phased out (e.g. former `llm-context-2026/` paths).

### When to fire

- **Before opening a PR** that touches any stable doc — manual invocation.
- **On natural-language triggers**: "check for leaks", "stable doc audit", "lint stable docs", "check leaks before PR".
- **Optionally** wired as a pre-commit hook for PRs that modify `memory/**/README.md`, `memory/MEMORY.md`, `CLAUDE.md`, `.agents/skills/*/SKILL.md`, or `docs/architecture/adr-*.md`.

### What counts as a stable doc (the sweep target)

```
CLAUDE.md
META-PRINCIPLES.md
ENGINEERING-PRINCIPLES.md
memory/README.md
memory/MEMORY.md
memory/long-term/README.md
memory/medium-term/README.md
memory/short-term/feedback/README.md
memory/short-term/README.md
.agents/skills/*/SKILL.md
docs/architecture/adr-*.md
docs/governance/*.md
docs/agent-ops/*.md
docs/*.md (any top-level doc)
memory/decisions/DECISIONS.md (with carve-out — see below)
```

`memory/short-term/feedback/stable/*.md` and `memory/short-term/feedback/in-flight/*.md` are also stable in nature; include them.

Daily short-term entries (`memory/short-term/<week>/<date>.md`) are NOT stable — they are episodic record. Skip them.

### What to look for (the leak patterns)

#### Pattern 1 — Linear card references

Regex: `BOR-[0-9]+|LIN-[0-9]+|linear\.app/[a-z]+/issue/`

Any match in a stable doc is a leak. Exception: Linear references in commit messages, in PR descriptions, and in the body of `memory/decisions/DECISIONS.md` are acceptable historical record. The rule applies to forward-looking stable docs, not historical decision logs.

#### Pattern 2 — `tmp/` path references

Regex: `\btmp/[^ \t\n)]+`

Any match in a stable doc is a leak. The `/tmp-cleanup` skill's mention of the `tmp/` folder by name is a self-reference and acceptable. The rule applies to references that link to specific files inside `tmp/`.

#### Pattern 3 — Transient per-instance filenames

Specific patterns:
- `consolidation\.md` referenced by name (with week-specific path)
- Specific daily entry filenames (`<YYYY-MM-DD>\.md`)
- Specific deferred audit file paths

These are recognizable by being one of many transient instances. Reference the folder (`memory/short-term/<week>/`) or the category (`weekly consolidation files`) instead.

#### Pattern 4 — `@<deprecated-path>` imports

Maintain a list of deprecated paths to grep for. Initial list:

- `@llm-context-2026/`
- `@.claude/projects/-Users-ahmedomrane-Workspace/memory/` (the old auto-memory path, pre-symlink-cutover)

Add to the list whenever a folder is deprecated.

### Steps

1. **Build the sweep targets list** (use the patterns above).
2. **Run the four pattern checks** in parallel via `grep -rn`. Capture output per pattern.
3. **Filter exceptions:**
   - Linear refs in `DECISIONS.md` historical entries: skip.
   - `tmp-cleanup` skill self-referencing `tmp/`: skip.
4. **Report findings:** if any leaks, surface them grouped by pattern + file. If clean, one-line confirmation.
5. **Optional fix mode:** if invoked with `--fix` or "fix the leaks", attempt sed-replacements per pattern (Linear → remove, tmp → remove, deprecated `@-imports` → updated path). Stop and ask if a fix is ambiguous.

### Output shape

If clean:
```
✓ Stable docs clean. Swept N files across 4 patterns. No leaks.
```

If leaks:
```
⚠ Stable docs have N leaks across 4 patterns:

[Pattern 1 — Linear card references]
- CLAUDE.md:42 — PROJ-NNN referenced
- memory/README.md:88 — linear.app/.../issue/PROJ-NNN referenced

[Pattern 2 — tmp/ paths]
- memory/medium-term/README.md:15 — tmp/restructure-narrative.md referenced

...

Fire `/check-leaks --fix` to attempt automated cleanup, or fix manually.
```

### Guardrails

- **Read-only by default.** Only `--fix` mode mutates files.
- **Never auto-fix ambiguous cases.** When the right replacement isn't obvious, surface for human decision.
- **Carve out historical records.** `DECISIONS.md` and historical artifacts have legitimate references; the rule is about forward-looking stable docs, not historical accounting.
- **Maintain the deprecated-paths list.** When adding a new deprecated path to grep for, document it in this skill file.

---

## Surface B — Linear cards sweep (`--cards`)

Linear card descriptions and comments often reference workspace files (`memory/...`, `docs/...`, `.claude/...`) — those paths can rot when files are renamed or moved. The repo doesn't enforce this; the cards live in the Linear API, not in the working tree, so a `git grep` won't catch them.

### Why this exists

A real instance: 2026-05-01, a card was filed with a description pointing at `memory/medium-term/operational-doctrine/Enakl-Derailment-Archetype.md`. The next day, the file was renamed to `Engagement-Validity-Filter.md` as part of a memory cleanup. The Linear card description still pointed at the old name — caught manually inline during the card's execution, but the class of drift will recur.

### When to fire

- **Manual invocation** — `/check-leaks --cards`. Default on-demand cadence.
- **Natural-language triggers**: "check Linear card paths", "are any cards pointing at renamed files?", "stale card references".
- **After a memory restructure / rename pass** — the consolidation flow that renames files should fire this skill afterward to catch the resulting drift.
- **Periodic sweep** — could be wired to `/loop` or `/schedule` weekly. Not required.

### Scope (which cards to check)

By default: **open cards** (status not Done / Canceled / Duplicate) in the Boringsystems team. Stale references in closed cards are archaeological — leave alone.

Operator can override scope:
- `/check-leaks --cards --all` — include closed cards too.
- `/check-leaks --cards --team <name>` — different team.
- `/check-leaks --card BOR-NN` — single card check (also works without `--cards` flag).

### What to look for

Path-shaped references in Linear card descriptions and comments. Patterns:

- `memory/...\.md` — memory files
- `docs/...\.md` — docs (ADRs, architecture)
- `.claude/...\.md` — skills, decisions, hooks, agents
- `<workspace-relative>/...\.md` — generic markdown references like `go-to-market/strategy.md`, `boringsystems/docs/<file>.md`

Extract every path-shaped substring → for each, check whether it resolves under `$CLAUDE_PROJECT_DIR` → flag the ones that don't.

**Carve-outs:**
- Skip URLs (`https://...`, `mailto:`, etc.).
- Skip references inside fenced code blocks where they're clearly illustrative (e.g. an example of *what an old path used to look like*). Heuristic: if the path appears in a fenced block AND there's a sibling resolving path nearby, skip.
- Skip `tmp/...` paths — those are render-buffer-by-design.

### Steps

1. **List target cards** via Linear MCP (`mcp__claude_ai_Linear__list_issues`). Default filter: status type ∈ {`backlog`, `unstarted`, `started`}. Honor scope flags.
2. **For each card**: fetch the description via `get_issue`, fetch all comments via `list_comments`. Concatenate text.
3. **Extract path-shaped substrings** from each card's full text using a path regex. Suggested: `[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)+\.md`.
4. **Resolve each path** against `$CLAUDE_PROJECT_DIR`. Use the Bash tool with `[ -f ... ]` checks, or batch via `find`.
5. **Flag non-resolving paths** grouped by card.
6. **Output report**: per-card list of stale references, with the line context from the description/comment.

### Output shape

If clean:

```
✓ Linear cards clean. Swept N open cards. No stale workspace path references.
```

If stale references found:

```
⚠ N stale workspace path references across M cards:

[PROJ-NN] Re-voice go-to-market/strategy.md to remove striving-tax
- description:34 — memory/medium-term/operational-doctrine/Enakl-Derailment-Archetype.md (does not exist; possible rename → Engagement-Validity-Filter.md)

[BOR-NN] <title>
- comment 2026-05-01 — docs/architecture/adr-002-old-name.md (does not exist)

Fix manually via Linear UI, or re-invoke with --fix to attempt rename-resolution lookups.
```

### --fix mode (best-effort)

Optional. For each stale reference:
1. Search the workspace for files with the same basename — if exactly one match, propose a rename-resolution.
2. If multiple matches or no matches, surface for manual decision.
3. Never silently mutate a Linear card. Surface proposed edits, ask, then apply via `mcp__claude_ai_Linear__save_issue` or `save_comment` only after operator approval.

### Rate-limit handling

Linear MCP rate-limits unpredictably (per `feedback_retry_silently_on_transient_platform_errors.md`). When `list_issues` / `get_issue` / `list_comments` hits a rate limit:
- First retry: same call.
- Second retry: smaller batch (fewer cards per page, narrower filter).
- Third route-around: process the cards already fetched; surface the unprocessed list as a follow-up.
- Never let a rate-limit error be the user-facing artifact.

### Guardrails

- **Read-only by default.** Only `--fix` mode proposes mutations, and even then asks before applying.
- **Don't sweep historical Linear noise.** Closed cards are archaeology unless `--all` is passed.
- **Workspace-rooted only.** This skill checks paths against `$CLAUDE_PROJECT_DIR`. It does not check absolute paths, URLs, or external filesystems.
- **Don't conflate with docs-sweep direction.** Surface A checks repo files for *forbidden* references (Linear, tmp, etc.). Surface B checks Linear cards for *broken* references (non-resolving paths). Inverse direction; don't merge them.

---

## Combined output shape (--all)

When both surfaces are run together, output each section separately with a combined summary at the end:

```
=== Surface A — Stable docs ===
[... Surface A output ...]

=== Surface B — Linear cards ===
[... Surface B output ...]

=== Summary ===
Docs: [CLEAN | N leaks]
Cards: [CLEAN | N stale paths across M cards]
```

---

## Migration note

This skill merges `/check-stable-docs-leaks` and `/check-linear-card-paths` (both removed 2026-05-29). The `/check-leaks --docs` path (Surface A) is the drop-in replacement for `/check-stable-docs-leaks`. The `/check-leaks --cards` path (Surface B) is the drop-in replacement for `/check-linear-card-paths`. All existing trigger phrases still route here.
