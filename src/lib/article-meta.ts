export type Lang = 'en' | 'fr';

export function readTime(body: string, lang: Lang = 'en'): string {
  const words = body.split(/\s+/).filter(Boolean).length;
  const mins = Math.max(1, Math.ceil(words / 200));
  return lang === 'fr' ? `${mins} min de lecture` : `${mins} min read`;
}

export function formatDate(date: Date | string | undefined, lang: Lang = 'en'): string | null {
  if (!date) return null;
  const d = typeof date === 'string' ? new Date(date) : date;
  if (Number.isNaN(d.getTime())) return null;
  return d.toLocaleDateString(lang === 'fr' ? 'fr-FR' : 'en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
}

export function articleMeta(
  body: string,
  date: Date | string | undefined,
  lang: Lang = 'en',
): string {
  const parts = [formatDate(date, lang), readTime(body, lang)].filter(Boolean);
  return parts.join(' · ');
}
