import { loadStripe } from '@stripe/stripe-js'
import Stripe from 'stripe'

// Configuration publique pour le client
export const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!
)

// Configuration serveur pour l'API - Version la plus récente
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2025-06-30.basil', // Version requise par les types
})

// Types pour Math4Child
export interface SubscriptionPlan {
  name: string
  price: number
  currency: string
  interval: 'month' | 'year'
  interval_count?: number
  features: string[]
}

// Configuration des plans d'abonnement Math4Kids
export const SUBSCRIPTION_PLANS: Record<string, SubscriptionPlan> = {
  monthly: {
    name: 'Math4Kids Mensuel',
    price: 999, // 9.99€ en centimes
    currency: 'eur',
    interval: 'month',
    interval_count: 1,
    features: [
      'Accès illimité à tous les niveaux',
      'Support multilingue (195+ langues)',
      'Applications Web + Mobile',
      'Statistiques de progression',
      'Support prioritaire'
    ]
  },
  quarterly: {
    name: 'Math4Kids Trimestriel',
    price: 2697, // 26.97€ en centimes (10% de réduction)
    currency: 'eur',
    interval: 'month',
    interval_count: 3,
    features: [
      'Tout du plan mensuel',
      '10% de réduction',
      'Fonctionnalités bonus',
      'Rapport de progression détaillé'
    ]
  },
  annual: {
    name: 'Math4Kids Annuel',
    price: 8392, // 83.92€ en centimes (30% de réduction)
    currency: 'eur',
    interval: 'year',
    interval_count: 1,
    features: [
      'Tout du plan mensuel',
      '30% de réduction',
      'Accès anticipé aux nouvelles fonctionnalités',
      'Support téléphonique',
      'Certification de progression'
    ]
  }
}

// Configuration business GOTEST
export const STRIPE_BUSINESS_CONFIG = {
  businessName: 'GOTEST',
  siret: '53958712100028',
  address: {
    line1: '1 ALLEE DE LA HAUTE PLACE',
    postal_code: '93160',
    city: 'NOISY-LE-GRAND',
    country: 'FR'
  },
  email: 'khalid_ksouri@yahoo.fr',
  phone: '+33123456789'
}

// Configuration Qonto
export const QONTO_BANK_CONFIG = {
  iban: 'FR7616958000016218830371501',
  bic: 'QNTOFRP1XXX',
  bankName: 'Qonto',
  accountHolder: 'KSOURI KHALID'
}

export type SubscriptionPlanKey = keyof typeof SUBSCRIPTION_PLANS
