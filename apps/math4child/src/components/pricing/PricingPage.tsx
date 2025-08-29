'use client'

import React, { useState } from 'react'
import PricingCards from './PricingCards'
import PlanComparison from './PlanComparison'

export default function PricingPage() {
  const [showComparison, setShowComparison] = useState(false)

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Hero Section */}
      <div className="relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-blue-600/10 to-purple-600/10" />
        <div className="relative max-w-7xl mx-auto px-4 py-24">
          <div className="text-center">
            <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
              Révolutionnez l'apprentissage 
              <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                {' '}des mathématiques
              </span>
            </h1>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
              Intelligence artificielle adaptative, reconnaissance manuscrite et assistant vocal 
              pour transformer l'éducation mathématique de vos enfants
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
              <button
                onClick={() => setShowComparison(!showComparison)}
                className="px-6 py-3 bg-white border border-gray-300 text-gray-700 rounded-lg font-medium hover:bg-gray-50 transition-colors"
              >
                {showComparison ? 'Voir les plans' : 'Comparer les fonctionnalités'}
              </button>
              <div className="text-sm text-gray-500">
                Essai gratuit 14 jours • Sans engagement
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Stats Section */}
      <div className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
            <div>
              <div className="text-3xl font-bold text-blue-600 mb-2">200+</div>
              <div className="text-gray-600">Langues supportées</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-green-600 mb-2">95%</div>
              <div className="text-gray-600">Taux de satisfaction</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-purple-600 mb-2">50k+</div>
              <div className="text-gray-600">Enfants accompagnés</div>
            </div>
            <div>
              <div className="text-3xl font-bold text-orange-600 mb-2">4.9/5</div>
              <div className="text-gray-600">Note moyenne</div>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      {showComparison ? <PlanComparison /> : <PricingCards />}

      {/* Trust Indicators */}
      <div className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4">
          <div className="text-center mb-12">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">
              Ils nous font confiance
            </h2>
            <p className="text-gray-600">
              Utilisé par des milliers de familles et établissements scolaires
            </p>
          </div>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8 items-center opacity-60">
            <div className="text-center">
              <div className="bg-white rounded-lg p-6 shadow-sm">
                <div className="text-2xl font-bold text-gray-800">École 42</div>
              </div>
            </div>
            <div className="text-center">
              <div className="bg-white rounded-lg p-6 shadow-sm">
                <div className="text-2xl font-bold text-gray-800">Epitech</div>
              </div>
            </div>
            <div className="text-center">
              <div className="bg-white rounded-lg p-6 shadow-sm">
                <div className="text-2xl font-bold text-gray-800">Supinfo</div>
              </div>
            </div>
            <div className="text-center">
              <div className="bg-white rounded-lg p-6 shadow-sm">
                <div className="text-2xl font-bold text-gray-800">CNAM</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Security Section */}
      <div className="py-16 bg-white">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-8">
            Sécurité et confidentialité garanties
          </h2>
          <div className="grid md:grid-cols-3 gap-8">
            <div className="space-y-4">
              <div className="w-16 h-16 mx-auto bg-green-100 rounded-full flex items-center justify-center">
                <span className="text-2xl">🔒</span>
              </div>
              <h3 className="font-semibold text-gray-900">Chiffrement bancaire</h3>
              <p className="text-gray-600 text-sm">
                Vos données sont protégées par un chiffrement de niveau bancaire
              </p>
            </div>
            <div className="space-y-4">
              <div className="w-16 h-16 mx-auto bg-blue-100 rounded-full flex items-center justify-center">
                <span className="text-2xl">🛡️</span>
              </div>
              <h3 className="font-semibold text-gray-900">RGPD Conforme</h3>
              <p className="text-gray-600 text-sm">
                Conformité totale avec les réglementations européennes
              </p>
            </div>
            <div className="space-y-4">
              <div className="w-16 h-16 mx-auto bg-purple-100 rounded-full flex items-center justify-center">
                <span className="text-2xl">⚡</span>
              </div>
              <h3 className="font-semibold text-gray-900">Disponibilité 99.9%</h3>
              <p className="text-gray-600 text-sm">
                Service hautement disponible avec SLA garanti
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
