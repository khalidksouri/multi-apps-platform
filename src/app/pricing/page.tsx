"use client"

import React, { useState } from 'react'
import Link from 'next/link'
import { Check, Star, Crown, Building, Users, Zap } from 'lucide-react'

interface PricingPlan {
  id: string
  name: string
  price: number
  profiles: string
  period: string
  popular?: boolean
  badge?: string
  icon: React.ReactNode
  color: string
  features: string[]
  limitations?: string[]
}

export default function PricingPage() {
  const [isAnnual, setIsAnnual] = useState(false)

  const plans: PricingPlan[] = [
    {
      id: 'gratuit',
      name: 'GRATUIT',
      price: 0,
      profiles: '1 profil',
      period: '1 semaine',
      icon: <Zap className="w-6 h-6" />,
      color: 'from-gray-400 to-gray-500',
      features: [
        '1 semaine d\'accès complet',
        '50 questions maximum',
        'Mode classique uniquement',
        '3 langues au choix',
        'Support communautaire'
      ],
      limitations: [
        'Limité à 50 questions',
        'Pas d\'IA adaptative',
        'Pas de recognition manuscrite'
      ]
    },
    {
      id: 'basic',
      name: 'BASIC',
      price: isAnnual ? 4.99 : 4.99,
      profiles: '1 profil unique',
      period: 'mois',
      icon: <Users className="w-6 h-6" />,
      color: 'from-blue-400 to-blue-500',
      features: [
        '1 profil utilisateur',
        'Accès illimité niveau 1-2',
        'Mode classique + manuscrit',
        '5 langues au choix',
        'Statistiques de base',
        'Support email'
      ]
    },
    {
      id: 'standard',
      name: 'STANDARD',
      price: isAnnual ? 6.99 : 9.99,
      profiles: '2 profils',
      period: 'mois',
      icon: <Star className="w-6 h-6" />,
      color: 'from-green-400 to-green-500',
      features: [
        '2 profils utilisateurs',
        'Accès tous les niveaux (1-5)',
        'Tous les modes d\'exercices',
        '50 langues incluses',
        'IA Adaptative basique',
        'Dashboard parental',
        'Support prioritaire'
      ]
    },
    {
      id: 'premium',
      name: 'PREMIUM',
      price: isAnnual ? 10.49 : 14.99,
      profiles: '3 profils',
      period: 'mois',
      popular: true,
      badge: 'LE PLUS CHOISI',
      icon: <Crown className="w-6 h-6" />,
      color: 'from-purple-500 to-blue-600',
      features: [
        '3 profils utilisateurs',
        '🚀 TOUTES les innovations',
        '🧠 IA Adaptative complète',
        '🥽 Réalité Augmentée 3D',
        '🌍 200+ langues',
        '📊 Analytics avancés',
        '🎮 Gamification complète',
        '👨‍👩‍👧‍👦 Dashboard famille',
        '🆘 Support 24/7'
      ]
    },
    {
      id: 'famille',
      name: 'FAMILLE',
      price: isAnnual ? 13.99 : 19.99,
      profiles: '5 profils',
      period: 'mois',
      icon: <Users className="w-6 h-6" />,
      color: 'from-pink-400 to-red-500',
      features: [
        '5 profils utilisateurs',
        'Toutes les fonctionnalités PREMIUM',
        'Rapports familiaux détaillés',
        'Contrôle parental avancé',
        'Support VIP prioritaire',
        'Accès bêta nouvelles fonctionnalités',
        'Sessions familiales'
      ]
    },
    {
      id: 'ultimate',
      name: 'ULTIMATE',
      price: 0, // Prix sur devis
      profiles: '10+ profils',
      period: 'sur devis',
      icon: <Building className="w-6 h-6" />,
      color: 'from-gray-800 to-black',
      features: [
        'MINIMUM 10 profils',
        'SANS LIMITATION MAXIMUM',
        'DEVIS PERSONNALISÉ',
        'Solution institutionnelle',
        'API développeur complète',
        'Fonctionnalités école/institution',
        'Support dédié 24/7',
        'Personnalisation marque blanche',
        'Formation équipes incluse',
        'SLA garanti'
      ]
    }
  ]

  const getDiscountedPrice = (price: number) => {
    if (isAnnual && price > 0) {
      return (price * 12 * 0.7).toFixed(2) // 30% de réduction annuelle
    }
    return price.toFixed(2)
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl md:text-5xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-blue-800 bg-clip-text text-transparent mb-6">
            Plans d'Abonnement Math4Child
          </h1>
          <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            Choisissez le plan parfait pour votre famille. De 1 à 10+ profils avec toutes nos innovations révolutionnaires.
          </p>
          
          {/* Toggle Mensuel/Annuel */}
          <div className="flex items-center justify-center space-x-4 mb-8">
            <span className={`text-lg font-medium ${!isAnnual ? 'text-blue-600' : 'text-gray-500'}`}>
              Mensuel
            </span>
            <button
              onClick={() => setIsAnnual(!isAnnual)}
              className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${
                isAnnual ? 'bg-blue-600' : 'bg-gray-300'
              }`}
            >
              <span
                className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${
                  isAnnual ? 'translate-x-6' : 'translate-x-1'
                }`}
              />
            </button>
            <span className={`text-lg font-medium ${isAnnual ? 'text-blue-600' : 'text-gray-500'}`}>
              Annuel
            </span>
            {isAnnual && (
              <span className="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium">
                30% d'économie !
              </span>
            )}
          </div>
        </div>

        {/* Plans Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
          {plans.map((plan) => (
            <div
              key={plan.id}
              className={`relative bg-white rounded-2xl shadow-lg border-2 transition-all duration-300 hover:shadow-xl ${
                plan.popular 
                  ? 'border-purple-400 scale-105 transform' 
                  : 'border-gray-200 hover:border-blue-300'
              }`}
            >
              {/* Badge populaire */}
              {plan.popular && (
                <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                  <div className="bg-gradient-to-r from-purple-500 to-blue-600 text-white px-6 py-2 rounded-full text-sm font-bold shadow-lg">
                    ⭐ {plan.badge}
                  </div>
                </div>
              )}

              <div className="p-8">
                {/* Header du plan */}
                <div className="text-center mb-6">
                  <div className={`inline-flex items-center justify-center w-16 h-16 rounded-full bg-gradient-to-r ${plan.color} text-white mb-4`}>
                    {plan.icon}
                  </div>
                  <h3 className="text-2xl font-bold text-gray-800 mb-2">{plan.name}</h3>
                  
                  {/* Prix */}
                  <div className="mb-4">
                    {plan.price === 0 && plan.id === 'gratuit' ? (
                      <div className="text-4xl font-bold text-gray-600">Gratuit</div>
                    ) : plan.price === 0 && plan.id === 'ultimate' ? (
                      <div className="text-2xl font-bold text-gray-800">Sur Devis</div>
                    ) : (
                      <div>
                        <span className="text-4xl font-bold text-gray-800">€{getDiscountedPrice(plan.price)}</span>
                        <span className="text-gray-600">/{plan.period}</span>
                        {isAnnual && plan.price > 0 && (
                          <div className="text-sm text-green-600 font-medium">
                            au lieu de €{(plan.price * 12).toFixed(2)}/an
                          </div>
                        )}
                      </div>
                    )}
                  </div>

                  {/* Nombre de profils */}
                  <div className="bg-blue-50 px-4 py-2 rounded-lg mb-6">
                    <div className="text-sm text-blue-600 font-medium">Profils inclus</div>
                    <div className="text-lg font-bold text-blue-800">{plan.profiles}</div>
                  </div>
                </div>

                {/* Fonctionnalités */}
                <div className="space-y-3 mb-8">
                  {plan.features.map((feature, index) => (
                    <div key={index} className="flex items-start space-x-3">
                      <Check className="w-5 h-5 text-green-500 mt-0.5 flex-shrink-0" />
                      <span className="text-gray-700 text-sm">{feature}</span>
                    </div>
                  ))}
                  
                  {plan.limitations && (
                    <div className="border-t border-gray-200 pt-3 mt-3">
                      <div className="text-xs text-gray-500 mb-2">Limitations :</div>
                      {plan.limitations.map((limitation, index) => (
                        <div key={index} className="flex items-start space-x-3">
                          <div className="w-5 h-5 text-orange-400 mt-0.5 flex-shrink-0">⚠️</div>
                          <span className="text-gray-600 text-xs">{limitation}</span>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

                {/* Bouton CTA */}
                <div className="text-center">
                  {plan.id === 'ultimate' ? (
                    <Link
                      href="mailto:commercial@math4child.com?subject=Demande%20plan%20ULTIMATE"
                      className="w-full bg-gray-800 text-white py-3 px-6 rounded-lg font-semibold hover:bg-gray-900 transition-colors inline-block"
                    >
                      📞 Contacter Commercial
                    </Link>
                  ) : plan.id === 'gratuit' ? (
                    <Link
                      href="/exercises"
                      className="w-full bg-gradient-to-r from-green-500 to-green-600 text-white py-3 px-6 rounded-lg font-semibold hover:shadow-lg transition-all inline-block"
                    >
                      🚀 Essayer Gratuit
                    </Link>
                  ) : (
                    <button className={`w-full bg-gradient-to-r ${plan.color} text-white py-3 px-6 rounded-lg font-semibold hover:shadow-lg transform hover:scale-105 transition-all`}>
                      💎 Choisir ce Plan
                    </button>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Réductions multi-plateformes */}
        <div className="bg-white rounded-2xl shadow-lg p-8 mb-12">
          <h3 className="text-2xl font-bold text-center text-gray-800 mb-6">
            🎯 Réductions Multi-Plateformes
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="text-center p-6 bg-blue-50 rounded-xl">
              <div className="text-4xl mb-3">📱</div>
              <h4 className="font-bold text-blue-800 mb-2">2ème Plateforme</h4>
              <div className="text-3xl font-bold text-blue-600 mb-2">50%</div>
              <p className="text-sm text-blue-700">de réduction sur Android ou iOS</p>
            </div>
            <div className="text-center p-6 bg-green-50 rounded-xl">
              <div className="text-4xl mb-3">🌐</div>
              <h4 className="font-bold text-green-800 mb-2">3ème Plateforme</h4>
              <div className="text-3xl font-bold text-green-600 mb-2">75%</div>
              <p className="text-sm text-green-700">de réduction sur la 3ème plateforme</p>
            </div>
            <div className="text-center p-6 bg-purple-50 rounded-xl">
              <div className="text-4xl mb-3">📅</div>
              <h4 className="font-bold text-purple-800 mb-2">Abonnement Annuel</h4>
              <div className="text-3xl font-bold text-purple-600 mb-2">30%</div>
              <p className="text-sm text-purple-700">d'économie sur tous les plans</p>
            </div>
          </div>
        </div>

        {/* FAQ/Support */}
        <div className="text-center">
          <h3 className="text-2xl font-bold text-gray-800 mb-4">
            Des questions sur nos plans ?
          </h3>
          <p className="text-gray-600 mb-6">
            Notre équipe est là pour vous aider à choisir le plan parfait pour vos besoins.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link
              href="mailto:support@math4child.com"
              className="bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors"
            >
              📧 Support Technique
            </Link>
            <Link
              href="mailto:commercial@math4child.com"
              className="bg-purple-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-purple-700 transition-colors"
            >
              💼 Équipe Commerciale
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}
