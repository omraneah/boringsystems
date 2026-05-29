---
name: pre-start
description: Gate 1 structural artifact — declare what you're about to do before executing. Lists files changing, decisions requiring confirmation, assumptions, skills to run post-execution. Invoke before any multi-file or structural code change, and at every card pickup/kickoff. Formats a gated proposal for Ahmed to approve. Write plan → show → wait for approval → execute.
user-invocable: true
model: sonnet
effort: medium
disable-model-invocation: false
allowed-tools: Read, Grep, Glob
argument-hint: "[flow type: code-change | structural-change | card-pickup | research | optional description]"
---

Pre-execution gate. Produce a plan artifact for Ahmed to approve before any edit.

Do not announce the skill invocation. Produce the plan directly.

## When to invoke

**Auto-invoke** when:
- Starting any code change or structural change on any project.
- Ahmed says "start BOR-XX", "let's work on X", or assigns a task involving multiple files or decisions.
- Picking up a Linear card to execute (card pickup/kickoff flow).

**Manual invocation** always valid.

**Skip for:** single-file typo fixes, one-line changes with no architectural surface, article context drops (full-auto flow), narrow lookups, mechanical operational skills (`/commit`, `/github-cleanup`, etc.).

## Steps

1. **Identify the flow type.** One of: `code-change`, `structural-change`, `card-pickup`, `research`.
2. **Read the relevant SOP.** For code/structural: `docs/agent-ops/workspace-workflow.md` + the project's `docs/workflow.md`. For card pickup: fetch the card in full (description + all comments). For research: none required.
3. **Read domain docs.** For boringsystems code changes: `docs/constraints.md` + domain-relevant doc (analytics, i18n, etc.). For card pickup: any doc the card's start-of-session protocol names. Do not infer from CLAUDE.md alone.
4. **Produce the plan artifact:**

```
Flow: [code-change | structural-change | card-pickup | research]

What I'm going to do:
- [one-line summary]

Files that change (or will likely change):
- [path]: [why]

Decisions requiring confirmation before executing:
- [decision]: [why it matters / why it can't be defaulted]

Assumptions I'm making (proceeding unless you correct):
- [assumption]

Skills to run post-execution:
- [skill]: [trigger condition]

Ready to proceed?
```

5. **Wait for explicit approval** before writing any code or editing any file. Approval = "yes", "go", "proceed", "looks good", or equivalent. Silence is NOT approval.

## Guardrails

- If the card has a detailed start-of-session protocol, follow it exactly — this skill provides the output artifact, the card provides the reading list.
- If a decision cannot be answered without reading more context, read the context first, then produce the plan. Do not produce an incomplete plan that requires follow-up.
- If approved assumptions turn out to be wrong mid-execution, pause and surface the discrepancy before continuing.
- If scope expands beyond the approved plan mid-execution, pause and surface before continuing.

## Reference

Full flow definitions and autonomy gradient: `docs/agent-ops/workspace-workflow.md`
