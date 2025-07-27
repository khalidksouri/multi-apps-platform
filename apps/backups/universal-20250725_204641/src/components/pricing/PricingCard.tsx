import React from 'react';
import { PricingCardProps } from '@/types';

export const PricingCard: React.FC<PricingCardProps> = ({ plan, onSelect, className = '' }) => {
  return (
    <div
      className={`relative bg-white rounded-2xl p-6 border-2 transition-all duration-300 hover:shadow-lg ${
        plan.popular 
          ? 'border-purple-500 shadow-lg' 
          : 'border-gray-200 hover:border-gray-300'
      } ${className}`}
    >
      {plan.popular && (
        <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
          <div className="bg-purple-500 text-white px-4 py-1 rounded-full text-sm font-semibold">
            Le plus populaire
          </div>
        </div>
      )}

      <div className="text-center mb-6">
        <h3 className="text-xl font-bold text-gray-900 mb-2">{plan.name}</h3>
        <div className="flex items-center justify-center space-x-2">
          <span className="text-3xl font-bold text-gray-900">{plan.price}€</span>
          <span className="text-gray-500">/mois</span>
        </div>
        {plan.originalPrice && (
          <div className="text-sm text-gray-500 line-through">
            {plan.originalPrice}€/mois
          </div>
        )}
      </div>

      <ul className="space-y-3 mb-6">
        {plan.features.map((feature, index) => (
          <li key={index} className="flex items-center space-x-3">
            <div className="w-5 h-5 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
              <div className="w-2 h-2 bg-green-500 rounded-full"></div>
            </div>
            <span className="text-gray-700">{feature}</span>
          </li>
        ))}
      </ul>

      <button
        onClick={() => onSelect(plan.id)}
        className={`w-full py-3 px-4 rounded-xl font-semibold transition-all duration-300 hover:scale-105 focus:outline-none focus:ring-2 focus:ring-offset-2 ${
          plan.popular
            ? 'bg-gradient-to-r from-purple-500 to-purple-600 text-white hover:from-purple-600 hover:to-purple-700 shadow-lg focus:ring-purple-500'
            : 'bg-gray-100 text-gray-700 hover:bg-gray-200 focus:ring-gray-500'
        }`}
      >
        {plan.popular ? 'Commencer l\'essai gratuit' : 'Choisir ce plan'}
      </button>
    </div>
  );
};
