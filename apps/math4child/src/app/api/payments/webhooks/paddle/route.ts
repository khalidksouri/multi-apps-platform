import { NextRequest, NextResponse } from 'next/server'
import { optimalPayments } from '@/lib/optimal-payments'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    
    console.log('Paddle webhook received:', body)
    
    const result = await optimalPayments.createPaymentIntent({
      amount: body.unit_price || 0,
      currency: body.currency || 'EUR',
      provider: 'paddle',
    })
    
    return NextResponse.json({ 
      received: true, 
      success: true,
      processed: result.success
    })
    
  } catch (error) {
    console.error('Paddle webhook error:', error)
    return NextResponse.json(
      { error: 'Webhook processing failed', success: false },
      { status: 500 }
    )
  }
}

export async function GET() {
  return NextResponse.json({
    message: 'Paddle webhook endpoint is working',
    success: true
  })
}
