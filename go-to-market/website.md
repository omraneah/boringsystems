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

## Persona model — two channels, two intents

Two reader-personas live on the same site. **They do not share a funnel.**

**P1 — peers** (senior engineers, technical operators).

- *Intent:* community channel. They come to read, recognize quality, refer Ahmed to others.
- *What they pay in:* trust and reach. Not revenue.
- *Voice:* technical depth, restraint, no ask. **No CTAs on P1 surfaces.**
- *Profile detail:* `boringsystems/docs/target-audiences.md` § P1 `technical`.

**P2 — buyers** (founder-operators, sponsors, advisors with execution problems).

- *Intent:* conversion channel. They come to decide whether Ahmed can solve a problem keeping them up at night.
- *What they pay in:* revenue.
- *Voice:* capability-led, calm, sovereign, anchored. They need to recognize themselves first, then see a door.
- *Profile detail:* `boringsystems/docs/target-audiences.md` § P2 `builder`.

**Voice-target-per-piece rule.** Every piece of copy is written to one persona, not both. Lane-independent — a Building-lane piece can address P1 or P2; per-piece calibration. Cross-referenced from `boringsystems/docs/target-audiences.md` § Cross-voice rules; formalized here as load-bearing for this channel.

### Current phase: scaffolding, not converting

The site is being built; voice and rhythm come first. P2 conversion funnel ships later — when voice has stabilized on LinkedIn and warm-intro volume justifies a real close.

Until then:

- **Cold-stranger bounces are acceptable.** That's pre-funnel filter doing its job (§ Pre-funnel aesthetic filter).
- **Warm-intro bounces are NOT acceptable.** Warm intros leave with an impression that colors the next conversation. The home page must read as deliberate, never as under-construction.
- **"How to work with me" doorway stays visible from the home page through scaffolding** so the conversion muscle doesn't atrophy. (Page design itself is in flight per `strategy.md` § Surface 2 § May focus points.)

### LinkedIn voice is the load-bearing artifact

The site is downstream of the voice. Voice gets built in public on LinkedIn. If voice compounds there, the site rewrites itself almost passively. If voice doesn't compound, no site work compensates.

Attention allocation reflects that: **LinkedIn first, site second.** When the two compete for time, LinkedIn wins.

### Decisions — do not relitigate

- Domain stays `boringsystems.app`. Functions as pre-funnel aesthetic filter. Counterweight to an otherwise warm stack. (Logged: `.claude/decisions/DECISIONS.md` 2026-05-01.)
- P2 is the conversion persona. P1 is peer-share — no revenue expected.
- Voice-target-per-piece. Never write for both at once.
- "How to work with me" doorway visible from the home page through scaffolding.

### Routing principle (for when conversion goes live)

Split P1/P2 at the **second click**, not the first.

- Home stays one shared room with two visible doors. Visible-without-scrolling doors beat clever IA.
- Don't force self-classification at the URL level before the visitor has signal — that's the site's job, not the visitor's.
- When P2 lands on the home page, the question is *how fast do they see their door* — not *whether the home is rewritten for them*. Routing problem, not tuning problem.

### Polarization gradient across the funnel

Different filtering mechanism at each stage. § Pre-funnel aesthetic filter is the principle this gradient comes from.

| Stage | Mechanism | What does the work |
|---|---|---|
| Top (pre-funnel + Awareness) | Aesthetic filter | Domain, header, surface register |
| Middle (Interest + Consideration) | Specificity | Body copy, named systems, named constraints, named decisions |
| Bottom (Conversion) | Edge | Offer page polarizes by stating what's *not* a fit |

**Drift to watch (load-bearing):** warmth creeping into the *bottom* (softens the close, leaves the right reader unable to commit) ↔ edge creeping into the *top* (filters out warm prospects in line one). Same identity-reflex showing up in opposite directions of the funnel.

### Drift watches — per persona

**P1:**

- Premature ask. P1 surfaces have no CTAs.
- Over-explaining the technical. P1 doesn't need the warm-up paragraph.
- Founder-LinkedIn cadence intrusion (short-line punch-and-drop). Reads as performance to engineers.

**P2:**

- Performative warmth at the close. Trust-building voice carrying into the conversion ask, leaving the right reader unable to commit.
- Generic-claim drift. "Senior judgment" without sensory anchor.
- Hedge-stacking on the offer ("I think," "maybe," "perhaps"). Leaks confidence at the moment of decision.
- Premature edge at the open. Anti-hype reflex producing copy that filters out warm prospects in line one.

### Signals to watch (operational triggers)

- **Cold-stranger volume rising** → revisit secondary-domain experiment (§ Secondary-domain experiment).
- **Warm intros bouncing without converting** → routing audit. Home page is failing the second-click rule.
- **P2 conversion data, once it exists** → re-test the persona-model diagnoses against the first ten real P2 conversations sourced from the site. The model is hypothesis until then.
- **Voice not compounding on LinkedIn** → step back from site work. Site is downstream; site work cannot compensate for upstream voice failure.
- **P1 traffic swamping P2 in raw volume** → bring forward the P1/P2 split sooner than planned.

### Deferred work — with triggers

Each item ships when the trigger fires. None of these are scheduled.

- **Full P2 conversion funnel** — when voice has stabilized on LinkedIn and warm-intro volume justifies a real close.
- **Dedicated P2 landing page beyond the existing doorway** — after the first ~5 P2 conversations sourced from the site. Until then there's not enough signal to know what the page actually needs to say.
- **Dedicated P1 landing page or peer-shaped index** — when P1 traffic swamps P2 routing on the shared home.
- **Secondary domain (`omrane.work` or similar) 301'd to the site** — when cold-stranger volume rises to where the boringsystems.app filter is costing more warm conversions than it's worth (cross-reference § Secondary-domain experiment).
- **Conversion measurement definition** — must be defined *before* the P2 conversion funnel ships. No funnel without a measurement plan.

---

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
