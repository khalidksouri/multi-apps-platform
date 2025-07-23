import { NextRequest, NextResponse } from 'next/server'
import { optimalPayments } from '@/lib/optimal-payments'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    
    // Log du webhook pour débogage
    console.log('Paddle webhook received:', {
      headers: Object.fromEntries(request.headers.entries()),
      body: body,
      timestamp: new Date().toISOString()
    })
    
    // Vérification basique du webhook
    const eventType = body.event_type || 'unknown'
    
    switch (eventType) {
      case 'subscription_created':
        console.log('New Paddle subscription created:', body.subscription_id)
        break
      case 'subscription_updated':
        console.log('Paddle subscription updated:', body.subscription_id)
        break
      case 'subscription_cancelled':
        console.log('Paddle subscription cancelled:', body.subscription_id)
        break
      case 'payment_succeeded':
        console.log('Paddle payment succeeded:', body.order_id)
        break
      default:
        console.log('Unknown Paddle event type:', eventType)
    }
    
    // Simuler le traitement avec optimalPayments
    const result = await optimalPayments.createPaymentIntent({
      amount: body.unit_price || 0,
      currency: body.currency || 'EUR',
      provider: 'paddle',
      metadata: {
        webhook_event: eventType,
        subscription_id: body.subscription_id,
        order_id: body.order_id
      }
    })
    
    // Réponse de succès pour Paddle
    return NextResponse.json({ 
      received: true, 
      event_type: eventType,
      success: true,
      processed: result.success
    })
    
  } catch (error) {
    console.error('Paddle webhook error:', error)
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
    message: 'Paddle webhook endpoint is working',
    success: true
  })
}
