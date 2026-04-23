# boringsystems

Ahmed Omrane's personal site. Engineering-leadership writing, case studies, live builds, and long-living playbooks.

Built with [Astro 5](https://astro.build) + MDX. Deployed on [Vercel](https://vercel.com). 100% AI-authored code (Claude Code via voice dictation) — architecture and judgment decisions are human.

Live site: **[boringsystems.app](https://boringsystems.app)**

---

## The four-lane taxonomy

The site is organized around four content lanes. Each lane is a **content type**, not an audience segment. Every reader (founders, operators, technical peers, sponsors) ultimately sees every lane — the lane tells you *what kind of piece* this is, not *who it's for*.

| Lane | URL | Collection | What goes here |
|---|---|---|---|
| **Writing** | `/{lang}/writing/` | `src/content/writing-{en,fr}/` | Thinking pieces, decision guides, frameworks, tactical advice. The questions founders/operators/builders face — framed, diagnosed, answered. **Primary lane. Most new content lands here.** |
| **Work** | `/{lang}/work/` | `src/content/work-{en,fr}/` | Case studies from past engagements. What got built, under what constraint, with what trade-offs. Proof — not testimonials. |
| **Building** | `/{lang}/building/` | `src/content/building-{en,fr}/` | Live AI-native work. Current builds shown in progress — boringsystems itself, portfolio apps, Claude skills, lead-magnet artifacts. Evidence the method works in 2026. |
| **Archive** | `/{lang}/archive/` | `src/content/archive-{en,fr}/` | Long-living playbooks and principles. Doctrine layer. Slower to change; meant to be returned to. |

### Primary navigation order

**Writing → Work → Building → Archive**, then About. Writing is first because it's the conversion surface — cold visitors land there and find a decision guide that speaks to them. Work and Building supply credibility; Archive is reference.

### Voice targets (per-piece calibration)

An article's **voice target** is a drafting decision, separate from its lane. Two voice targets live in `docs/target-audiences.md`:

- `technical` — CTOs, VPs of Engineering, staff engineers, technical founders.
- `builder` — entrepreneurs, intrapreneurs, solopreneurs, non-technical founders, operators.

Any piece in any lane can be addressed to either target. The writer picks one per piece; voice target does not appear in frontmatter. The `article-review` skill asks for it as a review input.

---

## Where does a new article go?

Walk this decision tree in order. First match wins.

1. **Retrospective of real past work Ahmed did for someone?** → **Work**.
2. **Live commentary on something Ahmed is building right now?** → **Building**.
3. **Long-living principle / operating playbook?** → **Archive**. (New archive pieces are rare — most new content is not Archive.)
4. **Everything else** — thinking pieces, decision guides, frameworks, diagnosis of a question a founder/operator faces. → **Writing** (default).

The `/article-capture` skill walks this decision tree and refuses to proceed if lane is ambiguous. `docs/target-audiences.md` has the authoritative version.

---

## Repository structure

```
src/
├── components/        Reusable UI: ArticleCard, ArticleFeedback, LeadMagnet, Nav, Footer
├── content/           Markdown + MDX content, one collection per lane × locale:
│                       writing-{en,fr}/     writing-lane articles
│                       work-{en,fr}/        case studies
│                       building-{en,fr}/    live builds
│                       archive-{en,fr}/     playbooks (subfolder-grouped; URLs stay flat)
│                     Folder name = URL path. File basename = URL slug.
│                     Any subfolders in between are grouping-only (see docs/constraints.md).
├── layouts/           Base.astro (full chrome), Article.astro (article reader view)
├── lib/               mailer.ts, article-meta.ts, lead-magnets.ts, i18n.ts, http.ts
├── pages/             Strict two-language routing:
│                       en/{writing,work,building,archive,about}/*
│                       fr/{writing,work,building,archive,about}/*
│                       api/v1/*    (language-neutral API routes)
└── styles/            Global CSS + design tokens

docs/                  Architecture decisions + editorial doctrine
scripts/               verify-structure.ts (pre-commit structural-integrity gate)
```

### Folder = URL = collection (with one subtlety)

The **first-level folder** under `src/content/` is the URL lane. The **file basename** is the URL slug. Any subfolders between them are grouping-only — they do not appear in URLs.

Canonical example: archive playbooks are grouped on disk as
```
src/content/archive-en/operating-playbooks/series-1-foundations/s1-p0-how-we-run.md
                      └────── subfolder tree ───────────────────┘ └── URL slug ──┘
```
and render at `/en/archive/s1-p0-how-we-run`.

`scripts/verify-structure.ts` enforces basename uniqueness per collection so grouping can't cause URL collisions. Every `[slug].astro` route uses `entry.slug.split('/').pop()` to extract the basename.

Full rule: `docs/constraints.md` § Content.

---

## Editorial doctrine

| Doc | What it covers |
|---|---|
| `docs/target-audiences.md` | Voice targets (`technical`, `builder`), lane-placement decision tree, writing implications per voice target. |
| `docs/design-charter.md` | Voice, typography, color discipline, per-lane layout conventions, anti-patterns. |
| `docs/french-guide.md` | FR voice rules. "Re-voice, don't translate." English-default for technical/business terms. |
| `docs/constraints.md` | Project-level "never do X" list: build/deploy invariants, routing, content rules, dependencies. |
| `docs/adr-002-home-selection.md` | Home-page selection semantics — `featured`, `highlight`, `order` flags and their surfaces. |
| `docs/adr-003-enforcement-tier.md` | Local-first enforcement doctrine — no CI, pre-commit hook is the gate. |
| `docs/architecture-and-toolchain.md` | Living doc — stack, hosting, deployment, env vars. |
| `docs/adr-001-contact-form.md` | Original decision rationale for Resend + the contact form. |

---

## Project skills

Invokable via `/` in Claude Code. These are project-scoped (live in `.claude/skills/`).

| Skill | When to use |
|---|---|
| `/article-capture` | After a deep conversation that produced publishable insight. Drafts a Linear card — critically, enforces the lane placement decision. |
| `/article-review` | Before publishing any article (EN + FR together). Loads design-charter + target-audiences + french-guide, produces a pass/flag report. |
| `/french-audit` | After drafting or updating FR content. Flags over-translation, banned register, over-length paragraphs. |
| `/verify-home` | After any change to home layout, redirects, or frontmatter flags (`highlight`/`featured`/`order`). Smoke-tests the rendered site. |
| `/check-constraints` | Before writing structural code (i18n, routing, redirects, build pipeline, SEO metadata, layout changes). Scans `constraints.md` for rules that apply. |
| `/audit-fix` | When `npm audit` shows high/critical vulns, or the pre-push hook blocks on audit findings. |

Cross-project skills (`/commit`, `/pr`, `/log-decision`, `/wrap-session`, `/session-pulse`, `/arch-review`) are available from any working directory.

---

## Development

```bash
npm install           # Install deps + pre-commit hook (via simple-git-hooks)
npm run dev           # http://localhost:4321
npm run build         # Production build — must pass before commit
npm run verify        # Structural-integrity script (also runs in pre-commit)
```

### Pre-commit hook (local-first enforcement)

Every commit runs: `astro check` → `npm run verify` (structural invariants) → `astro build`. All three must pass. `--no-verify` is **forbidden** — the hook is the merge gate. No CI, no GitHub Actions; see `docs/adr-003-enforcement-tier.md` for the principle and upgrade trigger.

### Pre-push hook (dependency audit)

`npm audit --audit-level=high` must exit clean before a push is accepted. Fix path: `npm audit fix` → `overrides` for transitive patches → documented acceptance in `docs/adr-003-enforcement-tier.md` for non-exploitable CVEs. Never `--no-verify`.

### Deployment

Automatic on push to `main` via Vercel's GitHub integration. Never push to `main` directly — feature branch + PR. Claude pushes; Ahmed opens the PR.

---

## Stack

| Layer | Choice |
|---|---|
| Framework | Astro 5 (static + SSR opt-in per route) |
| Content | Astro Content Collections (Markdown + MDX) |
| Diagrams | mermaid.js (client-side render from a custom remark plugin — no build-time browser deps) |
| Hosting | Vercel + Vercel Functions for API routes |
| Email | Resend (contact form, article feedback, lead magnets) — encapsulated in `src/lib/mailer.ts` |
| Analytics | Vercel Analytics + Speed Insights |
| Typography | Playfair Display (body), IBM Plex Mono (code), Inter (UI chrome) |
| Color tokens | CSS custom properties in `src/styles/global.css` |

Full stack detail: `docs/architecture-and-toolchain.md`.

---

## i18n

Native Astro i18n with strict `/en/` and `/fr/` prefixes. Root `/` → `/en/` via 301. No other redirects exist — folder = URL.

Every article exists in both locales. FR is **re-voiced**, not translated — see `docs/french-guide.md`. The `/french-audit` skill enforces it.

---

## Contributing (for future-Ahmed or collaborators)

1. Start every content session by identifying the lane (see decision tree above). If in doubt, run `/article-capture`.
2. Place the file under `src/content/<lane>-{en,fr}/`. Mirror the EN and FR files. Mandatory `date:` frontmatter except in Archive.
3. Write per `docs/design-charter.md` (voice, structure) and `docs/target-audiences.md` (voice-target calibration).
4. For FR, re-voice paragraph-by-paragraph per `docs/french-guide.md`. Keep English technical/business terms in English.
5. Run `/article-review` before committing. Run `/french-audit` if FR was touched.
6. Commit via the pre-commit hook. Push and open the PR through Ahmed.

No edits to this README or to `docs/` files without a reason worth writing down.
