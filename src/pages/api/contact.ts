import type { APIRoute } from 'astro';
import { sendContactEmail } from '../../lib/mailer';

export const prerender = false;

export const POST: APIRoute = async ({ request }) => {
  let body: unknown;

  try {
    body = await request.json();
  } catch {
    return new Response(JSON.stringify({ error: 'Invalid request body' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const { email, message } = body as Record<string, unknown>;

  if (
    typeof email !== 'string' || !email.includes('@') ||
    typeof message !== 'string' || message.trim().length === 0
  ) {
    return new Response(JSON.stringify({ error: 'Invalid input' }), {
      status: 422,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    await sendContactEmail({ email: email.trim(), message: message.trim() });
  } catch (err) {
    console.error('[contact] send failed:', err);
    return new Response(JSON.stringify({ error: 'Failed to send message' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  return new Response(JSON.stringify({ ok: true }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
};
