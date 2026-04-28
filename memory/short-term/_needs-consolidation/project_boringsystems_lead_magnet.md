---
name: boringsystems lead-magnet infrastructure status
description: Lead-magnet capture pipeline is live on boringsystems; first asset (AI-Native Builder Starter Prompt) is not finalised — tracked in Linear BOR-16.
type: project
originSessionId: e464aaed-a5a0-4c1c-ac8b-19b9dd83adf6
---
Lead-magnet infrastructure on boringsystems is fully wired and deployed: typed registry at `src/lib/lead-magnets.ts`, reusable `<LeadMagnet />` component, `POST /api/lead-magnet` endpoint, Resend integration via `sendLeadMagnetNotification()` + `sendLeadMagnetConfirmation()`. The *Solo Founder* and *Operator's AI Stack* articles both embed it, pointing at a single asset slug: `ai-native-builder-starter-prompt`.

The asset itself — the actual starter prompt — is **not finalised**. The subscriber confirmation currently says "I'm finalising this prompt; you'll get it shortly" rather than delivering the real thing. A draft prompt + delivery options are captured in Linear card **BOR-16** under *Distribution & Market Exposure*, priority High.

**Why:** Ahmed chose to defer finalising the prompt so the infrastructure could ship without the asset content blocking it. The capture loop is what matters for validation — he can see who subscribes and what they're building before deciding the final shape of the deliverable.

**How to apply:** When Ahmed talks about the starter prompt, lead-magnet finalisation, or "I got a subscriber, what do I send them", point to BOR-16. When adding a *new* lead magnet (not finalising this one), the work is a single registry entry in `src/lib/lead-magnets.ts` — no code changes elsewhere. Verify this memory is still current before acting: if BOR-16 is marked Done, the asset has shipped; update or remove this memory.
