'use client';

import React from 'react';
import { Check, Crown } from 'lucide-react';

const plans = [
  {
    name: 'BASIC',
    price: 4.99,
    profiles: 1,
    features: ['1 profil', '5 niveaux', '100 réponses min/niveau']
  },
  {
    name: 'STANDARD',
    price: 9.99,
    profiles: 2,
    features: ['2 profils', 'IA avancée', 'Reconnaissance manuscrite']
  },
  {
    name: 'PREMIUM',
    price: 14.99,
    profiles: 3,
    popular: true,
    features: ['3 profils', 'Assistant vocal IA', 'Réalité augmentée 3D']
  },
  {
    name: 'FAMILLE',
    price: 19.99,
    profiles: 5,
    features: ['5 profils', 'Contrôle parental', 'Support VIP']
  },
  {
    name: 'ULTIMATE',
    price: 29.99,
    profiles: '10+',
    features: ['10+ profils', 'API développeur', 'Support 24/7']
  }
];

export default function SimplePricing() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {plans.map((plan) => (
        <div key={plan.name} className={`
          bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20
          ${plan.popular ? 'ring-2 ring-yellow-400' : ''}
        `}>
          <div className="text-center mb-4">
            <h3 className="text-xl font-bold text-white mb-2">
              {plan.name}
              {plan.popular && (
                <span className="block text-sm text-yellow-400 flex items-center justify-center gap-1">
                  <Crown className="w-4 h-4" />
                  LE PLUS CHOISI
                </span>
              )}
            </h3>
            <div className="text-3xl font-bold text-white">
              €{plan.price}
            </div>
            <div className="text-white/80 text-sm">par mois</div>
            <div className="text-white/60 text-sm mt-1">
              {plan.profiles} profil{typeof plan.profiles === 'number' && plan.profiles > 1 ? 's' : ''}
            </div>
          </div>
          
          <ul className="space-y-2 mb-6">
            {plan.features.map((feature, index) => (
              <li key={index} className="flex items-center gap-2 text-white/80 text-sm">
                <Check className="w-4 h-4 text-green-400" />
                {feature}
              </li>
            ))}
          </ul>
          
          <button className="w-full bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600 transition-colors">
            Choisir ce plan
          </button>
        </div>
      ))}
    </div>
  );
}
