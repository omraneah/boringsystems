import type { APIRoute } from 'astro';
import { sendFeedbackEmail } from '../../lib/mailer';

export const prerender = false;

export const POST: APIRoute = async ({ request }) => {
  let body: unknown;

  try {
    body = await request.json();
  } catch {
    return json({ error: 'Invalid request body' }, 400);
  }

  const { message, email, articleTitle, articleUrl } = body as Record<string, unknown>;

  if (typeof message !== 'string' || message.trim().length === 0) {
    return json({ error: 'Message is required' }, 422);
  }
  if (typeof articleTitle !== 'string' || typeof articleUrl !== 'string') {
    return json({ error: 'Missing article context' }, 422);
  }
  if (email !== undefined && (typeof email !== 'string' || !email.includes('@'))) {
    return json({ error: 'Invalid email' }, 422);
  }

  try {
    await sendFeedbackEmail({
      message: message.trim(),
      email: typeof email === 'string' ? email.trim() : undefined,
      articleTitle,
      articleUrl,
    });
  } catch (err) {
    console.error('[feedback] send failed:', err);
    return json({ error: 'Failed to send feedback' }, 500);
  }

  return json({ ok: true }, 200);
};

function json(body: object, status: number) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}
