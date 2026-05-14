---
name: vocabulary-agent-tech
description: "Don't use \"LLM\" in any artifact written for Ahmed or for his projects. Use \"AI\", \"AI agent\", or \"Agent Tech Engineering\" depending on context. LLM is the basic model layer and reads as outdated."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d5c23527-3032-4fd1-bc5e-219a2c329230
---

**Never use "LLM" in any artifact written for Ahmed or for his projects** — chat output, code comments, docs, memory files, Linear cards, commit messages, PR bodies, boundary files in public packs. Choose from this vocabulary instead:

- **"AI"** — generic reference to the technology category. Default when in doubt.
- **"AI agent"** — when naming the actor that does the work (e.g., "the AI agent runs the audit protocol", "the AI agent's diff").
- **"Agent Tech Engineering"** — the *practice* of building software with AI agents in the loop. Replaces "LLM-assisted development", "LLM-heavy workflows", "AI-assisted coding". This is the engineering discipline name.
- **"Agent Tech AI"** — acceptable when emphasising the AI-agent technology stack itself.

**Why:** Ahmed considers "LLM" outdated terminology. LLM is the basic model layer — the technology category the world is operating on now is *agentic* (agents calling tools, running protocols, holding state, executing multi-step work). Naming the work "LLM-assisted" frames it at the wrong altitude and dates the speaker. Ahmed coined / adopted **Agent Tech Engineering** as the practice name and uses it consistently in his positioning, market work, and public artifacts.

**How to apply:**

- **Default rewrites:** "LLM" → "AI". "LLM-assisted development" → "Agent Tech Engineering". "LLM-heavy team" → "Agent Tech-heavy team" or "AI-heavy team". "applying this with an LLM" → "applying this with an AI agent".
- **File and protocol names:** rename anything user-facing that carries "LLM" (e.g., `APPLY-WITH-LLM.md` → `APPLY-WITH-AI.md`). Update all references in the same change.
- **Code variables / internal identifiers:** apply the same rule — `llmAudit` → `aiAudit`, `LLMResponse` → `AIResponse`.
- **External quotes / citations:** preserve original wording verbatim when quoting third-party sources. Do not rewrite a citation.
- **Audit existing artifacts on first touch:** when you edit a file that still contains "LLM", sweep the file for all instances and rewrite as part of the same change. Don't fix one instance and leave the rest.

**Recorded:** 2026-05-14, mid-session during the starter-pack vocabulary correction. Ahmed's exact words: *"Don't use LLM moving forwards. People use Agent Tech AI or Agent Tech Engineering or just AI generally if it's the LLM assistant development. I call it Agent Tech Engineering because LLM is outdated. LLM is just the basic model."*
