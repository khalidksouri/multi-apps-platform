import { NextRequest, NextResponse } from 'next/server'

// Interface simple sans import externe
interface CheckoutResponse {
  success: boolean
  provider: string
  checkoutUrl: string
  sessionId: string
}

// Classe de paiement simple intégrée
class SimplePayments {
  async createCheckout(planId: string, options: any): Promise<CheckoutResponse> {
    return {
      success: true,
      provider: 'stripe',
      checkoutUrl: `https://stripe.com/checkout/${planId}`,
      sessionId: `session_${Date.now()}`
    }
  }

  async handleWebhook(provider: string, payload: unknown): Promise<{ success: boolean; provider: string }> {
    console.log('Webhook received:', provider, payload)
    return { success: true, provider }
  }
}

const payments = new SimplePayments()

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { amount, currency = 'EUR', planId, country, platform, email } = body

    if (!amount || amount <= 0) {
      return NextResponse.json({ error: 'Invalid amount', success: false }, { status: 400 })
    }

    if (planId) {
      const checkout = await payments.createCheckout(planId, { email, country, platform, amount, currency })
      return NextResponse.json(checkout)
    }

    return NextResponse.json({
      provider: 'stripe',
      checkoutUrl: 'https://stripe.com/checkout',
      amount,
      currency,
      success: true
    })
  } catch (error) {
    console.error('Payment creation error:', error)
    return NextResponse.json({ error: 'Internal server error', success: false }, { status: 500 })
  }
}

export async function GET() {
  return NextResponse.json({ 
    message: 'Math4Child Payment API - Working!', 
    success: true,
    timestamp: new Date().toISOString()
  })
}
