import type { AppTranslations, Translations } from '@/types/i18n';

const frenchTranslations: AppTranslations = {
  nav: {
    home: 'Accueil',
    game: 'Jeu',
    pricing: 'Abonnements',
    profile: 'Profil'
  },
  home: {
    title: 'Math4Child - Apprendre les maths en s\'amusant !',
    subtitle: 'L\'application éducative n°1 pour apprendre les mathématiques',
    description: 'Une application complète pour apprendre les mathématiques de façon ludique.',
    startFree: 'Commencer gratuitement',
    viewPlans: 'Voir les abonnements'
  },
  game: {
    levels: {
      beginner: 'Débutant',
      elementary: 'Élémentaire',
      intermediate: 'Intermédiaire',
      advanced: 'Avancé',
      expert: 'Expert'
    },
    operations: {
      addition: 'Addition',
      subtraction: 'Soustraction',
      multiplication: 'Multiplication',
      division: 'Division'
    }
  }
};

const englishTranslations: AppTranslations = {
  nav: {
    home: 'Home',
    game: 'Game',
    pricing: 'Pricing',
    profile: 'Profile'
  },
  home: {
    title: 'Math4Child - Learn math while having fun!',
    subtitle: 'The #1 educational app for learning mathematics',
    description: 'A complete application to learn mathematics in a fun way.',
    startFree: 'Start for Free',
    viewPlans: 'View Plans'
  },
  game: {
    levels: {
      beginner: 'Beginner',
      elementary: 'Elementary',
      intermediate: 'Intermediate',
      advanced: 'Advanced',
      expert: 'Expert'
    },
    operations: {
      addition: 'Addition',
      subtraction: 'Subtraction',
      multiplication: 'Multiplication',
      division: 'Division'
    }
  }
};

export const translations: Translations = {
  fr: frenchTranslations,
  en: englishTranslations,
  es: { ...englishTranslations }, // Placeholder
  de: { ...englishTranslations }, // Placeholder
  ar: { ...englishTranslations }, // Placeholder - à traduire
  zh: { ...englishTranslations }, // Placeholder
  ru: { ...englishTranslations }, // Placeholder
  ja: { ...englishTranslations }  // Placeholder
};
