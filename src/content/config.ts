import { defineCollection, z } from 'astro:content';

// Flag semantics — see docs/adr-002-home-selection.md for the full contract.
//
//   featured  — include in grid listings (home "Selected Articles" and lane
//               index pages).
//   highlight — include in the home "Highlights" stack (capped at three,
//               sorted by `order`).
//   order     — sort key across every surface. Lower = earlier.
//
// Lane is implicit in the collection: system-design, builders, technology, archive.
// Folder path = URL path = collection name (minus locale suffix). No persona
// field: articles live under the lane that matches their voice.
//
// Adding a lane: create new collection dirs and a matching schema block here.
// Never add ad-hoc frontmatter flags (homePinned, showOnHome, etc.) — widen
// selection logic in `src/pages/{en,fr}/index.astro` instead.

const article = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    // First-merge git date, ISO (YYYY-MM-DD). Mandatory — renders in the
    // meta strip on cards and under every article subtitle. Seed via:
    //   git log --follow --diff-filter=A --format=%aI <path> | tail -1
    date: z.coerce.date(),
    featured: z.boolean().optional().default(false),
    highlight: z.boolean().optional().default(false),
    order: z.number().optional().default(99),
  }),
});

// Archive: long-living playbooks. No `date` — these are principles, not
// time-stamped pieces. Series metadata drives grouping on the Archive index.
const archive = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    series: z.string().optional(),
    seriesNum: z.number().optional(),
    playbook: z.number().optional(),
    featured: z.boolean().optional().default(false),
    highlight: z.boolean().optional().default(false),
    order: z.number().optional().default(99),
  }),
});

export const collections = {
  'system-design-en': article,
  'system-design-fr': article,
  'builders-en': article,
  'builders-fr': article,
  'technology-en': article,
  'technology-fr': article,
  'archive-en': archive,
  'archive-fr': archive,
};
