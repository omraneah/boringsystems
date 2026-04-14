// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import vercel from '@astrojs/vercel';

export default defineConfig({
  site: 'https://boringsystems.app',
  // Static by default — only routes with `export const prerender = false` run as functions.
  adapter: vercel(),
  integrations: [mdx(), sitemap()],
});
