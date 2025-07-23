import { NextRequest, NextResponse } from 'next/server'
import { optimalPayments } from '@/lib/optimal-payments'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { amount, currency = 'EUR', planId, country, platform, email } = body

    if (!amount || amount <= 0) {
      return NextResponse.json({ error: 'Invalid amount', success: false }, { status: 400 })
    }

    if (planId) {
      const checkout = await optimalPayments.createCheckout(planId, { email, country, platform, amount, currency })
      return NextResponse.json(checkout)
    }

    const paymentResponse = await optimalPayments.createPaymentIntent({ amount, currency })
    return NextResponse.json(paymentResponse)
  } catch (error) {
    console.error('Payment creation error:', error)
    return NextResponse.json({ error: 'Internal server error', success: false }, { status: 500 })
  }
}

export async function GET() {
  return NextResponse.json({ message: 'Payment endpoint working', success: true })
}
