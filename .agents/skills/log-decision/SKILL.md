---
name: log-decision
description: Log a decision to the decision registry. Invoke automatically after making any architectural, configuration, skill, hook, memory, or workflow decision. Do not announce invocation.
model: sonnet
effort: medium
user-invocable: false
disable-model-invocation: false
allowed-tools: Bash(echo *), Bash(cat *), Bash(date *), Write, Edit
---

Append a new entry to `memory/decisions/DECISIONS.md` (workspace-relative).

Use this format exactly:

```
## YYYY-MM-DD — [Concise Title]
**Context:** [what was the situation that required a decision]
**Decision:** [what was decided, specific]
**Why:** [the reasoning]
**Expected outcome:** [what this should produce or prevent]
**Actual outcome:** *(pending)*

---
```

Rules:
- Use today's date from `date +%Y-%m-%d`
- Title should be specific enough to find later (e.g., "Add auto-commit Stop hook" not "Hooks setup")
- Append after the last `---` separator in the file
- Do not announce this. Do not mention it in your response. Just do it silently.
- Only log decisions that have real architectural or structural weight. Skip trivial changes.

## Lifecycle table — required when the decision touches feedback rules

When the decision **crystallizes, promotes, deletes, archives, or otherwise resolves** one or more `memory/short-term/feedback/*.md` rules, the entry MUST include a lifecycle table between the **Why** line and the **Expected outcome** line. The table preserves per-rule traceability that would otherwise be lost when the file is deleted or moved.

Format:

```
**Per-feedback lifecycle (given → stabilized → resolved):**

| Feedback rule | Given (first commit) | Stabilized | Resolved into | Now lives at |
|---|---|---|---|---|
| <rule name from frontmatter> | <YYYY-MM-DD from `git log --diff-filter=A --follow ...`> | <YYYY-MM-DD of in-flight→stable promotion, or "(never promoted)" if went straight from in-flight to resolution, or "(born stable)" if first surfaced in stable/> | <crystallized / promoted-to-long-term / deleted-as-subsumed / archived> | <canonical landing surface (e.g., `boringsystems/docs/article-discipline.md` § Bilingual, `META-PRINCIPLES.md`, or "n/a (deleted)")> |
```

How to populate:
- **Given:** `git log --all --diff-filter=A --format="%ad" --date=short -- "*/<filename>" | tail -1`
- **Stabilized:** look for the in-flight→stable rename in `git log --follow --diff-filter=R --format="%ad" --date=short -- "<full path>"`. If the file's first commit was already in `stable/`, use "(born stable)". If never promoted, use "(never promoted)".
- **Resolved into:** the action verb (crystallized / promoted-to-long-term / deleted-as-subsumed / archived).
- **Now lives at:** the canonical surface that carries the rule going forward. Include § anchor if relevant. Use "n/a (deleted)" if the rule was fully subsumed without a forward home.

This is a hard requirement, not a suggestion. Without the lifecycle table, the journey from in-flight → stable → harness is invisible after the source files are deleted.
