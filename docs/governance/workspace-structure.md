# Workspace Structure — Layer Ownership
_Written 2026-05-02 · Based on session audit + community patterns research_

---

## The organizing principle

**Each layer owns what it governs, and only that. A file's scope equals the breadth of the repo it lives in.**

This single rule resolves every ambiguity in the workspace/sub-project architecture and explains itself without additional documentation.

---

## What the community has converged on

**ADR placement:** "As close to the code as the scope of the decision." For multi-repo: org-level decisions live at the org/workspace layer. Project-level decisions live in the project. The litmus test: if the decision would be cited in a PR review on a *different* repo, it's workspace-level. If not, it stays local.

**CLAUDE.md hierarchy:** Claude Code reads upward from CWD. Parent CLAUDE.md loads automatically. Sub-project CLAUDE.md loads on-demand when working in that directory. Workspace → project inheritance is native — no engineering needed. The constraint is the reverse: sub-project CLAUDE.md *cannot reach upward* into workspace files at runtime.

**Memory:** Three-tier (durable identity, medium-term direction, short-term episodic) stored in-repo, version-controlled. Durable tier loads every session; episodic is queried selectively.

**ADR vs SOP vs decision log:**
- ADR = *why* (durable, append-only, no expiry)
- SOP = *how we normally do this* (planned, evolves with process)
- Decision log = the flat chronological signal for things below ADR threshold
- Write a structured ADR only when the decision affects structure, key quality attributes, or is hard to reverse. Below that: a short log entry is sufficient.

---

## What lives where

```
Workspace/
├── CLAUDE.md                      — workspace identity + cross-project rules
├── memory/
│   ├── decisions/DECISIONS.md     — workspace infrastructure decisions only
│   ├── long-term/                 — identity, north star (loads every session)
│   ├── medium-term/               — direction, doctrine (on-demand)
│   └── short-term/
│       ├── feedback/stable/       — crystallized behavioral rules (auto-loads)
│       ├── feedback/in-flight/    — active corrections (auto-loads)
│       └── YYYY-Www/              — episodic record
├── docs/
│   ├── architecture/             — ADRs
│   ├── governance/               — workspace structure, tier map, patterns
│   └── agent-ops/                — infrastructure, collaboration, git workflow
└── .agents/                       — canonical skills, hooks, personas, permissions

boringsystems/ (git submodule)
├── CLAUDE.md                      — project rules, self-contained (no workspace refs)
├── docs/
│   ├── constraints.md             — project constraints, self-contained
│   ├── adr-*.md                   — code/architecture decisions, self-contained
│   └── workflow.md               — article/code/structural SOPs
└── .claude/
    └── skills/                    — project-specific skills
```

**Ownership by document type:**

| What | Where | Format |
|---|---|---|
| Identity, north star | `memory/long-term/` (workspace) | Markdown, version-controlled |
| Behavioral rules (how Claude works) | `memory/short-term/feedback/` (workspace) | Feedback memory files |
| Current direction | `memory/medium-term/` (workspace) | Markdown, on-demand |
| Workspace infrastructure decisions | `memory/decisions/DECISIONS.md` | Flat chronological log |
| Code/architecture decisions | `docs/architecture/adr-*.md` (workspace) / `<project>/docs/adr-*.md` (project) | Structured ADR per decision |
| Process choreography | `docs/workflow.md` (project) | SOP format |
| Project rules | `CLAUDE.md` (project) | Self-contained, no upward refs |

---

## DECISIONS.md scope (critical)

`memory/decisions/DECISIONS.md` at workspace level is for **workspace infrastructure decisions only** — choices about the workspace setup, tooling, process architecture, and meta-level rules that apply across all projects.

It is **not** for:
- Behavioral corrections → those go to `memory/short-term/feedback/`
- Code/architecture decisions → those go to workspace ADRs in `docs/architecture/adr-*.md` or project ADRs in `<project>/docs/adr-*.md`

The historical entries in DECISIONS.md predate this scope clarification and remain as-is. The discipline applies going forward.

---

## Sub-project self-containment rule

Every sub-project (boringsystems, personal-apps, etc.) must be operationally self-contained: a clean-slate agent working from the sub-project root has everything it needs without requiring workspace files.

**Invariant:** Sub-project `docs/` and `CLAUDE.md` must contain no references to workspace-external paths (`memory/`, `cross-stack-architecture-starter-pack/`, etc.). If a rule from workspace context is needed inside a sub-project doc, the rule content is inlined — the workspace path reference is removed.

**Detection:** Periodic audit of sub-project docs for `memory/` or workspace-specific path patterns.

---

## Intentionally deferred

- **`docs/workspace-sop.md`** — session routing, how work flows across projects. Deferred until the absence causes a real problem.
- **DECISIONS.md historical entry migration** — existing entries stay as mixed-format audit trail.
- **Automated drift detection** — a pre-commit script checking that boringsystems docs contain no workspace refs. Deferred to follow-up cycle (2026-05-16).
