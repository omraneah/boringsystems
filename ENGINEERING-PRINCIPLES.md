# Engineering Principles

The seven dimensions of cross-stack engineering practice that apply to every project in this workspace.

This is the workspace-root distillation. The full reference lives in `cross-stack-architecture-starter-pack/engineering-practices-boundaries.md`, alongside the eleven boundary documents (auth, API, multi-tenancy, IAM, module communication, IaC, naming, quality/security, data integrity, etc.) that govern *what must be true*, plus agent guides, decision trees, patterns, and anti-patterns that describe *how to make it true*.

These are governing rules, not preferences. They apply equally to engineers and AI tools — **one bar for everyone**. Violations are defects in how work is done.

---

## 1. Architecture and Boundaries

Check architectural boundaries before implementation; boundaries are non-negotiable. Do not build on top of major degradation — escalate instead. Boundaries are constraints, not suggestions; violations are rejected in review.

## 2. Separation of Concerns

Each unit owns one responsibility. The architectural-level expression of SOLID's Single Responsibility Principle, applied across functions, modules, services, and systems. Layered architectures (controller/service/repository, hexagonal, clean, MVC, modular monolith) exist to enforce it; encapsulation, loose coupling, and high cohesion are corollaries. Specific failure modes to watch: business logic leaking into the client, controllers doing service work, god modules. The test in review: if a single change request would touch more than one responsibility inside a unit, the unit was carrying too much.

## 3. Root Cause and Fixes

Identify the root cause before fixing. Avoid workarounds and silencing unless explicitly approved. Short-term workarounds are documented and escalated, not normalized into the codebase.

## 4. Planning and Reviewability

Share plans early for non-trivial work. Prefer small, reviewable changes — split structurally when a unit grows complex. Ship small, iterate often; estimates are forecasts, not promises. Reviews spread knowledge; treat them as alignment and learning.

## 5. Code Quality

Small, well-named units. Explicit types. No magic numbers. KISS and YAGNI — simplest solution that meets the requirement, no speculative complexity, no premature future-proofing. DRY — single source of truth, no duplicated logic across layers or repos. Every line of code and every dependency is a liability; add only when the benefit clearly outweighs the long-term cost.

## 6. Documentation and Traceability

Document non-obvious decisions and the rationale behind them. Commit messages explain what and why, not just what changed. History should be reviewable and debuggable months later.

## 7. Testing

Test behaviour that matters. Leave tests better than you found them (boy-scout rule). Triage flaky or failing tests; never ignore them. Tests are first-class — same clarity, naming, and maintainability standards as production code.

---

## Reference

- Full text: `cross-stack-architecture-starter-pack/engineering-practices-boundaries.md`
- Cross-stack ARDs (eleven boundary documents): `cross-stack-architecture-starter-pack/*.md`
- Agent guides: `cross-stack-architecture-starter-pack/AGENT-GUIDES/`
- Decision trees, patterns, anti-patterns: `cross-stack-architecture-starter-pack/{DECISION-TREES,PATTERNS,ANTI-PATTERNS}/`

The cross-stack pack is the source of truth. This file is a distillation for fast reference. When the two diverge, the pack wins; this file is updated to match (per `META-PRINCIPLES.md` principle 1).
