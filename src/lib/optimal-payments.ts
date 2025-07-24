/**
 * 💰 Système de Paiements Optimal - Math4Child
 * Sélection automatique du meilleur provider selon le contexte
 */

interface PaymentProvider {
  name: 'stripe' | 'paddle' | 'lemonsqueezy' | 'revenuecat'
  priority: number
  supportedCountries: string[]
  supportedPlatforms: ('web' | 'ios' | 'android')[]
  fees: {
    percentage: number
    fixed: number
    currency: string
  }
  features: string[]
}

const PAYMENT_PROVIDERS: PaymentProvider[] = [
  {
    name: 'paddle',
    priority: 1,
    supportedCountries: ['FR', 'DE', 'IT', 'ES', 'GB', 'NL', 'BE', 'AT'],
    supportedPlatforms: ['web', 'ios', 'android'],
    fees: { percentage: 0.05, fixed: 0, currency: 'EUR' },
    features: ['tax_handling', 'global_compliance', 'subscription_management']
  },
  {
    name: 'revenuecat',
    priority: 2,
    supportedCountries: ['*'], // Global
    supportedPlatforms: ['ios', 'android'],
    fees: { percentage: 0.01, fixed: 0, currency: 'USD' },
    features: ['in_app_purchases', 'subscription_analytics', 'cross_platform']
  },
  {
    name: 'stripe',
    priority: 3,
    supportedCountries: ['US', 'CA', 'AU', 'JP', 'KR', 'SG', 'HK'],
    supportedPlatforms: ['web'],
    fees: { percentage: 0.029, fixed: 0.30, currency: 'USD' },
    features: ['advanced_fraud', 'recurring_billing', 'marketplace']
  },
  {
    name: 'lemonsqueezy',
    priority: 4,
    supportedCountries: ['*'], // Global fallback
    supportedPlatforms: ['web'],
    fees: { percentage: 0.05, fixed: 0, currency: 'USD' },
    features: ['simple_integration', 'tax_inclusive', 'global_reach']
  }
]

interface CheckoutOptions {
  email?: string
  country?: string
  platform?: 'web' | 'ios' | 'android'
  amount: number
  currency?: string
  planId: string
  userId?: string
  metadata?: Record<string, any>
}

interface CheckoutSession {
  id: string
  provider: string
  checkoutUrl: string
  amount: number
  currency: string
  country: string
  platform: string
  expiresAt: Date
  metadata: Record<string, any>
}

class OptimalPaymentManager {
  
  /**
   * Sélectionne le provider optimal selon les critères
   */
  getOptimalProvider(options: CheckoutOptions): PaymentProvider {
    const { country = 'FR', platform = 'web', amount = 699 } = options
    
    // Filtrer les providers selon les critères
    const availableProviders = PAYMENT_PROVIDERS.filter(provider => {
      const countrySupported = provider.supportedCountries.includes(country) || 
                              provider.supportedCountries.includes('*')
      const platformSupported = provider.supportedPlatforms.includes(platform)
      
      return countrySupported && platformSupported
    })
    
    // Si mobile iOS/Android, privilégier RevenueCat
    if (platform !== 'web') {
      const revenueCat = availableProviders.find(p => p.name === 'revenuecat')
      if (revenueCat) return revenueCat
    }
    
    // Sinon, retourner le provider avec la plus haute priorité
    return availableProviders.sort((a, b) => a.priority - b.priority)[0] || PAYMENT_PROVIDERS[3]
  }
  
  /**
   * Calcule les frais pour un montant donné
   */
  calculateFees(provider: PaymentProvider, amount: number): number {
    return (amount * provider.fees.percentage) + provider.fees.fixed
  }
  
  /**
   * Crée une session de checkout optimale
   */
  async createCheckout(options: CheckoutOptions): Promise<CheckoutSession> {
    const provider = this.getOptimalProvider(options)
    const fees = this.calculateFees(provider, options.amount)
    
    console.log(`🎯 [OPTIMAL] Provider sélectionné: ${provider.name}`)
    console.log(`💰 [OPTIMAL] Frais calculés: ${fees}€`)
    
    // Simulation - En production, remplacer par vraies API calls
    const session: CheckoutSession = {
      id: this.generateCheckoutId(),
      provider: provider.name,
      checkoutUrl: this.generateCheckoutUrl(provider.name, options.planId),
      amount: options.amount,
      currency: options.currency || 'EUR',
      country: options.country || 'FR',
      platform: options.platform || 'web',
      expiresAt: new Date(Date.now() + 30 * 60 * 1000), // 30 minutes
      metadata: {
        userId: options.userId,
        fees,
        selectedFeatures: provider.features,
        ...options.metadata
      }
    }
    
    return session
  }
  
  /**
   * Gère les webhooks des différents providers
   */
  async handleWebhook(provider: string, payload: any): Promise<{ success: boolean; data?: any }> {
    console.log(`📨 [WEBHOOK] ${provider.toUpperCase()}:`, payload)
    
    try {
      switch (provider) {
        case 'paddle':
          return await this.handlePaddleWebhook(payload)
        case 'stripe':
          return await this.handleStripeWebhook(payload)
        case 'lemonsqueezy':
          return await this.handleLemonSqueezyWebhook(payload)
        case 'revenuecat':
          return await this.handleRevenueCatWebhook(payload)
        default:
          throw new Error(`Provider non supporté: ${provider}`)
      }
    } catch (error) {
      console.error(`❌ [WEBHOOK] Erreur ${provider}:`, error)
      return { success: false }
    }
  }
  
  private async handlePaddleWebhook(payload: any) {
    // Logique webhook Paddle
    return { success: true, provider: 'paddle', data: payload }
  }
  
  private async handleStripeWebhook(payload: any) {
    // Logique webhook Stripe
    return { success: true, provider: 'stripe', data: payload }
  }
  
  private async handleLemonSqueezyWebhook(payload: any) {
    // Logique webhook LemonSqueezy
    return { success: true, provider: 'lemonsqueezy', data: payload }
  }
  
  private async handleRevenueCatWebhook(payload: any) {
    // Logique webhook RevenueCat
    return { success: true, provider: 'revenuecat', data: payload }
  }
  
  private generateCheckoutId(): string {
    return `checkout_${Date.now()}_${Math.random().toString(36).substring(2, 15)}`
  }
  
  private generateCheckoutUrl(provider: string, planId: string): string {
    const baseUrls = {
      paddle: 'https://checkout.paddle.com',
      stripe: 'https://checkout.stripe.com',
      lemonsqueezy: 'https://checkout.lemonsqueezy.com',
      revenuecat: 'https://api.revenuecat.com'
    }
    
    return `${baseUrls[provider as keyof typeof baseUrls]}/checkout/${planId}`
  }
  
  /**
   * Analyse des performances des providers
   */
  getProviderAnalytics() {
    return {
      providers: PAYMENT_PROVIDERS.map(p => ({
        name: p.name,
        priority: p.priority,
        countries: p.supportedCountries.length,
        platforms: p.supportedPlatforms.length,
        avgFees: p.fees.percentage * 100 + '%'
      })),
      recommendations: {
        web_europe: 'paddle',
        mobile_global: 'revenuecat',
        web_usa: 'stripe',
        fallback: 'lemonsqueezy'
      }
    }
  }
}

// Instance singleton
export const optimalPayments = new OptimalPaymentManager()
export default optimalPayments

// Types export
export type { PaymentProvider, CheckoutOptions, CheckoutSession }
