import { NextApiRequest, NextApiResponse } from 'next'
import Stripe from 'stripe'

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-06-20',
})

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method !== 'GET') {
    return res.status(405).json({ message: 'Method not allowed' })
  }

  try {
    const { customerId } = req.query

    if (!customerId || typeof customerId !== 'string') {
      return res.status(400).json({ error: 'Customer ID required' })
    }

    const subscriptions = await stripe.subscriptions.list({
      customer: customerId,
      status: 'active',
      limit: 10
    })

    res.status(200).json({
      subscriptions: subscriptions.data,
      hasActiveSubscription: subscriptions.data.length > 0
    })
  } catch (error) {
    console.error('Erreur récupération abonnements:', error)
    res.status(500).json({ 
      error: 'Erreur lors de la récupération des abonnements',
      details: error instanceof Error ? error.message : 'Erreur inconnue'
    })
  }
}
