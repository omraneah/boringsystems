---
title: "Les principes d'engineering qui survivent au stack"
description: "Les frameworks tournent. Les langages se renouvellent. Les primitives cloud se rebrandent. Les sept dimensions de la pratique d'engineering en dessous sont stack-orthogonales — vraies sur du bare metal, vraies sur Kubernetes, vraies sur n'importe quel runtime agent-native qui sortira en 2028."
date: 2026-04-27
order: 2
---

Les frameworks tournent tous les deux ans. Les langages se renouvellent. Les primitives cloud se rebrandent. Le stack que vous avez écrit en 2022 est à moitié déprécié ; celui de 2027 n'est pas encore livré. Rien de tout ça n'est le goulot.

Le goulot, c'est la couche pratique en dessous — les sept invariants qui gouvernent comment n'importe quelle équipe, dans n'importe quel langage, sur n'importe quel stack, ship du software qui ne s'effondre pas. Vrais sur du bare metal. Vrais sur Kubernetes. Vrais sur n'importe quel runtime agent-native qui sortira en 2028. Stack-orthogonaux par construction.

Cette pièce, c'est la couche pratique, écrite serrée. Pas une affiche de valeurs — chaque dimension est applicable en review, et les violations sont des défauts dans la façon dont on travaille, pas des opinions à respecter. Une seule barre s'applique : engineers et AI tools suivent les mêmes practice boundaries quand ils contribuent, reviewent ou génèrent du code. L'asymétrie où les humains-écrivent-du-code-soigné et les machines-génèrent-du-code-au-mieux ne survit pas à 2026. La barre, c'est la barre.

## Ce que c'est, et ce que ce n'est pas

Ce n'est pas la couche architecture. Les boundaries elles-mêmes — auth, multi-tenancy, IAM, module communication, infrastructure-as-code — sont leur propre surface de craft et appartiennent à leur propre document. Les sept dimensions ci-dessous se logent en dessous des boundaries architecturales : elles façonnent *comment* une équipe écrit du code, indépendamment de *à quoi* le code parle. Le principe 1 ci-dessous, c'est la discipline de respecter les architectural boundaries qui existent ; ce n'est pas un débat sur lesquelles tracer.

---

## 1. Architecture et boundaries

Vérifier les architectural boundaries avant l'implémentation. Les boundaries sont des contraintes, pas des suggestions. Les violations sont rejetées en review.

La discipline est procédurale. Lire les documents de boundaries. Comparer l'approche prévue à chaque boundary pertinente. Ne jamais présumer la conformité sans vérification. Si une boundary est sur le chemin, on la fait remonter et on la résout structurellement — pas de bypass par workarounds, exclusions ou silencing.

La version la plus dure de cette règle : ne pas construire au-dessus d'une dégradation majeure. Si une zone porte des violations connues, beaucoup de tech debt ou de l'instabilité, on s'arrête et on escalade avec des options. Construire des features sur des fondations cassées multiplie le rewrite final, et le rewrite arrive toujours.

## 2. Séparation des préoccupations

La logique business vit dans le backend ou l'API. Les clients consomment des APIs et gèrent la presentation, point.

La dérive la plus commune : la logique de validation qui a commencé dans l'API se duplique dans le client parce que c'était plus rapide que d'attendre l'équipe API. Six mois plus tard, les règles divergent, la copie côté client est périmée, et le bug ressemble à un problème backend alors que la source est une supposition côté client.

Le backend est la source unique de vérité pour les règles du domaine. Les clients rendent. C'est la ligne.

## 3. Cause racine et correctifs

Identifier la cause racine avant de corriger. Éviter les workarounds et le silencing sauf approbation explicite.

La forme de cet échec : un check tombe, l'engineer désactive le check, l'échec disparaît, le défaut sous-jacent ship. Une retry loop enveloppe une exception qui n'aurait jamais dû exister, et le bug devient invisible au monitoring. Un test est marqué flaky et skipped, et la régression n'a plus de détecteur.

Quand un workaround court terme est vraiment inévitable, on documente et on escalade. Les workarounds sont de la dette tracée, pas un état normalisé.

## 4. Planning et reviewability

Partager les plans tôt sur les travaux non triviaux. Préférer les changements petits et reviewables — découper structurellement quand une unité grossit.

Le travail du reviewer doit rester traitable. Un PR de 4 000 lignes qui touche huit modules ne peut pas être reviewé ; il peut juste être approuvé. Découper le même travail en cinq PRs focalisés garde la surface de review honnête, et garde l'unité de rollback petite quand quelque chose tourne mal en production.

Les reviews diffusent la connaissance. À traiter comme alignement et apprentissage, pas comme du gatekeeping. Demander de l'aide quand on bloque. Les estimates sont des prévisions, pas des promesses — communiquer l'incertitude plutôt que de traiter une estimate comme un contrat.

## 5. Qualité du code

Trois règles portent la charge.

**Petites unités, bien nommées.** Les fichiers et modules restent reviewables. Les fonctions restent courtes et focalisées. Pas de god objects. Types explicites — pas d'APIs non typées. Constantes nommées pour les literals ; pas de magic numbers, pas de strings inexpliquées. Les noms de fonctions et de variables révèlent l'intention.

**KISS et YAGNI.** La solution la plus simple qui rencontre l'exigence. Pas de complexité spéculative, pas de future-proofing pour des besoins qui ne se sont pas montrés. Tout est trade-off ; choisir l'option pratique et alignée avec les boundaries, pas celle qui vous fait tomber amoureux de votre design. Chaque ligne de code et chaque dépendance est une dette — à ajouter seulement quand le bénéfice surpasse clairement le coût long terme.

**DRY.** Pas de logique dupliquée à travers les couches ou les repos. Centraliser dans un endroit, traiter cet endroit comme la source de vérité, et résister à la tentation de "juste copier une fois". Deux copies en deviennent quatre ; quatre dérivent.

## 6. Documentation et traçabilité

Documenter les décisions et designs non évidents avec leur rationale. Les commit messages expliquent ce qui change et pourquoi, pas juste quoi.

Le test pour qu'un commentaire mérite sa place : un futur engineer qui lit ce code serait-il surpris sans contexte ? Si oui, le rationale appartient près du code. Sinon, le commentaire est du bruit. Les decision records — courts, archivés, linkables — portent le raisonnement plus lourd.

Les commit messages sont un outil de debugging. "Fix bug" est inutile six mois plus tard quand on git-blame une régression. "Switch from X to Y because we hit cycle Z" est searchable, reviewable, et économise une heure à chaque fois que quelqu'un re-rencontre le trade-off.

## 7. Testing

Tester le comportement qui compte. Laisser les tests meilleurs qu'on les a trouvés. Trier les tests flaky ou en échec au lieu de les ignorer.

La discipline est composable. Quand on touche au code, on améliore la couverture ou la clarté de la zone — règle du boy-scout, appliquée aux tests plutôt qu'aux commentaires. Les tests sont du code de production de premier rang : mêmes standards de naming, mêmes standards de maintenabilité, même attendu d'être lisibles dans plusieurs mois.

Les tests flaky sont pires que pas de tests. Ils entraînent l'équipe à ignorer les échecs, ce qui garantit que le prochain vrai échec sera lui aussi ignoré. Soit on fix le flake, soit on l'isole avec un follow-up tracé, soit on le supprime. Le skipper en permanence sans plan, c'est le mode d'échec qui ship des outages.

---

## Ce que ça permet

Ces sept dimensions ne shippent pas de features. Elles rendent les features livrables. Une équipe qui les respecte avance plus lentement les deux premiers mois et beaucoup plus vite pour toujours après, parce que chaque décision se compose dans une codebase qui reste reviewable, debuggable et fiable.

Une équipe qui les viole le premier mois ship le travail du premier mois vite et paie l'intérêt de la violation aux mois quatre à quarante. Ce n'est pas une affirmation morale. C'est la distribution long terme d'où le temps d'engineering passe vraiment.

## Pour clore

Les stacks sont interchangeables. La pratique non. Tout ce que vous construisez sur ces sept invariants survit à la prochaine migration ; tout ce que vous construisez à côté d'eux est réécrit quand le framework change d'avis.

La couche d'orchestration qui enveloppe un coding agent moderne — skills, hooks, memory, sub-agents, le harness autour du modèle — a son propre jeu d'invariants, en aval de ceux-ci mais avec leur propre logique. Ils sont dans la pièce compagnon : *[Les principes d'orchestration qui survivent au modèle](/fr/writing/orchestration-principles-that-outlive-the-model)*. L'agent qui vous aide à écrire le code suit la même practice bar décrite ci-dessus ; l'orchestration autour de l'agent suit six principes additionnels qui gèrent ce que l'agent lui-même ne peut pas.
