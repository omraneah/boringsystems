// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import vercel from '@astrojs/vercel';
import { visit } from 'unist-util-visit';

// Mermaid: small remark plugin that converts ```mermaid``` fences into raw
// <pre class="mermaid"> HTML nodes BEFORE Shiki runs. Client-side mermaid.js
// (loaded in Article.astro) renders them at view time. Avoids rehype-mermaid's
// playwright dependency chain.
function remarkMermaidFences() {
  return (tree) => {
    visit(tree, 'code', (node, index, parent) => {
      if (node.lang !== 'mermaid') return;
      if (!parent || typeof index !== 'number') return;
      parent.children.splice(index, 1, {
        type: 'html',
        value: `<pre class="mermaid">${node.value}</pre>`,
      });
    });
  };
}

export default defineConfig({
  site: 'https://boringsystems.app',
  // Static by default — only routes with `export const prerender = false` run as functions.
  adapter: vercel(),
  integrations: [mdx({ remarkPlugins: [remarkMermaidFences] }), sitemap({
    // Include hreflang alternates in sitemap for EN/FR pairs.
    i18n: {
      defaultLocale: 'en',
      locales: {
        en: 'en-US',
        fr: 'fr-FR',
      },
    },
  })],
  markdown: {
    remarkPlugins: [remarkMermaidFences],
  },
  // Native Astro i18n. With `prefixDefaultLocale: true`, every URL lives
  // under /en/ or /fr/ — no implicit default locale. `redirectToDefaultLocale`
  // auto-redirects root `/` to `/en/`. Helpers like `getRelativeLocaleUrl()`
  // become available via `astro:i18n` — prefer them over hardcoded prefixes.
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'fr'],
    routing: {
      prefixDefaultLocale: true,
      // redirectToDefaultLocale is handled by the redirects map below, which
      // emits a proper 301 on Vercel (native i18n's version demands a root
      // index.astro and emits a meta-refresh on static builds).
    },
  },
  // Root redirect + legacy URLs that predate the strict /{locale}/ structure.
  // Vercel adapter emits these as 301s (vs. the meta-refresh fallback a raw
  // Astro.redirect in src/pages/index.astro would produce on static build).
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
