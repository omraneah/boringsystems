// Persona IDs — single source of truth.
//
// Canonical persona registry for the site. `PERSONAS` is the tuple that
// drives Zod's content-schema enum; `Persona` is the literal-union type
// derived from it; `PERSONA` is the named-constant accessor for code that
// filters or references a persona by name.
//
// Usage:
//   - Content schema  → `z.enum(PERSONAS)` in `src/content/config.ts`.
//   - Page filters    → `data.persona === PERSONA.BUILDER` — never a bare string.
//   - Type annotations → `Persona` (import from here).
//
// Adding a persona: append to `PERSONAS`, add a matching `PERSONA.<NAME>`
// entry, and TypeScript will force every lane filter and skill contract
// to be revisited. Doctrine (who each persona is, which lane they live in)
// lives in `docs/target-audiences.md`.

export const PERSONAS = ['technical', 'builder'] as const;

export type Persona = (typeof PERSONAS)[number];

export const PERSONA = {
  TECHNICAL: 'technical',
  BUILDER: 'builder',
} as const satisfies Record<string, Persona>;
