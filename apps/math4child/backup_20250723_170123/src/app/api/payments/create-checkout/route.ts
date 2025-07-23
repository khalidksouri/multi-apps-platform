import { NextRequest, NextResponse } from 'next/server'
import { OptimalPaymentManager, getOptimalProvider, CheckoutResponse } from '@/lib/optimal-payments'

export async function POST(request: NextRequest) {
  try {
    const { planId, country, platform, email, amount, currency } = await request.json()
    
    const provider = getOptimalProvider({
      platform: platform || 'web',
      country: country || 'FR',
      amount: amount || 699
    })
    
    console.log(`🎯 [OPTIMAL] Provider sélectionné: ${provider} pour ${country}`)
    
    const checkout: CheckoutResponse = await OptimalPaymentManager.createCheckout(planId, {
      email, country, platform, amount, currency
    })
    
    return NextResponse.json({
      success: checkout.success,
      provider: checkout.provider,
      checkoutUrl: checkout.checkoutUrl,
      sessionId: checkout.sessionId,
      advantages: [
        provider === 'paddle' ? 'TVA automatique EU' : '',
        provider === 'lemonsqueezy' ? 'Optimisé international' : '',
        provider === 'revenuecat' ? 'Gestion familiale native' : '',
        'Fees optimisés',
        'Conversion maximale'
      ].filter(Boolean)
    })
    
  } catch (error) {
    console.error('❌ [OPTIMAL] Erreur checkout:', error)
    return NextResponse.json(
      { error: 'Erreur création checkout optimal' },
      { status: 500 }
    )
  }
}
