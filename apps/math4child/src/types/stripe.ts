// =============================================================================
// 💳 TYPES STRIPE MATH4CHILD v4.2.0
// =============================================================================

export interface StripeConfig {
  publishableKey: string
  secretKey: string
  webhookSecret: string
  apiVersion: string
}

export interface Math4ChildPlan {
  id: string
  name: string
  description: string
  price: number // en centimes (ex: 499 = 4,99€)
  currency: string
  interval: 'month' | 'year'
  features: string[]
  profiles: number
  popular?: boolean
  badge?: string
  stripePriceId?: string
  discount?: {
    percentage: number
    validUntil?: Date
  }
}

export interface CheckoutSessionRequest {
  planId: string
  email?: string
  successUrl?: string
  cancelUrl?: string
  metadata?: Record<string, string>
  couponCode?: string
  trialDays?: number
}

export interface CheckoutSessionResponse {
  success: boolean
  sessionId?: string
  url?: string
  error?: string
  demoMode?: boolean
}

export interface WebhookEvent {
  id: string
  type: string
  data: {
    object: any
  }
  created: number
  livemode: boolean
}

export interface SubscriptionStatus {
  id: string
  status: 'active' | 'canceled' | 'incomplete' | 'past_due' | 'trialing' | 'unpaid'
  currentPeriodStart: number
  currentPeriodEnd: number
  planId: string
  customerId: string
  cancelAtPeriodEnd: boolean
}

export interface Customer {
  id: string
  email: string
  name?: string
  created: number
  subscriptions: SubscriptionStatus[]
}

// Types pour les cartes de test
export interface StripeTestCard {
  type: string
  number: string
  cvc: string
  exp_month: string
  exp_year: string
  description: string
  expected: 'success' | 'decline' | 'insufficient' | 'expired'
}

export const STRIPE_TEST_CARDS: StripeTestCard[] = [
  {
    type: 'success',
    number: '4242424242424242',
    cvc: '123',
    exp_month: '12',
    exp_year: '34',
    description: 'Visa - Paiement réussi',
    expected: 'success'
  },
  {
    type: 'decline',
    number: '4000000000000002',
    cvc: '123',
    exp_month: '12',
    exp_year: '34',
    description: 'Visa - Carte déclinée',
    expected: 'decline'
  },
  {
    type: 'insufficient',
    number: '4000000000009995',
    cvc: '123',
    exp_month: '12',
    exp_year: '34',
    description: 'Visa - Fonds insuffisants',
    expected: 'insufficient'
  }
]
