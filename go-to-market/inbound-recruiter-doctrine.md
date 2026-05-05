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

## Register calibration — French vs. international

**~80% of inbound is French companies, in French. ~20% is international** (Germany-based or international firms in France), in English.

**French (80%):** Ahmed's natural direct register reads as cold or dismissive in this context. The correction: one sentence of genuine acknowledgment before the redirect. Don't pretend the role is interesting — but soften the delivery. Don't lecture about altitude or signal that the outreach was low quality. The relationship survives or doesn't based on the tone of the refusal.

**International (20%):** Ahmed's natural direct register is appropriate — especially for German companies, where efficiency and clarity are expected. No need to add warmth padding. Be direct, be clear, close cleanly.

The language of the exchange (French vs. English) is the signal for which register to use. Both tracks apply the same substance — honesty on fit, no door slammed — with different packaging.

## Inbound outcomes — what to aim for

Inbound from recruiters is a full-time channel. Companies hiring recruiters want a full-time hire. Do not pitch fractional or freelance through this channel — that offer goes outbound, directly to decision-makers, not through a recruiter who was briefed on a CDI.

**The three outcomes, in order of priority:**

1. **Pursue** — genuine altitude match. Engage, run the pre-call filter, book the call.

2. **Light contract mention** — role scope seems confused or uncommitted on the company side (unclear mandate, undecided between senior IC and leader, role not yet published). A one-sentence mention that a contract engagement could be a lower-risk way to validate fit. This is not a pitch — it is an option offered once, when the company itself seems unsure. Only worth doing with an internal recruiter who can actually carry the message.

3. **Intel + warm close** — clear mismatch, especially with an external recruiter. Extract one useful question ("what problem is the company trying to solve?"), close warmly, move on. No alternative offer. The recruiter cannot route a reframed proposal and it is not worth the energy.

**Avoid "executive system builder."** No market-ready procurement bucket exists for it. Use plain language about the mandate when redirecting.

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

## Tracking

Log every exchange in Airtable (Professional Transition → LinkedIn Inbound). Notes field: what outcome was aimed for, what happened. The contract mention (outcome 2) is worth tracking when it occurs — note whether the recruiter was internal or external and whether it got forwarded.

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
