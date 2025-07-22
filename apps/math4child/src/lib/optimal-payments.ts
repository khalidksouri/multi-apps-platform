// =============================================================================
// SYSTÈME DE PAIEMENT OPTIMAL - Math4Child (VERSION CORRIGÉE)
// =============================================================================

export interface OptimalPlan {
  id: string
  name: string
  price: { monthly: number; annual: number }
  profiles: number
  features: string[]
  freeTrial: number
  provider: 'paddle' | 'lemonsqueezy' | 'revenuecat' | 'stripe'
}

export interface CheckoutResponse {
  success: boolean
  provider: string
  checkoutUrl: string
  sessionId: string
}

export const OPTIMAL_PLANS: OptimalPlan[] = [
  {
    id: 'family',
    name: 'Famille',
    price: { monthly: 699, annual: 5990 },
    profiles: 5,
    features: [
      'Questions illimitées', '5 niveaux complets', '5 profils enfants',
      '30+ langues', 'Mode hors-ligne', 'Statistiques avancées'
    ],
    freeTrial: 14,
    provider: 'paddle'
  }
]

export function getOptimalProvider(params: {
  platform: 'web' | 'ios' | 'android'
  country: string
  amount: number
}): 'paddle' | 'lemonsqueezy' | 'revenuecat' | 'stripe' {
  
  if (params.platform === 'ios' || params.platform === 'android') {
    return 'revenuecat'
  }
  
  const euCountries = ['FR', 'DE', 'IT', 'ES', 'NL', 'BE', 'AT', 'PT', 'IE', 'FI', 'SE', 'DK']
  if (euCountries.includes(params.country)) {
    return 'paddle'
  }
  
  return 'stripe'
}

class OptimalPaymentManagerClass {
  
  async createCheckout(planId: string, options: {
    email?: string
    country?: string
    platform?: string
    amount?: number
    currency?: string
  }): Promise<CheckoutResponse> {
    
    const provider = getOptimalProvider({
      platform: (options.platform as 'web' | 'ios' | 'android') || 'web',
      country: options.country || 'FR',
      amount: options.amount || 699
    })
    
    return {
      success: true,
      provider,
      checkoutUrl: `https://${provider}.example.com/checkout/${planId}`,
      sessionId: `${provider}_${Date.now()}`
    }
  }
  
  async handleWebhook(provider: string, payload: unknown) {
    console.log(`📨 [WEBHOOK] ${provider.toUpperCase()}:`, payload)
    return { success: true }
  }
}

export const OptimalPaymentManager = new OptimalPaymentManagerClass()
export default OptimalPaymentManager
