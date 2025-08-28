'use client'

import { useState } from 'react'
import { Check, Star, Users, Crown, Rocket } from 'lucide-react'

interface PricingPlan {
  id: string
  name: string
  description: string
  profiles: number
  price: {
    monthly: number
    quarterly: number
    annual: number
  }
  features: string[]
  popular?: boolean
  icon: any
  color: string
}

const PRICING_PLANS: PricingPlan[] = [
  {
    id: 'basic',
    name: 'BASIC',
    description: 'Parfait pour débuter',
    profiles: 1,
    price: { monthly: 9.99, quarterly: 26.97, annual: 83.93 },
    features: [
      '1 profil utilisateur',
      'Accès aux 5 niveaux',
      '5 opérations mathématiques',
      '100 questions par niveau',
      'Support toutes plateformes',
      'Progression sauvegardée'
    ],
    icon: Users,
    color: 'blue'
  },
  {
    id: 'standard', 
    name: 'STANDARD',
    description: 'Idéal pour la famille',
    profiles: 2,
    price: { monthly: 16.99, quarterly: 45.87, annual: 142.73 },
    features: [
      '2 profils utilisateurs',
      'Accès aux 5 niveaux',
      '5 opérations mathématiques', 
      '100 questions par niveau',
      'Support toutes plateformes',
      'Progression sauvegardée',
      'Statistiques détaillées'
    ],
    icon: Users,
    color: 'green'
  },
  {
    id: 'premium',
    name: 'PREMIUM',
    description: 'Le plus choisi',
    profiles: 3,
    price: { monthly: 24.99, quarterly: 67.47, annual: 209.93 },
    features: [
      '3 profils utilisateurs',
      'Accès aux 5 niveaux',
      '5 opérations mathématiques',
      '100 questions par niveau', 
      'Support toutes plateformes',
      'Progression sauvegardée',
      'Statistiques avancées',
      'Support prioritaire',
      'Fonctionnalités premium'
    ],
    popular: true,
    icon: Star,
    color: 'purple'
  },
  {
    id: 'famille',
    name: 'FAMILLE',
    description: 'Pour les grandes familles',
    profiles: 5,
    price: { monthly: 39.99, quarterly: 107.97, annual: 335.93 },
    features: [
      '5 profils utilisateurs',
      'Accès aux 5 niveaux',
      '5 opérations mathématiques',
      '100 questions par niveau',
      'Support toutes plateformes', 
      'Progression sauvegardée',
      'Statistiques familiales',
      'Gestion parentale avancée',
      'Rapports de progression',
      'Support prioritaire'
    ],
    icon: Crown,
    color: 'orange'
  },
  {
    id: 'ultimate',
    name: 'ULTIMATE', 
    description: 'Sans limitation - Sur devis',
    profiles: 10,
    price: { monthly: 0, quarterly: 0, annual: 0 },
    features: [
      '10+ profils (sans limitation)',
      'Accès aux 5 niveaux',
      '5 opérations mathématiques',
      '100 questions par niveau',
      'Support toutes plateformes',
      'Progression sauvegardée', 
      'Fonctionnalités enterprise',
      'API personnalisée',
      'Support dédié 24/7',
      'Formation incluse',
      'Devis personnalisé selon besoins'
    ],
    icon: Rocket,
    color: 'red'
  }
]

export default function PricingPage() {
  const [billingPeriod, setBillingPeriod] = useState<'monthly' | 'quarterly' | 'annual'>('monthly')

  const getDiscount = (period: string) => {
    switch (period) {
      case 'quarterly': return '10%'
      case 'annual': return '30%'
      default: return ''
    }
  }

  const formatPrice = (plan: PricingPlan, period: 'monthly' | 'quarterly' | 'annual') => {
    if (plan.id === 'ultimate') return 'Sur devis'
    const price = plan.price[period]
    if (period === 'quarterly') return `${(price/3).toFixed(2)}€/mois`
    if (period === 'annual') return `${(price/12).toFixed(2)}€/mois`
    return `${price}€/mois`
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* En-tête */}
        <div className="text-center mb-16">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
            Plans d'Abonnement Math4Child
          </h1>
          <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            Choisissez le plan parfait pour votre famille. Support universel 200+ langues, 
            5 niveaux de progression, apprentissage révolutionnaire.
          </p>
          
          {/* Sélecteur de période */}
          <div className="flex items-center justify-center space-x-4 mb-8">
            <button
              onClick={() => setBillingPeriod('monthly')}
              className={`px-6 py-3 rounded-lg font-medium transition-colors ${
                billingPeriod === 'monthly' 
                  ? 'bg-blue-600 text-white' 
                  : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
              }`}
            >
              Mensuel
            </button>
            <button
              onClick={() => setBillingPeriod('quarterly')}
              className={`px-6 py-3 rounded-lg font-medium transition-colors relative ${
                billingPeriod === 'quarterly'
                  ? 'bg-blue-600 text-white'
                  : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
              }`}
            >
              Trimestriel
              <span className="absolute -top-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full">
                -10%
              </span>
            </button>
            <button
              onClick={() => setBillingPeriod('annual')}
              className={`px-6 py-3 rounded-lg font-medium transition-colors relative ${
                billingPeriod === 'annual'
                  ? 'bg-blue-600 text-white'
                  : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
              }`}
            >
              Annuel
              <span className="absolute -top-2 -right-2 bg-red-500 text-white text-xs px-2 py-1 rounded-full">
                -30%
              </span>
            </button>
          </div>
        </div>

        {/* Grille des plans */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-8">
          {PRICING_PLANS.map((plan) => {
            const IconComponent = plan.icon
            return (
              <div
                key={plan.id}
                className={`relative bg-white rounded-2xl shadow-xl p-8 transition-transform hover:scale-105 ${
                  plan.popular ? 'ring-4 ring-purple-500 scale-105' : ''
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-gradient-to-r from-purple-600 to-pink-600 text-white px-6 py-2 rounded-full text-sm font-bold">
                      ⭐ LE PLUS CHOISI ⭐
                    </span>
                  </div>
                )}

                <div className="text-center">
                  <div className={`inline-flex p-4 rounded-full bg-${plan.color}-100 mb-4`}>
                    <IconComponent className={`w-8 h-8 text-${plan.color}-600`} />
                  </div>
                  
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                  <p className="text-gray-600 mb-6">{plan.description}</p>
                  
                  <div className="mb-6">
                    <div className="text-4xl font-bold text-gray-900 mb-1">
                      {formatPrice(plan, billingPeriod)}
                    </div>
                    {plan.id !== 'ultimate' && (
                      <div className="text-sm text-gray-500">
                        {billingPeriod === 'quarterly' && 'Facturé trimestriellement'}
                        {billingPeriod === 'annual' && 'Facturé annuellement'}
                        {billingPeriod === 'monthly' && 'Facturé mensuellement'}
                      </div>
                    )}
                  </div>

                  <div className="text-lg font-semibold text-gray-700 mb-6">
                    {plan.profiles === 10 ? '10+ profils' : `${plan.profiles} profil${plan.profiles > 1 ? 's' : ''}`}
                  </div>
                </div>

                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-start space-x-3">
                      <Check className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                      <span className="text-sm text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>

                <button
                  className={`w-full py-3 px-6 rounded-lg font-medium transition-colors ${
                    plan.popular
                      ? 'bg-gradient-to-r from-purple-600 to-pink-600 text-white hover:from-purple-700 hover:to-pink-700'
                      : plan.id === 'ultimate'
                      ? 'bg-gray-900 text-white hover:bg-gray-800'
                      : `bg-${plan.color}-600 text-white hover:bg-${plan.color}-700`
                  }`}
                >
                  {plan.id === 'ultimate' ? 'Demander un devis' : 'Choisir ce plan'}
                </button>
              </div>
            )
          })}
        </div>

        {/* Informations supplémentaires */}
        <div className="mt-16 text-center">
          <div className="bg-blue-50 rounded-2xl p-8 mb-8">
            <h3 className="text-2xl font-bold text-gray-900 mb-4">
              Tarification Multi-Device Avantageuse
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 text-center">
              <div>
                <div className="text-3xl font-bold text-blue-600 mb-2">1er Device</div>
                <div className="text-gray-600">Prix complet</div>
              </div>
              <div>
                <div className="text-3xl font-bold text-green-600 mb-2">2ème Device</div>
                <div className="text-gray-600">50% de réduction</div>
              </div>
              <div>
                <div className="text-3xl font-bold text-purple-600 mb-2">3ème Device</div>
                <div className="text-gray-600">75% de réduction</div>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
            <div>
              <div className="text-4xl font-bold text-blue-600 mb-2">5</div>
              <div className="text-gray-600">Niveaux de progression</div>
            </div>
            <div>
              <div className="text-4xl font-bold text-green-600 mb-2">100</div>
              <div className="text-gray-600">Bonnes réponses par niveau</div>
            </div>
            <div>
              <div className="text-4xl font-bold text-purple-600 mb-2">200+</div>
              <div className="text-gray-600">Langues supportées</div>
            </div>
          </div>

          <div className="mt-12 p-6 bg-gray-50 rounded-xl">
            <h4 className="text-lg font-semibold text-gray-900 mb-2">
              Support et Contact
            </h4>
            <div className="space-y-2 text-gray-600">
              <div>Support technique: support@math4child.com</div>
              <div>Contact commercial: commercial@math4child.com</div>
              <div>Site web: www.math4child.com</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
