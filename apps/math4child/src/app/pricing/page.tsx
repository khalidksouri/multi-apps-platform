"use client"

import Navigation from '@/components/navigation/Navigation'
import { BillingOptions } from '@/components/pricing/BillingOptions'
import { pricingPlans } from '@/data/pricing'

export default function PricingPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
      <Navigation />
      <div className="container mx-auto px-4 py-16">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-800 mb-4">
            💎 Plans Math4Child v4.2.0
          </h1>
          <p className="text-xl text-gray-600">
            Choisissez le plan parfait pour votre révolution éducative
          </p>
        </div>

        <BillingOptions />

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-8">
          {pricingPlans.map((plan) => (
            <div 
              key={plan.id}
              className={`bg-white rounded-xl p-6 shadow-lg border-2 ${
                plan.popular ? 'border-purple-400 relative' : 'border-gray-200'
              }`}
            >
              {plan.popular && (
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-purple-500 text-white px-4 py-1 rounded-full text-sm font-bold">
                  ⭐ POPULAIRE
                </div>
              )}
              
              <div className="text-center mb-6">
                <div className="text-4xl mb-3">{plan.icon}</div>
                <h3 className="text-2xl font-bold text-gray-800">{plan.name}</h3>
                <p className="text-gray-600 mb-4">{plan.description}</p>
                <div className="text-3xl font-bold text-blue-600">
                  {plan.price.monthly}€<span className="text-lg text-gray-500">/mois</span>
                </div>
              </div>

              <ul className="space-y-3 mb-6">
                {plan.features.map((feature, index) => (
                  <li key={index} className="flex items-center text-sm">
                    <span className="text-green-500 mr-2">✓</span>
                    {feature}
                  </li>
                ))}
              </ul>

              <button className={`w-full py-3 rounded-lg font-semibold transition-colors ${
                plan.popular 
                  ? 'bg-purple-500 text-white hover:bg-purple-600'
                  : 'bg-gray-100 text-gray-800 hover:bg-gray-200'
              }`}>
                Choisir {plan.name}
              </button>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
