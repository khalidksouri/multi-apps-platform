'use client';

import React, { useState } from 'react';
import Link from 'next/link';

interface PricingPlan {
  id: string;
  name: string;
  price: {
    monthly: number;
    yearly: number;
  };
  description: string;
  features: string[];
  popular?: boolean;
  contact?: boolean;
}

type BillingPeriod = 'monthly' | 'yearly';

export default function SubscriptionPage() {
  const [billingPeriod, setBillingPeriod] = useState<BillingPeriod>('monthly');

  const plans: PricingPlan[] = [
    {
      id: 'free',
      name: 'Version Gratuite',
      price: { monthly: 0, yearly: 0 },
      description: '7 jours - 50 questions',
      features: ['50 questions au total', 'Tous les niveaux limités', 'Support par email', 'Accès 7 jours']
    },
    {
      id: 'monthly',
      name: 'Mensuel',
      price: { monthly: 9.99, yearly: 119.88 },
      description: 'Parfait pour commencer',
      features: ['Questions illimitées', 'Tous les niveaux débloqués', 'Toutes les opérations', 'Support prioritaire', 'Statistiques détaillées'],
      popular: true
    },
    {
      id: 'quarterly',
      name: 'Trimestriel',
      price: { monthly: 26.97, yearly: 323.64 },
      description: '3 mois - Économie de 10%',
      features: ['Tout du plan mensuel', 'Économie de 10%', 'Paiement unique', 'Support premium', 'Rapports de progression']
    },
    {
      id: 'family',
      name: 'Famille',
      price: { monthly: 19.99, yearly: 239.88 },
      description: 'Jusqu\'à 5 profils enfants',
      features: ['Jusqu\'à 5 profils', 'Toutes les fonctionnalités', 'Tableau de bord famille', 'Support téléphonique', 'Rapports personnalisés'],
      contact: true
    }
  ];

  const getPlanPrice = (plan: PricingPlan, period: BillingPeriod): number => {
    return plan.price[period];
  };

  const formatPrice = (price: number): string => {
    return price === 0 ? 'Gratuit' : `${price.toFixed(2)}€`;
  };

  const getButtonText = (plan: PricingPlan): string => {
    const price = getPlanPrice(plan, billingPeriod);
    
    if (price === 0) {
      return 'Commencer gratuitement';
    }
    
    if (plan.contact) {
      return 'Nous contacter';
    }
    
    return `S'abonner - ${formatPrice(price)}`;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <Link href="/" className="text-2xl font-bold text-blue-600">🧮 Math4Child</Link>
            </div>
            <nav className="flex space-x-8">
              <Link href="/" className="text-gray-700 hover:text-blue-600 font-medium">Accueil</Link>
              <Link href="/exercises" className="text-gray-700 hover:text-blue-600 font-medium">Exercices</Link>
              <Link href="/subscription" className="text-blue-600 font-medium">Abonnement</Link>
            </nav>
          </div>
        </div>
      </header>

      <div className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">Choisissez votre formule</h1>
            <p className="text-xl text-gray-600 mb-8">Des plans adaptés à tous les besoins d'apprentissage</p>

            <div className="flex justify-center mb-12">
              <div className="bg-gray-100 p-1 rounded-lg flex">
                <button
                  onClick={() => setBillingPeriod('monthly')}
                  className={`px-6 py-2 rounded-md font-medium transition-all ${
                    billingPeriod === 'monthly' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500 hover:text-gray-700'
                  }`}
                >
                  Mensuel
                </button>
                <button
                  onClick={() => setBillingPeriod('yearly')}
                  className={`px-6 py-2 rounded-md font-medium transition-all ${
                    billingPeriod === 'yearly' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500 hover:text-gray-700'
                  }`}
                >
                  Annuel
                  <span className="ml-2 text-xs bg-green-100 text-green-800 px-2 py-1 rounded-full">-20%</span>
                </button>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {plans.map((plan) => (
              <div
                key={plan.id}
                className={`relative bg-white rounded-2xl shadow-lg p-8 border-2 transition-all duration-300 hover:shadow-xl ${
                  plan.popular ? 'border-blue-500 transform scale-105' : 'border-gray-200 hover:border-blue-300'
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium">🔥 Populaire</span>
                  </div>
                )}

                <div className="text-center mb-6">
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                  <p className="text-gray-500 mb-4">{plan.description}</p>
                  
                  <div className="mb-6">
                    {getPlanPrice(plan, billingPeriod) === 0 ? (
                      <div className="text-4xl font-bold text-green-600">Gratuit</div>
                    ) : (
                      <>
                        <div className="text-4xl font-bold text-gray-900">{formatPrice(getPlanPrice(plan, billingPeriod))}</div>
                        <div className="text-gray-500">/{billingPeriod === 'monthly' ? 'mois' : 'an'}</div>
                      </>
                    )}
                  </div>
                </div>

                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-start">
                      <svg className="w-5 h-5 text-green-500 mr-3 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd"/>
                      </svg>
                      <span className="text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>

                <button className={`w-full py-3 px-6 rounded-lg font-semibold transition-all duration-200 ${
                  plan.popular ? 'bg-blue-600 text-white hover:bg-blue-700' : 'bg-gray-100 text-gray-900 hover:bg-gray-200'
                }`}>
                  {getButtonText(plan)}
                </button>

                {getPlanPrice(plan, billingPeriod) > 0 && !plan.contact && (
                  <div className="mt-4 text-center">
                    <p className="text-xs text-gray-500">Essai gratuit de 7 jours</p>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
