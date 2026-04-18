---
name: new-post
description: Create a new article for boringsystems. Use when starting a new case file or operating playbook. Handles frontmatter, file naming, and structure scaffolding.
disable-model-invocation: true
allowed-tools: Read, Write, Glob, Bash(ls *)
argument-hint: "[type: case-file|playbook] [title or topic]"
---

Create a new article for boringsystems.com.

$ARGUMENTS should specify: type (case-file or playbook) and the topic/title.

## Step 1 — Determine type and location

**Case file** → `src/content/case-files/[slug].md`
- Schema: `title`, `description`, `featured` (bool), `order` (number)
- These are retrospective: a real problem, a constraint, an execution arc, a result.

**Operating playbook** → `src/content/operating-playbooks/[slug].md`  
- Schema: `title`, `description`, `series` (string), `seriesNum` (number), `playbook` (number), `featured` (bool), `highlight` (bool)
- These are principle-level: how to think about a class of problem.
- Check existing playbooks to determine the correct series and number.

## Step 2 — Check existing content for context

Read 2-3 existing articles to calibrate tone before writing anything:
- `src/content/case-files/architecture-governance.md` (case file reference)
- `src/content/operating-playbooks/s3-p2-context-is-the-edge.md` (playbook reference)

## Step 3 — Generate the slug

Lowercase, hyphenated, descriptive. Max 5 words. Example: `platform-ownership-under-ambiguity`.

## Step 4 — Write the file

### Tone and style (non-negotiable)
- Short sentences. No filler.
- No corporate language ("leverage synergies", "best-in-class", "stakeholders").
- No hedging ("maybe", "perhaps", "it could be argued").
- Structural honesty: name the constraint, name the tension, name what was actually done.
- Technical precision without over-explaining basics.
- Write like a senior operator explaining to another senior operator — not a tutorial, not a blog post.
- Use short paragraphs. Use lists sparingly — only when genuinely list-like.
- The "---" horizontal rule is used between major sections.

### Case file structure
```
---
title: "[Title]"
description: "[One sentence: what problem, what was done about it, what resulted]"
featured: false
order: 99
---

# [Title]
[One-line subhead — the constraint or tension in plain language]

---

## Context
[The situation. What existed. What was wrong. What was missing.]

---

## Constraint Pattern
[The specific constraints that shaped the approach. Be concrete.]

---

## Objective
[What success looked like. Not aspirational — operational.]

---

## Execution
[What was actually done. Phases if needed. No heroics, no vagueness.]

---

## Result
[What changed. Be specific. What is true now that wasn't before.]
```

### Playbook structure
```
---
title: "[Title]"
description: "[One sentence: what this playbook governs and why it matters]"
series: "[Series Name]"
seriesNum: [N]
playbook: [N]
featured: false
highlight: false
---

# Playbook [N] — [Title]
[One-line frame: what this is about at the highest level]

## Purpose
[Why this playbook exists. What it prevents or produces.]

---

## Core Principles
[The non-negotiables. Bullet format, each with a bold label and 2-3 sentences.]

---

## [Main section title]
[The substance. How this works in practice.]

---

## Why It Matters
[The cost of not having this. Concrete, not abstract.]
```

## Step 5 — Create the file

Write the scaffolded file with frontmatter and section headers. Leave content placeholders where you don't have substance — do not invent content. This is a scaffold, not a draft.

Tell me the path of the created file when done.
