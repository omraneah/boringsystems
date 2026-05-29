# GitHub SOP — Boringsystems Workspace

> Version-controlled doctrine. Updated after each significant workflow change.
> Companion: `linear-sop.md` (same folder).
>
> ⚠️ This document contains only stable rules and structures — never board snapshots,
> PR IDs, branch names of current work, or any live state. Those are short-term episodic
> and belong in `memory/short-term/` or on GitHub itself.

---

## Repository structure

| Repo | Role | Stack |
|---|---|---|
| `omraneah/workspace` | Root workspace + submodule pointers | — |
| `omraneah/boringsystems` | Main site | Astro, Vercel |
| `omraneah/personal-apps` | Subdomain apps | Next.js 16, React 19, Tailwind 4 |
| `omraneah/cross-stack-architecture-starter-pack` | Read-only reference | — |

Submodule URLs in `.gitmodules` must always be **HTTPS** (not SSH) — required for cloud-agent compatibility. Local SSH-via-HTTPS rewrite is fine (`url."git@github.com:".insteadOf`); that config stays local and doesn't affect the repo.

---

## Protected branches — absolute rule

**Never push to: `main`, `master`, `development`, `dev`, `production`.**

Enforced by two hooks:
- `block-protected-push.sh` (PreToolUse/Bash) — blocks protected-branch push, force-push, and deletion commands
- `enforce-feature-branch.sh` (PreToolUse/Edit|Write|NotebookEdit) — blocks edits when on a protected branch

If a protected-branch push is ever needed, Ahmed does it manually. Claude never does.

Git commands are pre-authorized normal workflow. Claude expresses this through broad `Bash`; Codex expresses it through broad `prefix_rule(pattern=["git"], decision="allow")`. Do not ask Ahmed for Git-command permission unless the command would touch a protected branch or bypass hooks.

---

## Branch naming

| Context | Convention | Example |
|---|---|---|
| Single feature/card | `omraneah/<kebab-case-task>` | `omraneah/mixpanel-install` |
| Multi-concern session | `omraneah/session-YYYY-MM-DD` | `omraneah/session-2026-05-01` |
| Linear card (auto-suggested) | `omraneah/bor-<N>-<slug>` | `omraneah/bor-40-mixpanel` |

**Branch per concern.** If a session accumulates more than three distinct concerns, split into separate branches. Reuse the existing session branch — do not create siblings within a session.

---

## Sub-agent worktree & branch discipline

When dispatching sub-agents that commit code (especially with `isolation: worktree`), three failure modes have recurred — codify against them:

- **Branch off `origin/main`, explicitly.** A worktree inherits whatever HEAD the main checkout was on at spawn — often a stale session branch. The agent's first step must be `git fetch origin` then `git checkout -b <branch> origin/main`. Never branch new work off an unmerged feature branch or an unsynced base. (Recurred: an enforcement branch cut from a pre-merge base hit avoidable conflicts.)
- **Verify the pushed branch carries the work.** A worktree auto-creates a `worktree-<id>` branch; commits can land there instead of the intended `omraneah/<task>` branch, and the push then ships an empty feature branch. After an agent reports "pushed," confirm `git rev-parse origin/<branch>` is non-empty and matches the work. (Recurred: graduation commits stranded on the worktree auto-branch; pushed branch was empty.)
- **Relative paths inside worktrees.** Absolute `/Users/...` or `/home/...` paths bypass worktree isolation and edit the live checkout. Agents use repo-relative paths or `$PWD`.
- **Scoped `git add`.** `git add -A` can sweep `.claude/worktrees/` into the index as stray refs. That path is gitignored; prefer `git add <paths>` or `git add -u`.
- **Check submodule pointer before commit** — it can drift when working across branches.

---

## Division of labor — PR workflow

| Step | Owner |
|---|---|
| Create feature branch | Claude |
| Commit work | Claude |
| Push to origin | Claude |
| Surface 5-bullet summary + PR-creation URL + auto-open in browser | Claude |
| Click URL, review diff, open the actual PR | **Ahmed** |
| Review, approve, merge | **Ahmed** |
| Signal "merged, clean up" | Ahmed |
| Sync main + delete feature branch | Claude (`/github-cleanup`) |

**Claude never runs `gh pr create`, `mcp__github__create_pull_request`, or any PR-mutating GitHub operation.**

`mcp__github__*` read operations are fine (checking PR status, reading issues, listing commits).

---

## End-of-turn shape when pushing

Every push that produces a `pull/new/<branch>` URL ends the turn with all three:
1. **5-bullet concise summary** — one bullet per concern, what shipped
2. **Clickable `github.com/.../pull/new/<branch>` URL** in chat
3. **`open <url>` executed via Bash** — auto-launches in Ahmed's browser

No asking, every time. If a Linear card covers this work, the card also gets an In Review transition + executive summary comment with the PR link.

---

## Commit and push — pre-authorized workflow

When a discrete unit of work finishes, commit and push to a feature branch without asking permission first. This is the default close-out for any completed task.

**Why:** Asking each time creates friction on a workflow that's already settled.

- After finishing a task, commit + push immediately. Don't end the turn with "want me to commit?".
- Git commands on feature branches are pre-authorized normal workflow.
- If currently on a protected branch, create `omraneah/<short-task-name>` first, then commit + push.
- Claude pushes; Ahmed opens the PR. That boundary never changes.

## Auto-edit on feature branch — never ask

Editing files in this workspace is pre-authorized on feature branches. Do not ask permission to use Edit, Write, or NotebookEdit.

1. Before the first edit of any session, check current branch: `git -C <repo-root> rev-parse --abbrev-ref HEAD`
2. If on a protected branch (`main`, `master`, `development`, `dev`, `production`), create a feature branch first.
3. If a feature branch already exists for this session, reuse it. Do not create siblings.
4. Submodule edits follow the same rule for the submodule's own branch.

## Batch permission for multi-file edit sweeps

Present the full plan at the start of a multi-file edit pass (which files, what changes, why). Ask once. Execute in a batch. Only interrupt mid-stream when something genuinely surprising surfaces that changes the plan.

---

## Commit discipline

**Format:** `<type>: <imperative subject>`
- Types: `feat` / `fix` / `chore` / `refactor` / `docs`
- Body: explains *why*, not *what*. One paragraph, optional.
- Footer: always `Co-Authored-By: Claude <model> <noreply@anthropic.com>`

**Auto-commit hook** (`auto-commit.sh`, Stop event, async):
- Fires at end of Claude's turn on feature branches only
- Skips if last commit was within 1800s (debounce)
- Skips if more than 10 files are modified (signals active multi-step work)
- Ahmed can always trigger `/commit` manually

**Never:**
- Amend a published commit
- Commit files with secrets (`.env`, credentials) — warn Ahmed if asked
- Use `--no-verify` to bypass pre-commit hooks

---

## Post-merge workflow

Two skills, two scopes:

**`/github-cleanup`** — fires per merged PR
- Syncs `main` (`--ff-only`)
- Deletes the merged feature branch locally
- Never deletes protected branches
- Triggered by: "merged, clean up" / "PR merged, sync main" / similar
- May fire multiple times in a session (once per merged PR)

**`/wrap-session`** — fires once at session end
- Stops dev servers Claude started during the session
- Produces reflective recap: skills, hooks, docs, decisions to add/change
- Triggered by: "wrap up the session" / "we're done for today"

If ambiguous (per-PR cleanup vs. full wrap?), ask one clarifier before proceeding.

---

## Submodule workflow

Changes to a submodule require **two PRs**:

1. **Inside the submodule:** feature branch → commit → push → PR → Ahmed merges
2. **In the workspace:** update submodule pointer in a workspace feature branch → PR → Ahmed merges

The workspace bump closes the loop. Never leave submodule pointers uncommitted after a submodule PR merges.

**Submodule pointer drift** (currently manual): the SessionStart hook pulls `main` on base branches but does not check submodule pointer alignment. Detected opportunistically via `git status`.

---

## Hooks — enforcement layer

| Hook | Event | What it does |
|---|---|---|
| `session-start.sh` | SessionStart (async) | Pulls `main`/`development` if session opens on a base branch |
| `block-protected-push.sh` | PreToolUse (Bash) | Blocks protected-branch push, force-push, and deletion |
| `enforce-feature-branch.sh` | PreToolUse (Edit/Write/NotebookEdit) | Blocks edits when on a protected branch |
| `auto-commit.sh` | Stop (async) | Auto-commits + pushes; debounced; feature branches only |
| `post-edit-typecheck.sh` | PostToolUse (Edit/Write on .ts/.astro) | Runs `astro check` / `tsc --noEmit` in background |
| `parallel-by-default-reminder.sh` | UserPromptSubmit | Reminds Claude to parallelize independent tool calls |
| `gtm-nudge.sh` | Stop (async) | Periodic nudge to capture GTM signal via `/gtm-sync` |

Hooks are enforcement, not advisory. CLAUDE.md rules are advisory. If they conflict, the hook wins.

---

## Skills — GitHub-adjacent

| Skill | Trigger | What it does |
|---|---|---|
| `/commit` | Manual or Stop hook | Stage, commit, push to current feature branch |
| `/pr` | Manual | Verify branch, push if needed, construct PR URL, draft title/body, auto-open |
| `/github-cleanup` | "merged, clean up" | Sync main, delete feature branch |
| `/wrap-session` | Session end | Stop dev servers + reflective recap |
| `/check-leaks --docs` | Before PR touching stable docs | Sweeps for transient references in stable docs; `--cards` variant checks broken paths after renames |
| `/arch-review` | New module / API / structural change | Reviews against architectural principles |

---

## npm security — pre-push gate

Each npm-capable submodule has a `pre-push` hook running `npm audit --audit-level=high`. The workspace root also runs `.claude/git-hooks/pre-push` which audits every submodule before a pointer bump.

**Fix path for vulnerabilities:** `npm audit fix` → `npm overrides` → major upgrade → documented advisory acceptance in the project's ADR. `--no-verify` is forbidden.

---

## Limitations and open questions

1. **No branch protection at GitHub level.** Protection is purely local (hooks). A collaborator or Ahmed pushing directly from the GitHub UI bypasses everything. Enabling GitHub branch protection rules on `main` for each repo would add a safety net — currently not configured.

2. **PR description has no enforced template.** The `/pr` skill drafts title + body, but format is AI-generated per session. A `PULL_REQUEST_TEMPLATE.md` in each repo would standardize this and survive non-Claude PRs.

3. **Submodule pointer drift is manual.** A planned SessionStart hook for auto-detecting submodule pointer drift was canceled on 2026-05-01. Currently relies on opportunistic `git status` observation. Drift silently accumulates between merges.

4. **No automated PR ↔ Linear card linking.** Branch names follow the `omraneah/bor-<N>-...` convention, which Linear's GitHub integration could auto-link — but the integration is not configured. Card updates are manual comments from Claude.

5. **HTTPS/SSH hybrid requires one-time laptop config.** The `url."git@github.com:".insteadOf` rewrite is documented but not enforced by `setup.sh`. A new laptop cloning the repo would use HTTPS natively (which works) but would need the rewrite for SSH-key-based workflow. `setup.sh` could add this check.

6. **Auto-commit debounce is time-based only.** The 1800s debounce prevents double-commits but doesn't account for intent — e.g., a checkpoint mid-session may not be a meaningful unit. No semantic commit-readiness signal exists beyond the file-count threshold (>10 files skips).
