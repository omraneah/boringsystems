---
name: Laptop-Agnostic Architecture Principle
description: Everything must survive a fresh-machine clone. No local-only state, no manual-setup shortcuts, no "works on my machine" hacks. Architecture first, always.
type: feedback
originSessionId: 5eb01b49-a215-4b70-a1a0-353c0aaae2f2
---
**Every decision and every piece of infrastructure must be laptop-agnostic.** If a fresh machine clone + documented setup script can't reproduce the full working state, the architecture is wrong.

**Why:** Ahmed operates across local machine, claude.ai cloud agents, and potentially new machines (France 2026 transition is imminent). Anything that depends on local-only state — hidden config, installed CLIs, manual auth tokens, un-committed files, my-laptop-only symlinks — is technical debt that will surface at the worst time. He is not "playing around on a laptop"; the setup is production infrastructure for his thinking and work. Fragility compounds.

**How to apply (the tests every suggestion must pass):**

1. **Fresh-machine test**: If someone clones the workspace and runs the documented setup, does everything work? If not, the change is not done. Fix the setup script or document the missing step.
2. **Cloud-agent test**: If a claude.ai cloud agent runs against one of these repos, does it have everything it needs *in the repo*? Skills, docs, config, conventions — all in the checkout. No references to "the workspace root" or "my global config" that the cloud won't see.
3. **No-token test**: Does this work without Ahmed handing out API keys, running `gh auth login`, installing a local CLI, or doing any manual auth? If not, route through claude.ai connectors instead. (See also: Cloud-Connector-Only Tool Auth.)
4. **Commit-or-it-doesn't-exist test**: Is every piece of config version-controlled? Hooks, skills, settings, memory, decisions, CLAUDE.md — everything. If it only lives at `~/.something` with no symlink back to a tracked file, it's not real.
5. **Symlink hygiene**: Symlinks from `~/` into a git-tracked workspace path are fine (they're reproducible via setup script). Symlinks in the opposite direction (git → outside) are not.

**When I notice an exception**: surface it immediately, not later. "This step works now but requires manual X on a new machine" is the kind of rot Ahmed wants flagged the moment it appears, not discovered during a migration.

**Scope**: This principle applies to everything — skills architecture, hooks, CLAUDE.md rules, project config, tool auth, dev-environment setup, deployment commands, memory storage. It is not limited to any one domain. Treat it as the highest-priority architectural constraint.
