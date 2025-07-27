'use client';

import React, { useState, useRef, useEffect } from 'react';

// Types et interfaces
interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  continent: string;
  currency: string;
}

interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  profiles: number;
  features: string[];
  popular?: boolean;
  savings?: string;
}

interface Level {
  id: number;
  name: string;
  icon: string;
  progress: number;
  isLocked: boolean;
  isCompleted: boolean;
}

// Données des langues
const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', continent: 'Europe', currency: 'EUR' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', continent: 'America', currency: 'USD' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', continent: 'Europe', currency: 'EUR' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', continent: 'Europe', currency: 'EUR' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', continent: 'Europe', currency: 'EUR' }
];

// Plans d'abonnement optimisés
const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: 'family',
    name: 'Famille',
    price: 6.99,
    profiles: 5,
    features: [
      '5 profils enfants',
      'Tous les niveaux (1 à 5)',
      'Exercices illimités',
      'Suivi détaillé des progrès',
      'Statistiques par opération',
      'Rapports de progression'
    ],
    popular: true,
    savings: '30%'
  },
  {
    id: 'premium',
    name: 'Premium',
    price: 4.99,
    profiles: 2,
    features: [
      '2 profils enfants',
      'Tous les niveaux + exercices bonus',
      'Mode révision niveaux validés',
      'Défis chronométrés',
      'Analyse détaillée des erreurs',
      'Recommandations personnalisées',
      'Mode hors-ligne complet'
    ]
  },
  {
    id: 'school',
    name: 'École',
    price: 24.99,
    profiles: 30,
    features: [
      '30 profils élèves',
      'Gestion par niveaux (1 à 5)',
      'Tableau de bord enseignant',
      'Suivi collectif des validations',
      'Attribution d\'exercices ciblés',
      'Rapports de classe détaillés',
      'Support pédagogique dédié'
    ]
  }
];

// Niveaux de jeu
const LEVELS: Level[] = [
  { id: 1, name: 'Niveau 1', icon: '🌱', progress: 75, isLocked: false, isCompleted: false },
  { id: 2, name: 'Niveau 2', icon: '🌿', progress: 45, isLocked: false, isCompleted: false },
  { id: 3, name: 'Niveau 3', icon: '🌳', progress: 20, isLocked: false, isCompleted: false },
  { id: 4, name: 'Niveau 4', icon: '🏔️', progress: 0, isLocked: true, isCompleted: false },
  { id: 5, name: 'Niveau 5', icon: '🏆', progress: 0, isLocked: true, isCompleted: false }
];

export default function Math4ChildPage() {
  // États du composant
  const [selectedLanguage, setSelectedLanguage] = useState<Language>(LANGUAGES[0]);
  const [isLanguageOpen, setIsLanguageOpen] = useState(false);
  const [selectedLevel, setSelectedLevel] = useState<Level>(LEVELS[0]);
  const [selectedPlan, setSelectedPlan] = useState<SubscriptionPlan>(SUBSCRIPTION_PLANS[0]);
  const [billingPeriod, setBillingPeriod] = useState<'monthly' | 'quarterly' | 'annual'>('monthly');

  const languageDropdownRef = useRef<HTMLDivElement>(null);

  // Gestion des clics en dehors du dropdown
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (languageDropdownRef.current && !languageDropdownRef.current.contains(event.target as Node)) {
        setIsLanguageOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Fonctions de gestion des événements
  const handleLanguageChange = (language: Language) => {
    setSelectedLanguage(language);
    setIsLanguageOpen(false);
  };

  const handleLevelSelect = (level: Level) => {
    if (!level.isLocked) {
      setSelectedLevel(level);
    }
  };

  const handlePlanSelect = (plan: SubscriptionPlan) => {
    setSelectedPlan(plan);
    alert(`Plan ${plan.name} sélectionné pour ${plan.price}€/mois !`);
  };

  const updateLevelProgress = (levelId: number, newProgress: number) => {
    console.log(`Mise à jour niveau ${levelId}: ${newProgress}%`);
  };

  // Calcul des prix selon la période
  const getPrice = (plan: SubscriptionPlan) => {
    switch (billingPeriod) {
      case 'quarterly':
        return plan.price * 3 * 0.9;
      case 'annual':
        return plan.price * 12 * 0.7;
      default:
        return plan.price;
    }
  };

  const getPeriodLabel = () => {
    switch (billingPeriod) {
      case 'quarterly': return '/trimestre';
      case 'annual': return '/an';
      default: return '/mois';
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="container mx-auto px-4 py-8 max-w-6xl">
        
        {/* Header avec sélecteur de langue */}
        <header className="flex justify-between items-center mb-12">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 bg-indigo-600 rounded-xl flex items-center justify-center">
              <span className="text-white text-2xl font-bold">M</span>
            </div>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">Math4Child</h1>
              <p className="text-sm text-gray-600">Apprendre les maths en s'amusant</p>
            </div>
          </div>

          <div className="relative" ref={languageDropdownRef}>
            <div
              onClick={() => setIsLanguageOpen(!isLanguageOpen)}
              className="flex items-center space-x-2 px-4 py-2 bg-white border border-gray-300 rounded-lg shadow-sm hover:bg-gray-50 transition-colors cursor-pointer"
              role="button"
              tabIndex={0}
            >
              <span className="text-xl">{selectedLanguage.flag}</span>
              <span className="text-sm font-medium text-gray-700">{selectedLanguage.name}</span>
              <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
              </svg>
            </div>

            {isLanguageOpen && (
              <div className="absolute top-full right-0 mt-3 w-56 bg-white border border-gray-200 rounded-lg shadow-xl z-50">
                <div className="p-3 border-b border-gray-100">
                  <h3 className="text-sm font-semibold text-gray-900">Sélectionner une langue</h3>
                </div>
                <div className="py-1">
                  {LANGUAGES.map((language) => (
                    <div
                      key={language.code}
                      onClick={() => handleLanguageChange(language)}
                      className="px-4 py-3 text-left hover:bg-gray-50 flex items-center space-x-3 transition-colors cursor-pointer"
                      role="button"
                      tabIndex={0}
                    >
                      <span className="text-xl">{language.flag}</span>
                      <div className="flex-1">
                        <div className="font-medium text-sm">{language.name}</div>
                        <div className="text-xs text-gray-500">{language.nativeName}</div>
                      </div>
                      {language.code === selectedLanguage.code && (
                        <div className="text-indigo-600 text-sm font-bold">✓</div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </header>

        {/* Section titre principal */}
        <section className="text-center mb-16">
          <h2 className="text-5xl font-bold text-gray-900 mb-6">
            Apprends les maths en t'amusant !
          </h2>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Découvre une nouvelle façon d'apprendre les mathématiques avec des exercices interactifs et ludiques adaptés à ton niveau.
          </p>
        </section>

        {/* Section progression des niveaux */}
        <section className="mb-16">
          <div className="mb-8 bg-white rounded-lg p-6 shadow-sm">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">Ta progression</h3>
              <span className="text-sm text-gray-500">5 niveaux disponibles</span>
            </div>
            <div className="flex space-x-2">
              {LEVELS.map((level) => (
                <div key={level.id} className="flex-1">
                  <div className="h-3 rounded-full bg-gray-200">
                    {level.progress > 0 && (
                      <div 
                        className="h-full bg-yellow-400 rounded-full transition-all duration-500"
                        style={{ width: `${level.progress}%` }}
                      />
                    )}
                  </div>
                  <div className="text-xs text-center mt-1 font-medium">{level.name}</div>
                </div>
              ))}
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6">
            {LEVELS.map((level) => (
              <div
                key={level.id}
                onClick={() => handleLevelSelect(level)}
                className="p-6 bg-white rounded-xl shadow-sm border-2 transition-all duration-200 relative hover:shadow-lg hover:scale-105 cursor-pointer"
                role="button"
                tabIndex={0}
              >
                <div className="text-center">
                  <div className="text-4xl mb-3">{level.icon}</div>
                  <h4 className="font-semibold text-gray-900 mb-1">{level.name}</h4>
                  <p className="text-xs text-gray-600 mb-3">
                    {level.isCompleted ? 'Terminé !' : level.isLocked ? 'Verrouillé' : 'En cours'}
                  </p>

                  <div className="mb-3">
                    <div className="flex justify-between text-xs text-gray-600 mb-1">
                      <span>Progrès</span>
                      <span>{level.progress}%</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className="h-2 rounded-full transition-all duration-500 bg-blue-500"
                        style={{ width: `${level.progress}%` }}
                      />
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Section plans d'abonnement */}
        <section className="mb-16">
          <div className="text-center mb-12">
            <h3 className="text-3xl font-bold text-gray-900 mb-4">Choisis ton plan</h3>
            <p className="text-lg text-gray-600">Accède à tous les niveaux et fonctionnalités</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {SUBSCRIPTION_PLANS.map((plan) => (
              <div
                key={plan.id}
                className="relative p-6 bg-white rounded-xl shadow-sm border-2 transition-all duration-200 hover:shadow-lg hover:scale-105"
              >
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-indigo-600 text-white text-xs px-3 py-1 rounded-full font-medium">
                      Populaire
                    </span>
                  </div>
                )}

                <div className="text-center mb-6">
                  <h4 className="text-xl font-bold text-gray-900 mb-2">{plan.name}</h4>
                  <div className="mb-2">
                    <span className="text-3xl font-bold text-gray-900">
                      {plan.price}€
                    </span>
                    <span className="text-gray-500 text-sm">/mois</span>
                  </div>
                  <div className="text-sm text-gray-600 mb-4">
                    {plan.profiles} profils inclus
                  </div>
                </div>

                <ul className="space-y-2 mb-6">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-start">
                      <span className="text-green-500 mr-2 mt-0.5">✓</span>
                      <span className="text-sm text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>

                <div
                  onClick={() => handlePlanSelect(plan)}
                  className="w-full py-3 px-4 rounded-lg font-semibold transition-all duration-200 hover:scale-105 text-center cursor-pointer bg-indigo-600 text-white hover:bg-indigo-700"
                  role="button"
                  tabIndex={0}
                >
                  Choisir ce plan
                </div>
              </div>
            ))}
          </div>
        </section>

      </div>
    </div>
  );
}
