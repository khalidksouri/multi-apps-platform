// =============================================================================
// 💳 TYPES STRIPE MATH4CHILD v4.2.0
// =============================================================================

export interface StripeCheckoutSession {
  id: string;
  url: string;
  payment_status: 'paid' | 'unpaid' | 'no_payment_required';
  customer_email?: string;
}

export interface StripeSubscription {
  id: string;
  status: 'active' | 'canceled' | 'incomplete' | 'past_due' | 'trialing';
  current_period_start: number;
  current_period_end: number;
  plan: {
    id: string;
    amount: number;
    currency: string;
    interval: 'month' | 'year';
  };
}

export interface StripeCustomer {
  id: string;
  email: string;
  name?: string;
  created: number;
  subscriptions: {
    data: StripeSubscription[];
  };
}

export interface StripeProduct {
  id: string;
  name: string;
  description: string;
  images: string[];
  metadata: Record<string, string>;
}

export interface StripePrice {
  id: string;
  unit_amount: number;
  currency: string;
  recurring?: {
    interval: 'month' | 'year';
    interval_count: number;
  };
  product: string;
}

// Types spécifiques à Math4Child
export interface Math4ChildPlan {
  id: string;
  name: string;
  description: string;
  price: number;
  currency: string;
  interval: 'month' | 'year';
  features: string[];
  stripePriceId: string;
  popular?: boolean;
  discount?: {
    percentage: number;
    validUntil?: Date;
  };
}

export interface PricingConfig {
  plans: Math4ChildPlan[];
  currencies: string[];
  regions: {
    [countryCode: string]: {
      currency: string;
      taxRate?: number;
    };
  };
}

// Configuration des plans Math4Child
export const MATH4CHILD_PRICING: PricingConfig = {
  plans: [
    {
      id: 'basic',
      name: 'Basique',
      description: 'Parfait pour débuter avec Math4Child',
      price: 999, // €9.99
      currency: 'eur',
      interval: 'month',
      stripePriceId: 'price_basic_monthly',
      features: [
        'Exercices de base',
        'Suivi des progrès',
        '3 niveaux de difficulté',
        'Support multilingue',
        'Accès mobile'
      ]
    },
    {
      id: 'premium',
      name: 'Premium',
      description: "L'expérience complète Math4Child",
      price: 1999, // €19.99
      currency: 'eur',
      interval: 'month',
      stripePriceId: 'price_premium_monthly',
      popular: true,
      features: [
        'IA Adaptative complète',
        'Reconnaissance manuscrite',
        'Assistant vocal',
        'Analyses avancées',
        'Comptes famille (5)',
        'Personnalisation',
        'Support prioritaire'
      ]
    },
    {
      id: 'ultimate',
      name: 'Ultimate',
      description: 'Toute la puissance révolutionnaire',
      price: 3999, // €39.99
      currency: 'eur',
      interval: 'month',
      stripePriceId: 'price_ultimate_monthly',
      features: [
        'Réalité Augmentée 3D',
        'IA Ultra-Adaptative',
        'Reconnaissance avancée',
        'Assistant vocal émotionnel',
        'Comptes illimités',
        'Fonctionnalités école',
        'Tableaux de bord enseignant',
        'API développeur',
        'Support dédié 24/7'
      ]
    }
  ],
  currencies: ['eur', 'usd', 'gbp'],
  regions: {
    'FR': { currency: 'eur', taxRate: 0.20 },
    'US': { currency: 'usd', taxRate: 0.08 },
    'GB': { currency: 'gbp', taxRate: 0.20 },
    'DE': { currency: 'eur', taxRate: 0.19 }
  }
};
