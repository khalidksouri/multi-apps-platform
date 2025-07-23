import { NextApiRequest, NextApiResponse } from 'next'
import Stripe from 'stripe'

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2023-10-16',
})

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' })
  }

  try {
    const { priceId, mode = 'subscription' } = req.body

    const session = await stripe.checkout.sessions.create({
      mode: mode,
      line_items: [
        {
          price: priceId,
          quantity: 1,
        },
      ],
      success_url: `${process.env.NEXT_PUBLIC_BASE_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.NEXT_PUBLIC_BASE_URL}/pricing`,
      automatic_tax: { enabled: true },
      billing_address_collection: 'required',
      metadata: {
        app: 'math4child',
        environment: process.env.NODE_ENV || 'development'
      }
    })

    res.status(200).json({ sessionId: session.id, url: session.url })

  } catch (error) {
    console.error('Erreur création session Stripe:', error)
    res.status(500).json({ 
      error: 'Erreur lors de la création de la session',
      details: error instanceof Error ? error.message : 'Erreur inconnue'
    })
  }
}
