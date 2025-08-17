import Stripe from 'stripe'

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY || '', {
  apiVersion: '2022-11-15',
  typescript: true,
})

export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  currency: string;
  interval: 'month' | 'year';
  features: string[];
  profiles?: number;
  priceMonthly?: number;
  priceQuarterly?: number;
  priceAnnual?: number;
}

export const MATH4CHILD_PLANS: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'Basique',
    price: 999,
    currency: 'eur',
    interval: 'month',
    features: ['Exercices de base', 'Suivi des progrès', '3 niveaux de difficulté'],
    profiles: 1,
    priceMonthly: 999,
    priceQuarterly: 2499,
    priceAnnual: 8999
  },
  {
    id: 'premium',
    name: 'Premium',
    price: 1999,
    currency: 'eur',
    interval: 'month',
    features: ['IA Adaptative complète', 'Reconnaissance manuscrite', 'Assistant vocal'],
    profiles: 5,
    priceMonthly: 1999,
    priceQuarterly: 4999,
    priceAnnual: 17999
  },
  {
    id: 'ultimate',
    name: 'Ultimate',
    price: 3999,
    currency: 'eur',
    interval: 'month',
    features: ['Toutes les innovations', 'Réalité Augmentée 3D', 'Support prioritaire'],
    profiles: 999,
    priceMonthly: 3999,
    priceQuarterly: 9999,
    priceAnnual: 35999
  }
];

export { stripe }
