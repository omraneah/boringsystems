import { defineCollection, z } from 'astro:content';

const persona = z.enum(['technical', 'operator']).optional();

const caseFiles = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
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
