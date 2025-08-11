"use client"

import { useState } from 'react'
import { useLanguage } from '@/hooks/useLanguage'
import { 
  MATH4CHILD_PLANS, 
  FREE_TRIAL_CONFIG, 
  calculatePlatformDiscount,
  getFormattedProfilesCount,
  requiresQuote,
  COMMERCIAL_CONTACT,
  POPULARITY_STATS
} from '@/types/subscription'

interface PricingPlansProps {
  onSelectPlan?: (planId: string, interval: 'monthly' | 'quarterly' | 'annual') => void
}

export function PricingPlans({ onSelectPlan }: PricingPlansProps) {
  const { t } = useLanguage()
  const [selectedInterval, setSelectedInterval] = useState<'monthly' | 'quarterly' | 'annual'>('monthly')
  const [platformCount, setPlatformCount] = useState(1)

  const formatPrice = (price: number): string => {
    return (price / 100).toFixed(2)
  }

  const getPrice = (plan: any) => {
    switch (selectedInterval) {
      case 'monthly':
        return calculatePlatformDiscount(plan.priceMonthly, platformCount)
      case 'quarterly':
        return calculatePlatformDiscount(plan.priceQuarterly, platformCount)
      case 'annual':
        return calculatePlatformDiscount(plan.priceAnnual, platformCount)
      default:
        return plan.priceMonthly
    }
  }

  const getDiscount = () => {
    switch (selectedInterval) {
      case 'quarterly': return '10%'
      case 'annual': return '30%'
      default: return null
    }
  }

  const handlePlanSelection = (planId: string, interval: 'monthly' | 'quarterly' | 'annual') => {
    if (requiresQuote(planId)) {
      // Redirection vers contact commercial pour ULTIMATE
      window.open(`mailto:${COMMERCIAL_CONTACT.email}?subject=Devis Math4Child ULTIMATE&body=Bonjour, je souhaite obtenir un devis personnalisé pour le plan ULTIMATE. Nombre de profils souhaité : `, '_blank')
    } else {
      onSelectPlan?.(planId, interval)
    }
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-12">
      {/* Header */}
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          💎 Plans Math4Child v4.2.0
        </h1>
        <p className="text-xl text-gray-600 mb-8">
          Choisissez le plan idéal pour votre famille ou votre institution
        </p>
        <div className="bg-gradient-to-r from-blue-50 to-purple-50 border border-blue-200 rounded-lg p-6 max-w-4xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-center">
            <div>
              <div className="text-2xl font-bold text-blue-600">45%</div>
              <div className="text-sm text-gray-600">choisissent Premium</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-green-600">98%</div>
              <div className="text-sm text-gray-600">satisfaction Premium</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-purple-600">🎙️+🥽</div>
              <div className="text-sm text-gray-600">IA Vocal + Réalité Augmentée</div>
            </div>
          </div>
        </div>
      </div>

      {/* Sélecteur d'intervalle */}
      <div className="flex justify-center mb-8">
        <div className="bg-gray-100 rounded-xl p-1 flex">
          {[
            { key: 'monthly', label: 'Mensuel', discount: null },
            { key: 'quarterly', label: 'Trimestriel', discount: '10%' },
            { key: 'annual', label: 'Annuel', discount: '30%' }
          ].map(interval => (
            <button
              key={interval.key}
              onClick={() => setSelectedInterval(interval.key as any)}
              className={`px-6 py-3 rounded-lg font-medium transition-all ${
                selectedInterval === interval.key
                  ? 'bg-white text-blue-600 shadow-md'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              {interval.label}
              {interval.discount && (
                <span className="ml-2 bg-green-100 text-green-600 px-2 py-1 rounded-full text-xs">
                  -{interval.discount}
                </span>
              )}
            </button>
          ))}
        </div>
      </div>

      {/* Sélecteur nombre de plateformes */}
      <div className="text-center mb-8">
        <h3 className="text-lg font-semibold text-gray-800 mb-4">
          🖥️ Plateformes incluses (Web + Android + iOS)
        </h3>
        <div className="flex justify-center gap-4">
          {[1, 2, 3].map(count => (
            <button
              key={count}
              onClick={() => setPlatformCount(count)}
              className={`px-4 py-2 rounded-lg border-2 transition-all ${
                platformCount === count
                  ? 'border-blue-500 bg-blue-50 text-blue-600'
                  : 'border-gray-300 hover:border-gray-400'
              }`}
            >
              {count} plateforme{count > 1 ? 's' : ''}
              {count === 2 && <span className="ml-2 text-green-600 text-sm">-50%</span>}
              {count === 3 && <span className="ml-2 text-green-600 text-sm">-75%</span>}
            </button>
          ))}
        </div>
        <p className="text-sm text-gray-600 mt-2">
          Économisez en choisissant plusieurs plateformes
        </p>
      </div>

      {/* Version gratuite */}
      <div className="mb-8">
        <div className="bg-gradient-to-r from-gray-50 to-gray-100 rounded-xl p-6 border-2 border-dashed border-gray-300">
          <div className="text-center">
            <h3 className="text-2xl font-bold text-gray-800 mb-2">🆓 Essai Gratuit</h3>
            <p className="text-gray-600 mb-4">Découvrez Math4Child sans engagement</p>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
              <div className="text-center">
                <div className="text-3xl font-bold text-blue-600">7</div>
                <div className="text-sm text-gray-600">jours d'accès gratuit</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold text-green-600">50</div>
                <div className="text-sm text-gray-600">questions incluses</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold text-purple-600">5</div>
                <div className="text-sm text-gray-600">types d'exercices</div>
              </div>
            </div>
            <button 
              onClick={() => handlePlanSelection('free', 'monthly')}
              className="bg-blue-600 text-white px-8 py-3 rounded-xl font-bold hover:bg-blue-700 transition-colors"
            >
              🚀 Commencer Gratuitement
            </button>
          </div>
        </div>
      </div>

      {/* Plans d'abonnement */}
      <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6">
        {MATH4CHILD_PLANS.map((plan) => {
          const price = getPrice(plan)
          const discount = getDiscount()
          const profilesCount = getFormattedProfilesCount(plan)
          const isUltimate = plan.id === 'ultimate'
          const isPremium = plan.id === 'premium'
          
          return (
            <div
              key={plan.id}
              className={`relative bg-white rounded-xl border-2 p-6 hover:shadow-lg transition-all ${
                isPremium
                  ? 'border-blue-500 bg-blue-50 transform scale-105 ring-4 ring-blue-100' 
                  : isUltimate
                  ? 'border-purple-500 bg-purple-50'
                  : 'border-gray-200 hover:border-gray-300'
              }`}
            >
              {isPremium && (
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-gradient-to-r from-blue-500 to-blue-600 text-white px-4 py-1 rounded-full text-sm font-bold shadow-lg">
                    ⭐ LE PLUS CHOISI
                  </span>
                </div>
              )}

              {isUltimate && (
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-purple-500 text-white px-4 py-1 rounded-full text-sm font-bold">
                    💼 SUR MESURE
                  </span>
                </div>
              )}

              <div className="text-center">
                <h3 className="text-xl font-bold text-gray-800 mb-2">{plan.name}</h3>
                <p className="text-gray-600 text-sm mb-4">{plan.description}</p>
                
                {/* Badge spécial pour Premium */}
                {isPremium && (
                  <div className="mb-3 bg-gradient-to-r from-blue-100 to-purple-100 rounded-lg p-2">
                    <div className="text-xs text-blue-700 font-medium">
                      🏆 Choisi par {POPULARITY_STATS.premium.percentage}% des utilisateurs
                    </div>
                  </div>
                )}
                
                {/* Nombre de profils mis en évidence */}
                <div className={`mb-4 p-3 rounded-lg ${
                  isPremium ? 'bg-blue-100 border border-blue-200' :
                  isUltimate ? 'bg-purple-100' : 'bg-gray-100'
                }`}>
                  <div className={`text-2xl font-bold ${
                    isPremium ? 'text-blue-600' :
                    isUltimate ? 'text-purple-600' : 'text-gray-600'
                  }`}>
                    👥 {profilesCount}
                  </div>
                  <div className="text-sm text-gray-600">
                    {isUltimate ? 'profils minimum' : 'profil' + (plan.profiles !== 1 ? 's' : '')}
                    {isUltimate && (
                      <div className="text-xs text-purple-600 font-medium">
                        Sans limite maximum
                      </div>
                    )}
                  </div>
                </div>
                
                <div className="mb-4">
                  {isUltimate ? (
                    <div>
                      <div className="text-2xl font-bold text-gray-900">
                        À partir de €{formatPrice(price)}
                      </div>
                      <div className="text-sm text-gray-500">
                        /{selectedInterval === 'annual' ? 'an' : selectedInterval === 'quarterly' ? '3 mois' : 'mois'}
                      </div>
                      <div className="text-sm text-purple-600 font-medium mt-1">
                        💬 Devis personnalisé
                      </div>
                    </div>
                  ) : (
                    <div>
                      <div className={`text-3xl font-bold ${isPremium ? 'text-blue-600' : 'text-gray-900'}`}>
                        €{formatPrice(price)}
                      </div>
                      <div className="text-sm text-gray-500">
                        /{selectedInterval === 'annual' ? 'an' : selectedInterval === 'quarterly' ? '3 mois' : 'mois'}
                      </div>
                      {discount && (
                        <div className="text-sm text-green-600 font-medium mt-1">
                          💰 Économisez {discount} !
                        </div>
                      )}
                      {isPremium && (
                        <div className="text-xs text-blue-600 font-medium mt-1">
                          🥽 Assistant Vocal IA + Réalité Augmentée 3D
                        </div>
                      )}
                    </div>
                  )}
                  
                  {platformCount > 1 && (
                    <div className="text-sm text-blue-600 font-medium mt-1">
                      🎯 Réduction multi-plateforme incluse
                    </div>
                  )}
                </div>

                <div className="mb-6">
                  <ul className="text-sm text-gray-600 space-y-1">
                    {plan.features.slice(0, isPremium ? 6 : isUltimate ? 6 : 4).map((feature, index) => (
                      <li key={index} className="flex items-start gap-2">
                        <span className="text-green-500 mt-0.5">✓</span>
                        <span>{feature}</span>
                      </li>
                    ))}
                    {plan.features.length > (isPremium ? 6 : isUltimate ? 6 : 4) && (
                      <li className="text-gray-500 text-xs">
                        +{plan.features.length - (isPremium ? 6 : isUltimate ? 6 : 4)} autres avantages
                      </li>
                    )}
                  </ul>
                </div>

                <button
                  onClick={() => handlePlanSelection(plan.id, selectedInterval)}
                  className={`w-full py-3 rounded-xl font-bold transition-colors ${
                    isPremium
                      ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white hover:from-blue-700 hover:to-blue-800 shadow-lg'
                      : isUltimate
                      ? 'bg-purple-600 text-white hover:bg-purple-700'
                      : 'bg-gray-900 text-white hover:bg-gray-800'
                  }`}
                >
                  {isUltimate ? '📞 Obtenir un devis' : `⭐ Choisir ${plan.name}`}
                </button>

                {isUltimate && (
                  <div className="mt-3 text-xs text-gray-500">
                    <div>📧 {COMMERCIAL_CONTACT.email}</div>
                    <div>📞 {COMMERCIAL_CONTACT.phone}</div>
                  </div>
                )}
              </div>
            </div>
          )
        })}
      </div>

      {/* Section Premium mis en avant */}
      <div className="mt-12 bg-gradient-to-r from-blue-50 to-purple-50 rounded-xl p-8 border-2 border-blue-200">
        <h3 className="text-2xl font-bold text-center text-gray-800 mb-6">
          🏆 Pourquoi Premium est le Plus Choisi ?
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 text-center">
          <div className="bg-white rounded-lg p-4 shadow-sm">
            <div className="text-3xl mb-2">🎙️</div>
            <h4 className="font-semibold text-gray-800 text-sm">Assistant Vocal IA</h4>
            <p className="text-xs text-gray-600">Première mondiale éducation</p>
          </div>
          <div className="bg-white rounded-lg p-4 shadow-sm">
            <div className="text-3xl mb-2">🥽</div>
            <h4 className="font-semibold text-gray-800 text-sm">Réalité Augmentée 3D</h4>
            <p className="text-xs text-gray-600">Visualisation révolutionnaire</p>
          </div>
          <div className="bg-white rounded-lg p-4 shadow-sm">
            <div className="text-3xl mb-2">👥</div>
            <h4 className="font-semibold text-gray-800 text-sm">3 Profils Inclus</h4>
            <p className="text-xs text-gray-600">Parfait pour les familles</p>
          </div>
          <div className="bg-white rounded-lg p-4 shadow-sm">
            <div className="text-3xl mb-2">💰</div>
            <h4 className="font-semibold text-gray-800 text-sm">Rapport Qualité-Prix</h4>
            <p className="text-xs text-gray-600">Innovations à €14.99/mois</p>
          </div>
        </div>
        <div className="text-center mt-6">
          <button 
            onClick={() => handlePlanSelection('premium', selectedInterval)}
            className="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-8 py-3 rounded-xl font-bold hover:from-blue-700 hover:to-blue-800 transition-colors shadow-lg"
          >
            ⭐ Choisir Premium - Le Plus Populaire
          </button>
        </div>
      </div>

      {/* Garanties et avantages */}
      <div className="mt-16 text-center">
        <h3 className="text-xl font-semibold text-gray-800 mb-8">
          🛡️ Vos Avantages Math4Child
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 max-w-5xl mx-auto">
          <div className="text-gray-600">
            <div className="text-3xl mb-3">🔒</div>
            <h4 className="font-semibold mb-2">Paiement 100% Sécurisé</h4>
            <p className="text-sm">Technologie Stripe de niveau bancaire</p>
          </div>
          <div className="text-gray-600">
            <div className="text-3xl mb-3">🌍</div>
            <h4 className="font-semibold mb-2">200+ Langues</h4>
            <p className="text-sm">Interface disponible dans votre langue</p>
          </div>
          <div className="text-gray-600">
            <div className="text-3xl mb-3">📱</div>
            <h4 className="font-semibold mb-2">Multi-Plateformes</h4>
            <p className="text-sm">Web, Android et iOS inclus</p>
          </div>
          <div className="text-gray-600">
            <div className="text-3xl mb-3">↩️</div>
            <h4 className="font-semibold mb-2">Annulation Simple</h4>
            <p className="text-sm">Résiliez votre abonnement à tout moment</p>
          </div>
        </div>
      </div>
    </div>
  )
}
