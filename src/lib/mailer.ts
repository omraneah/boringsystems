import { Resend } from 'resend';

export interface ContactPayload {
  email: string;
  message: string;
}

// Swap this function to change email provider — nothing else needs to change.
export async function sendContactEmail(payload: ContactPayload): Promise<void> {
  const apiKey = import.meta.env.RESEND_API_KEY;
  const toEmail = import.meta.env.CONTACT_TO_EMAIL;

  if (!apiKey || !toEmail) {
    throw new Error('Missing RESEND_API_KEY or CONTACT_TO_EMAIL environment variables');
  }

  const resend = new Resend(apiKey);

  const { error } = await resend.emails.send({
    from: 'Boring Systems <contact@boringsystems.ai>',
    to: toEmail,
    replyTo: payload.email,
    subject: 'New message — Boring Systems',
    text: `From: ${payload.email}\n\n${payload.message}`,
  });

  if (error) {
    throw new Error(error.message);
  }
}
