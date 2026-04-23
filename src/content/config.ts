import { defineCollection, z } from 'astro:content';

// Four content lanes — see README.md and docs/target-audiences.md for the
// editorial taxonomy. Folder name = URL path = collection name (minus the
// locale suffix). Lane placement is the content-type decision; voice target
// per piece is a writer-side concern that does not show up here.
//
//   writing   — thinking pieces, decision guides, frameworks, tactical advice.
//                Most articles land here by default.
//   work      — past case studies of real engagements. Proof pieces.
//   building  — current AI-native builds shown live. Live work + commentary.
//   archive   — long-living playbooks and principles. Doctrine layer.
//
// Flag semantics — see docs/adr-002-home-selection.md for the full contract.
//   featured  — include in grid listings (home "Selected Articles" and lane indexes).
//   highlight — include in the home "Highlights" stack (capped at three, sorted by order).
//   order     — sort key across every surface. Lower = earlier.
//
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
  'writing-en': article,
  'writing-fr': article,
  'work-en': article,
  'work-fr': article,
  'building-en': article,
  'building-fr': article,
  'archive-en': archive,
  'archive-fr': archive,
};
