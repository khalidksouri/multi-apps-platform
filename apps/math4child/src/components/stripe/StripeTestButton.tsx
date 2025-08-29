// =============================================================================
// 🧪 COMPOSANT TEST STRIPE - MATH4CHILD v4.2.0
// =============================================================================

'use client'

import React, { useState } from 'react'
import { useStripe, usePlans } from '@/hooks/useStripe'
import { formatPrice } from '@/lib/stripe'
import { STRIPE_TEST_CARDS } from '@/types/stripe'

interface StripeTestButtonProps {
  className?: string
  showTestCards?: boolean
}

export default function StripeTestButton({ 
  className = '', 
  showTestCards = true 
}: StripeTestButtonProps) {
  const { loading, error, createCheckoutForPlan, clearError } = useStripe()
  const { plans } = usePlans()
  const [selectedPlan, setSelectedPlan] = useState<string>('premium')
  const [testEmail, setTestEmail] = useState<string>('test@math4child.com')

  const handleTest = async (planId: string) => {
    clearError()
    console.log(`🧪 Test checkout pour plan: ${planId}`)
    await createCheckoutForPlan(planId, testEmail)
  }

  const handleQuickTest = async () => {
    await handleTest(selectedPlan)
  }

  return (
    <div className={`stripe-test-container ${className}`}>
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-500 to-purple-600 text-white p-6 rounded-t-lg">
        <h2 className="text-2xl font-bold flex items-center gap-2">
          🧪 Tests Stripe Math4Child
          <span className="text-sm bg-white/20 px-2 py-1 rounded">v4.2.0</span>
        </h2>
        <p className="text-blue-100 mt-2">
          Interface de test pour l'intégration des abonnements
        </p>
      </div>

      {/* Configuration du test */}
      <div className="bg-white p-6 border-x border-gray-200">
        <div className="flex flex-col sm:flex-row gap-4 mb-4">
          <div className="flex-1">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Email de test
            </label>
            <input
              type="email"
              value={testEmail}
              onChange={(e) => setTestEmail(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="test@math4child.com"
            />
          </div>
          
          <div className="flex-1">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Plan à tester
            </label>
            <select
              value={selectedPlan}
              onChange={(e) => setSelectedPlan(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              {plans.map((plan) => (
                <option key={plan.id} value={plan.id}>
                  {plan.name} - {formatPrice(plan.price, plan.currency)}
                </option>
              ))}
            </select>
          </div>
        </div>

        <button
          onClick={handleQuickTest}
          disabled={loading}
          className="w-full bg-blue-500 hover:bg-blue-600 disabled:bg-gray-400 
                     text-white font-semibold py-3 px-6 rounded-lg transition-colors
                     disabled:cursor-not-allowed flex items-center justify-center gap-2"
        >
          {loading ? (
            <>
              <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
                <circle cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" className="opacity-25"/>
                <path fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" className="opacity-75"/>
              </svg>
              Test en cours...
            </>
          ) : (
            <>
              🚀 Tester le checkout
            </>
          )}
        </button>
      </div>

      {/* Messages d'erreur */}
      {error && (
        <div className="bg-red-50 border-x border-red-200 px-6 py-4">
          <div className="flex items-start gap-3">
            <div className="text-red-500 text-xl">❌</div>
            <div>
              <h3 className="text-red-800 font-semibold">Erreur de test</h3>
              <p className="text-red-700 text-sm mt-1">{error}</p>
              <button
                onClick={clearError}
                className="text-red-600 hover:text-red-800 text-sm underline mt-2"
              >
                Effacer l'erreur
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Tests par plan */}
      <div className="bg-white p-6 border-x border-gray-200">
        <h3 className="text-lg font-semibold text-gray-800 mb-4">
          Tests par plan individual
        </h3>
        
        <div className="grid gap-4">
          {plans.map((plan) => (
            <div key={plan.id} className="border rounded-lg p-4 hover:bg-gray-50">
              <div className="flex justify-between items-start">
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-2">
                    <h4 className="text-lg font-semibold text-gray-900">
                      {plan.name}
                    </h4>
                    {plan.popular && (
                      <span className="bg-orange-100 text-orange-800 text-xs px-2 py-1 rounded-full">
                        {plan.badge || 'POPULAIRE'}
                      </span>
                    )}
                  </div>
                  
                  <p className="text-gray-600 text-sm mb-2">{plan.description}</p>
                  
                  <div className="flex items-center gap-4 text-sm text-gray-500">
                    <span className="font-semibold text-lg text-gray-900">
                      {formatPrice(plan.price, plan.currency)}/{plan.interval}
                    </span>
                    <span>{plan.profiles} profil{plan.profiles > 1 ? 's' : ''}</span>
                  </div>
                </div>
                
                <button
                  onClick={() => handleTest(plan.id)}
                  disabled={loading}
                  className="bg-gray-100 hover:bg-blue-100 hover:text-blue-700 
                           disabled:bg-gray-50 disabled:text-gray-400
                           text-gray-700 px-4 py-2 rounded-lg transition-colors
                           disabled:cursor-not-allowed text-sm font-medium"
                >
                  {loading ? 'Test...' : `Tester ${plan.name}`}
                </button>
              </div>
              
              {/* Features */}
              <div className="mt-3 pt-3 border-t border-gray-100">
                <div className="flex flex-wrap gap-1">
                  {plan.features.slice(0, 3).map((feature, index) => (
                    <span
                      key={index}
                      className="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded"
                    >
                      {feature}
                    </span>
                  ))}
                  {plan.features.length > 3 && (
                    <span className="text-xs text-gray-500 px-2 py-1">
                      +{plan.features.length - 3} autres
                    </span>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Cartes de test */}
      {showTestCards && (
        <div className="bg-gray-50 p-6 border-x border-gray-200 rounded-b-lg">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">
            💳 Cartes de test Stripe
          </h3>
          
          <div className="grid gap-2 text-sm">
            {STRIPE_TEST_CARDS.map((card, index) => (
              <div key={index} className="flex justify-between items-center p-2 bg-white rounded border">
                <div className="flex items-center gap-3">
                  <span className={`w-2 h-2 rounded-full ${
                    card.expected === 'success' ? 'bg-green-500' : 'bg-red-500'
                  }`} />
                  <code className="font-mono text-xs bg-gray-100 px-2 py-1 rounded">
                    {card.number}
                  </code>
                  <span className="text-gray-600">{card.description}</span>
                </div>
                <div className="text-xs text-gray-500">
                  CVC: {card.cvc} | {card.exp_month}/{card.exp_year}
                </div>
              </div>
            ))}
          </div>
          
          <div className="mt-4 p-3 bg-blue-50 border border-blue-200 rounded text-sm">
            <div className="flex items-start gap-2">
              <span className="text-blue-500">💡</span>
              <div>
                <strong className="text-blue-800">Conseil :</strong>
                <span className="text-blue-700 ml-1">
                  Utilisez ces cartes dans le formulaire de paiement Stripe pour tester différents scénarios.
                  La première carte (4242...) est recommandée pour les tests de base.
                </span>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
