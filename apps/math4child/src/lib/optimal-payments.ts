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

export class OptimalPayments {
  private providers: PaymentProvider[] = [
    { name: 'stripe', isAvailable: true, priority: 1 },
    { name: 'paddle', isAvailable: true, priority: 2 },
    { name: 'lemonsqueezy', isAvailable: true, priority: 3 }
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
      
      return {
        provider: provider.name,
        checkoutUrl: `https://checkout.${provider.name}.com/test`,
        amount: intent.amount,
        currency: intent.currency,
        success: true,
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

  async handleWebhook(provider: string, payload: unknown) {
    console.log(`Webhook ${provider}:`, payload)
    return { success: true, provider }
  }
}

export const optimalPayments = new OptimalPayments()
export default optimalPayments
