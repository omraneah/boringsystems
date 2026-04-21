# French Voice & Translation Guide

The French content on boringsystems is not a translation layer. It is the same work, re-voiced in French, for readers who live and operate in French-speaking Europe.

If an article reads as machine-translated, it fails. The `french-audit` skill loads this file and flags violations at line level.

Personas (`senior-peer`, `operator`, `early-builder`) are defined in [`target-audiences.md`](./target-audiences.md). The register below applies across all three — persona changes the framing, not the register.

---

## The one rule

**Re-voice, don't translate.**

Work paragraph by paragraph, not sentence by sentence. Read the English paragraph, understand the argument, write the French paragraph the way a French operator would write it if they had the same thought.

Literal translation of English sentence structure into French is the single largest quality failure on the current site.

---

## Do NOT translate these terms

These are used as-is in professional French and translating them signals naïveté.

**Business / startup vocabulary.**
startup · early stage · bootstrap · scale · scaling · roadmap · sprint · backlog · framework · pitch · funding · SaaS · MVP · product-market fit · churn · burn rate · runway · pivot · go-to-market · onboarding · stakeholder · lead · deal · growth · retention

**Engineering / infrastructure.**
deploy · deployment · pipeline · serverless · container · runtime · edge · middleware · proxy · cache · caching · queue · stream · streaming · endpoint · API · SDK · CLI · repo · commit · branch · merge · rollback · rollout · feature flag · observability · logging · monitoring · tracing · backup · failover · throughput · latency · payload · timeout · webhook

**Product / design.**
UX · UI · design system · wireframe · prototype · dashboard · layout · frontend · backend · fullstack · A/B test · funnel · cohort

**AI / modern stack (since 2022).**
LLM · prompt · token · context window · fine-tuning · embedding · RAG · agent · MCP · multimodal

If a term appears in both lists and in French dictionaries, the do-not-translate rule wins. French operators use these words in English every day.

**Exception.** When explaining a term to `operator` persona at first introduction, a brief parenthetical gloss is acceptable: `serverless (exécution à la demande sans gestion de serveurs)`. Use it once per article, not every mention.

---

## Banned register phrases

These phrases mark an article as overly formal, academic, or machine-translated. Replace with direct French.

- **"Il convient de noter que"** → just state the thing.
- **"Dans le cadre de"** → "pour", "lors de", or restructure.
- **"Force est de constater"** → state the observation.
- **"À l'heure actuelle"** → "aujourd'hui" or drop entirely.
- **"En effet"** as sentence-opener → usually redundant; delete.
- **"Il est important de"** → delete and just say the thing.
- **"Ainsi"** overused → use once per article maximum.
- **"De ce fait"** → "donc".
- **"Au niveau de"** as vague preposition → use the specific preposition the sentence needs.
- **"Par ailleurs"** as filler transition → usually deletable.
- **"Permettre de + infinitif"** chains → restructure into direct action verbs.
- **"Mettre en place"** as default verb → use a specific verb (déployer, lancer, installer, créer).

---

## Register rules

- **Direct.** Same register as the English version. Not formal, not casual — operator-to-operator.
- **Short sentences.** French has a cultural tendency toward long, comma-spliced sentences. Resist. Break them.
- **Active voice default.** Passive constructions (être + participe passé) appear three times more often in bad French tech writing than they should. If the subject of the action is known, make it the subject of the sentence.
- **"On" is allowed.** Informal "on" for "we/one" is appropriate for operator-to-operator voice and sounds less stiff than "nous" in most contexts. Use "nous" when collective ownership is the actual point.
- **No filler adverbs.** "Évidemment", "clairement", "manifestement", "véritablement" — cut on sight unless the sentence breaks without them.
- **No hedging chains.** "Il semblerait peut-être que l'on puisse envisager" → pick one.
- **Contractions.** Standard French contractions (du, des, au, aux) as normal. No invented anglicism contractions.

---

## Length accounting

French runs approximately **20% longer** than English at the prose level. Implications:

- **Headlines.** Do not translate — rewrite. A French headline that fits the same visual space as the English one is almost always better than a faithful translation.
- **Navigation labels and buttons.** The nav component and button text must fit in French without wrapping on desktop. If the English label is "Case Files" (10 chars), the French needs to be comparable — "Études de cas" (13 chars) works; "Études de cas techniques" breaks the layout.
- **Card summaries.** Card grids are laid out against English character counts. If the French summary would overflow, cut it, don't wrap.
- **CTAs.** Same rule — rewrite, don't translate.

The `french-audit` skill flags paragraphs where FR exceeds EN by more than 25% as candidates for compression.

---

## Anglicisms: which are fine, which are not

**Fine.**
- All the do-not-translate list above.
- Mixing English technical terms into French sentences is natural and expected: *"Le pipeline de déploiement tombe si le webhook ne répond pas dans les 30 secondes."*

**Not fine.**
- False cognates forced into French meaning: "éventuellement" means "possibly", not "eventually".
- English sentence structure: *"C'est quelque chose que nous faisons"* for "It's something we do" is translated English, not French. Native French: *"On le fait."*
- English punctuation habits: French uses non-breaking spaces before `: ; ? !` and French quotation marks `« »` in formal prose. For operator-to-operator prose on this site, standard `" "` is acceptable — but pick one per article and stay consistent.

---

## Review checklist

Before marking a French article ready, the `french-audit` skill checks:

1. No do-not-translate term was translated.
2. No banned register phrase survived the draft.
3. No paragraph exceeds EN length by >25% without justification.
4. Headlines, nav labels, CTAs were rewritten, not translated.
5. Active voice dominates; passive constructions are deliberate.
6. Sentences that exceed 25 words without a strong reason are flagged for splitting.

The skill outputs a structured list. Ahmed decides per flag — this is not auto-fix.
