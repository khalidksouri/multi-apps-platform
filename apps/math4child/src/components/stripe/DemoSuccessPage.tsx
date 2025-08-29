// =============================================================================
// 🧪 PAGE SUCCÈS DÉMO - MATH4CHILD v4.2.0
// =============================================================================

'use client'

import React, { useEffect, useState } from 'react'
import { useSearchParams } from 'next/navigation'
import { formatPrice, getPlanById } from '@/lib/stripe'

export default function DemoSuccessPage() {
  const searchParams = useSearchParams()
  const [planDetails, setPlanDetails] = useState<any>(null)

  useEffect(() => {
    const planId = searchParams.get('plan')
    const amount = searchParams.get('amount')
    const name = searchParams.get('name')

    if (planId) {
      const plan = getPlanById(planId)
      setPlanDetails({
        ...plan,
        amount: amount ? parseInt(amount) : plan?.price,
        displayName: name ? decodeURIComponent(name) : plan?.name
      })
    }
  }, [searchParams])

  if (!planDetails) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto"></div>
          <p className="mt-4 text-gray-600">Chargement...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-12">
      <div className="max-w-md mx-auto bg-white rounded-lg shadow-lg overflow-hidden">
        {/* Header Success */}
        <div className="bg-green-500 text-white p-6 text-center">
          <div className="text-6xl mb-4">🎉</div>
          <h1 className="text-2xl font-bold">Paiement Simulé Réussi !</h1>
          <p className="text-green-100 mt-2">Mode démo Math4Child</p>
        </div>

        {/* Plan Details */}
        <div className="p-6">
          <div className="text-center mb-6">
            <h2 className="text-xl font-semibold text-gray-800">
              Plan {planDetails.displayName}
            </h2>
            <p className="text-3xl font-bold text-blue-600 mt-2">
              {formatPrice(planDetails.amount, planDetails.currency || 'eur')}
              <span className="text-sm font-normal text-gray-500">/{planDetails.interval}</span>
            </p>
          </div>

          <div className="bg-gray-50 rounded-lg p-4 mb-6">
            <h3 className="font-semibold text-gray-800 mb-3">✨ Fonctionnalités incluses :</h3>
            <ul className="space-y-2">
              {planDetails.features?.map((feature: string, index: number) => (
                <li key={index} className="flex items-center gap-2 text-sm text-gray-700">
                  <span className="text-green-500">✓</span>
                  {feature}
                </li>
              ))}
            </ul>
          </div>

          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
            <div className="flex items-start gap-2">
              <span className="text-blue-500 text-lg">🧪</span>
              <div className="text-sm">
                <strong className="text-blue-800">Mode Démo Actif</strong>
                <p className="text-blue-700 mt-1">
                  Ceci est une simulation. Aucun paiement réel n'a été effectué. 
                  Pour les vrais paiements, configurez vos clés Stripe de production.
                </p>
              </div>
            </div>
          </div>

          {/* Actions */}
          <div className="flex gap-3">
            <button
              onClick={() => window.location.href = '/'}
              className="flex-1 bg-blue-500 hover:bg-blue-600 text-white py-3 px-4 rounded-lg font-semibold transition-colors"
            >
              🏠 Retour à l'accueil
            </button>
            <button
              onClick={() => window.location.href = '/pricing'}
              className="flex-1 bg-gray-200 hover:bg-gray-300 text-gray-800 py-3 px-4 rounded-lg font-semibold transition-colors"
            >
              🔄 Nouveaux tests
            </button>
          </div>
        </div>

        {/* Footer */}
        <div className="bg-gray-50 px-6 py-4 text-center text-xs text-gray-500">
          Math4Child v4.2.0 - Tests d'intégration Stripe
        </div>
      </div>
    </div>
  )
}
