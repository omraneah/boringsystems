---
title: "Pourquoi les AI agents ont besoin de databases jetables"
description: "Les databases traditionnelles partent du principe que la donnée est permanente et vous la facturent comme telle. Les AI agents n'ont pas besoin de données permanentes — ils ont besoin de databases qui spin up, tournent, puis disparaissent. Snowflake et Neon l'ont vu venir ; Databricks a payé un milliard pour la preuve."
date: 2026-04-23
featured: true
order: 3
---

## L'hypothèse sous l'hypothèse

Pendant cinquante ans, la database par défaut couplait deux choses : là où les données vivent et là où le compute tourne. Vous payiez les deux que vous utilisiez l'un ou l'autre. Scaler l'un forçait à scaler l'autre. Faire grossir un workload voulait dire faire grossir une machine. Réduire un workload voulait dire continuer à payer pour ce que vous aviez arrêté d'utiliser.

C'était accepté comme une propriété du medium. Oracle a construit une boîte qui vaut des centaines de milliards là-dessus. IBM aussi. Et, plus discrètement, tous ceux qui ont vendu une database managée sur AWS ces quinze dernières années. L'hypothèse sous l'hypothèse, c'était que la donnée compte, que la donnée persiste, et que tout ce qui tient de la donnée est assez load-bearing pour qu'on paie indéfiniment.

En avril 2026, cette hypothèse est la contrainte. Les agents génèrent de la donnée à vitesse machine. L'essentiel n'a pas d'importance. L'essentiel ne persiste pas. Et la couche qui a été construite pour du load-bearing state est soudain le bottleneck des workloads dont le signal-to-noise ratio est à peu près d'un sur dix.

## Le pari Snowflake, douze ans trop tôt

Snowflake a fait le pari architectural le premier, pour l'analytics. Fondé en 2012 à San Mateo. Trois engineers. Un whitepaper. Le pari : séparer le storage du compute. Stocker la donnée dans S3. Faire tourner le compute sur des virtual warehouses éphémères qui scalent indépendamment. Quand on a besoin de plus de query concurrency, on spin up un warehouse. Quand on est idle, on l'arrête. On paie le compute seulement quand du compute se passe.

Le pari architectural n'était pas le produit. Le produit était le pari de distribution par-dessus. BigQuery avait la même architecture — Dremel comme query engine, Colossus comme file system, annoncé en 2010, deux ans avant que Snowflake n'existe. Google avait la technologie. Google avait la donnée. Ce que Google n'avait pas, c'était un moyen de vendre à une enterprise qui ne voulait pas parier sur GCP.

Snowflake vendait la même architecture, cloud-agnostic. Tournait sur AWS d'abord, Azure en 2018, GCP en 2019. Les enterprises l'ont acheté non parce qu'il était techniquement supérieur à BigQuery — c'était le même pari — mais parce qu'il ne les forçait pas à s'engager sur un cloud provider. La boîte était une stratégie de distribution déguisée en trench coat.

Redshift existait. Redshift était couplé. Le temps qu'AWS ship RA3 avec managed storage en 2019, Snowflake avait la mindshare. Le temps que Redshift Serverless arrive en juillet 2022, le marché avait bougé.

## AWS gagne l'infra. AWS perd la couche applicative.

Voilà le pattern qui vaut la peine d'être compris. AWS gagne l'infra — compute, storage, network. AWS perd la couche au-dessus. Snowflake a battu Redshift. Databricks a battu EMR et Glue. Anthropic, dans lequel Amazon a maintenant engagé environ trente-trois milliards, livre la capability de modèle frontier que les modèles natifs Bedrock d'AWS n'ont jamais rattrapés.

Le pattern n'est pas un one-off. Le pattern est le business model. Les hyperscalers monétisent en louant du compute, du storage et du network avec une marge. Construire la couche applicative demande un muscle différent : product-market fit, enterprise motion, focus de specialist. Les product orgs des hyperscalers continuent de shipper la couche applicative en retard, commodity, et avec du cloud lock-in intégré. Les clients qui ont un vrai choix prennent le specialist.

## Le parallèle des modèles AI

Le même pattern se joue un étage plus haut. Aucun des cloud providers n'a gagné la course au modèle frontier organiquement. GCP a Gemini et le fait tourner natif sur Vertex. AWS a Trainium, Anthropic sur Bedrock, et trente-trois milliards d'equity Anthropic. Microsoft a OpenAI comme investissement interne par-dessus Azure. Trois stratégies de provider différentes. Aucune n'est une victoire native. Les specialists ont capturé la couche émergente et les providers ont racheté leur place.

Claude, en 2026, est le seul modèle frontier disponible sur les trois hyperscalers. Ce n'est pas la stratégie de partenariat d'Anthropic. C'est les hyperscalers qui ont échoué, individuellement, à construire le modèle, et qui écrivent chacun de gros chèques pour rester dans la course.

## La fragmentation, c'était la dernière décennie. Le lifecycle, c'est celle-ci.

La dernière décennie a produit une explosion cambrienne de databases spécialisées. pgvector pour les embeddings. ClickHouse pour l'analytics columnar. DuckDB pour le OLAP local. Redis pour le cache. Chacune était une nouvelle *forme* de donnée. Chacune résolvait un workload que du Postgres ou MySQL traditionnel ne pouvait pas gérer proprement. Chacune s'asseyait à côté de votre database OLTP, sans la remplacer.

Neon ajoute une dimension différente. Pas une nouvelle forme de donnée. Un nouveau lifecycle. Postgres reste Postgres. Le schema reste un schema. Ce qui a changé, c'est qu'une database Neon peut spin up en millisecondes, brancher depuis la production avec copy-on-write en secondes, faire tourner un workload, et disparaître. Éphémère par défaut. Persistante par choix. La forme de donnée est inchangée ; l'hypothèse de durée est inversée.

## Pourquoi Databricks a payé un milliard

En mai 2025, Databricks a accepté d'acquérir Neon pour environ un milliard. Ali Ghodsi, le CEO de Databricks, a dit le non-dit à l'annonce : quatre-vingts pour cent des databases provisionnées sur Neon ont été créées par des agents AI, pas par des humains. Ce chiffre, c'est toute la thèse en un stat.

Les agents génèrent de l'output high-volume, low-signal, à vitesse machine. Un agent à qui on donne une tâche va typiquement essayer plusieurs approches, produire plusieurs variantes, et la plupart ne survivront pas à l'évaluation. Le problème des databases traditionnelles dans cette boucle, c'est qu'elles supposent la permanence. Les schema migrations prennent des minutes. Les connection pools doivent chauffer. Le provisioning prend entre trente secondes et plusieurs minutes selon le provider. Et le cost floor par instance n'est pas zéro — une petite instance RDS Postgres coûte à peu près quarante à soixante dollars par mois idle, et ça c'est avant de multiplier par le nombre d'instances de test parallèles dont un agent peut avoir besoin.

Neon inverse l'économie. Une branche ne coûte rien tant qu'aucune donnée n'y est écrite. Le compute scale à zéro en idle. Le spin-up est en centaines de millisecondes. Un agent fait tourner dix experiments sur dix branches en parallèle ; neuf disparaissent, une est promue. La facture mensuelle n'est pas quarante dollars fois dix. La facture mensuelle, c'est la petite quantité de storage que la survivante a accumulée.

Ce n'est pas un play pour remplacer les databases transactionnelles dans les enterprises. Débarquer dans une banque en proposant de swap Oracle pour Neon, c'est délirant. La couche existante est load-bearing, a des exigences de compliance, porte des décennies de data lineage et d'audit trails, tourne sur des contrats avec des termes de support définis. Oracle ne va nulle part parce qu'Oracle n'a jamais été en compétition pour le workload que Neon sert. Le play, c'est la couche qui n'existait pas avant les agents : l'état éphémère à vitesse machine, pricé pour matcher le signal-to-noise ratio de l'output agentique.

## Comment les maths changent, concrètement

Un engineer veut faire tourner une experiment. L'experiment touche la database — ajouts de schema, population de données, query work. Sur un modèle provisionné, l'option la moins chère honnêtement, c'est une instance dédiée ; disons cinquante dollars par mois. Pour un agent qui fait tourner cette experiment dix fois en parallèle, cinquante fois dix, c'est cinq cents dollars par mois, et l'engineer paie ce coût que neuf des dix experiments aient produit quelque chose d'utile ou non.

Sur un modèle disaggregated, scale-to-zero, les mêmes dix experiments parallèles coûtent près de zéro pendant qu'elles tournent, et zéro quand elles s'arrêtent. Le storage footprint, c'est la petite quantité de donnée que la branche survivante a gardée. La facture totale, c'est de quelques centimes à quelques dollars par mois selon le storage retenu.

Le swing de coût dix-pour-un est tout l'argument économique. C'est aussi la raison pour laquelle l'ancien modèle n'a jamais été la mauvaise réponse pour la donnée de production load-bearing : à l'échelle production, la persistance se paie elle-même. C'est seulement la mauvaise réponse pour les workloads construits autour de l'exploration agentique, qui n'existaient pas comme catégorie à l'échelle production avant 2024.

## Une petite note sur où je m'en sers

Ce site tourne sur ce pattern. La database de production de boringsystems, c'est Neon. Le path CI spin up des branches par feature pour les boucles de review agent-assisted ; les branches qui ne survivent pas au review sont supprimées. Celles qui survivent sont mergées back et promues. Faire tourner des experiments se mesure en centimes par mois, pas en dollars par instance par heure. Si l'architecture était encore couplée — storage lié à l'instance compute, les deux provisionnés ensemble, les deux payés ensemble — le workflow aurait un coût qui me forcerait à être prudent sur l'expérimentation, ce qui est exactement le mauvais endroit pour mettre un cost ceiling quand les agents font la plupart de l'exploration.

La stack complète — Claude Code, Vercel, Neon, Resend — et le raisonnement derrière chaque pièce sont détaillés dans *[The Operator's AI Stack: April 2026](/fr/building/operator-ai-stack-april-2026)*. Neon est un composant de cette stack ; l'argument plus long sur pourquoi le pari architectural de Neon vaut la peine d'être regardé, *c'est* ce piece.

## Le fil rouge

La séparation des concerns compose. Snowflake a séparé storage et compute pour l'analytics en 2012. Neon les a séparés pour les transactions en 2021. Ce qui viendra ensuite séparera quelque chose d'autre qui était couplé depuis des décennies — et les workloads qui étaient économiquement inviables sous l'ancienne hypothèse deviendront triviaux sous la nouvelle.

Les hyperscalers continueront de gagner l'infra et de perdre la couche applicative. Les specialists continueront de capturer les workloads émergents. Les enterprises continueront de faire tourner Oracle, Postgres et SQL Server pour la donnée qui compte vraiment, et elles devraient. Ce qu'elles ne feront pas, c'est acheter une nouvelle instance provisionnée à mille dollars par mois chaque fois qu'un engineer veut faire tourner une experiment — pas quand l'agent qui fait l'experiment a besoin de cinquante databases jetables et d'un dixième de centime pour les faire tourner.

Pour qui construit maintenant : la décision de provisioning que vous avez prise l'année dernière, c'est celle qui vaut la peine d'être revue ce trimestre. Si votre stack suppose que vos workloads sont permanents, vous payez pour une permanence dont vous n'avez pas besoin, et vous payez le plus pour les experiments qui comptent le plus. L'architecture a changé. Le prix a changé. Il reste seulement à savoir si la décision que vous prenez ce mois-ci reflète ce qui est vrai maintenant.
