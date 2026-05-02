---
title: "Why AI Agents Need Disposable Databases"
description: "Traditional databases assume data is permanent and charge you for it. AI agents don't need permanent data — they need databases that spin up, run, and disappear. Snowflake and Neon saw this coming; Databricks paid a billion dollars for the proof."
date: 2026-04-23
featured: true
order: 3
---

## The assumption underneath the assumption

For fifty years the default database coupled two things: where the data lives and where the computation runs. You paid for both whether you used either. Scaling one forced scaling the other. Growing a workload meant growing a machine. Shrinking a workload meant paying for what you stopped using.

This was accepted as a property of the medium. Oracle built a company worth hundreds of billions on it. So did IBM. So, more quietly, did everyone who sold a managed database on AWS for the last fifteen years. The assumption underneath the assumption was that data matters, data persists, and anything that holds data is load-bearing enough to pay for indefinitely.

In April 2026 that assumption is the constraint. Agents generate data at machine speed. Most of it does not matter. Most of it does not persist. And the layer that was built for load-bearing state is suddenly the bottleneck for workloads that have a signal-to-noise ratio of roughly one-in-ten.

## The Snowflake bet, twelve years early

Snowflake made the architectural bet first, for analytics. Founded in 2012 in San Mateo. Three engineers. One whitepaper. The bet: separate the storage from the compute. Store the data in S3. Run the compute on ephemeral virtual warehouses that scale independently. When you need more query concurrency, spin up a warehouse. When you're idle, shut it down. Pay for compute only when compute is happening.

The architectural bet was not the product. The product was the distribution bet on top of it. BigQuery had the same architecture — Dremel as the query engine, Colossus as the file system, announced in 2010, two years before Snowflake existed. Google had the technology. Google had the data. What Google did not have was a way to sell to an enterprise that did not want to bet on GCP.

Snowflake sold the same architecture, cloud-agnostic. Ran on AWS first, then Azure in 2018, then GCP in 2019. Enterprises bought it not because it was technically superior to BigQuery — they were the same bet — but because it did not force them to commit to a cloud provider. The company was a distribution strategy in a trench coat.

Redshift existed. Redshift was coupled. By the time AWS shipped RA3 with managed storage in 2019, Snowflake had the mindshare. By the time Redshift Serverless arrived in July 2022, the market had moved.

## AWS wins infrastructure. AWS loses the application layer.

This is the pattern worth understanding. AWS wins infrastructure — compute, storage, network. AWS loses the layer above it. Snowflake beat Redshift. Databricks beat EMR and Glue. Anthropic, which Amazon has now committed around thirty-three billion dollars to, delivers the frontier model capability that AWS's native Bedrock models never caught.

The pattern is not a one-off. The pattern is the business model. Hyperscalers monetize by renting compute, storage, and network at a premium. Building the application layer requires a different muscle: product-market fit, enterprise motion, specialist focus. Hyperscaler product orgs keep shipping the application layer late, commodity, and with cloud lock-in baked in. Customers with a real choice pick the specialist.

## The AI model parallel

The same pattern is unfolding one layer up. None of the cloud providers won the frontier model race organically. GCP has Gemini and runs it native on Vertex. AWS has Trainium, Anthropic on Bedrock, and thirty-three billion dollars of Anthropic equity. Microsoft has OpenAI as an internal investment on top of Azure. Three different provider strategies. None of them a native win. Specialists captured the emergent layer and the providers bought in.

Claude, as of 2026, is the only frontier model available on all three hyperscalers. That's not Anthropic's partnership strategy. That's the hyperscalers failing, individually, to build the model and each separately writing large checks to stay in the game.

## Fragmentation was the last decade. Lifecycle is this one.

The last decade produced a Cambrian explosion of specialized databases. pgvector for embeddings. ClickHouse for columnar analytics. DuckDB for local OLAP. Redis for cache. Each one was a new data *shape*. Each one solved a workload traditional Postgres or MySQL could not handle gracefully. Each one sat next to your OLTP database, not replacing it.

Neon adds a different dimension. Not a new data shape. A new lifecycle. Postgres is still Postgres. The schema is still a schema. What changed is that a Neon database can spin up in milliseconds, branch from production with copy-on-write in seconds, run a workload, and disappear. Ephemeral by default. Persistent by choice. The data shape is unchanged; the lifetime assumption inverted.

## Why Databricks paid a billion dollars

In May 2025 Databricks agreed to acquire Neon for about one billion dollars. Ali Ghodsi, Databricks' CEO, said the quiet part at the announcement: eighty percent of databases provisioned on Neon were created by AI agents, not humans. That number is the whole thesis in one stat.

Agents generate high-volume, low-signal output at machine speed. An agent given a task will typically try several approaches, produce several variants, and most of them do not survive contact with evaluation. The problem with traditional databases in that loop is that they assume permanence. Schema migrations take minutes. Connection pools need warming. Provisioning takes between thirty seconds and several minutes depending on provider. And the cost floor per instance is non-zero — a small RDS Postgres instance costs roughly forty to sixty dollars per month idle, and that's before you multiply by the number of parallel test instances an agent might need.

Neon inverts the economics. A branch costs nothing while it has no data written to it. Compute scales to zero on idle. Spin-up is in the hundreds of milliseconds. An agent runs ten experiments against ten branches in parallel; nine disappear, one promotes. The monthly bill is not forty dollars times ten. The monthly bill is whatever tiny amount of storage the survivor accumulated.

This is not a play to replace transactional databases in enterprises. Walking into a bank and proposing to swap Oracle for Neon is delusional. The existing layer is load-bearing, has compliance requirements, carries decades of data lineage and audit trails, runs on contracts with defined support terms. Oracle is not going anywhere because Oracle was never competing for the workload Neon serves. The play is the layer that did not exist before agents: ephemeral state at machine speed, priced to match the signal-to-noise ratio of agentic output.

## How the math changes, concretely

Assume an engineer wants to run an experiment. The experiment touches the database — schema additions, data population, query work. On a provisioned model, the cheapest honest option is a dedicated instance; call it fifty dollars a month. For an agent running that experiment ten times in parallel, fifty times ten is five hundred dollars a month, and the engineer is paying that cost regardless of whether nine of the ten experiments produced anything useful.

On a disaggregated, scale-to-zero model, the same ten parallel experiments cost near-zero while they run and zero when they stop. The storage footprint is whatever small amount of data the surviving branch kept. The total bill is a few cents to a few dollars a month depending on the storage retained.

The ten-to-one cost swing is the entire economic argument. It's also the reason the old model was never the wrong answer for load-bearing production data: at production scale, persistence pays for itself. It's only the wrong answer for the workloads built around agentic exploration, which did not exist as a category at production scale before 2024.

## A small note on where I'm using this

This site runs on that pattern. boringsystems' production database is Neon. The CI path spawns branches per feature for agent-assisted review loops; the branches that don't survive review get deleted. The ones that do get merged back and promoted. Running experiments is measured in cents per month, not dollars per instance per hour. If the architecture was still coupled, the same workflow would cost enough to force me to be careful about experimentation — which is exactly the wrong lever to put a cost ceiling on when agents are doing most of the exploring.

The full stack — Claude Code, Vercel, Neon, Resend — and the reasoning behind each piece is laid out in *[The Operator's AI Stack: April 2026](/en/building/operator-ai-stack-april-2026)*. Neon is one component of that stack; the longer argument for why its architectural bet is worth paying attention to *is* this piece.

## The through-line

Separation of concerns compounds. Snowflake separated storage from compute for analytics in 2012. Neon separated them for transactions in 2021. Whatever comes next will separate something else that was coupled for decades — and the workloads that were economically unviable under the old assumption become trivial under the new one.

The hyperscalers will keep winning infrastructure and losing the application layer. The specialists will keep capturing the emergent workloads. Enterprises will keep running Oracle and Postgres and SQL Server for the data that actually matters, and they should. What they won't do is buy a new thousand-dollar-a-month provisioned instance every time an engineer wants to run an experiment — not when the agent doing the experiment needs fifty throwaway databases and a tenth of one cent to run them.

For anyone building right now: the provisioning decision you made last year is the one worth revisiting this quarter. If your stack assumes your workloads are permanent, you are paying for permanence you do not need, and you are paying the most for the experiments that matter most. The architecture changed. The price changed. The only thing left is whether the decision you make this month reflects what is now true.

---

Separation of concerns — the principle that storage and compute should be separately owned, that what changes fast should not be coupled to what changes slow — is one of the seven invariants in *[Engineering Practice Boundaries — One Bar for Engineers and AI](/en/writing/engineering-principles-that-outlive-the-stack)*. Neon's architectural bet is that principle applied to database provisioning.

The ephemeral database sits alongside ephemeral context: agents don't persist the data they explore, and they shouldn't persist the scratch reasoning they generate either. The architecture for managing what *does* persist — the context that compounds across sessions — is the subject of *[Context is the Edge](/en/writing/context-is-the-edge)*. The complete stack that ties all of this together is in *[The Agent Harness That Runs 80% of My Work](/en/building/the-harness-i-actually-run)*.
