'use client'

import { useState } from 'react'
import { useTranslation } from '@/hooks/useTranslation'
import { X, Check, Crown, Star, Users, Clock, Shield, CreditCard } from 'lucide-react'

interface PricingPlan {
  id: string
  name: string
  price: number
  originalPrice?: number
  interval: 'month' | 'year'
  profiles: number
  features: string[]
  popular?: boolean
  recommended?: boolean
  savings?: string
}

interface PricingModalProps {
  isOpen: boolean
  onClose: () => void
  onPlanSelect: (planId: string) => void
}

export function PricingModal({ isOpen, onClose, onPlanSelect }: PricingModalProps) {
  const { t, isRTL } = useTranslation()
  const [billingInterval, setBillingInterval] = useState<'monthly' | 'yearly'>('monthly')

  if (!isOpen) return null

  const plans: PricingPlan[] = [
    {
      id: 'free',
      name: t('free'),
      price: 0,
      interval: 'month',
      profiles: 1,
      features: [
        '1 profil enfant',
        'Exercices de base',
        '50 questions/semaine',
        'Statistiques simples'
      ]
    },
    {
      id: 'premium',
      name: t('premiumPlan'),
      price: billingInterval === 'monthly' ? 9.99 : 99.99,
      originalPrice: billingInterval === 'yearly' ? 119.88 : undefined,
      interval: billingInterval === 'monthly' ? 'month' : 'year',
      profiles: 3,
      popular: true,
      savings: billingInterval === 'yearly' ? '17%' : undefined,
      features: [
        '3 profils enfants',
        'Tous les exercices',
        'Questions illimitées',
        'Statistiques avancées',
        'Support prioritaire'
      ]
    },
    {
      id: 'family',
      name: t('familyPlan'),
      price: billingInterval === 'monthly' ? 19.99 : 199.99,
      originalPrice: billingInterval === 'yearly' ? 239.88 : undefined,
      interval: billingInterval === 'monthly' ? 'month' : 'year',
      profiles: 6,
      recommended: true,
      savings: billingInterval === 'yearly' ? '25%' : undefined,
      features: [
        '6 profils enfants',
        'Tableau de bord famille',
        'Rapports détaillés',
        'Mode compétition',
        'Support VIP 24/7'
      ]
    }
  ]

  const formatPrice = (price: number, currency: string = 'EUR') => {
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency,
      minimumFractionDigits: price % 1 === 0 ? 0 : 2
    }).format(price)
  }

  const getPlanIcon = (planId: string) => {
    switch (planId) {
      case 'free': return <Shield className="w-8 h-8" />
      case 'premium': return <Star className="w-8 h-8" />
      case 'family': return <Crown className="w-8 h-8" />
      default: return <Shield className="w-8 h-8" />
    }
  }

  const getPlanColor = (planId: string) => {
    switch (planId) {
      case 'free': return 'from-gray-500 to-gray-600'
      case 'premium': return 'from-blue-500 to-purple-600'
      case 'family': return 'from-purple-500 to-pink-600'
      default: return 'from-green-500 to-blue-600'
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      {/* Overlay */}
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={onClose} />
      
      {/* Modal */}
      <div className={`relative bg-white rounded-3xl shadow-2xl max-w-6xl w-full max-h-[90vh] overflow-hidden ${isRTL ? 'rtl' : 'ltr'}`}>
        {/* Header */}
        <div className="bg-gradient-to-r from-purple-500 to-pink-500 p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-3xl font-bold">{t('pricing')}</h2>
              <p className="text-purple-100">Choisissez le plan qui convient le mieux à votre famille</p>
            </div>
            <button
              onClick={onClose}
              className="p-2 hover:bg-white/20 rounded-full transition-colors"
            >
              <X className="w-6 h-6" />
            </button>
          </div>

          {/* Toggle billing interval */}
          <div className="mt-6 flex justify-center">
            <div className="inline-flex bg-white/10 backdrop-blur-sm rounded-full p-1 border border-white/20">
              <button
                onClick={() => setBillingInterval('monthly')}
                className={`px-6 py-3 rounded-full font-medium transition-all duration-300 ${
                  billingInterval === 'monthly'
                    ? 'bg-white text-purple-600 shadow-lg'
                    : 'text-white hover:bg-white/10'
                }`}
              >
                {t('monthly')}
              </button>
              <button
                onClick={() => setBillingInterval('yearly')}
                className={`px-6 py-3 rounded-full font-medium transition-all duration-300 relative ${
                  billingInterval === 'yearly'
                    ? 'bg-white text-purple-600 shadow-lg'
                    : 'text-white hover:bg-white/10'
                }`}
              >
                {t('annual')}
                <span className="absolute -top-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full">
                  -25%
                </span>
              </button>
            </div>
          </div>
        </div>

        {/* Plans */}
        <div className="p-6 overflow-y-auto max-h-[60vh]">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {plans.map((plan) => (
              <div
                key={plan.id}
                className={`
                  relative bg-gradient-to-br from-gray-50 to-white rounded-2xl p-6 border-2 transition-all duration-300 hover:scale-105
                  ${plan.popular ? 'border-blue-400 ring-2 ring-blue-400 ring-opacity-50' : ''}
                  ${plan.recommended ? 'border-purple-400 ring-2 ring-purple-400 ring-opacity-50' : ''}
                  ${!plan.popular && !plan.recommended ? 'border-gray-200' : ''}
                `}
              >
                {/* Badges */}
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <div className="bg-blue-500 text-white px-4 py-2 rounded-full text-sm font-medium flex items-center">
                      <Star className="w-4 h-4 mr-1" />
                      {t('mostPopular')}
                    </div>
                  </div>
                )}

                {plan.recommended && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <div className="bg-purple-500 text-white px-4 py-2 rounded-full text-sm font-medium flex items-center">
                      <Crown className="w-4 h-4 mr-1" />
                      {t('recommended')}
                    </div>
                  </div>
                )}

                {/* Icon */}
                <div className={`w-16 h-16 rounded-2xl bg-gradient-to-r ${getPlanColor(plan.id)} p-4 text-white mb-6 mx-auto`}>
                  {getPlanIcon(plan.id)}
                </div>

                {/* Plan info */}
                <div className="text-center mb-6">
                  <h3 className="text-2xl font-bold text-gray-800 mb-2">{plan.name}</h3>
                  
                  {/* Price */}
                  {plan.price === 0 ? (
                    <div className="text-4xl font-bold text-gray-800">{t('free')}</div>
                  ) : (
                    <div>
                      <div className="flex items-center justify-center space-x-1">
                        <span className="text-4xl font-bold text-gray-800">
                          {formatPrice(plan.price)}
                        </span>
                        <span className="text-gray-600">
                          /{plan.interval === 'year' ? 'an' : 'mois'}
                        </span>
                      </div>
                      
                      {plan.originalPrice && (
                        <div className="flex items-center justify-center space-x-2 mt-2">
                          <span className="text-gray-500 line-through">
                            {formatPrice(plan.originalPrice)}
                          </span>
                          {plan.savings && (
                            <span className="bg-green-500/20 text-green-700 px-2 py-1 rounded-full text-sm font-medium">
                              {t('save')} {plan.savings}
                            </span>
                          )}
                        </div>
                      )}
                    </div>
                  )}
                </div>

                {/* Profiles */}
                <div className="flex items-center justify-center mb-6 text-gray-600">
                  <Users className="w-5 h-5 mr-2" />
                  <span>{plan.profiles} profil{plan.profiles > 1 ? 's' : ''} enfant{plan.profiles > 1 ? 's' : ''}</span>
                </div>

                {/* Features */}
                <div className="space-y-3 mb-8">
                  {plan.features.map((feature, index) => (
                    <div key={index} className="flex items-start space-x-3">
                      <Check className="w-5 h-5 text-green-500 mt-0.5 flex-shrink-0" />
                      <span className="text-gray-600 text-sm">{feature}</span>
                    </div>
                  ))}
                </div>

                {/* Action button */}
                <button
                  onClick={() => onPlanSelect(plan.id)}
                  className={`
                    w-full py-4 px-6 rounded-full font-semibold text-lg transition-all duration-300
                    ${plan.id === 'free'
                      ? 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      : `bg-gradient-to-r ${getPlanColor(plan.id)} text-white hover:scale-105 shadow-lg hover:shadow-xl`
                    }
                  `}
                >
                  {plan.id === 'free' ? 'Commencer gratuitement' : t('choosePlan')}
                </button>

                {/* Trial info */}
                {plan.id !== 'free' && (
                  <div className="text-center mt-4 text-gray-500 text-sm">
                    <Clock className="w-4 h-4 inline mr-1" />
                    Essai gratuit de 14 jours
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Footer */}
        <div className="border-t border-gray-200 p-6 bg-gray-50">
          <div className="flex items-center justify-center space-x-8 text-gray-600">
            <div className="flex items-center">
              <Shield className="w-5 h-5 mr-2" />
              <span>Paiement sécurisé</span>
            </div>
            <div className="flex items-center">
              <CreditCard className="w-5 h-5 mr-2" />
              <span>Satisfait ou remboursé</span>
            </div>
            <div className="flex items-center">
              <Users className="w-5 h-5 mr-2" />
              <span>100k+ familles</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
