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
- [Twice-Is-A-Pattern Rule](feedback_twice_is_a_pattern.md) — Same manual task twice in a session → codify before the third. Prevents pattern-codification lag.
- [Max Three Concerns Per Session](feedback_scope_discipline.md) — Wide-scope sessions degrade quality; split into branches when a 4th concern appears.
- [Platform Features First](feedback_platform_features_first.md) — Check framework native support before reimplementing i18n/auth/routing/caching/redirects. Custom reimplementation is a recurring failure mode.
- [Audit-Fix Isolation](feedback_audit_fix_isolation.md) — npm audit work lives in its own PR, never bundled with structural/feature changes. Rollback + reviewer triage reasons.
- [Planning Snapshot Before Flags](feedback_planning_snapshot_before_flags.md) — Every pre-publish review skill opens with an inferred-intent statement (placement + audience + one-sentence read + up-front verdicts) before the flag list. Catches miscalls fast.
