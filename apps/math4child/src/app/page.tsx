'use client'

import { useState } from 'react'

const SUBSCRIPTION_PLANS = [
  {
    id: 'basic',
    name: 'BASIC',
    price: '4.99€',
    profiles: 1,
    description: '1 Profil',
    features: [
      '✓ 1 profil utilisateur unique',
      '✓ 5 niveaux de progression',
      '✓ 100 bonnes réponses minimum par niveau',
      '✓ 5 opérations mathématiques',
      '✓ Support communautaire'
    ]
  },
  {
    id: 'standard',
    name: 'STANDARD',
    price: '9.99€',
    profiles: 2,
    description: '2 Profils',
    features: [
      '✓ 2 profils utilisateur',
      '✓ Toutes fonctionnalités BASIC',
      '✓ IA Adaptative avancée',
      '✓ Reconnaissance manuscrite',
      '✓ Support prioritaire'
    ]
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    price: '14.99€',
    profiles: 3,
    description: '3 Profils',
    popular: true,
    badge: 'LE PLUS CHOISI',
    features: [
      '✓ 3 profils utilisateur',
      '✓ Toutes fonctionnalités STANDARD',
      '✓ Assistant vocal IA',
      '✓ Réalité augmentée 3D',
      '✓ Analytics avancées'
    ]
  },
  {
    id: 'famille',
    name: 'FAMILLE',
    price: '19.99€',
    profiles: 5,
    description: '5 Profils',
    features: [
      '✓ 5 profils utilisateur',
      '✓ Toutes fonctionnalités PREMIUM',
      '✓ Rapports familiaux complets',
      '✓ Contrôle parental avancé',
      '✓ Support VIP 24h/24'
    ]
  },
  {
    id: 'ultimate',
    name: 'ULTIMATE',
    price: 'Sur Devis',
    profiles: 10,
    description: '10+ Profils (Sans Limite)',
    features: [
      '✓ 10+ profils utilisateur (sans limite)',
      '✓ Devis personnalisé selon besoins',
      '✓ API développeur complète',
      '✓ Fonctionnalités école/institution',
      '✓ Support dédié 24/7'
    ]
  }
]

export default function HomePage() {
  const [selectedPlan, setSelectedPlan] = useState<string | null>(null)

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      {/* Section Hero */}
      <section className="py-20 px-4 text-center">
        <div className="max-w-4xl mx-auto">
          <div className="mb-8">
            <span className="inline-block px-4 py-2 bg-blue-100 text-blue-800 rounded-full text-sm font-medium mb-4">
              ⭐ Application Éducative Révolutionnaire
            </span>
          </div>
          
          <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
            L'Avenir de l'Apprentissage
            <br />
            <span className="text-blue-600">des Mathématiques</span>
          </h1>
          
          <p className="text-xl text-gray-600 mb-12 max-w-3xl mx-auto">
            6 innovations révolutionnaires • 3 modes d'apprentissage uniques •<br />
            Support mondial 200+ langues
          </p>
          
          {/* Cards innovations */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
            <div className="bg-white rounded-2xl p-8 shadow-lg">
              <div className="w-16 h-16 bg-yellow-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <span className="text-2xl">⭐</span>
              </div>
              <h3 className="text-xl font-bold mb-2">6 Innovations</h3>
              <p className="text-gray-600">Révolutionnaires et 100% opérationnelles</p>
            </div>
            
            <div className="bg-white rounded-2xl p-8 shadow-lg">
              <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <span className="text-2xl">🌍</span>
              </div>
              <h3 className="text-xl font-bold mb-2">200+ Langues</h3>
              <p className="text-gray-600">Accessibilité universelle mondiale</p>
            </div>
            
            <div className="bg-white rounded-2xl p-8 shadow-lg">
              <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <span className="text-2xl">🏆</span>
              </div>
              <h3 className="text-xl font-bold mb-2">Millions d'Enfants</h3>
              <p className="text-gray-600">Impact éducatif mondial garanti</p>
            </div>
          </div>
        </div>
      </section>

      {/* Section Plans */}
      <section className="py-20 px-4 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">
              Plans d'Abonnement Math4Child
            </h2>
            <p className="text-xl text-gray-600">
              5 plans d'abonnement conformes aux spécifications. Chaque plan avec le nombre exact
              <br />de profils requis.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-6">
            {SUBSCRIPTION_PLANS.map((plan) => (
              <div
                key={plan.id}
                className={`rounded-2xl p-6 shadow-lg transition-all duration-300 hover:shadow-xl ${
                  plan.popular 
                    ? 'bg-gradient-to-b from-blue-600 to-blue-700 text-white relative border-2 border-blue-500' 
                    : 'bg-white border border-gray-200'
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-yellow-400 text-blue-900 px-3 py-1 rounded-full text-sm font-bold">
                      {plan.badge}
                    </span>
                  </div>
                )}
                
                <div className="text-center">
                  <h3 className={`text-xl font-bold mb-2 ${plan.popular ? 'text-white' : 'text-gray-900'}`}>
                    {plan.name}
                  </h3>
                  <div className={`text-3xl font-bold mb-2 ${plan.popular ? 'text-white' : 'text-gray-900'}`}>
                    {plan.price}
                    {plan.price !== 'Sur Devis' && <span className="text-sm font-normal">/mois</span>}
                  </div>
                  <p className={`mb-6 ${plan.popular ? 'text-blue-100' : 'text-gray-600'}`}>
                    {plan.description}
                  </p>
                  
                  <ul className="space-y-3 mb-6">
                    {plan.features.map((feature, index) => (
                      <li key={index} className={`text-sm ${plan.popular ? 'text-blue-50' : 'text-gray-600'}`}>
                        {feature}
                      </li>
                    ))}
                  </ul>
                  
                  <button
                    onClick={() => setSelectedPlan(plan.id)}
                    className={`w-full py-3 px-4 rounded-lg font-medium transition-colors ${
                      plan.popular 
                        ? 'bg-white text-blue-600 hover:bg-gray-100' 
                        : 'bg-blue-600 text-white hover:bg-blue-700'
                    }`}
                  >
                    Choisir ce plan
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
    </div>
  )
}
