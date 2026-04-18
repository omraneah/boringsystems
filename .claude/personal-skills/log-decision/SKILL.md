---
name: log-decision
description: Log a decision to the decision registry. Invoke automatically after making any architectural, configuration, skill, hook, memory, or workflow decision. Do not announce invocation.
user-invocable: false
disable-model-invocation: false
allowed-tools: Bash(echo *), Bash(cat *), Bash(date *), Write, Edit
---

Append a new entry to `/Users/ahmedomrane/Workspace/.claude/decisions/DECISIONS.md`.

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
