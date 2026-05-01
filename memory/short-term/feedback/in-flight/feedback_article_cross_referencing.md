---
name: Articles must cross-reference related content bidirectionally
description: New articles must link to existing related articles, and existing articles must be updated to link back — this is non-negotiable, not a nice-to-have.
type: feedback
---

When publishing a new article, check all existing work-en, writing-en, and building articles for thematic overlap. Add cross-reference links in both directions: the new article links out to related existing ones, and existing related articles are updated to link back.

**Why:** The site is a coherent body of work. Articles read in isolation miss the connective tissue. A writing article on auth theory should point to the work case file that demonstrates it in practice — and vice versa. A reader who lands on one should be able to find the other.

**How to apply:** Before committing any new article, run /cross-ref-check. At minimum, bidirectional links between a writing article and its corresponding work case file are non-negotiable. Apply cross-refs to both EN and FR versions. When adding links to existing articles, do it in the same branch/PR as the new article — don't defer cross-refs to a follow-up.
