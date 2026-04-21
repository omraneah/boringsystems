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

export interface LeadMagnetNotificationPayload {
  subscriberEmail: string;
  assetSlug: string;
  assetTitle: string;
  articleTitle?: string;
  articleUrl?: string;
  lang: 'en' | 'fr';
}

export interface LeadMagnetConfirmationPayload {
  subscriberEmail: string;
  assetTitle: string;
  subject: string;
  body: string;
  replyTo?: string;
}

interface SendEmailArgs {
  to: string;
  subject: string;
  text: string;
  replyTo?: string;
  fromLabel?: string;
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

async function sendEmail(args: SendEmailArgs): Promise<void> {
  const { resend, fromEmail } = getResend();
  const from = `${args.fromLabel ?? 'Boring Systems'} <${fromEmail}>`;

  const { error } = await resend.emails.send({
    from,
    to: args.to,
    ...(args.replyTo ? { replyTo: args.replyTo } : {}),
    subject: args.subject,
    text: args.text,
  });

  if (error) throw new Error(error.message);
}

export async function sendContactEmail(payload: ContactPayload): Promise<void> {
  const { toEmail } = getResend();
  await sendEmail({
    to: toEmail,
    replyTo: payload.email,
    subject: 'New message — Boring Systems',
    text: `From: ${payload.email}\n\n${payload.message}`,
  });
}

export async function sendFeedbackEmail(payload: FeedbackPayload): Promise<void> {
  const { toEmail } = getResend();
  const from = payload.email ? `Reader <${payload.email}>` : 'Anonymous reader';
  await sendEmail({
    to: toEmail,
    replyTo: payload.email,
    subject: `Feedback — ${payload.articleTitle}`,
    text: [
      `Article: ${payload.articleTitle}`,
      `URL: ${payload.articleUrl}`,
      `From: ${from}`,
      ``,
      payload.message,
    ].join('\n'),
  });
}

// Notifies Ahmed that a reader subscribed to a lead-magnet asset.
export async function sendLeadMagnetNotification(payload: LeadMagnetNotificationPayload): Promise<void> {
  const { toEmail } = getResend();
  await sendEmail({
    to: toEmail,
    replyTo: payload.subscriberEmail,
    subject: `Lead magnet request — ${payload.assetTitle}`,
    text: [
      `Asset: ${payload.assetTitle} (${payload.assetSlug})`,
      `Lang: ${payload.lang}`,
      `Subscriber: ${payload.subscriberEmail}`,
      payload.articleTitle ? `From article: ${payload.articleTitle}` : null,
      payload.articleUrl ? `URL: ${payload.articleUrl}` : null,
    ].filter(Boolean).join('\n'),
  });
}

// Confirmation to the subscriber — contents come from the lead-magnet registry.
export async function sendLeadMagnetConfirmation(payload: LeadMagnetConfirmationPayload): Promise<void> {
  await sendEmail({
    to: payload.subscriberEmail,
    replyTo: payload.replyTo,
    subject: payload.subject,
    text: payload.body,
  });
}
