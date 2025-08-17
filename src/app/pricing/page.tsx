"use client"

import Link from 'next/link'
import { Check, Star, Crown, Zap, BookOpen } from 'lucide-react'

export default function PricingPage() {
  const plans = [
    {
      id: 'basic',
      name: 'BASIC',
      price: '4.99',
      profiles: 1,
      badge: null,
      features: [
        '1 profil utilisateur unique',
        '5 niveaux de progression',
        '100 bonnes réponses minimum par niveau',
        '5 opérations mathématiques',
        'Support communautaire'
      ]
    },
    {
      id: 'standard',
      name: 'STANDARD',
      price: '9.99',
      profiles: 2,
      badge: null,
      features: [
        '2 profils utilisateur',
        'Toutes fonctionnalités BASIC',
        'IA Adaptative avancée',
        'Reconnaissance manuscrite',
        'Support prioritaire'
      ]
    },
    {
      id: 'premium',
      name: 'PREMIUM',
      price: '14.99',
      profiles: 3,
      badge: 'LE PLUS CHOISI',
      popular: true,
      features: [
        '3 profils utilisateur',
        'Toutes fonctionnalités STANDARD',
        'Assistant vocal IA',
        'Réalité augmentée 3D',
        'Analytics avancées',
        'Personnalisation complète'
      ]
    },
    {
      id: 'famille',
      name: 'FAMILLE',
      price: '19.99',
      profiles: 5,
      badge: null,
      features: [
        '5 profils utilisateur',
        'Toutes fonctionnalités PREMIUM',
        'Rapports familiaux',
        'Contrôle parental avancé',
        'Support VIP prioritaire'
      ]
    },
    {
      id: 'ultimate',
      name: 'ULTIMATE',
      price: 'Sur devis',
      profiles: 10,
      badge: null,
      features: [
        '10+ profils (sans limite)',
        'API développeur',
        'Fonctionnalités école/institution',
        'Support dédié 24/7',
        'Formation équipes',
        'SLA personnalisé'
      ]
    }
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="container mx-auto px-4 py-4">
          <div className="flex justify-between items-center">
            <Link href="/" className="flex items-center space-x-2">
              <BookOpen className="w-8 h-8 text-blue-600" />
              <span className="text-xl font-bold text-gray-800">Math4Child</span>
              <span className="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full">v4.2.0</span>
            </Link>
            
            <nav className="hidden md:flex items-center space-x-6">
              <Link href="/" className="text-gray-600 hover:text-blue-600 transition-colors">
                Accueil
              </Link>
              <Link href="/exercises" className="text-gray-600 hover:text-blue-600 transition-colors">
                Exercices
              </Link>
              <Link href="/pricing" className="text-blue-600 font-medium">
                Abonnements
              </Link>
            </nav>
          </div>
        </div>
      </header>

      {/* Section titre */}
      <section className="py-16 text-center">
        <div className="container mx-auto px-4">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-800 mb-6">
            Plans d'Abonnement Math4Child
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Révolution éducative mondiale - Choisissez votre plan parfait
          </p>
        </div>
      </section>

      {/* Plans d'abonnement avec data-plan pour tests */}
      <section className="py-16">
        <div className="container mx-auto px-4">
          <div className="grid md:grid-cols-5 gap-8 max-w-7xl mx-auto">
            {plans.map((plan) => (
              <div
                key={plan.id}
                data-plan={plan.id}
                className={`relative bg-white rounded-2xl shadow-lg p-8 border-2 transition-all duration-300 hover:shadow-xl ${
                  plan.popular 
                    ? 'border-blue-500 bg-blue-50 transform scale-105 ring-4 ring-blue-100' 
                    : 'border-gray-200 hover:border-gray-300'
                }`}
              >
                {/* Badge pour PREMIUM */}
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-gradient-to-r from-blue-500 to-blue-600 text-white px-4 py-1 rounded-full text-sm font-bold shadow-lg">
                      ⭐ LE PLUS CHOISI
                    </span>
                  </div>
                )}

                <div className="text-center">
                  <h3 className="text-xl font-bold text-gray-800 mb-2">{plan.name}</h3>
                  
                  {/* Nombre de profils */}
                  <div className={`mb-4 p-3 rounded-lg ${
                    plan.popular ? 'bg-blue-100 border border-blue-200' : 'bg-gray-100'
                  }`}>
                    <div className={`text-2xl font-bold ${
                      plan.popular ? 'text-blue-600' : 'text-gray-600'
                    }`}>
                      👥 {plan.profiles}
                    </div>
                    <div className="text-sm text-gray-600">
                      profil{plan.profiles !== 1 ? 's' : ''}
                      {plan.id === 'ultimate' && (
                        <div className="text-xs text-purple-600 font-medium">
                          minimum (sans limite)
                        </div>
                      )}
                    </div>
                  </div>
                  
                  <div className="mb-6">
                    <div className="text-3xl font-bold text-gray-900">
                      {plan.id === 'ultimate' ? 'À partir de ' : ''}€{plan.price}
                    </div>
                    <div className="text-sm text-gray-500">
                      {plan.id === 'ultimate' ? 'sur devis' : '/mois'}
                    </div>
                  </div>

                  {/* Fonctionnalités */}
                  <ul className="space-y-3 mb-8">
                    {plan.features.map((feature, index) => (
                      <li key={index} className="flex items-start space-x-2">
                        <Check className="w-5 h-5 text-green-500 mt-0.5 flex-shrink-0" />
                        <span className="text-sm text-gray-600">{feature}</span>
                      </li>
                    ))}
                  </ul>

                  <button className={`w-full py-3 px-6 rounded-lg font-medium transition-all duration-200 ${
                    plan.popular
                      ? 'bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white'
                      : 'bg-gray-100 hover:bg-gray-200 text-gray-800'
                  }`}>
                    {plan.id === 'ultimate' ? 'Demander un devis' : `Choisir ${plan.name}`}
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="container mx-auto px-4">
          <div className="text-center">
            <h3 className="text-2xl font-bold mb-4">Math4Child v4.2.0</h3>
            <p className="text-gray-400 mb-6">Révolution Éducative Mondiale</p>
            
            <div className="space-y-2">
              <p>Support: support@math4child.com</p>
              <p>Commercial: commercial@math4child.com</p>
              <p>Web: www.math4child.com</p>
            </div>
            
            <div className="mt-8 pt-8 border-t border-gray-800 text-sm text-gray-400">
              © 2025 Math4Child v4.2.0 - Révolution Éducative Mondiale
            </div>
          </div>
        </div>
      </footer>
    </div>
  )
}
