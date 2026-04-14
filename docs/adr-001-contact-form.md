# ADR-001 — Contact Form: Infrastructure Decisions

**Status:** Accepted  
**Date:** 2026-04-14

---

## Context

The site is a static Astro project hosted on Vercel with no backend. A minimal reach-out form was added to the homepage to capture interest from visitors — email address and free-text message, forwarded to a personal inbox. No database, no user accounts, no submission history required at this stage.

---

## Decision 1 — Vercel Serverless Function (not a third-party form service)

### What was considered

| Option | Notes |
|---|---|
| Formspree / Web3Forms | Zero setup, free tier, but form data passes through a third-party — no control over what they do with it, no swap path if pricing changes |
| Vercel Serverless Function | One API route in the repo, full control, stays within the existing hosting setup |
| `mailto:` link | Zero infrastructure, but unreliable on mobile and no consistent UX |

### Why Vercel

The site already runs on Vercel. Adding a single serverless function costs nothing extra, keeps all infrastructure in one place, and avoids a third-party service handling visitor data. The Astro adapter (`@astrojs/vercel`) supports a hybrid model: all pages remain statically generated, only the API route (`/api/contact`) runs as a function. No architectural change to the rest of the site.

### Trade-off accepted

A third-party form service would have been faster to set up initially. The added 30 minutes of setup here buys full ownership, no vendor dependency for the form submission path, and a clean swap path if the email provider changes.

---

## Decision 2 — Resend as the Email Provider

### What was considered

| Option | Notes |
|---|---|
| Resend | Developer-first transactional email, clean API, 3,000 emails/month free, good deliverability |
| SendGrid | Enterprise-focused, heavier setup, free tier more restrictive and declining |
| Postmark | Excellent deliverability, no free tier |
| Mailgun | Solid option, slightly more complex setup for the same outcome |
| AWS SES | Powerful but requires AWS account, identity verification, and more configuration overhead |
| Nodemailer + SMTP | Requires managing SMTP credentials or OAuth — fragile for a personal site |

### Why Resend

- **Single API call** — the entire integration is one function. The provider is fully encapsulated in `src/lib/mailer.ts`.
- **Free tier sufficient** — 3,000 emails/month, 100/day covers any realistic volume for this site at this stage.
- **`reply-to` support** — emails arrive in the inbox with the visitor's address as reply-to, enabling direct replies without any additional tooling.
- **Deliverability** — transactional email APIs handle deliverability infrastructure (SPF, DKIM, DMARC reputation) that raw SMTP does not.
- **No maintenance** — no credentials to rotate, no server to manage.

### Trade-off accepted

Resend is a third-party dependency for the sending path. This is mitigated by the isolation in `mailer.ts` — swapping providers requires changes to one file only, with no impact on the API route or the form.

---

## Current Configuration

| Env Var | Purpose | Current Value |
|---|---|---|
| `RESEND_API_KEY` | Authenticates with Resend | Set in Vercel |
| `CONTACT_TO_EMAIL` | Destination inbox | Set in Vercel |
| `CONTACT_FROM_EMAIL` | Sending address | `contact@boringsystems.app` |

### Domain verification

`boringsystems.app` is verified on Resend. All three env vars are required — the function throws if any is missing.

---

## File Structure

```
src/
├── lib/
│   └── mailer.ts          ← only file that knows about Resend
└── pages/
    └── api/
        └── contact.ts     ← serverless function, input validation, calls mailer
```

To swap email providers: replace the internals of `mailer.ts`. The `ContactPayload` interface and `sendContactEmail` function signature stay the same — the API route and the form are unaffected.
