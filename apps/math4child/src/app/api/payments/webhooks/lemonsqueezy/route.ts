import { NextRequest, NextResponse } from 'next/server'
import { optimalPayments } from '@/lib/optimal-payments'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    await optimalPayments.handleWebhook('lemonsqueezy', body)
    return NextResponse.json({ received: true, success: true })
  } catch (error) {
    console.error('LemonSqueezy webhook error:', error)
    return NextResponse.json(
      { error: 'Webhook processing failed', success: false },
      { status: 500 }
    )
  }
}

export async function GET() {
  return NextResponse.json({
    message: 'LemonSqueezy webhook endpoint is working',
    success: true
  })
}
