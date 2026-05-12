---
title: "Adoption IA en engineering sur une plateforme en production"
description: "Conduire l'adoption IA sur une plateforme en production, du premier adopter à 90 % de code écrit par IA en 14 mois — sans dérive qualité, sans départ forcé."
date: 2026-05-12
highlight: false
featured: true
order: 2
---

## Contexte

Au quatrième trimestre 2024, l'organisation engineering de ce cas portait une architecture stable, une équipe de taille moyenne mêlant seniors et profils intermédiaires, et aucune pratique de développement assisté par IA. Cursor venait juste de devenir crédible. Copilot était largement disponible mais rarement utilisé sur les chemins de production. Le coding agentique — des agents écrivant des branches de bout en bout avec revue humaine — restait pour l'essentiel de la démo.

L'équipe avait une direction technique claire, une migration en cours hors d'une infrastructure managée par un vendor — la transition d'in-housing documentée dans *[Reclaiming System Ownership Under Vendor Lock-In](/fr/work/breaking-vendor-lock-in)*, achevée en cours de période — et plusieurs surfaces produit actives en développement simultané. Le rythme était déjà contraint par le jugement, pas par les mains.

Ce qui a commencé comme une exploration personnelle fin 2024 s'est transformé, sur quatorze mois, en un changement durable de la façon dont l'équipe construit du software. Au début de 2026, plus de 90 % du nouveau code sur la plateforme était généré par IA, la vélocité de l'équipe variait entre 2x et 3x la baseline sur la plupart des surfaces, et entre 5x et 10x sur le greenfield, le bug-fixing rapide et les surfaces lourdes en abstractions, et la discipline opérationnelle avait été codifiée, appliquée et absorbée.

Voici la séquence qui a produit ce résultat — ce qui a été fait, dans quel ordre, et pourquoi.

Le texte compagnon — *[Le playbook d'adoption IA pour les équipes engineering](/fr/writing/the-ai-adoption-playbook-for-engineering-teams)* — formalise le playbook que ce case file démontre en pratique.

---

## Schéma de contraintes

L'environnement de départ portait ces contraintes :

- une plateforme en production avec des exigences de fiabilité au niveau prod,
- plusieurs surfaces parallèles en développement actif,
- une équipe à séniorité mixte, avec des plafonds de jugement et des ouvertures au nouveau tooling variables,
- aucune fonction dédiée à l'adoption de tooling ou à l'intégration IA,
- aucun précédent dans l'équipe pour ce à quoi *« un bon engineering AI-assisté »* ressemble,
- et un contexte concurrentiel où une adoption plus lente était déjà un coût stratégique.

Le travail devait se faire sans perturber la livraison active, sans imposer de mandats top-down qui auraient généré de la résistance, et sans baisser le plancher qualité.

---

## Objectif

À la fin de la période, le système opérationnel autour de l'engineering AI-assisté devait :

- être adopté par une claire majorité de l'équipe engineering, sans forcer,
- tourner à l'intérieur d'une couche de gouvernance empêchant la dérive qualité,
- composer la vélocité de façon significative sur plusieurs surfaces,
- inclure un chemin de mentoring pour les engineers qui devaient remonter,
- absorber les nouveaux outils et nouveaux modèles sans redémarrage complet,
- et rester cohérent sous de futures transitions de leadership.

---

## Aperçu de l'exécution

Le travail s'est déroulé en six phases sur quatorze mois. Chaque phase a changé le substrat. Le rythme était délibéré — le mauvais ordre aurait cassé le système.

---

### Phase 1 — Exploration personnelle (T4 2024)

Avant que quoi que ce soit n'arrive à l'équipe, le leader a passé un temps personnel substantiel à utiliser les outils.

Cela couvrait :

- Cursor comme éditeur principal, sur du vrai code dans de vraies branches, pas dans un sandbox.
- Amazon Q Developer et les IDE agentiques adjacents en parallèle, pour trianguler l'état du marché.
- Les mêmes outils appliqués au travail hors code — décisions d'architecture, rédaction de documents, orchestration d'agents — pour comprendre où se situait le plancher de productivité en 2024 par rapport à là où il allait.

L'objectif n'était pas de choisir un gagnant. L'objectif était la fluidité. L'équipe n'allait pas absorber le changement si le leader opérait à partir de briefings.

L'output de cette phase était interne : une lecture calibrée de là où les outils étaient forts, là où ils échouaient, à quoi ressemblait un workflow durable, et quels trous de gouvernance allaient apparaître une fois les outils entrés dans l'équipe.

La même discipline de contexte qui a rendu cette transition stable plus tard — quel contexte vit à la couche projet, quel à la couche partagée, quel à la couche personnelle — est décrite dans *[Le contexte est l'avantage](/fr/writing/context-is-the-edge)*. La transition décrite dans ce case file a été rendue possible en traitant le contexte comme de l'architecture, pas comme du contenu.

---

### Phase 2 — Introduire le premier adopter (T1 2025)

Une fois la fluidité du leader réelle, le mouvement suivant n'était pas une annonce à l'équipe. C'était un tête-à-tête.

L'engineer senior le plus curieux de l'équipe — qui faisait déjà tourner des expériences avec Cursor sur des side projects — était le premier adopter naturel.

Le traitement :

- message explicite que l'équipe allait dans cette direction, sans pression calendaire,
- accès aux outils que l'engineer aurait autrement dû justifier,
- échanges de feedback réguliers, peu formels, centrés sur ce qui cassait et ce qui débloquait,
- et espace explicite pour explorer sans livrable rattaché.

L'engineer senior a commencé à produire un delta visible en quelques semaines. La profondeur des revues de code a augmenté. Le throughput de tickets est monté. La forme de ses commits a changé.

Cette phase a eu deux outputs : la première preuve interne pour l'équipe, et un canal de feedback privé qui faisait remonter les modes d'échec tôt.

---

### Phase 3 — Première dérive qualité, premiers garde-fous

La dérive est apparue exactement là où elle a tendance à apparaître.

À mesure que la sortie du premier adopter montait, certains anti-schémas ont commencé à passer qui ne seraient pas passés sous son workflow pré-IA. La discipline de frontière s'est affaiblie par endroits. De la duplication s'est glissée. Certaines abstractions sont apparues plus tôt que ce que l'architecture voulait. Le travail était plus rapide — et le plancher avait légèrement fissuré.

Ce n'était pas un signal de battre en retraite. C'était le signal que la gouvernance était maintenant nécessaire.

Les premiers mouvements de gouvernance :

- **Règles architecturales codifiées dans une forme qu'un agent IA peut appliquer.** Les ADR de l'équipe ont été réécrits avec des invariants explicites, des zones autorisées/interdites, et des limites de responsabilité — formulés pour qu'un modèle les chargeant en contexte les respecte au moment de la génération. La même discipline est documentée de bout en bout dans *[Établir une gouvernance d'architecture transversale](/fr/work/architecture-governance)*.
- **Règles indexées dans l'IDE.** Les règles codifiées ont été rendues accessibles via l'intégration Cursor de l'équipe, pour que chaque session les charge avant toute génération de code.
- **Une skill standing — une commande project-scoped — pour invoquer ces règles à la demande**, pour que les engineers puissent lancer un check structurel contre la barre codifiée avant d'ouvrir une revue.

Le point de la couche de gouvernance n'était pas de ralentir le premier adopter. Le point était de rendre son rythme accéléré structurellement sûr. Après l'arrivée de la couche, son throughput est resté haut et le plancher qualité s'est rétabli.

---

### Phase 4 — Élan et mentoring différencié

D'autres engineers ont commencé à prendre le tooling. À ce stade, le toolchain IA était passé d'une exploration sur le côté au workflow standard de l'équipe.

L'élan était inégal. Une partie de la vague suivante a bougé vite — ils observaient le premier adopter et étaient prêts. D'autres ont traîné. Deux schémas de résistance distincts ont émergé.

**Schéma de résistance 1 — l'engineer qui se cache derrière des hacks.**

Un engineer opérait depuis un certain temps légèrement en-dessous du standard de l'équipe, livrant par l'assertivité et des contournements informels plutôt que par un engineering propre. Le nouveau tooling, particulièrement la couche de règles codifiées et l'étape agent-as-reviewer arrivée plus tard, a exposé cela plus nettement que l'environnement pré-IA ne le faisait.

La qualité sur les branches de cet engineer s'est dégradée visiblement. La friction n'était pas le tooling. La friction venait du fait que le plancher avait monté et que l'écart était maintenant lisible.

Le traitement était direct. Mentoring explicite. Attentes claires. Sessions en binôme avec le premier adopter. Tête-à-tête privés cadrant la situation comme une conversation de capacité, pas une conversation d'adoption. L'engineer a fait des progrès mesurables sur les mois suivants. Le mentoring s'est poursuivi — et est resté séparé du reste du rollout, pour que la story d'adoption de l'équipe ne se mélange pas avec une situation individuelle de performance.

**Schéma de résistance 2 — l'engineer puriste.**

Un autre engineer était authentiquement fort. Il avait testé les premières versions des outils et conclu — correctement — que la sortie était sous sa barre. Il n'avait aucun incentive à courir après une tendance. Sa position était de principe, pas défensive.

Le traitement était l'inverse du Schéma 1.

Pas de pression. Accès continu aux outils, visibilité continue sur ce que les champions livraient, aucun cadrage public de sa position. Sur l'année qui a suivi, à mesure que les modèles s'amélioraient et que le harness autour mûrissait, il a commencé à explorer de son côté et a fini par adopter le toolchain — à ses conditions, selon sa propre évaluation. Au début de 2026, il l'utilisait régulièrement.

Le même engineer qui aurait résisté à n'importe quel rollout forcé a adopté volontairement une fois les preuves convergées. C'est le dividende de la patience comme mouvement délibéré, pas comme évitement.

La discipline plus large pour faire tourner ces deux schémas en parallèle — coacher un groupe d'engineers à la hausse, tenir l'espace pour qu'un autre groupe arrive à son rythme — est le principe opérationnel dans *[Influence-First Cross-Functional Leadership](/fr/archive/s2-p3-influence-first)*.

---

### Phase 5 — La gouvernance comme couche multi-agent

À mi-période, l'équipe opérait avec la plupart des engineers utilisant le tooling. La couche de gouvernance devait évoluer.

Trois ajouts :

- **Un second agent IA en first-pass reviewer.** L'agent lisait chaque PR contre les règles codifiées et les limites architecturales avant qu'aucun reviewer humain ne s'engage. L'engineer corrigeait sur le feedback de l'agent en premier. Le reviewer humain arrivait en dernier, jugeant la substance au lieu d'attraper les détails.
- **Garde-fous CI/CD appliquant la couche de règles au niveau machine.** Tests, checks de violation de principes, checks de franchissement de frontière. Erreurs bon marché attrapées au moment le moins cher possible.
- **Principes engineering codifiés et distillés pour les agents IA comme pour les engineers.** Pas un site de documentation. Un petit ensemble dense de règles, chargé dans chaque session par chaque engineer, quel que soit l'agent en cours. Les principes sont les mêmes que ceux documentés séparément dans *[Engineering Practice Boundaries — One Bar for Engineers and AI](/fr/writing/engineering-principles-that-outlive-the-stack)*.

La discipline d'orchestration qui tient ce type de couche multi-agent — ce qui est écrit, comment la mémoire est tiered, comment la boucle reste fermée — est le substrat décrit dans *[Agentic AI Orchestration — 7 principes opérationnels](/fr/writing/orchestration-principles-that-outlive-the-model)*.

Après l'arrivée de cette couche, la gouvernance a cessé de dépendre d'une intervention synchrone d'une seule personne. Le système s'appliquait lui-même.

---

### Phase 6 — Standardisation et composition (T1 2026)

La dernière phase a formalisé le nouveau standard.

- L'adoption est entrée dans la pratique engineering standing — référencée dans l'onboarding, dans les conversations de performance, dans les OKR.
- Les KPI étaient suivis par projet et par engineer : pourcentage de code généré par IA, delta de vélocité, taux de défauts, nombre d'itérations de revue, nombre de violations de gouvernance.
- De nouvelles règles et de nouvelles commandes continuaient d'être ajoutées en réponse à des modes d'échec spécifiques, le système étant conçu pour les absorber sans redémarrage.
- Des modèles plus récents — Claude Opus 4.6 en particulier — ont multiplié ce qui marchait déjà. Le substrat était prêt pour l'upgrade ; l'upgrade n'a pas nécessité de relancer le rollout.

À ce stade, le pattern opérationnel était absorbé. Cela ne ressemblait plus à une transition.

---

## Résultat

Les résultats matériels après quatorze mois :

- plus de 90 % du nouveau code sur la plateforme généré par IA,
- vélocité à 2-3x la baseline sur la plupart des surfaces ; 5-10x sur le greenfield, le bug-fixing rapide et les surfaces lourdes en abstractions,
- aucune dégradation mesurable de la qualité par rapport à la baseline pré-adoption ; sur les surfaces denses en règles, une amélioration mesurable,
- une équipe engineering opérant avec fluidité dans des workflows agentiques, avec un vocabulaire partagé pour la nouvelle barre,
- une couche de gouvernance codifiée dans le repo et dans le CI, capable d'absorber le nouveau tooling sans réécriture,
- un engineer mentoré à la hausse, un engineer adopté à ses conditions, zéro départ forcé lié au rollout.

Le substrat se compose désormais. Le prochain upgrade de modèle ajoute du throughput sans perturber le système opérationnel.

---

## Note de clôture

La transition décrite ici n'a pas cassé le système, n'a pas produit de backlash, et n'a pas dépendu de la survie d'un seul outil. Le substrat qu'elle a produit — règles codifiées, gouvernance multi-agent, chemin de mentoring pour les résistants, KPI clairs visibles dans toute l'équipe — est portable entre stacks, entre équipes, et à travers la prochaine vague de modèles.

La même forme a déjà été jouée, sur d'autres vagues technologiques, sous d'autres noms. Les principes transversaux — quand agir, comment ancrer, quoi protéger — sont cristallisés dans *[Change Injection: Shaping Systems Without Collapse](/fr/archive/s2-p2-change-injection)*.

Le playbook que ce case file démontre en pratique est dans *[Le playbook d'adoption IA pour les équipes engineering](/fr/writing/the-ai-adoption-playbook-for-engineering-teams)*. Les deux sont appariés : celui-ci est la preuve, celui-là est la barre.
