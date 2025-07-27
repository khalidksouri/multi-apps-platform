/**
 * 💰 Système de Paiements Optimal Hybride - Math4Child
 * Sélection automatique selon plateforme avec fallbacks sécurisés
 */

interface PaymentProvider {
  name: 'stripe' | 'paddle' | 'lemonsqueezy' | 'revenuecat'
  priority: number
  supportedPlatforms: ('web' | 'ios' | 'android')[]
  fees: {
    percentage: number
    fixed: number
    currency: string
  }
  features: string[]
}

const HYBRID_PAYMENT_PROVIDERS: PaymentProvider[] = [
  {
    name: 'revenuecat',
    priority: 1,
    supportedPlatforms: ['ios', 'android'],
    fees: { percentage: 0.01, fixed: 0, currency: 'USD' },
    features: ['in_app_purchases', 'subscription_analytics', 'cross_platform']
  },
  {
    name: 'paddle',
    priority: 2,
    supportedPlatforms: ['web'],
    fees: { percentage: 0.05, fixed: 0, currency: 'EUR' },
    features: ['tax_handling', 'global_compliance', 'subscription_management']
  },
  {
    name: 'stripe',
    priority: 3,
    supportedPlatforms: ['web'],
    fees: { percentage: 0.029, fixed: 0.30, currency: 'USD' },
    features: ['advanced_fraud', 'recurring_billing']
  },
  {
    name: 'lemonsqueezy',
    priority: 4,
    supportedPlatforms: ['web'],
    fees: { percentage: 0.05, fixed: 0, currency: 'USD' },
    features: ['simple_integration', 'global_reach']
  }
]

interface CheckoutOptions {
  platform?: 'web' | 'ios' | 'android'
  amount: number
  currency?: string
  planId: string
  userId?: string
}

interface CheckoutSession {
  id: string
  provider: string
  checkoutUrl: string
  amount: number
  currency: string
  platform: string
  isNative: boolean
}

class HybridPaymentManager {
  
  /**
   * Sélectionne le provider optimal selon la plateforme
   */
  getOptimalProvider(options: CheckoutOptions): PaymentProvider {
    const platform = options.platform || this.detectPlatform()
    
    // Filtrer selon la plateforme
    const availableProviders = HYBRID_PAYMENT_PROVIDERS.filter(provider => 
      provider.supportedPlatforms.includes(platform)
    )
    
    // Retourner le provider avec la plus haute priorité ou fallback
    return availableProviders.sort((a, b) => a.priority - b.priority)[0] || HYBRID_PAYMENT_PROVIDERS[3]
  }
  
  /**
   * Crée une session de checkout hybride avec gestion d'erreur
   */
  async createCheckout(options: CheckoutOptions): Promise<CheckoutSession> {
    try {
      const provider = this.getOptimalProvider(options)
      const platform = options.platform || this.detectPlatform()
      
      console.log(`🎯 [HYBRIDE] Provider: ${provider.name} pour ${platform}`)
      
      const session: CheckoutSession = {
        id: this.generateCheckoutId(),
        provider: provider.name,
        checkoutUrl: this.generateCheckoutUrl(provider.name, options.planId, platform),
        amount: options.amount,
        currency: options.currency || 'EUR',
        platform,
        isNative: platform !== 'web'
      }
      
      return session
    } catch (error) {
      console.warn('Erreur création checkout:', error)
      // Retourner session par défaut en cas d'erreur
      return {
        id: 'fallback-' + Date.now(),
        provider: 'paddle',
        checkoutUrl: '#',
        amount: options.amount,
        currency: options.currency || 'EUR',
        platform: 'web',
        isNative: false
      }
    }
  }
  
  /**
   * Détecte automatiquement la plateforme avec fallback
   */
  detectPlatform(): 'web' | 'ios' | 'android' {
    if (typeof window === 'undefined') return 'web'
    
    try {
      // Vérifier Capacitor
      const capacitor = (window as any).Capacitor
      if (capacitor && capacitor.getPlatform) {
        return capacitor.getPlatform()
      }
      
      // Fallback user agent
      const ua = navigator.userAgent
      if (ua.includes('Android')) return 'android'
      if (ua.includes('iPhone') || ua.includes('iPad')) return 'ios'
      
      return 'web'
    } catch (error) {
      console.warn('Erreur détection plateforme:', error)
      return 'web'
    }
  }
  
  /**
   * Checkout automatique selon plateforme détectée
   */
  async createAutoCheckout(planId: string, amount: number, userId?: string): Promise<CheckoutSession> {
    const platform = this.detectPlatform()
    
    return this.createCheckout({
      platform,
      planId,
      amount,
      userId
    })
  }
  
  private generateCheckoutId(): string {
    return `hybrid_${Date.now()}_${Math.random().toString(36).substring(2, 15)}`
  }
  
  private generateCheckoutUrl(provider: string, planId: string, platform: string): string {
    const baseUrls: Record<string, string> = {
      paddle: 'https://checkout.paddle.com',
      stripe: 'https://checkout.stripe.com',
      lemonsqueezy: 'https://checkout.lemonsqueezy.com',
      revenuecat: `capacitor://localhost/checkout/${planId}`
    }
    
    const baseUrl = baseUrls[provider] || baseUrls.paddle
    
    if (provider === 'revenuecat') {
      return baseUrl
    }
    
    return `${baseUrl}/checkout/${planId}?platform=${platform}`
  }
  
  /**
   * Analytics des providers par plateforme
   */
  getHybridAnalytics() {
    return {
      web: HYBRID_PAYMENT_PROVIDERS.filter(p => p.supportedPlatforms.includes('web')),
      ios: HYBRID_PAYMENT_PROVIDERS.filter(p => p.supportedPlatforms.includes('ios')),
      android: HYBRID_PAYMENT_PROVIDERS.filter(p => p.supportedPlatforms.includes('android')),
      recommendations: {
        web: 'paddle',
        ios: 'revenuecat',
        android: 'revenuecat'
      }
    }
  }
}

// Instance singleton
export const optimalPayments = new HybridPaymentManager()

// Export par défaut
export default optimalPayments

// Exports utilitaires
export type { PaymentProvider, CheckoutOptions, CheckoutSession }
