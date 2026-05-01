---
title: "Découpler l'identité du provider d'authentification"
description: "Un parcours en trois phases : du câblage provider pragmatique à une couche identité propre et une frontière d'authentification enterprise-ready."
date: 2026-05-01
featured: true
order: 6
---

## Contexte

Une fois la maîtrise interne de la plateforme établie, un problème structurel plus profond est apparu.

La couche d'authentification avait été câblée pendant la phase d'inhousing sous forte pression temporelle. Le provider retenu — un service cloud d'identité managé — avait été choisi parce qu'il était déjà disponible et ne nécessitait aucun travail d'infrastructure initial. C'était le bon choix étant donné les contraintes.

Mais ce choix avait été étendu au-delà de son périmètre initial.

Le provider d'authentification avait glissé dans un second rôle : il servait de facto de couche de gestion des utilisateurs. Ses identifiants spécifiques s'étaient propagés dans tout le système — modules métier, API, back office, application mobile. Ce qui devait être un point d'intégration étroit était devenu une dépendance structurante embarquée dans une logique applicative qui n'avait rien à voir avec l'authentification.

Ce n'était pas une erreur de conception non remarquée. Ajouter un troisième espace d'identifiants — par-dessus les identifiants du vendor externe et ceux du provider — aurait introduit une complexité structurelle pendant la fenêtre de vélocité la plus critique de la transition. Le choix pragmatique était de différer.

Mais la dette différée s'était cumulée. Le système n'était pas seulement couplé à un provider spécifique. Il était câblé au modèle d'identité de ce provider à chaque couche. Toute évolution future — contrôle d'accès plus strict, remplacement du provider, ou intégration enterprise — exigeait de démêler ce couplage en premier.

Ce démêlage n'était pas optionnel. C'était la condition structurelle pour la prochaine phase — [la séquence de renforcement de la plateforme qui a suivi est documentée dans Renforcer une plateforme en production pour l'entreprise](/fr/work/saas-hardening/).

---

## Contraintes

L'environnement portait un ensemble de contraintes familières :

- production en continu sans tolérance d'interruption,
- delivery de features qui ne pouvait pas s'arrêter,
- une équipe réduite avec une capacité parallèle limitée,
- et une identité spécifique au provider embarquée sur de multiples surfaces.

Le problème ne pouvait pas se résoudre par une réécriture. Il fallait le traiter progressivement, sans perturber la delivery.

---

## Objectif

Établir une couche identité propre et agnostique au provider — rendre l'identifiant utilisateur interne canonique dans tout le système, isoler le provider d'authentification sur une frontière étroite, et préparer la plateforme à une authentification enterprise sans forcer une migration destructurante.

---

## Exécution

Le travail s'est déroulé en trois phases distinctes, chacune adressant un stade différent du problème d'identité.

---

### Phase 1 — Nommer la dette avant d'y toucher

La première phase était un choix de jugement, pas une implémentation.

Le choix pragmatique fait pendant l'inhousing était correct pour ce moment-là. Rouvrir le modèle d'identité en pleine transition aurait ralenti le travail qui devait réellement avancer. La décision était donc de continuer, de documenter la contrainte explicitement, et de traiter le cleanup comme un engagement futur défini — pas un report indéfini, mais un séquençage intentionnel.

Ce cadrage avait de l'importance. Il signifiait que le cleanup arrivait avec un propriétaire clair et un périmètre défini, plutôt que comme un refactoring ouvert déclenché par l'accumulation de frustrations.

---

### Phase 2 — Supprimer les fuites du provider de façon systématique

La deuxième phase a démarré une fois la maîtrise de la plateforme stabilisée et la feuille de route de hardening en cours.

La première étape consistait à établir des règles claires : un identifiant interne unique devenait le primitif utilisateur canonique dans tout le système. Les identifiants spécifiques au provider étaient confinés à une frontière auth étroite. Toute occurrence en dehors de cette frontière était classifiée comme un défaut architectural — pas une suggestion, pas un backlog : une violation à rejeter en code review.

Ces règles ont été publiées sous forme de documents de frontières architecturales, placés là où la planification, l'implémentation et la review avaient déjà lieu. Cela les rendait actionnables plutôt que consultatives.

Des guardrails programmatiques ont été ajoutés pour que les identifiants provider ne puissent pas réintégrer la logique métier et atteindre la production sans être détectés. Un suivi hebdomadaire mesurait le nombre de violations restantes dans la codebase. Cela donnait au cleanup une métrique visible et une condition d'arrêt concrète.

L'exécution a été divisée délibérément : un senior engineer portait le refactoring structurel, tandis que les autres contributeurs nettoyaient les violations rencontrées dans leur flow de delivery habituel. Cette division a empêché le cleanup de bloquer les features ou de se concentrer sur une seule personne.

Le cleanup a couvert tous les modules métier du système : booking, paiement, wallet, gestion des utilisateurs, opérations drivers, GPS, gestion des lignes, back office et application mobile.

Le périmètre complet a été terminé en environ deux mois — plus vite que ce type d'effort prend habituellement, principalement parce que les règles étaient explicites, les guardrails appliqués programmatiquement, et le suivi hebdomadaire rendait la progression lisible sans coordination constante.

---

### Phase 3 — Construire la voie enterprise-ready

La troisième phase adressait la trajectoire suivante de la plateforme.

Le modèle business exigeait une authentification enterprise : intégrations avec les identity providers des acheteurs grands comptes, support des protocoles standards utilisés par ces acheteurs, et gestion du cycle de vie des utilisateurs déléguée aux systèmes de l'acheteur.

Deux options étaient sur la table concernant le provider d'authentification existant : l'étendre au-delà de son périmètre initial pour couvrir ces exigences, ou le traiter comme l'outil adapté à ce qu'il faisait déjà et router les nouvelles exigences enterprise ailleurs.

Étendre le provider existant a été considéré et rejeté. Cette voie aurait accumulé une complexité opérationnelle — configuration par tenant, cas limites protocolaires, outillage de gestion sur-mesure — sans résoudre la dépendance architecturale sous-jacente. Elle aurait aussi rendu la migration complète plus coûteuse à terme, pas moins.

La résolution a été une séparation nette : le provider existant restait en place pour le tenant interne actuel, où il fonctionnait bien et où le risque de migration ne valait pas d'être pris. Tous les nouveaux tenants enterprise passaient par un auth broker dédié — une couche spécifiquement conçue pour absorber la complexité N-tenants × M-protocoles et gérer les intégrations avec les identity providers sans exposer cette complexité au backend de la plateforme.

Cette approche maintenait la stabilité opérationnelle, donnait aux nouveaux tenants du SSO enterprise dès le départ, et préservait un chemin de migration clair pour le tenant interne au moment opportun.

---

## Résultat

La plateforme est passée d'un état où l'identité spécifique au provider était embarquée dans toute la logique métier à un état où l'identifiant interne est canonique, la logique provider isolée en périphérie du système, et la couche d'authentification capable d'évoluer sans toucher au code domaine.

Les résultats concrets :

- identité agnostique au provider dans tous les modules métier,
- frontières programmatiques empêchant les fuites de régresser,
- voie d'authentification enterprise pour les nouveaux tenants, isolée des opérations existantes,
- périmètre complété en deux mois pour un refactoring de cette envergure structurelle,
- et une fondation propre pour toute évolution ou remplacement futur du provider.

---

## Note de clôture

Le couplage au provider d'authentification se cumule silencieusement. Il reste invisible jusqu'à ce que la prochaine exigence stratégique rende le coût du démêlage prohibitif.

La résolution ne consiste pas à éviter les choix pragmatiques sous pression — ces choix sont souvent corrects pour le moment. Il s'agit de nommer la contrainte, définir la frontière future, et exécuter le cleanup avant que la dette technique ferme des options stratégiques.

Quand les règles sont explicites, appliquées programmatiquement et suivies sur une métrique réelle, un refactoring de cette envergure peut être terminé plus vite qu'anticipé — sans perturber la delivery qu'il accompagne.

Le cadre de décision pour savoir quand déléguer l'auth et comment lire le plafond de chaque approche — avant que le couplage devienne de la dette — est couvert dans [SaaS Auth : le bon, la brute et le truand](/fr/writing/saas-auth-the-good-the-bad-and-the-ugly/).
