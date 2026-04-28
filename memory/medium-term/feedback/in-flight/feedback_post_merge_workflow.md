---
name: post-merge workflow — split between /github-cleanup and /wrap-session
description: Two distinct skills for post-merge work. /github-cleanup runs once per merged GitHub PR (git mechanics only). /wrap-session runs once at session end (dev-server stop + reflective recap). Auto-invoke on the right trigger phrases.
type: feedback
---

A single session can ship multiple PRs. Post-merge work splits cleanly into two scopes:

- **Per-PR scope — `/github-cleanup`.** Runs immediately after Ahmed signals a single PR has been merged on GitHub. Sync main (`--ff-only`), delete the merged feature branch (`-d`, never `-D`). May fire multiple times in a session — once per merged PR. No recap, no dev-server cleanup. (Renamed from `/cleanup` 2026-04-28 when `/tmp-cleanup` was added; historical "merged, clean up" triggers still route here.)
- **Session scope — `/wrap-session`.** Runs once at end of session, after all per-PR cleanups have already happened. Stops dev servers Claude started during the session, then produces the reflective recap with proposed system improvements (skills, hooks, docs, ADRs, memory, decisions).

**Why:** Before this split (codified 2026-04-26), `/wrap-session` did both jobs in one shot. That worked when sessions shipped one PR. With multi-PR sessions, conflating them means either (a) running the heavy recap after every merge — wasted reflection budget — or (b) deferring all cleanup to session end — which leaves stale feature branches checked out across multiple PRs and breaks the "always on main between chunks" hygiene Ahmed prefers. Split clearly: mechanics per-PR, reflection per-session.

**How to apply:**

Auto-invoke `/github-cleanup` on per-PR signals:

- "merged, clean up" / "I merged the PR, clean up"
- "PR merged on main" / "go to main and delete the branch"
- "merged, sync main" / any phrasing that names a single merge event and asks for cleanup

Auto-invoke `/wrap-session` on end-of-session signals:

- "wrap up the session" / "we're done for today"
- "end of session" / "wrap this up"

If a signal is ambiguous (could plausibly be either), ask one one-line clarifier: *"cleanup the merged branch only, or full session wrap?"* Do not guess.

The recap is where system-level improvements get compounded — never skip it on a real wrap-session, and never fabricate improvements to pad a thin one. If the session was small, the recap is small.

If a session spanned multiple repos (workspace + submodules), `/github-cleanup` operates in whichever cwd Ahmed is in when he gives the signal. Run it once per repo where a merge happened.
