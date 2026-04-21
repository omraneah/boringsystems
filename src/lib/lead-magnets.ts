// Registry of lead-magnet assets. Add a new entry here and it becomes
// subscribable anywhere the <LeadMagnet /> component is used.
//
// `body` is the confirmation email sent to subscribers when the asset is
// ready to auto-deliver. When `body` is a placeholder (asset not finalised
// yet), Ahmed receives the notification and sends the real asset manually.

export type Lang = 'en' | 'fr';

export interface LeadMagnetAsset {
  slug: string;
  title: Record<Lang, string>;
  description: Record<Lang, string>;
  buttonLabel: Record<Lang, string>;
  // Copy shown inline on the form, above the email input.
  prompt: Record<Lang, string>;
  // Email subject + body sent to the subscriber as confirmation.
  confirmation: Record<Lang, { subject: string; body: string }>;
}

export const LEAD_MAGNETS: Record<string, LeadMagnetAsset> = {
  'ai-native-builder-starter-prompt': {
    slug: 'ai-native-builder-starter-prompt',
    title: {
      en: 'The AI-Native Builder Starter Prompt',
      fr: 'Le prompt de démarrage AI-Native Builder',
    },
    description: {
      en: 'A ready-to-paste prompt for Claude Code that scaffolds the full stack described here — git, GitHub, Vercel, Neon, Resend, and the initial project conventions.',
      fr: 'Un prompt prêt à coller dans Claude Code qui scaffolde la stack décrite ici — git, GitHub, Vercel, Neon, Resend, et les conventions de départ du projet.',
    },
    buttonLabel: {
      en: 'Send me the prompt',
      fr: 'Envoyez-moi le prompt',
    },
    prompt: {
      en: 'Drop your email and I\'ll send you the starter prompt. One email, no list, no follow-up sequence.',
      fr: 'Laissez votre email et je vous envoie le prompt de démarrage. Un seul email, pas de liste, pas de séquence.',
    },
    confirmation: {
      en: {
        subject: 'Your AI-Native Builder Starter Prompt — incoming',
        body: [
          'Thanks for reaching out.',
          '',
          'I\'m finalising this prompt — you\'ll get it directly from me within the next few days, along with a short note on how to use it.',
          '',
          'If you want to skip the wait, reply to this email with one line about what you\'re building. That changes what I send back.',
          '',
          '— Ahmed',
          'boringsystems.app',
        ].join('\n'),
      },
      fr: {
        subject: 'Votre prompt AI-Native Builder — en préparation',
        body: [
          'Merci pour votre intérêt.',
          '',
          'Je finalise ce prompt — vous le recevrez directement de ma part dans les prochains jours, avec une note courte sur comment l\'utiliser.',
          '',
          'Pour accélérer : répondez à cet email en une ligne sur ce que vous construisez. Ça change ce que je vous envoie.',
          '',
          '— Ahmed',
          'boringsystems.app',
        ].join('\n'),
      },
    },
  },
};

export function getLeadMagnet(slug: string): LeadMagnetAsset {
  const asset = LEAD_MAGNETS[slug];
  if (!asset) throw new Error(`Unknown lead magnet: ${slug}`);
  return asset;
}
