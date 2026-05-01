---
title: "SaaS Auth : le bon, la brute et le truand"
description: "Un guide de terrain pour les opérateurs qui construisent du B2B SaaS — ce qu'est vraiment l'auth, les failure modes qui font le plus mal, et quand déléguer plutôt que construire."
date: 2026-05-01
highlight: false
order: 7
---

## L'analogie Stripe que personne n'applique à l'auth

Personne ne construit son propre payment gateway. Quand le produit doit accepter des paiements, on prend Stripe, Adyen, ou Braintree. Le raisonnement est évident : le risque de mal faire est asymétrique, la complexité d'implémentation est réelle, et les outils pour déléguer existent.

L'auth ne bénéficie pas du même traitement.

La plupart des opérateurs la traitent comme une case à cocher — "login utilisateur, quelques rôles, ce que propose le cloud provider, c'est bon" — et passent à autre chose. Ça tient. Jusqu'au moment où ça ne tient plus. À ce stade, les identifiants du provider sont embarqués dans tous les recoins du système, le deal enterprise est bloqué parce que la plateforme ne supporte pas l'Okta de l'acheteur, et le refactoring pour corriger ça prend des mois, pas des jours.

Ce guide est là pour que cette décision soit prise consciemment — avant que la dette technique ne la prenne à votre place.

---

## Ce qu'est vraiment l'auth

La plupart des opérateurs confondent trois systèmes distincts sous le mot "auth." Les garder séparés est la base de toutes les bonnes décisions qui suivent.

**Authentication (AuthN)** — prouver l'identité. Le rôle du provider : vérifier un credential (mot de passe, code MFA, assertion SSO d'un identity provider d'entreprise) et émettre un token signé. C'est là que vivent Cognito, Firebase Auth et Auth0.

**Authorization (AuthZ)** — décider l'accès. Le rôle du backend : vérifier le token, charger les rôles et permissions depuis sa propre base de données, appliquer les règles métier. Qui peut faire quoi, dans quel contexte, sous quelles conditions.

**Gestion des utilisateurs** — le cycle de vie. Créer des comptes, mettre à jour des profils, attribuer des rôles, déprovisionner quand quelqu'un quitte l'organisation. Partiellement la responsabilité de la plateforme, partiellement celle de l'identity provider de l'acheteur — selon jusqu'où on monte en gamme.

Pourquoi cette distinction compte : les providers auth sont conçus pour bien faire l'AuthN. Quand on s'appuie sur eux pour les trois, on crée un couplage qui s'accumule silencieusement. Les identifiants du provider s'embarquent dans la logique métier. Le modèle d'autorisation dépend de données qui vivent dans une boîte noire qu'on ne contrôle pas. Le cycle de vie des utilisateurs passe par la console du provider plutôt que par son propre backend.

Ça fonctionne. Jusqu'au moment où il faut faire évoluer n'importe lequel de ces éléments.

---

## Les failure modes

### La brute

**Utiliser le provider auth comme base de données utilisateurs.**

Le provider émet un identifiant — un claim `sub`, un Cognito user ID. Il est là, dans le JWT. On commence à l'utiliser partout : les enregistrements de booking, les lignes de paiement, les logs d'activité, les contrats d'API. Des mois plus tard, on veut ajouter du SSO enterprise, ou changer de provider, ou nettoyer le modèle d'autorisation. On découvre l'identifiant du provider dans 25 modules, des colonnes de base de données, des event handlers, et des payloads d'application mobile. Ce qui aurait dû être un point d'intégration étroit est devenu la structure portante du système. La migration qui attend se mesure en mois d'ingénierie.

**Les provider IDs qui fuient dans la logique métier.**

Même cause racine, surface différente. Une entité booking a une colonne `cognito_user_id`. Un enregistrement de paiement porte l'identifiant du provider. Les événements GPS routent sur la clé utilisateur du provider auth. L'authentification et la logique domaine sont maintenant couplées sémantiquement — pas à la frontière où c'est intentionnel, mais partout dans le système où c'est invisible. Ce ne sont pas des bugs. Ils s'accumulent comme des décisions de développement normales prises sans règle claire. Le cleanup, quand il arrive, n'est pas un hotfix.

**Utiliser les groupes du provider pour les rôles.**

Les Cognito groups, les `app_metadata` Auth0 — ça semble raisonnable pour marquer "cet utilisateur est driver, celui-là est admin." Le problème : les rôles vivent maintenant dans une boîte noire qu'on ne contrôle pas pleinement, les décisions d'accès dépendent de données extérieures à sa propre base de données, et il n'y a pas de source de vérité que son propre code possède. Les rôles appartiennent à la base de données, dérivés du modèle domaine. Le provider auth prouve l'identité. C'est là que s'arrête son autorité.

### Le truand

**Coupler chaque requête API au réseau du provider.**

Ça paraît être la bonne façon de valider un token : appeler la source de vérité à chaque requête. En pratique, on vient d'ajouter un appel réseau externe synchrone à chaque requête authentifiée de l'application — 50 à 150ms de latence, un rate limit du provider qui devient son propre rate limit, et une dépendance de disponibilité où toute dégradation de Cognito affecte chaque utilisateur, chaque endpoint, à chaque instant. Le bon pattern est la vérification locale du JWT : vérifier la signature contre des clés publiques mises en cache, aucun appel réseau. C'est une opération cryptographique locale. Elle coûte des nanosecondes, pas des millisecondes. Si personne dans l'équipe ne sait que c'est problématique, ça tourne silencieusement en production jusqu'à ce que la charge l'expose.

**Pas de plan pour le plafond du provider.**

Chaque provider auth a un plafond. AWS Cognito gère bien l'identité à l'échelle consumer. Le SSO enterprise multi-tenant, il le gère mal — pas de modèle organisation natif, pas de portail admin self-service pour les équipes IT des entreprises, une configuration par tenant qui nécessite du code custom pour être mise en place. Si la feuille de route inclut de vendre à des grandes organisations, et que la couche auth a été conçue pour autre chose, il y a une migration dans le futur. La planifier tôt ne coûte presque rien. La découvrir pendant une conversation de procurement enterprise coûte beaucoup plus.

---

## Ce dont le SaaS a réellement besoin

Les exigences auth divergent significativement selon à qui on vend.

| Marché | AuthN | SSO enterprise | SCIM |
|---|---|---|---|
| B2C / consumer | Email, social login | Non | Non |
| B2SMB (≤ 50 employés) | Email + Google/Microsoft OIDC | Parfois | Rarement |
| B2B mid-market | SSO optionnel | Oui pour les grands comptes | À la demande |
| B2B enterprise (1000+ employés) | SSO obligatoire | Oui, prérequis | Attendu |
| Réglementé / souverain | SSO + audit logs + conformité | Oui, souvent IdP on-prem | Requis |

Le saut de "SSO optionnel" à "SSO obligatoire" surprend la plupart des opérateurs. Ce n'est pas une demande de feature. C'est une case à cocher dans le procurement. Les grandes organisations ne peuvent pas centraliser la gestion des credentials et le déprovisionnement sans que tous les SaaS connectés supportent le SSO. Dire qu'on ne le supporte pas revient à dire qu'on ne peut pas figurer sur la liste des vendors approuvés.

Un cas particulier à noter : certains acheteurs enterprise sont petits en effectifs — une direction financière, une unité opérationnelle, dix utilisateurs. Mais ils appartiennent à une grande organisation dont la politique IT impose le SSO pour tous les outils tiers. Le contexte enterprise ne scale pas avec le nombre d'utilisateurs. Il scale avec le processus d'achat. Cinq utilisateurs dans une grande banque ont quand même besoin du SSO.

---

## Le primer protocoles

Pas besoin de les implémenter. Il faut savoir ce qu'on achète.

**SSO (Single Sign-On) :** Le concept — un login unique donne accès à plusieurs applications. Les utilisateurs s'authentifient une fois auprès de l'identity provider de leur entreprise ; chaque outil connecté accepte le résultat. Pour l'acheteur : les employés utilisent leur compte d'entreprise, l'IT contrôle les accès de façon centralisée, le déprovisionnement est immédiat.

**SAML 2.0 :** Le protocole dominant pour le SSO enterprise. Basé sur XML, limité au navigateur, nécessite un échange de métadonnées entre l'application et l'identity provider du client. Lourd à configurer manuellement, mais chaque équipe IT enterprise le connaît. L'attente par défaut dans les questionnaires de procurement enterprise.

**OIDC (OpenID Connect) :** Le protocole moderne — basé sur JSON/JWT, plus léger à intégrer, fonctionne avec les APIs et les applications mobiles. Les identity providers enterprise modernes (Okta, Microsoft Entra) supportent les deux. Le social login ("Sign in with Google") est aussi OIDC. La direction de voyage pour les nouvelles intégrations.

**SCIM :** Pas de l'auth — de la gestion du cycle de vie. L'application expose un endpoint SCIM ; l'identity provider du client pousse des événements create/update/deactivate quand les systèmes RH ou IT changent. Quand un employé est licencié, SCIM propage ça automatiquement à tous les SaaS connectés. Le JIT provisioning (créer un compte à la première connexion SSO) est l'alternative pragmatique pour les premiers clients enterprise — suffisant jusqu'à ce que les questionnaires de procurement demandent explicitement le SCIM.

---

## La matrice de décision

| Approche | Enterprise-ready | Charge ops | Risque de migration | Quand |
|---|---|---|---|---|
| Auth managé simple (Cognito, Firebase) | Partielle | Faible | Élevé si sur-étendu | Early stage, B2C, B2SMB |
| Étendre Cognito pour le SSO | Partielle (douloureux à l'échelle) | Moyen | Élevé | Peu de clients enterprise, déjà sur AWS |
| Auth0 / Okta | Oui | Faible | Moyen | Écosystème Okta existant ; besoins complexes |
| Auth broker (WorkOS, Stytch) | Oui | Faible | Faible | Vente enterprise, équipe trop petite pour gérer l'infra auth |
| Self-hosted (Keycloak) | Oui | Très élevé (0,25–1 FTE ongoing) | Faible | Souveraineté des données, environnement réglementé |
| Build full custom | Dépend | Très élevé | Contrôle total | Capacité ingénierie auth et besoins spécifiques |

L'analogie tient encore : Stripe existe non pas parce que les paiements sont impossibles à construire, mais parce que la plupart des équipes ont mieux à faire que les construire. La même logique s'applique à l'auth au niveau enterprise. Un auth broker à 125 $/connexion enterprise par mois est négligeable par rapport au coût d'un deal enterprise bloqué parce qu'on ne pouvait pas supporter SAML à temps.

---

## Comparaison des outils

| Outil | SAML/OIDC | SCIM | Self-hosted | Modèle tarifaire | Idéal pour |
|---|---|---|---|---|---|
| **WorkOS** | Oui | Oui | Non | Par connexion (65–125 $/mois) | SaaS Series A–C, motion de vente enterprise rodée |
| **Stytch B2B** | Oui | Oui* | Non | MAU + par connexion ; 5 offertes | Early-stage, validation de la demande enterprise |
| **Auth0 (Okta)** | Oui | Oui | Plan enterprise seulement | MAU + palier plan ; falaise après 5 connexions | Écosystème Okta existant ou besoins hybrides complexes |
| **Frontegg** | Oui | Oui | Non | MAU + features ; tier gratuit (5 connexions) | Équipes qui embarquent un portail admin tenant dans le produit |
| **Clerk** | Oui | Non | Non | Par connexion (15–75 $/mois) | Produits PLG / developer ; pas prêt pour Fortune 500 |
| **SSOReady** | Oui | Oui | Oui (Apache) | Core gratuit ; enterprise custom | Environnements réglementés, contrainte coût, open source |
| **Keycloak** | IdP complet | Oui | Oui (obligatoire) | OSS gratuit ; build Red Hat disponible | Gouvernement, souveraineté EU, on-prem |
| **AWS Cognito** | SP uniquement | Non natif | AWS-hosted seulement | MAU (0,015 $/MAU SAML) | Équipes AWS-native, peu de clients enterprise |

*Statut GA du SCIM Stytch : à vérifier avant engagement.

**Note sur Clerk :** pas de support SCIM en début 2026. Quand un employé est supprimé d'Okta, l'application n'en est pas notifiée. C'est une lacune que la plupart des questionnaires de sécurité enterprise détectent.

**Note sur Auth0 :** la falaise tarifaire est réelle. Au-delà du cinquième client enterprise avec SSO sur le plan Professional, le contrat suivant nécessite une négociation enterprise custom. Des devis réels à ce palier pour de petits volumes d'utilisateurs ont été documentés à 30 000 $/an et au-delà.

---

## Le bon jugement

Si le marché est entièrement B2C ou SMB et que l'enterprise est à trois ans : utiliser ce qui est le plus simple. Ne pas sur-investir tôt. Cognito, Firebase Auth, une implémentation JWT propre — tout cela est approprié à ce stade. L'erreur à cette phase est d'investir dans une infrastructure auth dont on n'aura pas besoin avant des années.

Si la vente enterprise commence aujourd'hui — même à des petites équipes à l'intérieur de grandes organisations — la question n'est pas de savoir s'il faut supporter le SSO. C'est quelle couche gère la complexité protocolaire pour que l'équipe n'ait pas à le faire. Pour la plupart des équipes de moins de 20 ingénieurs, ça signifie déléguer. Le coût de la gestion de la configuration IdP par tenant, des échanges de certificats par client, et de la maintenance des endpoints SCIM est une charge opérationnelle permanente. Le coût d'un auth broker est prévisible, borné, et transfère la surface de sécurité à une équipe dont c'est le métier.

Si la souveraineté des données est une contrainte — secteur réglementé, acheteur gouvernemental, exigence de résidence EU — le calcul bascule vers le self-hosted (Keycloak) ou une option open source spécialisée (SSOReady). La charge ops est réelle, mais l'alternative peut ne pas être disponible.

---

## Prendre la décision avant qu'elle se prenne d'elle-même

Personne n'attend de traiter la première transaction pour décider d'utiliser Stripe. L'architecture paiement fait partie de la conception du produit dès le départ, parce que le coût de se tromper est immédiatement visible.

L'auth ne casse pas immédiatement. Elle casse quand il faut faire évoluer — nouvelle exigence enterprise, nouveau provider, nouveau marché. Et à ce moment, le coût n'est pas l'implémentation. C'est le démêlage de chaque choix pragmatique fait sous pression, avant que quiconque pense que ça aurait de l'importance.

Les décisions sont simples quand elles sont prises tôt. Les outils sont matures. Les options sont claires.

Prendre la décision avant que le questionnaire de procurement enterprise ne la prenne à votre place.
