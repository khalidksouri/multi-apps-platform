'use client'
import { useState } from 'react'
import { PricingComponentProps, IntervalType } from '@/types/paddle'
import { PADDLE_PLANS, getDiscountPercentage } from '@/lib/paddle/plans'
import { IntervalSelector } from './IntervalSelector'
import { PlanCard } from './PlanCard'

export function PricingComponent({ onPlanSelect }: PricingComponentProps) {
  const [selectedInterval, setSelectedInterval] = useState<IntervalType>('month')
  
  return (
    <div className="pricing-container max-w-7xl mx-auto px-4 py-12">
      {/* Header */}
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-white mb-4">
          Choisissez votre plan Math4Child
        </h1>
        <p className="text-xl text-white/80 mb-8">
          Plans compétitifs avec essai gratuit - Annulation facile
        </p>
      </div>

      {/* Sélecteur d'intervalle */}
      <IntervalSelector 
        selectedInterval={selectedInterval}
        onIntervalChange={setSelectedInterval}
      />

      {/* Plans d'abonnement */}
      <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6 mt-12">
        {Object.entries(PADDLE_PLANS).map(([planType, plans]) => {
          const plan = plans.find(p => p.interval === selectedInterval)
          if (!plan) return null

          return (
            <PlanCard
              key={`${planType}-${selectedInterval}`}
              plan={plan}
              planType={planType}
              interval={selectedInterval}
              onSelect={() => onPlanSelect(planType, selectedInterval)}
              isPopular={planType === 'famille'}
              isRecommended={planType === 'ecole'}
            />
          )
        })}
      </div>

      {/* Garanties */}
      <div className="mt-16 text-center">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
          <div className="text-white/80">
            <div className="text-3xl mb-2">🔒</div>
            <h3 className="font-semibold mb-1">Paiement sécurisé</h3>
            <p className="text-sm">Chiffrement SSL 256-bit</p>
          </div>
          <div className="text-white/80">
            <div className="text-3xl mb-2">↩️</div>
            <h3 className="font-semibold mb-1">Annulation facile</h3>
            <p className="text-sm">Résiliez à tout moment</p>
          </div>
          <div className="text-white/80">
            <div className="text-3xl mb-2">✨</div>
            <h3 className="font-semibold mb-1">Satisfaction garantie</h3>
            <p className="text-sm">30 jours satisfait ou remboursé</p>
          </div>
        </div>
      </div>
    </div>
  )
}
