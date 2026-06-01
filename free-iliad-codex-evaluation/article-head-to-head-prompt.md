# Use case 2 — the shared article prompt (head-to-head)

This is the **exact, one-shot prompt** I used for the second use case (writing an article). It is reproduced verbatim below.

**How it was produced.** I prepared it with Claude Code acting as my operating partner — after we discussed the approach, and after analyzing the codebase and extracting the real adoption numbers the article draws on. So the prompt is the *output of the thinking*, not a cold brief.

**How it was used.** The same prompt — deliberately **agent-agnostic** — went to two agents at once: a **Claude Code** agent (which already understands my harness) and the **codeX** CLI agent (which doesn't, so the prompt spells out the full procedure). Each worked in its **own git worktree and branch**, so both versions deploy as **separate Vercel previews** and can be read side by side. It was **one shot** — no iteration — to see where each agent lands on its own.

codeX's resulting write-up: [`codex-assessment/writing-assessment.md`](codex-assessment/writing-assessment.md).

---

## The prompt (verbatim)

```
You are writing ONE article for the boringsystems site, in a single shot — no
back-and-forth with me. Another agent is given this exact prompt in parallel;
you each work in your OWN git worktree and branch so both versions deploy as
separate Vercel previews and a reader can compare them side by side. Do not
touch the other agent's branch.

──────────────────────────────────────────────────────────────────────────
0) HEAD-TO-HEAD SETUP (do this first)
──────────────────────────────────────────────────────────────────────────
The site is the `boringsystems` repo (Astro 5, deployed on Vercel; every push
to a branch gets a preview URL). It lives at ./boringsystems in the workspace;
remote is github.com/omraneah/boringsystems.

Create an isolated worktree + branch named after yourself (use "claude" or
"codex" for <tool>):

  cd boringsystems
  git fetch origin
  git worktree add ../bs-<tool> -b article/ai-adoption-metrics-<tool> origin/main
  cd ../bs-<tool>
  npm install        # installs deps + the pre-commit hook

Work, commit, and push ONLY on that branch. Never push to main. Do NOT open a PR.

──────────────────────────────────────────────────────────────────────────
1) THE ARTICLE
──────────────────────────────────────────────────────────────────────────
Topic: how I MEASURED an AI-assisted engineering adoption — the metrics that
actually told the truth. This is the measurement companion to an existing case
file; it fills the gap neither existing piece covers (the case file is "how I
ran it"; the playbook is "the change-management bar"; this is "how I knew it
worked").

Lane: WRITING (a method/playbook essay), not a Work case file.

Thesis: most AI-adoption metrics are gameable vanity. Measure outcomes, proxy
them with the least-gameable signals, and never report throughput without a
quality guardrail beside it.

Cover, in your own structure:
- Leading vs lagging; why activity/input metrics get gamed and drift across
  contexts (PR count, time-to-first-commit, lines-of-code).
- The metrics I actually trusted:
  • scope-normalized cycle time — same sprint objectives delivered in half the
    time (2-week sprint → 1-week), measured post-stabilization;
  • deployment frequency measured AT PRODUCTION, not per-PR (re-fixing your own
    breakage shouldn't count as throughput);
  • change-failure via reverts/rollbacks (stayed near zero, most months zero);
  • escalations/interruptions-to-the-lead dropping (un-gameable autonomy proxy);
  • % of code authored by AI — reported as ACTIVITY, not achievement.
- The pairing law: a throughput metric only counts next to a quality guardrail
  (CI/CD, review) — you can't game one without the other moving.
- The two-phase read (do NOT conflate them): the SPEED gain was banked early
  (cycle halved, ~2–3× throughput); the QUALITY gain came later, at HELD
  velocity (rework roughly halved, rollbacks near zero, tests up). This year's
  story is quality, not a fresh speed-up.
- The honest ceiling: no human-performance baseline, so this was an experienced
  read, not a quantified benchmark. The rigorous version I'd build next: an
  agent vs a senior engineer on a KNOWN refactor (before/after), scored against
  the human result.

Aggregate evidence you MAY cite (these are already public in the case file):
>90% of new code AI-generated in ~14 months, 2–3× baseline velocity (5–10× on
greenfield), near-zero rollback, on a ~5-engineer team.

HARD DATA CONSTRAINT: stay at that aggregate altitude only. NO contributor
names, NO repo names, NO per-month tables, NO internal identifiers. If you don't
have a number, don't invent one.

Voice: technical, senior, executive register — short sentences, no fluff, no
"this will revolutionize your workflow." Match the existing boringsystems
technical voice (see docs/design-charter.md, docs/target-audiences.md).

Mandatory cross-links (≥2, both directions where possible):
- the case file:  /en/work/engineering-ai-adoption-on-a-live-platform
- the playbook:   /en/writing/the-ai-adoption-playbook-for-engineering-teams
First mention of any external company (e.g. Enakl) links to its URL.

Suggested titles (pick one; the slug is the kebab-cased title): "Measuring an
AI Coding Adoption Without Gameable Metrics" / "The AI-Adoption Metrics That
Survived Contact". Finalize the title before writing — fix the title if it makes
a bad slug.

──────────────────────────────────────────────────────────────────────────
2) BORINGSYSTEMS RULES YOU MUST FOLLOW (non-negotiable)
──────────────────────────────────────────────────────────────────────────
Files: create BOTH locales —
  src/content/writing-en/<slug>.md   and   src/content/writing-fr/<slug>.md
Frontmatter required: title, description, date (use today's date YYYY-MM-DD).
  - description must match the technical voice (no consumer-soft language).
- i18n is platform-native: every page lives under /en/ or /fr/; never hand-roll
  routing. The content-collection files above are all you create.
- FR is RE-VOICED, not translated — natural French, keep English jargon per
  docs/french-guide.md. Do not produce a literal translation.
- Cross-references are mandatory (the two links above, minimum).
- No build-time browser deps. No CSS transform: scale() for zoom.
- Slug = kebab-cased title; never rename a published slug.
SEO/JSON-LD/OG/hreflang are emitted by the layouts automatically — you don't
hand-write them, but don't break them.

──────────────────────────────────────────────────────────────────────────
3) SOP + SKILLS
──────────────────────────────────────────────────────────────────────────
The site has project skills that encode this SOP. If your agent can invoke
them (Claude Code can), run them:
  /article-capture     → confirm lane placement + structure before drafting
  /article-review      → pre-publish check (EN + FR together): voice, structure,
                         lane, FR register
  /cross-ref-check     → verify ≥2 valid cross-links, both directions, FR parity
  /french-audit        → FR voice/register check

If your agent CANNOT invoke these skills (codeX may not), do manually what they
enforce, using the rules in section 2 and the docs in boringsystems/docs/
(design-charter.md, target-audiences.md, french-guide.md, constraints.md):
lane = Writing; both locales; FR re-voiced; ≥2 cross-links both ways; voice
matches the technical target; title→slug clean.

──────────────────────────────────────────────────────────────────────────
4) BEFORE YOU COMMIT
──────────────────────────────────────────────────────────────────────────
Run and pass:  npm run build   (and npm run verify if present)
The pre-commit hook runs astro check + verify + astro build. It is the gate.
NEVER use --no-verify. Fix issues until it passes.

──────────────────────────────────────────────────────────────────────────
5) DELIVER
──────────────────────────────────────────────────────────────────────────
Commit on your branch with a clear message and push:
  git push -u origin article/ai-adoption-metrics-<tool>
Then report: the branch name, the file paths, and the Vercel preview URL (or
say a preview will appear once the branch is pushed). Do NOT open a PR; I open
those. One shot — make it your best single pass.
```
