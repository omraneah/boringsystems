---
title: "Délimiter les couches d'authentification dans un système en production"
description: "Un compte-rendu en trois phases de la séparation des couches auth dans une plateforme live — du modèle domaine couplé au provider vers des frontières propres et un chemin d'authentification enterprise-ready."
date: 2026-05-01
featured: true
order: 6
---

## Contexte

Le principe de départ était juste : ne pas gérer les mots de passe, ne pas devenir un Identity Provider. Déléguer la vérification des credentials à un service managé — absorber aucun risque cryptographique, aucune complexité de breach response, aucune surface de compliance. Cette décision a été prise correctement, sous pression et contrainte, et elle a tenu.

Ce qui n'a pas été spécifié, c'est tout le reste.

La stack auth a plus d'une couche. Il y a l'Identity Provider — le système qui authentifie les utilisateurs et émet des assertions signées. Il y a l'identity broker — la couche qui normalise la fédération entre plusieurs IdPs en amont. Il y a la token verification — comment le backend confirme l'identité à chaque requête API. Il y a le user management — la base de données de la plateforme, son modèle domaine, ses IDs. Il y a le user provisioning — le cycle de vie des comptes, distinct de l'authentification. Il y a le session management — maintenir l'état authentifié entre les requêtes. Il y a l'authorization — qui peut faire quoi.

Aucune de ces couches n'a été nommée. Elles sont donc devenues par défaut la responsabilité de l'IdP. Pas par choix — par gravité. Le service d'authentification managé était là, il avait des APIs, et l'équipe les a utilisées. L'identifiant utilisateur du provider est devenu l'identifiant utilisateur de la plateforme, embarqué dans les objets domaine. La token verification appelait le provider à chaque requête API. L'état d'autorisation était partiellement stocké dans les custom attributes du provider. Le point d'intégration qui aurait dû rester étroit était devenu une dépendance structurante dans chaque module domaine.

Chacune de ces décisions était défendable en isolation, prise sous pression pendant une transition critique. Le problème n'était pas une décision individuelle. C'était l'absence d'un modèle qui définit les couches comme distinctes, assigne à chacune un propriétaire, et rend les violations de frontières rejetables.

Voici comment c'est résolu — et comment le chemin d'authentification enterprise a été construit sur des fondations propres ensuite.

---

## Contraintes

Le travail s'est déroulé sous les contraintes opérationnelles standard pour ce type de chantier :

- production live, delivery continue, aucune tolérance d'interruption
- delivery de features qui ne pouvait pas s'arrêter
- équipe réduite avec une capacité parallèle limitée
- identifiants et logique spécifiques au provider dans chaque module domaine : booking, paiement, wallet, user management, opérations drivers, GPS, gestion des lignes, back office, application mobile

Le couplage ne pouvait pas se résoudre par une réécriture. Il fallait le traiter progressivement, une frontière à la fois, sans perturber la delivery.

---

## Les trois violations de couche

Avant tout cleanup, la première tâche était de nommer quelles couches faisaient le travail de qui. Un cleanup qui commence sans modèle clair produit de l'activité sans progrès.

Trois violations ont été cartographiées :

**L'identifiant de l'IdP dans la couche domaine.** L'identifiant interne du provider — un claim émis par le token — était devenu l'identifiant utilisateur canonique dans tous les objets domaine. Chaque record de booking, ligne de paiement, log d'activité, et contrat API référençait l'identifiant du provider. C'était un élément de la couche IdP embarqué dans les couches user management et domaine. Le provider faisait office de base de données utilisateurs de la plateforme — non par décision, mais parce qu'aucune autre décision n'avait été prise.

**La token verification dans le hot path de l'API.** La couche de token verification appelait l'API du provider auth à chaque requête entrante. Chaque appel API authentifié — chargements de pages, actions utilisateurs, fetch de données — était un appel réseau externe synchrone vers un service tiers. L'effet : 50 à 300 ms de latence externe à chaque requête, une dépendance de disponibilité sur le provider pour chaque utilisateur à chaque instant, et les rate limits API du provider qui devenaient les rate limits de la plateforme sous charge.

Le pattern correct est la vérification cryptographique locale : parser le JWT, vérifier la signature contre les clés publiques publiées par l'émetteur (récupérées une fois, mises en cache via JWKS), valider les claims. C'est une opération locale avec zéro appel réseau en régime normal. Le provider appartient au cold path — le login — pas au hot path.

**L'état d'autorisation dans la mauvaise couche.** Les rôles et les données liées aux permissions étaient partiellement gérés via les custom attributes et les group constructs du provider auth. L'authorization est une préoccupation domaine. Qui peut faire quoi, dans quel contexte, sous quel tenant — ça appartient à la base de données de la plateforme, dérivé de son propre modèle domaine. L'IdP prouve l'identité. Ce que cette identité est autorisée à faire ne concerne pas le provider.

---

## Phase 1 — Nommer la dette avant d'y toucher

La première phase était une décision de cadrage, pas d'implémentation.

Les choix pragmatiques faits pendant la transition étaient corrects pour ce moment-là. Rouvrir le modèle d'identité sous pression de vélocité aurait ralenti le travail qui devait réellement avancer. La décision était donc de continuer, documenter la contrainte explicitement, et s'engager sur un cleanup défini — pas un backlog ouvert, mais une dette nommée avec un propriétaire et un périmètre.

Ce cadrage avait de l'importance. Il signifiait que le cleanup arrivait avec une propriété claire et une condition d'arrêt définie, plutôt que comme un refactoring ouvert déclenché par l'accumulation de friction.

---

## Phase 2 — Redessiner les frontières et exécuter le cleanup

La deuxième phase a démarré une fois la stabilité de la plateforme restaurée.

**Les règles d'abord.** Un identifiant utilisateur interne à la plateforme — généré par la plateforme, opaque pour le provider auth — est devenu le primitif utilisateur canonique dans tout le système. L'identifiant du provider auth a été confiné à une frontière auth étroite. Toute occurrence en dehors de cette frontière était classifiée comme un défaut architectural : pas une suggestion de code review, pas un item de backlog, mais une violation à rejeter.

Ces règles ont été publiées sous forme de documents de frontières architecturales placés là où la planification, l'implémentation et la review avaient déjà lieu. Ça les rendait actionnables plutôt que consultatives.

**L'enforcement programmatique.** Des guardrails d'analyse statique empêchaient les identifiants spécifiques au provider de traverser vers les modules domaine sans être détectés. Un tracking metric hebdomadaire comptait les violations restantes dans la codebase. Quand le cleanup a un nombre visible et une condition d'arrêt concrète, il finit. Quand il est diffus, il ne finit pas.

**L'exécution divisée délibérément.** Un senior engineer portait le refactoring structurel des modules domaine centraux. Les autres contributeurs nettoyaient les violations rencontrées dans leur flow de delivery habituel. Ça a empêché le cleanup de devenir un projet bloquant ou de se concentrer sur une seule personne.

Le périmètre complet a été terminé en environ deux mois pour une codebase de cette taille et cette surface — plus vite que ce type de refactoring structurel ne progresse habituellement, principalement parce que le modèle était explicite, l'enforcement était programmatique, et la progression était mesurée sur un metric réel.

---

## Phase 3 — Le chemin enterprise : IdP de l'acheteur via un broker vers la plateforme

La troisième phase adressait la trajectoire suivante de la plateforme.

Le business model exigeait une authentification enterprise-grade : intégration avec les identity providers des organisations acheteuses, support des protocoles qu'elles utilisent, et gestion du cycle de vie des comptes déléguée aux systèmes de l'acheteur.

**La structure de l'auth enterprise en B2B SaaS.** Dans un contexte B2B SaaS, l'authentification enterprise a une forme spécifique : les employés de l'acheteur s'authentifient auprès de l'identity provider de l'acheteur — Okta, Microsoft Entra ID, une instance Keycloak self-hosted. Ce provider émet une assertion signée (SAML ou OIDC). Le SaaS reçoit cette assertion, la vérifie, et la mappe au bon user record et à la bonne session.

La couche entre le SaaS et l'IdP de l'acheteur est l'identity broker. Sa fonction : normaliser N configurations d'IdP clients, N variantes protocolaires, N attribute mappings en une seule API. Gérer l'admin portal self-service pour que les équipes IT clients configurent les connexions indépendamment. Abstraire les échanges de metadata SAML par client et les rotations de certificats. C'est le problème de fédération multi-tenant — il compound avec chaque client enterprise ajouté. Le construire en interne est un engagement opérationnel permanent qui évolue mal.

**Les deux options évaluées pour la stack auth existante.** Le service d'authentification managé en place pouvait supporter la fédération SAML et OIDC. Mais le SSO enterprise multi-tenant à l'échelle — configuration IdP par tenant, admin portal self-service, gestion des endpoints SCIM par client — exigeait de construire une couche custom significative par-dessus. Évalué, rejeté : ce chemin aurait recréé la couche broker, sous-dimensionnée, dans un service portant déjà plus de responsabilité qu'il ne devrait.

L'alternative : introduire un identity broker dédié pour les nouveaux tenants enterprise, et laisser le service d'authentification managé existant en place pour le tenant interne de l'entreprise où il fonctionne et où le risque de migration ne justifie pas le coût.

**L'architecture résultante pour les tenants enterprise :**

```
Employé de l'acheteur
  → IdP de l'acheteur (Okta, Entra ID, Keycloak, etc.)
  → Identity broker (normalise SAML/OIDC, gère la config par tenant, gère SCIM)
  → Backend de la plateforme (reçoit le profil vérifié, émet son propre session token)
  → Base de données de la plateforme (user record, tenant, rôles, permissions)
```

Le tenant interne continue sur son chemin existant, inchangé.

**La token verification reste le même pattern quel que soit l'émetteur.** Les deux chemins émettent des JWTs. Les deux sont vérifiés localement contre le JWKS publié par l'émetteur. Le claim `iss` dans le token détermine quel key set utiliser. Deux émetteurs, deux endpoints JWKS, une couche de vérification. Le provider auth — quel qu'il soit — est sur le cold path. Le hot path est une vérification cryptographique locale.

La gestion du cycle de vie des comptes pour les tenants enterprise passe par SCIM : l'identity provider de l'acheteur pousse des événements de provisioning vers le broker, qui les transmet à la plateforme. Quelqu'un rejoint l'organisation : compte créé. Quelqu'un la quitte : accès révoqué. Aucune intervention manuelle, aucune dérive.

---

## Résultat

La plateforme est passée d'un état où les identifiants du provider auth étaient embarqués dans tout le domaine à un état avec une séparation propre des couches :

- Un identifiant utilisateur interne à la plateforme est canonique dans tous les objets domaine
- L'identifiant du provider auth est une référence externe, stockée une fois, isolée à la frontière auth
- La token verification est une opération cryptographique locale — aucun provider dans le hot path de l'API
- La logique d'autorisation opère entièrement depuis les données propres de la plateforme
- Les nouveaux tenants enterprise s'authentifient via un identity broker qui gère la fédération multi-tenant sans exposer cette complexité au backend
- Le tenant interne continue inchangé, avec un chemin de migration disponible le moment venu

Le cleanup a terminé le périmètre complet en environ deux mois — parce que le modèle était explicite, l'enforcement était programmatique, et la progression était mesurée sur un metric réel plutôt que gérée par coordination.

---

## Le principe qui tient

La décision de départ — ne pas posséder les mots de passe, ne pas devenir un Identity Provider — était juste et cascade correctement à chaque couche de la stack.

La même logique s'applique à l'identity broker : ne pas construire la matrice N-IdPs × M-protocoles en interne quand le problème est déjà résolu et que le coût de le construire compound avec chaque client.

La même logique s'applique à la token verification : le provider émet un token une fois au login. Le backend le vérifie localement à chaque requête. Le provider appartient au cold path.

Le failure mode n'est pas la mauvaise première décision. C'est prendre la première décision sans nommer ce qui vient après. Chaque couche non nommée défaute vers le vendor disponible — pragmatiquement, invisiblement — jusqu'au moment où la pression d'évolution rend le coût du démêlage prohibitif.

Le cadre de décision pour savoir quand déléguer l'auth et comment lire le plafond de chaque approche — avant que le couplage devienne de la dette — est couvert dans [Auth SaaS : les couches que les opérateurs traitent comme une seule décision](/fr/writing/saas-auth-the-good-the-bad-and-the-ugly/).
