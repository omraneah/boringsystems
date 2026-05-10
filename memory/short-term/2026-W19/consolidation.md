# Consolidation — Week 2026-W19 (consolidating 2026-W18)

*Created Sunday 2026-05-10.*

W18 was high-volume and high-altitude: tiered-memory restructure landed (long-term→I-AM + Path-Doctrine + Relational-Architecture as North Star), three-horizon scaffolding deployed, persona model deepened (Camille, P1/P2 routing), domain decision settled, GTM revoice + Enakl scrub, auth articles shipped, Mixpanel + BOR-40 implemented, project-management SOPs, structural hygiene, harness audit (BOR-46) spec'd, laptop-agnostic harness pass. ~12 PRs, ~15 cards touched.

W19 to date (05-05, 05-06, 05-10) thinner — wrap-session ergonomics, impeccable skill audit + distillation, and today's harness edge-thesis research (Sofia + AutoDream/Tropic identification).

## My consolidation

### Promotions proposed (short → medium)

- **Pre-funnel aesthetic filter principle.** Currently lives in `go-to-market/website.md` § Pre-funnel filter. Generalizes beyond the domain decision — it's a portable rule (filter on register before funnel, on thesis inside funnel) that applies to LinkedIn header, conference bios, podcast titles, any cold-stranger touchpoint. Promote to `memory/medium-term/market/` as a standalone file. Rationale: it's named, validated, generative; the go-to-market doc is too narrow a home.

- **"Park craft, do market reconnaissance, ship micro-fix" judgment pattern.** Logged 05-01 obs #12. Compounded well during the LinkedIn-vs-site Camille session (parked craft work, did light WebSearch, made one ~5-min fix). It's a meta-skill about when to escalate research vs. commit. Promote to `memory/medium-term/operational-doctrine/` (small file, possibly a section in `Work-Hygiene-Doctrine.md`).

### Promotions proposed (medium → long)

None this week. The long-term tier consolidated heavily during W18 itself (I-AM enrichment, Path-Doctrine, Relational-Architecture) — letting it settle is the right move.

### Demotions proposed

None.

### Drift flags

- **Tier:** short-term feedback / live conversation. **Memory said:** "less is more on skills" is the operator's discipline (implicit across many feedback files). **Live signal (today's research):** operator is at 22 skills + 13 agents + 8 hooks — inside Anthropic's silent-truncation watch zone (15–25 skills before descriptions drop, per v2.1.129). Yubi's "10 keeper" benchmark, ~4–6 redundant skills (`hygiene-review` / `session-pulse` / `signal-recap` / `wrap-session` all session-end-shaped). **Suggested action:** keep the principle, surface the inventory gap. Harness audit (BOR-46, Urgent / Todo since 05-03) is the right home. Bump priority — today's research validates the urgency.

- **Tier:** medium-term market positioning. **Memory said:** boringsystems and `AI-Native-Builder-Positioning.md` lean implicitly on "harness sophistication as evidence of competence." **Live signal (today's Sofia research):** the artifact decays as a positioning claim on a 6–12 month tempo (Anthropic climbing, marketplaces commoditizing). The defensible frame is one tier up: *"crystallized senior-engineering judgment ported into AI-native operating discipline; the harness is exhibit A, the doctrine is the argument."* **Suggested action:** keep; flag for revoicing pass on `AI-Native-Builder-Positioning.md` and any boringsystems hero copy that leans harness-first. Don't act yet — let the frame settle 1–2 weeks before propagating. New work should adopt the doctrine-first frame; existing docs await revoice.

- **Tier:** stable docs. **Memory said:** stable docs reference only stable concepts (per `/check-stable-docs-leaks` rule). **Live signal:** `docs/adr-004-tiered-memory-architecture.md:16` still references `BOR-24` (caught by hygiene-review 05-03, pre-existing). **Suggested action:** clean up in next stable-docs hygiene pass; not blocking.

### Deletions proposed

None. (W18's deprecated medium-term audit folder was already deleted during the restructure.)

### Current-arc update proposed

Two small additions worth considering for `medium-term/current-arc.md`:

- **Add a "harness vs. doctrine" line** under "What re-stabilize means concretely" or in a new sub-bullet: harness is evidence, doctrine is the argument; the published artifact (essay or case file making the operating mode legible on boringsystems) compounds harder than refining the harness itself. Anchors today's research insight as a phase-shaping principle rather than letting it float.
- **Bump harness audit (BOR-46) visibility.** The current arc lists "deep market analysis continuing" + "reactivation continuing" + "boringsystems publishing continuing" — but harness curation is now overdue and load-bearing for cognition. Worth one line acknowledging the audit as a current-phase task, not a backlog item.

Both light edits; neither rewrites the doctrine. Hold for your call.

### Cross-cutting patterns I'd flag without proposing action

- **Twice-is-a-pattern: "verify before claiming done."** Surfaced 05-01 (Enakl scrub leak) + 05-03 (BOR-40 process gaps + 3+ correction rounds). Operator-visible. The `/declare-ready` skill exists — is it being used? Gap may be invocation discipline more than missing tool.
- **Twice-is-a-pattern: "premature closure under uncertainty."** 1M-context confabulation (04-30) → "questions are noise" pre-verdict (04-30) → Q-A shape commitment (04-30) → PostHog over-push (05-01) → tool-comparison-as-decoration (05-01). Five instances in 48h. Has not been codified as a feedback rule. Borderline candidate; flagging not promoting.
- **Adversarial cut from today's research:** the harness can wear the costume of work. Yubi's "productive procrastination" is pointed at extended skill-building / memory-restructuring sessions when the actual compounding work is publishing + meeting people + signing engagements. Worth carrying as a periodic gut-check question, not a rule.

## Your decisions

- Pre-funnel aesthetic filter → **promoted** to `memory/medium-term/market/pre-funnel-filter.md`.
- Park-craft-under-unstable-assumptions → **promoted** as § 8 in `memory/medium-term/operational-doctrine/Work-Hygiene-Doctrine.md`.
- BOR-24 leak in `docs/adr-004-tiered-memory-architecture.md:16` → **cleaned** (replaced with generic "deferred backlog items").
- Current-arc.md → **updated** (harness-vs-doctrine frame under boringsystems bullet + harness governance as current-phase task).
- "Verify before claiming done" → **codified** as `memory/short-term/feedback/stable/feedback_verify_before_claiming_done.md`.
- Positioning revoice on `AI-Native-Builder-Positioning.md` → **held**. Let frame settle before propagating.
- Premature closure pattern → **held**. Flagging only, not promoting to feedback rule.

## Actions taken

- Created `memory/medium-term/market/pre-funnel-filter.md`.
- Added § 8 (Park-Craft-Under-Unstable-Assumptions) to `Work-Hygiene-Doctrine.md`.
- Fixed BOR-24 reference in `docs/adr-004-tiered-memory-architecture.md:16`.
- Updated `memory/medium-term/current-arc.md` — two lines added under boringsystems/harness bullets.
- Created `memory/short-term/feedback/stable/feedback_verify_before_claiming_done.md`.
