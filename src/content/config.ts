import { defineCollection, z } from 'astro:content';

const caseFiles = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.string().optional(),
    featured: z.boolean().optional().default(false),
    order: z.number().optional().default(99),
  }),
});

const operatingPlaybooks = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.string().optional(),
    series: z.string().optional(),
    seriesNum: z.number().optional(),
    playbook: z.number().optional(),
    featured: z.boolean().optional().default(false),
  }),
});

export const collections = {
  'case-files': caseFiles,
  'operating-playbooks': operatingPlaybooks,
};
