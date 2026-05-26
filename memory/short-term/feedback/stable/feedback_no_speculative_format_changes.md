---
name: no-speculative-format-changes
description: Never change format, style, or encoding of generated/artifact files without proof the current format is broken
metadata:
  type: feedback
---

Never change format, style, or encoding of generated/artifact files (TOML, committed build outputs, etc.) without first proving the current format causes an actual failure in the actual content.

**Why:** Session 2026-05-26 — changed `"""` to `'''` in TOML files with zero evidence of breakage in any persona file. Doubled the diff, wasted review time, had to revert. Ahmed called it "pure stupidity."

**How to apply:** Before any format change on an artifact file, answer: "Does the current format fail on the real content?" If no evidence of failure exists, leave it alone. "Could theoretically be an issue" is not a reason.
