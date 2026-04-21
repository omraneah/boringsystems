# MEMORY INDEX

- [Ahmed Omrane — Profile](user_profile.md) — Who Ahmed is, his background, capabilities, and operating context in France 2026
- [Collaboration Preferences](feedback_collaboration.md) — Tone, code style, what to avoid: terse, no summaries, surgical changes only
- [Workspace Structure & Project Map](project_workspace_structure.md) — Folder-by-folder breakdown of `/Users/ahmedomrane/Workspace/` with access rules and tech stacks
- [Ahmed — Strategic Context 2026](user_strategic_context.md) — Transition phase, positioning philosophy, French market specifics, work hygiene doctrine
- [Context Inheritance Architecture](feedback_context_architecture.md) — How context flows across workspace/submodules; revisit triggers documented
- [Laptop-Agnostic Architecture Principle](feedback_laptop_agnostic.md) — Highest-priority constraint: everything must survive fresh-machine clone + documented setup. No local-only state.
- [Cloud-Connector-Only Tool Auth](feedback_mcp_connectors.md) — Never suggest `gh auth login`, manual MCP keys, or any token flow. GitHub/Linear/Gmail/etc. always via claude.ai connectors.
- [PR Creation Division of Labor](feedback_pr_creation.md) — Claude pushes branches + announces the PR URL. Ahmed opens the PR himself. Never `gh pr create` or `mcp__github__create_pull_request`.
- [Article Capture Behavior](feedback_article_capture.md) — Proactively suggest `/article-capture` when a conversation produces deep technical + business model insight worth publishing on boringsystems
- [Wrap-Session Auto-Trigger](feedback_wrap_session.md) — When Ahmed signals a merged PR, auto-invoke `/wrap-session` — git sync + reflective recap + improvement proposals
- [Infrastructure-First Pattern](feedback_infrastructure_first.md) — Build typed registries/helpers/plugins before the content that uses them, when reuse is likely
- [boringsystems Lead-Magnet Status](project_boringsystems_lead_magnet.md) — Capture pipeline live; first asset (Starter Prompt) unfinalised, tracked in Linear BOR-16
