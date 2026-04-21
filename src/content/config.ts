import { defineCollection, z } from 'astro:content';

// Persona drives lane filtering on /engineering and /entrepreneurs.
// `technical` → engineering lane; `operator` → entrepreneurs lane.
const persona = z.enum(['technical', 'operator']).optional();

// Flag semantics — see docs/adr-002-home-selection.md for the full contract.
//
//   featured  — include in grid listings (home "Selected Articles" when
//               persona is technical, lane index pages).
//   highlight — include in the home "Highlights" stack (capped at three,
//               sorted by `order`).
//   order     — sort key across every surface. Lower = earlier.
//
// Never add ad-hoc flags (homePinned, showOnHome, etc.). Widen selection
// logic in `src/pages/{en,fr}/index.astro` instead.

const caseFiles = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    // First-merge git date, ISO (YYYY-MM-DD). Mandatory — renders in the
    // meta strip on cards and under every article subtitle. Seeded via:
    //   git log --follow --diff-filter=A --format=%aI <path> | tail -1
    date: z.coerce.date(),
    featured: z.boolean().optional().default(false),
    highlight: z.boolean().optional().default(false),
    order: z.number().optional().default(99),
    persona,
  }),
});

const operatingPlaybooks = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    series: z.string().optional(),
    seriesNum: z.number().optional(),
    playbook: z.number().optional(),
    // `featured` and `highlight` exist for symmetry with case files, but
    // the home page currently pins exactly one playbook slug by explicit
    // getEntry() rather than via these flags. See ADR-002.
    featured: z.boolean().optional().default(false),
    highlight: z.boolean().optional().default(false),
    persona,
  }),
});

export const collections = {
  'case-files-en': caseFiles,
  'operating-playbooks-en': operatingPlaybooks,
  'case-files-fr': caseFiles,
  'operating-playbooks-fr': operatingPlaybooks,
};
