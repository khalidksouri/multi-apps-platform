import { NextRequest, NextResponse } from 'next/server'
import { stripe, SUBSCRIPTION_PLANS } from '@/lib/stripe'

export async function POST(request: NextRequest) {
  try {
    const { plan, platform, customerEmail } = await request.json()

    // Vérifier que le plan existe
    if (!SUBSCRIPTION_PLANS[plan]) {
      return NextResponse.json(
        { error: 'Plan invalide' },
        { status: 400 }
      )
    }

    const selectedPlan = SUBSCRIPTION_PLANS[plan]

    // Créer la session Stripe Checkout
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      customer_email: customerEmail,
      line_items: [
        {
          price_data: {
            currency: selectedPlan.currency,
            product_data: {
              name: selectedPlan.name,
              description: `Math4Child - Application éducative GOTEST`,
              images: ['https://www.math4child.com/images/logo.png'],
              metadata: {
                platform: platform || 'web',
                business: 'GOTEST',
                siret: '53958712100028'
              }
            },
            recurring: selectedPlan.interval_count && selectedPlan.interval_count > 1
              ? {
                  interval: selectedPlan.interval,
                  interval_count: selectedPlan.interval_count,
                }
              : {
                  interval: selectedPlan.interval,
                },
            unit_amount: selectedPlan.price,
          },
          quantity: 1,
        },
      ],
      mode: 'subscription',
      success_url: `${process.env.NEXT_PUBLIC_SITE_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.NEXT_PUBLIC_SITE_URL}/cancel`,
      metadata: {
        plan: plan,
        platform: platform || 'web',
        business: 'GOTEST - Math4Child',
        contact: 'gotesttech@gmail.com',
        siret: '53958712100028'
      },
      subscription_data: {
        metadata: {
          plan: plan,
          platform: platform || 'web',
          business: 'GOTEST'
        }
      }
    })

    return NextResponse.json({ url: session.url })
  } catch (error) {
    console.error('Erreur création session Stripe:', error)
    return NextResponse.json(
      { error: 'Erreur lors de la création de la session de paiement' },
      { status: 500 }
    )
  }
}

export async function GET() {
  return NextResponse.json({ 
    message: 'API Stripe Math4Child - GOTEST',
    contact: 'gotesttech@gmail.com',
    siret: '53958712100028'
  })
}
