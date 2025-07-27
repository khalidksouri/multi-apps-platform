'use client';

import React, { useState } from 'react';
import { PricingPlan } from '@/types/pricing';
import { OPTIMAL_PRICING_PLANS } from '@/lib/constants';

interface PricingComponentProps {
  onPlanSelect?: (planId: string, period: string) => Promise<void>;
}

export const PricingComponent: React.FC<PricingComponentProps> = ({ onPlanSelect }) => {
  const [selectedPeriod, setSelectedPeriod] = useState<'monthly' | 'quarterly' | 'annual'>('monthly');
  const [loading, setLoading] = useState<string | null>(null);

  const handlePlanSelect = async (planId: string) => {
    if (onPlanSelect) {
      setLoading(planId);
      try {
        await onPlanSelect(planId, selectedPeriod);
      } catch (error) {
        console.error('Erreur lors de la sélection du plan:', error);
      } finally {
        setLoading(null);
      }
    }
  };

  const plans = OPTIMAL_PRICING_PLANS[selectedPeriod];

  const getPeriodLabel = (period: string) => {
    switch (period) {
      case 'monthly': return 'Mensuel';
      case 'quarterly': return 'Trimestriel';
      case 'annual': return 'Annuel';
      default: return 'Mensuel';
    }
  };

  const getColorClasses = (color: string, isPopular: boolean = false) => {
    const baseClasses = {
      gray: 'border-gray-200 bg-gray-50',
      blue: 'border-blue-200 bg-blue-50',
      purple: 'border-purple-200 bg-purple-50',
      green: 'border-green-200 bg-green-50'
    };

    const popularClasses = {
      gray: 'border-gray-400 bg-gray-100',
      blue: 'border-blue-400 bg-blue-100 ring-2 ring-blue-400',
      purple: 'border-purple-400 bg-purple-100 ring-2 ring-purple-400',
      green: 'border-green-400 bg-green-100'
    };

    return isPopular ? popularClasses[color as keyof typeof popularClasses] : baseClasses[color as keyof typeof baseClasses];
  };

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      {/* En-tête avec titre */}
      <div className="text-center mb-8">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          Choisissez votre abonnement
        </h1>
        <p className="text-xl text-gray-600">
          Plus compétitif que toute la concurrence
        </p>
      </div>

      {/* Sélecteur de période */}
      <div className="flex justify-center mb-8">
        <div className="bg-gray-100 p-1 rounded-lg flex">
          {(['monthly', 'quarterly', 'annual'] as const).map((period) => (
            <button
              key={period}
              onClick={() => setSelectedPeriod(period)}
              className={`px-6 py-2 rounded-md font-medium transition-all ${
                selectedPeriod === period
                  ? 'bg-white text-blue-600 shadow-sm'
                  : 'text-gray-600 hover:text-blue-600'
              }`}
            >
              {getPeriodLabel(period)}
              {period === 'quarterly' && (
                <span className="ml-2 text-xs bg-green-100 text-green-800 px-2 py-1 rounded">-10%</span>
              )}
              {period === 'annual' && (
                <span className="ml-2 text-xs bg-green-100 text-green-800 px-2 py-1 rounded">-25%</span>
              )}
            </button>
          ))}
        </div>
      </div>

      {/* Grille des plans */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {plans.map((plan) => (
          <div
            key={plan.id}
            data-plan={plan.id}
            data-testid={`plan-${plan.id}`}
            className={`relative rounded-2xl border-2 p-6 transition-all hover:shadow-lg ${getColorClasses(plan.color, plan.popular)}`}
          >
            {/* Badge populaire */}
            {plan.popular && (
              <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                  Recommandé
                </span>
              </div>
            )}

            {/* En-tête du plan */}
            <div className="text-center mb-6">
              <h3 className="text-xl font-bold text-gray-900 mb-2">{plan.name}</h3>
              <div className="mb-2">
                {plan.price === 0 ? (
                  <span className="text-3xl font-bold text-gray-900">Gratuit</span>
                ) : (
                  <div className="flex items-center justify-center">
                    <span className="text-3xl font-bold text-gray-900" data-testid="price">
                      {plan.price}€
                    </span>
                    <span className="text-gray-600 ml-1">
                      /{selectedPeriod === 'monthly' ? 'mois' : selectedPeriod === 'quarterly' ? 'trim' : 'an'}
                    </span>
                  </div>
                )}
              </div>

              {/* Prix barré et économies */}
              {plan.originalPrice && plan.originalPrice > plan.price && (
                <div className="text-center">
                  <span className="text-sm text-gray-500 line-through">
                    {plan.originalPrice}€
                  </span>
                  {plan.savings && (
                    <div className="text-sm text-green-600 font-medium mt-1">
                      {plan.savings}
                    </div>
                  )}
                </div>
              )}

              <div className="text-sm text-gray-600 mt-2">
                {plan.profiles} profil{plan.profiles > 1 ? 's' : ''}
              </div>
            </div>

            {/* Fonctionnalités */}
            <ul className="space-y-3 mb-6">
              {plan.features.map((feature, index) => (
                <li key={index} className="flex items-start">
                  <svg
                    className="w-5 h-5 text-green-500 mt-0.5 mr-3 flex-shrink-0"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                  >
                    <path
                      fillRule="evenodd"
                      d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                      clipRule="evenodd"
                    />
                  </svg>
                  <span className="text-sm text-gray-700">{feature}</span>
                </li>
              ))}
            </ul>

            {/* Bouton d'action */}
            <button
              onClick={() => handlePlanSelect(plan.id)}
              disabled={loading === plan.id}
              className={`w-full py-3 px-4 rounded-lg font-medium transition-all ${
                plan.popular
                  ? 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-2 focus:ring-blue-500'
                  : 'bg-gray-900 text-white hover:bg-gray-800 focus:ring-2 focus:ring-gray-500'
              } ${loading === plan.id ? 'opacity-50 cursor-not-allowed' : ''}`}
            >
              {loading === plan.id ? (
                <div className="flex items-center justify-center">
                  <div className="animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent mr-2"></div>
                  Chargement...
                </div>
              ) : (
                plan.button
              )}
            </button>
          </div>
        ))}
      </div>

      {/* Section de sélection actuelle */}
      <div className="mt-12 bg-gray-50 rounded-lg p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Votre sélection</h3>
        <div className="flex items-center justify-between">
          <div>
            <span className="text-sm text-gray-600">Plan:</span>
            <span className="font-medium text-gray-900 ml-2">Gratuit</span>
          </div>
          <div>
            <span className="text-sm text-gray-600">Période:</span>
            <span className="font-medium text-gray-900 ml-2">{getPeriodLabel(selectedPeriod)}</span>
          </div>
        </div>
        <p className="text-sm text-gray-500 mt-2">1 profils inclus</p>
      </div>
    </div>
  );
};
