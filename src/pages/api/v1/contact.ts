import type { APIRoute } from 'astro';
import { sendContactEmail } from '../../../lib/mailer';
import { json, jsonError } from '../../../lib/http';

export const prerender = false;

export const POST: APIRoute = async ({ request }) => {
  let body: unknown;

  try {
    body = await request.json();
  } catch {
    return jsonError('Invalid request body', 400);
  }

  const { email, message } = body as Record<string, unknown>;

  if (
    typeof email !== 'string' || !email.includes('@') ||
    typeof message !== 'string' || message.trim().length === 0
  ) {
    return jsonError('Invalid input', 422);
  }

  try {
    await sendContactEmail({ email: email.trim(), message: message.trim() });
  } catch (err) {
    console.error('[contact] send failed:', err);
    return jsonError('Failed to send message', 500);
  }

  return json({ ok: true });
};
