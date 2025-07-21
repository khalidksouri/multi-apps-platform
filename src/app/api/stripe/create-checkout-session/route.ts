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

    // Créer la session Stripe Checkout avec paramètres compatibles
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      customer_email: customerEmail,
      line_items: [
        {
          price_data: {
            currency: selectedPlan.currency,
            product_data: {
              name: selectedPlan.name,
              description: `Math4Child.com - Application éducative pour enfants (GOTEST)`,
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
      success_url: `${process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000'}/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000'}/cancel`,
      metadata: {
        plan: plan,
        platform: platform || 'web',
        business: 'GOTEST - Math4Child',
        contact: 'khalid_ksouri@yahoo.fr',
        siret: '53958712100028'
      },
      subscription_data: {
        metadata: {
          plan: plan,
          platform: platform || 'web',
          business: 'GOTEST',
          qonto_iban: 'FR7616958000016218830371501'
        }
      }
      // Suppression de receipt_email et automatic_tax pour compatibilité
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
