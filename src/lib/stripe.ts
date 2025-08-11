import Stripe from 'stripe'

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY || '', {
  apiVersion: '2024-06-20',
  typescript: true,
})

export { stripe }

// Types pour Math4Child
export interface PaymentIntent {
  id: string;
  amount: number;
  currency: string;
  status: string;
}

export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  currency: string;
  interval: 'month' | 'year';
  features: string[];
}

export const MATH4CHILD_PLANS: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'Basique',
    price: 999, // €9.99 en centimes
    currency: 'eur',
    interval: 'month',
    features: ['Exercices de base', 'Suivi des progrès', '3 niveaux de difficulté']
  },
  {
    id: 'premium',
    name: 'Premium',
    price: 1999, // €19.99 en centimes
    currency: 'eur',
    interval: 'month',
    features: ['IA Adaptative complète', 'Reconnaissance manuscrite', 'Assistant vocal']
  },
  {
    id: 'ultimate',
    name: 'Ultimate',
    price: 3999, // €39.99 en centimes
    currency: 'eur',
    interval: 'month',
    features: ['Toutes les innovations', 'Réalité Augmentée 3D', 'Support prioritaire']
  }
];
