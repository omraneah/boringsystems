// Registry of lead-magnet assets. Add a new entry here and it becomes
// subscribable anywhere the <LeadMagnet /> component is used.
//
// `body` is the confirmation email sent to subscribers when the asset is
// ready to auto-deliver. When `body` is a placeholder (asset not finalised
// yet), Ahmed receives the notification and sends the real asset manually.
//
// Long prompt bodies (>~30 lines) live in their own file under
// `src/lib/prompts/` and are imported here. Short bodies stay inline.

import {
  TIERED_MEMORY_RESTRUCTURE_PROMPT_EN,
  TIERED_MEMORY_RESTRUCTURE_PROMPT_FR,
} from '@/lib/prompts/tiered-memory-restructure';

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
  'harness-audit': {
    slug: 'harness-audit',
    title: {
      en: 'Personal AI Harness Audit',
      fr: 'Audit de votre AI harness personnel',
    },
    description: {
      en: 'Send me a short description of your current harness — skills, hooks, memory, personas, connectors — and I\'ll send back a written audit plus a set of prompts your coding agent can run to level it up.',
      fr: 'Envoyez-moi une description courte de votre harness actuel — skills, hooks, memory, personas, connectors — et je vous renvoie un audit écrit avec un set de prompts que votre coding agent peut lancer pour le faire évoluer.',
    },
    buttonLabel: {
      en: 'Send me the audit',
      fr: 'Envoyez-moi l\'audit',
    },
    prompt: {
      en: 'Drop your email and one paragraph on your current setup — or a link to your `.claude/` folder if it\'s public. One email back with the audit and the next-step prompts. No list, no sequence.',
      fr: 'Laissez votre email et un paragraphe sur votre setup actuel — ou un lien vers votre dossier `.claude/` s\'il est public. Un seul email retour avec l\'audit et les prompts de next step. Pas de liste, pas de séquence.',
    },
    confirmation: {
      en: {
        subject: 'Your AI Harness Audit — incoming',
        body: [
          'Thanks for reaching out.',
          '',
          'I\'ll review what you sent and come back within a few days with a written audit — concrete observations on what\'s working, what to reorder, what to cut — plus a short set of prompts you can hand your coding agent to apply the changes.',
          '',
          'If you want to sharpen the audit, reply with the one constraint or workflow that bothers you most today. I\'ll focus there.',
          '',
          '— Ahmed',
          'boringsystems.app',
        ].join('\n'),
      },
      fr: {
        subject: 'Votre AI Harness Audit — en préparation',
        body: [
          'Merci pour votre message.',
          '',
          'Je regarde ce que vous m\'avez envoyé et je reviens dans les prochains jours avec un audit écrit — observations concrètes sur ce qui marche, ce qu\'il faut réordonner, ce qu\'il faut couper — plus un set de prompts à donner à votre coding agent pour appliquer les changements.',
          '',
          'Pour un audit plus ciblé : répondez avec la contrainte ou le workflow qui vous gêne le plus aujourd\'hui. Je focaliserai là-dessus.',
          '',
          '— Ahmed',
          'boringsystems.app',
        ].join('\n'),
      },
    },
  },
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
  'tiered-memory-restructure-prompt': {
    slug: 'tiered-memory-restructure-prompt',
    title: {
      en: 'The Tiered-Memory Restructure Prompt',
      fr: 'Le prompt de restructure de tiered memory',
    },
    description: {
      en: 'A ready-to-paste prompt for Claude Code that walks your own agent through the tiered-memory restructure described in the case file — exploration first, then tier drafts, then migration in batches, then drift skills, then weekly consolidation, then cutover. Six phases, explicit checkpoints, no bulk-move.',
      fr: 'Un prompt prêt à coller dans Claude Code qui guide votre propre agent à travers le restructure de tiered memory décrit dans le case file — exploration d\'abord, puis drafts de tiers, puis migration en batches, puis drift skills, puis consolidation hebdomadaire, puis cutover. Six phases, checkpoints explicites, aucun bulk-move.',
    },
    buttonLabel: {
      en: 'Send me the prompt',
      fr: 'Envoyez-moi le prompt',
    },
    prompt: {
      en: 'Drop your email and I\'ll send you the prompt. One email, no list, no follow-up sequence.',
      fr: 'Laissez votre email et je vous envoie le prompt. Un seul email, pas de liste, pas de séquence.',
    },
    confirmation: {
      en: {
        subject: 'Your Tiered-Memory Restructure Prompt',
        body: [
          'Thanks for reaching out. The full prompt is below — paste it into Claude Code at the root of your workspace and let it run.',
          '',
          'A few things worth knowing before you start:',
          '',
          '— Phase 1 is gating. Do not let the agent skip the exploration. Your starting state is almost certainly different from the reference state, and a tier system designed against the wrong starting state will not survive contact with reality.',
          '— The drift skills (\\`/whence\\` and \\`/divergence-check\\`) get wired before the weekly consolidation. They are what makes the long-term tier safe to have.',
          '— The cutover is reversible until you delete the old folder. Run a full session on the new tree before deleting anything.',
          '',
          'If you want to send me the agent\'s output at any phase boundary for a second pair of eyes, reply to this email with the diff and I will read it.',
          '',
          '— Ahmed',
          'boringsystems.app',
          '',
          '----- BEGIN PROMPT -----',
          '',
          TIERED_MEMORY_RESTRUCTURE_PROMPT_EN,
          '',
          '----- END PROMPT -----',
        ].join('\n'),
      },
      fr: {
        subject: 'Votre prompt de restructure de tiered memory',
        body: [
          'Merci pour votre message. Le prompt complet est ci-dessous — collez-le dans Claude Code à la racine de votre workspace et laissez-le tourner.',
          '',
          'Quelques points utiles avant de démarrer :',
          '',
          '— La Phase 1 est gating. Ne laissez pas l\'agent sauter l\'exploration. Votre point de départ est presque sûrement différent de l\'état de référence, et un système de tiers designé contre le mauvais point de départ ne survivra pas au contact avec la réalité.',
          '— Les drift skills (\\`/whence\\` et \\`/divergence-check\\`) sont câblés avant la consolidation hebdomadaire. Ce sont eux qui rendent le tier long-term sûr à avoir.',
          '— Le cutover est réversible jusqu\'à ce que vous supprimiez l\'ancien dossier. Faites tourner une session entière sur le nouvel arbre avant de supprimer quoi que ce soit.',
          '',
          'Si vous voulez m\'envoyer la sortie de l\'agent à n\'importe quelle frontière de phase pour une deuxième paire d\'yeux, répondez à cet email avec le diff et je le lis.',
          '',
          '— Ahmed',
          'boringsystems.app',
          '',
          '----- DÉBUT DU PROMPT -----',
          '',
          TIERED_MEMORY_RESTRUCTURE_PROMPT_FR,
          '',
          '----- FIN DU PROMPT -----',
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
