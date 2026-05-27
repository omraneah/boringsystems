---
name: github-cleanup
description: Per-PR post-merge GitHub branch cleanup. Sync main, delete the merged feature branch. Triggered when Ahmed says some variant of "github cleanup", "merged github, cleanup", "merged, clean up", "I merged the PR, clean up", "PR merged on main", "PR merged, sync main", "go to main and delete the branch" — anything that signals a single GitHub PR has just been merged. May fire multiple times in a session (one per merged PR). Companion skill `/tmp-cleanup` exists for clearing the `tmp/` render buffer — different surface, same shape. Does NOT produce a recap and does NOT stop dev servers — those are end-of-session concerns handled by `/wrap-session`.
model: sonnet
effort: medium
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(git *)
---

Per-PR git cleanup for GitHub PRs. Runs after Ahmed has merged a single PR on GitHub. Fast, mechanical, no narration.

Do not announce the skill invocation. Just do the work.

## Companion skills

- **`/tmp-cleanup`** — wipes the `tmp/` render buffer on operator demand. Different surface (filesystem, not git), same shape (explicit operator request → mechanical action → one-line confirmation).
- **`/wrap-session`** — end-of-session reflection. Stops dev servers, produces session recap. Don't conflate with per-PR cleanup.

## When to invoke

Auto-fire when Ahmed signals a single GitHub PR has been merged:

- "github cleanup"
- "merged github, cleanup"
- "merged, clean up"
- "I merged the PR, clean up"
- "PR merged, sync main"
- "go to main and delete the branch"
- "merged on main, cleanup"
- Any phrasing that names a GitHub merge event and asks for cleanup

The historical short-form triggers ("merged, clean up", etc.) still route here — muscle memory preserved.

Do **not** invoke for:

- End-of-session signals ("wrap up the session", "we're done") — that's `/wrap-session`.
- "tmp cleanup", "wipe tmp", "clear tmp" — that's `/tmp-cleanup`.
- Merges that haven't actually happened yet (Ahmed says "I'm about to merge") — wait until he confirms.

If the signal is ambiguous (could be either skill), ask one one-line clarifier: "cleanup the merged branch only, or full session wrap?"

## Steps

Operate in the current working directory. If the merged PR was in a submodule and Ahmed is in the submodule, do the cleanup there. If he's in the workspace root, do it in the workspace.

1. **Identify the feature branch.** `git branch --show-current`. If it's a protected branch (`main`, `master`, `development`, `dev`, `production`), stop — nothing to clean up. Tell Ahmed and ask which branch he meant.
2. **Check it's actually merged.** `git fetch origin main` then `git log HEAD..origin/main --oneline | grep <branch>` — the merge commit should reference the feature branch. If you cannot verify the merge, stop and ask Ahmed. Never delete a branch you cannot verify was merged.
3. **Switch and sync.** `git checkout main && git pull --ff-only`. Fast-forward only — if main has diverged locally, fail loudly. Local main should never have commits ahead of origin (Ahmed never commits to main).
4. **Delete the feature branch locally.** `git branch -d <branch>`. If `-d` refuses, the branch is not fully merged — report and stop.
5. **Confirm clean state.** `git status -s` should be empty; `git branch --show-current` should be `main`.

## Output shape

One short confirmation. Three lines max. Example:

```
Synced main. Deleted omraneah/bor-24-skills-frontmatter-audit (merge commit abc1234). Clean.
```

No recap. No improvement proposals. No narration of intermediate steps. If anything failed mid-flow, surface the exact failure and stop.

## Guardrails

- **Default cleanup is local.** Remote deletion is not part of `/github-cleanup` unless Ahmed explicitly asks for it.
- **Never delete protected branches.** Local or remote.
- **Never push to main.** This skill is read-only from the network's perspective on main.
- **Never fabricate verification.** If `git log HEAD..origin/main` does not show the merge, stop and ask.
- **Single-PR scope.** Don't try to clean up multiple branches in one invocation. If Ahmed has merged two PRs and wants both cleaned, run twice.
- **Don't stop dev servers.** Those persist across PRs within a session — `/wrap-session` handles them at session end.
- **Don't touch `tmp/`.** That's `/tmp-cleanup`'s job. Different surface entirely.
