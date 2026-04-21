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
  redirects: {
    '/': '/en/',
    '/about': '/en/about',
    '/engineering': '/en/engineering',
    '/entrepreneurs': '/en/entrepreneurs',
    '/essays': '/en/essays',
    '/case-files': '/en/case-files',
    '/case-files/[slug]': '/en/case-files/[slug]',
    '/operating-playbooks': '/en/operating-playbooks',
    '/operating-playbooks/[slug]': '/en/operating-playbooks/[slug]',
  },
});
