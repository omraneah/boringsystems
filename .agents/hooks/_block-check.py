#!/usr/bin/env python3
# Companion detector for block-protected-push.sh.
#
# Reads the candidate command on stdin, prints a reason and exits 0 if a
# protected-branch operation is detected, exits 1 otherwise.
#
# Precision goals:
#  - quoted spans are stripped so "talks about git push origin main" never blocks
#  - the protected-name match is anchored within the SAME statement as the
#    `git push` / `git branch -d` it refers to (split on ; && || | newline) so
#    `git checkout main && git branch -d feature` does NOT misread as a delete
#    of `main`.

import re
import sys

PROT_NAMES = ("main", "master", "development", "dev", "production")
PROT_RE = "|".join(PROT_NAMES)
PROT_SET = set(PROT_NAMES)

raw = sys.stdin.read()
# Strip "..." and '...' quoted spans so quoted MENTIONS do not false-positive.
scan = re.sub(r'"[^"]*"|\'[^\']*\'', " ", raw)


def statement_segment(start_idx: int) -> str:
    """Return the substring from start_idx up to the next statement boundary."""
    end = len(scan)
    for sep in (";", "&&", "||", "|", "\n"):
        idx = scan.find(sep, start_idx)
        if idx != -1 and idx < end:
            end = idx
    return scan[start_idx:end]


def block(reason: str) -> None:
    print(reason)
    sys.exit(0)


# --- `git push …` checks (per push statement) ---
for m in re.finditer(r"(?:^|[^A-Za-z0-9_])git\s+push\b", scan):
    seg = statement_segment(m.start())
    if re.search(r"\borigin\s+(?:" + PROT_RE + r")\b", seg):
        block(
            "Direct push to a protected branch is forbidden. Create a feature "
            "branch and open a PR instead."
        )
    has_force = re.search(r"(?:-f\b|--force\b|--force-with-lease\b)", seg)
    has_prot = re.search(r"\b(?:" + PROT_RE + r")\b", seg)
    if has_force and has_prot:
        block("Force-pushing to a protected branch is forbidden.")
    if re.search(r"(?:--delete|:)\s*(?:" + PROT_RE + r")\b", seg):
        block("Deleting protected branches on the remote is forbidden.")

# --- `git branch -d/-D …` check: protected name must appear as an ARG to -d ---
for m in re.finditer(r"(?:^|[^A-Za-z0-9_])git\s+branch\s+-[dD]\b", scan):
    seg = statement_segment(m.start())
    post = re.split(r"-[dD]", seg, maxsplit=1)[1]
    tokens = [t for t in re.split(r"\s+", post.strip()) if t and not t.startswith("-")]
    if any(t in PROT_SET for t in tokens):
        block(
            "Deleting protected branches locally is forbidden. "
            "Protected: main, master, development, dev, production."
        )

sys.exit(1)
