'use client'

import React from 'react'
import { MATH4CHILD_PLANS, formatPrice } from '@/lib/stripe'

export default function PlanComparison() {
  const features = [
    { name: 'Profils enfants', basic: '1', premium: '3', ultimate: '10' },
    { name: 'Exercices disponibles', basic: '100+', premium: '500+', ultimate: 'Illimité' },
    { name: 'Niveaux de difficulté', basic: '5', premium: 'Tous', ultimate: 'Tous' },
    { name: 'IA Adaptative', basic: false, premium: true, ultimate: true },
    { name: 'Reconnaissance manuscrite', basic: false, premium: true, ultimate: true },
    { name: 'Assistant vocal', basic: false, premium: true, ultimate: true },
    { name: 'Réalité augmentée 3D', basic: false, premium: false, ultimate: true },
    { name: 'Mode hors-ligne', basic: 'Basique', premium: 'Avancé', ultimate: 'Complet' },
    { name: 'Rapports parents', basic: 'Basique', premium: 'Détaillés', ultimate: 'Personnalisés' },
    { name: 'Support', basic: 'Communauté', premium: 'Email', ultimate: '24/7' },
    { name: 'API pour écoles', basic: false, premium: false, ultimate: true },
  ]

  const renderFeatureValue = (value: string | boolean) => {
    if (typeof value === 'boolean') {
      return value ? (
        <span className="text-green-600 text-xl">✓</span>
      ) : (
        <span className="text-gray-300 text-xl">✗</span>
      )
    }
    return <span className="text-gray-900 font-medium">{value}</span>
  }

  return (
    <div className="max-w-6xl mx-auto px-4 py-16">
      <div className="text-center mb-12">
        <h2 className="text-3xl font-bold text-gray-900 mb-4">
          Comparaison détaillée des plans
        </h2>
        <p className="text-lg text-gray-600">
          Trouvez le plan qui correspond parfaitement à vos besoins
        </p>
      </div>

      <div className="overflow-x-auto shadow-xl rounded-2xl">
        <table className="w-full bg-white">
          <thead>
            <tr className="bg-gray-50">
              <th className="px-6 py-8 text-left">
                <div className="text-lg font-semibold text-gray-900">
                  Fonctionnalités
                </div>
              </th>
              {MATH4CHILD_PLANS.map((plan) => (
                <th key={plan.id} className="px-6 py-8 text-center">
                  <div className="space-y-2">
                    <div className="text-xl font-bold text-gray-900">
                      {plan.name}
                    </div>
                    <div className="text-2xl font-bold text-blue-600">
                      {formatPrice(plan.price, plan.currency)}
                      <span className="text-sm text-gray-500 font-normal">
                        /{plan.interval}
                      </span>
                    </div>
                  </div>
                </th>
              ))}
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {features.map((feature, index) => (
              <tr key={index} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}>
                <td className="px-6 py-4 font-medium text-gray-900">
                  {feature.name}
                </td>
                <td className="px-6 py-4 text-center">
                  {renderFeatureValue(feature.basic)}
                </td>
                <td className="px-6 py-4 text-center">
                  {renderFeatureValue(feature.premium)}
                </td>
                <td className="px-6 py-4 text-center">
                  {renderFeatureValue(feature.ultimate)}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="mt-12 text-center">
        <div className="bg-blue-50 border border-blue-200 rounded-xl p-6 max-w-4xl mx-auto">
          <h3 className="text-xl font-semibold text-blue-900 mb-2">
            Garantie de satisfaction 30 jours
          </h3>
          <p className="text-blue-800">
            Pas satisfait ? Nous vous remboursons intégralement sous 30 jours, 
            sans questions ni conditions.
          </p>
        </div>
      </div>
    </div>
  )
}
