const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY || 'sk_test_demo');

export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  currency: string;
  interval: 'month' | 'year';
  features: string[];
  profiles: number;
  popular?: boolean;
  badge?: string;
}

export const MATH4CHILD_PLANS: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'BASIC',
    price: 499,
    currency: 'eur',
    interval: 'month',
    features: ['1 profil utilisateur', '5 niveaux', 'Support communautaire'],
    profiles: 1
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    price: 1499,
    currency: 'eur',
    interval: 'month',
    popular: true,
    badge: 'LE PLUS CHOISI',
    features: ['3 profils', 'IA Adaptative', 'Assistant vocal', 'Réalité augmentée'],
    profiles: 3
  }
];

export { stripe }
