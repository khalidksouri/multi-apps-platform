/**
 * Types pour le système de paiement Math4Child - Version corrigée
 */

export interface PricingPlan {
  id: string
  name: string
  description: string
  price: number
  originalPrice?: number
  currency: string
  interval: 'month' | 'quarter' | 'year'
  intervalCount: number
  features: string[]
  maxProfiles: number
  popular?: boolean
  recommended?: boolean
  badge?: string
  savings?: string
  stripeProductId?: string
  stripePriceId?: string
}

export interface BillingInfo {
  email: string
  name: string
  address: {
    line1: string
    line2?: string
    city: string
    state?: string
    postalCode: string
    country: string
  }
  taxId?: string
}

export interface UserProfile {
  id: string
  name: string
  age: number
  level: 'beginner' | 'intermediate' | 'advanced' | 'expert' | 'master'
  avatar?: string
  progress: {
    totalGames: number
    totalScore: number
    currentStreak: number
    bestStreak: number
    totalTime: number
  }
}

export interface Subscription {
  id: string
  userId: string
  planId: string
  status: 'active' | 'canceled' | 'past_due' | 'incomplete' | 'trialing'
  currentPeriodStart: Date
  currentPeriodEnd: Date
  cancelAtPeriodEnd: boolean
  trialEnd?: Date
  stripeSubscriptionId?: string
}

export interface PaymentMethod {
  id: string
  type: 'card' | 'paypal' | 'sepa'
  last4?: string
  brand?: string
  expiryMonth?: number
  expiryYear?: number
  default: boolean
}

export interface CheckoutSession {
  sessionId: string
  planId: string
  amount: number
  currency: string
  status: 'pending' | 'completed' | 'failed'
  createdAt: Date
}
