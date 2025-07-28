'use client'

import { useState } from 'react'
import { 
  CheckCircle, 
  XCircle, 
  AlertTriangle, 
  Clock,
  RefreshCw,
  Copy,
} from 'lucide-react'

// Cartes de test Stripe avec différents scénarios
const TEST_CARDS = [
  {
    number: '4242 4242 4242 4242',
    type: '✅ Succès',
    description: 'Paiement réussi',
    expected: 'success',
    color: 'bg-green-50 border-green-200',
    icon: CheckCircle,
    iconColor: 'text-green-600'
  },
  {
    number: '4000 0000 0000 0002',
    type: '❌ Déclinée',
    description: 'Carte déclinée',
    expected: 'declined',
    color: 'bg-red-50 border-red-200',
    icon: XCircle,
    iconColor: 'text-red-600'
  },
  {
    number: '4000 0000 0000 9995',
    type: '💸 Fonds insuffisants',
    description: 'Solde insuffisant',
    expected: 'insufficient_funds',
    color: 'bg-orange-50 border-orange-200',
    icon: AlertTriangle,
    iconColor: 'text-orange-600'
  },
  {
    number: '4000 0000 0000 0069',
    type: '⏰ Expirée',
    description: 'Carte expirée',
    expected: 'expired_card',
    color: 'bg-yellow-50 border-yellow-200',
    icon: Clock,
    iconColor: 'text-yellow-600'
  },
  {
    number: '4000 0000 0000 0127',
    type: '🔒 CVC incorrect',
    description: 'Code de sécurité invalide',
    expected: 'incorrect_cvc',
    color: 'bg-purple-50 border-purple-200',
    icon: AlertTriangle,
    iconColor: 'text-purple-600'
  },
  {
    number: '4000 0000 0000 0119',
    type: '🔄 Processus échoué',
    description: 'Erreur de traitement',
    expected: 'processing_error',
    color: 'bg-gray-50 border-gray-200',
    icon: RefreshCw,
    iconColor: 'text-gray-600'
  }
]

// Plans de test
const TEST_PLANS = [
  {
    id: 'family',
    name: 'Plan Famille',
    monthlyPrice: 6.99,
    yearlyPrice: 59.90,
    features: ['5 profils enfant', 'Questions illimitées', 'Support prioritaire'],
    popular: true
  },
  {
    id: 'premium',
    name: 'Plan Premium',
    monthlyPrice: 4.99,
    yearlyPrice: 39.90,
    features: ['2 profils enfant', 'Questions illimitées', 'Mode hors-ligne'],
    popular: false
  },
  {
    id: 'school',
    name: 'Plan École',
    monthlyPrice: 24.99,
    yearlyPrice: 199.90,
    features: ['30 élèves', 'Tableau de bord professeur', 'Rapports détaillés'],
    popular: false
  }
]

export default function StripeTestPage() {
  const [isYearly, setIsYearly] = useState(false)
  const [loading, setLoading] = useState<string | null>(null)
  const [testResults, setTestResults] = useState<Record<string, any>>({})

  const copyCardNumber = async (number: string) => {
    try {
      await navigator.clipboard.writeText(number.replace(/\s/g, ''))
      // console.log(`Copié: ${number}`)
    } catch (err) {
      console.error('Erreur lors de la copie:', err)
    }
  }

  const testPayment = async (planId: string, cardType: string) => {
    setLoading(`${planId}-${cardType}`)
    
    try {
      const plan = TEST_PLANS.find(p => p.id === planId)
      if (!plan) throw new Error('Plan non trouvé')

      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          priceId: `price_test_${planId}_${isYearly ? 'yearly' : 'monthly'}`,
          mode: 'subscription',
          testCard: cardType
        }),
      })

      const data = await response.json()
      
      if (response.ok) {
        setTestResults(prev => ({
          ...prev,
          [`${planId}-${cardType}`]: {
            status: 'success',
            sessionId: data.sessionId,
            url: data.url
          }
        }))
        
        window.open(data.url, '_blank')
      } else {
        throw new Error(data.error || 'Erreur inconnue')
      }
    } catch (error) {
      console.error('Erreur test paiement:', error)
      setTestResults(prev => ({
        ...prev,
        [`${planId}-${cardType}`]: {
          status: 'error',
          error: error instanceof Error ? error.message : 'Erreur inconnue'
        }
      }))
    } finally {
      setLoading(null)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 p-6">
      <div className="max-w-7xl mx-auto">
        
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-800 mb-4">
            🧪 Test des Paiements Math4Child
          </h1>
          <p className="text-xl text-gray-600 mb-6">
            Interface de test pour valider les paiements Stripe avec cartes fictives
          </p>
          <div className="inline-flex items-center bg-yellow-100 text-yellow-800 px-4 py-2 rounded-full">
            <AlertTriangle className="w-5 h-5 mr-2" />
            Mode développement - Aucun paiement réel
          </div>
        </div>

        {/* Toggle Mensuel/Annuel */}
        <div className="flex justify-center mb-8">
          <div className="bg-white rounded-lg p-1 shadow-lg">
            <button
              onClick={() => setIsYearly(false)}
              className={`px-6 py-2 rounded-md font-medium transition-all ${
                !isYearly ? 'bg-blue-500 text-white shadow-md' : 'text-gray-600 hover:text-gray-800'
              }`}
            >
              Mensuel
            </button>
            <button
              onClick={() => setIsYearly(true)}
              className={`px-6 py-2 rounded-md font-medium transition-all ${
                isYearly ? 'bg-blue-500 text-white shadow-md' : 'text-gray-600 hover:text-gray-800'
              }`}
            >
              Annuel
              <span className="ml-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full">-30%</span>
            </button>
          </div>
        </div>

        {/* Cartes de Test */}
        <div className="mb-12">
          <h2 className="text-2xl font-bold text-gray-800 mb-6 text-center">💳 Cartes de Test Stripe</h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
            {TEST_CARDS.map((card, index) => {
              const IconComponent = card.icon
              return (
                <div
                  key={index}
                  className={`p-4 rounded-lg border-2 cursor-pointer hover:shadow-lg transition-all ${card.color}`}
                  onClick={() => copyCardNumber(card.number)}
                >
                  <div className="flex items-center justify-between mb-2">
                    <IconComponent className={`w-5 h-5 ${card.iconColor}`} />
                    <Copy className="w-4 h-4 text-gray-400" />
                  </div>
                  <div className="font-bold text-lg mb-1">{card.type}</div>
                  <div className="font-mono text-sm text-gray-600 mb-2">{card.number}</div>
                  <div className="text-xs text-gray-500">{card.description}</div>
                </div>
              )
            })}
          </div>
        </div>

        {/* Plans de Test */}
        <div className="mb-12">
          <h2 className="text-2xl font-bold text-gray-800 mb-6 text-center">📋 Plans de Test</h2>
          <div className="grid md:grid-cols-3 gap-6">
            {TEST_PLANS.map((plan) => (
              <div key={plan.id} className={`bg-white rounded-xl shadow-lg p-6 border-2 ${plan.popular ? 'border-blue-500' : 'border-gray-200'}`}>
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-medium">Populaire</span>
                  </div>
                )}
                
                <div className="text-center mb-6">
                  <h3 className="text-xl font-bold text-gray-800 mb-2">{plan.name}</h3>
                  <div className="text-3xl font-bold text-blue-600 mb-1">
                    €{isYearly ? plan.yearlyPrice : plan.monthlyPrice}
                    <span className="text-sm text-gray-500">/{isYearly ? 'an' : 'mois'}</span>
                  </div>
                  {isYearly && (
                    <div className="text-sm text-green-600">Soit €{(plan.yearlyPrice / 12).toFixed(2)}/mois</div>
                  )}
                </div>

                <ul className="text-sm text-gray-600 mb-6 space-y-2">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-center">
                      <CheckCircle className="w-4 h-4 text-green-500 mr-2" />
                      {feature}
                    </li>
                  ))}
                </ul>

                <div className="space-y-2">
                  <h4 className="font-semibold text-gray-700 text-sm mb-3">Tests par scénario :</h4>
                  {TEST_CARDS.slice(0, 4).map((card) => {
                    const testKey = `${plan.id}-${card.expected}`
                    const result = testResults[testKey]
                    const isLoading = loading === testKey
                    
                    return (
                      <button
                        key={card.expected}
                        onClick={() => testPayment(plan.id, card.expected)}
                        disabled={isLoading}
                        className={`w-full text-left p-2 rounded text-xs border transition-all ${
                          result 
                            ? result.status === 'success'
                              ? 'bg-green-50 border-green-200 text-green-700'
                              : 'bg-red-50 border-red-200 text-red-700'
                            : 'bg-gray-50 border-gray-200 hover:bg-gray-100'
                        } disabled:opacity-50`}
                      >
                        {isLoading ? (
                          <span className="flex items-center">
                            <RefreshCw className="w-3 h-3 animate-spin mr-1" />
                            Test en cours...
                          </span>
                        ) : (
                          <span>
                            {card.type} {result && (result.status === 'success' ? '✅' : '❌')}
                          </span>
                        )}
                      </button>
                    )
                  })}
                </div>
              </div>
            ))}
          </div>
        </div>

      </div>
    </div>
  )
}
