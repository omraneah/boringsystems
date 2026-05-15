---
title: "Domain-Driven Design: The Fancy Name for Principle Thinking"
description: "Database-driven design was rational when schema migrations were terrifying production operations. Carrying that thinking into 2026 isn't. DDD is what happened when the industry corrected the mistake and gave the correction a name."
date: 2026-05-15
---

Of course you design around your domain. Why would you design around anything else? The fact that domain-driven design became a named discipline — with a book and a conference circuit — tells you something broke badly before someone decided to name the correction.

The break wasn't stupidity. When databases were the hardest constraint, schema migrations were production events that could take tables down for minutes. Starting with the schema was rational engineering under real pressure.

## What went wrong

Teams designed tables first. Modules organized around tables. A "UserService" because there's a `users` table. An "OrderService" because there's an `orders` table. Business logic scattered across whatever service happened to own the relevant table.

The result: a cancellation flow touching five tables meant five different services, no single owner, no clear boundary. Cancel a booking, refund a wallet, notify a driver, update a ledger, close a feedback window — five teams in the room. The database was the architecture. The business was a secondary tenant in its own system.

This was defensible under real constraints: slow databases, expensive migrations, shared schemas across multiple applications. The mistake is carrying that thinking into 2026, when migrations are automated, databases provision in seconds, and storage is not the bottleneck.

The constraint is gone. The habit stayed.

## What it actually means in practice

Not the academic definition. The one that changes how you build.

At a ride-hailing platform I ran, the real units were booking, rider, wallet, driver, shift. Those became the primary units of the architecture. Not tables. Not DTOs. The business concept. The schema came after.

This sounds obvious. It wasn't. The previous design had wallet logic scattered across the booking flow, the driver settlement process, and a shared utility module that had accumulated both. No one owned it. Refunds touched three services. Driver payouts touched four. When a new constraint appeared — wallet state needed to be consistent across a cancellation — there was no single place to enforce it.

The correction is to make ownership explicit. Wallet belongs to the user domain because a wallet cannot exist without a rider. That's a business truth, not a design preference. Once you name it, the structure follows: wallet lives inside the user domain, every state transition goes through a single defined path, and the cancellation handler doesn't negotiate with three other services to find out if a refund is valid.

The harder discipline is the language. Same term in the product spec, in the code, in the database, in conversations with the PM. Not "customer" in the UI, "user" in the code, "account" in the schema, "client" in the API contract. One canonical name, enforced.

When the language drifts, the model drifts. When the model drifts, bugs appear at the seams — the place where "user" in one module tries to talk to "account" in another and someone writes a mapping layer that slowly becomes authoritative. The mapping layer is the symptom. Drifting names are the disease.

Explicit boundaries follow from explicit ownership. "User" in the booking context — the entity requesting a ride — is different from "user" in the payment context — the entity with a payment method and a billing history. Drawing the boundary explicitly prevents booking logic from depending on payment model specifics and stops your cancellation handler from importing your Stripe integration.

## Where it shows up in architectural decisions

**Module communication follows domain boundaries.** Cross-domain communication goes through events — async pub/sub where the publisher knows nothing about the subscriber. Within a domain, direct injection is fine. Blur that line and you get circular dependencies, deployment coupling, and the inability to change one domain without touching three others.

**The disguised function call.** We shipped this mistake once. The booking service emitted a "BookingConfirmed" event and immediately awaited the return value — the result of a wallet check happening in a listener. In TypeScript with an EventEmitter, if the listener isn't registered or throws, the caller receives `undefined` and no exception surfaces. The booking confirmed. The wallet check never ran. We found it when a user reported their ride had confirmed but their wallet showed no deduction.

Events exist to decouple. The moment you await the return value, you've destroyed the decoupling and added the worst failure properties of both approaches: the silent failure of async without the type safety of a direct call. Use a function call if you need the answer. It fails loudly.

**Transactional consistency without coupling.** When booking confirmation and wallet deduction must succeed or fail together, the answer isn't events. It's a shared database transaction. The booking service opens a transaction, writes to the booking table, writes to the wallet table via the ORM's transaction manager, commits. Either both happen or neither happens. The wallet service is never involved. Atomicity at the database level, not the application level.

The database transaction is the right tool for this. That is not a violation of domain boundaries — it is infrastructure doing the consistency work so the application does not have to.

## Three patterns worth knowing

**Event-driven / pub-sub.** Cross-domain communication where publisher and subscriber should evolve independently. The domain emits what happened; whoever needs to react, reacts. The publisher knows nothing about them.

**CQRS.** Separate the write model from the read model. Writes go to the transactional database optimized for consistency; reads go to a model optimized for querying. If you're already running an analytics database separate from your operational one, you're doing this without the name.

**Outbox pattern.** Write the event to an outbox table in the same transaction as the business operation. A separate process publishes from the outbox. Business atomicity and reliable event delivery, without coupling them. Without this, publishing an event after a transaction is a race condition.

## The closing

DDD is not a framework you install. Not a pattern catalog you memorize.

It's the discipline of starting with what is true about the business, letting that truth drive every structural decision, and refusing to let technical convenience reverse the order.

The engineers who get it right rarely know the pattern names. They start with: what is this thing, who owns it, what can happen to it, what must be true when something does. They arrive at the right structure through reasoning.

The doctrine exists for teams where not everyone has developed that reasoning ability. It is a map for people who haven't been to the territory. The name is just for people who needed someone to write it down.

---

The seven engineering practice dimensions that underpin this kind of structural thinking — separation of concerns, root-cause fixes, architectural boundary discipline — are in *[Engineering Practice Boundaries — One Bar for Engineers and AI](/en/writing/engineering-principles-that-outlive-the-stack)*. What these principles look like applied at a governance layer across multiple product surfaces, including naming drift and boundary enforcement, is in *[Establishing Cross-Surface Architecture Governance](/en/work/architecture-governance)*.
