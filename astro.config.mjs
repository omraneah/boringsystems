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
  integrations: [mdx({ remarkPlugins: [remarkMermaidFences] }), sitemap()],
  markdown: {
    remarkPlugins: [remarkMermaidFences],
  },
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
