import type { APIRoute } from 'astro';
import { sendLeadMagnetNotification, sendLeadMagnetConfirmation } from '@/lib/mailer';
import { LEAD_MAGNETS } from '@/lib/lead-magnets';
import { json, jsonError } from '@/lib/http';

export const prerender = false;

export const POST: APIRoute = async ({ request }) => {
  let body: unknown;

  try {
    body = await request.json();
  } catch {
    return jsonError('Invalid request body', 400);
  }

  const { email, assetSlug, lang, articleTitle, articleUrl } = body as Record<string, unknown>;

  if (typeof email !== 'string' || !email.includes('@')) {
    return jsonError('Invalid email', 422);
  }
  if (typeof assetSlug !== 'string' || !(assetSlug in LEAD_MAGNETS)) {
    return jsonError('Unknown asset', 422);
  }
  const resolvedLang: 'en' | 'fr' = lang === 'fr' ? 'fr' : 'en';

  const asset = LEAD_MAGNETS[assetSlug];
  const subscriberEmail = email.trim();

  try {
    // Notify first. If that fails, do not confirm.
    await sendLeadMagnetNotification({
      subscriberEmail,
      assetSlug: asset.slug,
      assetTitle: asset.title[resolvedLang],
      articleTitle: typeof articleTitle === 'string' ? articleTitle : undefined,
      articleUrl: typeof articleUrl === 'string' ? articleUrl : undefined,
      lang: resolvedLang,
    });

    await sendLeadMagnetConfirmation({
      subscriberEmail,
      assetTitle: asset.title[resolvedLang],
      subject: asset.confirmation[resolvedLang].subject,
      body: asset.confirmation[resolvedLang].body,
    });
  } catch (err) {
    console.error('[lead-magnet] send failed:', err);
    return jsonError('Failed to register. Try again.', 500);
  }

  return json({ ok: true });
};
