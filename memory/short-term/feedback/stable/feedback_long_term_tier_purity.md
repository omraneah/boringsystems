---
name: Long-term tier purity — timeless content only
description: Long-term memory (memory/long-term/) holds only what is true over years. Never embed transient references — date markers, current company / specific event references, phase-bound pricing, "recent" / "currently" framings. Every sentence must hold in 2+ years. Caught manually after Anchored-Stance.md shipped with current-company + friend-mortality + 2026 French market specifics that needed to be stripped.
type: feedback
---

Long-term memory (`memory/long-term/`) is the north star — identity profile, distilled inner-game doctrine, life-level constitutional content. It is auto-loaded every session and weighted highest in routing. Polluting it with transient content corrupts the tier's reliability, because future-Ahmed reading the file in 1-2 years should find the same shape that holds today.

**Why:** This was violated when Anchored-Stance.md first shipped with references to "current company misalignment," a specific friend's death at 37, French market pricing thresholds (60-90k / 100-130k / 150k+), and "6-12 months post-trauma" date-bound psychology framing. Ahmed flagged it sharply: long-term tier holds only what is true over years; transient or context-bound content belongs in medium-term (current phase) or short-term (episodic record), not in identity-level doctrine.

**How to apply:**

- **Before any write to `memory/long-term/**.md`, run the year-test**: every sentence must be as true 2 years from now as it is today.
- **Forbidden in long-term content:**
  - Date markers (specific years, "last week", "this month", "recently", "currently", "right now", "the past N years")
  - Specific company / project / person names from the current phase (the "current company," "the friend who died," "my current founder")
  - Phase-bound pricing or market specifics (any country/year-specific numerical anchors)
  - Date-bound psychology arcs (specific recovery timelines, "6-12 months post-X")
  - Codification dates in the body (frontmatter `last_reviewed:` field is fine for audit; body content should not date itself)
- **Allowed in long-term content:**
  - Generalized categories (e.g. "a misaligned engagement" instead of "the current company")
  - Generalized event types (e.g. "felt contact with capture cost (health, time, mortality)" instead of "after my friend died at 37")
  - Abstract pattern names (e.g. "period of post-disruption clarity" instead of "6-12 months post-trauma")
  - Cross-references to other doctrine files (those can carry the specifics that belong in their own tier)
- **Specifics belong elsewhere:**
  - Phase-specific data points → medium-term (e.g. `Engagement-Shapes.md`, `Pull-Mode-Strategy.md`, `current-arc.md`)
  - Episodic events, daily decisions → short-term (e.g. `memory/short-term/<week>/<date>.md`)
  - Audit dates / codification metadata → frontmatter, not body content
- **The test:** if a 2028 reader would say "wait, what current company?" or "what 2026 pricing?" — the content is in the wrong tier. Move or generalize.
- **At commit time:** the pre-commit hook `.claude/git-hooks/pre-commit` lints staged `memory/long-term/**.md` files for date markers and transient phrases. If it flags, the content needs generalization or relocation to a lower tier before commit. `--no-verify` forbidden per workspace policy.

**Companion rule:** [[feedback_no_short_term_state_in_medium_term_docs]] applies the same principle one tier down — medium-term holds rules and structures that outlive a single session/sprint but may be phase-bound; short-term carries the live episodic state.
