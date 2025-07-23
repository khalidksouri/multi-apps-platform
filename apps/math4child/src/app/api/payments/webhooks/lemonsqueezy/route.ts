import { NextRequest, NextResponse } from 'next/server'

// Classe simple intégrée
class SimplePayments {
  async handleWebhook(provider: string, payload: unknown): Promise<{ success: boolean; provider: string }> {
    console.log('Webhook received:', provider, payload)
    return { success: true, provider }
  }
}

const payments = new SimplePayments()

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const result = await payments.handleWebhook('lemonsqueezy', body)
    return NextResponse.json({ 
      received: true, 
      success: result.success, 
      provider: result.provider,
      timestamp: new Date().toISOString()
    })
  } catch (error) {
    console.error('lemonsqueezy webhook error:', error)
    return NextResponse.json({ error: 'Webhook failed', success: false }, { status: 500 })
  }
}

export async function GET() {
  return NextResponse.json({
    message: 'lemonsqueezy webhook endpoint working',
    success: true,
    provider: 'lemonsqueezy'
  })
}
