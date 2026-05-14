---
name: vocabulary-agentic-engineering
description: "Don't use \"LLM\" in any artifact written for Ahmed or for his projects. Use \"AI\", \"AI agent\", or \"agentic engineering\" depending on context. LLM is the basic model layer and reads as outdated. The practice name is \"agentic engineering\" — never \"Agent Tech Engineering\" or \"Agent Tech AI\"."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d5c23527-3032-4fd1-bc5e-219a2c329230
---

**Never use "LLM" in any artifact written for Ahmed or for his projects** — chat output, code comments, docs, memory files, Linear cards, commit messages, PR bodies, boundary files in public packs. Choose from this vocabulary instead:

- **"AI"** — generic reference to the technology category. Default when in doubt.
- **"AI agent"** — when naming the actor that does the work (e.g., "the AI agent runs the audit protocol", "the AI agent's diff").
- **"agentic engineering"** — the *practice* of building software with AI agents in the loop. Lowercase, no capitals. Replaces "LLM-assisted development", "LLM-heavy workflows", "AI-assisted coding". This is the engineering discipline name.
- **"agentic"** — adjective form. "Agentic workflow", "agentically engineered code", "agentic-engineering-heavy team".

**Never use "Agent Tech Engineering" or "Agent Tech AI"** — those phrasings were rejected. The correct term is **agentic engineering**, lowercase.

**Why:** Ahmed considers "LLM" outdated terminology. LLM is the basic model layer — the technology category the world is operating on now is *agentic* (agents calling tools, running protocols, holding state, executing multi-step work). Naming the work "LLM-assisted" frames it at the wrong altitude and dates the speaker. **Agentic engineering** is the practice name Ahmed uses consistently in his positioning, market work, and public artifacts.

**How to apply:**

- **Default rewrites:** "LLM" → "AI". "LLM-assisted development" → "agentic engineering". "LLM-heavy team" → "agentic-engineering-heavy team" or "AI-heavy team". "applying this with an LLM" → "applying this with an AI agent".
- **File and protocol names:** rename anything user-facing that carries "LLM" (e.g., `APPLY-WITH-LLM.md` → `APPLY-WITH-AI.md`). Update all references in the same change.
- **Code variables / internal identifiers:** apply the same rule — `llmAudit` → `aiAudit`, `LLMResponse` → `AIResponse`.
- **External quotes / citations:** preserve original wording verbatim when quoting third-party sources. Do not rewrite a citation.
- **Audit existing artifacts on first touch:** when you edit a file that still contains "LLM" or "Agent Tech", sweep the file for all instances and rewrite as part of the same change. Don't fix one instance and leave the rest.

**Recorded:** 2026-05-14, mid-session during the starter-pack vocabulary correction. Initial attempt used "Agent Tech Engineering" — Ahmed rejected it sharply and corrected to "agentic engineering". The lowercase, plain-English form is the only correct one.
