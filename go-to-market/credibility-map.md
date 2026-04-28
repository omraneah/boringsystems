# Credibility Map

What the resume + track record sells credibly, what it sells with friction, and what it cannot sell. Used as a constraint check on offer design and as a live qualification filter on inbound.

This is honest market reality, not aspiration. Inbound that lands inside the easy-sell zone closes faster, with less proving, at better margin. Inbound that lands outside it costs disproportionate energy to convert and often closes at a discount.

---

## The three zones

### Zone 1 — Easy sell (credibility is high, no proving required)

| Claim | Evidence backing it |
|---|---|
| Lead generalist (Tech / Data / Product) | Three-year cross-functional ownership; technical decisions made with business-model awareness |
| 0→1 builder | Done it twice — both times to operable production state |
| Data / AI native | Demonstrated in current role and in the AI-agent orchestration work that defines the post-Enakl operating mode |
| Early-stage operator (5–50 people) | Three-year footprint at this exact altitude |

**Inbound landing here closes fast.** The buyer is buying something the resume already proves. Discovery is about fit and timing, not about whether Ahmed can do the work.

### Zone 2 — Hard sell (credibility is partial, requires proving in conversation)

| Claim | Friction |
|---|---|
| Head of … (function-level leadership at a larger org) | The title shape exists in the trajectory but not as a labeled "Head of" line item — buyers used to corporate signaling will need it framed |

**Inbound landing here can close** but the discovery call has to do real work to translate the lived experience into the language the buyer is scanning for. Slow down on these — they're winnable but not on autopilot.

### Zone 3 — Cannot sell credibly (do not anchor here)

| Claim | Why it doesn't sell |
|---|---|
| Manager-of-managers (VP / Director / C-Level at scale) | Track record is operator-shaped, not org-builder-shaped at that altitude |
| Hyperscale / hyper-growth ops | The companies in the trajectory are early-stage; scale-stage credibility is borrowed at best |
| Deep tech / complex infra (e.g. distributed systems R&D) | Generalist-with-judgment, not specialist-with-depth in this lane |

**Inbound landing here will not close** at the price/altitude the buyer is implicitly assuming. The right move is to either reframe the conversation toward the easy-sell zone or refer out.

---

## How this constrains the offers

Each of the three offers in `offers.md` checked against the map:

### Offer 1 — Fractional CTO
**Zone:** Easy sell. Seed → Series B is exactly the early-stage zone. Executive-level technical decisions for 5–50 person companies is the lived experience verbatim.
**Verdict:** Offer is inside credibility. Default offer for inbound.

### Offer 2 — Sprint Founder-Builder
**Zone:** Easy sell. 0→1 build for a non-technical founder is the most credibility-dense version of the lived experience. AI-native execution sharpens it further.
**Verdict:** Offer is inside credibility. Highest margin and highest craft satisfaction.

### Offer 3 — Transformation Lead
**Zone:** **Borderline.** The "50+ engineer larger corporation" framing brushes the hyperscale wall. The actual proof point is *transformation on team-of-3-to-5 budgets* — which is genuine, but the offer copy currently invites buyers from a tier where credibility is borrowed.
**Verdict:** Reframe the offer's target buyer to *mid-stage companies in transformation moments where the migration is owned at operator altitude, not VP/Director altitude*. Or accept that this offer is the safety net (current framing) and qualify hard during discovery: if the buyer is asking for VP-of-Engineering-during-migration shape, refer out rather than pursue.

---

## Live qualification — questions to surface zone during inbound

Use these in the discovery half of an inbound call (per `inbound-call-discipline.md`) to identify which zone the conversation lives in *before* anchoring on offer or price:

1. **Stage and headcount.** Seed → Series B / 5–50 people = Zone 1. 50+ with established function-level leaders = Zone 3 risk.
2. **What's the role of the person they're trying to replace or augment?** "Founder, full-stack" = Zone 1. "VP of Engineering, manager of managers" = Zone 3.
3. **What's the technical surface area?** Application layer, product engineering, AI integration = Zone 1. Distributed systems R&D, hyperscale infra, deep specialist domain = Zone 3.
4. **Who currently makes the architectural decisions?** No one / a generalist founder = Zone 1. A team of senior architects = Zone 2 or 3.

If two or more answers land in Zone 3, walk with care (per the `inbound-call-discipline.md` walk criteria). Refer out where possible — preserves the relationship without taking on a losing engagement.

---

## What this map is *not*

- Not a fixed identity. The map evolves — Sprint Founder-Builder engagements will, over 12–24 months, build the case for Zone 2 expansion. The lab/ exploration probe may produce evidence that shifts a credibility wall.
- Not a confidence statement. Credibility ≠ capability. Ahmed can *execute* in some Zone 3 contexts; the map says the *sale* costs more than it returns.
- Not permanent. Re-read this file every 6 months against actual inbound. Move claims between zones as evidence accumulates.

---

## References

- `offers.md` — the three offers, now constrained by this map
- `inbound-call-discipline.md` — discovery questions surface zone before anchoring
- `memory/medium-term/market/Leverage Profile & Market Lens.md` — the strategic-tier source material on capability-based vs. credential-based leverage
