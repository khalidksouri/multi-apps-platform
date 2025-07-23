// =============================================================================
// 💳 TYPES STRIPE MATH4CHILD
// =============================================================================

import { Stripe } from '@stripe/stripe-js'

declare module '@stripe/stripe-js' {
  interface StripeConstructorOptions {
    apiVersion?: string
    stripeAccount?: string
  }
}

// Types pour les APIs Stripe
export interface CreateCheckoutSessionRequest {
  priceId: string
  mode?: 'payment' | 'subscription'
  customerEmail?: string
  metadata?: Record<string, string>
}

export interface CreateCheckoutSessionResponse {
  sessionId: string
  url: string | null
  error?: string
  details?: string
}

export interface SubscriptionStatusResponse {
  subscriptions: unknown[]
  hasActiveSubscription: boolean
  error?: string
}

export interface WebhookEvent {
  id: string
  object: 'event'
  type: string
  data: {
    object: unknown
  }
}

export {}
