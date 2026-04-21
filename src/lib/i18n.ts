// Locale-aware URL helpers for boringsystems.
//
// Astro's `astro:i18n` module provides `getRelativeLocaleUrl` and
// `getAbsoluteLocaleUrl`, but those assume a single path shape. Our
// Essays lane has a locale-specific slug (`/en/essays` ↔ `/fr/essais`),
// so we need a small wrapper that knows about that mapping.

export type Lang = 'en' | 'fr';

export const LOCALES: Lang[] = ['en', 'fr'];
export const DEFAULT_LOCALE: Lang = 'en';

// Paths whose localized slug differs per locale. Key shape is
// "{lang}:{path-suffix}". Add an entry here when a new slug diverges.
const SLUG_ALIASES: Record<string, string> = {
  'en:essays': 'fr:essais',
  'fr:essais': 'en:essays',
};

function stripLocalePrefix(path: string): { lang: Lang | null; rest: string } {
  for (const lang of LOCALES) {
    if (path === `/${lang}` || path === `/${lang}/`) return { lang, rest: '/' };
    if (path.startsWith(`/${lang}/`)) return { lang, rest: path.slice(3) };
  }
  return { lang: null, rest: path };
}

// Given a current pathname, return the equivalent pathname in `target` locale.
// Applies SLUG_ALIASES for lanes with locale-specific slugs.
export function toLocalePath(path: string, target: Lang): string {
  const { lang, rest } = stripLocalePrefix(path);
  if (!lang) return path;
  if (lang === target) return path;

  const segments = rest.replace(/^\/+|\/+$/g, '').split('/').filter(Boolean);
  const firstSeg = segments[0] ?? '';

  const aliasKey = `${lang}:${firstSeg}`;
  const aliasValue = SLUG_ALIASES[aliasKey];
  if (aliasValue) {
    const [, alias] = aliasValue.split(':');
    segments[0] = alias;
  }

  const newPath = segments.length ? `/${target}/${segments.join('/')}` : `/${target}/`;
  return newPath;
}

// For a given pathname + site origin, emit the hreflang pairs.
// Returns one entry per locale plus x-default (pointing at default locale).
// Returns null for paths where hreflang does not apply (e.g. api routes).
export function hreflangsForPath(
  pathname: string,
  site: URL | string,
): { hreflang: string; href: string }[] | null {
  // No hreflang for api routes or root (root 301s to /en/ and never renders a page)
  if (pathname.startsWith('/api/')) return null;
  if (pathname === '/' || pathname === '') return null;

  const { lang } = stripLocalePrefix(pathname);
  if (!lang) return null;

  const origin = typeof site === 'string' ? site : site.toString();

  const byLocale = LOCALES.map((locale) => ({
    hreflang: locale === 'en' ? 'en-US' : 'fr-FR',
    href: new URL(toLocalePath(pathname, locale), origin).href,
  }));

  const xDefault = {
    hreflang: 'x-default',
    href: new URL(toLocalePath(pathname, DEFAULT_LOCALE), origin).href,
  };

  return [...byLocale, xDefault];
}
