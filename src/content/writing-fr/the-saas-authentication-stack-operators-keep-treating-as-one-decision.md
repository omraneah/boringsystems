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

## Les sept couches en 30 secondes

Avant les décisions, le vocabulaire. "Auth" est un raccourci pour sept couches fonctionnelles — chacune une décision distincte :

1. **Identity Provider (IdP)** — prouve qui est l'utilisateur. Soit le vôtre (Cognito, Firebase, Supabase Auth), soit celui de l'acheteur (son Okta, Entra ID, Keycloak).
2. **Identity broker** — fédère entre votre app et plusieurs IdPs côté acheteur. WorkOS, Stytch B2B, SSOReady et apparentés.
3. **Token verification** — votre backend vérifie chaque requête API, localement, via JWKS.
4. **User management** — votre base de données, vos user IDs, jamais l'identifiant du provider comme clé primaire.
5. **User provisioning (SCIM)** — le système RH / IT de l'acheteur pousse les lifecycle events vers un endpoint que votre application expose.
6. **Session management** — tokens d'accès à courte durée de vie, rotation des refresh tokens, configurable par tenant.
7. **Authorization** — rôles, permissions, règles métier. Votre logique de domaine, dans votre DB.

Les sections actionnables suivent. Le détail couche par couche — ce que fait chaque couche, comment elle échoue, pourquoi elle doit rester sa propre décision — est dans la seconde moitié du guide pour ceux qui veulent le *pourquoi* derrière chaque appel.

---

## Votre situation → votre stack

Les principes généraux se mappent sur la situation réelle. Six configurations d'opérateur, avec la décision :

**Vous êtes pre-PMF, B2C ou SMB, sur AWS ou GCP.** Stack : Cognito ou Firebase Auth, vérification JWKS, votre table users. Stop. Pas la peine de chercher un broker. Pas la peine de migrer vers Auth0 "pour être prêt à l'enterprise" — vous ne vendez pas à l'enterprise encore, et le coût d'être prêt est réel maintenant, le bénéfice est hypothétique. La seule chose à faire correctement : garder l'identifiant utilisateur de l'application séparé de celui du provider (cf. la section user management dans la seconde moitié du guide).

**Vous êtes pre-PMF sur un stack framework-native (Next.js, Remix, etc.) et pas encore sur un cloud managé.** Stack : Auth.js / Lucia / le helper de session du framework, votre DB, vérification JWKS le jour où vous ajoutez un IdP managé. Moins cher qu'un IdP managé, moins de pièces mobiles, pas de couplage vendor. On ajoute un IdP managé seulement quand on déborde — typiquement social login à l'échelle, recovery flows qu'on ne veut pas opérer, ou MFA qu'on ne veut pas rouler soi-même.

**Vous venez de signer votre premier client enterprise qui demande SAML.** Stack : on garde l'IdP existant. On ajoute un broker qui fait SSO et SCIM et rien d'autre. **SSOReady** (open source / managé) et **WorkOS broker-only** (par connexion) sont les deux bonnes réponses. On ne remplace pas l'IdP en même temps qu'on ajoute le SSO — on migrerait l'identité utilisateur et on ajouterait la fédération enterprise dans le même sprint, et l'un des deux va casser. On évite Auth0, Frontegg, Stytch B2B pour ce cas, sauf raison séparée de migrer l'IdP en même temps.

**Vous êtes à trois clients enterprise ou plus et l'équipe recâble le SAML à chaque fois.** C'est là que le coût par connexion d'un broker devient une erreur d'arrondi face aux heures engineering. **WorkOS** ou **SSOReady**. Si vous démarrez greenfield (pas d'IdP encore) et que le produit est B2B-shaped dès le jour un, **Stytch B2B** devient une vraie option — un seul vendor pour IdP plus broker — mais soyez honnête sur le lock-in : on ne sépare pas facilement les couches après, et post-acquisition Twilio la roadmap est en mouvement.

**Vous êtes en contexte réglementé, souverain, ou compliance-heavy.** L'IdP de l'acheteur fait autorité, souvent non négociable. Broker self-hosted (**Keycloak** ou SSOReady self-hosted). SCIM avec logs audit-grade est une exigence dure, pas un nice-to-have. Le coût bascule par rapport au monde SaaS : le temps engineering sur l'ops Keycloak est le ticket d'entrée, et il n'y a pas de raccourci.

**Vous êtes déjà locked-in sur Auth0, Frontegg, ou une autre plateforme complète depuis une décision antérieure.** On ne migre pas sauf forcing function : un cost cliff au tier suivant, une feature manquante exigée par l'acheteur (SCIM si vous êtes sur Clerk, provisioning temps réel si vous êtes sur Entra), ou un profil d'outage qu'on ne peut pas accepter. Le piège du sunk cost est faux — mais le piège inverse aussi. Le coût de migration est la facture pour switcher, et le nouveau vendor causera ses propres surprises. Migrer quand le calcul est clair, pas quand le dashboard agace.

Le pattern à travers les six : **la décision broker est en aval de la question "à quoi ressemblent les douze prochains mois de clients ?"** Pre-PMF, pre-enterprise, pre-procurement : la réponse est "utiliser ce qui est dans votre cloud, posséder votre user table, continuer à avancer". Au-delà de ces seuils, la couche broker devient une décision d'achat et la carte des vendors ci-dessous dit laquelle.

---

## La carte des vendors

Les vendors se divisent en deux groupes pour l'opérateur. Le **premier groupe** est conçu pour la couche broker (certains ont évolué en plateformes B2B complètes). Le **second groupe** rassemble les services auth génériques / cloud-native que les opérateurs adoptent tôt parce qu'ils sont déjà sur AWS / GCP / Supabase — ce ne sont *pas* des brokers, mais ils sont traités comme tels jusqu'au premier appel procurement enterprise qui révèle le manque. On liste les deux parce que l'arbre de décision réel inclut les deux.

Les colonnes sont opérateur-shaped : ce que le vendor couvre au-delà du brokering, la *forme* de la pricing (par connexion vs par MAU vs bundlé — les montants exacts changent, donc chaque ligne pointe vers la page pricing du vendor), choisir-si, éviter-si.

<div class="wide-table">
<table>
  <caption>Identity brokers et plateformes auth B2B</caption>
  <thead>
    <tr>
      <th>Vendor</th>
      <th>Au-delà du broker — ce qu'il couvre aussi</th>
      <th>Forme de pricing</th>
      <th>Choisir si</th>
      <th>Éviter si</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>WorkOS</strong></td>
      <td>IdP complet (AuthKit), sessions, MFA, RBAC, organisations, audit logs, admin portal acheteur, fraud (Radar), KMS (Vault)</td>
      <td>Par connexion, premium-priced, avec remises de volume ; AuthKit sur sa propre bande MAU — <a href="https://workos.com/pricing">workos.com/pricing</a></td>
      <td>Vous voulez un broker propre qui scale par deal enterprise, avec l'option d'adopter leur IdP complet plus tard</td>
      <td>Vous aurez une longue traîne de petits tenants enterprise — l'économie par connexion devient lourde</td>
    </tr>
    <tr>
      <td><strong>Stytch B2B</strong> <em>(Twilio)</em></td>
      <td>IdP complet, sessions, MFA, RBAC, organisations B2B, admin portal acheteur embarqué, M2M tokens, device fingerprinting</td>
      <td>Free tier généreux sur les MAU B2B + quelques connexions SSO/SCIM ; usage-based au-delà — <a href="https://stytch.com/pricing">stytch.com/pricing</a></td>
      <td>Vous démarrez B2B greenfield et voulez un seul vendor pour IdP + broker ; orgs multi-tenant dès le jour un</td>
      <td>Vous êtes averse au risque vendor — Twilio a racheté Stytch fin 2025, la roadmap est encore en mouvement</td>
    </tr>
    <tr>
      <td><strong>Frontegg</strong></td>
      <td>IdP complet, RBAC, orgs, login box hosté et admin portal acheteur, audit logs — fortement bundlé</td>
      <td>Starter gratuit (caps bas) ; SSO et features avancées payantes, sales-quoted — <a href="https://frontegg.com/pricing">frontegg.com/pricing</a></td>
      <td>Vous voulez toute la surface admin acheteur préfaite et vous ne voulez pas la designer</td>
      <td>Vous voulez une pricing transparente ou une intégration étroite — le bundling impose des choix UI et data-model</td>
    </tr>
    <tr>
      <td><strong>Auth0 (Okta CIC)</strong></td>
      <td>IdP complet, fédération, sessions, MFA, RBAC, orgs B2B, audit logs, attack protection</td>
      <td>Premium ; le SKU B2B est nettement plus cher que le B2C à la même bande MAU ; enterprise sales-quoted — <a href="https://auth0.com/pricing">auth0.com/pricing</a></td>
      <td>Vous êtes déjà sur Okta corporate, vous voulez tout dans une seule plateforme, et le budget n'est pas la contrainte</td>
      <td>Vous êtes sensible au coût — le saut SKU B2C → B2B est lourd ; enterprise va à six chiffres</td>
    </tr>
    <tr>
      <td><strong>Clerk</strong></td>
      <td>IdP complet, sessions, MFA, RBAC, orgs B2B, UI React préfaite. <em>Pas de SCIM natif en mai 2026</em></td>
      <td>Pro tier ; add-ons payants pour connexions SAML supplémentaires et bundle MFA+SAML ; add-on B2B au-dessus d'un seuil bas d'organisations — <a href="https://clerk.com/pricing">clerk.com/pricing</a></td>
      <td>B2C / prosumer ou B2B grand public avec UI préfaite ; stacks React-first</td>
      <td>Un acheteur enterprise demande SCIM directory sync — Clerk ne le ship pas nativement</td>
    </tr>
    <tr>
      <td><strong>SSOReady</strong></td>
      <td>SAML SSO et SCIM directory sync — et rien d'autre. Setup self-serve hosté, custom domain, management API. Explicitement <em>pas</em> un IdP</td>
      <td>Open source ; cloud managé gratuit pour usage typique ; payant uniquement pour le support SLA enterprise — <a href="https://ssoready.com/">ssoready.com</a></td>
      <td>Vous tournez déjà avec un IdP et vous voulez ajouter la fédération enterprise proprement, avec une option de sortie</td>
      <td>Vous avez aussi besoin de user pool, sessions, MFA, ou RBAC — hors scope par design</td>
    </tr>
    <tr>
      <td><strong>Keycloak</strong></td>
      <td>IdP complet, fédération, user mgmt, sessions, MFA, realms pour le multi-tenant. <em>SCIM uniquement via extensions communautaires, pas d'endpoint natif</em></td>
      <td>Gratuit / self-hosted ; le coût est opérationnel (clustering, DB, upgrades, monitoring) — <a href="https://www.keycloak.org/">keycloak.org</a></td>
      <td>Réglementé / souverain / self-host obligatoire et vous avez une équipe plateforme</td>
      <td>Petite équipe sans capacité ops — la console admin est dense, l'empreinte est lourde</td>
    </tr>
  </tbody>
</table>
</div>

La table suivante recense ce que les opérateurs utilisent réellement *avant* que la question du broker ne soit nommée — l'auth qui vient avec le cloud sur lequel ils sont déjà. Ce ne sont pas des brokers. Ils gèrent le rôle IdP pour les utilisateurs qu'on possède ; certains ajoutent la fédération enterprise, mais aucun ne résout le problème admin portal multi-clients ou SCIM-comme-procurement-gate. On les liste ici parce que c'est ce qu'un opérateur affronte réellement : "puis-je juste utiliser ce qui est déjà dans mon cloud ?" La réponse honnête dépend d'où on va.

<div class="wide-table">
<table>
  <caption>Services auth génériques / cloud-native (pas des brokers — listés parce que les opérateurs les confondent)</caption>
  <thead>
    <tr>
      <th>Service</th>
      <th>Couches couvertes (et les manques qui comptent)</th>
      <th>Forme de pricing</th>
      <th>Choisir si</th>
      <th>Éviter si</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Firebase Auth</strong></td>
      <td>IdP (email/password, social, phone), sessions, user mgmt basique. <em>Pas de SAML, pas d'OIDC, pas de SCIM, pas d'admin portal acheteur</em></td>
      <td>Bande consumer gratuite généreuse ; per-MAU au-delà — <a href="https://firebase.google.com/pricing">firebase.google.com/pricing</a></td>
      <td>Le chemin le plus rapide pour "les utilisateurs peuvent se connecter" sur un produit B2C ou mobile-first ; déjà sur Firebase</td>
      <td>Toute roadmap B2B-enterprise — il n'y a pas de chemin SAML ; on bolt-on un broker plus tard et on regrette le couplage</td>
    </tr>
    <tr>
      <td><strong>Google Cloud Identity Platform (GCIP)</strong></td>
      <td>Moteur Firebase Auth + SAML, OIDC, MFA, multi-tenancy, SLA. <em>Pas de SCIM, pas d'admin portal acheteur</em></td>
      <td>Petite bande gratuite sur les MAU enterprise ; per-MAU au-delà — <a href="https://cloud.google.com/identity-platform/pricing">cloud.google.com/identity-platform/pricing</a></td>
      <td>Vous êtes déjà sur GCP et vous avez besoin de SAML pour quelques clients enterprise</td>
      <td>Les acheteurs s'attendent à SCIM — aucun tier ne le ship ; l'UX admin multi-tenant est à construire</td>
    </tr>
    <tr>
      <td><strong>Supabase Auth</strong></td>
      <td>IdP (email, magic link, social, MFA), sessions ; SAML SSO sur tier payant. <em>Pas de SCIM, pas de primitive organisations native</em> — le multi-tenant est RLS + JWT claims à la main</td>
      <td>Bundlé avec le plan Supabase — <a href="https://supabase.com/pricing">supabase.com/pricing</a></td>
      <td>Vous tournez déjà sur Supabase Postgres et vous avez besoin de SAML SSO léger pour du B2B</td>
      <td>L'acheteur attend orgs / teams ou SCIM — vous construiriez la couche B2B sur Postgres vous-même</td>
    </tr>
    <tr>
      <td><strong>AWS Cognito</strong></td>
      <td>IdP (user pools), fédération (SAML, OIDC, social), MFA, hosted UI, groups (pas du vrai RBAC). <em>Pas de SCIM dans les user pools, pas d'admin portal acheteur</em></td>
      <td>Tarification MAU faible ; AWS-native — <a href="https://aws.amazon.com/cognito/pricing/">aws.amazon.com/cognito/pricing</a></td>
      <td>Déjà sur AWS, sensible au coût, prêt à construire la surface admin acheteur vous-même</td>
      <td>Vous montez en gamme — Cognito est workforce-shaped ; le SaaS multi-tenant gating sur SCIM est à construire</td>
    </tr>
    <tr>
      <td><strong>Microsoft Entra External ID</strong></td>
      <td>IdP, user mgmt, sessions, MFA, conditional access, SAML/OIDC ; SCIM nécessite licensing Entra ID workforce</td>
      <td>Tarification MAU avec free tier (remplace Azure AD B2C — fermé aux nouveaux clients en 2025) — <a href="https://learn.microsoft.com/en-us/entra/external-id/external-identities-pricing">microsoft.com / Entra External ID pricing</a></td>
      <td>Stack Microsoft-heavy vendant à des enterprises Microsoft-shop</td>
      <td>Vous voulez une DX vendor-neutre — la config s'appuie sur le portail Azure ; cadence SCIM lourde pour le temps réel</td>
    </tr>
  </tbody>
</table>
</div>

Deux patterns à voir à travers les deux tables. **Les vendors "tout-en-un" facturent le bundle qu'on l'utilise ou non.** Auth0, Frontegg, et dans une moindre mesure Stytch B2B et Clerk facturent la plateforme entière — la couche broker arrive avec l'IdP, les sessions, MFA, RBAC, l'admin portal, les audit logs, etc. Si on n'a besoin que de la fédération, on paie le reste. **Les vendors étroits (SSOReady, WorkOS broker-only) gardent la couche séparable** — au prix de devoir posséder l'IdP et le user pool. Le choix entre "bundle-moi tout" et "donne-moi seulement le broker" n'est pas une comparaison de features. C'est la question de savoir si on veut que l'auth soit une boîte qu'on arrête d'y penser, ou une couche séparable pour pouvoir swap n'importe quel morceau plus tard.

---

## Checklist pre-procurement de dix minutes

Quand l'équipe procurement ou IT d'un prospect enterprise pose des questions sur votre auth, déroulez cette liste avant de répondre "oui" à quoi que ce soit. La plupart des désastres procurement sont l'un de ces sept points sans réponse, pas un mauvais choix de vendor :

1. **Qui gère l'IdP ?** Le leur (Okta, Entra, Keycloak). Confirmation par écrit — jamais supposer.
2. **SAML ou OIDC ?** Les deux est le défaut sûr. "OIDC seulement" ferme le deal six mois plus tard quand l'auditeur demande SAML.
3. **SCIM ?** Au-delà de quelques centaines d'employés, attendez-vous à oui. JIT-only rate l'audit SOC 2 Type II sur la preuve de déprovisionnement.
4. **Policy de session ?** Timeout configurable, forced logout, limites de sessions concurrentes — ils vont demander, et "on ne le supporte pas" est un non.
5. **Audit logs ?** Login events, changements de rôle, actions admin — exposés dans un format que l'IT acheteur peut lire directement, pas via un ticket support.
6. **Où leurs user IDs mappent-ils sur les vôtres ?** Si le modèle de domaine a l'identifiant de l'IdP comme clé primaire des utilisateurs, votre réponse honnête est un trimestre de refactor, pas une réponse procurement. À régler *avant* l'appel.
7. **Qui possède l'admin portal du client ?** Si la réponse est "nous" et qu'il n'existe pas encore, soit on achète un broker qui en ship un (WorkOS, Stytch B2B, Frontegg), soit on le construit ce trimestre.

Déroulez la liste à voix haute, écrivez les manques, ramenez-les à l'engineering avec une deadline. Le deal ne se ferme pas sur une démo vendor — il se ferme sur ces sept réponses sans ambiguïté.

---

## Comment l'auth se décompose — couche par couche

Les sept couches du début du guide, en détail. Ce que chacune fait, comment elle échoue, pourquoi elle doit rester sa propre décision. Si les calls plus haut suffisent, vous pouvez vous arrêter là. Si vous voulez le *pourquoi* derrière un call précis, la sous-section correspondante l'a.

"Auth" décrit des *rôles*, pas des produits. Un seul vendor remplit souvent plusieurs rôles, et c'est exactement ce qui crée la confusion. Nommer le rôle de chaque couche, c'est ce qui garde les frontières visibles.

### Identity Provider (IdP)

Le système qui authentifie les utilisateurs — qui prouve que cette personne est bien qui elle prétend être. Il détient ou fédère les credentials, gère la vérification multi-facteurs, et émet des assertions signées en aval : une réponse SAML ou un token OIDC.

En contexte B2C ou SMB, l'IdP est généralement sous contrôle de l'opérateur. AWS Cognito ou Firebase Auth pour les utilisateurs email/password, Google ou Apple pour le social login. On fait soit tourner un service IdP managé, soit on délègue à l'un d'eux.

En contexte B2B enterprise, l'IdP appartient à l'acheteur. Leur tenant Okta, leur Microsoft Entra ID, leur instance Keycloak — c'est l'autorité. Quand un employé se connecte à un outil que l'entreprise a acheté, il s'authentifie auprès de l'IdP de l'entreprise, pas du SaaS. Le SaaS ne détient aucun credential pour ces utilisateurs. Il fait confiance aux assertions d'un IdP qu'il ne gère pas.

Cette distinction — qui gère l'IdP — est le premier axe de toute décision d'architecture auth.

### Identity broker

La couche entre l'application et l'IdP de l'acheteur. Quand on a plusieurs clients enterprise, chacun avec son propre IdP, chacun avec sa configuration SAML ou OIDC, le broker normalise cette complexité en une seule API que le backend utilise.

Cette couche a récemment trouvé un nom. Le pattern s'appelait "federation broker" dans la littérature académique sur l'identité, mais le terme identity broker est devenu un terme d'opérateur vers 2022, quand des produits dédiés ont émergé pour résoudre ce problème. Avant ça, les équipes construisaient cette couche elles-mêmes et l'appelaient "l'intégration SAML" — une description qui sous-estime largement le périmètre réel.

Le problème du broker : N IdPs clients × M protocoles (SAML 2.0, OIDC) × configuration par client × un admin portal self-service pour les équipes IT de chaque client. C'est un investissement engineering permanent, pas un ticket. Il compound avec chaque client enterprise ajouté. WorkOS, Stytch B2B, et SSOReady existent parce que l'industrie a convergé vers "cette couche vaut la peine d'être achetée".

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

Les bonnes réponses à chaque couche dépendent de qui on vend. Mais deux des sept couches ne varient pas selon le marché : **token verification est toujours JWKS local**, et **user management est toujours votre base de données**. Ce sont des réponses fixes, quel que soit la ligne de la table ci-dessous. Le reste, c'est la calibration.

<div class="wide-table">
<table>
  <thead>
    <tr>
      <th>Couche</th>
      <th>B2C</th>
      <th>B2SMB (≤50)</th>
      <th>B2B mid-market</th>
      <th>B2B enterprise</th>
      <th>Réglementé</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Identity Provider</strong></td>
      <td>IdP managé / social</td>
      <td>IdP managé + Google/MS OIDC</td>
      <td>IdP managé + IdP de l'acheteur</td>
      <td>L'IdP de l'acheteur fait autorité</td>
      <td>IdP de l'acheteur ; Keycloak self-hosted en contexte souverain</td>
    </tr>
    <tr>
      <td><strong>Identity broker</strong></td>
      <td>—</td>
      <td>—</td>
      <td>Optionnel (1–2 manuels)</td>
      <td>Requis au-delà de quelques clients</td>
      <td>Requis ; souvent self-hosted</td>
    </tr>
    <tr>
      <td><strong>Provisioning</strong></td>
      <td>—</td>
      <td>JIT suffit</td>
      <td>JIT ; SCIM pour les grands comptes</td>
      <td>SCIM requis</td>
      <td>SCIM + logs audit-grade</td>
    </tr>
    <tr>
      <td><strong>Session management</strong></td>
      <td>Basique</td>
      <td>Configurable</td>
      <td>Configurable par tenant</td>
      <td>Par tenant : timeout, forced logout, limites de sessions concurrentes</td>
      <td>Strict ; imposé par compliance</td>
    </tr>
    <tr>
      <td><strong>Authorization</strong></td>
      <td>Simple</td>
      <td>Role-based</td>
      <td>RBAC tenant-aware</td>
      <td>RBAC tenant-aware + ABAC</td>
      <td>Fine-grained ; parfois policy engine externe</td>
    </tr>
  </tbody>
</table>
</div>

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

La décision du broker est celle où le calcul change le plus nettement avec l'échelle. Un client enterprise : câbler SAML manuellement. Trois clients : trois configurations, trois rotations de certificats, trois threads de support IT. Dix clients : on a reconstruit la couche broker soi-même, sous pression, sans l'outillage. Au-delà de deux ou trois deals enterprise par trimestre, le coût par connexion d'un broker dédié est une erreur d'arrondi face au temps engineering requis pour construire et opérer la même chose en interne — plus le risque organisationnel de ce temps engineering devenant un engagement permanent.

---

## La décision avant qu'elle ne se prenne d'elle-même

Les décisions auth sont bon marché prises tôt. Les couches sont claires, les protocoles sont standardisés, l'outillage est mature. Chaque couche de cette stack a un failure mode bien compris, un fix bien compris, et un point bien compris à partir duquel le mauvais choix devient coûteux à inverser.

L'erreur n'est pas de choisir le mauvais vendor. C'est de ne pas nommer les couches du tout — de laisser chacune défauter vers "aussi le provider auth", puis de découvrir les frontières quand la pression d'évolution rend le refactoring coûteux.

La première décision — ne pas posséder les mots de passe — est correcte et cascade correctement à chaque couche. L'appliquer jusqu'au bout.

---

Le principe de séparation des préoccupations sous-jacent à chaque call dans ce guide — chaque couche possède une responsabilité, les violations sont des défauts pas des choix de design — est formalisé dans *[Engineering Practice Boundaries — Une seule barre pour engineers et AI](/fr/writing/engineering-principles-that-outlive-the-stack)*. La question de qui tient le jugement technique pour ces décisions dans une entreprise early-stage est traitée dans *[Does Your Early-Stage Startup Actually Need a CTO?](/fr/writing/does-your-startup-need-a-cto)*. Et le pattern organisationnel pour garder ces frontières explicites et applicables à mesure que le système grandit est dans *[Establishing Cross-Surface Architecture Governance](/fr/work/architecture-governance)*.
