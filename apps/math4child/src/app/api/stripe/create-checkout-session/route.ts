import { NextRequest, NextResponse } from 'next/server'

const TEST_PRICES = {
  'price_test_family_monthly': { amount: 699, currency: 'eur', interval: 'month' },
  'price_test_family_yearly': { amount: 5990, currency: 'eur', interval: 'year' },
  'price_test_premium_monthly': { amount: 499, currency: 'eur', interval: 'month' },
  'price_test_premium_yearly': { amount: 3990, currency: 'eur', interval: 'year' },
  'price_test_school_monthly': { amount: 2499, currency: 'eur', interval: 'month' },
  'price_test_school_yearly': { amount: 19990, currency: 'eur', interval: 'year' }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { priceId, mode = 'subscription', testCard } = body

    // console.log('🧪 Test Stripe Checkout:', { priceId, mode, testCard })

    if (!TEST_PRICES[priceId as keyof typeof TEST_PRICES]) {
      return NextResponse.json({ error: 'Prix non valide pour les tests' }, { status: 400 })
    }

    // En mode développement, simuler une session Stripe
    if (process.env.NODE_ENV === 'development') {
      const mockSession = {
        id: `cs_test_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        url: `http://localhost:3000/success?session_id=cs_test_mock_${testCard || 'success'}`,
        object: 'checkout.session',
        payment_status: testCard === 'success' ? 'paid' : 'unpaid'
      }

      return NextResponse.json({
        sessionId: mockSession.id,
        url: mockSession.url,
        testMode: true,
        testCard: testCard
      })
    }

    // Code Stripe réel pour production (nécessite STRIPE_SECRET_KEY)
    return NextResponse.json({ error: 'Configuration Stripe requise pour la production' }, { status: 500 })

  } catch (error) {
    console.error('❌ Erreur Stripe checkout:', error)
    return NextResponse.json({ 
      error: 'Erreur lors de la création de la session de paiement',
      details: error instanceof Error ? error.message : 'Erreur inconnue'
    }, { status: 500 })
  }
}

export async function GET() {
  return NextResponse.json({
    status: 'OK',
    message: 'API Stripe Checkout opérationnelle',
    environment: process.env.NODE_ENV,
    testMode: process.env.NODE_ENV === 'development',
    availablePrices: Object.keys(TEST_PRICES),
    timestamp: new Date().toISOString()
  })
}
