import { NextRequest, NextResponse } from 'next/server'
import { OptimalPaymentManager, getOptimalProvider } from '@/lib/optimal-payments'

interface CheckoutResponse {
  success: boolean
  provider: string
  checkoutUrl?: string
  sessionId?: string
  packageId?: string
  offering?: string
}

export async function POST(request: NextRequest) {
  try {
    const { planId, country, platform, email, amount, currency } = await request.json()
    
    // Déterminer le provider optimal
    const provider = getOptimalProvider({
      platform: platform || 'web',
      country: country || 'FR',
      amount: amount || 699
    })
    
    console.log(`🎯 [OPTIMAL] Provider sélectionné: ${provider} pour ${country}`)
    
    // Créer checkout via provider optimal
    const checkout: CheckoutResponse = await OptimalPaymentManager.createCheckout(planId, {
      email,
      country,
      platform,
      amount,
      currency
    })
    
    // Analytics
    console.log('📊 [OPTIMAL] Checkout créé:', {
      planId,
      provider,
      country,
      amount: `${amount/100}€`
    })
    
    // Construire la réponse selon le type de provider
    const response: any = {
      success: true,
      provider,
      advantages: [
        provider === 'paddle' ? 'TVA automatique EU' : '',
        provider === 'lemonsqueezy' ? 'Optimisé international' : '',
        provider === 'revenuecat' ? 'Gestion familiale native' : '',
        'Fees optimisés',
        'Conversion maximale'
      ].filter(Boolean)
    }
    
    // Ajouter les champs spécifiques selon le provider
    if (checkout.checkoutUrl) {
      response.checkoutUrl = checkout.checkoutUrl
    }
    
    if (checkout.sessionId) {
      response.sessionId = checkout.sessionId
    }
    
    if (checkout.packageId) {
      response.packageId = checkout.packageId
    }
    
    if (checkout.offering) {
      response.offering = checkout.offering
    }
    
    return NextResponse.json(response)
    
  } catch (error) {
    console.error('❌ [OPTIMAL] Erreur checkout:', error)
    return NextResponse.json(
      { error: 'Erreur création checkout optimal' },
      { status: 500 }
    )
  }
}
