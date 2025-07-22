'use client'
import { PaddlePlan, IntervalType } from '@/types/paddle'

interface PlanCardProps {
  plan: PaddlePlan
  planType: string
  interval: IntervalType
  onSelect: () => void
  isPopular?: boolean
  isRecommended?: boolean
}

export function PlanCard({ 
  plan, 
  planType, 
  interval, 
  onSelect, 
  isPopular = false, 
  isRecommended = false 
}: PlanCardProps) {
  const formatPrice = (amount: number) => (amount / 100).toFixed(2)
  
  const getIntervalLabel = (interval: IntervalType) => {
    switch (interval) {
      case 'month': return 'mois'
      case 'quarter': return 'trimestre'
      case 'year': return 'an'
    }
  }

  const getPlanFeatures = (planType: string) => {
    const baseFeatures = ['Questions illimitées', 'Mode hors-ligne', 'Support prioritaire']
    
    switch (planType) {
      case 'famille':
        return [...baseFeatures, '5 profils enfants', 'Rapports parents', 'Synchronisation cloud']
      case 'premium':
        return [...baseFeatures, '2 profils', 'Statistiques avancées']
      case 'ecole':
        return [...baseFeatures, '30 profils élèves', 'Tableau de bord enseignant', 'Rapports détaillés']
      default:
        return baseFeatures
    }
  }

  return (
    <div className={`relative bg-white/10 backdrop-blur-sm rounded-2xl p-6 transition-all hover:bg-white/15 ${
      isPopular ? 'ring-2 ring-blue-400 scale-105' : ''
    } ${isRecommended ? 'ring-2 ring-green-400' : ''}`}>
      
      {/* Badges */}
      {isPopular && (
        <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
          <span className="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-medium">
            Le plus populaire
          </span>
        </div>
      )}
      
      {isRecommended && (
        <div className="absolute -top-3 right-4">
          <span className="bg-green-500 text-white px-3 py-1 rounded-full text-sm font-medium">
            Recommandé
          </span>
        </div>
      )}

      {/* Contenu */}
      <div className="text-center">
        <h3 className="text-xl font-semibold text-white mb-2 capitalize">
          {planType}
        </h3>
        
        <div className="mb-4">
          <span className="text-3xl font-bold text-white">
            {formatPrice(plan.amount)}€
          </span>
          <span className="text-white/70">
            /{getIntervalLabel(interval)}
          </span>
        </div>

        {plan.trialDays > 0 && (
          <div className="bg-green-500/20 text-green-300 px-3 py-1 rounded-full text-sm mb-6">
            {plan.trialDays} jours gratuit
          </div>
        )}

        {/* Fonctionnalités */}
        <ul className="text-white/80 text-sm space-y-2 mb-8">
          {getPlanFeatures(planType).map((feature, index) => (
            <li key={index} className="flex items-center">
              <span className="text-green-400 mr-2">✓</span>
              {feature}
            </li>
          ))}
        </ul>

        <button
          onClick={onSelect}
          className={`w-full py-3 rounded-lg font-semibold transition-all ${
            isPopular
              ? 'bg-blue-600 hover:bg-blue-700 text-white'
              : isRecommended
              ? 'bg-green-600 hover:bg-green-700 text-white'
              : 'bg-white/20 hover:bg-white/30 text-white'
          }`}
        >
          Essai {plan.trialDays}j gratuit
        </button>
      </div>
    </div>
  )
}
