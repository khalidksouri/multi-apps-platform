'use client'

import React from 'react'
import { useStripe } from '@/hooks/useStripe'
import { MATH4CHILD_PLANS, formatPrice } from '@/lib/stripe'

export default function PricingCards() {
  const { loading, error, createCheckoutForPlan, clearError } = useStripe()

  const handleSelectPlan = async (planId: string) => {
    clearError()
    await createCheckoutForPlan(planId, 'user@example.com')
  }

  const getPlanColor = (planId: string) => {
    switch (planId) {
      case 'basic': return 'blue'
      case 'premium': return 'green'
      case 'ultimate': return 'purple'
      default: return 'gray'
    }
  }

  const getPlanButtonColor = (planId: string) => {
    switch (planId) {
      case 'basic': return 'bg-blue-500 hover:bg-blue-600'
      case 'premium': return 'bg-green-500 hover:bg-green-600'
      case 'ultimate': return 'bg-purple-500 hover:bg-purple-600'
      default: return 'bg-gray-500 hover:bg-gray-600'
    }
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-16">
      <div className="text-center mb-16">
        <h2 className="text-4xl font-bold text-gray-900 mb-4">
          Choisissez votre plan Math4Child
        </h2>
        <p className="text-xl text-gray-600 max-w-3xl mx-auto">
          Révolutionnez l'apprentissage des mathématiques avec notre IA adaptative, 
          reconnaissance manuscrite et assistant vocal personnalisé
        </p>
      </div>

      {error && (
        <div className="max-w-md mx-auto mb-8 bg-red-50 border border-red-200 rounded-lg p-4">
          <div className="flex items-center">
            <div className="text-red-400 mr-3">❌</div>
            <div>
              <h3 className="text-red-800 font-semibold">Erreur de paiement</h3>
              <p className="text-red-700 text-sm mt-1">{error}</p>
            </div>
          </div>
        </div>
      )}

      <div className="grid md:grid-cols-3 gap-8 lg:gap-12">
        {MATH4CHILD_PLANS.map((plan, index) => (
          <div
            key={plan.id}
            className={`relative bg-white rounded-2xl shadow-xl overflow-hidden ${
              plan.popular ? 'ring-4 ring-green-400 scale-105' : ''
            }`}
          >
            {plan.popular && (
              <div className="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
                <span className="bg-green-500 text-white px-4 py-2 rounded-full text-sm font-semibold">
                  LE PLUS CHOISI
                </span>
              </div>
            )}

            <div className="p-8">
              {/* Header */}
              <div className="text-center mb-8">
                <h3 className="text-2xl font-bold text-gray-900 mb-2">
                  {plan.name}
                </h3>
                <p className="text-gray-600 mb-4">{plan.description}</p>
                <div className="mb-4">
                  <span className="text-5xl font-bold text-gray-900">
                    {formatPrice(plan.price, plan.currency)}
                  </span>
                  <span className="text-gray-600 ml-2">/{plan.interval}</span>
                </div>
                <p className="text-sm text-gray-500">
                  {plan.profiles} profil{plan.profiles > 1 ? 's' : ''} inclus
                </p>
              </div>

              {/* Features */}
              <div className="mb-8">
                <ul className="space-y-3">
                  {plan.features.map((feature, idx) => (
                    <li key={idx} className="flex items-start">
                      <span className={`text-${getPlanColor(plan.id)}-500 mr-3 mt-0.5 flex-shrink-0`}>
                        ✓
                      </span>
                      <span className="text-gray-700 text-sm">{feature}</span>
                    </li>
                  ))}
                </ul>
              </div>

              {/* Button */}
              <button
                onClick={() => handleSelectPlan(plan.id)}
                disabled={loading}
                className={`w-full py-4 px-6 rounded-xl font-semibold text-white transition-all duration-200 ${getPlanButtonColor(
                  plan.id
                )} disabled:opacity-50 disabled:cursor-not-allowed transform hover:scale-105`}
              >
                {loading ? (
                  <span className="flex items-center justify-center">
                    <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                      <path className="opacity-75" fill="currentColor" d="m4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Chargement...
                  </span>
                ) : (
                  'Choisir ce plan'
                )}
              </button>
            </div>

            {/* Premium highlight */}
            {plan.popular && (
              <div className="absolute inset-0 bg-gradient-to-r from-green-400/5 to-blue-400/5 pointer-events-none" />
            )}
          </div>
        ))}
      </div>

      {/* Enterprise section */}
      <div className="mt-16 text-center">
        <div className="bg-gray-50 rounded-2xl p-8 max-w-4xl mx-auto">
          <h3 className="text-2xl font-bold text-gray-900 mb-4">
            Besoin d'une solution sur mesure ?
          </h3>
          <p className="text-gray-600 mb-6 max-w-2xl mx-auto">
            Pour les établissements scolaires, entreprises ou familles nombreuses, 
            nous proposons des solutions personnalisées avec API dédiée, 
            formation incluse et support prioritaire.
          </p>
          
          <div className="grid md:grid-cols-2 gap-6 mb-8">
            <div className="text-left">
              <h4 className="font-semibold text-gray-900 mb-3">Fonctionnalités Enterprise</h4>
              <ul className="space-y-2">
                <li className="flex items-center text-gray-700">
                  <span className="text-green-500 mr-2">✓</span>
                  Profils illimités
                </li>
                <li className="flex items-center text-gray-700">
                  <span className="text-green-500 mr-2">✓</span>
                  API personnalisée
                </li>
                <li className="flex items-center text-gray-700">
                  <span className="text-green-500 mr-2">✓</span>
                  Formation dédiée
                </li>
                <li className="flex items-center text-gray-700">
                  <span className="text-green-500 mr-2">✓</span>
                  Support 24/7
                </li>
              </ul>
            </div>
            <div className="text-left">
              <h4 className="font-semibold text-gray-900 mb-3">Support avancé</h4>
              <ul className="space-y-2">
                <li className="flex items-center text-gray-700">
                  <span className="text-green-500 mr-2">✓</span>
                  Intégration sur mesure
                </li>
                <li className="flex items-center text-gray-700">
                  <span className="text-green-500 mr-2">✓</span>
                  Rapports détaillés
                </li>
                <li className="flex items-center text-gray-700">
                  <span className="text-green-500 mr-2">✓</span>
                  SLA garanti
                </li>
                <li className="flex items-center text-gray-700">
                  <span className="text-green-500 mr-2">✓</span>
                  Devis personnalisé
                </li>
              </ul>
            </div>
          </div>

          <button className="bg-gray-900 hover:bg-gray-800 text-white px-8 py-4 rounded-xl font-semibold transition-colors">
            Demander un devis
          </button>
        </div>
      </div>

      {/* FAQ Section */}
      <div className="mt-16">
        <h3 className="text-2xl font-bold text-center text-gray-900 mb-8">
          Questions fréquentes
        </h3>
        <div className="max-w-3xl mx-auto space-y-6">
          <div className="bg-white rounded-lg p-6 shadow-md">
            <h4 className="font-semibold text-gray-900 mb-2">
              Puis-je changer de plan à tout moment ?
            </h4>
            <p className="text-gray-600">
              Oui, vous pouvez upgrader ou downgrader votre plan à tout moment. 
              Les changements prennent effet immédiatement avec un prorata automatique.
            </p>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-md">
            <h4 className="font-semibold text-gray-900 mb-2">
              Y a-t-il une période d'essai gratuite ?
            </h4>
            <p className="text-gray-600">
              Tous nos plans incluent une période d'essai gratuite de 14 jours. 
              Aucun engagement, annulation possible à tout moment.
            </p>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-md">
            <h4 className="font-semibold text-gray-900 mb-2">
              Les données sont-elles sécurisées ?
            </h4>
            <p className="text-gray-600">
              Absolument. Nous utilisons un chiffrement de niveau bancaire et sommes 
              conformes RGPD. Vos données ne sont jamais partagées avec des tiers.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
