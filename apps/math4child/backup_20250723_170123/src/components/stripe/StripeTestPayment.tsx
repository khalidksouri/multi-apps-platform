'use client'

import { useState } from 'react'
import { loadStripe } from '@stripe/stripe-js'

const stripePromise = loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!)

interface Plan {
  id: string
  name: string
  price_monthly: string
  price_yearly: string
  features: string[]
  popular?: boolean
  monthlyPrice: number
  yearlyPrice: number
}

const MATH4CHILD_PLANS: Plan[] = [
  {
    id: 'family',
    name: 'Plan Famille',
    price_monthly: 'price_test_family_monthly',
    price_yearly: 'price_test_family_yearly',
    monthlyPrice: 6.99,
    yearlyPrice: 59.90,
    features: [
      '5 profils enfants',
      'Questions illimitées',
      '30+ langues',
      'Mode hors-ligne total',
      'Support prioritaire'
    ],
    popular: true
  },
  {
    id: 'premium',
    name: 'Plan Premium', 
    price_monthly: 'price_test_premium_monthly',
    price_yearly: 'price_test_premium_yearly',
    monthlyPrice: 6.99,
    yearlyPrice: 59.90,
    features: [
      '2 profils enfants',
      'Questions illimitées',
      '30+ langues',
      'Mode hors-ligne',
      'Support email'
    ]
  },
  {
    id: 'school',
    name: 'Plan École',
    price_monthly: 'price_test_school_monthly',
    price_yearly: 'price_test_school_yearly',
    monthlyPrice: 6.99,
    yearlyPrice: 59.90,
    features: [
      '30 profils élèves',
      'Tableau de bord enseignant',
      'Rapports détaillés',
      'API LMS',
      'Support téléphonique'
    ]
  }
]

interface TestCard {
  type: string
  number: string
  description: string
  expected: 'success' | 'decline' | 'insufficient' | 'expired'
}

const TEST_CARDS: TestCard[] = [
  {
    type: 'Paiement réussi',
    number: '4242 4242 4242 4242',
    description: 'Processus de paiement standard',
    expected: 'success'
  },
  {
    type: 'Carte déclinée',
    number: '4000 0000 0000 0002',
    description: 'Erreur générique de déclin',
    expected: 'decline'
  },
  {
    type: 'Fonds insuffisants',
    number: '4000 0000 0000 9995',
    description: 'Solde insuffisant',
    expected: 'insufficient'
  },
  {
    type: 'Carte expirée',
    number: '4000 0000 0000 0069',
    description: 'Date d\'expiration dépassée',
    expected: 'expired'
  }
]

export default function StripeTestPayment() {
  const [loading, setLoading] = useState<string | null>(null)
  const [isYearly, setIsYearly] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const handleSubscription = async (plan: Plan) => {
    try {
      setLoading(plan.id)
      setError(null)
      
      const priceId = isYearly ? plan.price_yearly : plan.price_monthly
      
      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          priceId: priceId,
          mode: 'subscription'
        }),
      })

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      const { sessionId, url } = await response.json()

      if (url) {
        window.location.href = url
      } else if (sessionId) {
        const stripe = await stripePromise
        if (stripe) {
          await stripe.redirectToCheckout({ sessionId })
        }
      } else {
        throw new Error('Aucune URL ou sessionId reçu')
      }

    } catch (error) {
      console.error('Erreur paiement:', error)
      setError('Erreur lors du processus de paiement')
      
      // Pour les tests Playwright
      if (typeof window !== 'undefined') {
        window.dispatchEvent(new CustomEvent('stripe-error', { 
          detail: { error: error instanceof Error ? error.message : 'Erreur inconnue' }
        }))
      }
    } finally {
      setLoading(null)
    }
  }

  const formatPrice = (plan: Plan): string => {
    if (isYearly) {
      return `€${plan.yearlyPrice}/an`
    }
    return `€${plan.monthlyPrice}/mois`
  }

  const getSubPrice = (plan: Plan): string => {
    if (isYearly) {
      const monthlyEquivalent = (plan.yearlyPrice / 12).toFixed(2)
      return `Soit €${monthlyEquivalent}/mois`
    }
    return 'Facturation mensuelle'
  }

  return (
    <div className="max-w-6xl mx-auto p-6" data-testid="stripe-test-container">
      {/* Header */}
      <div className="text-center mb-8">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          🧪 Test des Paiements Math4Child
        </h1>
        <p className="text-xl text-gray-600 mb-6">
          Mode développement - Utilisez les cartes de test Stripe
        </p>
        
        {/* Alerte d'erreur */}
        {error && (
          <div 
            className="bg-red-50 border border-red-200 rounded-lg p-4 mb-6"
            data-testid="error-alert"
          >
            <p className="text-red-800">{error}</p>
          </div>
        )}
        
        {/* Toggle mensuel/annuel */}
        <div className="flex items-center justify-center space-x-4 mb-8">
          <span className={`${!isYearly ? 'text-blue-600 font-semibold' : 'text-gray-500'}`}>
            Mensuel
          </span>
          <button
            onClick={() => setIsYearly(!isYearly)}
            className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${
              isYearly ? 'bg-blue-600' : 'bg-gray-200'
            }`}
            data-testid="billing-toggle"
            aria-label={`Basculer vers ${isYearly ? 'mensuel' : 'annuel'}`}
          >
            <span
              className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${
                isYearly ? 'translate-x-6' : 'translate-x-1'
              }`}
            />
          </button>
          <span className={`${isYearly ? 'text-blue-600 font-semibold' : 'text-gray-500'}`}>
            Annuel
            <span className="ml-1 text-green-600 text-sm">(-20%)</span>
          </span>
        </div>
      </div>

      {/* Plans */}
      <div className="grid md:grid-cols-3 gap-8 mb-8">
        {MATH4CHILD_PLANS.map((plan) => (
          <div
            key={plan.id}
            className={`bg-white rounded-2xl shadow-lg p-6 relative ${
              plan.popular ? 'border-2 border-blue-500 transform scale-105' : 'border border-gray-200'
            }`}
            data-testid={`plan-${plan.id}`}
          >
            {plan.popular && (
              <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                <span className="bg-gradient-to-r from-blue-500 to-purple-600 text-white px-4 py-1 rounded-full text-sm font-semibold">
                  ⭐ Populaire
                </span>
              </div>
            )}

            <div className="text-center mb-6">
              <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
              <div className="text-3xl font-bold text-blue-600" data-testid={`price-${plan.id}`}>
                {formatPrice(plan)}
              </div>
              <p className="text-gray-500 text-sm mt-1">
                {getSubPrice(plan)}
              </p>
            </div>

            <ul className="space-y-3 mb-6">
              {plan.features.map((feature, index) => (
                <li key={index} className="flex items-center">
                  <span className="text-green-500 mr-2">✓</span>
                  <span className="text-gray-700">{feature}</span>
                </li>
              ))}
            </ul>

            <button
              onClick={() => handleSubscription(plan)}
              disabled={loading === plan.id}
              className={`w-full py-3 px-4 rounded-xl font-semibold transition-all ${
                plan.popular
                  ? 'bg-gradient-to-r from-blue-500 to-purple-600 text-white hover:from-blue-600 hover:to-purple-700'
                  : 'bg-gray-900 text-white hover:bg-gray-800'
              } disabled:opacity-50 disabled:cursor-not-allowed`}
              data-testid={`test-${plan.id}-button`}
              aria-label={`Tester le ${plan.name}`}
            >
              {loading === plan.id ? (
                <span className="flex items-center justify-center">
                  <span className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></span>
                  Chargement...
                </span>
              ) : (
                `Tester ${plan.name}`
              )}
            </button>
          </div>
        ))}
      </div>

      {/* Cartes de test */}
      <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-6" data-testid="test-cards-section">
        <h3 className="text-lg font-semibold text-yellow-800 mb-4">
          💳 Cartes de test Stripe
        </h3>
        <div className="grid md:grid-cols-2 gap-4 text-sm">
          {TEST_CARDS.map((card, index) => (
            <div key={index} className="mb-2" data-testid={`test-card-${card.expected}`}>
              <strong>{card.type} :</strong>
              <p className="font-mono">{card.number}</p>
              <p className="text-gray-600 text-xs">{card.description}</p>
            </div>
          ))}
        </div>
        <div className="mt-4 p-3 bg-yellow-100 rounded-lg">
          <p className="text-yellow-700 text-sm">
            <strong>Instructions :</strong><br />
            • Date d'expiration : n'importe quelle date future (ex: 12/25)<br />
            • CVC : n'importe quel nombre à 3 chiffres (ex: 123)<br />
            • Nom : n'importe quel nom<br />
            • Adresse : n'importe quelle adresse valide
          </p>
        </div>
      </div>

      {/* Section de debug pour les développeurs */}
      {process.env.NODE_ENV === 'development' && (
        <div className="mt-8 bg-gray-50 border border-gray-200 rounded-lg p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">
            🔧 Debug Info (DEV uniquement)
          </h3>
          <div className="text-sm space-y-2">
            <p><strong>Mode :</strong> {isYearly ? 'Annuel' : 'Mensuel'}</p>
            <p><strong>Loading :</strong> {loading || 'None'}</p>
            <p><strong>Stripe Key :</strong> {process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY?.substring(0, 20)}...</p>
            <p><strong>Environment :</strong> {process.env.NODE_ENV}</p>
          </div>
        </div>
      )}
    </div>
  )
}
