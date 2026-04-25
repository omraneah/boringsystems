---
name: Voice-Dictation Disambiguation for Proper Nouns
description: When Ahmed dictates, voice-to-text frequently slips on proper nouns (people, brands, products). Try plausible homophone matching before asking him to repeat.
type: feedback
originSessionId: f5c05bc8-0936-44a0-aed7-ae06d0dc1a42
---
When Ahmed dictates, voice-to-text reliably slips on proper nouns. Names of people, companies, products, and books often arrive transcribed as similar-sounding common words. Catch these inline by checking for plausible matches before treating the phrase as ambiguous.

**Why:** Asking Ahmed to repeat or clarify a name interrupts his flow and is often unnecessary — the right name is usually obvious from context if you check for homophones. He's frustrated by friction that could be resolved with a moment of inference.

**How to apply:**
- When an unfamiliar phrase appears in a position where a known person/brand/product would fit (advisor selection, founder reference, book title, app name, city), try homophone matching first.
- Use the surrounding context — what role is Ahmed assigning, what lens, what era — to disambiguate.
- Confirm tentatively in your response ("reading X as Y, correct me if wrong") rather than blocking on a question.
- Only ask if no plausible homophone exists or two equally-plausible matches compete.

**Examples observed in this session (2026-04-25):**
- "version group who has the book by Richard Branson" → **Virgin Group** (Branson is the founder; "version" → "Virgin")
- "novel from Angel List, novel or vacant" → **Naval Ravikant** (founder of AngelList)
- "KREV" → **GaryVee / Gary Vaynerchuk** (in context of content/marketing thesis discussion)
- "uuncle.co" — actually correct, but worth verifying when novel-sounding tool names appear

**Categories where slips are most common:**
- Founders/CEOs by first name only
- Company names that overlap with common words (Virgin, Apple, Square)
- Book titles transcribed as descriptive phrases
- Tools and products with invented or non-English names
- Place names and city names

**When in doubt:** offer your best read in the response and explicitly invite correction in one short clause. Don't stop the conversation to clarify — keep momentum, let Ahmed redirect if needed.
