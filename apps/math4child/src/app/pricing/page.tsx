'use client';

import { useState, useEffect } from 'react';

export default function PricingPage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return <div className="min-h-screen flex items-center justify-center">Chargement...</div>;

  const plans = [
    { name: 'BASIC', price: '4.99€', profiles: '1 Profil', features: ['Exercices de base', 'Support email'], popular: false },
    { name: 'STANDARD', price: '9.99€', profiles: '2 Profils', features: ['Tous les modes', 'Support prioritaire'], popular: false },
    { name: 'PREMIUM', price: '14.99€', profiles: '3 Profils', features: ['6 Innovations', 'IA avancée', 'Support 24/7'], popular: true },
    { name: 'FAMILLE', price: '19.99€', profiles: '5 Profils', features: ['Dashboard parental', 'Rapports détaillés'], popular: false },
    { name: 'ULTIMATE', price: 'Sur devis', profiles: '10+ Profils', features: ['Solution entreprise', 'Support dédié'], popular: false }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 to-purple-900 text-white">
      <div className="max-w-7xl mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h1 className="text-6xl font-bold mb-6">💎 Plans d'Abonnement</h1>
          <p className="text-2xl mb-4">Conformes aux spécifications Math4Child</p>
          <div className="bg-green-500 text-white px-6 py-2 rounded-full inline-block">
            ✨ 1, 2, 3, 5, 10+ Profils ✨
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-5 gap-6">
          {plans.map((plan, index) => (
            <div key={index} className={`relative bg-gray-900/50 rounded-2xl p-6 transition-transform hover:scale-105 ${
              plan.popular ? 'border-2 border-yellow-500' : 'border border-gray-700'
            }`}>
              {plan.popular && (
                <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                  <div className="bg-yellow-500 text-black px-4 py-1 rounded-full text-sm font-bold">
                    ⭐ LE PLUS CHOISI
                  </div>
                </div>
              )}
              
              <div className="text-center">
                <h3 className="text-2xl font-bold mb-2">{plan.name}</h3>
                <p className="text-gray-400 mb-4">{plan.profiles}</p>
                <div className="text-4xl font-bold mb-6">{plan.price}</div>
                <ul className="text-sm text-gray-300 mb-6 space-y-2">
                  {plan.features.map((feature, idx) => (
                    <li key={idx} className="flex items-center">
                      <span className="text-green-400 mr-2">✓</span>
                      {feature}
                    </li>
                  ))}
                </ul>
                <button 
                  type="button"
                  className={`w-full py-3 rounded font-semibold transition-colors ${
                    plan.popular ? 'bg-yellow-500 text-black hover:bg-yellow-400' : 'bg-blue-600 text-white hover:bg-blue-700'
                  }`}
                >
                  Choisir ce plan
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
