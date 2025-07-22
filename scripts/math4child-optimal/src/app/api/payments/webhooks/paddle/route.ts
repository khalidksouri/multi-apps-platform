import { NextRequest, NextResponse } from 'next/server'
import { OptimalPaymentManager } from '@/lib/optimal-payments'

export async function POST(request: NextRequest) {
  try {
    const payload = await request.json()
    
    await OptimalPaymentManager.handleWebhook('paddle', payload)
    
    return NextResponse.json({ received: true })
  } catch (error) {
    console.error('❌ [PADDLE] Webhook error:', error)
    return NextResponse.json({ error: 'Webhook error' }, { status: 400 })
  }
}
