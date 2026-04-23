#!/usr/bin/env tsx
// Structural-integrity gate for boringsystems.
//
// Replaces the class of tests a SaaS codebase would write for the same
// invariants: EN/FR content mirror, frontmatter schema, SLUG_ALIASES
// integrity, LEAD_MAGNETS completeness. Called by the pre-commit hook
// (see package.json `simple-git-hooks` + `verify` script) and available
// as `npm run verify`.
//
// Exit 0 = all invariants hold. Exit 1 = one or more failed.
// Output is human-readable; every failure names the offending path and
// the specific invariant violated.

import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

import { LEAD_MAGNETS, type LeadMagnetAsset } from '../src/lib/lead-magnets.ts';
import { LOCALES, type Lang } from '../src/lib/i18n.ts';

const ROOT = fileURLToPath(new URL('..', import.meta.url));
const CONTENT = join(ROOT, 'src/content');
const PAGES = join(ROOT, 'src/pages');

type Failure = { where: string; why: string };
const failures: Failure[] = [];

function fail(where: string, why: string): void {
  failures.push({ where, why });
}

// --- helpers -----------------------------------------------------------

function listFiles(dir: string): string[] {
  try {
    return readdirSync(dir).filter((name) => {
      const full = join(dir, name);
      if (!statSync(full).isFile()) return false;
      // Only content files — ignore `.gitkeep`, `.DS_Store`, etc.
      return /\.(md|mdx)$/i.test(name);
    });
  } catch {
    return [];
  }
}

function stripExt(name: string): string {
  return name.replace(/\.(md|mdx|astro)$/i, '');
}

// Minimal YAML frontmatter parser. Supports `key: value` and `key: "value"`.
// Rejects anything multi-line or nested. That's by design — our schema is flat.
function parseFrontmatter(filePath: string): Record<string, string> {
  const raw = readFileSync(filePath, 'utf8');
  const match = raw.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) return {};
  const body = match[1];
  const out: Record<string, string> = {};
  for (const line of body.split(/\r?\n/)) {
    const m = line.match(/^([a-zA-Z_][a-zA-Z0-9_]*)\s*:\s*(.*?)\s*$/);
    if (!m) continue;
    const [, key, rawValue] = m;
    let value = rawValue;
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }
    out[key] = value;
  }
  return out;
}

// --- invariants --------------------------------------------------------

function verifyContentMirror(collection: string): void {
  const enDir = join(CONTENT, `${collection}-en`);
  const frDir = join(CONTENT, `${collection}-fr`);
  const en = new Set(listFiles(enDir).map(stripExt));
  const fr = new Set(listFiles(frDir).map(stripExt));

  for (const slug of en) {
    if (!fr.has(slug)) {
      fail(
        `${collection}/${slug}`,
        `exists in EN but missing in FR — hreflang invariant requires mirror content`,
      );
    }
  }
  for (const slug of fr) {
    if (!en.has(slug)) {
      fail(
        `${collection}/${slug}`,
        `exists in FR but missing in EN — hreflang invariant requires mirror content`,
      );
    }
  }
}

function verifyFrontmatter(collection: string, requireDate: boolean): void {
  for (const lang of LOCALES) {
    const dir = join(CONTENT, `${collection}-${lang}`);
    for (const file of listFiles(dir)) {
      const full = join(dir, file);
      const rel = relative(ROOT, full);
      const fm = parseFrontmatter(full);

      if (!fm.title || fm.title.trim().length === 0) {
        fail(rel, 'missing or empty frontmatter `title`');
      }
      if (!fm.description || fm.description.trim().length === 0) {
        fail(rel, 'missing or empty frontmatter `description`');
      }
      if (requireDate) {
        if (!fm.date) {
          fail(rel, 'missing frontmatter `date` (mandatory on case files)');
        } else if (Number.isNaN(Date.parse(fm.date))) {
          fail(rel, `frontmatter \`date\` does not parse: "${fm.date}"`);
        }
      }
    }
  }
}

function verifySlugAliases(): void {
  // Re-parse i18n.ts rather than importing — SLUG_ALIASES is not exported.
  // Purpose: when the table grows, structural check confirms both sides
  // point at real content directories.
  const i18nPath = join(ROOT, 'src/lib/i18n.ts');
  const src = readFileSync(i18nPath, 'utf8');
  const block = src.match(/SLUG_ALIASES[^=]*=\s*{([^}]*)}/);
  if (!block) {
    fail('src/lib/i18n.ts', 'could not locate SLUG_ALIASES declaration');
    return;
  }
  const pairRe = /['"]([a-z]{2}):([a-z-]+)['"]\s*:\s*['"]([a-z]{2}):([a-z-]+)['"]/g;
  let m: RegExpExecArray | null;
  while ((m = pairRe.exec(block[1])) !== null) {
    const [, sourceLang, sourceSlug, targetLang, targetSlug] = m;
    // For a top-level lane alias like `en:essays → fr:essais`, assert a
    // route exists under pages/<lang>/<slug>{,.astro}.
    const source = join(PAGES, sourceLang, sourceSlug);
    const target = join(PAGES, targetLang, targetSlug);
    for (const [label, path] of [
      [`${sourceLang}:${sourceSlug}`, source],
      [`${targetLang}:${targetSlug}`, target],
    ] as const) {
      try {
        statSync(path);
      } catch {
        try {
          statSync(`${path}.astro`);
        } catch {
          fail(
            'src/lib/i18n.ts SLUG_ALIASES',
            `alias "${label}" does not resolve to a route at pages/${relative(PAGES, path)}`,
          );
        }
      }
    }
  }
}

function verifyLeadMagnets(): void {
  for (const [key, asset] of Object.entries(LEAD_MAGNETS)) {
    const label = `LEAD_MAGNETS["${key}"]`;
    if (asset.slug !== key) {
      fail(label, `slug "${asset.slug}" does not match registry key "${key}"`);
    }
    const required: Array<[string, LeadMagnetAsset[keyof LeadMagnetAsset]]> = [
      ['title', asset.title],
      ['description', asset.description],
      ['buttonLabel', asset.buttonLabel],
      ['prompt', asset.prompt],
    ];
    for (const [fieldName, field] of required) {
      for (const lang of LOCALES) {
        const value = (field as Record<Lang, string>)[lang];
        if (!value || value.trim().length === 0) {
          fail(label, `missing or empty \`${fieldName}.${lang}\``);
        }
      }
    }
    for (const lang of LOCALES) {
      const conf = asset.confirmation[lang];
      if (!conf) {
        fail(label, `missing confirmation.${lang}`);
        continue;
      }
      if (!conf.subject || conf.subject.trim().length === 0) {
        fail(label, `missing confirmation.${lang}.subject`);
      }
      if (!conf.body || conf.body.trim().length === 0) {
        fail(label, `missing confirmation.${lang}.body`);
      }
    }
  }
}

function verifyPageMirror(): void {
  // Every page file under pages/en should have a counterpart under pages/fr,
  // respecting SLUG_ALIASES for any top-level lane renames. Empty after
  // the 2026-04-22 restructure — all lanes use identical slugs now.
  const aliasesFromEnToFr: Record<string, string> = {};
  const aliasesFromFrToEn: Record<string, string> = {};

  function relToFirstSeg(rel: string): { first: string; tail: string } {
    const segs = rel.split('/');
    return { first: segs[0], tail: segs.slice(1).join('/') };
  }

  function walk(base: string, prefix: string): string[] {
    const out: string[] = [];
    let entries: string[];
    try {
      entries = readdirSync(base);
    } catch {
      return out;
    }
    for (const name of entries) {
      const full = join(base, name);
      const rel = prefix ? `${prefix}/${name}` : name;
      if (statSync(full).isDirectory()) {
        out.push(...walk(full, rel));
      } else if (/\.astro$/.test(name)) {
        out.push(rel);
      }
    }
    return out;
  }

  const enPages = walk(join(PAGES, 'en'), '');
  const frPages = walk(join(PAGES, 'fr'), '');
  const frSet = new Set(frPages);
  const enSet = new Set(enPages);

  for (const rel of enPages) {
    const { first, tail } = relToFirstSeg(rel);
    const frFirst = aliasesFromEnToFr[first] ?? first;
    const expected = tail ? `${frFirst}/${tail}` : frFirst;
    if (!frSet.has(expected)) {
      fail(`src/pages/en/${rel}`, `has no FR counterpart at src/pages/fr/${expected}`);
    }
  }
  for (const rel of frPages) {
    const { first, tail } = relToFirstSeg(rel);
    const enFirst = aliasesFromFrToEn[first] ?? first;
    const expected = tail ? `${enFirst}/${tail}` : enFirst;
    if (!enSet.has(expected)) {
      fail(`src/pages/fr/${rel}`, `has no EN counterpart at src/pages/en/${expected}`);
    }
  }
}

// --- run ---------------------------------------------------------------

verifyContentMirror('system-design');
verifyContentMirror('builders');
verifyContentMirror('technology');
verifyContentMirror('archive');
verifyFrontmatter('system-design', /* requireDate */ true);
verifyFrontmatter('builders', /* requireDate */ true);
verifyFrontmatter('technology', /* requireDate */ true);
verifyFrontmatter('archive', /* requireDate */ false);
verifySlugAliases();
verifyLeadMagnets();
verifyPageMirror();

if (failures.length === 0) {
  console.log('verify-structure: all invariants hold.');
  process.exit(0);
}

console.error(`verify-structure: ${failures.length} failure(s).`);
for (const f of failures) {
  console.error(`  ✗ ${f.where} — ${f.why}`);
}
process.exit(1);
