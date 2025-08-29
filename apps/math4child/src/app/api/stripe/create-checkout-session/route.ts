// =============================================================================
// 💳 API CHECKOUT SESSION - APP ROUTER [CORRIGÉ]
// =============================================================================

import { NextRequest, NextResponse } from 'next/server'
import { stripe, getPlanById, DEMO_MODE, formatPrice } from '@/lib/stripe'
import { CheckoutSessionRequest, CheckoutSessionResponse } from '@/types/stripe'

export async function POST(request: NextRequest) {
  try {
    // Parsing JSON sécurisé
    let body: CheckoutSessionRequest
    try {
      const rawBody = await request.text()
      body = JSON.parse(rawBody)
    } catch (parseError) {
      console.error('Erreur parsing JSON:', parseError)
      return NextResponse.json(
        { 
          success: false, 
          error: 'JSON invalide dans la requête' 
        } as CheckoutSessionResponse,
        { status: 400 }
      )
    }

    const { planId, email, successUrl, cancelUrl, metadata, couponCode, trialDays } = body

    console.log(`[CHECKOUT] Demande pour plan: ${planId}`)

    // Validation du planId
    if (!planId || typeof planId !== 'string') {
      return NextResponse.json(
        { 
          success: false, 
          error: 'planId requis et doit être une chaîne de caractères' 
        } as CheckoutSessionResponse,
        { status: 400 }
      )
    }

    // Validation du plan
    const plan = getPlanById(planId)
    if (!plan) {
      console.error(`Plan non trouvé: ${planId}`)
      return NextResponse.json(
        { 
          success: false, 
          error: `Plan "${planId}" non trouvé. Plans disponibles: basic, premium, ultimate` 
        } as CheckoutSessionResponse,
        { status: 400 }
      )
    }

    // URLs par défaut
    const origin = request.headers.get('origin') || 'http://localhost:3000'
    const defaultSuccessUrl = successUrl || `${origin}/success?session_id={CHECKOUT_SESSION_ID}`
    const defaultCancelUrl = cancelUrl || `${origin}/pricing`

    console.log(`[CHECKOUT] Plan sélectionné: ${plan.name} - ${formatPrice(plan.price, plan.currency)}`)

    // Mode démo - retourner une réponse simulée
    if (DEMO_MODE) {
      console.log(`[DEMO] Simulation checkout pour ${plan.name}`)
      
      const demoResponse: CheckoutSessionResponse = {
        success: true,
        sessionId: `demo_session_${planId}_${Date.now()}`,
        url: `${origin}/demo-success?plan=${planId}&amount=${plan.price}&name=${encodeURIComponent(plan.name)}`,
        demoMode: true
      }
      
      return NextResponse.json(demoResponse)
    }

    // Mode production - Stripe réel
    console.log('[STRIPE] Création session Stripe réelle...')

    const sessionParams: any = {
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: plan.currency,
            product_data: {
              name: `Math4Child ${plan.name}`,
              description: plan.description,
              images: [`${origin}/images/logo-math4child.png`],
              metadata: {
                planId: planId,
                profiles: plan.profiles.toString()
              }
            },
            unit_amount: plan.price,
            recurring: {
              interval: plan.interval,
            },
          },
          quantity: 1,
        },
      ],
      mode: 'subscription',
      success_url: defaultSuccessUrl,
      cancel_url: defaultCancelUrl,
      metadata: {
        planId: planId,
        profiles: plan.profiles.toString(),
        source: 'math4child-web',
        version: '4.2.0',
        ...metadata
      },
      allow_promotion_codes: true
    }

    // Ajouter email si fourni
    if (email && typeof email === 'string') {
      sessionParams.customer_email = email
    }

    // Ajouter subscription data si nécessaire
    sessionParams.subscription_data = {
      metadata: {
        planId: planId,
        profiles: plan.profiles.toString(),
      }
    }

    // Ajouter période d'essai si fournie
    if (trialDays && typeof trialDays === 'number' && trialDays > 0) {
      sessionParams.subscription_data.trial_period_days = trialDays
    }

    // Ajouter coupon si fourni
    if (couponCode && typeof couponCode === 'string') {
      sessionParams.discounts = [{ coupon: couponCode }]
    }

    const session = await stripe.checkout.sessions.create(sessionParams)

    const response: CheckoutSessionResponse = {
      success: true,
      sessionId: session.id,
      url: session.url || defaultSuccessUrl
    }

    console.log(`[STRIPE] Session créée: ${session.id}`)
    return NextResponse.json(response)

  } catch (error) {
    console.error('[CHECKOUT] Erreur:', error)
    
    const errorMessage = error instanceof Error ? error.message : 'Erreur inconnue'
    const errorResponse: CheckoutSessionResponse = {
      success: false,
      error: `Erreur lors de la création de la session: ${errorMessage}`
    }
    
    return NextResponse.json(errorResponse, { status: 500 })
  }
}

// Gérer les autres méthodes HTTP
export async function GET() {
  return NextResponse.json(
    { 
      error: 'Méthode GET non supportée pour la création de session',
      message: 'Utilisez POST avec les données du plan',
      example: {
        planId: 'basic',
        email: 'test@example.com'
      },
      availablePlans: ['basic', 'premium', 'ultimate']
    },
    { status: 405 }
  )
}

export async function PUT() {
  return NextResponse.json({ error: 'Méthode PUT non supportée' }, { status: 405 })
}

export async function DELETE() {
  return NextResponse.json({ error: 'Méthode DELETE non supportée' }, { status: 405 })
}
