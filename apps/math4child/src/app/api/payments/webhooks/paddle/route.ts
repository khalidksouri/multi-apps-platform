import { NextRequest, NextResponse } from 'next/server'
import { optimalPayments } from '@/lib/optimal-payments'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const result = await optimalPayments.handleWebhook('paddle', body)
    return NextResponse.json({ received: true, success: result.success, provider: result.provider })
  } catch (error) {
    console.error('paddle webhook error:', error)
    return NextResponse.json({ error: 'Webhook failed', success: false }, { status: 500 })
  }
}
