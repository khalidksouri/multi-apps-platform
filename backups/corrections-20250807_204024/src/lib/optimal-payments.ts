// Forced update: 1753300816
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
      '30+ langues', 'Mode hors-ligne', 'Statistiques avancées',
      'Rapports parents', 'Support prioritaire', 'Sync cloud'
    ],
    freeTrial: 14,
    provider: 'paddle'
  }
]

// Configuration providers
export const PAYMENT_CONFIG = {
  paddle: {
    environment: process.env.NODE_ENV === 'production' ? 'production' : 'sandbox',
    clientToken: process.env.PADDLE_CLIENT_TOKEN || ''
  },
  lemonsqueezy: {
    apiKey: process.env.LEMONSQUEEZY_API_KEY || '',
    storeId: process.env.LEMONSQUEEZY_STORE_ID || ''
  },
  revenuecat: {
    apiKey: process.env.REVENUECAT_API_KEY || '',
    publicKey: process.env.NEXT_PUBLIC_REVENUECAT_PUBLIC_KEY || ''
  },
  stripe: {
    publishableKey: process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || '',
    secretKey: process.env.STRIPE_SECRET_KEY || ''
  }
}

// Fonction pour déterminer le provider optimal
export function getOptimalProvider(params: {
  platform: 'web' | 'ios' | 'android'
  country: string
  amount: number
}): 'paddle' | 'lemonsqueezy' | 'revenuecat' | 'stripe' {
  
  // Mobile natif -> RevenueCat
  if (params.platform === 'ios' || params.platform === 'android') {
    return 'revenuecat'
  }
  
  // EU -> Paddle (TVA automatique)
  const euCountries = ['FR', 'DE', 'IT', 'ES', 'NL', 'BE', 'AT', 'PT', 'IE', 'FI', 'SE', 'DK']
  if (euCountries.includes(params.country)) {
    return 'paddle'
  }
  
  // International -> LemonSqueezy  
  if (!['US', 'CA', 'GB'].includes(params.country)) {
    return 'lemonsqueezy'
  }
  
  // Fallback -> Stripe
  return 'stripe'
}

// OptimalPaymentManager principal
class OptimalPaymentManagerClass {
  
  async createCheckout(planId: string, options: {
    email?: string
    country?: string
    platform?: string
    amount?: number
    currency?: string
  }): Promise<CheckoutResponse> {
    const provider = getOptimalProvider({
      platform: options.platform as any || 'web',
      country: options.country || 'FR',
      amount: options.amount || 699
    })
    
    console.log(`🎯 [OPTIMAL] Provider sélectionné: ${provider}`)
    
    // Retourner un objet conforme à CheckoutResponse
    return {
      success: true,
      provider,
      checkoutUrl: `https://${provider}.example.com/checkout/${planId}`,
      sessionId: `${provider}_${Date.now()}`
    }
  }
  
  async handleWebhook(provider: string, payload: any) {
    console.log(`📨 [WEBHOOK] ${provider.toUpperCase()}:`, payload)
    
    // Logique webhook selon le provider
    if (provider === 'paddle') {
      // Traitement webhook Paddle
    } else if (provider === 'lemonsqueezy') {
      // Traitement webhook LemonSqueezy  
    } else if (provider === 'stripe') {
      // Traitement webhook Stripe
    }
    
    return { success: true }
  }
}

export const OptimalPaymentManager = new OptimalPaymentManagerClass()
export default OptimalPaymentManager
