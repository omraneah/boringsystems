---
name: Parallel-By-Default for Non-Conflicting Tasks
description: When Ahmed gives a multi-task instruction, classify each task and run independent ones in parallel — multiple Agent calls + Bash calls + Write calls in a single message. Worktrees only when Ahmed explicitly asks for conflict isolation.
type: feedback
originSessionId: de7cfa88-4bce-4436-923d-8a9b70f52fa4
---
When Ahmed gives instructions that contain multiple distinct tasks, default to parallelizing every task that doesn't conflict with another. Multi-step instructions are not requests for sequential execution — they are requests for the work to be done. The agent picks the execution shape.

**Why:** Sequential execution wastes wall-clock time on independent work. Most multi-task asks (create a Linear card + run an advisor + edit some files) have zero conflict surface. Doing them serially is operator-time waste. 2026-04-25 session: Ahmed had to explicitly ask for parallelization on a multi-task prompt; he wants the default flipped permanently.

**How to apply:**

1. **Classify each task in the prompt:**
   - **Independent** — no shared file, no shared state, no dependency on another task's output. Default: PARALLEL via Agent or tool calls in a single message.
   - **Sequential dependency** — task B reads task A's output (e.g. bump submodule pointer needs the post-merge SHA from task A). Run sequentially, no choice.
   - **Conflicting** — both edit the same file or shared state. Run sequentially in main thread. Worktree only if Ahmed explicitly asks for isolation; default = sequential same-tree.

2. **Multiple tool calls in the SAME message run in parallel.** Use aggressively. A single message can contain N Agent calls, M Bash calls, K Write calls — all execute concurrently if they don't conflict.

3. **Subagents are the unit of parallel cognitive work.** Independent reasoning streams (Singer on one question + general-purpose for a Linear card + Naomi reviewing positioning) all fire in one message. Each one is a separate context. Output returns when each completes; main thread continues other work in between.

4. **Worktrees are for the conflict case ONLY.** Default execution = same working tree, same branch, parallel tool calls + Agent invocations. If two tasks edit the same file, run them sequentially (not in worktrees) unless Ahmed explicitly says "use worktrees" or "isolate."

5. **Confirm execution shape briefly in the response** ("firing X in parallel with Y while doing Z") so Ahmed sees the choice and can correct if wrong.

**Hard rule:** Ahmed does not need to ask for parallelization. If he wants serial execution or worktrees for conflict isolation, he will say so. Default is parallel-with-shared-tree.

**Hook reinforcement:** `.claude/hooks/parallel-by-default-reminder.sh` (UserPromptSubmit) injects a one-line reminder when a multi-task prompt is detected. Heuristic — fires only on prompts with 2+ multi-task signals (numbered lists, "and then", "also", "in parallel", "simultaneously", etc.). Quiet on single-task prompts.

**Provenance:** 2026-04-25 session. Ahmed: *"Anything that you can paralyze, paralyze. This is, by the way, by default; you can add it. Anything that could be paralyze should be paralyze without the need for three work trees... Whenever I tell you something, you should be able to split it down into non-competing and non-conflicting tasks. For now, I will only be if there is the need to have work days and work on different things but with conflict that I will dictate it; you don't need to manage this."*
