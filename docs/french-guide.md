# French Voice & Translation Guide

The French content on boringsystems is not a translation layer. It is the same work, re-voiced in French, for readers who live and operate in French-speaking Europe.

If an article reads as machine-translated, it fails. The `french-audit` skill loads this file and flags violations at line level.

Personas (`technical`, `builder`) are defined in [`target-audiences.md`](./target-audiences.md). The register below applies across both — persona changes the framing, not the register.

---

## The two rules

**1. Re-voice, don't translate.**

Work paragraph by paragraph, not sentence by sentence. Read the English paragraph, understand the argument, write the French paragraph the way a French operator would write it if they had the same thought.

Literal translation of English sentence structure into French is the single largest quality failure on the current site.

**2. Default to English for technical and business terms.**

The bar to translate an English technical or business term is high. The default is to keep it in English. This applies across **both audiences** — `technical` and `builder`:

- Engineers in France work in English-tinted French every day. Code, tooling, frameworks, practices, and roles are discussed in English — they do not think in `cadre de travail`, they think in `framework`.
- Entrepreneurs, intrapreneurs, and builders in France are English-savvy. They read English tech and business content daily. They expect to see `startup`, `MVP`, `pipeline`, `SaaS`, `onboarding`, `growth`, `product` in their original form.

Translating these terms when they don't need it makes the content feel like it was written for a general audience rather than a professional one — and both boringsystems audiences are professional. The do-not-translate lists below are **illustrative, not exhaustive**. When in doubt: keep the English term. The only time to translate is when the French has genuine, common professional usage that's stronger than the English (rare for the vocabulary this site uses).

---

## Do NOT translate these terms (illustrative list)

These are used as-is in professional French and translating them signals naïveté. **The list is not exhaustive** — it anchors the pattern. Any English technical or business term with common professional usage follows the same rule, even if not listed here. When in doubt, keep English.

**Business / startup vocabulary.**
startup · early stage · bootstrap · scale · scaling · roadmap · sprint · backlog · framework · pitch · funding · SaaS · MVP · product-market fit · churn · burn rate · runway · pivot · go-to-market · onboarding · stakeholder · lead · deal · growth · retention

**Disciplines and role nouns.**
engineering · product · marketing · sales · operations · growth · design · branding · HR · finance

These are the disciplines a company is organized around. When they appear as labels, categories, page titles, nav items, or job descriptions, keep them in English — translating them signals naïveté. This is why the site's lane labels (`System Design`, `Builders`, `Technology`, `Archive`) stay in English across both locales.

The same rule applies when these nouns appear in prose as the name of a function ("l'équipe engineering", "le responsable product"). Translate them only when they are used as generic common nouns in a non-company context (e.g. `ingénierie mécanique` for mechanical engineering as a field of study).

**Engineering / infrastructure.**
deploy · deployment · pipeline · serverless · container · runtime · edge · middleware · proxy · cache · caching · queue · stream · streaming · endpoint · API · SDK · CLI · repo · commit · branch · merge · rollback · rollout · feature flag · observability · logging · monitoring · tracing · backup · failover · throughput · latency · payload · timeout · webhook

**Product / design.**
UX · UI · design system · wireframe · prototype · dashboard · layout · frontend · backend · fullstack · A/B test · funnel · cohort

**AI / modern stack (since 2022).**
LLM · prompt · token · context window · fine-tuning · embedding · RAG · agent · MCP · multimodal

If a term appears in both lists and in French dictionaries, the do-not-translate rule wins. French operators use these words in English every day.

**Exception (use sparingly).** When introducing a term that is genuinely niche even for an English-savvy audience (rare), a brief parenthetical gloss is acceptable on first mention only: `serverless (exécution à la demande sans gestion de serveurs)`. Do not gloss common terms — `startup`, `pipeline`, `framework`, `MVP`, `SaaS`, `product`, `engineering`, `onboarding` never need a gloss. Both audiences know them.

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

**Fine (and expected).**
- All the do-not-translate list above, and any English technical or business term the site uses.
- Mixing English technical terms into French sentences is natural and expected. Examples that should read as perfectly normal professional French:
  - *"Le pipeline de déploiement tombe si le webhook ne répond pas dans les 30 secondes."*
  - *"L'équipe product valide la roadmap avant le prochain sprint."*
  - *"Un MVP pour une startup early-stage doit tenir sans serverless complexe."*
  - *"Le growth dépend du onboarding plus que du funnel lui-même."*
- If the sentence reads naturally when an English term stays in English, keep it. Do not "fix" it.

**Not fine.**
- False cognates forced into French meaning: "éventuellement" means "possibly", not "eventually".
- English sentence structure: *"C'est quelque chose que nous faisons"* for "It's something we do" is translated English, not French. Native French: *"On le fait."*
- English punctuation habits: French uses non-breaking spaces before `: ; ? !` and French quotation marks `« »` in formal prose. For operator-to-operator prose on this site, standard `" "` is acceptable — but pick one per article and stay consistent.

---

## Review checklist

Before marking a French article ready, the `french-audit` skill checks (in order of severity):

1. **Over-translation (blocker)** — any English technical or business term that was translated when it shouldn't have been. This is the single most common quality failure. The do-not-translate lists above anchor what to look for, but the skill flags any translated term that has common English-language professional usage, even if not listed.
2. **Banned register phrases (warning)** — every occurrence flagged.
3. **Over-length paragraphs (warning)** — FR paragraph >25% longer than EN.
4. **Headlines / nav labels / CTAs** — these must be *rewritten*, not translated.
5. **Passive voice clusters (nit)** — paragraphs dominated by passive constructions.
6. **Long sentences (nit)** — >25 words without a strong reason.

The skill outputs a structured list. Ahmed decides per flag — this is not auto-fix. **The skill never flags an English term left in English as a missing translation** — that is the desired behavior, not a violation.
