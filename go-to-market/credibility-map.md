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
| Data / AI native | Demonstrated in current role and in the AI-agent orchestration work that defines the post-transition operating mode |
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

## How this constrains the shapes

Each of the two engagement shapes (Shape A — mandate; Shape B — fractional / freelance) checked against the map. Full structural definitions in `memory/medium-term/Engagement-Shapes.md`; operational surfaces in `offers.md`.

### Shape A — Mandate inside a company
**Zone:** Easy sell at Seed → Series B or transformation-shaped mid-stage. Lived experience verbatim. At hyperscale / VP-with-direct-reports altitude, borderline — VP-of-VPs scope is borrowed credibility.
**Verdict:** Inside credibility for AI-native / transformation-shaped orgs at 5–200 people. Qualify hard if the role-shape is a VP-of-VPs / direct-report-heavy mandate (filter: team-leadership-as-main-mandate, out — see `memory/medium-term/Drivers-and-Filters.md`).

### Shape B.1 — Fractional CTO / CPO, early-stage
**Zone:** Easy sell. Seed → Series B is exactly the early-stage zone. Executive-level technical decisions for 5–50 person companies is the lived experience verbatim.
**Verdict:** Inside credibility. Default Shape B engagement.

### Shape B.2 — Transformation freelance for established orgs
**Zone:** **Borderline.** The "50+ engineer larger corporation" framing brushes the hyperscale wall. The actual proof point is *transformation on team-of-3-to-5 budgets* — which is genuine, but the offer copy must avoid inviting buyers from a tier where credibility is borrowed.
**Verdict:** Target *mid-stage companies in transformation moments where the migration is owned at operator altitude, not VP/Director altitude*. Qualify hard during discovery: if the buyer is asking for VP-of-Engineering-during-migration shape, refer out rather than pursue.

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

- Not a fixed identity. The map evolves — Shape B engagements will, over 12–24 months, build the case for Zone 2 expansion. The lab/ exploration probe may produce evidence that shifts a credibility wall.
- Not a confidence statement. Credibility ≠ capability. Ahmed can *execute* in some Zone 3 contexts; the map says the *sale* costs more than it returns.
- Not permanent. Re-read this file every 6 months against actual inbound. Move claims between zones as evidence accumulates.

---

## References

- `offers.md` — engagement options (Shape A, Shape B.1, Shape B.2), constrained by this map
- `inbound-call-discipline.md` — discovery questions surface zone before anchoring
- `memory/medium-term/Drivers-and-Filters.md` — qualification layer (drivers + filters + position synthesis)
- `memory/medium-term/Engagement-Shapes.md` — structural definitions of Shape A and Shape B
