import { CheckoutResponse } from '@/types/paddle'
import { getPlanByTypeAndInterval } from './plans'

export async function createPaddleCheckout(
  planType: string, 
  interval: string, 
  userEmail: string
): Promise<CheckoutResponse> {
  const selectedPlan = getPlanByTypeAndInterval(planType, interval)
  
  if (!selectedPlan) {
    throw new Error(`Plan ${planType} avec interval ${interval} non trouvé`)
  }

  // Configuration Paddle avec URL réelle
  const checkoutData = {
    items: [{
      priceId: selectedPlan.priceId,
      quantity: 1
    }],
    customer: {
      email: userEmail
    },
    customData: {
      planId: selectedPlan.id,
      planType: planType,
      interval: interval,
      app: 'Math4Child',
      version: '1.0.0'
    },
    settings: {
      allowLogout: false,
      displayMode: 'overlay',
      theme: 'light',
      locale: 'fr',
      successUrl: `${process.env.NEXT_PUBLIC_APP_URL}/success?session_id={checkout.id}`,
      cancelUrl: `${process.env.NEXT_PUBLIC_APP_URL}/pricing`
    },
    discountId: interval === 'year' ? 'dsc_annual_30_off' : 
                 interval === 'quarter' ? 'dsc_quarterly_10_off' : null
  }

  // Appel à l'API Paddle réelle
  const response = await fetch('https://api.paddle.com/checkout/custom', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.PADDLE_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(checkoutData)
  })

  if (!response.ok) {
    throw new Error(`Erreur Paddle: ${response.status} ${response.statusText}`)
  }

  const result = await response.json()
  
  return {
    success: true,
    provider: 'paddle',
    checkoutUrl: result.data.url, // URL réelle du checkout
    sessionId: result.data.id
  }
}

export async function validatePaddleWebhook(signature: string, body: string): Promise<boolean> {
  // Validation du webhook Paddle
  // À implémenter selon la documentation Paddle
  return true
}
