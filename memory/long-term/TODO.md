# memory/long-term/ — TODO

## Era / transient references — full-sweep pending

The pre-commit lint at `.agents/git-hooks/pre-commit` flags era references on ADDED lines only. The following pre-existing violations remain in body content and need a content-rewrite pass owned by Ahmed (substantive identity-doctrine edits, not mechanical).

Sweep command:
```
grep -rEn '\b20[0-9][0-9]\b|\brecently\b|\bcurrently\b|\bright now\b|\blast (week|month|year|quarter)\b|\bthis (week|month|year|quarter)\b|\bnext (week|month|year|quarter)\b|\bpast (few |several )?(week|month|year|quarter)s?\b|\bover the past\b|\bin the coming\b' memory/long-term/ | grep -vE 'last_reviewed|^---$|date:|codified:|horizon:|seeded:|companion_to:'
```

Action: schedule a focused pass during a weekly consolidation. Rewrite each flagged sentence to be timeless or relocate to medium-term. Rule source: `memory/short-term/feedback/stable/feedback_long_term_tier_purity.md`.
