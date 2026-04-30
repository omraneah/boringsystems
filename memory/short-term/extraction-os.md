# Proof Asset Extraction OS

**Status:** Authoritative — governs all extraction during notice period

**Purpose:** Convert Enakl into **portable, market-grade assets** (not internal notes)

---

## Core Principle (Non-Negotiable)

> If it is not reusable outside Enakl, it is not worth documenting.
> 

---

## 1. Extraction Scope (Strict)

You already defined the right scope. Lock it:

### A. Infra Design Principles

- IAM, access control, secrets management
- Network boundaries, security layers
- Deployment architecture, CI/CD patterns
- Multi-tenancy foundations

### B. SaaS Transition Principles

- Monolith → SaaS decomposition logic
- Data isolation strategies (row vs schema vs hybrid)
- Migration sequencing under constraint
- Backward compatibility / risk containment

### C. AI-Native Dev Principles

- How AI integrates into dev workflows
- What changes in architecture decisions
- Where AI adds leverage vs noise
- Human vs AI responsibility boundaries

### D. Org Design (Under Constraint)

- Team topology (who owns what, why)
- Pairing logic (ISFJ / INTP constraints etc.)
- Decision layers and escalation paths
- Failure containment through org design

---

### E. Cross-Stack “Healthy Start” Principles (Important addition)

This is your **high-value differentiator**:

- What teams miss early that creates long-term tech debt
- Cross-stack invariants (backend, infra, data, product)
- Minimal constraints that prevent exponential complexity
- “If you don’t do this early → cost explodes later”

---

## 2. Output Format (Mandatory)

Each asset = **Case + Principle**

### Format:

1. **Context**
- Initial situation (constraints, team, stage)
1. **Problem**
- What was broken / risky / unclear
1. **Decision**
- What you chose (and why)
1. **Principle**
- Abstract rule (reusable)
1. **Trade-offs**
- What you accepted / rejected
1. **Outcome**
- Result (even partial)

---

**Rule:**

> No raw notes. Only structured artifacts.
> 

---

## 3. Quality Bar (Market-Level)

Each artifact must:

- Stand alone (no Enakl context needed)
- Be understandable in 2–3 minutes
- Show **judgment under constraint**
- Avoid internal jargon

If it sounds like internal documentation → rewrite.

---

## 4. Extraction Filter (What NOT to Capture)

Do NOT document:

- Implementation details
- Ticket-level decisions
- Team-specific issues
- Anything tied to specific people
- Anything not reusable

---

## 5. Cadence

- **Quality > volume.** These are positioning assets, not output to fill a schedule.
- Capture when the triggers in Section 6 fire — pattern recognized, decision had long-term impact, constraint forced a non-obvious solution. Don't manufacture artifacts for the cadence.
- A few clean artifacts over the 2-month window beats a forced weekly schedule.

---

## 6. Extraction Triggers (When to Capture)

Capture when:

- You notice a recurring pattern
- A decision had long-term impact
- A constraint forced a non-obvious solution
- Something “felt wrong” in standard approaches

---

## 7. Likely Output Buckets

These are buckets where artifacts are likely to land — not a target inventory:

- Infra principles
- SaaS transition principles
- AI-native dev perspective
- Org design under constraint
- Cross-stack "healthy start" doctrine

The actual mix is whatever the extraction triggers produce. Some buckets may stay empty; others may produce more. Quality and reusability are the only metrics.

---

## 8. Anti-Drift Rule

If extraction turns into:

- rewriting code
- fixing systems
- helping the team

→ stop immediately

---

## 9. Final Rule

> You are not documenting what you did.
> 
> 
> You are extracting **how you think**.

---

## 10. Current State — Externalized Proof (Update)

**Status:** Active — execution already started

### Existing Outputs (Already Published)

A portion of the extraction is already externalized into public artifacts:

A cross-stack architecture starter pack (GitHub), containing:

- Boundary-driven architecture
- Enforceable invariants and constraints
- Designed for reuse across systems

A personal platform (website), containing:

- Case-based breakdowns of real system situations
- Operating playbooks for execution and decision-making
- Principle-level system thinking

### Content Nature (What is already covered)

The published material already demonstrates:

- Architecture as enforced constraints, not guidelines

System design focused on:

- simplicity
- explicitness
- long-term maintainability

Cross-stack invariants:

- identity & access separation
- tenant isolation
- module boundaries
- infrastructure control

Execution patterns under constraint:

- decision-making
- change injection
- complexity control

### Distribution Structure (Current System)

A layered system is already in place:

- LinkedIn -> Website -> GitHub

Where:

- LinkedIn = entry point (signal)
- Website = structured thinking (cases + playbooks)
- GitHub = concrete, reusable artifacts

### Implication (Critical)

> Extraction is no longer theoretical.
> It is already partially completed and publicly deployed.

Remaining work is:

- Continue extraction incrementally
- Increase density and sharpness of artifacts
- Not "start from zero"

### Anti-Distortion Rule (Important)

Do NOT behave as if:

- proof is missing
- execution has not started

> This creates false urgency and misalignment.
