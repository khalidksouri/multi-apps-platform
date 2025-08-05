import { loadStripe } from '@stripe/stripe-js'
import Stripe from 'stripe'

// Configuration publique pour le client
export const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!
)

// Configuration serveur pour l'API
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-06-20',
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

// Configuration des plans d'abonnement Math4Child - GOTEST
export const SUBSCRIPTION_PLANS: Record<string, SubscriptionPlan> = {
  free: {
    name: 'Math4Child Explorer',
    price: 0, // Gratuit
    currency: 'eur',
    interval: 'month',
    features: [
      '50 questions totales',
      'Niveau 1 seulement',
      '1 profil enfant',
      'Support communautaire'
    ]
  },
  monthly: {
    name: 'Math4Child Aventurier',
    price: 999, // 9.99€ en centimes
    currency: 'eur',
    interval: 'month',
    features: [
      'Questions illimitées',
      'Tous les 5 niveaux',
      '3 profils enfants',
      'IA adaptative',
      'Support prioritaire'
    ]
  },
  quarterly: {
    name: 'Math4Child Champion',
    price: 2697, // 26.97€ en centimes (10% de réduction)
    currency: 'eur',
    interval: 'month',
    interval_count: 3,
    features: [
      'Tout du plan Aventurier',
      '10% de réduction',
      '5 profils enfants',
      'Mode multijoueur',
      'Défis exclusifs',
      'Statistiques avancées'
    ]
  },
  annual: {
    name: 'Math4Child Maître',
    price: 8393, // 83.93€ en centimes (30% de réduction)
    currency: 'eur',
    interval: 'year',
    features: [
      'Tout du plan Champion',
      '30% de réduction',
      '10 profils enfants',
      'Accès anticipé aux nouvelles fonctionnalités',
      'Mode tournoi',
      'Support téléphonique',
      'Certificats de progression'
    ]
  }
}

// Configuration business GOTEST
export const STRIPE_BUSINESS_CONFIG = {
  businessName: 'GOTEST',
  siret: '53958712100028',
  address: {
    line1: 'Adresse GOTEST',
    postal_code: '75000',
    city: 'Paris',
    country: 'FR'
  },
  email: 'gotesttech@gmail.com',
  phone: '+33123456789',
  website: 'https://www.math4child.com'
}

export type SubscriptionPlanKey = keyof typeof SUBSCRIPTION_PLANS
