---
title: "Context is the Edge"
description: "The AI harness commoditizes. The only advantage that compounds with you is the context you build, govern, and carry across every session and every agent."
date: 2026-04-17
highlight: true
featured: true
order: 4
---

The only thing the labs can't ship for you.

## Purpose

The AI ecosystem is in a race to improve the harness: connections, tools, reasoning loops, memory systems, orchestrators.

The labs will raise the floor on all of it every few weeks.

None of that is yours to own.

Your context is.

How you structure it, govern it, and carry it across every session and every agent — that is the only edge that compounds with you over time.

This playbook describes the architecture that makes it possible.

---

## Core Principles

**Context is architecture, not content**

The structure determines what an agent inherits. An unstructured dump is noise. A governed, layered context is leverage.

**Separation of concerns applies here too**

Project decisions, shared patterns, and personal working principles have different lifetimes, different scopes, and different purposes. They should never live in the same place.

**Version control is the discipline**

Unversioned context drifts. Decisions get overwritten. Constraints silently disappear. Without git, the system will eventually collapse on itself.

**The raw material is yours to capture**

LLMs can help you structure and refine context. They cannot generate it. The decisions, the constraints, the judgment calls — those exist only in your work. Capture them or lose them.

**Maintenance is not optional**

Accumulated noise is worse than no context. Stale constraints mislead agents. Outdated decisions create false floors. The system requires periodic pruning.

**Context compounds; everything else resets**

Each structured session builds on the last. Each captured decision avoids being rediscovered. The gap between a session that inherits context and one that starts from scratch widens with every project.

---

## The Three-Layer Context Stack

The system that compounds consistently is built on three distinct layers, each with its own scope and lifetime.

**Layer 1 — Project Context (in-repo)**

This layer lives inside the project repository itself.

It contains:

- the domain model and its constraints
- architectural decisions and the reasoning behind them
- engineering rules and quality standards
- guardrails that govern what agents may and may not generate
- key patterns and anti-patterns specific to this codebase

Every agent session starts from here, not from scratch.

The key structural principle: these documents are not documentation. They are not written after the fact. They are operational — loaded before any session begins, governing every generation decision.

They answer: *what is true about this system, and what must remain true.*

**Layer 2 — Shared Layer (cross-project)**

This layer sits above individual projects and below the personal layer.

It contains:

- engineering practices that apply regardless of the project
- reusable patterns extracted from past work
- agent commands and skills common across codebases
- decision frameworks that recur across different contexts

Nothing here belongs to a single project.

It is the layer that converts isolated experience into reusable infrastructure.

**Layer 3 — Personal Layer (separate repository)**

This layer is entirely separate — its own repository, its own maintenance cycle.

It contains:

- working principles and cognitive defaults
- how decisions get made under constraint
- collaboration models and relational context
- active projects and their current state
- personal guardrails that apply to every session

This layer applies universally. It loads regardless of which project is active.

It answers: *how does this operator think, decide, and work.*

---

## What Belongs Where

The routing principle is simple:

- A decision that affects one project → Layer 1
- A pattern that applies across projects → Layer 2
- Anything that governs how you think or work → Layer 3

When in doubt: the narrower the scope, the lower the layer.

A constraint about a specific domain boundary in one codebase belongs in Layer 1. A principle about how to handle that class of problem in general belongs in Layer 2. A principle about how you approach architectural trade-offs belongs in Layer 3.

Do not flatten layers to reduce friction. Flattening is how context becomes noise.

---

## Why Git is Non-Negotiable

This is the part most people skip — and where the system breaks down.

Context managed without version control is not a system. It is a pile of files that will diverge, contradict itself, and eventually mislead the agents working with it.

Here is what happens without it:

- an agent updates a constraint; a future session inherits the wrong version
- two documents make conflicting claims; there is no way to know which is authoritative
- a decision is overwritten; the reasoning is gone
- a context change introduces a regression; there is no way to roll it back

The AI agents themselves — the ones used to enrich and maintain context as you go — need to operate against a repository with full commit history. That is the only way their changes can be reviewed, audited, and trusted.

**This requires:**

- a git repository for each layer of the stack
- a remote host (GitHub, GitLab, or equivalent) — local-only repositories do not survive machine resets, tooling changes, or any form of collaboration
- a working knowledge of git sufficient to review diffs, revert changes, and branch when agents make structural edits

The remote repository is not optional infrastructure. It is what keeps the system coherent across time, across agents, and across contributors.

If you cannot review what changed and why, you cannot trust what the agent inherits next session.

This is not a best practice. It is a structural requirement. Without it, the context system will scale into chaos rather than compound into leverage.

---

## The Maintenance Contract

A context system without a maintenance contract decays faster than no system at all.

The contract is simple:

**Capture decisions at the layer they belong to, not after the fact.**

When an architectural boundary is established, it goes into Layer 1 immediately — not into a backlog, not into a comment, not into a chat thread.

**Prune when sessions start producing drift.**

Drift is the signal. When agent outputs start misaligning with intent, the context is stale. Investigate before adding new documents — the fix is usually removal, not addition.

**Promote patterns that recur.**

When the same constraint appears across multiple projects, it belongs in Layer 2. Patterns that survive two projects are ready to be abstracted. Do not wait for three.

**Let agents maintain context — but review every change.**

Agents can be used to enrich, restructure, and update context over time. That is part of the value. But every change an agent makes to a context repository is a commit to be reviewed, not a save to be trusted blindly.

The review step is what keeps the system honest.

---

## How This Operates in Practice

Before any session:

- the relevant project context (Layer 1) is attached
- the applicable shared layer (Layer 2) is referenced
- the personal operating layer (Layer 3) is loaded

The agent inherits the accumulated judgment of past decisions.

It does not start from a blank prompt. It starts from a structured position.

The session produces output. Some of that output reveals new constraints, confirms existing patterns, or surfaces decisions worth capturing.

At the end of the session, those insights are promoted into the appropriate layer — committed, reviewed, pushed.

The next session starts from a richer position than the last.

That is the compounding mechanism.

---

## How You Can Build This

You do not need to start with all three layers.

**Start with Layer 1, in one project.**

Create a folder in the repository. Add the non-obvious constraints — the ones an agent would violate without context. Add the architectural decisions with their reasoning. Add the guardrails.

Commit everything. Push it to a remote repository.

**Build Layer 2 when patterns start recurring.**

The second time you extract the same principle from two different projects, it belongs in a shared repository. Create it then, not before.

**Build Layer 3 when you notice that every session needs the same behavioral corrections.**

If you find yourself re-establishing the same working principles at the start of every session — the same defaults, the same constraints, the same decision framing — those belong in a personal layer. Document them once. Load them always.

---

## Why It Matters

The throughput difference between a session that starts with structured context and one that starts from scratch is not marginal.

The gap compounds with project complexity and with time.

Most AI productivity gains are prompt-level gains. They are real — but they reset. Every session, every new agent, every context switch returns to zero.

Context-level gains do not reset.

The architecture is the asset.

LLMs will get better at helping you build and maintain it.

The raw material — the decisions, the constraints, the judgment — is yours to capture or lose.

No one will build it for you.

Context is the edge. Everything else is infrastructure.
