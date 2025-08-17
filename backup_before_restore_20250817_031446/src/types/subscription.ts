export interface SubscriptionPlan {
  id: string;
  name: string;
  description: string;
  price: number;
  currency: string;
  interval: 'month' | 'year';
  features: string[];
  stripePriceId?: string;
  popular?: boolean;
  savings?: string;
  profiles?: number;
  priceMonthly?: number;
  priceQuarterly?: number;
  priceAnnual?: number;
}

export const MATH4CHILD_PLANS: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'Basique',
    description: 'Parfait pour débuter',
    price: 999,
    currency: 'eur',
    interval: 'month',
    features: ['Exercices de base', 'Suivi des progrès', '3 niveaux de difficulté'],
    stripePriceId: 'price_basic_monthly',
    profiles: 1,
    priceMonthly: 999,
    priceQuarterly: 2499,
    priceAnnual: 8999
  },
  {
    id: 'premium',
    name: 'Premium',
    description: 'L\'expérience complète',
    price: 1999,
    currency: 'eur',
    interval: 'month',
    features: ['IA Adaptative', 'Reconnaissance manuscrite', 'Assistant vocal'],
    stripePriceId: 'price_premium_monthly',
    popular: true,
    profiles: 5,
    priceMonthly: 1999,
    priceQuarterly: 4999,
    priceAnnual: 17999
  },
  {
    id: 'ultimate',
    name: 'Ultimate',
    description: 'Toute la puissance',
    price: 3999,
    currency: 'eur',
    interval: 'month',
    features: ['Réalité Augmentée 3D', 'IA Ultra-Adaptative', 'Support 24/7'],
    stripePriceId: 'price_ultimate_monthly',
    profiles: 999,
    priceMonthly: 3999,
    priceQuarterly: 9999,
    priceAnnual: 35999
  }
];

export interface FreeTrialConfig {
  duration: number;
  durationUnit: 'days' | 'weeks';
  features: string[];
}

export const FREE_TRIAL_CONFIG: FreeTrialConfig = {
  duration: 14,
  durationUnit: 'days',
  features: ['Accès complet', 'Tous les exercices', 'Support prioritaire']
};

export interface ContactInfo {
  email: string;
  website: string;
  phone: string;
}

export const COMMERCIAL_CONTACT: ContactInfo = {
  email: 'commercial@math4child.com',
  website: 'https://www.math4child.com',
  phone: '+33 1 42 86 83 21'
};

export interface PopularityStats {
  usersCount: number;
  countriesCount: number;
  satisfactionRate: number;
  premium: {
    percentage: number;
    satisfaction: number;
    renewal: number;
  };
}

export const POPULARITY_STATS: PopularityStats = {
  usersCount: 150000,
  countriesCount: 45,
  satisfactionRate: 98,
  premium: {
    percentage: 45,
    satisfaction: 98,
    renewal: 92
  }
};

// Corriger la signature de la fonction
export function calculatePlatformDiscount(basePrice: number, platform: number): number {
  const platformString = platform.toString();
  const discounts: { [key: string]: number } = {
    'mobile': 0.1,
    'web': 0,
    'tablet': 0.05,
    '1': 0,      // 1 platform
    '2': 0.05,   // 2+ platforms 
    '3': 0.1     // 3+ platforms
  };
  
  const discount = discounts[platformString] || 0;
  return Math.round(basePrice * (1 - discount));
}

// Corriger la signature de la fonction
export function getFormattedProfilesCount(plan: SubscriptionPlan): string {
  if (!plan.profiles) return '1 profil';
  
  if (plan.profiles === 1) return '1 profil';
  if (plan.profiles > 100) return 'Illimité';
  return `${plan.profiles} profils`;
}

export function requiresQuote(planId: string): boolean {
  return planId === 'enterprise' || planId === 'school';
}
