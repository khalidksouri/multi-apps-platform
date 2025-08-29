// =============================================================================
// 🔔 WEBHOOKS STRIPE - APP ROUTER  
// =============================================================================

import { NextRequest, NextResponse } from 'next/server'
import { stripe, DEMO_MODE } from '@/lib/stripe'
import { WebhookEvent } from '@/types/stripe'

const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET || ''

export async function POST(request: NextRequest) {
  try {
    const body = await request.text()
    const signature = request.headers.get('stripe-signature')

    console.log('🔔 [WEBHOOK] Réception webhook Stripe')

    // Mode démo
    if (DEMO_MODE) {
      console.log('🧪 [DEMO] Webhook simulé reçu')
      try {
        const demoEvent = JSON.parse(body)
        console.log('🧪 [DEMO] Type événement:', demoEvent.type)
        return NextResponse.json({ received: true, demo: true, event: demoEvent.type })
      } catch {
        console.log('🧪 [DEMO] Webhook de test générique')
        return NextResponse.json({ received: true, demo: true })
      }
    }

    // Vérification de la signature en production
    if (!signature) {
      console.error('❌ [WEBHOOK] Signature manquante')
      return NextResponse.json(
        { error: 'Signature Stripe manquante' },
        { status: 400 }
      )
    }

    if (!webhookSecret) {
      console.error('❌ [WEBHOOK] Secret webhook non configuré')
      return NextResponse.json(
        { error: 'Secret webhook non configuré' },
        { status: 500 }
      )
    }

    let event: WebhookEvent
    try {
      event = stripe.webhooks.constructEvent(body, signature, webhookSecret) as WebhookEvent
      console.log(`✅ [WEBHOOK] Événement validé: ${event.type}`)
    } catch (err) {
      console.error('❌ [WEBHOOK] Signature invalide:', err)
      return NextResponse.json(
        { error: 'Signature webhook invalide' },
        { status: 400 }
      )
    }

    // Traitement des événements Stripe
    switch (event.type) {
      case 'customer.subscription.created':
        console.log('🎉 [WEBHOOK] Nouvel abonnement créé:', event.data.object.id)
        await handleSubscriptionCreated(event.data.object)
        break

      case 'customer.subscription.updated':
        console.log('🔄 [WEBHOOK] Abonnement mis à jour:', event.data.object.id)
        await handleSubscriptionUpdated(event.data.object)
        break

      case 'customer.subscription.deleted':
        console.log('❌ [WEBHOOK] Abonnement annulé:', event.data.object.id)
        await handleSubscriptionCanceled(event.data.object)
        break

      case 'invoice.payment_succeeded':
        console.log('💰 [WEBHOOK] Paiement réussi:', event.data.object.id)
        await handlePaymentSucceeded(event.data.object)
        break

      case 'invoice.payment_failed':
        console.log('💥 [WEBHOOK] Échec paiement:', event.data.object.id)
        await handlePaymentFailed(event.data.object)
        break

      case 'checkout.session.completed':
        console.log('✅ [WEBHOOK] Checkout complété:', event.data.object.id)
        await handleCheckoutCompleted(event.data.object)
        break

      default:
        console.log(`📨 [WEBHOOK] Événement non géré: ${event.type}`)
    }

    return NextResponse.json({ received: true, event: event.type })

  } catch (error) {
    console.error('💥 [WEBHOOK] Erreur traitement:', error)
    return NextResponse.json(
      { error: 'Erreur serveur webhook' },
      { status: 500 }
    )
  }
}

// Fonctions de traitement des événements
async function handleSubscriptionCreated(subscription: any) {
  console.log('🎉 Traitement création abonnement:', {
    id: subscription.id,
    customer: subscription.customer,
    status: subscription.status,
    planId: subscription.metadata?.planId
  })
  // TODO: Sauvegarder en base de données
  // TODO: Envoyer email de bienvenue
  // TODO: Activer l'accès utilisateur
}

async function handleSubscriptionUpdated(subscription: any) {
  console.log('🔄 Traitement mise à jour abonnement:', {
    id: subscription.id,
    status: subscription.status,
    cancelAtPeriodEnd: subscription.cancel_at_period_end
  })
  // TODO: Mettre à jour en base de données
  // TODO: Notifier l'utilisateur si nécessaire
}

async function handleSubscriptionCanceled(subscription: any) {
  console.log('❌ Traitement annulation abonnement:', {
    id: subscription.id,
    canceledAt: subscription.canceled_at
  })
  // TODO: Désactiver l'accès utilisateur
  // TODO: Envoyer email de confirmation d'annulation
}

async function handlePaymentSucceeded(invoice: any) {
  console.log('💰 Traitement paiement réussi:', {
    id: invoice.id,
    amount: invoice.amount_paid,
    subscription: invoice.subscription
  })
  // TODO: Confirmer l'abonnement actif
  // TODO: Envoyer reçu par email
}

async function handlePaymentFailed(invoice: any) {
  console.log('💥 Traitement échec paiement:', {
    id: invoice.id,
    attemptCount: invoice.attempt_count,
    subscription: invoice.subscription
  })
  // TODO: Notifier l'utilisateur
  // TODO: Suspendre l'accès si nécessaire
}

async function handleCheckoutCompleted(session: any) {
  console.log('✅ Traitement checkout complété:', {
    id: session.id,
    customer: session.customer,
    paymentStatus: session.payment_status
  })
  // TODO: Finaliser l'inscription utilisateur
}

// Gérer les autres méthodes HTTP
export async function GET() {
  return NextResponse.json({
    message: 'Endpoint webhooks Stripe Math4Child v4.2.0',
    methods: ['POST'],
    events: [
      'customer.subscription.created',
      'customer.subscription.updated', 
      'customer.subscription.deleted',
      'invoice.payment_succeeded',
      'invoice.payment_failed',
      'checkout.session.completed'
    ]
  })
}
