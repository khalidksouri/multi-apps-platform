'use client'

import React from 'react'
import Link from 'next/link'

export default function SubscriptionPage() {
  const plans = [
    { name: 'Gratuit', price: '0€', features: ['50 questions', '1 niveau'] },
    { name: 'Mensuel', price: '9.99€', features: ['Questions illimitées', 'Tous niveaux', 'Support'] },
    { name: 'Annuel', price: '99€', features: ['Tout inclus', 'Économie 20%', 'Support prioritaire'] }
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 p-8">
      <div className="max-w-6xl mx-auto">
        <div className="mb-8">
          <Link href="/" className="text-blue-600 hover:underline">← Retour</Link>
        </div>
        
        <h1 className="text-4xl font-bold text-center text-gray-900 mb-12">
          Choisissez votre formule
        </h1>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {plans.map((plan, index) => (
            <div key={index} className="bg-white rounded-2xl p-8 shadow-xl">
              <h3 className="text-2xl font-bold text-gray-900 mb-4">{plan.name}</h3>
              <div className="text-4xl font-bold text-blue-600 mb-6">{plan.price}</div>
              <ul className="space-y-3 mb-8">
                {plan.features.map((feature, i) => (
                  <li key={i} className="flex items-center">
                    <span className="text-green-500 mr-2">✓</span>
                    {feature}
                  </li>
                ))}
              </ul>
              <button className="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors">
                Choisir
              </button>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
