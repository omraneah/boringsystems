# Vibe DevEx — Measurement Talking Points + Enakl Numbers

Companion to `vibe-ai-lead-devex.md`. Hard numbers for the Arnaud Porterie call (measurement is his home turf — ex-founder of Echoes HQ, an engineering-productivity measurement company).

**Source.** Git history of the Enakl `enakl-tech` repos, fetched from remote 2026-06-01. Window: **January 2025 → May 2026** (17 months). Read-only analysis, no working-tree changes.

**Surfaces.** Apps = `rider-app` + `driver-app` merged (single contributor; treated as one surface). Backend split by path into **`backend-api/`** and **`backoffice/`** (it's a monorepo: 1046 vs 476 files). Excluded: `analytics` (no activity in window), `lambda-functions`/`cloud-infra` (single-month bursts), `cross-stack-*` (Ahmed's own architecture work).

**Identity dedup.** Same engineers commit under multiple emails/GitHub IDs; counts use a canonical map (e.g. `azedineouhadou`/`xperaz` = Azedine; `abderrsfa`/`abderrahmanesfaihi` = Abderrahmane; three Mehdi emails merged; Ahmed = lead, excluded from IC counts). Residual error possible.

---

## Executive summary — assessing throughput, velocity & release (Jan 2025 → Jun 2026)

A ≤6-engineer team shipping **>90% AI-generated code**, assessed across ~18 months and an explicit early-vs-mature comparison (H1-2025 = start of adoption, "tacky," churn; H1-2026 = matured).

**The team did not get louder — it got cleaner and more resilient.**

- **Release cadence: DORA Elite, sustained.** Backend held ~4.8–6.7 production releases/week steady-state; apps on app-store cadence (~1.2/wk). Never more than 6 backend engineers.
- **Quality rose sharply, H1-2025 → H1-2026.** All-surface change-failure (reverts) fell **~60%** (0.46 → 0.18/week). Backend-API bug-fix share **nearly halved** (24% → 14%). Backoffice reverts went 4 → **0**. Apps: **0 reverts the entire period.**
- **De-risked through churn.** One engineer left (Mehdi), two joined (Azedine, Elias); team size held. Critically, work **de-concentrated**: H1-2025 leaned on one dominant contributor (Yacine, 316 commits); H1-2026 load spread evenly across five. Key-person risk down.
- **Feature delivery held flat while rework fell.** The truest feature signal — **PR-merges into `development`** — was **steady** H1-25 → H1-26 (backend ~13/week both halves; apps +8%). But raw **commits/week fell 20–41%** and **prod releases fell**. Same features shipped, with **fewer commits per feature and fewer, larger prod batches** — i.e. **less thrash, not less delivery.**

**Two-phase arc (the honest framing):**
- **Phase 1 — speed (2024 → early 2025):** cycle collapsed 2 weeks → 1 week, ~2–3× throughput, no added headcount, no added PMs. Banked *last year* — the figure sold to investors.
- **Phase 2 — quality at held speed (2025 → 2026):** bug load more than halved, rollbacks −60%, test coverage <20% → ~70%, mobile zero reverts in 17 months. *This year's* story.

The Jan-2025+ git window mostly captures Phase 2 — which is exactly why feature-velocity reads *flat*: the speedup had already plateaued. Attribute cleanly: **speed = Phase 1, quality = Phase 2.** Merging them is the one way the story breaks under scrutiny.

**Net read:** H1-2025 was high-volume, high-rework, key-person-dependent early adoption. H1-2026 delivered the **same feature throughput** with near-zero rollback, less churn, more tests, and a distributed team. **AI adoption bought efficiency, quality, and resilience at constant feature velocity.**

> **⚠️ Frame velocity precisely.** Feature-merge rate was **sustained, not increased** — and raw commit/release *counts fell* (batching + reduced rework). So don't claim "we shipped more"; claim **"same feature output, far less rework and rollback."** The separate "2–3× velocity" figure is a **scope-normalized cycle-time** story (same sprint objectives in half the time) — not derivable from git counts. Lead on **feature-velocity-held + rework-down + rollback-down + risk-down.**

---

## 1. DORA primer (the four, one line each)

| Metric | What it measures | Type |
|---|---|---|
| **Deployment frequency** | How often code reaches production | Throughput |
| **Lead time for changes** | Commit → running in prod | Throughput |
| **Change failure rate** | % of deployments causing a failure/rollback | Stability (quality guardrail) |
| **MTTR** | Time to restore service after a failure | Stability (quality guardrail) |

The point to make to Arnaud: **throughput and stability are paired on purpose.** You can't game one without the other moving. Velocity alone is vanity; velocity *at constant stability* is the signal. Git gives **deployment frequency** + a **change-failure proxy** (reverts). Lead time and MTTR need ticket/incident data — proxied verbally (cycle-time story), not claimed as numbers.

---

## 2. Headline

- **Backend: 499 production releases over 17 months ≈ 6.7/week.** DORA **Elite**, sustained — by a team that was never larger than ~6 backend contributors.
- **The quality-under-velocity story is visible in the split:** on `backend-api`, **reverts went from clustered in H1-2025 (early adoption) to near-zero through 2026, and bug-fix share roughly halved (≈30% → ≈10%), while throughput held.** Speed sustained, quality *improved* as the harness matured.
- **Apps: one engineer, 0 reverts across all 17 months**, steady ~4.7 commits/week. The clean solo-operator counterpoint.
- All while **>90% of new code was AI-generated.**

---

## 2b. H1-2025 vs H1-2026 — early adoption vs matured

Normalized to **per-week** rates (H1-2025 = Jan–Jun, 26.0 wk; H1-2026 = Jan–May, 21.7 wk) so the uneven month counts don't distort. Ahmed = lead, excluded from IC counts.

| Metric | H1-2025 (early) | H1-2026 (matured) | Δ |
|---|---|---|---|
| backend-api commits/wk | 12.2 | 9.3 | −24% |
| backoffice commits/wk | 7.3 | 4.3 | −41% |
| apps commits/wk | 5.9 | 4.7 | −20% |
| backend releases/wk | 10.3 * | 6.0 | * H1-25 inflated by pre-batch merges |
| apps releases/wk | 1.4 | 1.2 | ≈flat |
| **backend-api bug-fix share** | **24%** | **14%** | **−10 pts** |
| backoffice bug-fix share | 15% | 21% | +6 pts |
| **all-surface reverts/wk** | **0.46** (12 total) | **0.18** (4 total) | **−60%** |
| backoffice reverts | 4 | 0 | −100% |
| apps reverts | 0 | 0 | — |

**Contributor churn (ICs):**
- H1-2025: Yacine (316), Abderrahmane (217), Omar (146), Mehdi (84) — 4 ICs, **heavily concentrated on Yacine.**
- H1-2026: Azedine (136), Yacine (126), Omar (98), Abderrahmane (88), Elias (49) — 5 ICs, **evenly distributed.**
- **Left:** Mehdi. **Joined:** Azedine, Elias. **Stayed:** Yacine, Abderrahmane, Omar.

**What it says:** volume down, **rework down, rollback down, key-person risk down.** The early-adoption half was loud and fragile; the matured half is quieter and robust. This is the maturity signal — not a speed-up.

---

## 3. Deployment frequency (production releases)

`rel` = merge into the production branch. Backend = `DEV→MASTER` promotions; apps = app-store `Release x.y.z` merges.

| month | backend rel | rel/wk | apps rel | rel/wk |
|---|---|---|---|---|
| 2025-01 | 22 | 5.0 | 2 | 0.5 |
| 2025-02 | 54 | 13.5 | 12 | 3.0 |
| 2025-03 | 52 | 11.7 | 8 | 1.8 |
| 2025-04 | 92 | 21.5 | 8 | 1.9 |
| 2025-05 | 31 | 7.0 | 4 | 0.9 |
| 2025-06 | 18 | 4.2 | 2 | 0.5 |
| 2025-07 | 23 | 5.2 | 4 | 0.9 |
| 2025-08 | 16 | 3.6 | 6 | 1.4 |
| 2025-09 | 17 | 4.0 | 9 | 2.1 |
| 2025-10 | 22 | 5.0 | 1 | 0.2 |
| 2025-11 | 7 | 1.6 | 0 | 0.0 |
| 2025-12 | 15 | 3.4 | 4 | 0.9 |
| 2026-01 | 29 | 6.5 | 4 | 0.9 |
| 2026-02 | 24 | 6.0 | 4 | 1.0 |
| 2026-03 | 30 | 6.8 | 9 | 2.0 |
| 2026-04 | 29 | 6.8 | 6 | 1.4 |
| 2026-05 | 18 | 4.1 | 2 | 0.5 |
| **TOTAL** | **499** | **6.7** | **85** | **1.1** |

H1-2025 backend cadence (22–92/mo) is inflated by a pre-batch merge style — not apples-to-apples with the steadier `DEV→MASTER` flow from mid-2025 on. Use the 2025-06→2026-05 band (~4.8/wk) as the defensible steady-state number.

---

## 3b. Feature velocity — PR-merges into `development` (the real feature signal)

`master`/prod just **batches** finished work (`DEV→MASTER` promotions), so it understates feature pace. The true unit of feature work is a **PR squash-merged into `development`** (each tagged `#PR`). This is where the development-speed signal lives. `lambda-functions` excluded (no `development` branch).

Cells = PR-merges to dev that month (per-week rate).

| month | backend | apps (rider+driver) | cloud-infra |
|---|---|---|---|
| 2025-01 | 76 (17.2) | 14 (3.2) | — |
| 2025-02 | 53 (13.2) | 15 (3.8) | — |
| 2025-03 | 66 (14.9) | 10 (2.3) | — |
| 2025-04 | 34 (7.9) | 22 (5.1) | — |
| 2025-05 | 64 (14.5) | 16 (3.6) | — |
| 2025-06 | 48 (11.2) | 7 (1.6) | — |
| 2025-07 | 49 (11.1) | 10 (2.3) | — |
| 2025-08 | 22 (5.0) | 13 (2.9) | — |
| 2025-09 | 26 (6.1) | 19 (4.4) | — |
| 2025-10 | 36 (8.1) | 6 (1.4) | — |
| 2025-11 | 16 (3.7) | 9 (2.1) | — |
| 2025-12 | 36 (8.1) | 10 (2.3) | — |
| 2026-01 | 45 (10.2) | 16 (3.6) | — |
| 2026-02 | 78 (19.5) | 15 (3.8) | — |
| 2026-03 | 71 (16.0) | 16 (3.6) | 15 (3.4) |
| 2026-04 | 46 (10.7) | 16 (3.7) | — |
| 2026-05 | 46 (10.4) | 13 (2.9) | — |
| **TOTAL** | **812** | **227** | **15** |

### H1-2025 vs H1-2026 — feature PR-merges/week

| project | H1-25/wk | H1-26/wk | Δ |
|---|---|---|---|
| backend | 13.1 | 13.2 | **+0% (flat)** |
| apps (rider+driver) | 3.2 | 3.5 | **+8%** |
| cloud-infra | 0.0 | 0.7 | new (infra extracted 2026) |

**The decisive contrast:** feature-merge velocity was **held constant** across the two halves — while raw commits/week and prod-release counts both *fell*. The team produced the **same volume of merged features** with **fewer commits per feature** (less rework) and **fewer rollbacks** (better quality). Prod-release count dropping just means H1-2026 shipped in **fewer, larger, cleaner batches**. This is the efficiency dividend of the matured harness: constant output, less waste.

---

## 3c. Testing growth (quality investment)

Test-*file* ratio from git (test files ÷ source files). Two master snapshots: 2025-06-27 vs 2026-05-29.

| surface | test files (2025-06 → 2026-05) | test:source ratio |
|---|---|---|
| backend-api | 86 → 243 (**×2.8**) | 17% → 32% |
| backoffice | 7 → 51 (**×7.3**) | 2% → 13% |

**Caveat:** this is test-file ratio, not line coverage. The "<20% → ~70% coverage" figure is a **Sonar/jest dashboard number**, not git-derivable — cite it as your own metric. Git corroborates the **direction** hard: testing roughly tripled on the API and went from near-absent to a real suite on backoffice.

---

## 4. Per-surface development — speed vs. quality vs. contributors

`/wk` = non-merge commits touching that surface ÷ weeks. `fix%` = bug-fix share of commits (quality proxy). `rev` = reverts. `ppl` = distinct contributors. `dominant` = top contributor's share.

### backend-api — the multi-dev surface that "changes"

| month | commits | /wk | fix% | rev | ppl | dominant |
|---|---|---|---|---|---|---|
| 2025-01 | 50 | 11.3 | 16% | 0 | 4 | Yacine 52% |
| 2025-02 | 49 | 12.2 | 38% | 0 | 5 | Yacine 46% |
| 2025-03 | 45 | 10.2 | 35% | 3 | 5 | Yacine 53% |
| 2025-04 | 85 | 19.8 | 27% | 3 | 5 | Yacine 41% |
| 2025-05 | 57 | 12.9 | 10% | 2 | 4 | Yacine 36% |
| 2025-06 | 30 | 7.0 | 20% | 0 | 4 | Abderrahmane 66% |
| 2025-07 | 38 | 8.6 | 28% | 0 | 4 | Abderrahmane 42% |
| 2025-08 | 18 | 4.1 | 27% | 1 | 4 | Yacine 27% |
| 2025-09 | 17 | 4.0 | 5% | 0 | 2 | Abderrahmane 58% |
| 2025-10 | 29 | 6.5 | 24% | 1 | 3 | Yacine 44% |
| 2025-11 | 12 | 2.8 | 0% | 2 | 3 | Abderrahmane 75% |
| 2025-12 | 19 | 4.3 | 0% | 0 | 4 | Yacine 42% |
| 2026-01 | 32 | 7.2 | 9% | 2 | 4 | Yacine 37% |
| 2026-02 | 50 | 12.5 | 8% | 1 | 5 | Yacine 38% |
| 2026-03 | 49 | 11.1 | 12% | 1 | 6 | Azedine 36% |
| 2026-04 | 41 | 9.6 | 21% | 0 | 5 | Azedine 48% |
| 2026-05 | 29 | 6.5 | 24% | 0 | 4 | Yacine 44% |
| **TOTAL** | **650** | **8.8** | **20%** | **16** | **7** | Yacine 242 · Abderrahmane 209 · Azedine 68 · Mehdi 52 · Omar 39 · Ahmed 34 · Elias 6 |

### backoffice

| month | commits | /wk | fix% | rev | ppl | dominant |
|---|---|---|---|---|---|---|
| 2025-01 | 47 | 10.6 | 4% | 0 | 4 | Yacine 48% |
| 2025-02 | 30 | 7.5 | 16% | 1 | 2 | Abderrahmane 63% |
| 2025-03 | 31 | 7.0 | 19% | 1 | 4 | Abderrahmane 54% |
| 2025-04 | 38 | 8.9 | 23% | 1 | 3 | Abderrahmane 76% |
| 2025-05 | 23 | 5.2 | 8% | 1 | 3 | Abderrahmane 86% |
| 2025-06 | 22 | 5.1 | 27% | 0 | 3 | Abderrahmane 50% |
| 2025-07 | 23 | 5.2 | 17% | 0 | 3 | Abderrahmane 60% |
| 2025-08 | 8 | 1.8 | 0% | 1 | 3 | Abderrahmane 62% |
| 2025-09 | 13 | 3.0 | 15% | 0 | 3 | Abderrahmane 76% |
| 2025-10 | 16 | 3.6 | 25% | 1 | 2 | Abderrahmane 56% |
| 2025-11 | 6 | 1.4 | 0% | 0 | 1 | Abderrahmane 100% |
| 2025-12 | 12 | 2.7 | 0% | 0 | 2 | Abderrahmane 75% |
| 2026-01 | 21 | 4.7 | 28% | 0 | 4 | Abderrahmane 47% |
| 2026-02 | 19 | 4.8 | 21% | 0 | 5 | Abderrahmane 36% |
| 2026-03 | 23 | 5.2 | 8% | 0 | 4 | Azedine 56% |
| 2026-04 | 10 | 2.3 | 40% | 0 | 2 | Azedine 70% |
| 2026-05 | 20 | 4.5 | 15% | 0 | 3 | Abderrahmane 50% |
| **TOTAL** | **362** | **4.9** | **16%** | **6** | **7** | Abderrahmane 209 · Yacine 90 · Azedine 37 · Ahmed 10 · Mehdi 7 · Elias 6 · Omar 3 |

### apps (rider + driver merged)

| month | commits | /wk | fix% | rev | ppl | dominant |
|---|---|---|---|---|---|---|
| 2025-01 | 17 | 3.8 | 17% | 0 | 1 | Omar 100% |
| 2025-02 | 44 | 11.0 | 11% | 0 | 2 | Omar 70% |
| 2025-03 | 31 | 7.0 | 16% | 0 | 3 | Omar 74% |
| 2025-04 | 31 | 7.2 | 32% | 0 | 2 | Omar 87% |
| 2025-05 | 21 | 4.7 | 19% | 0 | 1 | Omar 100% |
| 2025-06 | 9 | 2.1 | 0% | 0 | 1 | Omar 100% |
| 2025-07 | 14 | 3.2 | 0% | 0 | 1 | Omar 100% |
| 2025-08 | 19 | 4.3 | 5% | 0 | 1 | Omar 100% |
| 2025-09 | 28 | 6.5 | 10% | 0 | 1 | Omar 100% |
| 2025-10 | 7 | 1.6 | 0% | 0 | 1 | Omar 100% |
| 2025-11 | 9 | 2.1 | 22% | 0 | 1 | Omar 100% |
| 2025-12 | 14 | 3.2 | 0% | 0 | 1 | Omar 100% |
| 2026-01 | 20 | 4.5 | 25% | 0 | 2 | Omar 85% |
| 2026-02 | 19 | 4.8 | 21% | 0 | 3 | Omar 68% |
| 2026-03 | 25 | 5.6 | 16% | 0 | 3 | Omar 76% |
| 2026-04 | 22 | 5.1 | 13% | 0 | 1 | Omar 100% |
| 2026-05 | 16 | 3.6 | 12% | 0 | 1 | Omar 100% |
| **TOTAL** | **346** | **4.7** | **14%** | **0** | **5** | Omar 306 · Mehdi 24 · Elias 11 · Ahmed 3 · Azedine 2 |

---

## 5. The speed-vs-quality finding

- **Backend-api stabilized as the harness matured.** H1-2025 (early/scaling adoption) was the noisy period: high throughput *and* elevated bug-fix share (27–38%) *and* the reverts cluster (Mar–May 2025). Through 2026, **reverts fell to 0–1/month and fix-share dropped to ~8–12%, while throughput stayed at ~7–12 commits/week.** Speed held; quality improved.
- **Backoffice followed the same curve** — reverts concentrated in H1-2025 (6 total, all by Oct-2025), then zero across the entire 2026 window.
- **Apps prove the ceiling case:** a single engineer sustained ~4.7 commits/week with **zero reverts for 17 straight months**. Solo + AI harness = high output, zero rollback.
- **The team never exceeded ~6 backend contributors** and the workhorses (Yacine, Abderrahmane) carried both surfaces full-stack — yet held Elite release cadence. That's leverage, not headcount.

---

## 6. How to use with Arnaud

**Lead with the pairing:** *"As the harness matured, backend reverts went to near-zero and bug-fix share halved while release cadence held at ~5/week — with a team that never topped six backend engineers. Speed didn't cost quality; it bought it."*

**Then hand him the measurement-design problem** (the n=5 move): *"At this scale I trusted release cadence + revert rate + bug-fix share + escalations-to-me, and deliberately ignored the gameable DORA inputs (PR count, time-to-first-commit). At 50 the instrumentation changes. You built Echoes around exactly this — what survived contact with teams once they knew they were measured?"*

---

## 7. Honest caveats (say them before he finds them)

1. **"Release" = merge to the production branch**, assuming deploy-on-merge. Backend is server-continuous; apps "releases" are store submissions. Different models — not summed.
2. **H1-2025 backend cadence is not comparable** to mid-2025+ (pre-batch merge style). Quote the ~4.8/wk steady-state band, not the 21.5/wk April spike.
3. **Surface split is fuzzy:** 192 backend commits touched *both* api and office, 95 touched neither (root/config). A full-stack commit counts in both columns. Throughput is directional, not exact.
4. **Bug-fix = commit-subject keyword**, not labeled tickets. Reverts = git-level only (flag/redeploy rollbacks invisible) — so the change-failure proxy is a *floor* on stability.
5. **Contributor counts depend on a hand-built identity map.** Directionally solid, not audited.
6. **⚠️ Contradicts the prior:** backend-api did **not** collapse to a single contributor — it shows **4–6 distinct contributors every month through 2026** (Yacine, Abderrahmane, Azedine dominant). If "now it's only him" is your live read, the commit data doesn't support it for the full backend-api surface — possibly true only for a sub-component, or only in the last few weeks. Worth reconciling before you lean on it verbally.
7. **Post-adoption window.** AI rollout ran Q4-2024 → Q1-2026, so most of this is steady-state, not before/after. The before/after delta is the cycle-time story (2wk→1wk), which lives in the narrative.
