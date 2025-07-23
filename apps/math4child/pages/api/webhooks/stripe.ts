import { NextApiRequest, NextApiResponse } from 'next'
import Stripe from 'stripe'

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-06-20',
})

export const config = {
  api: { bodyParser: false },
}

async function getRawBody(req: NextApiRequest): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const chunks: Buffer[] = []
    req.on('data', (chunk: Buffer) => chunks.push(chunk))
    req.on('end', () => resolve(Buffer.concat(chunks)))
    req.on('error', reject)
  })
}

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' })
  }

  const buf = await getRawBody(req)
  const sig = req.headers['stripe-signature']!

  let event: Stripe.Event

  try {
    event = stripe.webhooks.constructEvent(buf, sig, process.env.STRIPE_WEBHOOK_SECRET!)
  } catch (err) {
    console.error('Erreur webhook signature:', err)
    return res.status(400).send(`Webhook Error: ${err}`)
  }

  switch (event.type) {
    case 'checkout.session.completed':
      console.log('💳 Paiement réussi:', (event.data.object as Stripe.Checkout.Session).id)
      break
    case 'invoice.payment_succeeded':
      console.log('📄 Facture payée:', (event.data.object as Stripe.Invoice).id)
      break
    default:
      console.log(`Événement non géré: ${event.type}`)
  }

  res.json({ received: true })
}
