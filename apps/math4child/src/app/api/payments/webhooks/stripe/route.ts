import { NextRequest, NextResponse } from 'next/server'
import { optimalPayments } from '@/lib/optimal-payments'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    
    // Log du webhook pour débogage
    console.log('Stripe webhook received:', {
      headers: Object.fromEntries(request.headers.entries()),
      body: body,
      timestamp: new Date().toISOString()
    })
    
    // Vérification basique du webhook
    const eventType = body.type || 'unknown'
    
    switch (eventType) {
      case 'checkout.session.completed':
        console.log('Stripe checkout completed:', body.data?.object?.id)
        break
      case 'invoice.payment_succeeded':
        console.log('Stripe payment succeeded:', body.data?.object?.id)
        break
      case 'customer.subscription.created':
        console.log('Stripe subscription created:', body.data?.object?.id)
        break
      case 'customer.subscription.updated':
        console.log('Stripe subscription updated:', body.data?.object?.id)
        break
      case 'customer.subscription.deleted':
        console.log('Stripe subscription cancelled:', body.data?.object?.id)
        break
      default:
        console.log('Unknown Stripe event type:', eventType)
    }
    
    // Simuler le traitement avec optimalPayments
    const result = await optimalPayments.createPaymentIntent({
      amount: body.data?.object?.amount_total || 0,
      currency: body.data?.object?.currency || 'eur',
      provider: 'stripe',
      metadata: {
        webhook_event: eventType,
        session_id: body.data?.object?.id,
        customer_id: body.data?.object?.customer
      }
    })
    
    // Réponse de succès pour Stripe
    return NextResponse.json({ 
      received: true, 
      event_type: eventType,
      success: true,
      processed: result.success
    })
    
  } catch (error) {
    console.error('Stripe webhook error:', error)
    return NextResponse.json(
      { 
        error: 'Webhook processing failed', 
        success: false,
        message: error instanceof Error ? error.message : 'Unknown error'
      },
      { status: 500 }
    )
  }
}

// Méthode GET pour vérification
export async function GET() {
  return NextResponse.json({
    message: 'Stripe webhook endpoint is working',
    success: true
  })
}
