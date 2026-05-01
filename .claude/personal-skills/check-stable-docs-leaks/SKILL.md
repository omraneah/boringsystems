---
name: check-stable-docs-leaks
description: Sweep stable workspace docs (READMEs, MEMORY.md, CLAUDE.md, skill files, ADRs, decision registry) for transient references that should not appear in stable docs — Linear card URLs/identifiers, tmp/ paths, transient per-instance filenames (per-week consolidation files, daily entries), and @-imports pointing at deprecated paths. Run before opening any PR that touches stable docs, or as a pre-commit safety check.
model: sonnet
effort: medium
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash, Read
---

# /check-stable-docs-leaks — Sweep stable docs for transient references

Stable docs (READMEs, MEMORY.md, CLAUDE.md, skill files, ADRs, decision registry) must reference only stable folders and concepts. They must NOT reference:

- **Linear cards** (`https://linear.app/...`, `BOR-NN`, `LIN-NN`) — Linear is project-management ephemera; cards get worked on and forgotten.
- **`tmp/` paths** — `tmp/` is render buffer; contents are wipeable on demand.
- **Transient per-instance filenames** — per-week consolidation files (`consolidation.md` in a specific week), specific daily entries, specific deferred audit files. Reference the folder or category instead.
- **`@<deprecated-path>` imports** — any `@-import` pointing at a folder being phased out (e.g. former `llm-context-2026/` paths).

This skill mechanizes the discipline. Catches what manual review misses.

## When to fire

- **Before opening a PR** that touches any stable doc — manual invocation.
- **On natural-language triggers**: "check for leaks", "stable doc audit", "lint stable docs", "check leaks before PR".
- **Optionally** wired as a pre-commit hook for PRs that modify `memory/**/README.md`, `memory/MEMORY.md`, `CLAUDE.md`, `.claude/personal-skills/*/SKILL.md`, or `docs/adr-*.md`.

## What counts as a stable doc (the sweep target)

```
CLAUDE.md
WORKSPACE_MAP.md
META-PRINCIPLES.md
ENGINEERING-PRINCIPLES.md
memory/README.md
memory/MEMORY.md
memory/long-term/README.md
memory/medium-term/README.md
memory/short-term/feedback/README.md
memory/short-term/README.md
.claude/personal-skills/*/SKILL.md
docs/adr-*.md
docs/*.md (any architecture / infrastructure doc)
.claude/decisions/DECISIONS.md (with carve-out — see below)
```

`memory/short-term/feedback/stable/*.md` and `memory/short-term/feedback/in-flight/*.md` are also stable in nature; include them.

Daily short-term entries (`memory/short-term/<week>/<date>.md`) are NOT stable — they are episodic record. Skip them.

## What to look for (the leak patterns)

### Pattern 1 — Linear card references

Regex: `BOR-[0-9]+|LIN-[0-9]+|linear\.app/[a-z]+/issue/`

Any match in a stable doc is a leak. Exception: Linear references in commit messages, in PR descriptions, and in the body of `.claude/decisions/DECISIONS.md` are acceptable historical record. The rule applies to forward-looking stable docs, not historical decision logs.

### Pattern 2 — `tmp/` path references

Regex: `\btmp/[^ \t\n)]+`

Any match in a stable doc is a leak. The `/tmp-cleanup` skill's mention of the `tmp/` folder by name is a self-reference and acceptable. The rule applies to references that link to specific files inside `tmp/`.

### Pattern 3 — Transient per-instance filenames

Specific patterns:
- `consolidation\.md` referenced by name (with week-specific path)
- Specific daily entry filenames (`<YYYY-MM-DD>\.md`)
- Specific deferred audit file paths

These are recognizable by being one of many transient instances. Reference the folder (`memory/short-term/<week>/`) or the category (`weekly consolidation files`) instead.

### Pattern 4 — `@<deprecated-path>` imports

Maintain a list of deprecated paths to grep for. Initial list:

- `@llm-context-2026/`
- `@.claude/projects/-Users-ahmedomrane-Workspace/memory/` (the old auto-memory path, pre-symlink-cutover)

Add to the list whenever a folder is deprecated.

## Steps

1. **Build the sweep targets list** (use the patterns above).
2. **Run the four pattern checks** in parallel via `grep -rn`. Capture output per pattern.
3. **Filter exceptions:**
   - Linear refs in `DECISIONS.md` historical entries: skip.
   - `tmp-cleanup` skill self-referencing `tmp/`: skip.
4. **Report findings:** if any leaks, surface them grouped by pattern + file. If clean, one-line confirmation.
5. **Optional fix mode:** if invoked with `--fix` or "fix the leaks", attempt sed-replacements per pattern (Linear → remove, tmp → remove, deprecated `@-imports` → updated path). Stop and ask if a fix is ambiguous.

## Output shape

If clean:
```
✓ Stable docs clean. Swept N files across 4 patterns. No leaks.
```

If leaks:
```
⚠ Stable docs have N leaks across 4 patterns:

[Pattern 1 — Linear card references]
- CLAUDE.md:42 — BOR-29 referenced
- memory/README.md:88 — linear.app/.../issue/BOR-30 referenced

[Pattern 2 — tmp/ paths]
- memory/medium-term/README.md:15 — tmp/restructure-narrative.md referenced

...

Fire `/check-stable-docs-leaks --fix` to attempt automated cleanup, or fix manually.
```

## Guardrails

- **Read-only by default.** Only `--fix` mode mutates files.
- **Never auto-fix ambiguous cases.** When the right replacement isn't obvious, surface for human decision.
- **Carve out historical records.** `DECISIONS.md` and `tmp/restructure-narrative.md`-style historical artifacts have legitimate references; the rule is about forward-looking stable docs, not historical accounting.
- **Maintain the deprecated-paths list.** When adding a new deprecated path to grep for, document it in this skill file.

## Companion rules

- The four governance rules captured in BOR-30 codifications (READMEs point to stable refs only, no Linear in stable docs, no tmp in stable docs, workspace-root-precedence) — this skill mechanizes their enforcement.
- `feedback_at_imports_break_on_rename.md` — the @-import check (Pattern 4) prevents the silent breakage that rule warns about.

## Companion skills

- `/check-linear-card-paths` — sibling. Same shape (path-references-must-resolve), different surface (Linear cards, not filesystem). This skill catches *forbidden* references in repo docs; the sibling catches *broken* references in Linear cards. Run both when tightening up a folder rename or memory restructure.
