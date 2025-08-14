// =============================================================================
// 💳 SYSTÈME DE PAIEMENT MATH4CHILD - STRIPE INTEGRATION
// =============================================================================

import { PaymentInfo, SubscriptionPlan } from '@/types';

// Plans d'abonnement selon README.md avec tarification exacte
export const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: 'basic',
    name: 'BASIC',
    price: 4.99,
    profiles: 1,
    currency: 'EUR',
    features: [
      '1 profil unique',
      '5 niveaux de progression',
      '100 réponses minimum par niveau',
      '5 opérations mathématiques',
      'Support communautaire',
      'Accès web uniquement'
    ]
  },
  {
    id: 'standard',
    name: 'STANDARD',
    price: 9.99,
    profiles: 2,
    currency: 'EUR',
    features: [
      '2 profils utilisateur',
      'Toutes fonctionnalités BASIC',
      'IA Adaptative avancée',
      'Reconnaissance manuscrite',
      'Statistiques détaillées',
      'Support prioritaire'
    ]
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    price: 14.99,
    profiles: 3,
    popular: true,
    badge: 'LE PLUS CHOISI',
    currency: 'EUR',
    features: [
      '3 profils utilisateur',
      'Toutes fonctionnalités STANDARD',
      'Assistant vocal IA',
      'Réalité augmentée 3D',
      'Analytics avancées',
      'Personnalisation complète'
    ]
  },
  {
    id: 'famille',
    name: 'FAMILLE',
    price: 19.99,
    profiles: 5,
    currency: 'EUR',
    features: [
      '5 profils utilisateur',
      'Toutes fonctionnalités PREMIUM',
      'Rapports familiaux',
      'Contrôle parental avancé',
      'Support VIP prioritaire',
      'Accès bêta nouvelles fonctionnalités'
    ]
  },
  {
    id: 'ultimate',
    name: 'ULTIMATE',
    price: 29.99,
    profiles: 10,
    currency: 'EUR',
    features: [
      '10+ profils (sans limite)',
      'Devis personnalisé',
      'API développeur',
      'Fonctionnalités école/institution',
      'Support dédié 24/7',
      'Marque blanche'
    ]
  }
];

// Réductions multi-plateformes selon README.md
export function calculateDiscount(interval: 'monthly' | 'quarterly' | 'yearly'): number {
  switch (interval) {
    case 'quarterly':
      return 0.10; // 10%
    case 'yearly':
      return 0.30; // 30%
    default:
      return 0;
  }
}

// Tarification localisée selon pouvoir d'achat
export function getLocalizedPrice(planId: string, countryCode: string): PaymentInfo {
  const basePlan = SUBSCRIPTION_PLANS.find(p => p.id === planId);
  if (!basePlan) throw new Error('Plan non trouvé');
  
  const multipliers = {
    'US': 1.2,   // $5.99 au lieu de €4.99
    'GB': 0.9,   // £4.49 au lieu de €4.99
    'IN': 0.3,   // Pays émergents 70% réduction
    'BR': 0.4,   // Pays émergents 60% réduction
    'FR': 1.0,   // Prix de base
  };
  
  const multiplier = multipliers[countryCode] || 1.0;
  const localPrice = basePlan.price * multiplier;
  
  return {
    planId: basePlan.id,
    amount: Math.round(localPrice * 100) / 100,
    currency: getCurrency(countryCode),
    interval: 'monthly',
    platform: 'web'
  };
}

function getCurrency(countryCode: string): string {
  const currencies = {
    'US': 'USD',
    'GB': 'GBP',
    'FR': 'EUR',
    'DE': 'EUR',
    'ES': 'EUR',
    'IT': 'EUR',
    'IN': 'INR',
    'BR': 'BRL',
    'JP': 'JPY',
  };
  
  return currencies[countryCode] || 'EUR';
}

// Intégration Stripe
export async function createStripeCheckout(paymentInfo: PaymentInfo): Promise<string> {
  // En production, appeler l'API Stripe
  console.log('Création session Stripe:', paymentInfo);
  
  // Retourne l'URL de checkout Stripe
  return 'https://checkout.stripe.com/pay/session_id';
}
