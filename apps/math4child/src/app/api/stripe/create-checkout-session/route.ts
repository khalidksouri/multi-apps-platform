import { NextRequest, NextResponse } from 'next/server'
import { SUBSCRIPTION_PLANS, createStripeMetadata, BUSINESS_INFO, getStripeConfig } from '@/lib/stripe'

// Configuration des prix de test (compatible avec l'existant)
const TEST_PRICES: Record<string, { amount: number; currency: string; interval: string }> = {
  'price_test_premium_monthly': { amount: 999, currency: 'eur', interval: 'month' },
  'price_test_premium_yearly': { amount: 9999, currency: 'eur', interval: 'year' },
  'price_test_family_monthly': { amount: 1999, currency: 'eur', interval: 'month' },
  'price_test_family_yearly': { amount: 19999, currency: 'eur', interval: 'year' }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { 
      plan, 
      priceId, 
      customerEmail, 
      platform = 'web',
      mode = 'subscription',
      testCard = 'success'
    } = body

    console.log('🔄 Création session checkout:', { plan, priceId, customerEmail, platform })

    // Validation du plan avec typage correct
    let selectedPlan: any
    if (plan && SUBSCRIPTION_PLANS[plan as keyof typeof SUBSCRIPTION_PLANS]) {
      selectedPlan = SUBSCRIPTION_PLANS[plan as keyof typeof SUBSCRIPTION_PLANS]
    } else if (priceId && TEST_PRICES[priceId]) {
      // Compatibilité avec l'ancien système de priceId
      const priceInfo = TEST_PRICES[priceId]
      selectedPlan = {
        id: priceId,
        name: `Plan ${priceId}`,
        price: priceInfo.amount,
        currency: priceInfo.currency,
        interval: priceInfo.interval
      }
    } else {
      return NextResponse.json(
        { error: 'Plan ou priceId invalide' },
        { status: 400 }
      )
    }

    // En mode développement, simulation de session
    if (process.env.NODE_ENV === 'development') {
      const mockSessionId = `cs_test_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
      const config = getStripeConfig()
      
      const mockSession = {
        id: mockSessionId,
        url: testCard === 'success' 
          ? `${config.successUrl}?session_id=${mockSessionId}`
          : `${config.cancelUrl}?error=payment_failed`,
        object: 'checkout.session',
        payment_status: testCard === 'success' ? 'paid' : 'unpaid',
        metadata: createStripeMetadata('test_user', selectedPlan.id, platform)
      }

      console.log('🧪 Session de test créée:', mockSessionId)

      return NextResponse.json({
        sessionId: mockSession.id,
        url: mockSession.url,
        testMode: true,
        testCard: testCard
      })
    }

    // Code Stripe réel pour production
    if (!process.env.STRIPE_SECRET_KEY) {
      return NextResponse.json(
        { error: 'Configuration Stripe manquante pour la production' },
        { status: 500 }
      )
    }

    // Ici, intégrer avec le vrai Stripe en production
    const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY)
    const config = getStripeConfig()

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      customer_email: customerEmail,
      line_items: [
        {
          price_data: {
            currency: selectedPlan.currency,
            product_data: {
              name: selectedPlan.name,
              description: `Math4Child.com - Application éducative (${BUSINESS_INFO.name})`,
              images: ['https://www.math4child.com/images/logo.png'],
              metadata: {
                business: BUSINESS_INFO.name,
                siret: BUSINESS_INFO.siret
              }
            },
            recurring: {
              interval: selectedPlan.interval,
              interval_count: selectedPlan.interval_count || 1
            },
            unit_amount: selectedPlan.price,
          },
          quantity: 1,
        },
      ],
      mode: 'subscription',
      success_url: `${config.successUrl}?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: config.cancelUrl,
      metadata: createStripeMetadata('production_user', selectedPlan.id, platform),
      subscription_data: {
        metadata: createStripeMetadata('production_user', selectedPlan.id, platform)
      }
    })

    return NextResponse.json({ 
      sessionId: session.id,
      url: session.url 
    })

  } catch (error) {
    console.error('❌ Erreur création session Stripe:', error)
    return NextResponse.json(
      { 
        error: 'Erreur lors de la création de la session de paiement',
        details: error instanceof Error ? error.message : 'Erreur inconnue'
      },
      { status: 500 }
    )
  }
}

export async function GET() {
  return NextResponse.json({
    status: 'OK',
    message: 'API Stripe Math4Child opérationnelle',
    business: BUSINESS_INFO.name,
    environment: process.env.NODE_ENV,
    testMode: process.env.NODE_ENV === 'development',
    availablePlans: Object.keys(SUBSCRIPTION_PLANS),
    timestamp: new Date().toISOString()
  })
}
