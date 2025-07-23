import { NextRequest, NextResponse } from 'next/server'
import { optimalPayments } from '@/lib/optimal-payments'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { amount, currency = 'EUR', provider, metadata } = body

    // Validation
    if (!amount || amount <= 0) {
      return NextResponse.json(
        { error: 'Invalid amount', success: false },
        { status: 400 }
      )
    }

    // Créer l'intention de paiement
    const paymentResponse = await optimalPayments.createPaymentIntent({
      amount,
      currency,
      provider,
      metadata,
    })

    if (!paymentResponse.success) {
      return NextResponse.json(
        { error: paymentResponse.error || 'Payment creation failed', success: false },
        { status: 500 }
      )
    }

    return NextResponse.json(paymentResponse)
    
  } catch (error) {
    console.error('Payment creation error:', error)
    return NextResponse.json(
      { 
        error: 'Internal server error', 
        success: false,
        message: error instanceof Error ? error.message : 'Unknown error'
      },
      { status: 500 }
    )
  }
}

// Méthode GET pour les tests
export async function GET() {
  return NextResponse.json({
    message: 'Payment endpoint is working',
    providers: ['stripe', 'paddle', 'lemonsqueezy', 'revenuecat'],
    success: true
  })
}
