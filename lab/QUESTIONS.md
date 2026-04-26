# Open Questions

Complexity preserved. **Do not collapse these by picking the first plausible answer.** Each is held open until the data resolves it, or until a deliberate decision is logged.

---

## Frame & scope

### 1. Hard quarantine vs. soft quarantine

Currently soft (folder in workspace, can call existing agents/skills, marked "experimental"). Should this escalate to hard (own submodule, own settings, own MCP, own deploy surface) at any specific trigger? What would that trigger be?

> Default working assumption: stay soft until either (a) the lab generates artifacts that are commercially distinct from boringsystems, or (b) the lab needs different deploy surfaces / credentials / branding from the main workspace. Either escalates to hard quarantine via submodule.

### 2. Brand boundary

When the lab eventually publishes / sells, does it do so under:

- (a) Ahmed's name + boringsystems reputation as cover (max leverage, max brand-risk)
- (b) A separate sub-brand under the boringsystems umbrella (some leverage, some isolation)
- (c) A fully separate brand with no public link to Ahmed (no leverage, full isolation)
- (d) Decide later — let the lab itself surface the answer

**This is genuinely undecided and shapes everything downstream.** Held open.

### 3. Relationship to the conductor pattern

Is the lab the proving ground for the conductor (the conductor lives in the workspace harness; first real run lives here), or does it use a different orchestration mechanism specific to the lab?

> Default read: same conductor; first run here; conductor lives upstream as workspace infrastructure. Lab consumes it.

### 4. 18-month horizon clause from the Re-Entry Doctrine

The doctrine names a 12–18 month re-entry phase. The lab runs alongside that phase. At the end (≈ Dec 2027), is the lab re-evaluated as part of the re-entry checkpoint, or on a separate cadence?

---

## Assets & integrity

### 5. Asset scope, concretely

Which of these are explicitly in scope as raw material for the lab?

- [ ] Enakl proof / cases (TMS-from-scratch, vendor-exit, SaaS transformation, 20M+ DAU data infra)
- [ ] boringsystems published content (re-package, re-edit, re-bundle)
- [ ] Cross-Stack ARDs (productize)
- [ ] The Claude Code harness pattern itself (the way of working with agents)
- [ ] Domain knowledge across the eight areas (founders, customers, GTM, marketing, sales, content, paid-acquisition, product, analytics, growth)
- [ ] Personal-apps portfolio (Pollen Tracker, African Legal Factory)
- [ ] **OUT OF SCOPE — confirmed:** Warm graph contacts. The lab does not touch the relationship-led substrate.
- [ ] **OUT OF SCOPE — confirmed:** Identity-attached materials (Meta-Identity Constitution, transition docs, etc.).
- [ ] Other? `____`

### 6. Integrity floor — concrete edge cases

Each is a real edge case from the prior conversation. Each needs a clear ruling before execution:

| Edge case | Ruling |
|---|---|
| AI-generated content sold under Ahmed's name **without** disclosure | `____` |
| AI-augmented info products **with** disclosure ("built with my agent harness") | `____` |
| Existing boringsystems articles repackaged into a paid bundle | `____` |
| Cold outreach with personalized AI-generated DMs at scale | `____` |
| Lead magnet → email sequence → upsell, where the email sequence is LLM-tuned on Ahmed's voice | `____` |
| A paid micro-product about agent orchestration that competes with content Ahmed publishes for free on boringsystems | `____` |

---

## Success criterion

### 7. The €500–€1k floor — measured how?

- (a) Revenue produced *by* the lab's mechanisms (a digital product sells through automation)
- (b) Revenue produced *through* the lab's outputs (Ahmed closes the sale, but the lab generated the lead, the positioning, the artifact)
- (c) Both count, with no preference

### 8. Honest review cadence

No deadlines. But: at what cadence does Ahmed honestly review whether to continue, pivot, or shelf?

> Default: quarterly, with the next review pre-scheduled at the moment kill criteria are written.

---

## Doctrine relationship — the most consequential open question

### 9. Are the 12–18 month Re-Entry Doctrine rules applicable to the lab?

The doctrine names: *"no PMF reframes," "no audience-building-as-primary," "advisory-led path is the path itself."*

Two readings:

- **(i) Lab is genuinely independent.** Doctrine governs the 90%; lab is a sandbox where the doctrine doesn't apply because it's not the primary path.
- **(ii) Lab is downstream of the doctrine.** The rules are about *Ahmed*, not about *which folder*. They apply everywhere.

The two readings produce very different labs. **Until this is resolved, the lab is in pre-execution.**

---

## Hypothesis sharpening

### 10. The agent-to-agent attention arbitrage hypothesis itself

What's the smallest, cheapest signal that would update toward "real" or "not real"?

Greene's question, carried verbatim: *"Do I have a decade of substrate underneath this probe, or am I betting on a window I read about?"* — what's the honest answer?

### 11. Smallest scrappy version (Branson's challenge)

What's the smallest scrappy version that could ship by Friday? Not the full orchestration. The crudest version of the smallest piece that would generate any signal at all.

---

## Resolution discipline

Before the lab starts, every question above either has a clear answer logged here, or has an explicit "deliberately held open until data" annotation.

When a question is resolved, mark it `RESOLVED YYYY-MM-DD` with the answer inline. When a decision is made, log it in `lab/decisions/` (create the folder when the first decision lands).
