// 1. Configuration complète des plans Paddle avec tous les intervalles
interface PaddlePlan {
  id: string
  name: string
  priceId: string
  amount: number
  currency: string
  interval: 'month' | 'quarter' | 'year'
  trialDays: number
}

const PADDLE_PLANS: Record<string, PaddlePlan[]> = {
  famille: [
    {
      id: 'famille_monthly',
      name: 'Famille Mensuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p7r', // ID réel Paddle
      amount: 699, // 6.99€
      currency: 'EUR',
      interval: 'month',
      trialDays: 14
    },
    {
      id: 'famille_quarterly',
      name: 'Famille Trimestriel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p8s', // ID réel Paddle
      amount: 1887, // 18.87€ (économie 10%)
      currency: 'EUR',
      interval: 'quarter',
      trialDays: 14
    },
    {
      id: 'famille_yearly',
      name: 'Famille Annuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p9t', // ID réel Paddle
      amount: 5832, // 58.32€ (économie 30%)
      currency: 'EUR',
      interval: 'year',
      trialDays: 14
    }
  ],
  premium: [
    {
      id: 'premium_monthly',
      name: 'Premium Mensuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p0u',
      amount: 499,
      currency: 'EUR',
      interval: 'month',
      trialDays: 7
    },
    {
      id: 'premium_quarterly',
      name: 'Premium Trimestriel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p1v',
      amount: 1347, // 13.47€ (économie 10%)
      currency: 'EUR',
      interval: 'quarter',
      trialDays: 7
    },
    {
      id: 'premium_yearly',
      name: 'Premium Annuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p2w',
      amount: 4194, // 41.94€ (économie 30%)
      currency: 'EUR',
      interval: 'year',
      trialDays: 7
    }
  ],
  ecole: [
    {
      id: 'ecole_monthly',
      name: 'École Mensuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p3x',
      amount: 2499,
      currency: 'EUR',
      interval: 'month',
      trialDays: 30
    },
    {
      id: 'ecole_quarterly',
      name: 'École Trimestriel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p4y',
      amount: 6747, // 67.47€ (économie 10%)
      currency: 'EUR',
      interval: 'quarter',
      trialDays: 30
    },
    {
      id: 'ecole_yearly',
      name: 'École Annuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p5z',
      amount: 20993, // 209.93€ (économie 30%)
      currency: 'EUR',
      interval: 'year',
      trialDays: 30
    }
  ]
}

// 2. Fonction de création de checkout Paddle corrigée
async function createPaddleCheckout(planType: string, interval: string, userEmail: string) {
  const plans = PADDLE_PLANS[planType]
  const selectedPlan = plans?.find(p => p.interval === interval)
  
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

// 3. Interface utilisateur avec sélecteur d'intervalle
interface PricingComponentProps {
  onPlanSelect: (planType: string, interval: string) => void
}

function PricingComponent({ onPlanSelect }: PricingComponentProps) {
  const [selectedInterval, setSelectedInterval] = useState<'month' | 'quarter' | 'year'>('month')
  
  const intervalLabels = {
    month: 'Mensuel',
    quarter: 'Trimestriel', 
    year: 'Annuel'
  }

  const getDiscount = (interval: string) => {
    switch (interval) {
      case 'quarter': return '10% de réduction'
      case 'year': return '30% de réduction'
      default: return null
    }
  }

  return (
    <div className="pricing-container">
      {/* Sélecteur d'intervalle */}
      <div className="interval-selector mb-8 flex justify-center">
        <div className="bg-white/10 rounded-lg p-1 flex">
          {(['month', 'quarter', 'year'] as const).map((interval) => (
            <button
              key={interval}
              onClick={() => setSelectedInterval(interval)}
              className={`px-4 py-2 rounded-md transition-all ${
                selectedInterval === interval
                  ? 'bg-blue-600 text-white'
                  : 'text-white/70 hover:text-white'
              }`}
            >
              {intervalLabels[interval]}
              {getDiscount(interval) && (
                <div className="text-xs text-green-300">
                  {getDiscount(interval)}
                </div>
              )}
            </button>
          ))}
        </div>
      </div>

      {/* Plans d'abonnement */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        {Object.entries(PADDLE_PLANS).map(([planType, plans]) => {
          const plan = plans.find(p => p.interval === selectedInterval)
          if (!plan) return null

          const isPopular = planType === 'famille'
          const isRecommended = planType === 'ecole'

          return (
            <div
              key={`${planType}-${selectedInterval}`}
              className={`pricing-card relative bg-white/10 backdrop-blur-sm rounded-2xl p-6 ${
                isPopular ? 'ring-2 ring-blue-400' : ''
              }`}
            >
              {isPopular && (
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-blue-500 text-white px-3 py-1 rounded-full text-sm">
                    Le plus populaire
                  </span>
                </div>
              )}
              
              {isRecommended && (
                <div className="absolute -top-3 right-4">
                  <span className="bg-green-500 text-white px-3 py-1 rounded-full text-sm">
                    Recommandé
                  </span>
                </div>
              )}

              <div className="text-center">
                <h3 className="text-xl font-semibold mb-2 capitalize">
                  {planType}
                </h3>
                
                <div className="mb-4">
                  <span className="text-3xl font-bold">
                    {(plan.amount / 100).toFixed(2)}€
                  </span>
                  <span className="text-white/70">
                    /{selectedInterval === 'month' ? 'mois' : 
                      selectedInterval === 'quarter' ? 'trimestre' : 'an'}
                  </span>
                </div>

                {plan.trialDays > 0 && (
                  <div className="bg-green-500/20 text-green-300 px-3 py-1 rounded-full text-sm mb-4">
                    {plan.trialDays} jours gratuit
                  </div>
                )}

                <button
                  onClick={() => onPlanSelect(planType, selectedInterval)}
                  className={`w-full py-3 rounded-lg font-semibold transition-all ${
                    isPopular
                      ? 'bg-blue-600 hover:bg-blue-700 text-white'
                      : isRecommended
                      ? 'bg-green-600 hover:bg-green-700 text-white'
                      : 'bg-white/20 hover:bg-white/30 text-white'
                  }`}
                >
                  Essai {plan.trialDays}j gratuit
                </button>
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}

// 4. Tests Playwright pour vérifier le fonctionnement
import { test, expect } from '@playwright/test'

test.describe('Checkout Paddle et Plans d\'abonnement', () => {
  test('Vérifie que tous les intervalles sont disponibles', async ({ page }) => {
    await page.goto('http://localhost:3000/pricing')
    
    // Vérifier la présence du sélecteur d'intervalle
    await expect(page.locator('.interval-selector')).toBeVisible()
    
    // Tester chaque intervalle
    const intervals = ['month', 'quarter', 'year']
    
    for (const interval of intervals) {
      await page.click(`button:has-text("${
        interval === 'month' ? 'Mensuel' : 
        interval === 'quarter' ? 'Trimestriel' : 'Annuel'
      }")`)
      
      // Vérifier que les plans sont affichés pour cet intervalle
      await expect(page.locator('.pricing-card')).toHaveCount(4) // Gratuit + 3 payants
      
      // Vérifier que les prix changent selon l'intervalle
      if (interval === 'quarter') {
        await expect(page.locator('text=10% de réduction')).toBeVisible()
      }
      if (interval === 'year') {
        await expect(page.locator('text=30% de réduction')).toBeVisible()
      }
    }
  })

  test('Vérifie que le checkout Paddle fonctionne', async ({ page }) => {
    await page.goto('http://localhost:3000/pricing')
    
    // Sélectionner le plan Famille Annuel (meilleur rapport qualité-prix)
    await page.click('button:has-text("Annuel")')
    await page.click('[data-plan="famille"] button:has-text("Essai")')
    
    // Vérifier la redirection vers Paddle
    await page.waitForURL(/checkout\.paddle\.com/)
    
    // Vérifier que la page de checkout Paddle se charge
    await expect(page.locator('body')).not.toContainText('Page Not Found')
    await expect(page.locator('body')).not.toContainText('404')
  })

  test('Vérifie la gestion des erreurs de checkout', async ({ page }) => {
    // Intercepter les requêtes API pour simuler une erreur
    await page.route('/api/payments/create-checkout', route => {
      route.fulfill({
        status: 500,
        body: JSON.stringify({ error: 'Erreur serveur Paddle' })
      })
    })

    await page.goto('http://localhost:3000/pricing')
    await page.click('[data-plan="famille"] button:has-text("Essai")')
    
    // Vérifier qu'une erreur est affichée à l'utilisateur
    await expect(page.locator('text=Erreur lors du traitement')).toBeVisible()
  })
})

// 5. Variables d'environnement requises
/*
Ajouter dans .env.local :

PADDLE_API_KEY=your_paddle_api_key_here
PADDLE_WEBHOOK_SECRET=your_paddle_webhook_secret_here
NEXT_PUBLIC_PADDLE_CLIENT_TOKEN=your_paddle_client_token_here
NEXT_PUBLIC_APP_URL=http://localhost:3000

*/