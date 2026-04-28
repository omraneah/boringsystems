---
name: Twice-is-a-pattern — codify before the third time
description: When the same manual task happens twice in a session, stop before the third time and propose codification (skill, hook, doc, memory). Ahmed's meta-cognition discipline.
type: feedback
originSessionId: e464aaed-a5a0-4c1c-ac8b-19b9dd83adf6
---
When the same manual task happens twice in a single session — running the same grep, writing the same boilerplate, executing the same git sequence, doing the same FR+EN mirror edit — **stop before the third time** and propose codification: a skill, a hook, a doc section, or a memory entry.

**Why:** Session 2026-04-21 flagged that every system improvement lagged the pattern by 2–3 PRs. `/wrap-session` was run manually 3× before it became a skill. `/verify-home` came after 4× manual HTML greps. The insight was always there; the codification was always late. Late codification costs compound interest — the skill's value starts when written, not when the pattern was first recognized.

**How to apply:** After completing a task, do a one-beat check: "has this shape appeared before in this session?" If yes, name the pattern explicitly and propose the smallest durable form (often a 20-line skill, sometimes one line in a doc, sometimes a single memory entry). Do not wait for session-close — propose mid-session. Ahmed will pick (codify now vs. park) — the proposal itself is the discipline, not the always-yes answer.

The codification target depends on what the pattern touches:

- **Deterministic shell sequence** → a hook or a shell script (if cross-project: `.claude/hooks/`, `.claude/personal-skills/<skill>/`).
- **Reasoning-heavy checklist** → a skill (cross-project: `.claude/personal-skills/`; project-scoped: `<project>/.claude/skills/`).
- **Behavioral rule** → a memory entry (feedback type) and/or one line in CLAUDE.md.
- **Architectural constraint** → `docs/constraints.md` in the project, and a decision log entry.
- **Governance decision** → `.claude/decisions/DECISIONS.md` via `/log-decision`.

Never invent a new codification location to avoid the existing ones. The choice is always one of the five above.
