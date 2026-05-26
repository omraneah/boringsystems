---
name: log-inbound
description: Logs a LinkedIn recruiter exchange to the Airtable LinkedIn Inbound table. Ahmed creates the initial record (Initial DM + metadata fields). This skill handles the Rest of Exchange update — Ahmed pastes the full exchange dump, the skill parses it, finds the matching record, and writes the formatted conversation thread. Triggered when Ahmed pastes an exchange and says "log this", "log exchange", "log inbound", or similar.
model: sonnet
effort: low
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash
---

Logs the "Rest of Exchange" column for a LinkedIn recruiter inbound record in Airtable. Fast, mechanical. Ahmed owns the record creation; this skill owns the copy-paste relief.

Do not announce the skill invocation. Just do the work.

## Division of labor

Ahmed (the operator) owns:
- Creating the record in Airtable (LinkedIn Inbound table)
- Filling the Initial DM field verbatim from the LinkedIn message
- Filling metadata fields: Date, Role, Company, Recruiter URL, Recruiter Quality, Status, etc.
- Logging outcomes after calls (notes, outcome field, status updates)

This skill owns:
- Receiving the full exchange paste from Ahmed
- Parsing it into structured chronological format
- Finding the correct Airtable record
- Writing the Rest of Exchange field

## When to invoke

Auto-fire when Ahmed pastes a LinkedIn exchange and signals logging:

- "log this"
- "log exchange"
- "log inbound"
- "update the exchange"
- "add the rest of the exchange"
- Any phrasing that combines a paste with an intent to log it to Airtable

## Airtable coordinates

- Base: apphid9XHlTRG7lnU (Professional Transition)
- Table: tblqQjt9OyIMvaSGG (LinkedIn Inbound)
- Rest of Exchange field: fldvA7Fi2vtY1KQew
- Initial DM field: fldONnqgStJBp3OX7 (read-only for this skill — used for record matching only)

## Steps

1. **Parse the paste.** Extract recruiter name and company from the first message in the dump. This is the locator — it must match what Ahmed already entered in the Initial DM field of an existing record.

2. **Find the record.** Two-pass lookup:
   - **Pass 1:** Full-text search via `mcp__claude_ai_Airtable__search_records` on recruiter name and/or company name. Works when those strings appear in indexed fields (Initial DM, Role, Company).
   - **Pass 2 (if Pass 1 returns zero):** Ahmed may provide a LinkedIn URL. Filter on the Recruiter field (`fldiv1EkiSanRhvZC`) using `mcp__claude_ai_Airtable__list_records_for_table` with a `contains` filter on the URL slug. Recruiter names are not always stored in indexed fields — the URL is the reliable fallback.
   - Ask Ahmed for the LinkedIn URL if Pass 1 fails and no URL was provided.
   - If zero matches after both passes: stop, say so.
   - If multiple matches: stop. Surface the candidates and ask Ahmed which one.
   - Never act on ambiguity.

3. **Parse the Rest of Exchange.** Everything from Ahmed's first reply onward. Format:
   ```
   Name (HH:MM): message text

   Name (HH:MM): message text

   → Outcome (e.g. "Call booked: Monday 11h30", "No reply", "Declined")
   ```
   - Use the actual names as they appear in the conversation
   - Preserve timestamps where visible; omit if not present
   - Add an arrow outcome line at the end summarizing the result if discernible from the exchange

4. **Update the record.** Write the formatted block to the Rest of Exchange field (`fldvA7Fi2vtY1KQew`) using `mcp__claude_ai_Airtable__update_records_for_table`.

5. **Confirm.** One line:
   > Updated — [Recruiter name] / [Role] @ [Company]. [Brief summary of what was logged, e.g. "3 messages, call booked Monday 11h30."]

## Output shape

One confirmation line only. No recap of the full exchange. No suggestions. Example:

```
Updated — David PELISSIER / Senior Vibe Coder Evangelist @ Free. 4 messages, call booked Monday 11h30.
```

## Guardrails

- **Never create records.** Record creation is Ahmed's job. If no matching record exists, stop and say so.
- **Never overwrite Initial DM.** That field is operator-owned. Read it for matching only.
- **Never act on ambiguity.** Zero or multiple matches → surface and stop.
- **Never update metadata fields** (Status, Outcome, Recruiter Quality, Notes). Those are Ahmed's domain.
- **Single record scope.** One invocation = one exchange = one record update.
