let _mp: any = null;

function mp() {
  return _mp;
}

function deriveLane(pathname: string): string {
  if (pathname.includes('/writing/')) return 'writing';
  if (pathname.includes('/work/')) return 'work';
  if (pathname.includes('/building/')) return 'building';
  if (pathname.includes('/archive/')) return 'archive';
  if (pathname.endsWith('/about') || pathname.endsWith('/about/')) return 'about';
  if (pathname.endsWith('/work-with-me') || pathname.endsWith('/work-with-me/')) return 'work-with-me';
  return 'home';
}

export async function initMixpanel(): Promise<void> {
  const token = import.meta.env.PUBLIC_MIXPANEL_TOKEN;
  if (!token) return;
  const { default: mixpanel } = await import('mixpanel-browser');
  mixpanel.init(token, {
    api_host: 'https://api-eu.mixpanel.com',
    track_pageview: 'url-with-path',
    cross_subdomain_cookie: false,
    ip: false,
  });
  const lane = deriveLane(window.location.pathname);
  const language = document.documentElement.lang ?? 'en';
  const voiceTarget = (document.body.dataset.voiceTarget as string) ?? 'unknown';
  const isReturning = (() => {
    try { return localStorage.getItem('bs_returning') === 'true'; } catch { return false; }
  })();
  mixpanel.register({ lane, language, voice_target: voiceTarget, is_returning: isReturning });
  if (!isReturning) { try { localStorage.setItem('bs_returning', 'true'); } catch {} }
  _mp = mixpanel;
}

export function trackOutbound(targetUrl: string, articleSlug?: string): void {
  const slug = articleSlug ?? document.body?.dataset?.articleSlug ?? '';
  mp()?.track('outbound_link_clicked', { target_url: targetUrl, article_slug: slug });
}

export function trackLeadMagnet(magnetSlug: string, articleSlug: string, language: string): void {
  mp()?.track('lead_magnet_captured', { magnet_slug: magnetSlug, article_slug: articleSlug, language });
}

export function trackScroll75(articleSlug: string, lane: string, voiceTarget: string): void {
  mp()?.track('article_scroll_75', { article_slug: articleSlug, lane, voice_target: voiceTarget });
}

export function trackLanguageToggle(from: string, to: string): void {
  mp()?.track('language_toggled', { from, to });
}

export function trackPortfolioVisit(): void {
  mp()?.track('portfolio_visited', {});
}
