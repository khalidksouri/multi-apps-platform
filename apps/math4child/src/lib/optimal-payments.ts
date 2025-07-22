// =============================================================================
// CONFIGURATION STACK OPTIMAL MULTI-PROVIDER (CORRIGÉ)
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

export const OPTIMAL_PLANS: OptimalPlan[] = [
  {
    id: 'free',
    name: 'Gratuit',
    price: { monthly: 0, annual: 0 },
    profiles: 1,
    features: ['100 questions/mois', '2 niveaux', '5 langues', 'Support communautaire'],
    freeTrial: 0,
    provider: 'paddle'
  },
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
  },
  {
    id: 'premium',
    name: 'Premium',
    price: { monthly: 499, annual: 3990 },
    profiles: 2,
    features: [
      'Questions illimitées', '5 niveaux', '2 profils',
      '30+ langues', 'Mode hors-ligne', 'Statistiques'
    ],
    freeTrial: 7,
    provider: 'paddle'
  },
  {
    id: 'school',
    name: 'École',
    price: { monthly: 2499, annual: 19990 },
    profiles: 30,
    features: [
      'Tout plan Famille', '30 profils élèves', 'Tableau enseignant',
      'Devoirs', 'Rapports classe', 'API LMS', 'Support téléphone'
    ],
    freeTrial: 30,
    provider: 'paddle'
  }
]

// Configuration providers
export const PAYMENT_CONFIG = {
  paddle: {
    environment: process.env.NODE_ENV === 'production' ? 'production' : 'sandbox',
    token: process.env.PADDLE_CLIENT_TOKEN || 'test_token'
  },
  lemonsqueezy: {
    apiKey: process.env.LEMONSQUEEZY_API_KEY || 'test_key',
    storeId: process.env.LEMONSQUEEZY_STORE_ID || 'test_store'
  },
  revenuecat: {
    apiKey: process.env.REVENUECAT_API_KEY || 'test_key',
    publicKey: process.env.REVENUECAT_PUBLIC_KEY || 'test_public'
  },
  stripe: {
    publicKey: process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || 'test_pk',
    secretKey: process.env.STRIPE_SECRET_KEY || 'test_sk'
  }
}

// Smart routing optimal provider
export function getOptimalProvider(context: {
  platform: 'web' | 'ios' | 'android'
  country: string
  amount: number
}): 'paddle' | 'lemonsqueezy' | 'revenuecat' | 'stripe' {
  
  // Mobile: Toujours RevenueCat
  if (context.platform === 'ios' || context.platform === 'android') {
    return 'revenuecat'
  }
  
  // Web Europe: Paddle (gestion TVA automatique)
  const euCountries = ['FR', 'DE', 'ES', 'IT', 'NL', 'BE', 'AT', 'PT', 'SE', 'DK', 'FI']
  if (euCountries.includes(context.country)) {
    return 'paddle'
  }
  
  // Web Amérique du Nord: LemonSqueezy
  if (['US', 'CA'].includes(context.country)) {
    return 'lemonsqueezy'
  }
  
  // Fallback: Stripe pour couverture mondiale
  return 'stripe'
}

// Gestionnaire de paiement unifié (CORRIGÉ)
export class OptimalPaymentManager {
  
  static async createCheckout(planId: string, context: Record<string, unknown>) {
    const plan = OPTIMAL_PLANS.find(p => p.id === planId)
    if (!plan) throw new Error('Plan introuvable')
    
    const provider = getOptimalProvider({
      platform: (context.platform as 'web' | 'ios' | 'android') || 'web',
      country: (context.country as string) || 'FR',
      amount: (context.amount as number) || 699
    })
    
    switch (provider) {
      case 'paddle':
        return await this.createPaddleCheckout(plan, context)
      case 'lemonsqueezy':
        return await this.createLemonSqueezyCheckout(plan, context)
      case 'revenuecat':
        return await this.createRevenueCatPurchase(plan, context)
      case 'stripe':
        return await this.createStripeCheckout(plan, context)
      default:
        throw new Error('Provider non supporté')
    }
  }
  
  private static async createPaddleCheckout(plan: OptimalPlan, context: Record<string, unknown>) {
    // Implémentation Paddle
    const checkoutData = {
      items: [{
        priceId: `price_${plan.id}_monthly`,
        quantity: 1
      }],
      customData: {
        planId: plan.id,
        profiles: plan.profiles,
        freeTrial: plan.freeTrial,
        app: 'Math4Child'
      },
      customer: {
        email: context.email
      },
      settings: {
        allowLogout: false,
        displayMode: 'overlay',
        theme: 'light'
      }
    }
    
    console.log('Paddle checkout data:', checkoutData)
    
    return {
      success: true,
      provider: 'paddle',
      checkoutUrl: 'https://checkout.paddle.com/...',
      sessionId: 'paddle_session_123'
    }
  }
  
  private static async createLemonSqueezyCheckout(plan: OptimalPlan, context: Record<string, unknown>) {
    // Implémentation LemonSqueezy
    console.log('LemonSqueezy checkout for plan:', plan.id, context)
    
    return {
      success: true,
      provider: 'lemonsqueezy',
      checkoutUrl: 'https://checkout.lemonsqueezy.com/...',
      sessionId: 'ls_session_123'
    }
  }
  
  private static async createRevenueCatPurchase(plan: OptimalPlan, context: Record<string, unknown>) {
    // Implémentation RevenueCat mobile
    console.log('RevenueCat purchase for plan:', plan.id, context)
    
    return {
      success: true,
      provider: 'revenuecat',
      packageId: `rc_${plan.id}_monthly`,
      offering: 'default'
    }
  }
  
  private static async createStripeCheckout(plan: OptimalPlan, context: Record<string, unknown>) {
    // Fallback Stripe
    console.log('Stripe checkout for plan:', plan.id, context)
    
    return {
      success: true,
      provider: 'stripe',
      checkoutUrl: 'https://checkout.stripe.com/...',
      sessionId: 'stripe_session_123'
    }
  }
  
  static async handleWebhook(provider: string, payload: Record<string, unknown>) {
    console.log(`📧 [OPTIMAL] Webhook ${provider}:`, payload)
    
    switch (provider) {
      case 'paddle':
        return await this.handlePaddleWebhook(payload)
      case 'lemonsqueezy':
        return await this.handleLemonSqueezyWebhook(payload)
      case 'stripe':
        return await this.handleStripeWebhook(payload)
      default:
        console.log('Webhook non géré:', provider)
    }
  }
  
  private static async handlePaddleWebhook(payload: Record<string, unknown>) {
    // Gestion webhooks Paddle
    if (payload.event_type === 'subscription.created') {
      console.log('🎉 [PADDLE] Nouvel abonnement:', payload.data)
    }
  }
  
  private static async handleLemonSqueezyWebhook(payload: Record<string, unknown>) {
    // Gestion webhooks LemonSqueezy
    if (payload.meta && (payload.meta as Record<string, unknown>).event_name === 'subscription_created') {
      console.log('🎉 [LEMONSQUEEZY] Nouvel abonnement:', payload.data)
    }
  }
  
  private static async handleStripeWebhook(payload: Record<string, unknown>) {
    // Gestion webhooks Stripe
    if (payload.type === 'checkout.session.completed') {
      console.log('🎉 [STRIPE] Paiement réussi:', payload.data)
    }
  }
}

export default OptimalPaymentManager
