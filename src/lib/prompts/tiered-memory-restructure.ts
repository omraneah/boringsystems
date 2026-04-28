// The full text of the "Tiered Memory Restructure" lead-magnet prompt,
// in EN and FR. Surfaced via src/lib/lead-magnets.ts (asset slug
// `tiered-memory-restructure-prompt`).
//
// Kept in its own file because the prompt is long enough that inlining it
// in the registry would drown the registry's other (short) entries.
// Other lead-magnet bodies stay inline; once a body crosses ~30 lines
// it earns its own file under `src/lib/prompts/`.

export const TIERED_MEMORY_RESTRUCTURE_PROMPT_EN = `You are about to help me restructure my Claude memory into a tiered system: long-term (constitutional + identity), medium-term (evolving doctrine + project state), short-term (episodic per-session entries), with weekly consolidation as the closed-loop correction mechanism and two drift-detection skills as the immune system.

This is a multi-phase operation. You will not rush. You will not bulk-move. Each phase has an explicit checkpoint where you stop and wait for my confirmation before continuing. If you find yourself wanting to skip a step "because it's obvious," that is the signal to slow down — my starting state is almost certainly different from the reference state these instructions assume.

Below are six phases. Run them in order. Pause between each one.

---

PHASE 1 — EXPLORATION (gating; nothing else happens until I confirm)

Before designing tiers, survey what I already have. Memory in a workspace shows up in many shapes; do not assume there's a single canonical folder.

Look for:
- Auto-loaded memory folders (Claude Code conventionally reads from a path like \`.claude/projects/<workspace>/memory/\` or a workspace-root \`memory/\`; check both).
- A workspace-level \`CLAUDE.md\` and any project-level \`CLAUDE.md\` files. These often contain rules and routing that act as memory.
- Any folder named or prefixed \`memory\`, \`context\`, \`knowledge\`, \`docs\`, \`notes\`, \`scratch\`, \`tmp\`, \`brain\`, or similar.
- Any \`MEMORY.md\`, \`AGENTS.md\`, \`PRINCIPLES.md\`, \`DOCTRINE.md\`, or \`DECISIONS.md\` at any depth.
- Files prefixed with patterns like \`feedback_*.md\`, \`project_*.md\`, \`user_*.md\`, \`reference_*.md\`, \`rule_*.md\` — these are the loosely-managed-state signature.
- Any separate strategic-context folder (positioning, identity, market lens, transition material) that is read on demand rather than auto-loaded.
- Any setup script (\`setup.sh\`, \`install.sh\`, etc.) that creates symlinks. The symlink architecture is what makes memory laptop-agnostic; we'll need to understand it before changing it.

Report back with:
- A tree of every memory-shaped surface you found, with absolute paths.
- For each surface: how big it is (file count, rough total size), how it's loaded (auto vs on-demand), and what kinds of content it holds (rules, identity, project state, strategic context, scratch).
- Your best inference of which files are constitutional (rarely change), which are evolving (change weekly-to-monthly), and which are episodic (change session-to-session). Say "uncertain" where you are uncertain — do not guess.
- Any drift signals you can already see: files with stale dates, files contradicting each other, files contradicting the workspace \`CLAUDE.md\`.

Then STOP. Wait for my confirmation that the survey is complete and accurate before moving to Phase 2. If I add or correct files, redo the relevant part of the survey before proceeding.

---

PHASE 2 — TIER DEFINITIONS AND GOVERNANCE READMES (drafted, shown, approved)

Once I confirm the survey, draft four READMEs:

1. \`memory/README.md\` (root governance) — covers: tier definitions, weighting rules (which tier wins when two tiers contradict each other; default is short-term wins for live state, long-term wins for constitutional rules), conflict resolution (when live conversation contradicts a tier, the conversation wins by default and the contradicted file gets flagged for next consolidation), drift protocols (when to fire the drift skills), consolidation cadence (Monday weekly), garbage collection (how short-term archives roll out of active scope), and symlink architecture (memory lives at workspace root, symlinked into the agent's read location, fresh-machine setup handled by setup.sh).

2. \`memory/long-term/README.md\` — what belongs here (constitutional rules, codified principles, identity material, decision registry, slow-changing doctrine), what does not (anything time-bounded, anything project-specific, anything that's still being worked out), write discipline (slow, conscious, never silent overwrite), and the explicit warning that identity material in long-term is the layer most prone to silent staleness in a transition phase.

3. \`memory/medium-term/README.md\` — what belongs here (evolving doctrine drafts, project memos, GTM hypotheses under test, persona drafts, market reads, watch-memos with explicit revisit dates, current-arc paragraph), write discipline (updates are routine; decay is expected and welcome), and the rule that anything stable enough for three consolidation cycles in a row should be considered for promotion to long-term.

4. \`memory/short-term/README.md\` — what belongs here (daily entries with timestamps, decisions, state, especially conflicts and divergences from any tier), naming convention (\`<ISO-week>/<ISO-date>.md\` for daily entries, \`<ISO-week>/consolidation.md\` for the weekly Monday output), rotation rule (older weeks move to \`_archive/\` after a configurable horizon), and the explicit warning that nothing in short-term should be treated as authoritative — it is the input to consolidation, not a source of truth.

Three editorial rules apply to every README:
- Reference only stable folders and concepts. Never reference specific filenames, project-management cards, or ephemeral folders.
- The READMEs describe the architecture, not the current contents. They survive content changes.
- Each README is one screen at most. If a README needs subsections, the architecture is too complex.

Show me the four drafts. I will edit, ask questions, and approve. Do not move any file until all four READMEs are approved.

---

PHASE 3 — MIGRATION IN BATCHES (one category at a time, explicit checkpoints)

Once the READMEs are approved, migrate the existing files into tiers. Never bulk-move. Take one category per batch:

Batch 3a — Constitutional rules. Files that encode workspace-wide non-negotiables (push policies, MCP auth conventions, security rules, scope discipline). Move to \`memory/long-term/workspace-rules/\` (or a similar subfolder you propose). For each file: show me the file's current name and proposed new path, ask one sentence whether the move is right, and only proceed once I confirm the batch.

Batch 3b — Identity and codified principles. User profile, collaboration tone, codified meta-principles, behavioural rules. Move to \`memory/long-term/identity/\` and \`memory/long-term/principles/\`. Apply the same per-batch confirmation rule. WARN ME EXPLICITLY for each identity file: identity content drifts faster than constitutional rules, and the long-term tier is the most expensive place to silently anchor on a stale identity. If a file looks like it might already be stale, flag it for the post-migration audit (Phase 6) instead of confidently moving it.

Batch 3c — Workflow conventions and evolving doctrine. Workflow patterns, in-flight doctrine drafts, conventions that are settled enough to use but not yet codified at the constitutional level. Move to \`memory/medium-term/workflow-conventions/\` and \`memory/medium-term/doctrine-in-flight/\`.

Batch 3d — Active project state. Project-specific notes, deferred follow-ups, GTM hypotheses, persona drafts. Move to \`memory/medium-term/\` (in an appropriate subfolder you propose).

Batch 3e — Anything you cannot confidently tier. Move to \`memory/short-term/_needs-consolidation/\` with a one-line note in each file explaining why it landed there. The first weekly consolidation will resolve these.

If a separate strategic-context folder exists (positioning, identity, market material), distillation into tiers is a fifth batch. Distillation is lossy — light reframing only, an "Origin" header on every distilled file pointing back to the source, and the originals left untouched in their old location until the post-migration audit confirms the distillation was faithful. Defer the deep audit; do not try to combine migration and interrogation.

Show me the per-file mapping for each batch before moving anything. Confirm one batch fully before starting the next.

---

PHASE 4 — DRIFT SKILLS (the immune system, before the closed loop)

Wire two skills. Order matters: drift detection makes the long-term tier safe to have before the weekly consolidation starts asking the agent to commit to it.

Skill 1 — \`/whence\`. Directive. The operator asks the agent where it pulled the current claim or behaviour from. The agent reports: tier (long / medium / short / live conversation), source (folder, doc, or "live"), bias risk this introduces (which tier of staleness is in play), confidence. One paragraph. Used when a claim sounds off.

Skill 2 — \`/divergence-check\`. Proactive. The agent fires it on detected frustration, correction loops, "you're missing me", or a long-term claim being contradicted by a live preference. The skill pauses, surfaces the suspected drift between live conversation and tracked memory, asks one clarifying question, and offers to record the divergence in today's short-term entry for next week's consolidation. Do NOT fire reactively to every disagreement — only when the gap feels structural, not tactical.

Add one behavioural rule to long-term: "When frustration or correction loops are detected, fire \`/divergence-check\` before continuing." This rule is what turns the proactive skill from a tool into a habit.

Symlink architecture: the skills live in the workspace and are exposed to the agent via symlinks. Be careful with \`ln -sf\` against existing parent symlinks — it can resolve through the parent and create circular self-references inside the skill directory. Test the symlink resolution explicitly after creating it. If you see a circular reference, remove and recreate from the canonical absolute path.

Update setup.sh idempotently: the script should detect a wrong target and recreate the symlink, not silently leave a stale one in place. After updating setup.sh, re-run it to confirm the new state.

---

PHASE 5 — WEEKLY CONSOLIDATION (the closed loop)

Wire the third skill: \`/consolidate-week\`. It reads last week's daily short-term entries, proposes promotions (short → medium, medium → long), demotions, drift flags, and deletions. The operator reviews each proposal — accept, reject, defer. Results record in this week's \`consolidation.md\` with three sections: (1) my consolidation — what the agent proposed, with reasoning; (2) your decisions — what the operator accepted, rejected, or deferred; (3) actions taken — the final state of the file tree after the operator's decisions. Older weeks rotate to \`_archive/\` automatically.

Add a behavioural rule to long-term: "On Monday session start, if this week's consolidation.md does not exist yet, fire \`/consolidate-week\`." V1 of this trigger is a memory-rule, not a hook. If the rule gets missed in practice, promote it to a hook in v2.

Write a first daily short-term entry the same day the system goes live. Format: timestamp, what was decided, what state changed, any conflicts or divergences from any tier (these are the most valuable signal — they feed the next consolidation).

---

PHASE 6 — CUTOVER AND DEFERRED AUDIT

Cutover is move-then-link. Move the new memory tree into place at workspace root. Update setup.sh to symlink the agent's read location to the new tree. Re-run setup.sh. Confirm the agent reads the new MEMORY.md by starting a fresh session and asking it to summarize the session-start protocol.

Once the new tree is verified working, \`git rm\` the obsolete files at the old auto-memory path. They remain recoverable from git history. Do not delete the original strategic-context folder if one existed — leave it as legacy until the deferred audit confirms the distillation was faithful.

Open a second piece of work — a deferred audit — to interrogate the long-term tier against the operator's current operating mode. The constitutional rules are stable. The identity material may already be drifting at the moment it landed in long-term. Until the audit completes, do not anchor strategic decisions on inherited long-term content.

---

WHAT TO RETURN AT EACH CHECKPOINT

At every phase boundary, return:
- What you did in the phase, in three to five bullets.
- What you did NOT do (deferred decisions, files you couldn't tier confidently, governance gaps you noticed).
- The exact state of the file tree after the phase (relevant subset only).
- One question or one decision needed before the next phase, if any.

Do not produce a long narrative. Distill. The architecture work is mostly thinking, but the output you return at each checkpoint is mostly state.

If you find yourself accelerating, slow down. The cost of a wrong move at this layer compounds for months.
`;

export const TIERED_MEMORY_RESTRUCTURE_PROMPT_FR = `Tu vas m'aider à restructurer ma memory Claude en un système tiered : long-term (constitutionnel + identité), medium-term (doctrine en évolution + état projet), short-term (entrées épisodiques par session), avec une consolidation hebdomadaire comme mécanisme de closed loop et deux skills de drift detection comme système immunitaire.

C'est une opération multi-phases. Tu ne vas pas te précipiter. Tu ne vas pas faire de bulk-move. Chaque phase a un checkpoint explicite où tu t'arrêtes et attends ma confirmation avant de continuer. Si tu te surprends à vouloir sauter une étape « parce que c'est évident », c'est le signal pour ralentir — mon point de départ est presque sûrement différent de l'état de référence que ces instructions supposent.

Voici six phases. Fais-les dans l'ordre. Pause entre chacune.

---

PHASE 1 — EXPLORATION (gating ; rien d'autre ne se passe avant que je confirme)

Avant de designer les tiers, fais un recensement de ce que j'ai déjà. La memory dans un workspace prend plein de formes ; ne suppose pas qu'il y a un seul dossier canonique.

Cherche :
- Les dossiers de memory auto-chargés (Claude Code lit par convention depuis un chemin du genre \`.claude/projects/<workspace>/memory/\` ou un \`memory/\` à la racine du workspace ; vérifie les deux).
- Un \`CLAUDE.md\` au niveau workspace et tout \`CLAUDE.md\` au niveau projet. Ils contiennent souvent des règles et du routing qui font office de memory.
- Tout dossier nommé ou préfixé \`memory\`, \`context\`, \`knowledge\`, \`docs\`, \`notes\`, \`scratch\`, \`tmp\`, \`brain\`, ou similaire.
- Tout \`MEMORY.md\`, \`AGENTS.md\`, \`PRINCIPLES.md\`, \`DOCTRINE.md\`, ou \`DECISIONS.md\` à n'importe quelle profondeur.
- Les fichiers préfixés par des patterns comme \`feedback_*.md\`, \`project_*.md\`, \`user_*.md\`, \`reference_*.md\`, \`rule_*.md\` — c'est la signature de l'état vaguement géré.
- Tout dossier de contexte stratégique séparé (positioning, identité, market lens, matériel transition) qui est lu on demand plutôt qu'auto-chargé.
- Tout script de setup (\`setup.sh\`, \`install.sh\`, etc.) qui crée des symlinks. L'architecture symlink est ce qui rend la memory laptop-agnostic ; il faut la comprendre avant de la changer.

Reviens avec :
- Un arbre de chaque surface memory-shaped trouvée, avec chemins absolus.
- Pour chaque surface : sa taille (nombre de fichiers, taille totale grossière), comment elle est chargée (auto vs on-demand), quels types de contenu elle porte (règles, identité, état projet, contexte stratégique, scratch).
- Ta meilleure inférence sur quels fichiers sont constitutionnels (changent rarement), évolutifs (changent à la semaine ou au mois), épisodiques (changent à la session). Dis « incertain » là où tu es incertain — ne devine pas.
- Tout signal de drift que tu peux déjà voir : fichiers à dates périmées, fichiers qui se contredisent, fichiers qui contredisent le \`CLAUDE.md\` du workspace.

Puis STOP. Attends ma confirmation que le recensement est complet et juste avant de passer à la Phase 2. Si j'ajoute ou corrige des fichiers, refais la partie pertinente du recensement avant de continuer.

---

PHASE 2 — DÉFINITIONS DE TIERS ET README DE GOVERNANCE (draftés, montrés, approuvés)

Une fois le recensement confirmé, drafte quatre README :

1. \`memory/README.md\` (governance racine) — couvre : définitions de tiers, règles de pondération (quel tier gagne quand deux tiers se contredisent ; par défaut short-term gagne pour l'état live, long-term gagne pour les règles constitutionnelles), résolution de conflit (quand la conversation live contredit un tier, la conversation gagne par défaut et le fichier contredit est flaggé pour la prochaine consolidation), protocoles de drift (quand déclencher les drift skills), cadence de consolidation (lundi hebdo), garbage collection (comment les archives short-term sortent du scope actif), et architecture symlink (la memory vit à la racine du workspace, symlinkée vers l'emplacement de lecture de l'agent, setup machine fraîche géré par setup.sh).

2. \`memory/long-term/README.md\` — ce qui appartient ici (règles constitutionnelles, principes codifiés, matériel d'identité, decision registry, doctrine lente à changer), ce qui n'y appartient pas (tout ce qui est borné dans le temps, tout ce qui est project-specific, tout ce qui est encore en construction), discipline d'écriture (lent, conscient, jamais d'écrasement silencieux), et l'avertissement explicite que le matériel d'identité dans long-term est la couche la plus sujette à la péremption silencieuse en phase de transition.

3. \`memory/medium-term/README.md\` — ce qui appartient ici (drafts de doctrine en évolution, memos projet, hypothèses GTM sous test, drafts de personas, market reads, watch-memos avec dates de revisit explicites, paragraphe current-arc), discipline d'écriture (les updates sont la routine ; la décroissance est attendue et bienvenue), et la règle que tout ce qui est stable sur trois cycles de consolidation d'affilée doit être candidat à la promotion vers long-term.

4. \`memory/short-term/README.md\` — ce qui appartient ici (entrées quotidiennes avec timestamps, décisions, état, surtout conflits et divergences depuis n'importe quel tier), convention de nommage (\`<ISO-week>/<ISO-date>.md\` pour les entrées quotidiennes, \`<ISO-week>/consolidation.md\` pour la sortie hebdo du lundi), règle de rotation (les semaines plus anciennes basculent dans \`_archive/\` après un horizon configurable), et l'avertissement explicite que rien dans short-term ne doit être traité comme autoritaire — c'est l'input à la consolidation, pas une source de vérité.

Trois règles éditoriales s'appliquent à chaque README :
- Référencer uniquement des dossiers et concepts stables. Ne jamais référencer de noms de fichiers spécifiques, de cards de project management, ou de dossiers éphémères.
- Les README décrivent l'architecture, pas le contenu courant. Ils survivent aux changements de contenu.
- Chaque README tient sur un écran maximum. S'il a besoin de sous-sections, l'architecture est trop complexe.

Montre-moi les quatre drafts. Je vais éditer, poser des questions, approuver. Ne bouge aucun fichier avant que les quatre README soient approuvés.

---

PHASE 3 — MIGRATION EN BATCHES (une catégorie à la fois, checkpoints explicites)

Une fois les README approuvés, migre les fichiers existants dans les tiers. Jamais de bulk-move. Une catégorie par batch :

Batch 3a — Règles constitutionnelles. Fichiers qui encodent les non-négociables workspace-wide (politiques de push, conventions d'auth MCP, règles de sécurité, discipline de scope). Bouger vers \`memory/long-term/workspace-rules/\` (ou un sous-dossier similaire que tu proposes). Pour chaque fichier : montre-moi le nom courant et le chemin proposé, demande en une phrase si le move est juste, et continue seulement quand je confirme le batch.

Batch 3b — Identité et principes codifiés. User profile, ton de collaboration, méta-principes codifiés, règles comportementales. Bouger vers \`memory/long-term/identity/\` et \`memory/long-term/principles/\`. Même règle de confirmation par batch. AVERTIS-MOI EXPLICITEMENT pour chaque fichier d'identité : le contenu d'identité dérive plus vite que les règles constitutionnelles, et le tier long-term est l'endroit le plus coûteux pour s'ancrer silencieusement sur une identité périmée. Si un fichier a l'air déjà périmé, flag-le pour l'audit post-migration (Phase 6) au lieu de le bouger avec assurance.

Batch 3c — Workflow conventions et doctrine en évolution. Patterns de workflow, drafts de doctrine en cours, conventions assez posées pour être utilisées mais pas encore codifiées au niveau constitutionnel. Bouger vers \`memory/medium-term/workflow-conventions/\` et \`memory/medium-term/doctrine-in-flight/\`.

Batch 3d — État projet actif. Notes project-specific, follow-ups différés, hypothèses GTM, drafts de personas. Bouger vers \`memory/medium-term/\` (dans un sous-dossier approprié que tu proposes).

Batch 3e — Tout ce que tu ne peux pas tierer avec assurance. Bouger vers \`memory/short-term/_needs-consolidation/\` avec une note d'une ligne dans chaque fichier expliquant pourquoi il a atterri là. La première consolidation hebdo résoudra ces cas.

Si un dossier de contexte stratégique séparé existe (positioning, identité, matériel marché), la distillation dans les tiers est un cinquième batch. La distillation est lossy — reframing léger seulement, un header « Origin » sur chaque fichier distillé pointant vers la source, et les originaux laissés intacts à leur ancienne place jusqu'à ce que l'audit post-migration confirme que la distillation a été fidèle. Diffère l'audit profond ; n'essaie pas de combiner migration et interrogation.

Montre-moi le mapping par fichier pour chaque batch avant de bouger quoi que ce soit. Confirme un batch en entier avant de commencer le suivant.

---

PHASE 4 — DRIFT SKILLS (le système immunitaire, avant le closed loop)

Câble deux skills. L'ordre compte : la drift detection rend le tier long-term sûr à avoir avant que la consolidation hebdo commence à demander à l'agent de s'y engager.

Skill 1 — \`/whence\`. Directif. L'opérateur demande à l'agent où il a pris l'affirmation ou le comportement courant. L'agent rapporte : tier (long / medium / short / conversation live), source (dossier, doc, ou « live »), risque de biais introduit (quel tier de péremption est en jeu), confiance. Un paragraphe. Utilisé quand une affirmation sonne off.

Skill 2 — \`/divergence-check\`. Proactif. L'agent le déclenche sur des signaux de frustration détectée, des boucles de correction, « tu me rates », ou une affirmation long-term contredite par une préférence live. Le skill fait pause, surface le drift suspecté entre conversation live et memory tracée, pose une question de clarification, et propose d'enregistrer la divergence dans l'entrée short-term du jour pour la consolidation de la semaine prochaine. NE déclenche PAS réactivement à chaque désaccord — seulement quand le gap semble structurel, pas tactique.

Ajoute une règle comportementale dans long-term : « Quand de la frustration ou des boucles de correction sont détectées, déclencher \`/divergence-check\` avant de continuer. » Cette règle est ce qui transforme le skill proactif d'un outil en habitude.

Architecture symlink : les skills vivent dans le workspace et sont exposés à l'agent via symlinks. Attention à \`ln -sf\` contre des parent symlinks existants — ça peut résoudre à travers le parent et créer des références auto-circulaires dans le dossier du skill. Teste la résolution du symlink explicitement après l'avoir créé. Si tu vois une référence circulaire, supprime et recrée depuis le chemin absolu canonique.

Update setup.sh idempotemment : le script doit détecter une cible erronée et recréer le symlink, pas en laisser silencieusement un périmé en place. Après avoir updaté setup.sh, relance-le pour confirmer le nouvel état.

---

PHASE 5 — CONSOLIDATION HEBDOMADAIRE (le closed loop)

Câble le troisième skill : \`/consolidate-week\`. Il lit les entrées short-term quotidiennes de la semaine dernière, propose des promotions (short → medium, medium → long), des démotions, des drift flags, et des suppressions. L'opérateur review chaque proposition — accepter, rejeter, différer. Les résultats s'enregistrent dans la \`consolidation.md\` de la semaine avec trois sections : (1) ma consolidation — ce que l'agent a proposé, avec raisonnement ; (2) vos décisions — ce que l'opérateur a accepté, rejeté, différé ; (3) actions taken — l'état final de l'arborescence après les décisions de l'opérateur. Les semaines plus anciennes basculent dans \`_archive/\` automatiquement.

Ajoute une règle comportementale dans long-term : « Au session start du lundi, si la consolidation.md de cette semaine n'existe pas encore, déclencher \`/consolidate-week\`. » La v1 de ce trigger est une règle memory, pas un hook. Si la règle est ratée en pratique, promouvoir en hook en v2.

Écris une première entrée short-term quotidienne le jour même où le système passe en live. Format : timestamp, ce qui a été décidé, quel état a changé, tout conflit ou divergence depuis n'importe quel tier (ce sont les signaux les plus précieux — ils alimentent la prochaine consolidation).

---

PHASE 6 — CUTOVER ET AUDIT DIFFÉRÉ

Le cutover, c'est move-then-link. Bouge le nouvel arbre memory en place à la racine du workspace. Update setup.sh pour symlinker l'emplacement de lecture de l'agent vers le nouvel arbre. Relance setup.sh. Confirme que l'agent lit le nouveau MEMORY.md en démarrant une session fraîche et en lui demandant de résumer le protocole de session-start.

Une fois le nouvel arbre vérifié comme fonctionnel, \`git rm\` les fichiers obsolètes à l'ancien chemin auto-memory. Ils restent récupérables depuis l'historique git. Ne supprime pas le dossier de contexte stratégique original si un existait — laisse-le en legacy jusqu'à ce que l'audit différé confirme que la distillation a été fidèle.

Ouvre un second morceau de travail — un audit différé — pour interroger le tier long-term contre le mode opératoire actuel de l'opérateur. Les règles constitutionnelles sont stables. Le matériel d'identité peut déjà dériver au moment où il atterrit dans long-term. Jusqu'à ce que l'audit soit fait, ne pas ancrer de décisions stratégiques sur du contenu long-term hérité.

---

CE QU'IL FAUT RENDRE À CHAQUE CHECKPOINT

À chaque frontière de phase, rends :
- Ce que tu as fait dans la phase, en trois à cinq bullets.
- Ce que tu n'as PAS fait (décisions différées, fichiers que tu ne pouvais pas tierer avec assurance, gaps de governance que tu as remarqués).
- L'état exact de l'arborescence après la phase (sous-ensemble pertinent uniquement).
- Une question ou une décision nécessaire avant la prochaine phase, le cas échéant.

Ne produis pas un long narratif. Distille. Le travail d'architecture est surtout du thinking, mais la sortie que tu rends à chaque checkpoint est surtout de l'état.

Si tu te surprends à accélérer, ralentis. Le coût d'un mauvais move à cette couche se compose pendant des mois.
`;
