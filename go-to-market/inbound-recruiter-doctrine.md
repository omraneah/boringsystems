# Inbound Recruiter Doctrine

**Status:** Active — tested incrementally.
**Folder:** `go-to-market/`
**Airtable log:** Professional Transition → LinkedIn Inbound table

---

## Base reality

Most LinkedIn inbound from recruiters arrives at the wrong altitude or with the wrong mandate. The pattern across 24+ entries (Jan → May 2026): Founding Engineer, Lead Dev, Analytics Engineer, IC-heavy roles dressed up with inflated titles. ~80% misaligned on mandate, altitude, or both.

This is not a failure — it's the default state of the French/EU recruiter market operating against a profile they can't cleanly categorize.

## The objective

Inbound from recruiters serves two purposes:
1. **Market intelligence.** Every conversation — even a misaligned one — is a data point on what's being funded, what shapes buyers are procuring, what vocabulary is being used for senior technical roles in 2026.
2. **Positioning experiment.** Each reply is a chance to test language, redirect, and observe what the market hears.

The first purpose means: don't close the door immediately. The second means: don't waste the exchange on a flat rejection either.

## Default stance

**Engage, calibrate, redirect.** Not accept, not reject.

When an inbound lands:
1. Read the role and company with fresh eyes — is there a genuine altitude match, even partial?
2. If yes → pursue (per `credibility-map.md` Zone 1/2 criteria).
3. If no → reply in a way that (a) names the mismatch without harshness, (b) stays warm enough to keep the relationship for future signal, (c) opens the door toward the freelance pivot when relevant.

Do not ghost. Do not send a flat rejection. Both close a door that costs nothing to keep ajar.

## French cultural calibration — the most important section

Ahmed is German-trained in work mode and anglophone/Germanophone by professional formation. Direct, efficient, clean-close communication is the default register. In France, that register reads as cold, dismissive, or condescending — especially with recruiters who are doing their job in good faith.

The correction came from lived feedback: early exchanges (Jan–Feb 2026) were too direct — conversations pushed hard and closed that had residual value. The right calibration is not about being less honest — it is about register.

- **Keep:** clarity on the mismatch. Don't pretend the role is interesting when it isn't.
- **Soften:** the delivery. One sentence of genuine acknowledgment ("le profil est intéressant mais...") before the redirect costs nothing and changes the temperature of the whole exchange.
- **Avoid:** lecturing about altitude, signaling that their outreach was low quality, implying they don't know their market. Even when accurate, this leaves no door. In France especially, the relationship survives or doesn't based on the tone of the refusal, not the refusal itself.

A recruiter who feels respected in a no today is a recruiter who routes a relevant mandate next quarter.

## The freelance pivot

When there is a clear altitude mismatch on the CDI / full-time side but the company or context has genuine interest, introduce the freelance track.

**The frame to use:** not "fractional CTO" — that label carries associations that don't fit the shape. The offer is: a freelance mission of one to several months to help manage a complex project. Hands-on involvement is possible but it is not the point. The complexity is the critical dimension — holding the business, product, and engineering decisions simultaneously without losing the thread, as the LinkedIn bio captures.

This is not execution. It is managing complexity — the kind that requires judgment at the intersection of multiple domains, not headcount.

The pivot is useful when:
- The company is real and funded, with a concrete problem that requires decision altitude, not just delivery
- The problem involves meaningful complexity (cross-functional, multi-stakeholder, or technically ambiguous)
- The recruiter is internal or has direct access to the decision-maker — the closer to the brief, the higher the conversion probability

The pivot is NOT useful when:
- The role is pure IC delivery with no judgment ownership
- The company is at a stage where a short mission produces no lasting trace
- The recruiter is external without direct mandate access — they cannot route a reframed proposal. Use the exchange for market intelligence instead.

**Avoid "executive system builder."** No market-ready procurement bucket exists for it. Zero uptake across 5+ exchanges. Use "fractional CTO/CPO ou advisory sur un mandat complexe" when redirecting.

## Pre-call filter — two mandatory questions

Before booking any Head-of or CTO-tier call, surface these in the first reply:

1. **"Building from zero vs. scaling existing?"** — catches the 0→1 builder vs. 25→100 scaler mismatch.
2. **"Expected split between organizational governance and hands-on technical contribution?"** — catches the AI governance vs. AI practitioner mismatch.

One extra message before booking. Avoids calls that close negatively on fit that was visible pre-call.

**First-reply rule:** One qualifying question max. No condition lists (comp, stage, team size, salary belong in the conversation itself — not the opener). Listing conditions in a first reply reads as defensive in a French recruiter context.

## Reply register guide

**CDI mismatch, interesting company, French recruiter:**
Acknowledge the company or sector briefly. Name the mismatch on the role without editorializing. Introduce the freelance track in one sentence. Offer to speak.

**CDI mismatch, uninteresting company:**
Name the mismatch briefly. Stay warm. Leave the door open generically. No call needed.

**Good internal recruiter, real mandate, close-but-not-quite:**
Engage. Ask the two pre-call filter questions. One conversation is worth it even without clear fit — it is market intelligence.

**Low-quality external recruiter, generic or misleading outreach:**
Short, warm, minimal. No energy spent. No lecture given. Extract one market intel question ("what problem is the company trying to solve?"), then close warmly. Do not introduce the freelance pivot — external recruiters have no forwarding pathway.

## Testing the freelance pivot

The pivot is being tested conversation by conversation. Do not systematize before the pattern is clear. Each use is a data point on:
- Whether French recruiters know what to do with the reframe
- Whether "managing complexity" as the offer frame resonates or needs translation
- Whether internal vs. external recruiter quality predicts whether the pivot gets forwarded

Log what happens in the Airtable (Professional Transition → LinkedIn Inbound). Notes field: record whether the pivot was introduced and what the response was.

## Airtable — the live log

The Professional Transition base in Airtable (LinkedIn Inbound table) is the live interactive log where every recruiter inbound is tracked: date, role, company, recruiter quality, status, notes, reply. This is the ground truth for how the doctrine is performing in practice — the file you are reading now is the operating principle; the Airtable is the evidence.

When checking progress on any of the hypotheses in this doctrine (does the freelance pivot land? do French recruiters forward the reframe? does internal recruiter quality predict conversion?), read the Airtable directly. Use the Airtable MCP connector (`mcp__claude_ai_Airtable__search_bases` → search "Professional Transition" → LinkedIn Inbound table) to pull the latest records. The notes field is where Ahmed logs whether the pivot was introduced and what happened.

The file stays healthy as long as the Airtable is kept current. Read the Airtable, not this file, for current state.

## Division of labor — operator vs. agent

Ahmed (the operator) owns record creation and outcome tracking:
- Creating each record in Airtable as an inbound lands
- Filling the Initial DM field verbatim from LinkedIn
- Filling metadata: Date, Role, Company, Recruiter URL, Recruiter Quality, Status
- Logging call notes, outcome, and status changes after conversations happen

The agent (`/log-inbound` skill) owns the copy-paste relief:
- Ahmed pastes the full exchange dump (everything from his first reply onward)
- The skill parses it, finds the matching record by recruiter/company name, formats the thread chronologically, and writes it to the "Rest of Exchange" column
- Confirms in one line: recruiter name, role, company, and what was logged
- Stops and surfaces if the record can't be identified unambiguously — never acts on ambiguity

This split exists because LinkedIn copy-paste is mechanical friction, not judgment work. Ahmed's judgment stays on the Initial DM, the metadata, and what happens after calls. Future skills may take on more of this load — the pattern is: anything that is purely copy-paste-and-format is agent territory; anything that requires reading a situation belongs to Ahmed.

## Cross-references

- `credibility-map.md` — zone detection for live qualification once in a conversation
- `inbound-call-discipline.md` — how to run the call once booked
- `linkedin.md` — the positioning the freelance pivot grounds out in
- `strategy.md` Surface 5 — private DMs as positioning experiments
- Airtable: Professional Transition base → LinkedIn Inbound table (live log, read this for current state)
