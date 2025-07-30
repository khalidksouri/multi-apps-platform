'use client';

import { X, Check, Star, Users, School } from 'lucide-react';
import { useLanguage } from '@/hooks/useLanguage';

interface PricingModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function PricingModal({ isOpen, onClose }: PricingModalProps) {
  const { t } = useLanguage();

  if (!isOpen) return null;

  const plans = [
    {
      id: 'free',
      name: t('planFree'),
      price: '0€',
      period: '7 jours',
      description: 'Version d\'essai limitée',
      features: [
        '1 profil enfant',
        'Niveau débutant uniquement',
        '50 questions totales',
        'Suivi de base'
      ],
      buttonText: 'Essayer Gratuitement',
      buttonClass: 'bg-gray-500 hover:bg-gray-600',
      warning: '⚠️ Durée limitée - Non renouvelable'
    },
    {
      id: 'premium',
      name: t('planPremium'),
      price: '4.99€',
      period: t('month'),
      description: 'Parfait pour 1-2 enfants',
      features: [
        '2 profils enfants',
        'Tous les niveaux + bonus',
        'Mode révision',
        'Défis chronométrés',
        'Analyse détaillée des erreurs'
      ],
      buttonText: t('choosePlan'),
      buttonClass: 'bg-purple-500 hover:bg-purple-600'
    },
    {
      id: 'family',
      name: t('planFamily'),
      price: '6.99€',
      period: t('month'),
      description: 'Le plus populaire',
      features: [
        '5 profils enfants',
        'Tous les niveaux 1→5',
        'Exercices illimités',
        'Statistiques par opération',
        'Rapports de progression',
        'Support prioritaire'
      ],
      buttonText: t('choosePlan'),
      buttonClass: 'bg-blue-500 hover:bg-blue-600',
      popular: true,
      badge: t('popular')
    },
    {
      id: 'school',
      name: t('planSchool'),
      price: '24.99€',
      period: t('month'),
      description: 'Pour écoles et associations',
      features: [
        '30 profils élèves',
        'Gestion par niveaux',
        'Tableau de bord enseignant',
        'Export des résultats',
        'Support pédagogique dédié',
        'Formation incluse'
      ],
      buttonText: t('choosePlan'),
      buttonClass: 'bg-green-500 hover:bg-green-600',
      badge: 'Recommandé écoles',
      icon: <School size={20} />
    }
  ];

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-3xl max-w-6xl w-full max-h-[90vh] overflow-y-auto">
        {/* Header premium */}
        <div className="flex justify-between items-center p-6 border-b border-gray-200">
          <div>
            <h2 className="text-3xl font-bold text-gray-800">Choisissez votre Plan</h2>
            <p className="text-gray-600 mt-1">Débloquez tout le potentiel de Math4Child</p>
          </div>
          <button
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700 p-2 rounded-lg hover:bg-gray-100"
          >
            <X size={24} />
          </button>
        </div>

        {/* Plans premium */}
        <div className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {plans.map((plan) => (
              <div
                key={plan.id}
                className={`relative bg-white rounded-2xl border-2 p-6 transition-all duration-200 hover:shadow-lg ${
                  plan.popular 
                    ? 'border-blue-500 shadow-lg scale-105' 
                    : 'border-gray-200 hover:border-blue-300'
                }`}
              >
                {/* Badge premium */}
                {(plan.popular || plan.badge) && (
                  <div className={`absolute -top-3 left-1/2 transform -translate-x-1/2 px-4 py-1 rounded-full text-xs font-semibold text-white ${
                    plan.popular ? 'bg-blue-500' : 'bg-green-500'
                  }`}>
                    {plan.badge}
                  </div>
                )}

                {/* Icon pour école */}
                {plan.icon && (
                  <div className="flex justify-center mb-4">
                    <div className="p-3 bg-green-100 rounded-full text-green-600">
                      {plan.icon}
                    </div>
                  </div>
                )}

                {/* Header du plan */}
                <div className="text-center mb-6">
                  <h3 className="text-xl font-bold text-gray-800 mb-2">{plan.name}</h3>
                  <div className="mb-2">
                    <span className="text-3xl font-bold text-blue-600">{plan.price}</span>
                    {plan.period && <span className="text-gray-500 text-sm">{plan.period}</span>}
                  </div>
                  <p className="text-gray-600 text-sm">{plan.description}</p>
                </div>

                {/* Features premium */}
                <ul className="space-y-3 mb-6">
                  {plan.features.map((feature, idx) => (
                    <li key={idx} className="flex items-start">
                      <Check className="w-5 h-5 text-green-500 mr-3 mt-0.5 flex-shrink-0" />
                      <span className="text-gray-600 text-sm">{feature}</span>
                    </li>
                  ))}
                </ul>

                {/* Warning pour plan gratuit */}
                {plan.warning && (
                  <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-4">
                    <p className="text-yellow-800 text-xs font-medium">{plan.warning}</p>
                  </div>
                )}

                {/* Bouton premium */}
                <button className={`w-full py-3 rounded-xl font-semibold text-white transition-all duration-200 ${plan.buttonClass}`}>
                  {plan.buttonText}
                </button>
              </div>
            ))}
          </div>

          {/* Section réductions multi-appareils premium */}
          <div className="mt-8 bg-gradient-to-r from-purple-50 to-pink-50 rounded-2xl p-6">
            <h3 className="text-xl font-bold text-gray-800 mb-4 text-center">
              💡 Réductions Multi-Appareils
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="text-center p-4 bg-white rounded-xl">
                <div className="text-2xl mb-2">📱</div>
                <div className="font-semibold text-gray-800">1er appareil</div>
                <div className="text-green-600 font-bold">Prix plein</div>
              </div>
              <div className="text-center p-4 bg-white rounded-xl">
                <div className="text-2xl mb-2">💻</div>
                <div className="font-semibold text-gray-800">2ème appareil</div>
                <div className="text-blue-600 font-bold">-50%</div>
              </div>
              <div className="text-center p-4 bg-white rounded-xl">
                <div className="text-2xl mb-2">🖥️</div>
                <div className="font-semibold text-gray-800">3ème appareil</div>
                <div className="text-purple-600 font-bold">-75%</div>
              </div>
            </div>
          </div>

          {/* Footer premium */}
          <div className="mt-6 text-center">
            <p className="text-gray-500 text-sm">
              🔒 Paiement sécurisé • ✨ Garantie 30 jours • 🌍 Support multilingue
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
