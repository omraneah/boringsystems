import { Resend } from 'resend';

export interface ContactPayload {
  email: string;
  message: string;
}

export interface FeedbackPayload {
  message: string;
  email?: string;
  articleTitle: string;
  articleUrl: string;
}

function getResend(): { resend: Resend; toEmail: string; fromEmail: string } {
  const apiKey = import.meta.env.RESEND_API_KEY;
  const toEmail = import.meta.env.CONTACT_TO_EMAIL;
  const fromEmail = import.meta.env.CONTACT_FROM_EMAIL;
  if (!apiKey || !toEmail || !fromEmail) {
    throw new Error('Missing RESEND_API_KEY, CONTACT_TO_EMAIL or CONTACT_FROM_EMAIL environment variables');
  }
  return { resend: new Resend(apiKey), toEmail, fromEmail };
}

// Swap this function to change email provider — nothing else needs to change.
export async function sendContactEmail(payload: ContactPayload): Promise<void> {
  const { resend, toEmail, fromEmail } = getResend();

  const { error } = await resend.emails.send({
    from: `Boring Systems <${fromEmail}>`,
    to: toEmail,
    replyTo: payload.email,
    subject: 'New message — Boring Systems',
    text: `From: ${payload.email}\n\n${payload.message}`,
  });

  if (error) throw new Error(error.message);
}

export async function sendFeedbackEmail(payload: FeedbackPayload): Promise<void> {
  const { resend, toEmail, fromEmail } = getResend();

  const from = payload.email ? `Reader <${payload.email}>` : 'Anonymous reader';
  const replyTo = payload.email ?? undefined;

  const { error } = await resend.emails.send({
    from: `Boring Systems <${fromEmail}>`,
    to: toEmail,
    ...(replyTo ? { replyTo } : {}),
    subject: `Feedback — ${payload.articleTitle}`,
    text: [
      `Article: ${payload.articleTitle}`,
      `URL: ${payload.articleUrl}`,
      `From: ${from}`,
      ``,
      payload.message,
    ].join('\n'),
  });

  if (error) throw new Error(error.message);
}
