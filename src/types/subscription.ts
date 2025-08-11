// =============================================================================
// 💳 SYSTÈME D'ABONNEMENT MATH4CHILD v4.2.0 - PREMIUM POPULAIRE
// =============================================================================

export interface SubscriptionPlan {
  id: string;
  name: string;
  description: string;
  profiles: number | string; // Peut être un nombre ou "10+" pour ULTIMATE
  priceMonthly: number;
  priceQuarterly: number; // 10% réduction
  priceAnnual: number;    // 30% réduction
  currency: string;
  features: string[];
  platform: 'web' | 'android' | 'ios';
  popular?: boolean; // PREMIUM maintenant populaire
  customQuote?: boolean; // Pour ULTIMATE
  minProfiles?: number;  // Pour ULTIMATE
  badge?: string; // Badge personnalisé (ex: "LE PLUS CHOISI")
}

export interface PlatformDiscount {
  secondPlatform: number; // 50% réduction
  thirdPlatform: number;  // 75% réduction
}

export interface FreeTrialConfig {
  duration: number; // 7 jours = 1 semaine
  questionsLimit: number; // 50 questions
  features: string[];
}

// PLANS AVEC PREMIUM COMME POPULAIRE
export const MATH4CHILD_PLANS: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'Basic',
    description: 'Parfait pour un usage individuel',
    profiles: 1, // 1 PROFIL UNIQUE selon spécifications
    priceMonthly: 499,    // €4.99
    priceQuarterly: 1347, // €13.47 (10% réduction)
    priceAnnual: 4193,    // €41.93 (30% réduction)
    currency: 'eur',
    platform: 'web',
    features: [
      '1 profil utilisateur unique',
      '5 niveaux de progression',
      '100 bonnes réponses minimum par niveau',
      '5 opérations mathématiques complètes',
      'Accès aux niveaux validés',
      'Support communautaire',
      'Accès web uniquement'
    ]
  },
  {
    id: 'standard',
    name: 'Standard',
    description: 'Idéal pour les couples',
    profiles: 2, // 2 PROFILS selon spécifications
    priceMonthly: 999,    // €9.99
    priceQuarterly: 2697, // €26.97 (10% réduction)
    priceAnnual: 8393,    // €83.93 (30% réduction)
    currency: 'eur',
    platform: 'web',
    features: [
      '2 profils utilisateurs',
      'Toutes les fonctionnalités Basic',
      'IA Adaptative avancée',
      'Reconnaissance manuscrite',
      'Statistiques détaillées',
      'Support prioritaire'
    ]
  },
  {
    id: 'premium',
    name: 'Premium',
    description: 'Le choix optimal pour les familles',
    profiles: 3, // 3 PROFILS selon spécifications
    priceMonthly: 1499,   // €14.99
    priceQuarterly: 4047, // €40.47 (10% réduction)
    priceAnnual: 12593,   // €125.93 (30% réduction)
    currency: 'eur',
    platform: 'web',
    popular: true,        // PREMIUM MAINTENANT POPULAIRE
    badge: 'LE PLUS CHOISI',
    features: [
      '3 profils utilisateurs',
      'Toutes les fonctionnalités Standard',
      '🎙️ Assistant vocal IA (Première mondiale)',
      '🥽 Réalité augmentée 3D révolutionnaire',
      '📊 Analytics avancées personnalisées',
      '🎨 Personnalisation complète interface',
      '🏆 Plan le plus populaire (45% des utilisateurs)',
      '⭐ Satisfaction client 98%'
    ]
  },
  {
    id: 'family',
    name: 'Famille',
    description: 'Idéal pour les grandes familles',
    profiles: 5, // 5 PROFILS selon spécifications
    priceMonthly: 1999,   // €19.99
    priceQuarterly: 5397, // €53.97 (10% réduction)
    priceAnnual: 16793,   // €167.93 (30% réduction)
    currency: 'eur',
    platform: 'web',
    features: [
      '5 profils utilisateurs',
      'Toutes les fonctionnalités Premium',
      'Rapports familiaux complets',
      'Contrôle parental avancé',
      'Support VIP prioritaire',
      'Accès bêta nouvelles fonctionnalités'
    ]
  },
  {
    id: 'ultimate',
    name: 'Ultimate',
    description: 'Écoles, institutions et entreprises',
    profiles: '10+', // 10+ PROFILS selon spécifications
    priceMonthly: 2999,   // €29.99 (prix de base)
    priceQuarterly: 8097, // €80.97 (10% réduction)
    priceAnnual: 25193,   // €251.93 (30% réduction)
    currency: 'eur',
    platform: 'web',
    customQuote: true,    // Devis personnalisé requis
    minProfiles: 10,      // Minimum 10 profils
    badge: 'SUR MESURE',
    features: [
      'Minimum 10 profils garantis',
      'AUCUNE LIMITATION MAXIMUM de profils',
      'Devis personnalisé selon besoins',
      'Toutes les fonctionnalités Famille',
      'API développeur complète',
      'Fonctionnalités école/institution',
      'Support dédié 24/7',
      'Personnalisation marque blanche',
      'Formation équipes incluse',
      'SLA garantis',
      'Contact commercial requis'
    ]
  }
];

// VERSION GRATUITE SELON SPÉCIFICATIONS
export const FREE_TRIAL_CONFIG: FreeTrialConfig = {
  duration: 7, // 1 semaine
  questionsLimit: 50, // 50 questions total
  features: [
    'Accès au niveau 1 uniquement',
    '50 questions maximum',
    '7 jours d\'accès',
    'Toutes les 5 opérations mathématiques',
    'Support communautaire'
  ]
};

// RÉDUCTIONS MULTI-PLATEFORMES
export const PLATFORM_DISCOUNTS: PlatformDiscount = {
  secondPlatform: 0.5,  // 50% réduction 2ème plateforme
  thirdPlatform: 0.25   // 75% réduction 3ème plateforme
};

// Statistiques de popularité
export const POPULARITY_STATS = {
  premium: {
    percentage: 45,
    satisfaction: 98,
    retention: 92,
    recommendation: 89
  },
  planDistribution: {
    basic: 15,
    standard: 25,
    premium: 45, // Le plus choisi
    family: 12,
    ultimate: 3
  }
};

// Utilitaires de calcul de prix
export function calculateQuarterlyPrice(monthlyPrice: number): number {
  return Math.round(monthlyPrice * 3 * 0.9); // 10% réduction
}

export function calculateAnnualPrice(monthlyPrice: number): number {
  return Math.round(monthlyPrice * 12 * 0.7); // 30% réduction
}

export function calculatePlatformDiscount(
  basePrice: number, 
  platformCount: number
): number {
  if (platformCount === 2) {
    return Math.round(basePrice * PLATFORM_DISCOUNTS.secondPlatform);
  } else if (platformCount >= 3) {
    return Math.round(basePrice * PLATFORM_DISCOUNTS.thirdPlatform);
  }
  return basePrice;
}

// Fonction pour obtenir le nombre de profils formaté
export function getFormattedProfilesCount(plan: SubscriptionPlan): string {
  if (typeof plan.profiles === 'string') {
    return plan.profiles; // "10+" pour ULTIMATE
  }
  return plan.profiles.toString();
}

// Fonction pour vérifier si un plan nécessite un devis
export function requiresQuote(planId: string): boolean {
  const plan = MATH4CHILD_PLANS.find(p => p.id === planId);
  return plan?.customQuote === true;
}

// Informations de contact commercial pour ULTIMATE
export const COMMERCIAL_CONTACT = {
  email: 'commercial@math4child.com',
  phone: '+33 1 23 45 67 89',
  website: 'www.math4child.com/contact-commercial'
};

// Informations de contact commercial NETTOYÉES
export const COMMERCIAL_CONTACT = {
  email: 'commercial@math4child.com',
  phone: '+33 1 23 45 67 89', // Numéro générique
  website: 'www.math4child.com/contact-commercial'
};

// Contact support NETTOYÉ
export const SUPPORT_CONTACT = {
  email: 'support@math4child.com',
  website: 'www.math4child.com/support'
};
