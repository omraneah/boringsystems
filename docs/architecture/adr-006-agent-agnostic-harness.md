# ADR-006 — Agent-Agnostic Harness

**Status:** Accepted
**Date:** 2026-05-29
**Context:** workspace-level
**Sources:** `META-PRINCIPLES.md` § 2 · `AGENTS.md` § Top constraint · `memory/decisions/DECISIONS.md` 2026-05-26 + 2026-05-27 entries

---

## Context

When Codex CLI was introduced alongside Claude Code (2026-05-26), both agents needed the same harness: skills, personas, hooks, git-hooks, and permission policies. The initial state was that every harness artifact lived under `.claude/` (Claude Code's runtime directory), which Codex auto-migrated into `.codex/` — creating two parallel sources of truth with instant drift risk.

The workspace invariant from `META-PRINCIPLES.md` § 2 is absolute: everything must survive a fresh-machine clone. That means the harness must not be secretly agent-specific, must not require manual setup steps, and must not live only in one agent's runtime directory.

A secondary tension: skills, personas, and hooks are "workspace infrastructure" — they describe how any agent should operate in this workspace, not how Claude Code specifically should operate. Tying them to `.claude/` was a category error.

The 2026-05-26 decision introduced agent-agnostic canonical directories. The 2026-05-27 decisions clarified setup boundaries and permission policy. This ADR records the resulting architecture as a first-class design decision.

---

## Decision

The harness is **agent-agnostic**. `.agents/` is the single canonical tree. Every agent that runs in this workspace is an adapter on top of it.

### Canonical tree: `.agents/`

| Directory | Contains | Who consumes |
|---|---|---|
| `.agents/skills/` | Cross-project skill definitions (`SKILL.md` per skill) | Claude Code via `~/.claude/skills` symlink; Codex natively |
| `.agents/personas/` | Full persona body markdown (single source per persona) | Claude Code via `.claude/agents/` (generated); Codex via `.codex/agents/` (generated) |
| `.agents/hooks/` | Stateless agent-lifecycle hooks (SessionStart, PreToolUse, Stop, UserPromptSubmit) | Claude Code via `.claude/settings.json`; Codex via `.codex/hooks.json` |
| `.agents/git-hooks/` | Git hooks (`pre-commit`, `pre-push`) fired by git via `core.hooksPath` | Any agent whose `setup.sh` runs `git config core.hooksPath .agents/git-hooks` |
| `.agents/permissions/` | Canonical permission policy (`command-prefixes.rules`, `claude-mcp-allow.txt`) | Claude Code via `.claude/settings.json`; Codex via `.codex/rules/default.rules` |

### Adapter directories

| Directory | Role | Owner |
|---|---|---|
| `.claude/` | Claude Code runtime adapter: settings.json, `.claude/hooks/session-start.sh`, agents/ (generated), setup.sh | Claude Code only |
| `.codex/` | Codex runtime adapter: hooks.json, agents/ (generated TOML), `.codex/rules/default.rules`, setup.sh | Codex only |

### Setup ownership

Each agent owns its own `setup.sh` and its own hook registration:

- **Claude Code:** `.claude/hooks/session-start.sh` runs `.claude/setup.sh` on SessionStart. Claude Code setup belongs under `.claude/`.
- **Codex:** `.codex/hooks.json` runs `.codex/setup.sh` on SessionStart after the workspace is trusted. Codex setup belongs under `.codex/`.
- **No cross-agent dependencies.** Claude Code never depends on `.codex/setup.sh`; Codex never depends on `.claude/setup.sh`.
- **Workspace-scoped only.** Codex setup is scoped to this workspace checkout, not `/Users/<user>` or any broader root.

### Generated artifacts

`.claude/agents/` and `.codex/agents/` are generated from `.agents/personas/` by `scripts/generate-agents.sh`. They are committed artifacts, not gitignored — cloud agents must find them from the checkout alone without running any setup step.

### Non-negotiable: anything in the harness applies to all agents

If a skill, hook, permission rule, or persona is added to `.agents/`, it must be valid for all agents — Claude Code, Codex, cloud, and future agents. Agent-specific concerns belong in the relevant adapter directory (``.claude/` or `.codex/`), not in `.agents/`.

---

## Five conformance tests

Every change to the harness must pass all five before merge:

1. **Fresh-machine.** `git clone` + active-agent `setup.sh` + `git submodule update --init --recursive` = full working state. No manual steps, no undocumented dependencies.
2. **Cloud-agent.** A cloud agent has everything it needs in the checkout — skills, personas, docs, generated adapter config. No secrets, no SSH keys, no external setup.
3. **No-token.** No `gh auth login`, no API keys entered manually, no manual MCP configuration. Use the agent platform's native connectors.
4. **Committed-or-it-doesn't-exist.** Hooks, skills, settings, memory, decisions, and permission adapters are version-controlled or they are not real. Local-only state is not real.
5. **Symlink hygiene.** Symlinks from `~/` into a tracked workspace path are fine (reproducible via `setup.sh`). Symlinks from the repo out to the host filesystem are not.

---

## Rationale

**Why `.agents/` as a shared canonical layer.** Symlink-based sharing (the previous pattern) breaks on cloud VMs and Codex ephemeral environments where the home directory is not the same machine as the checkout. A shared directory under the repo root survives any environment that can `git clone`.

**Why generated adapter artifacts are committed.** Codex on a cloud VM starts from the checkout, not from a post-clone setup script. If `.codex/agents/*.toml` were gitignored, cloud Codex would have no personas. Committed generated artifacts satisfy the cloud-agent test at zero extra cost and make persona drift visible in git diffs.

**Why agent-specific setup scripts are not shared.** Agent-agnostic does not mean one shared setup for every platform. Claude Code and Codex have different runtime directories, hook semantics, and permission mechanisms. Mixing them creates hidden coupling and breaks fresh-VM onboarding. Each agent's setup script is a thin adapter that wires the canonical `.agents/` tree into its own runtime.

**Why permissions have a canonical layer above adapters.** Claude and Codex expose different permission primitives (JSON allowlists vs. prefix rules). Identical files are the wrong target; equivalent policy enforced through each platform's native mechanism is correct. `.agents/permissions/` is the policy; the adapter files are generated from it.

**Why the git-hooks directory is separate from the agent-lifecycle hooks directory.** Two sibling systems, not parent/child. Git's `core.hooksPath` can only point at a directory containing git-named hooks (`pre-commit`, `pre-push`, etc.). Agent-lifecycle hooks (`SessionStart`, `PreToolUse`, etc.) are registered in platform-specific config files and named by the platform, not by git. Merging them would require either renaming git hooks or injecting non-git files into the hooksPath directory — both create confusion. Separate directories keep the two systems orthogonal. See `.agents/hooks/README.md` and `.agents/git-hooks/README.md`.

---

## Consequences

**Positive:**
- A single edit to a skill, persona, hook, or permission rule propagates to all agents after the pre-commit build-artifact sync regenerates the adapters.
- Fresh-machine onboarding for any agent is deterministic: clone + agent-specific `setup.sh` = working state.
- Cloud agents have full capability from the checkout alone.
- Harness changes are visible in git diffs and reviewable in PRs — no silent local-only mutation.
- Future agents follow a clear onboarding rule: implement a thin adapter in your own directory, consume `.agents/` as the canonical source.

**Negative / costs:**
- Generated adapter artifacts (`.claude/agents/`, `.codex/agents/`) must stay in sync with `.agents/personas/`. The pre-commit hook runs `generate-agents.sh` automatically; if that script fails, the adapters may be stale. Mitigation: the pre-commit hook warns loudly on `generate-agents.sh` failure.
- Any new agent platform requires writing a new adapter directory + generator. This is intentional — the cost is proportional to the value (full harness portability).
- Skills and personas in `.agents/` must be agent-neutral. Agent-specific behavior (e.g. Claude-only tool invocations) must live in adapter files, not in the shared tree.

---

## Alternatives considered

1. **Claude-only harness (the pre-2026-05-26 state).** Rejected: hard lock-in to Claude Code. Breaks the no-lock-in invariant from `META-PRINCIPLES.md` § 2. Codex introduced the need; future agents will too.

2. **Per-agent duplicated config (no shared canonical layer).** Rejected: two sources of truth → guaranteed drift. Persona changes would require manual sync across `.claude/agents/` and `.codex/agents/`. The drift was already observed within 48 hours of Codex being installed.

3. **Symlinks from adapter directories into `.agents/`.** Rejected: symlinks break on cloud VMs and Codex ephemeral environments. The problem this ADR solves is exactly that cloud agents cannot follow symlinks back to the user's home directory.

4. **Single shared `setup.sh` for all agents.** Rejected: Claude Code and Codex have different runtime directories and hook semantics. A shared setup script would need platform-detection logic that couples the two agents and violates the "no cross-agent dependencies" rule.

5. **Gitignored generated adapter artifacts.** Rejected: cloud agents start from the checkout. Gitignored artifacts require a setup step to regenerate, which violates the cloud-agent test. Committing them keeps the checkout self-sufficient.

---

## Provenance

- Triggered: 2026-05-26, when Codex auto-migrated `.claude/` config and created a two-source-of-truth problem.
- Source decisions: `memory/decisions/DECISIONS.md` 2026-05-26 (agent-agnostic harness), 2026-05-27 (agent-specific setup boundaries), 2026-05-27 (canonical permission policy), 2026-05-27 (git permission boundary).
- Governing principles: `META-PRINCIPLES.md` § 2 (written, version-controlled, hardware-agnostic) + `AGENTS.md` § Top constraint (agent-agnostic and hardware-agnostic by default).
- Implementation: `.agents/skills/`, `.agents/personas/`, `.agents/hooks/`, `.agents/git-hooks/`, `.agents/permissions/`; `scripts/generate-agents.sh`; `.claude/setup.sh`; `.codex/setup.sh`.

---

## Revisit triggers

Re-open this ADR if:
- A new agent platform is introduced and the adapter pattern does not cover its setup semantics.
- The pre-commit `generate-agents.sh` sync proves unreliable in practice (consider a CI check instead).
- `.agents/` grows large enough that the flat directory structure creates navigation friction (consider sub-namespacing by concern).
- A skill or persona legitimately needs to be agent-specific (document the exception and its rationale here).
