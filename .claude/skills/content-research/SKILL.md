---
name: content-research
description: Research a topic to support writing a new boringsystems article. Finds patterns, gaps, and angles that fit the existing body of work. Use before drafting a new post.
disable-model-invocation: false
allowed-tools: Read, Grep, Glob, WebSearch
argument-hint: "[topic or question to research]"
---

Research $ARGUMENTS to support a boringsystems article.

## Step 1 — Scan existing content for context

Read all existing articles to understand:
- What topics are already covered
- What angles have already been taken
- What tone and vocabulary is established
- What gaps exist

```bash
ls src/content/case-files/
ls src/content/operating-playbooks/
```

Read the titles and first 20 lines of each to map the territory.

## Step 2 — Identify what's missing

Based on the existing body:
- Is there a series gap? (e.g., Series 3 AI-Native only has 2 playbooks)
- Is there a case file that would complement an existing playbook?
- Is there a tension or constraint this site hasn't addressed yet?

## Step 3 — Research the topic

For the requested topic ($ARGUMENTS):
- Search for how others discuss this problem (use WebSearch if relevant)
- Find the vocabulary engineers and operators actually use
- Identify 3-5 angles or framings
- Note what would be obvious/cliché vs what would be distinctive

## Step 4 — Map to boringsystems voice

Filter everything through the boringsystems lens:
- Concrete over abstract
- Constraint-first (what made this hard)
- Operator perspective (not consultant, not academic)
- Result-oriented (what changed)

## Step 5 — Output a research brief

Structure:
```
## Topic: [topic]

### What already exists on this site
[What articles touch adjacent ground]

### The distinctive angle
[What this site could say that others don't — the specific constraint or tension]

### Recommended type
[Case file or playbook, and why]

### Suggested title and subhead
[Title candidate]
[One-line subhead]

### Key points to cover
- [point 1]
- [point 2]
- [point 3]

### What to avoid
[The clichés, the obvious takes, the angles already done elsewhere]
```
