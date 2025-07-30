/**
 * Configuration Stripe Math4Child - Version corrigée
 * Business: GOTEST (SIRET: 53958712100028)
 */

// Import conditionnel pour éviter les erreurs côté serveur
let stripePromise: Promise<any> | null = null

// Configuration business GOTEST
export const BUSINESS_INFO = {
  name: 'GOTEST',
  siret: '53958712100028',
  email: 'khalid_ksouri@yahoo.fr',
  website: 'https://www.math4child.com',
  iban: 'FR7616958000016218830371501'
}

// Fonction pour charger Stripe uniquement côté client
export const getStripe = async () => {
  if (typeof window === 'undefined') {
    return null // Retourner null côté serveur
  }

  if (!stripePromise) {
    const { loadStripe } = await import('@stripe/stripe-js')
    const publishableKey = process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || 'pk_test_...'
    stripePromise = loadStripe(publishableKey)
  }
  
  return stripePromise
}

// Plans d'abonnement Math4Child
export const SUBSCRIPTION_PLANS = {
  free: {
    id: 'free',
    name: 'Gratuit',
    price: 0,
    currency: 'eur',
    interval: 'month',
    interval_count: 1,
    features: [
      '1 profil enfant',
      'Exercices de base',
      '50 questions/semaine',
      'Statistiques simples'
    ]
  },
  premium: {
    id: 'premium',
    name: 'Premium',
    price: 999, // 9.99€ en centimes
    currency: 'eur',
    interval: 'month',
    interval_count: 1,
    stripePriceId: 'price_test_premium_monthly',
    features: [
      '3 profils enfants',
      'Tous les exercices',
      'Questions illimitées',
      'Statistiques avancées',
      'Support prioritaire'
    ]
  },
  premium_yearly: {
    id: 'premium_yearly',
    name: 'Premium Annuel',
    price: 9999, // 99.99€ en centimes
    currency: 'eur',
    interval: 'year',
    interval_count: 1,
    stripePriceId: 'price_test_premium_yearly',
    originalPrice: 11988, // 119.88€
    savings: '17%',
    features: [
      'Toutes les fonctionnalités Premium',
      '2 mois gratuits',
      'Garantie remboursement 30j'
    ]
  },
  family: {
    id: 'family',
    name: 'Famille',
    price: 1999, // 19.99€ en centimes
    currency: 'eur',
    interval: 'month',
    interval_count: 1,
    stripePriceId: 'price_test_family_monthly',
    features: [
      '6 profils enfants',
      'Tableau de bord famille',
      'Rapports détaillés',
      'Mode compétition',
      'Support VIP 24/7'
    ]
  },
  family_yearly: {
    id: 'family_yearly',
    name: 'Famille Annuel',
    price: 19999, // 199.99€ en centimes
    currency: 'eur',
    interval: 'year',
    interval_count: 1,
    stripePriceId: 'price_test_family_yearly',
    originalPrice: 23988, // 239.88€
    savings: '25%',
    features: [
      'Toutes les fonctionnalités Famille',
      '3 mois gratuits',
      'Consultation pédagogique offerte'
    ]
  }
}

// Configuration des webhooks Stripe
export const STRIPE_WEBHOOK_EVENTS = [
  'customer.subscription.created',
  'customer.subscription.updated',
  'customer.subscription.deleted',
  'invoice.payment_succeeded',
  'invoice.payment_failed',
  'checkout.session.completed',
  'checkout.session.expired'
]

// Métadonnées pour tous les paiements
export const createStripeMetadata = (userId: string, planId: string, platform: string = 'web') => ({
  userId,
  planId,
  platform,
  business: BUSINESS_INFO.name,
  siret: BUSINESS_INFO.siret,
  app: 'math4child',
  version: '2.0.0',
  contact: BUSINESS_INFO.email
})

// Utilitaire pour formater les prix
export const formatPrice = (amount: number, currency: string = 'EUR') => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency,
    minimumFractionDigits: amount % 100 === 0 ? 0 : 2
  }).format(amount / 100)
}

// Configuration pour les différents environnements
export const getStripeConfig = () => ({
  apiVersion: '2023-10-16' as const,
  publishableKey: process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || 'pk_test_...',
  webhookSecret: process.env.STRIPE_WEBHOOK_SECRET,
  successUrl: `${process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3001'}/success`,
  cancelUrl: `${process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3001'}/cancel`
})
