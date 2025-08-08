import { NextApiRequest, NextApiResponse } from 'next'
import { createPaddleCheckout } from '@/lib/paddle/checkout'

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' })
  }

  try {
    const { planType, interval, userEmail } = req.body
    
    if (!planType || !interval || !userEmail) {
      return res.status(400).json({ error: 'Paramètres manquants' })
    }
    
    const checkout = await createPaddleCheckout(planType, interval, userEmail)
    
    res.status(200).json(checkout)
  } catch (error) {
    console.error('Erreur checkout Paddle:', error)
    res.status(500).json({ 
      error: 'Erreur lors de la création du checkout' 
    })
  }
}
