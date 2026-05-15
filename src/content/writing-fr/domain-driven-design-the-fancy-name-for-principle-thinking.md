---
title: "Domain-Driven Design : le terme savant pour raisonner par principes"
description: "Le database-driven design était rationnel quand les migrations de schema étaient des opérations de production terrifiantes. Traîner cette habitude en 2026 ne l'est pas. Le DDD, c'est ce qui s'est passé quand l'industrie a corrigé l'erreur et donné un nom à la correction."
date: 2026-05-15
---

Évidemment que vous concevez autour de votre domaine. Pourquoi concevriez-vous autour d'autre chose ? Le fait que le domain-driven design soit devenu une discipline nommée — avec un livre et un circuit de conférences — vous dit que quelque chose a sérieusement cassé avant que quelqu'un décide de nommer la correction.

Ce n'était pas de la stupidité. Quand les databases étaient la contrainte la plus dure, les migrations de schema étaient des événements de production qui pouvaient bloquer des tables pendant des minutes. Commencer par le schema était de l'engineering rationnel sous une vraie pression.

## Ce qui a mal tourné

Les équipes concevaient les tables d'abord. Les modules s'organisaient autour des tables. Un "UserService" parce qu'il y a une table `users`. Un "OrderService" parce qu'il y a une table `orders`. La logique business dispersée dans n'importe quel service qui possédait la table concernée.

Résultat : un flow d'annulation touchant cinq tables signifiait cinq services différents, aucun owner clair, aucune boundary claire. Annuler un booking, rembourser un wallet, notifier un driver, mettre à jour un ledger, fermer une fenêtre de feedback — cinq équipes dans la salle. La database était l'architecture. Le business était un locataire secondaire dans son propre système.

C'était défendable sous de vraies contraintes : databases lentes, migrations coûteuses, schemas partagés entre plusieurs applications. L'erreur, c'est de traîner cette façon de penser en 2026, quand les migrations sont automatisées, les databases se provisionnent en quelques secondes, et le stockage n'est plus le goulot.

La contrainte a disparu. L'habitude est restée.

## Ce que ça signifie vraiment en pratique

Pas la définition académique. Celle qui change comment on construit.

Sur une plateforme de ride-hailing que j'ai dirigée, les vraies unités étaient booking, rider, wallet, driver, shift. Ce sont elles qui sont devenues les unités primaires de l'architecture. Pas les tables. Pas les DTOs. Le concept business. Le schema est venu après.

Ça paraît évident. Ça ne l'était pas. Le design précédent avait la logique de wallet dispersée dans le flow de booking, le processus de règlement des drivers, et un module utilitaire partagé qui avait tout accumulé. Personne n'en était owner. Les remboursements touchaient trois services. Les paiements des drivers touchaient quatre. Quand une nouvelle contrainte est apparue — l'état du wallet devait être cohérent à travers une annulation — il n'existait aucun endroit unique pour l'appliquer.

La correction consiste à rendre l'ownership explicite. Le wallet appartient au domaine user parce qu'un wallet ne peut pas exister sans un rider. C'est une vérité business, pas une préférence de design. Une fois qu'on la nomme, la structure suit : le wallet vit dans le domaine user, chaque transition d'état passe par un chemin unique défini, et le handler d'annulation ne négocie pas avec trois autres services pour savoir si un remboursement est valide.

La discipline plus difficile, c'est le langage. Le même terme dans le product spec, dans le code, dans la database, dans les conversations avec le PM. Pas "customer" dans l'UI, "user" dans le code, "account" dans le schema, "client" dans le contrat d'API. Un nom canonique, appliqué.

Quand le langage dérive, le modèle dérive. Quand le modèle dérive, des bugs apparaissent aux coutures — là où "user" dans un module essaie de parler à "account" dans un autre et quelqu'un écrit une mapping layer qui devient progressivement la version faisant autorité. La mapping layer est le symptôme. Les noms qui dérivent sont la maladie.

Les boundaries explicites découlent d'un ownership explicite. "User" dans le contexte booking — l'entité qui demande une course — est différent du "user" dans le contexte payment — l'entité avec une méthode de paiement et un historique de facturation. Tracer la boundary explicitement empêche la logique de booking de dépendre des spécificités du modèle payment et empêche votre handler d'annulation d'importer votre intégration Stripe.

## Où ça se manifeste dans les décisions architecturales

**La communication entre modules suit les domain boundaries.** La communication cross-domaine passe par des events — async pub/sub où le publisher ne sait rien du subscriber. À l'intérieur d'un domaine, l'injection directe est fine. Flouter cette ligne produit des dépendances circulaires, un couplage au déploiement, et l'impossibilité de modifier un domaine sans toucher trois autres.

**Le disguised function call.** On a shipé cette erreur une fois. Le service booking émettait un événement "BookingConfirmed" et attendait immédiatement la valeur de retour — le résultat d'une vérification du wallet dans un listener. En TypeScript avec un EventEmitter, si le listener n'est pas enregistré ou lève une exception, le caller reçoit `undefined` et aucune exception ne remonte. Le booking a confirmé. La vérification du wallet n'a jamais tourné. On l'a trouvé quand un utilisateur a signalé que sa course avait été confirmée mais que son wallet n'indiquait aucune déduction.

Les events existent pour découpler. Le moment où vous attendez la valeur de retour, vous avez détruit le découplage et ajouté les pires propriétés des deux approches : l'échec silencieux de l'async sans la type safety d'un appel direct. Utilisez un appel de fonction si vous avez besoin de la réponse. Il échoue bruyamment.

**Cohérence transactionnelle sans couplage.** Quand la confirmation de booking et la déduction du wallet doivent réussir ou échouer ensemble, la réponse n'est pas les events. C'est une transaction de database partagée. Le service booking ouvre une transaction, écrit dans la table booking, écrit dans la table wallet via le transaction manager de l'ORM, commit. Soit les deux se produisent, soit aucun. Le service wallet n'est jamais impliqué. Atomicité au niveau de la database, pas au niveau de l'application.

La transaction de database est le bon outil pour ça. Ce n'est pas une violation des domain boundaries — c'est l'infrastructure qui fait le travail de cohérence pour que l'application n'ait pas à le faire.

## Trois patterns qui méritent d'être connus

**Event-driven / pub/sub.** Communication cross-domaine où publisher et subscriber doivent évoluer indépendamment. Le domaine émet ce qui s'est passé ; quiconque a besoin de réagir, réagit. Le publisher ne sait rien d'eux.

**CQRS.** Séparer le write model du read model. Les writes vont dans la database transactionnelle optimisée pour la cohérence ; les reads vont dans un modèle optimisé pour les requêtes. Si vous faites déjà tourner une analytics database séparée de votre operational database, vous faites ça sans connaître le nom.

**Outbox pattern.** Écrire l'event dans une table outbox dans la même transaction que l'opération business. Un processus séparé publie depuis l'outbox. Atomicité business et livraison fiable des events, sans les coupler. Sans ça, publier un event après une transaction est une race condition.

## Pour conclure

Le DDD n'est pas un framework à installer. Pas un catalogue de patterns à mémoriser.

C'est la discipline de partir de ce qui est vrai dans le business, de laisser cette vérité piloter chaque décision structurelle, et de refuser de laisser la commodité technique inverser l'ordre.

Les engineers qui réussissent ne connaissent souvent pas les noms des patterns. Ils partent de : qu'est-ce que c'est, qui le possède, que peut-il lui arriver, qu'est-ce qui doit être vrai quand ça se produit. Ils arrivent à la bonne structure par le raisonnement.

La doctrine existe pour les équipes où tout le monde n'a pas encore développé cette capacité de raisonnement. C'est une carte pour les gens qui ne sont pas encore allés sur le terrain. Le nom, c'est juste pour les gens qui avaient besoin que quelqu'un l'écrive.

---

Les sept dimensions de la pratique d'engineering qui sous-tendent ce type de pensée structurelle — séparation des préoccupations, correctifs de cause racine, discipline des boundary architecturales — sont dans *[Engineering Practice Boundaries — Une seule barre pour engineers et AI](/fr/writing/engineering-principles-that-outlive-the-stack)*. Ce que ces principes donnent appliqués à une couche de gouvernance sur plusieurs surfaces produit — y compris la dérive des noms et l'application des boundaries — est dans *[Establishing Cross-Surface Architecture Governance](/fr/work/architecture-governance)*.
