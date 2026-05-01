---
title: "Auth SaaS : les couches que les opérateurs traitent comme une seule décision"
description: "Un guide de terrain pour les opérateurs B2B SaaS : les couches fonctionnelles derrière le mot 'auth', comment les exigences évoluent par segment de marché, et ce qui se passe quand on les confond."
date: 2026-05-01
highlight: false
order: 7
---

## La décision que la plupart des opérateurs prennent correctement — et ce qui suit

La première décision auth que la plupart des opérateurs prennent correctement : ne pas gérer les mots de passe. Ne pas devenir un Identity Provider. Ne pas construire l'infrastructure cryptographique, le stockage des credentials, la réponse aux incidents de sécurité, les flows MFA. Déléguer ce risque à un tiers spécialisé. Les outils existent, les protocoles sont standardisés, et il n'y a aucun avantage concurrentiel à faire ça soi-même.

Cette décision conduit naturellement au bon premier choix d'implémentation : utiliser un service d'authentification managé. AWS Cognito, Firebase Auth, Supabase Auth — n'importe lequel gère la vérification des credentials et l'émission de tokens. La couche IdP est résolue. On passe à la suite.

Le problème commence avec ce qui suit.

Parce que l'auth n'est pas une seule couche — c'en est plusieurs. Et une fois la première correctement déléguée, les suivantes ont toujours besoin de réponses explicites. La plupart des opérateurs ne les donnent pas. Ils laissent le premier vendor s'étendre par défaut. Ou ils livrent la première couche sans nommer les autres, et découvrent la structure manquante lors d'un appel procurement pour un deal enterprise.

Ce guide est là pour prendre ces décisions avant qu'elles ne se prennent d'elles-mêmes.

---

## Ce que "auth" regroupe en réalité

"Auth" est un raccourci pour une stack de couches fonctionnelles distinctes. Ces couches existent quel que soit le vendor ou le protocole utilisé — elles décrivent des *rôles*, pas des produits. Un seul vendor remplit souvent plusieurs rôles, et c'est exactement ce qui crée la confusion.

### Identity Provider (IdP)

Le système qui authentifie les utilisateurs — qui prouve que cette personne est bien qui elle prétend être. Il détient ou fédère les credentials, gère la vérification multi-facteurs, et émet des assertions signées en aval : une réponse SAML ou un token OIDC.

En contexte B2C ou SMB, l'IdP est généralement sous contrôle de l'opérateur. AWS Cognito ou Firebase Auth pour les utilisateurs email/password, Google ou Apple pour le social login. On fait soit tourner un service IdP managé, soit on délègue à l'un d'eux.

En contexte B2B enterprise, l'IdP appartient à l'acheteur. Leur tenant Okta, leur Microsoft Entra ID, leur instance Keycloak — c'est l'autorité. Quand un employé se connecte à un outil que l'entreprise a acheté, il s'authentifie auprès de l'IdP de l'entreprise, pas du SaaS. Le SaaS ne détient aucun credential pour ces utilisateurs. Il fait confiance aux assertions d'un IdP qu'il ne gère pas.

Cette distinction — qui gère l'IdP — est le premier axe de toute décision d'architecture auth.

### Identity broker

La couche entre l'application et l'IdP de l'acheteur. Quand on a plusieurs clients enterprise, chacun avec son propre IdP, chacun avec sa configuration SAML ou OIDC, le broker normalise cette complexité en une seule API que le backend utilise.

Cette couche a récemment trouvé un nom. Le pattern s'appelait "federation broker" dans la littérature académique sur l'identité, mais le terme identity broker est devenu un terme d'opérateur vers 2022, quand des produits dédiés ont émergé pour résoudre ce problème. Avant ça, les équipes construisaient cette couche elles-mêmes et l'appelaient "l'intégration SAML" — une description qui sous-estime largement le périmètre réel.

Le problème du broker : N IdPs clients × M protocoles (SAML 2.0, OIDC) × configuration par client × un admin portal self-service pour les équipes IT de chaque client. C'est un investissement engineering permanent, pas un ticket. Il compound avec chaque client enterprise ajouté. WorkOS, Stytch B2B, et SSOReady existent parce que l'industrie a convergé vers "cette couche vaut la peine d'être achetée".

| Vendor | SAML | OIDC | SCIM | Admin portal | Modèle |
|---|---|---|---|---|---|
| **WorkOS** | ✓ | ✓ | ✓ | ✓ | Payant — par connexion |
| **Stytch B2B** | ✓ | ✓ | ✓ | ✓ | Payant |
| **Frontegg** | ✓ | ✓ | ✓ | ✓ | Payant — features app bundlées (RBAC UI, etc.) |
| **Auth0 (Okta CIC)** | ✓ | ✓ | ✓ | ✓ | Payant — large, mature, coûteux |
| **Clerk** | ✓ | ✓ | Partiel | ✓ | Payant — origines B2C, SCIM enterprise en maturation |
| **SSOReady** | ✓ | ✓ | ✓ | ✓ | Open-source / self-hosted |
| **Keycloak** | ✓ | ✓ | ✓ | ✓ | Open-source / self-hosted — ops complet |

Le broker n'est pas l'IdP. Le broker ne possède pas l'identité — il fédère vers des IdPs qui le font. Les confondre est une des erreurs auth les plus coûteuses : traiter un broker comme une base de données utilisateurs, puis découvrir le couplage quand il faut migrer.

### Token verification

Comment le backend vérifie l'identité à chaque requête API.

Le pattern correct est la vérification cryptographique locale : parser le JWT depuis l'Authorization header, vérifier la signature contre les clés publiques publiées par l'émetteur (récupérées une fois, mises en cache — c'est le rôle de JWKS), valider les claims standards. C'est une opération locale. Elle coûte des microsecondes. Zéro appel réseau en régime normal.

L'anti-pattern courant est d'appeler le provider auth à chaque requête pour valider le token — invoquer l'API du service auth pour chaque appel entrant. Ça ajoute jusqu'à 300 ms à chaque requête authentifiée, consomme les rate limits API du provider, et rend la disponibilité de l'application dépendante de la disponibilité du provider pour chaque utilisateur, chaque endpoint, chaque seconde. C'est silencieux en développement et visible sous charge.

AWS publie `aws-jwt-verify` spécifiquement parce que cette erreur est assez répandue pour mériter une librairie officielle. Le pattern est documenté : vérifier les tokens localement, via JWKS.

Le backend vérifie les tokens. Le provider auth les émet, une fois, au login.

### User management

Votre base de données. Pas celle du provider auth.

Le provider authentifie l'utilisateur et transmet un claim d'identité vérifié — une adresse email, un identifiant stable, un nom. Ce que l'application fait de cette identité relève entièrement de son domaine : à quel tenant l'utilisateur appartient, quels rôles il détient, quelles permissions il a, à quoi ressemble son profil, quelles données lui appartiennent.

L'erreur classique est de laisser l'identifiant interne du provider devenir l'identifiant primaire de l'application. Les records de booking référencent le sub du provider. Les lignes de paiement portent l'identifiant du provider. Les logs d'activité, les contrats API — l'ID du provider est partout. Des mois plus tard, quand on veut ajouter du SSO enterprise, migrer de provider, ou nettoyer le modèle d'autorisation, on trouve ce qui aurait dû être un point d'intégration étroit devenu la structure portante du modèle de données. Le coût de migration se mesure en mois d'ingénierie.

Posséder son user ID. Il est généré par le système, vit dans la base de données, et est stable à travers les changements de provider auth. L'identifiant du provider est stocké une fois, comme référence externe. Le domaine n'en dépend jamais.

Le détail de ce que ce couplage provoque dans une plateforme live — comment il s'accumule et comment il se résout — est documenté dans [Délimiter les couches d'authentification dans un système en production](/fr/work/untangling-auth-layer-boundaries-in-a-running-system/).

### User provisioning (SCIM)

La gestion du cycle de vie des comptes. Cette couche tourne sur un protocole différent, à un moment différent : pas "qui se connecte maintenant" mais "qui devrait avoir accès, et cet accès est-il synchronisé avec les systèmes RH et IT de l'acheteur".

Quand quelqu'un rejoint une entreprise, son compte devrait exister dans les outils achetés avant qu'il en ait besoin le premier jour. Quand quelqu'un part, son accès devrait être révoqué partout au moment où il est off-boardé dans le système RH — pas à sa prochaine tentative de connexion, pas quand un admin IT pense à le supprimer.

SCIM 2.0 (System for Cross-domain Identity Management) est le protocole qui gère ça. L'identity provider de l'acheteur pousse des lifecycle events — user créé, mis à jour, désactivé — vers un endpoint exposé par l'application. L'application les traite et maintient l'accès synchronisé.

Le just-in-time (JIT) provisioning — créer un compte à la première connexion SSO — est un fallback acceptable pour les clients SMB et les premiers clients enterprise. Il ne tient pas à l'échelle parce qu'il ne peut pas déprovisionner, ni pré-provisionner, ni synchroniser les changements de group membership en temps réel.

### Session management

La couche "vous êtes toujours connecté". Tokens d'accès à courte durée de vie, rotation des refresh tokens, session timeouts configurables, forced logout, limites de sessions concurrentes. Les équipes IT enterprise veulent que ça soit configurable par tenant : sessions courtes pour les environnements sensibles, sessions longues pour la productivité, re-authentification forcée après un changement de credential.

### Authorization

Qui peut faire quoi, dans quel contexte. Vos rôles, vos permissions, vos règles métier. Cette couche vit entièrement dans l'application — dans la base de données et la logique backend.

Le provider auth prouve l'identité. L'application décide ce que cette identité est autorisée à faire.

Cette séparation compte parce que le modèle d'autorisation évolue indépendamment du modèle d'authentification. Les rôles changent avec le produit. La logique de permissions se complexifie. Si les rôles sont stockés dans les custom claims ou les metadata du provider auth, chaque changement de rôle se propage par la sémantique JWT plutôt que par une mise à jour de base de données. Le cleanup est disproportionné par rapport à la commodité qui l'a créé.

---

## Comment les exigences changent selon le marché

Les bonnes réponses à chaque couche dépendent de qui on vend.

| Couche | B2C | B2SMB (≤50) | B2B mid-market | B2B enterprise | Réglementé |
|---|---|---|---|---|---|
| **Identity Provider** | IdP managé ou social login | Google / Microsoft OIDC + IdP managé | Mix IdP managé + IdP corporate de l'acheteur | L'IdP de l'acheteur fait autorité | IdP de l'acheteur obligatoire ; self-hosted (Keycloak) dans les contextes souverains/réglementés |
| **Identity broker** | Pas nécessaire | Pas nécessaire | Optionnel — quelques clients enterprise gérables manuellement | Requis — au-delà de quelques clients, le SAML multi-tenant interne devient une charge permanente | Requis ; broker self-hosted souvent |
| **Token verification** | JWKS local — toujours | JWKS local — toujours | JWKS local — toujours | JWKS local — toujours | JWKS local + audit trail immuable |
| **User management** | Votre DB — toujours | Votre DB — toujours | Votre DB — toujours | Votre DB — toujours | Votre DB — toujours |
| **Provisioning** | Pas nécessaire | JIT suffit | JIT acceptable ; SCIM pour les grands comptes | SCIM requis | SCIM requis + logs audit-grade |
| **Session management** | Basique | Configurable | Configurable par tenant | Requis : policy par tenant, forced logout, limites de sessions | Contrôles stricts ; souvent imposés par compliance |
| **Authorization** | RBAC simple | Role-based | RBAC tenant-aware | RBAC tenant-aware, attribute-based controls | Fine-grained ; parfois policy engine externe |

Trois points de cette table qui surprennent le plus souvent les opérateurs :

**Le SSO est un hard gate procurement, pas une demande de feature.** Les acheteurs enterprise ne peuvent pas gérer les credentials centralement ni off-boarder les employés proprement sans que chaque SaaS connecté supporte le SSO. "On ne le supporte pas" se traduit directement par "on ne peut pas figurer sur votre liste de vendors approuvés." Le seuil ne dépend pas des effectifs — une équipe de 30 personnes dans une banque de 50 000 personnes a besoin du SSO parce que la politique IT de l'organisation parente l'impose pour tous les outils tiers.

**SAML n'est pas déprécié.** OIDC est le protocole moderne — JSON, REST-native, fonctionne avec le mobile et les APIs. SAML 2.0 est le standard de 2005 — XML, browser-mediated, intégration plus lourde. Les nouvelles intégrations SaaS partent sur OIDC quand les acheteurs l'acceptent. Les équipes IT enterprise avec de l'infrastructure legacy, les auditeurs compliance, et les industries réglementées exigent souvent SAML spécifiquement. Quiconque vend à l'enterprise doit supporter les deux. "OIDC uniquement" ferme le deal sur des critères techniques et le rouvre sur une demande SAML six mois plus tard.

**SCIM devient un hard gate au-dessus du mid-market.** Le déprovisionnement manuel rate les audits compliance. SOC 2 Type II exige la preuve d'une révocation d'accès dans les délais. SCIM est cette preuve. Le JIT provisioning résout le "créer au premier login" ; le déprovisionnement est la partie que les équipes IT security exigent vraiment pour leur posture de sécurité.

---

## Ce qu'il faut déléguer, ce qu'il faut posséder

| Couche | Décision | Principe |
|---|---|---|
| **Identity Provider** | Déléguer | Ne jamais implémenter le stockage de credentials. Choisir selon le marché : IdP managé pour les utilisateurs qui n'apportent pas le leur ; se fier à l'IdP corporate de l'acheteur pour l'enterprise. |
| **Identity broker** | Déléguer dès que N > quelques clients enterprise | La matrice N-IdPs × M-protocoles est un problème engineering permanent qui compound avec chaque client. Les brokers dédiés existent parce que construire en interne est une charge opérationnelle permanente. |
| **Token verification** | Posséder — quelques centaines de lignes avec une librairie reconnue | Vérification JWKS locale avec une librairie. Le provider n'est pas dans le hot path de l'API. |
| **User management** | Posséder — toujours | Votre table users, vos IDs, votre schéma. L'identifiant du provider est une référence externe, pas la clé primaire. |
| **Provisioning** | Déléguer via broker ou construire l'endpoint SCIM | Le protocole est standardisé ; la partie difficile est l'UI admin self-service pour les clients. Les brokers gèrent ça ; construire en interne signifie posséder cette surface. |
| **Session management** | Construire avec une librairie | Tokens d'accès à courte durée de vie, rotation des refresh tokens, timeout configurable par tenant. |
| **Authorization** | Posséder ; scaler vers un policy engine si la complexité le justifie | Commencer avec du RBAC en base de données. Ajouter un policy engine externe si les règles de contrôle d'accès deviennent assez complexes pour nécessiter des tests indépendants. |

La décision du broker est celle où le calcul change le plus nettement avec l'échelle. Un client enterprise : câbler SAML manuellement. Trois clients : trois configurations, trois rotations de certificats, trois threads de support IT. Dix clients : on a reconstruit la couche broker soi-même, sous pression, sans l'outillage. À deux ou trois deals enterprise par trimestre, le coût par connexion d'un broker dédié est une erreur d'arrondi face au temps engineering requis pour construire et opérer la même chose en interne — plus le risque organisationnel de ce temps engineering devenant un engagement permanent.

---

## La décision avant qu'elle ne se prenne d'elle-même

Les décisions auth sont bon marché prises tôt. Les couches sont claires, les protocoles sont standardisés, l'outillage est mature. Chaque couche de cette stack a un failure mode bien compris, un fix bien compris, et un point bien compris à partir duquel le mauvais choix devient coûteux à inverser.

L'erreur n'est pas de choisir le mauvais vendor. C'est de ne pas nommer les couches du tout — de laisser chacune défauter vers "aussi le provider auth", puis de découvrir les frontières quand la pression d'évolution rend le refactoring coûteux.

La première décision — ne pas posséder les mots de passe — est correcte et cascade correctement à chaque couche. L'appliquer jusqu'au bout.
