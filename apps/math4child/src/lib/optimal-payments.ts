// SYSTÈME DE PAIEMENT OPTIMAL - Math4Child

export interface CheckoutResponse {
  success: boolean
  provider: string
  checkoutUrl: string
  sessionId: string
}

export interface PaymentProvider {
  name: string
  isAvailable: boolean
  priority: number
}

export interface PaymentIntent {
  amount: number
  currency: string
  provider?: string
  metadata?: Record<string, string>
}

export interface PaymentResponse {
  provider: string
  clientSecret?: string
  checkoutUrl?: string
  amount: number
  currency: string
  success: boolean
  error?: string
}

export function getOptimalProvider(params: {
  platform: 'web' | 'ios' | 'android'
  country: string
  amount: number
}): 'paddle' | 'lemonsqueezy' | 'revenuecat' | 'stripe' {
  if (params.platform === 'ios' || params.platform === 'android') {
    return 'revenuecat'
  }
  const euCountries = ['FR', 'DE', 'IT', 'ES']
  if (euCountries.includes(params.country)) {
    return 'paddle'
  }
  return 'stripe'
}

export class OptimalPayments {
  private providers: PaymentProvider[] = [
    { name: 'stripe', isAvailable: true, priority: 1 }
  ]

  async createPaymentIntent(intent: PaymentIntent): Promise<PaymentResponse> {
    return {
      provider: 'stripe',
      checkoutUrl: 'https://stripe.com/checkout',
      amount: intent.amount,
      currency: intent.currency,
      success: true
    }
  }

  async createCheckout(planId: string, options: any): Promise<CheckoutResponse> {
    return {
      success: true,
      provider: 'stripe',
      checkoutUrl: 'https://stripe.com/checkout/' + planId,
      sessionId: 'session_' + Date.now()
    }
  }

  async handleWebhook(provider: string, payload: unknown): Promise<{ success: boolean; provider: string }> {
    console.log('Webhook received:', provider, payload)
    return { success: true, provider }
  }
}

export const optimalPayments = new OptimalPayments()
export default optimalPayments
