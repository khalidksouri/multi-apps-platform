// =============================================================================
// 🔧 TYPES GLOBAUX MATH4CHILD
// =============================================================================

declare global {
  interface Window {
    // Stripe global
    Stripe?: unknown
    
    // Analytics
    gtag?: (...args: unknown[]) => void
    
    // Events personnalisés
    addEventListener(type: 'stripe-error', listener: (event: CustomEvent) => void): void
    dispatchEvent(event: CustomEvent): boolean
  }
  
  // Variables d'environnement
  namespace NodeJS {
    interface ProcessEnv {
      NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY: string
      STRIPE_SECRET_KEY: string
      STRIPE_WEBHOOK_SECRET: string
      NEXT_PUBLIC_BASE_URL: string
      NEXT_PUBLIC_APP_ENV: 'development' | 'production' | 'preview'
      NODE_ENV: 'development' | 'production' | 'test'
    }
  }
}

// Types pour Stripe
export interface StripeTestCard {
  type: string
  number: string
  description: string
  expected: 'success' | 'decline' | 'insufficient' | 'expired'
}

export interface Plan {
  id: string
  name: string
  price_monthly: string
  price_yearly: string
  features: string[]
  popular?: boolean
  monthlyPrice: number
  yearlyPrice: number
}

export interface CheckoutSessionResponse {
  sessionId: string
  url: string
}

export interface StripeError {
  error: string
  details?: string
}

export {}
