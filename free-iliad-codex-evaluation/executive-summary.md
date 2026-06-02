# codeX — Executive Summary

External expert read from using codeX inside my own working setup across three short sessions. Detail and method in `methodology-and-findings.md`.

**What's good**
- Interaction quality holds up against the frontier tools I use daily — on what I tested.
- A credible everyday working partner; runs cleanly inside a sophisticated harness.
- The open-source engine is good enough to earn real use by strong engineers.

**To re-explore (not yet conclusive)**
- Sustained code generation under load — the gating unknown; light in this window.
- The IDE plugin — likely most engineers' actual entry point; untested here.
- Article authoring under the harness, and harder limits.

**What's shaky / watch**
- Model behavior — the gap that matters most: vs a frontier model (Opus 4.8), a higher tendency to invent detail (fake precision like a "10–18 hour" estimate it never built against; an invented "Mistral" hosting claim in a file that elsewhere names the model Qwen), to cut corners (producing the *shape* of a thorough assessment before doing the work that makes it true), and to over-assert points never discussed (marking a tool's hooks "✅ Native" untested). Compounds into drift over long, judgment-dense sessions. It self-corrected when explicitly asked to critique its own prior output — but does not catch it unprompted.
- Routing: the cheap-vs-strong-model boundary is invisible mid-task; mis-routing is a real adoption-killer.
- Governance on the open-source harness is advisory, not enforced (no native pre-action hooks).
- Self-hosted trails the frontier on hard reasoning; "no per-token cost" is not "free."

**What I recommend**
- Build the harness/governance layer — indexed context, shared rules, a few high-leverage skills. It's the compounding, model-portable asset; the model choice churns.
- Plan two tiers: codeX as substrate for volume, a frontier tool as burst capacity for judgment-dense work, with routing as a tool-level default. The model-behavior gap above is the reason the tiering is non-optional, not a nicety.
- Run codeX with tighter verification loops than a frontier tool: earlier "prove it" gates, smaller scope per session, test-result-before-synthesis. This is a governance default, not operator babysitting.
- Prove it on one willing team for a quarter — instrumented, with a go/no-go gate.

## Strategic read — how I'd play this (if I joined)

<!-- TODO (verify tomorrow, after use cases 2–3: article + code tests): confirm this strategic read still holds end-to-end. If this comment is still here, it hasn't been double-checked yet — remove it once it has. -->

A **barbell strategy** for agentic coding, with one owned layer underneath both ends.

- **Frontier end** — state-of-the-art agents from the labs (Claude Code, Codex, others later), bought and used where each engineer is most effective: CLI, IDE, or emerging surfaces like the Codex desktop app. Preferences are still crystallizing, so don't over-fix them. Afford more than one where the budget earns it — a small group tests and curates, the rest choose.
- **Internal end** — an open-source model hosted and governed in-house, carrying the ~80% of high-volume work that doesn't need frontier reasoning, with real control over cost and where it's deployed. It will always lag the frontier; that lag is exactly *why* you run a barbell rather than a single bet.
- **The owned layer underneath both** — an **agent-agnostic harness** (context, rules, skills, governance), built and governed internally by the team that owns codeX, working identically across the internal model and any frontier model added (Anthropic, OpenAI, others). The harness is the asset; the models are interchangeable.

**The lever is governance + incentives + fit — not the tool.** The tool is good; adoption is gated by governance, how it fits the current workflow, and the context teams actually have. So:
- **Quality guardrails** — CI/CD, review, management — so velocity never costs quality. An example of governance that cuts model-drift and hallucination friction, shipped as a review skill run against an architecture corpus: [architecture governance](https://boringsystems.app/en/work/architecture-governance).
- **Incentives to use both, tied to outcomes** — output, quality, adoption — not tool-for-tool's-sake. **No forcing**; adoption is earned, with strong internal ownership of the governance layer.
- **Cost + usage monitoring on both** — token spend especially — with routing that keeps frontier spend on the work that earns it.

**How I'd find the real blocker:** ask and observe, quantitative *and* qualitative. Quantitative — token usage, % of code authored by AI. Qualitative — talk to managers and engineers, observe them, run shadow-coding and peer-review sessions to see what actually happens.

**Then: adoption, adoption, adoption** — sequenced team by team, bit by bit; it takes time. The concrete first step is one willing team for a quarter (one indexed-context skill, one routing default, a metric, a go/no-go gate) — not a company-wide rollout. How I'd accompany the change: [engineering AI adoption on a live platform](https://boringsystems.app/en/work/engineering-ai-adoption-on-a-live-platform).

**Net:** whether Free builds or buys, this positions the group for what's coming — with strong ownership of the governance layer it builds and the workflow it enables.

**Honest limit**
- A short, time-boxed exploration with no human-performance baseline — so this is a qualitative, intuition-based read, not a quantified benchmark. The quantifiable version (agent vs senior engineer on a known refactor) is the next step I'd build, not something I claim here.

---

*Produced with AI and steered by me by voice — dictated via Wispr Flow, not typed. This summary and the methodology document were done with Claude Code (where I hold this context most fully); the three use-case deliverables were done with codeX, in my own working flow.*
