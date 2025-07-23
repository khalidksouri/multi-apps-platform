import { NextRequest, NextResponse } from 'next/server'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    
    // Log du webhook pour débogage
    console.log('LemonSqueezy webhook received:', {
      headers: Object.fromEntries(request.headers.entries()),
      body: body,
      timestamp: new Date().toISOString()
    })
    
    // Vérification basique du webhook
    const eventType = body.meta?.event_name || 'unknown'
    
    switch (eventType) {
      case 'order_created':
        console.log('New order created:', body.data?.id)
        break
      case 'subscription_created':
        console.log('New subscription created:', body.data?.id)
        break
      case 'subscription_updated':
        console.log('Subscription updated:', body.data?.id)
        break
      case 'subscription_cancelled':
        console.log('Subscription cancelled:', body.data?.id)
        break
      default:
        console.log('Unknown event type:', eventType)
    }
    
    // Réponse de succès pour LemonSqueezy
    return NextResponse.json({ 
      received: true, 
      event_type: eventType,
      success: true 
    })
    
  } catch (error) {
    console.error('LemonSqueezy webhook error:', error)
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
    message: 'LemonSqueezy webhook endpoint is working',
    success: true
  })
}
