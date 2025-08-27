'use client';

import React from 'react';

// Plans d'abonnement conformes aux spécifications EXACTES
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
];

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      {/* Header */}
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 py-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl flex items-center justify-center">
                <span className="text-white text-xl font-bold">M4C</span>
              </div>
              <div>
                <h1 className="text-2xl font-bold text-gray-900">Math4Child</h1>
                <p className="text-sm text-gray-600">Révolution Éducative v4.2.0</p>
              </div>
            </div>
            
            <div className="flex items-center gap-4 text-sm text-gray-600">
              <div>🌍 200+ Langues</div>
              <div>👥 Millions d'enfants</div>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="py-20 px-4">
        <div className="max-w-4xl mx-auto text-center">
          <div className="mb-8">
            <div className="inline-flex items-center gap-2 bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm font-medium mb-6">
              ✨ Application Éducative Révolutionnaire
            </div>
            <h2 className="text-5xl font-bold text-gray-900 mb-6">
              L'Avenir de l'Apprentissage
              <span className="block text-blue-600">des Mathématiques</span>
            </h2>
            <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
              6 innovations révolutionnaires • 3 modes d'apprentissage uniques • 
              Support mondial 200+ langues
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-6 mb-12">
            <div className="bg-white p-6 rounded-xl shadow-lg">
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mb-4 mx-auto">
                <span className="text-2xl">⭐</span>
              </div>
              <h3 className="font-semibold text-gray-900 mb-2">6 Innovations</h3>
              <p className="text-sm text-gray-600">Révolutionnaires et 100% opérationnelles</p>
            </div>

            <div className="bg-white p-6 rounded-xl shadow-lg">
              <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mb-4 mx-auto">
                <span className="text-2xl">🌍</span>
              </div>
              <h3 className="font-semibold text-gray-900 mb-2">200+ Langues</h3>
              <p className="text-sm text-gray-600">Accessibilité universelle mondiale</p>
            </div>

            <div className="bg-white p-6 rounded-xl shadow-lg">
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mb-4 mx-auto">
                <span className="text-2xl">🏆</span>
              </div>
              <h3 className="font-semibold text-gray-900 mb-2">Millions d'Enfants</h3>
              <p className="text-sm text-gray-600">Impact éducatif mondial garanti</p>
            </div>
          </div>
        </div>
      </section>

      {/* Plans d'Abonnement */}
      <section className="py-16 px-4 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Plans d'Abonnement Math4Child
            </h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              5 plans d'abonnement conformes aux spécifications. 
              Chaque plan avec le nombre exact de profils requis.
            </p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-5 gap-6">
            {SUBSCRIPTION_PLANS.map((plan) => (
              <div
                key={plan.id}
                className={`bg-white rounded-xl border-2 p-6 relative transition-all hover:shadow-lg ${
                  plan.popular 
                    ? 'border-yellow-400 ring-4 ring-yellow-400 ring-opacity-20 transform scale-105' 
                    : 'border-gray-200'
                }`}
              >
                {plan.badge && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <div className="bg-yellow-400 text-yellow-900 px-3 py-1 rounded-full text-xs font-bold">
                      {plan.badge}
                    </div>
                  </div>
                )}

                <div className="text-center mb-6">
                  <h3 className="text-lg font-bold text-gray-900 mb-2">
                    {plan.name}
                  </h3>
                  <div className="text-2xl font-bold text-blue-600 mb-2">
                    {plan.price}
                    {plan.price !== 'Sur Devis' && <span className="text-sm text-gray-500">/mois</span>}
                  </div>
                  <p className="text-sm text-gray-600">{plan.description}</p>
                </div>

                <div className="space-y-2 mb-6">
                  {plan.features.map((feature, index) => (
                    <div key={index} className="text-sm text-gray-600">
                      {feature}
                    </div>
                  ))}
                </div>

                <button className={`w-full py-2 px-4 rounded-lg font-medium text-sm transition-colors ${
                  plan.popular
                    ? 'bg-blue-600 text-white hover:bg-blue-700'
                    : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                }`}>
                  {plan.price === 'Sur Devis' ? 'Demander un Devis' : 'Choisir ce Plan'}
                </button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Contact */}
      <section className="py-12 px-4 bg-gray-50">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">
            Nous Contacter
          </h2>
          <div className="grid md:grid-cols-2 gap-8">
            <div className="bg-white p-6 rounded-xl shadow-sm">
              <h3 className="font-semibold text-gray-900 mb-2">📧 Support Technique</h3>
              <p className="text-blue-600 font-mono">support@math4child.com</p>
            </div>
            <div className="bg-white p-6 rounded-xl shadow-sm">
              <h3 className="font-semibold text-gray-900 mb-2">💼 Commercial</h3>
              <p className="text-blue-600 font-mono">commercial@math4child.com</p>
            </div>
          </div>
          
          <div className="mt-8 pt-8 border-t border-gray-200">
            <p className="text-sm text-gray-500">
              Math4Child v4.2.0 - La Première Application Éducative Révolutionnaire<br/>
              🌐 Domaine officiel: <span className="text-blue-600 font-mono">www.math4child.com</span><br/>
              🎯 Production Ready - Déploiement Automatisé Réussi
            </p>
          </div>
        </div>
      </section>
    </div>
  );
}
