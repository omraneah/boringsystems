import { deriveLane } from '@/lib/lanes';

let _mp: any = null;

function mp() {
  return _mp;
}

export async function initMixpanel(): Promise<void> {
  const token = import.meta.env.PUBLIC_MIXPANEL_TOKEN;
  if (!token) {
    if (import.meta.env.PROD) console.warn('[analytics] PUBLIC_MIXPANEL_TOKEN not set — no events will fire');
    return;
  }
  const { default: mixpanel } = await import('mixpanel-browser');
  mixpanel.init(token, {
    api_host: 'https://api-eu.mixpanel.com',
    track_pageview: 'url-with-path',
    cross_subdomain_cookie: false,
    ip: false,
    persistence: 'none' as any, // valid at runtime; missing from mixpanel-browser Persistence type
  });
  const lane = deriveLane(window.location.pathname);
  const language = document.documentElement.lang ?? 'en';
  mixpanel.register({ lane, language });
  _mp = mixpanel;
}

export function trackOutbound(targetUrl: string, articleSlug?: string): void {
  const slug = articleSlug ?? document.body?.dataset?.articleSlug ?? '';
  mp()?.track('outbound_link_clicked', { target_url: targetUrl, article_slug: slug });
}

export function trackLeadMagnet(magnetSlug: string, articleSlug: string, language: string): void {
  mp()?.track('lead_magnet_captured', { magnet_slug: magnetSlug, article_slug: articleSlug, language });
}

export function trackScroll75(articleSlug: string, lane: string): void {
  mp()?.track('article_scroll_75', { article_slug: articleSlug, lane });
}

export function trackLanguageToggle(from: string, to: string): void {
  mp()?.track('language_toggled', { from, to });
}

export function trackContactFormSent(): void {
  mp()?.track('contact_form_sent', {});
}
