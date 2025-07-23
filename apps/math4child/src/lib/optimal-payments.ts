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
  productId?: string
  amount: number
  currency: string
  success: boolean
  error?: string
}

export class OptimalPayments {
  private providers: PaymentProvider[] = [
    { name: 'stripe', isAvailable: true, priority: 1 },
    { name: 'paddle', isAvailable: true, priority: 2 },
    { name: 'lemonsqueezy', isAvailable: true, priority: 3 },
    { name: 'revenuecat', isAvailable: false, priority: 4 },
  ]

  getOptimalProvider(): PaymentProvider {
    return this.providers
      .filter(p => p.isAvailable)
      .sort((a, b) => a.priority - b.priority)[0] || this.providers[0]
  }

  async createPaymentIntent(intent: PaymentIntent): Promise<PaymentResponse> {
    try {
      const provider = intent.provider ? 
        this.providers.find(p => p.name === intent.provider) || this.getOptimalProvider() :
        this.getOptimalProvider()
      
      switch (provider.name) {
        case 'stripe':
          return await this.createStripePayment(intent)
        case 'paddle':
          return await this.createPaddlePayment(intent)
        case 'lemonsqueezy':
          return await this.createLemonSqueezyPayment(intent)
        case 'revenuecat':
          return await this.createRevenueCatPayment(intent)
        default:
          throw new Error('No payment provider available')
      }
    } catch (error) {
      return {
        provider: 'error',
        amount: intent.amount,
        currency: intent.currency,
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error'
      }
    }
  }

  private async createStripePayment(intent: PaymentIntent): Promise<PaymentResponse> {
    return {
      provider: 'stripe',
      clientSecret: 'pi_test_' + Math.random().toString(36).substr(2, 9),
      amount: intent.amount,
      currency: intent.currency,
      success: true,
    }
  }

  private async createPaddlePayment(intent: PaymentIntent): Promise<PaymentResponse> {
    return {
      provider: 'paddle',
      checkoutUrl: `https://checkout.paddle.com/test/${Math.random().toString(36).substr(2, 9)}`,
      amount: intent.amount,
      currency: intent.currency,
      success: true,
    }
  }

  private async createLemonSqueezyPayment(intent: PaymentIntent): Promise<PaymentResponse> {
    return {
      provider: 'lemonsqueezy',
      checkoutUrl: `https://checkout.lemonsqueezy.com/test/${Math.random().toString(36).substr(2, 9)}`,
      amount: intent.amount,
      currency: intent.currency,
      success: true,
    }
  }

  private async createRevenueCatPayment(intent: PaymentIntent): Promise<PaymentResponse> {
    return {
      provider: 'revenuecat',
      productId: 'math4child_premium',
      amount: intent.amount,
      currency: intent.currency,
      success: true,
    }
  }
}

export const optimalPayments = new OptimalPayments()
export default optimalPayments
