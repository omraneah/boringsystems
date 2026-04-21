# Architecture & Toolchain

**Status:** Living document — update when tools or integrations change  
**Date:** 2026-04-14

---

## How This Project Is Built

No code is written by hand. All development happens through prompts to Claude Code CLI, which reads, writes, and refactors the codebase directly. Prompts are dictated via Wispr Flow — voice-to-text feeds directly into the terminal session.

This means the effective workflow is: speak a requirement → Claude Code executes it → review the diff → commit.

---

## Stack

| Layer | Tool | Notes |
|---|---|---|
| Framework | Astro 5 | Static by default, SSR opt-in per route |
| Rendering | Hybrid (static + serverless) | All pages prerendered; API routes run as Vercel Functions |
| Styling | Vanilla CSS with design tokens | CSS variables in `global.css`, no framework |
| Content | Astro Content Collections | Markdown files in `src/content/` |

---

## Development Workflow

| Tool | Role |
|---|---|
| Claude Code CLI | All code authoring — no manual editing |
| Wispr Flow | Voice dictation for prompts |
| GitHub | Version control, branch-per-feature, PR review before merge |

Every change goes through a branch and a pull request. Nothing is committed directly to main. Claude Code operates on the branch; the human reviews and merges.

---

## Hosting & Deployment

| Tool | Role |
|---|---|
| Vercel | Hosting, automatic deployments, serverless functions |
| GitHub → Vercel | Push to any branch creates a preview deployment; merge to main deploys to production |
| Vercel Analytics | Page views, unique visitors, referrers, countries — no cookies, GDPR-compliant |
| Vercel Speed Insights | Core Web Vitals per page |

The Vercel project is linked to this GitHub repository. Deployment is fully automatic — no manual deploy steps.

---

## Domain

Bought and managed on Vercel. DNS is handled there.

**Domain:** `boringsystems.app`

---

## Email

| Tool | Role |
|---|---|
| Resend | Transactional email for contact form and article feedback |
| `contact@boringsystems.app` | Sending address (domain verified on Resend) |

Resend is the only outbound email dependency. It is fully encapsulated in `src/lib/mailer.ts` — swapping providers requires changes to that file only. See `docs/adr-001-contact-form.md` for the decision rationale.

---

## Environment Variables

Managed in Vercel project settings. For local development, copy to `.env.local` (gitignored).

| Variable | Purpose |
|---|---|
| `RESEND_API_KEY` | Resend authentication |
| `CONTACT_TO_EMAIL` | Destination inbox for contact and feedback emails |
| `CONTACT_FROM_EMAIL` | Sending address (`contact@boringsystems.app`) |

---

## Repository Structure (Key Paths)

```
src/
├── components/        ← Reusable UI components (including ArticleFeedback)
├── content/           ← Markdown articles, symmetric per language:
│                       case-files-en/, case-files-fr/,
│                       operating-playbooks-en/, operating-playbooks-fr/
├── layouts/           ← Page layouts (Base.astro, Article.astro)
├── lib/               ← Backend abstractions (mailer.ts, article-meta.ts)
├── pages/             ← Routes, strict two-language tree:
│                       en/* and fr/* mirror each other; api/* is language-neutral.
│                       No content lives at the root — astro.config.mjs 301-redirects
│                       `/`, `/case-files/*`, `/engineering`, etc. to `/en/...`.
└── styles/            ← Global CSS and design tokens

docs/                  ← Architecture decisions and toolchain documentation
```
