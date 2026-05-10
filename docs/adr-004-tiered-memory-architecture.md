# ADR-004 — Tiered Memory Architecture

**Status:** Accepted
**Date:** 2026-04-28
**Context:** workspace-level

## Context

The workspace had a flat 37-file `memory/` folder at the auto-memory location plus a separate `llm-context-2026/` strategic context folder accessed via a manual STRATEGIC INDEX. The flat folder mixed three different decay rates: constitutional rules (laptop-agnostic, PR creation, MCP connector-only), identity profile, and active project state (deferred items, watch-memos, lead-magnet status). All loaded every session via a single `MEMORY.md` index.

`META-PRINCIPLES.md` declared "tiered memory" as principle #3 but the architecture didn't enforce it. The corpus-malleable principle (#1) had no operational mechanism — no drift detection, no consolidation cadence, no asymmetric conflict resolution between identity and operational rules.

The state had three real costs in practice:

1. **No way to tell which rules to interrogate vs. which to trust.** Identity preferences and constitutional invariants sat alphabetically interleaved.
2. **Active project state degraded long-term reasoning.** When deferred backlog items lived next to laptop-agnostic constitutional rules, both got equal weight in routing.
3. **No closed loop.** Rules accumulated. Nothing prompted condensation, promotion, or archival. The implicit assumption was that everything earned permanence on first write.

## Decision

A three-tier memory architecture at `memory/` (workspace root), with weekly consolidation as the closed-loop correction mechanism and two attribution skills as the drift-detection immune system.

### Tiers

| Tier | Horizon | What goes here | Auto-load |
|---|---|---|---|
| **Long-term** | Effectively constant | Identity profile, distilled identity-constitution content. North star. | Full content |
| **Medium-term — feedback** | Temporary, evolving | Active behavioural rules. Sub-split into `feedback/stable/` (crystallized) and `feedback/in-flight/` (tied to current workflow). The split is audit-only; runtime is unified. | Full content (both sub-folders) |
| **Medium-term — current-arc** | 1–6 month, evolving | The live snapshot of where the operator is heading right now. Updated during weekly consolidation. | Full content |
| **Medium-term — rest** | 1–6 month, evolving | Positioning, market doctrine, project arcs, advisory board, strategic context. | Routing-only references in `MEMORY.md`; full content on demand |
| **Short-term** | ≤4 weeks, episodic | Daily entries (decisions, state, conflicts). Weekly consolidation files. Items pending tier-decision. | Current week + last week |

### Auto-load policy

Conservative for v1, biased toward visibility. The session-start protocol in `MEMORY.md` (the auto-loaded machine entry) reads:

1. Every file in `long-term/` and `long-term/inner-game/`.
2. Every file in `medium-term/feedback/stable/` and `medium-term/feedback/in-flight/`.
3. `medium-term/current-arc.md`.
4. All `.md` files in `short-term/<this-week>/` and `short-term/<last-week>/`.
5. Monday consolidation check (fires `/consolidate-week` if pending).
6. Other medium-term files load on demand.

`short-term/_archive/` is not auto-read; the operator opts in by pointing at a specific week.

### Conflict resolution

Weight order, descending: live conversation > long-term > medium-term/feedback > current week > last week > rest of medium-term.

Asymmetric rule for long-term:

- Constitutional rules (operationally invariant, e.g. `feedback_laptop_agnostic`): trust the rule unless live persistently contradicts.
- Identity-rooted rules (`user_profile`, distilled inner-game): default to live and surface the divergence. Identity is the most movable thing in this whole architecture.

For low-stakes conflicts: default to live, flag for next consolidation. For identity / strategy / north-star conflicts: stop, surface, ask before acting.

### Drift detection (the immune system)

Two skills, one directive and one proactive:

- `/whence` — operator asks where Claude pulled the current claim from. Claude reports tier + source + bias risk + confidence in one paragraph.
- `/divergence-check` — Claude fires on detected frustration / loss-of-fit / correction loops / live-contradicting-long-term. Pauses, surfaces the suspected drift, asks one clarifying question, offers to record under today's short-term entry.

The proactive trigger is wired by a long-term feedback rule (`feedback_fire_divergence_check_on_frustration`) — skills don't self-trigger; the rule is what makes the immune system actually fire.

### Closed-loop consolidation

`/consolidate-week` skill, fired on Monday session start per `feedback_consolidate_week_on_monday_session_start`. v1 ships this as a behavioural rule (faster, easier to debug); promote to a hard SessionStart hook in v2 if missed in practice.

The consolidation file (`short-term/<this-week>/consolidation.md`, talks about last week) has three sections populated in order: my consolidation (Claude's proposals), your decisions (operator's verdicts), actions taken (final state).

### Feedback lifecycle

Every behavioural rule starts in `medium-term/feedback/in-flight/`. Over time:

- **Promotion** — rules that crystallize across domains and time become candidates for long-term doctrine. Move to `feedback/stable/` first; later, deliberate audit passes promote stable rules into long-term.
- **Condensation** — clusters of related rules merge into single principles.
- **Archival** — rules no longer relevant move to `_archive/` or get removed pre-merge.

This shaping happens during weekly consolidation (small deltas) or deliberate audit passes (architectural pruning).

### Symlink architecture

Files live at `/Users/<user>/Workspace/memory/` (workspace root, version-controlled). Claude Code reads from `~/.claude/projects/<sanitized-workspace-path>/memory/` — that path is a symlink, created by `bash .claude/setup.sh` on a fresh machine. Test: clone + setup.sh = full memory accessible. Laptop-agnostic.

## Rationale

**Why three tiers and not two.** Two-tier (long + short) collapses the interpretive layer. Medium-term is where current direction lives — neither identity-stable nor episodic. Without it, drift signals from short-term have nowhere to surface as direction-shifts before reaching long-term identity audit. Three tiers give the system a structural place for "what's true right now but might change in 6 months."

**Why feedback in medium-term and not long-term.** Feedback is by nature in-flight. Most behavioural rules surface from corrections that haven't yet earned constitutional status. Putting them in long-term anchors them prematurely and creates false equivalence with identity. The audit critique that surfaced this was the load-bearing observation: when a `feedback_*` file lives next to `user_profile`, the asymmetric conflict rule ("identity-rooted defaults to live") gets accidentally applied to constitutional rules that shouldn't drift.

**Why feedback auto-loads despite living in medium-term.** Behavioural rules are how Claude operates. They must be in scope every turn. The exception ("medium-term is on-demand except feedback/") is documented but worth the cognitive cost — the alternative (putting feedback in long-term) creates worse problems.

**Why stable/in-flight split is audit-only, not runtime.** Runtime behaviour is unified — both sub-folders auto-load and weight equally. The split exists so the operator can see at a glance which rules to interrogate first during a deliberate audit pass. Splitting runtime behaviour would create three different sets of weighting rules instead of two, increasing surface area without adding value.

**Why short-term is week-folded.** Daily entries need a chronological container. ISO weeks are universal, sortable, and align with the consolidation cadence. The 4-rolling-week active window matches the decay rate of useful continuity — anything older is interpretive (lives in medium-term) or archived.

**Why weekly consolidation and not daily / monthly.** Daily creates fatigue. Monthly loses the signal — drift accumulates and the consolidation becomes overwhelming. Weekly matches the rhythm of operational pacing for a transition phase.

**Why drift skills as a pair (directive + proactive).** Operator-fired (`/whence`) catches what Claude missed but operator suspects. Claude-fired (`/divergence-check`) catches what Claude detects but operator hasn't surfaced. Both are necessary because the failure modes differ: the operator can detect drift Claude can't (operator knows their own state); Claude can detect compounding drift the operator hasn't named (correction-loop pattern).

**Why symlink architecture and not direct write.** Workspace at `/Users/<user>/Workspace/` is the source of truth — version-controlled, laptop-agnostic, survives fresh-machine clone. Claude Code's read location lives at `~/.claude/projects/...` — that's where the platform looks. Symlinking from the platform location to the workspace makes the workspace canonical without requiring platform changes.

## Consequences

**Positive:**

- Architecture matches operational truth. Different rules have different decay rates; the structure now reflects that.
- Drift detection prevents stale-rule drag. The two skills + behavioural triggers turn the corpus-malleable principle from theory into practice.
- Closed-loop consolidation prevents tier freeze. Without it, the architecture would calcify; with it, the system corrects itself.
- Asymmetric conflict resolution handles identity-shift signals correctly. When the operator changes, the architecture surfaces the drift instead of hiding it.
- Laptop-agnostic via symlink. Source of truth is in workspace; Claude Code reads via symlink. Fresh-machine clone + setup.sh works.

**Negative / costs:**

- Cognitive load: three tiers + sub-tier + audit-only sub-sub-folders requires discipline. The READMEs explain it; the operator must internalize.
- Auto-load policy "feedback always-loads but rest of medium-term doesn't" is an exception that needs to be remembered.
- Weekly consolidation depends on Monday-trigger reliability + operator bandwidth. v1 uses a behavioural rule (rule-based discipline); fragile if the operator skips a Monday.
- Identity-rooted long-term entries can drift fast (operator changes); risk of stale north-star is real and known.
- The feedback folder will grow without pruning unless the audit cadence holds.

**Calibration risks to monitor:**

- **Consolidation skipped 2+ weeks.** Tiers freeze. Promote behavioural rule to hard SessionStart hook.
- **Feedback folder grows past ~50 entries without pruning.** Audit fatigue is imminent. Trigger a deliberate audit pass.
- **Identity-rooted long-term entries persistently contradicted by live conversation.** Identity has shifted; reshape long-term, don't just patch.
- **Auto-load context bloat.** If the auto-loaded surface regularly exceeds ~10K lines, trim or move to on-demand.
- **Drift skills don't fire.** If `/divergence-check` never fires despite frustration signals, the trigger rule is silently broken — re-validate.

## Alternatives considered

1. **Flat memory (the previous state).** Rejected: mixing constitutional with project state with identity created false equivalence and prevented asymmetric conflict resolution.
2. **Single-tier (just long-term).** Rejected: ignores decay-rate differences. Forces every rule to be either too stable (and stale) or too volatile (and lost).
3. **Two-tier (long + short, no medium).** Rejected: medium-term is the interpretive bridge. Without it, drift signals from short-term have nowhere to surface as direction-shifts before reaching long-term identity audit. The architecture loses its self-correction loop.
4. **Vector-DB / RAG with semantic retrieval.** Rejected: heavy, opaque, requires infrastructure that breaks the laptop-agnostic principle. Filesystem + grep semantics fit the workflow better — every rule is human-readable, version-controllable, diffable. Move to vectors only if the corpus exceeds ~500 files and routing becomes a real bottleneck.
5. **Feedback in long-term (the v1 initial design).** Rejected after audit critique: false equivalence between constitutional rules and in-flight discipline. Constitutional rules ARE long-term; in-flight rules ARE medium-term. The taxonomy must reflect the decay rate.
6. **Stable/in-flight as differential auto-load (in-flight loads, stable doesn't).** Rejected: the runtime needs both. The split is for audit, not for behaviour. Splitting runtime adds complexity without value.
7. **Daily consolidation cadence.** Rejected: fatigue. Operator skips it within 2 weeks.
8. **Monthly consolidation cadence.** Rejected: signal lost. Drift accumulates and the consolidation becomes overwhelming.
9. **Single drift-detection skill (just directive, or just proactive).** Rejected: failure modes differ. The operator catches what Claude misses about their own state; Claude catches what the operator hasn't named about compounding patterns. Both are necessary.
10. **Strategic context as a separate submodule (the legacy `llm-context-2026/` design).** Rejected: created routing fragmentation. One memory location with internal tiers is simpler than two locations with cross-references.

## Provenance

- Triggered: 2026-04-28 session, dogfooding `META-PRINCIPLES.md` principle #3 ("tiered memory") on the architect's own setup. The orchestration article on the same principles had been published; the architect's memory had not been restructured.
- Implementation: 10-phase plan in one xhigh session, PR #39.
- Refinement: feedback-as-medium-term-sub-tier with stable/in-flight split, PR #40 (after audit critique).
- Deprecation of legacy `llm-context-2026/`: PRs #41 + #42.
- Codified in: `memory/README.md`, `memory/MEMORY.md`, `memory/long-term/README.md`, `memory/medium-term/README.md`, `memory/medium-term/feedback/README.md`, `memory/short-term/README.md`, this ADR, `.claude/decisions/DECISIONS.md`.
- Skills implementing the architecture: `.claude/personal-skills/whence/`, `.claude/personal-skills/divergence-check/`, `.claude/personal-skills/consolidate-week/`.
- Behavioural rules wiring the loops: `memory/medium-term/feedback/in-flight/feedback_fire_divergence_check_on_frustration.md`, `memory/medium-term/feedback/in-flight/feedback_consolidate_week_on_monday_session_start.md`.

## Revisit triggers

Re-open this ADR if:

- The auto-loaded surface regularly exceeds ~10K lines (context bloat).
- Monday consolidation is skipped 2+ weeks (promote behavioural rule to hard hook).
- The feedback folder grows past ~50 entries without pruning (audit pass overdue; consider whether the lifecycle is actually working).
- Identity-rooted long-term entries are persistently contradicted by live conversation (identity has shifted; reshape long-term, don't patch).
- Drift skills don't fire when expected (calibration defect).
- A new operator-context type emerges (e.g. multi-operator workspace, team memory) — re-derive tiers.
- The corpus exceeds ~500 files and grep-based routing becomes a bottleneck (consider vector retrieval).
