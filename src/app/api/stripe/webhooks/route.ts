import { NextRequest, NextResponse } from 'next/server'
import { stripe } from '@/lib/stripe'

export async function POST(request: NextRequest) {
  const body = await request.text()
  
  // Correction pour Next.js 15: headers() est synchrone, pas besoin d'await
  const signature = request.headers.get('stripe-signature')

  if (!signature) {
    return NextResponse.json(
      { error: 'Signature manquante' },
      { status: 400 }
    )
  }

  try {
    const event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    )

    console.log('📧 [GOTEST] Webhook reçu:', event.type)

    switch (event.type) {
      case 'checkout.session.completed':
        const session = event.data.object
        console.log('💳 [GOTEST] Paiement réussi Math4Child:', session.id)
        console.log('💰 [GOTEST] Montant:', session.amount_total, 'centimes')
        console.log('🏦 [GOTEST] Direction Qonto:', 'FR7616958000016218830371501')
        // Ici vous pourriez enregistrer l'abonnement en base de données
        break

      case 'customer.subscription.created':
        const subscription = event.data.object
        console.log('🎉 [GOTEST] Nouvel abonnement Math4Child:', subscription.id)
        break

      case 'customer.subscription.updated':
        const updatedSubscription = event.data.object
        console.log('🔄 [GOTEST] Abonnement mis à jour:', updatedSubscription.id)
        break

      case 'customer.subscription.deleted':
        const deletedSubscription = event.data.object
        console.log('❌ [GOTEST] Abonnement annulé:', deletedSubscription.id)
        break

      case 'invoice.payment_succeeded':
        const invoice = event.data.object
        console.log('💰 [GOTEST] Paiement récurrent Math4Child réussi:', invoice.id)
        break

      case 'invoice.payment_failed':
        const failedInvoice = event.data.object
        console.log('⚠️ [GOTEST] Échec de paiement Math4Child:', failedInvoice.id)
        break

      case 'payout.paid':
        const payout = event.data.object
        console.log('🏦 [GOTEST] Virement vers Qonto effectué:', payout.id)
        console.log('💸 [GOTEST] Montant viré:', payout.amount, 'centimes')
        break

      default:
        console.log('🔔 [GOTEST] Événement non géré:', event.type)
    }

    return NextResponse.json({ received: true })
  } catch (error) {
    console.error('❌ [GOTEST] Erreur webhook:', error)
    return NextResponse.json(
      { error: 'Erreur webhook' },
      { status: 400 }
    )
  }
}
