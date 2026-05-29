---
horizon: medium-term
type: project-management-sop
auto-load: true
last-reviewed: 2026-05-20
---

# Workspace Collaboration Workflow

Cross-project SOP for all collaboration flows between Ahmed and Claude Code. This document governs the whole workspace — not any single project. Project-specific flows (boringsystems article pipeline, analytics gates, etc.) extend these protocols in their own `docs/workflow.md`.

**Auto-loaded every session.** Weighted above `short-term/feedback` in conflict resolution: a crystallized SOP wins over a raw behavioral correction.

---

## Autonomy gradient

Every flow has a defined autonomy level. Knowing it in advance prevents the single biggest failure mode: Claude executing when it should have confirmed, or confirming when it should have just executed.

| Flow | Level | Confirmation required |
|---|---|---|
| Research — narrow lookup | Full-auto | Nothing. Execute and report. |
| Research — open-ended investigation | Plan-confirm | Question scope, sources, output shape, check-in trigger |
| Card creation | Behavioral checklist | Nothing — checklist is structural |
| Card pickup / kickoff | Plan-confirm | Plan declaration before ANY edit |
| Code change | Plan-confirm | Files changing, irreversible decisions, assumptions |
| Structural change | Plan-confirm + ADR | Same as code change + ADR scope |
| Advisory / strategic brief | Brief-approval-gate | Draft brief verbatim → wait for explicit approval → fire |
| Article flow (boringsystems) | See boringsystems workflow | See boringsystems workflow |
| Post-merge cleanup | Full-auto | Nothing — deterministic |

**Level bump triggers (any flow):** an irreversible decision discovered mid-execution → pause, surface, confirm before continuing. Scope expands beyond approved plan → pause, surface.

---

## Per-flow skill checklist

Skills that must run before declaring done. "Build passed" is necessary but not sufficient — skills catch wiring gaps and doc drift the build doesn't.

| Flow | Pre-execution | Before declaring done |
|---|---|---|
| Code change | `/check-constraints` (if structural surface) | `/analytics-audit` (new outbound links/CTAs), `/arch-review` (structural/architectural) |
| Structural change | `/check-constraints` | `/arch-review` |
| Research — open-ended | — | — (output is findings, not code) |
| Card creation | `/card-against-pattern` | Self-containment test (mental — see `linear-sop.md`) |
| Card pickup / kickoff | `/pre-start` | `/declare-ready` |
| New skill or hook | — | `/arch-review` |
| Advisory brief | Brief-approval-gate | — |
| Article flow | — | See boringsystems workflow |

---

## Scope discipline — max three concerns per session

If a single session/branch accumulates more than **three distinct concerns**, stop and propose splitting into separate feature branches before proceeding.

- Count concerns, not files. Two articles = one concern (content). Lead-magnet infra = another (platform). Mermaid rendering = a third (platform). Home redesign = a fourth (layout).
- At four, stop. Propose the split explicitly: *"this is four concerns — recommend splitting into branches A, B, C, D; which order do you want?"*
- Wide-scope sessions hit three failure modes: attention degrades past ~150 reliable items, PRs become un-reviewable, context thrash (changes to one concern invalidate the mental model of another).
- **Bundling exception:** work that is genuinely coupled (can't ship A without B) stays on one branch. **Bundling failure mode:** using "coupled" to rationalize tangentially related work. When in doubt, split.

---

## Research flow

**Trigger:** "think with me on X", "investigate Y", "what do you know about Z", "explore this", or any open-ended investigative request.

**Narrow lookup** (specific file, symbol, factual question with a known answer): full-auto. Execute and report. No gate.

**Open-ended investigation:** plan-confirm.

1. **Declare the investigation.** State: what question is being answered, what sources will be checked (web / codebase / docs / memory), expected output shape (synthesis / bulleted findings / comparison), and check-in trigger.
2. **Wait for scope approval.** Ahmed confirms or corrects. Alignment happens before investigation begins.
3. **Investigate.** Use subagents where scope warrants — long web research → `market-strategist`; codebase archaeology → `Explore` agent. Run parallel where independent.
4. **Synthesize.** Long output (>400 words of dense analysis) → `tmp/<name>.md` + reference path. Short output → inline.
5. **Declare done.** What was checked, what was NOT checked (scope boundary), confidence level.

---

## Card creation flow

**Trigger:** Ahmed asks to create a Linear card.

**Autonomy level:** behavioral checklist (no confirmation gate; the checklist is the gate).

1. **Check for container pattern.** Run `/card-against-pattern`. If an existing pattern fits, mirror it.
2. **Draft the card.** Five components required: goal (what done looks like), why (problem being solved), start-from (current state, concrete), how (approach/decisions already made, optional), all inputs needed (every artifact a clean-slate agent needs, inlined verbatim if ephemeral).
3. **Self-containment test.** Classify every reference: durable (workspace file, URL, Linear card) or ephemeral (tmp/, short-term memory, unconsolidated discussion). For every ephemeral reference: inline the substrate as a card comment before submitting.
4. **Submit + end-of-turn shape.** End the turn with all three:
   - **5-bullet executive summary** of what the card captures (load-bearing decisions, placeholders, open questions — not a restatement of the body).
   - **Linear card URL** clickable in chat.
   - **`open <url>` executed via Bash** in the same turn so the card launches in Ahmed's browser.
   No asking, no per-card opt-in.

See `linear-sop.md` for the full card lifecycle (In Progress → In Review → Done transitions).

---

## Card pickup / kickoff flow

**Trigger:** "start BOR-XX", "let's work on BOR-XX", or Claude picks up a card to execute.

**Autonomy level:** plan-confirm — always, even on detailed cards.

1. **Fetch the card in full.** Read description + all comments. Do not skim.
2. **Verify all path references.** Every file path, skill name, and doc reference in the card — confirm it resolves. If a path has drifted, flag it before proceeding.
3. **Read required docs.** If the card has a start-of-session protocol, follow it exactly. Otherwise: apply the code change gate (read domain docs first per the relevant project's workflow SOP).
4. **Invoke `/pre-start`.** Produce a gated plan artifact: flow type, files changing, decisions requiring confirmation, assumptions, skills to run post-execution.
5. **Transition card to In Progress** + post a starting comment: branch name, any bundled cards, next handoff point.
6. **Wait for Ahmed's explicit approval** before any edit. Silence is not approval.
7. **Execute** per the approved plan. Mid-execution: if an irreversible decision arises that wasn't in the plan, pause and surface before continuing.
8. **On done:** transition card to **In Review** + post an executive summary comment (delta vs card description, carve-outs, follow-ups, PR link). **Done is Ahmed's transition, not Claude's.**

For **bundled cards** (multiple cards on one PR): both cards get the In Progress transition + starting comment, and both get the In Review transition + executive summary.

---

## Code change flow

**Applies to:** any non-content file change in any project (layouts, components, config, scripts, deps, hooks, skills). Each project adds project-specific steps — see that project's `docs/workflow.md`.

**Autonomy level:** plan-confirm.

Three mandatory gates, in order. None are skippable. Applies to any multi-file or structural change. Does NOT apply to typo fixes, one-line changes, single-file trivial edits with no architectural surface.

### Gate 1 — Pre-execution: read context, write plan, confirm

1. **Read context first.** Read the project's domain docs relevant to the work type. Do not infer from CLAUDE.md alone — CLAUDE.md is a pointer, not the full context. For boringsystems analytics: `docs/analytics.md` + `docs/target-audiences.md`. For i18n/routing: `docs/architecture-and-toolchain.md`. Etc.
2. **Branch.** Create a feature branch: `omraneah/<short-description>`. Reuse the existing session feature branch — do not create siblings within a session. Apply the max-three-concerns rule (above).
3. **Invoke `/pre-start`.** Produce a plan artifact: files changing, decisions requiring confirmation, assumptions, skills to run post-execution.
4. **Confirm before executing.** Especially: any decision that can't be easily reversed once code is written (removing a dependency, choosing an event taxonomy, mapping a derived dimension). Do not execute on assumed answers.

### Gate 2 — During: atomicity on design changes

When a design decision changes mid-session (Ahmed overrules an approach, a constraint is discovered that invalidates a plan):

- Update all affected docs (ADRs, reference docs, constraints.md) in the **same commit** as the code change.
- Never split doc updates from code updates across commits. "I'll update the docs later" creates guaranteed drift.

### Gate 3 — Post-execution: run review skills, fix, declare done

1. **Verify locally.** Run the project's build command before committing.
2. **Run review skills** per the skill checklist (above). For any component touching outbound links, CTAs, or conversion actions: `/analytics-audit`. For structural/architectural changes: `/arch-review`. For articles: `/article-review` + `/french-audit`.
3. **Fix all FIX-level findings.** WARN-level: judgment call. FIX-level: fix before declaring done. Re-run skill to confirm clean.
4. **Invoke `/declare-ready`.** Explicit pre-handoff declaration before any push.
5. **Commit → PR handoff** (next section).

"Build passed" is necessary but not sufficient. The build gate catches type errors and broken imports. The skills gate catches wiring gaps, missing tracking, broken invariants, and doc drift.

---

## Structural change flow

For changes to content schema, routing architecture, enforcement tier, or anything that would require an ADR. Extends the code change flow.

**Autonomy level:** plan-confirm + ADR.

1. **Run `/check-constraints` first.** If a conflict surfaces, resolve the constraint before proceeding.
2. **Write an ADR if the decision is hard to reverse.** Threshold: does it affect project structure, a key quality attribute, or would it be painful to undo?
3. **Proceed as code change flow**, referencing the ADR in the commit message.

---

## PR handoff

**Claude's job:** create feature branches, commit, push to origin, surface the GitHub PR-creation URL.

**Ahmed's job:** click the URL, review, open the actual PR himself.

**Hard rules:**
- Never run `gh pr create`, `gh pr ...`, or any `gh` command that mutates state.
- Never call `mcp__github__create_pull_request`, `mcp__github__merge_pull_request`, or similar write operations — even if the connector is authenticated.
- `mcp__github__*` read operations are fine (PR status, issues, commits).
- Consistent with the laptop-agnostic + cloud-connector-only principles: no `gh` CLI, no local tokens, no token-based MCP for write ops.

**End-of-turn shape on push** — every push that produces a `pull/new/<branch>` URL ends the turn with all three:

1. **5-bullet concise summary** — one bullet per concern, what shipped (terse, not a re-statement of the diff).
2. **The `github.com/.../pull/new/<branch>` URL** clickable in chat.
3. **`open <url>` executed via Bash** in the same turn so the URL launches in Ahmed's default browser.

No asking, every time. The `/pr` skill follows this same shape — draft title/body, surface URL, open in browser, give the 5-bullet summary — but never creates the PR.

If a Linear card covers this work, the card also gets an **In Review** transition + executive summary comment with the PR link (see `linear-sop.md`).

---

## Advisory / strategic session flow

When composing a brief that frames a situation for a context-naive sub-agent — especially the strategic advisory board, the conductor when it exists, or any Agent call where framing carries interpretive weight:

1. **Draft the brief.**
2. **Show it to Ahmed verbatim** in chat, clearly delimited as a draft.
3. **Wait for explicit approval** before invoking the agent(s).
4. **Fire only after approval.**

**Why:** The brief IS the determining variable. Sub-agents respond honestly to what they're given. A wrong frame produces a confident-but-wrong diagnosis. Approval cost is low; misframe cost is high (loss of trust in the entire instrument). 2026-04-26 precedent: same six advisors, same protocol, opposite verdict — driven entirely by brief quality (round 1 brief was factually wrong; round 2 brief was accurate).

**Editorial stripping (always applied at draft time):**

- **Facts only.** Numbers, dates, named artifacts, direct quotes from Ahmed in quotation marks, observable state.
- **No characterizations.** No "running well," "stuck," "drifting," "healthy," "disciplined." Describe the data; let the agent characterize.
- **Claude's own framing, when needed, is flagged explicitly.** *"My read of this — feel free to disagree: ..."* — not embedded mid-paragraph.

**Apply gate when:**
- Convening the strategic board (always — the lens is the value, the brief is the leverage).
- Sub-agent doing strategic synthesis.
- Any context-naive agent receiving multi-paragraph framing.
- After Ahmed has corrected framing and Claude is re-drafting.

**Do NOT apply gate (overhead unjustified):**
- `Explore` agent searching the codebase for a keyword.
- Bash for `git status`, `ls`, mechanical lookups.
- Self-contained tactical delegations with no interpretive framing.

**Rule of thumb:** if the agent's output will inform a decision Ahmed will rely on, the brief gates. If it's a lookup, it doesn't.

---

## Parallel and lane-change protocols

### Parallel-by-default for non-conflicting tasks

When Ahmed gives a multi-task instruction, default to parallelizing every task that doesn't conflict with another. Multi-task instructions are requests for the work to be done; Claude picks the execution shape.

**Classify each task:**
- **Independent** — no shared file, no shared state, no dependency on another task's output. **Default: PARALLEL** via Agent or tool calls in a single message.
- **Sequential dependency** — task B reads task A's output. Run sequentially, no choice.
- **Conflicting** — both edit the same file or shared state. Run sequentially in main thread. Worktree **only** if Ahmed explicitly asks for isolation.

**Multiple tool calls in the SAME message run in parallel.** Use aggressively. A single message can contain N Agent calls, M Bash calls, K Write calls — all execute concurrently if they don't conflict.

**Subagents are the unit of parallel cognitive work.** Independent reasoning streams (Singer on one question + general-purpose for a Linear card + Naomi reviewing positioning) all fire in one message.

**Worktrees are for the conflict case ONLY.** Default execution = same working tree, same branch, parallel tool calls + Agent invocations. If Ahmed wants worktrees, he says so.

**Confirm execution shape briefly** in the response ("firing X in parallel with Y while doing Z") so Ahmed sees the choice and can correct.

### Parallel-agent recap (first summary)

When spawning parallel sub-agents, announce model/effort/why for each as the FIRST summary before reading any agent output:

> **Parallel sub-agent setup:**
> - Agent A — [task]: model **[X]**, effort **[Y]** — why [Z]
> - Agent B — [task]: model **[X]**, effort **[Y]** — why [Z]

Then the tool calls fire.

When results come back, recap one line per agent before synthesizing:

> Agent A returned [headline]. Agent B returned [headline]. Synthesizing.

**Skip the announcement when:** single sub-agent (mention inline instead), sub-agent inherits exact parent setup + task is mechanical, repeated invocation of the same agent type with the same setup (announce once, skip subsequent).

### Lane-change announcement (single-thread)

When the conversation shifts task-dimension or cadence (psychology → code, exchange → distilled, single → parallel), announce the current model/effort and a recommendation BEFORE proceeding.

Format:

> **Lane shift:** [old lane] → [new lane]
> **Current setup:** [model] / [effort]
> **Recommendation:** [keep / switch to X / bump to Y]
> **Why:** [one line]

If recommendation is "keep" — proceed. If "switch / bump" — proceed for trivial mechanical changes; wait for Ahmed's signal when the change is non-trivial.

**Fire on:** strategic exchange → execution, code → market research, light coding → heavy infra, single thread → parallel sub-agents, distilled output requested → exchange resumes, Ahmed signals "let's discuss" or "go execute," architecture phase → execute phase.

**Don't fire on:** continuous task lane, trivial sub-step inside same lane, confirming a previous lane change.

---

## Model and effort defaults

Three independent axes shape the choice:

1. **Task dimension** — psychology, positioning, advisors, code, ops, research
2. **Cadence** — exchange (back-and-forth, user is the loop closer) vs distilled (long output, model carries the pass)
3. **Complexity** — file writes / mechanical vs deep reasoning vs novel architecture

**Effort and response length are independent levers but correlate misleadingly.** Higher effort biases toward longer, more complete output, which fights exchange cadence. Lower effort = faster, shorter, more conversational. Model choice (Opus / Sonnet / Haiku) is orthogonal — depth-of-reasoning quality vs speed-and-economy on operational work.

### Per-lane defaults

| Lane | Model | Effort | Why |
|---|---|---|---|
| Psychology, release, emotional rabbit-holes | Opus 4.7 | `high` | Nuance + exchange cadence is the work. xhigh fights cadence |
| Positioning, GTM, market research | Opus 4.7 | `high` | Iterative; user is the loop closer |
| Advisory board (`/convene-board`) | Opus 4.7 | `xhigh` per advisor | Each lens needs depth, parallel fire, no internal exchange |
| Architecture decided → "go execute deeply" | Opus 4.7 | `max` (session-only) | Hand off deep reasoning, get one strong pass |
| Blog-site coding (boringsystems) | Sonnet 4.6 | `high` | Light, plenty smart, saves Opus quota |
| Heavy infra / backend coding | Opus 4.7 | `xhigh` | Default for serious code |
| Operational ops (`/commit`, `/pr`, `/github-cleanup`, etc.) | Sonnet 4.6 | `medium` | Speed > depth. Mechanical |
| Reflection / session recap (`/wrap-session`, `/session-pulse`) | Opus 4.7 | `high` | Pattern-recognition + improvement-proposal. Distilled |
| Web / market research (long, distilled) | Opus 4.7 | `xhigh` | Long output OK; depth matters; no exchange inside |
| One-off "really think hard" turn | current model | current effort + word `ultrathink` in prompt | Bumps a single turn without committing the session |

### Workspace defaults

- Session default: **Opus 4.7 / high** (matches dominant workload: strategic / psychological / positioning).
- Pinned in `.claude/settings.json` as `effortLevel: "high"` and `model: "opus[1m]"`.
- Per-skill / per-agent overrides via frontmatter: `model:` and `effort:` fields.

### Cascading order (which setting wins)

1. `CLAUDE_CODE_EFFORT_LEVEL` env var — highest precedence
2. `--effort` CLI flag at startup
3. Skill / agent / subagent frontmatter — when active
4. `effortLevel` in settings.json — workspace / user
5. Model default (`xhigh` for Opus 4.7, `high` for Opus 4.6 / Sonnet 4.6)

### Three reasons NOT to follow the matrix

- User explicitly asks to bump or drop — honor it.
- Lane shifts mid-session — invoke the lane-change announcement (above).
- Genuinely hard problem warrants `max` for one session — set deliberately via `/effort max`, don't drift.

### Revisit triggers

- A new model is released or default changes.
- A new effort level is added.
- A recurring task type doesn't fit any row — propose a new row.
- Effort/length correlation changes (Anthropic could decouple them in a future release).

---

## Cross-workspace conventions

### TODO.md files

Known limitations and improvement backlog items live in `TODO.md` files, placed at the parent folder level of where they apply. If a limitation affects a whole folder, `<folder>/TODO.md`. If it affects a subfolder, the TODO lives at the parent. Content: what's incomplete, what needs improvement, what the next step is. This keeps technical debt visible and co-located with the affected context.

### Workspace root > submodule for principles

When pointing to a principle or protocol, point first to its workspace-root declaration (e.g., this file, `META-PRINCIPLES.md`). Never point only to a submodule. The workspace is the authoritative tier; submodule docs are project-specific extensions.

### Feedback crystallization path

Short-term feedback rules crystallize into mid-term SOPs when they describe a protocol (not just a behavioral correction). The crystallization target is this file. After a rule crystallizes into a section here, the corresponding feedback file becomes a thin pointer and is archived in the next audit pass. See `memory/short-term/feedback/TODO.md` for the candidate list.

---

## Twice-is-a-pattern — codify before the third time

When the same manual task happens twice in a single session — running the same grep, writing the same boilerplate, executing the same git sequence, doing the same FR+EN mirror edit — **stop before the third time** and propose codification: a skill, a hook, a doc section, or a memory entry.

**Why:** Every system improvement that lags the pattern by 2–3 PRs wastes compound interest. The skill's value starts when written, not when the pattern was first recognized.

**How to apply:** After completing a task, one-beat check: "has this shape appeared before in this session?" If yes, name the pattern and propose the smallest durable form. Do not wait for session-close — propose mid-session. Ahmed picks (codify now vs. park). The proposal is the discipline.

Codification targets by what the pattern touches:
- **Deterministic shell sequence** → hook or shell script under `.agents/`
- **Reasoning-heavy checklist** → a skill under `.agents/skills/`
- **Behavioral rule** → a feedback file + one line in AGENTS.md
- **Architectural constraint** → `docs/constraints.md` + decision log entry
- **Governance decision** → `memory/decisions/DECISIONS.md` via `/log-decision`

Never invent a new codification location to avoid the existing ones.

---

## Verify before claiming done

**Never declare a task done without running the actual verification step.** "Done" means verified, not executed.

Before saying "done", "complete", "clean", or any closure language: run the relevant check (build passes, grep returns empty, file state matches expectation). If the check tooling exists (`/declare-ready`, `/check-leaks --docs`, `astro build`, `git status`), invoke it. Don't skip.

Exception: explicitly time-boxed exploratory tasks where "done" means "explored to scope" — even then, surface what's unverified.

---

## /declare-ready is the mandatory pre-handoff gate

Never ask Ahmed to review a PR until `/declare-ready` has run to completion:
- All required skills run and PASS
- Card transitioned to In Review
- Executive summary posted as a card comment

If Ahmed has to point out a missed step, the collaboration has failed. Ahmed's review should begin at the PR, not at correcting Claude's process.

`/declare-ready` is the last thing that runs before `/pr`. It is not optional. If the card can't be identified, surface that explicitly — don't silently skip.

---

## Connector-first MCP — never manual auth

All tool authentication goes through claude.ai connectors. Never suggest manual token-based auth. This covers both MCP servers and CLI tools.

**Services with direct connectors** (never set up manually): Linear, GitHub, Gmail, Google Calendar, Google Drive, Notion — and anything else visible in claude.ai Connectors.

**How to apply:**
- When Ahmed asks to connect a tool, check if it's in claude.ai Connectors first. If yes, use it.
- For GitHub: use `mcp__github__*` tools. Never `gh` CLI, never `gh auth login`.
- For Linear: use the Linear MCP connector. Never `linear-cli` or API keys.
- Manual setup is only acceptable after explicit confirmation that no connector exists.

---

## Skills canonical path — `.agents/skills/`

New skills go directly to `Workspace/.agents/skills/<name>/SKILL.md`. Never use `~/.claude/skills/` as a write target (it is a symlink — resolve it to the canonical source before writing).

`~/.claude/skills` is a symlink into `Workspace/.agents/skills/`. Writing to the symlink instead of the canonical source obscures version control. No exceptions.

---

## Harness work goes under `.agents/` — never `.claude/` or `.codex/`

Any harness component that must fire regardless of which agent is active (hooks, skills, personas, permissions, git-hooks) lives in `.agents/`. `.claude/` and `.codex/` hold ONLY per-agent adapters.

**Categorization rule:**
- `.agents/hooks/` — tool-call hooks (PreToolUse, PostToolUse, etc.)
- `.agents/git-hooks/` — git-invoked hooks (pre-commit, pre-push)
- `.agents/skills/` — canonical skill definitions
- `.agents/personas/` — canonical sub-agent personas
- `.agents/permissions/` — canonical permission policy
- `.claude/`, `.codex/` — per-agent adapters only

**Test before commit:** "If Codex ran this workspace tomorrow, would the harness behavior I just added still fire?" If no, the work is in the wrong place.

---

## tmp/ — workspace short-term RAM

### Part 1 — Long output goes to tmp/, not chat

When Claude generates more than roughly 400 words of dense analysis the user will read in full, write it to `tmp/<descriptive-name>.md` at the workspace root and reference the path in chat. Do not dump it inline.

What counts as "long": multi-section analyses, comparison tables, structured option breakdowns, verbatim drafts before approval, reference dumps the user is going to read once and discard.

What does NOT go in `tmp/`: short answers (one to a few paragraphs), anything going directly to a final home (article, memory, Linear, ADR), code being edited.

Assume nothing in `tmp/` persists across sessions. Default fate is deletion. Promote explicitly when Ahmed signals it matters.

### Part 2 — Promote tmp/ artifacts before session boundary

When you generate something in `tmp/` that matters beyond the current turn — load-bearing analysis, raw material for an article, anything you or Ahmed will reference later — promote it to a permanent home BEFORE any session-boundary event. "I'll move it later" is the failure mode this rule exists to prevent.

Promotion targets:
- Raw material for a deferred work item → paste as a comment on the relevant Linear card
- Decisions / state worth keeping → `memory/short-term/<this-week>/<today>.md`
- Artifacts that belong in a project repo → commit them in that repo
