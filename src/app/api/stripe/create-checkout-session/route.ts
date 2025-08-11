import { NextRequest } from 'next/server'
import { stripe, MATH4CHILD_PLANS } from '@/lib/stripe'

export async function POST(request: NextRequest) {
  try {
    const { planId, priceId } = await request.json()
    
    // Vérifier que le plan existe
    const plan = MATH4CHILD_PLANS.find(p => p.id === planId)
    if (!plan) {
      return Response.json({ error: 'Plan non trouvé' }, { status: 400 })
    }

    // Créer la session Stripe
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: plan.currency,
            product_data: {
              name: plan.name,
              description: `Math4Child v4.2.0 - ${plan.name}`,
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
      success_url: `${request.headers.get('origin')}/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${request.headers.get('origin')}/pricing`,
      metadata: {
        planId: planId,
      },
    })

    return Response.json({ sessionId: session.id })
  } catch (error) {
    console.error('Erreur création session Stripe:', error)
    return Response.json(
      { error: 'Erreur lors de la création de la session' },
      { status: 500 }
    )
  }
}
