---
name: wrap-session trigger
description: When Ahmed signals a merged PR with natural-language cleanup requests, auto-invoke the wrap-session skill — git sync + reflective recap + improvement proposals.
type: feedback
originSessionId: e464aaed-a5a0-4c1c-ac8b-19b9dd83adf6
---
When Ahmed signals a PR has been merged — phrases like "merged, pull and delete", "I merged it, clean up", "go to main and delete the branch", "we're done, wrap this up", "pull the changes and delete the feature branch" — invoke the `/wrap-session` skill automatically. Do not wait for him to type the command.

**Why:** Ahmed explicitly asked for this in session 2026-04-21. He wants the post-merge cleanup + reflective recap + improvement proposals to fire reliably without him having to remember a skill name. The recap is where system-level improvements (skills, hooks, ADRs, memory, decisions) get proposed and compounded — skipping it means the session's lessons evaporate.

**How to apply:** On detecting the signal language, run the skill. If the signal is ambiguous ("I'm done" without a merge context), ask a one-line clarifier before firing. If the session spanned multiple repos (workspace + submodules), apply git mechanics in each one independently before producing the recap. Never fabricate improvements to pad the recap — if the session was small, produce a small recap.
