# Website — boringsystems.app as Surface

**Status:** active surface, tactic doc.
**Last updated:** 2026-05-01.
**Strategic-altitude reference:** `strategy.md` § Surface 2 (boringsystems.app).

---

## What this doc is

The operational tactic for the website surface — how `boringsystems.app` talks, where it sits in the funnel, what it does and doesn't, and the conditions under which the surface itself would change. Strategic framing lives in `strategy.md`; this is one layer below.

## Current state (2026-05-01)

- **Domain:** `boringsystems.app`. Astro 5 on Vercel.
- **Three lanes** (per `boringsystems/docs/target-audiences.md` § Lane placement):
  - **Writing** — thinking pieces, decision guides, frameworks. Default lane.
  - **Work** — case files from real past engagements.
  - **Building** — live commentary on current builds (boringsystems itself, portfolio apps, AI-agent orchestration).
- **Two voice personas** (per `boringsystems/docs/target-audiences.md`):
  - **P1 `technical`** — senior engineering peers (CTO, VP Eng, Staff). Reputation currency. Refers, doesn't convert directly.
  - **P2 `builder`** — entrepreneurs, intrapreneurs, business operators. Decision-makers without daily code. Conversion path lives here.
- **Voice target is per-piece**, not per-lane. A Building-lane piece can address P1 or P2; a Writing-lane piece can address P1 or P2.
- **Companion surface:** `portfolio.boringsystems.app` — apps shipped end-to-end. Currently unlinked from main nav by design. Gated-by-knowledge.

## What the site does — and doesn't

**Does:**

- Carries Ahmed's writing, case files, and building work.
- **Default rhythm: writing paired with building.** When a build produces real material, a writing piece accompanies it. The build is the proof; the writing is the lens.
- **Solo writing happens too.** When something is alive in the head — a frame, a tension, a concept worth externalizing — it gets published without a build. The driver is curiosity, not cadence. Curiosity → externalize → share.
- Lives as evidence that the AI-native operating method works in 2026.
- Bilingual EN/FR. FR = re-voiced, not translated. Per `boringsystems/docs/french-guide.md`.

**Doesn't:**

- Newsletter. No subscribe popups. No mailing list capture beyond the current lead-magnet system.
- Audience-building cadence — no calendar pressure, no commit-to-publish rhythm. Heat-led, per `memory/medium-term/market/Visibility-OS.md` § 7.
- Performative content — no "future of X," no hot takes, no manifestos.
- Sales surface for offers. The "How to work with me" engagement-shapes page (in flight per `strategy.md`) is a separate internal-linked surface, not part of this tactic doc's scope.

## The funnel — distilled

Five stages. Schwartz awareness levels (1–5: unaware → most aware) sit *inside* each stage as the reader's psychological state at the moment of encounter.

1. **Awareness** — does the reader know I exist?
2. **Interest** — do they click?
3. **Consideration** — do they keep reading once they're on the site?
4. **Conversion** — do they reach out?
5. **Retention / Advocacy** — do they come back, refer, or share?

**Pre-funnel** sits *before* stage 1 — the aesthetic register of the surface itself, which filters who even enters Awareness.

## How `boringsystems.app` talks at each stage

- **Pre-funnel.** The name carries a register filter. "Boring" reads as anti-hype to the right reader and as strange/skip to the wrong one. Wrong reader leaves before consuming bandwidth — structurally cheap. Right reader has already self-identified.
- **Awareness.** Memorable, low-cost-to-process. Single-word handle ("boringsystems") survives the noisy LinkedIn / search-result environment.
- **Interest.** The click-or-bounce moment. Currently filters more aggressively than calmer alternatives would — by design. This is where pre-funnel-filter compounds.
- **Consideration.** The first screen does the work — hero copy ("systems that scale, judgment that holds") plus case-file format converts "boring" from strange to deliberate within ~6 seconds. Once the reader is on the site, the name's strangeness collapses into coherence.
- **Conversion.** Currently lossy. The "How to work with me" engagement-shapes page is the missing artifact (tracked in `strategy.md`). Without it, a P2 builder reaching conversion-readiness has no clear next step.
- **Retention / Advocacy.** Strongest with P1 technical peers — they refer Ahmed into rooms he didn't apply to. P2 builders convert directly more than they refer.

## Pre-funnel aesthetic filter — the principle

Filtering on **register** (texture, voice, surface-feel) is structurally different from filtering on **thesis** (a divisive claim in the copy).

- **Register filter** sits *before* the funnel. Wrong fit doesn't enter. No bandwidth spent.
- **Thesis filter** sits *inside* the funnel. Wrong fit enters, consumes attention, then bounces — usually after warmth has already done some work.

Register filter is cheaper. Thesis filter is more useful at the bottom of the funnel, where the right reader needs to feel the edge before committing. The two principles are not in tension — they fire at different layers.

**Where this principle applies beyond the domain:**

- LinkedIn headline — the first 7 words act as register filter.
- Conference / event bios — same role.
- Podcast appearance descriptions, interview title cards.
- Article titles operate inside the funnel already; register and thesis blend there.

The principle generalizes: **at every cold-stranger touchpoint, prefer aesthetic filtering to argumentative filtering.**

## The rename consideration (compressed)

In late April 2026 the surface name was reconsidered. Candidates were `slowcraft.app` and `calmcraft.app`. After analysis through the copy-craftsperson agent (Camille Brodeur), the decision was to keep `boringsystems.app`. Three reasons carried the verdict:

1. **Counterweight.** The rest of the system (calm, anchored, sovereign, resonance-not-persuasion) is uniformly warm. "Boring" is the only un-warm word — the structural edge that lets the right reader push against something at the bottom of the funnel.
2. **Archetype-fit.** "Boringsystems" flags the new operator-archetype the market is just learning to price (compresses execution with AI, refuses theatre). "Calmcraft" flags an older artisan-consultant archetype — saturated, undifferentiated.
3. **Pre-funnel-filter.** Boring's strangeness *is* the filter. Calmer alternatives would widen Interest at the cost of softer pre-filtering — pushing wrong-fit readers into bandwidth-consuming bounces deeper in the funnel.

Decision logged separately in `decisions/`. Revisit conditions below.

## Secondary-domain experiment — trigger conditions

A second domain (e.g. `omrane.work`, `ahmedomrane.com`) could 301 to the same Astro site and serve cold-stranger-heavy contexts where pre-funnel-filter cost grows. **Defer until trigger.**

**What the secondary domain would do:**

- Used in cold-stranger surfaces only — LinkedIn bio link, conference badges, AI-citation surface, podcast appearances.
- Redirects to the same canonical `boringsystems.app` content. No content duplication. No SEO split.
- Ahmed-name surface for cold strangers who haven't yet been calibrated to the boringsystems register.

**What it would NOT do:**

- Split brand identity. `boringsystems.app` stays canonical.
- Replace boringsystems for warm-graph reads or in-conversation lookups.
- Carry its own content. It's a routing surface, not an additional publication.

**Trigger conditions (revisit when ANY holds):**

- LinkedIn organic impressions on Ahmed's posts cross a felt-threshold of "reach is real now" — record the threshold once it crosses, don't pre-commit a number.
- Analytics show non-zero AI-citation traffic (Claude / ChatGPT / Perplexity referrals, identifiable via referrer or anomalous direct-traffic spikes).
- Two or more cold-stranger conversations independently report "I almost didn't click" or equivalent self-reported pre-funnel friction.
- Distribution shifts from verification-heavy (warm-graph lookup) to cold-stranger-heavy (broadcast finds him before he finds them).

**Not a trigger:** intuition that "it might be helpful," desire to optimize, finding a clever short URL. Wait for signal.

## Things to revisit later

- **Crossover point.** Pre-funnel filter cost is currently low because volume is verification-heavy. As cold-stranger flow grows, the filter cost grows linearly. Crossover unknown; watch.
- **The rename revisit.** Don't relitigate for 6 months minimum. If revisited, run the same seven-axis frame; don't re-decide on intuition.
- **LinkedIn CTR tracking.** Loose, not rigorous A/B — note relative CTR on the strongest pieces monthly. Structurally low CTR compared to peer operators is pre-funnel-friction signal.
- **The "How to work with me" engagement-shapes page.** Conversion-stage gap. Tracked in `strategy.md` § Surface 2 + § May focus points. When shipped, conversion-stage performance should improve — track.
- **Lead-magnet conversion rates.** Currently live on one piece. Worth reviewing once 2-3 more pieces have it wired in.
- **AI-discoverability (AEO) consolidation.** Plan in flight. Compounds under `boringsystems.app` (now decided canonical). Revisit after first ~3 months of consolidation work.
- **Voice-personas + reader-tag dimension** (BOR-20 in Linear) — currently deferred-by-design. If inbound clusters force the question, revisit.

## Cross-references

- Strategic frame for this surface: `strategy.md` § Surface 2.
- Voice personas + lane placement: `boringsystems/docs/target-audiences.md`.
- French voice rules: `boringsystems/docs/french-guide.md`.
- Site design charter: `boringsystems/docs/design-charter.md`.
- Heat-led publishing cadence: `memory/medium-term/market/Visibility-OS.md` § 7.
- Long-term being layer: `memory/long-term/I-AM.md`.
