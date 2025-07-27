'use client';

import { useState, useRef, useEffect } from 'react';

// Types et interfaces
interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  profiles: number;
  features: string[];
  popular?: boolean;
}

interface Level {
  id: number;
  name: string;
  icon: string;
  progress: number;
  isLocked: boolean;
  isCompleted: boolean;
}

// Données
const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹' }
];

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
    popular: true
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
      'Support pédagogique dédié'
    ]
  }
];

const LEVELS: Level[] = [
  { id: 1, name: 'Niveau 1', icon: '🌱', progress: 75, isLocked: false, isCompleted: false },
  { id: 2, name: 'Niveau 2', icon: '🌿', progress: 45, isLocked: false, isCompleted: false },
  { id: 3, name: 'Niveau 3', icon: '🌳', progress: 20, isLocked: false, isCompleted: false },
  { id: 4, name: 'Niveau 4', icon: '🏔️', progress: 0, isLocked: true, isCompleted: false },
  { id: 5, name: 'Niveau 5', icon: '🏆', progress: 0, isLocked: true, isCompleted: false }
];

export default function Math4ChildPage() {
  const [selectedLanguage, setSelectedLanguage] = useState<Language>(LANGUAGES[0]);
  const [isLanguageOpen, setIsLanguageOpen] = useState(false);
  const [selectedLevel, setSelectedLevel] = useState<Level>(LEVELS[0]);
  const [selectedPlan, setSelectedPlan] = useState<SubscriptionPlan>(SUBSCRIPTION_PLANS[0]);

  const languageDropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (languageDropdownRef.current && !languageDropdownRef.current.contains(event.target as Node)) {
        setIsLanguageOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

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

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      <div className="container mx-auto px-4 py-8 max-w-7xl">
        
        {/* Header avec sélecteur de langue */}
        <header className="flex flex-col sm:flex-row justify-between items-center mb-16 gap-4">
          <div className="flex items-center space-x-4">
            <div className="w-16 h-16 bg-gradient-to-br from-indigo-600 to-purple-600 rounded-2xl flex items-center justify-center shadow-lg">
              <span className="text-white text-3xl font-bold">M</span>
            </div>
            <div>
              <h1 className="text-3xl font-bold text-gray-900">Math4Child</h1>
              <p className="text-lg text-gray-600">Apprendre les maths en s'amusant</p>
            </div>
          </div>

          <div className="relative" ref={languageDropdownRef}>
            <div
              onClick={() => setIsLanguageOpen(!isLanguageOpen)}
              className="flex items-center space-x-3 px-6 py-3 bg-white border-2 border-gray-200 rounded-xl shadow-md hover:shadow-lg hover:border-indigo-300 transition-all duration-200 cursor-pointer"
            >
              <span className="text-2xl">{selectedLanguage.flag}</span>
              <span className="text-sm font-semibold text-gray-700">{selectedLanguage.name}</span>
              <svg className="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
              </svg>
            </div>

            {isLanguageOpen && (
              <div className="absolute top-full right-0 mt-2 w-64 bg-white border border-gray-200 rounded-xl shadow-2xl z-50 overflow-hidden">
                <div className="p-4 bg-gray-50 border-b border-gray-100">
                  <h3 className="text-sm font-bold text-gray-900">Sélectionner une langue</h3>
                </div>
                <div className="py-2">
                  {LANGUAGES.map((language) => (
                    <div
                      key={language.code}
                      onClick={() => handleLanguageChange(language)}
                      className="px-4 py-3 hover:bg-indigo-50 flex items-center space-x-3 transition-colors cursor-pointer"
                    >
                      <span className="text-2xl">{language.flag}</span>
                      <div className="flex-1">
                        <div className="font-semibold text-sm text-gray-900">{language.name}</div>
                        <div className="text-xs text-gray-500">{language.nativeName}</div>
                      </div>
                      {language.code === selectedLanguage.code && (
                        <div className="text-indigo-600 text-lg font-bold">✓</div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </header>

        {/* Titre principal avec design amélioré */}
        <section className="text-center mb-20">
          <h2 className="text-6xl font-bold bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-8">
            Apprends les maths en t'amusant !
          </h2>
          <p className="text-2xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
            Découvre une nouvelle façon d'apprendre les mathématiques avec des exercices interactifs et ludiques adaptés à ton niveau.
          </p>
        </section>

        {/* Section progression des niveaux améliorée */}
        <section className="mb-20">
          <div className="mb-10 bg-white rounded-2xl p-8 shadow-xl border border-gray-100">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-2xl font-bold text-gray-900">Ta progression</h3>
              <span className="text-sm font-semibold text-indigo-600 bg-indigo-100 px-4 py-2 rounded-full">
                5 niveaux disponibles
              </span>
            </div>
            <div className="flex space-x-3">
              {LEVELS.map((level) => (
                <div key={level.id} className="flex-1">
                  <div className="h-4 rounded-full bg-gray-200 overflow-hidden">
                    {level.progress > 0 && (
                      <div 
                        className="h-full bg-gradient-to-r from-yellow-400 to-orange-400 rounded-full transition-all duration-700 ease-out"
                        style={{ width: `${level.progress}%` }}
                      />
                    )}
                  </div>
                  <div className="text-sm text-center mt-2 font-semibold text-gray-700">{level.name}</div>
                  <div className="text-xs text-center text-gray-500">{level.progress}%</div>
                </div>
              ))}
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-8">
            {LEVELS.map((level) => (
              <div
                key={level.id}
                onClick={() => handleLevelSelect(level)}
                className={`p-8 bg-white rounded-2xl shadow-lg border-2 transition-all duration-300 cursor-pointer transform hover:scale-105 ${
                  level.isLocked 
                    ? 'border-gray-200 opacity-60' 
                    : selectedLevel.id === level.id
                    ? 'border-indigo-400 shadow-xl ring-4 ring-indigo-100'
                    : 'border-gray-200 hover:border-indigo-300 hover:shadow-xl'
                }`}
              >
                <div className="text-center">
                  <div className="text-5xl mb-4">{level.icon}</div>
                  <h4 className="font-bold text-gray-900 mb-2 text-lg">{level.name}</h4>
                  <p className="text-sm text-gray-600 mb-4 font-medium">
                    {level.isCompleted ? '🎉 Terminé !' : level.isLocked ? '🔒 Verrouillé' : '📚 En cours'}
                  </p>

                  <div className="mb-4">
                    <div className="flex justify-between text-sm text-gray-600 mb-2 font-semibold">
                      <span>Progrès</span>
                      <span>{level.progress}%</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                      <div 
                        className="h-full bg-gradient-to-r from-blue-400 to-blue-600 rounded-full transition-all duration-700 ease-out"
                        style={{ width: `${level.progress}%` }}
                      />
                    </div>
                  </div>

                  {!level.isLocked && (
                    <button className="w-full mt-2 px-4 py-2 bg-indigo-600 text-white rounded-lg font-semibold hover:bg-indigo-700 transition-colors text-sm">
                      {level.progress > 0 ? 'Continuer' : 'Commencer'}
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Section plans d'abonnement améliorée */}
        <section className="mb-16">
          <div className="text-center mb-16">
            <h3 className="text-4xl font-bold bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent mb-6">
              Choisis ton plan
            </h3>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              Accède à tous les niveaux et fonctionnalités avec nos prix les plus compétitifs
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-6xl mx-auto">
            {SUBSCRIPTION_PLANS.map((plan) => (
              <div
                key={plan.id}
                className={`relative p-8 bg-white rounded-2xl shadow-xl border-2 transition-all duration-300 hover:shadow-2xl hover:scale-105 ${
                  plan.popular 
                    ? 'border-indigo-400 ring-4 ring-indigo-100' 
                    : 'border-gray-200 hover:border-indigo-300'
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-gradient-to-r from-indigo-600 to-purple-600 text-white text-sm px-6 py-2 rounded-full font-bold shadow-lg">
                      ⭐ Populaire
                    </span>
                  </div>
                )}

                <div className="text-center mb-8">
                  <h4 className="text-2xl font-bold text-gray-900 mb-4">{plan.name}</h4>
                  <div className="mb-4">
                    <span className="text-5xl font-bold bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent">
                      {plan.price}€
                    </span>
                    <span className="text-gray-500 text-lg font-semibold">/mois</span>
                  </div>
                  <div className="text-lg text-gray-600 font-semibold bg-gray-50 py-2 px-4 rounded-lg">
                    {plan.profiles} profils inclus
                  </div>
                </div>

                <ul className="space-y-4 mb-8">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-start">
                      <span className="text-green-500 mr-3 mt-1 text-lg">✓</span>
                      <span className="text-gray-700 font-medium">{feature}</span>
                    </li>
                  ))}
                </ul>

                <button
                  onClick={() => handlePlanSelect(plan)}
                  className={`w-full py-4 px-6 rounded-xl font-bold text-lg transition-all duration-300 transform hover:scale-105 ${
                    plan.popular
                      ? 'bg-gradient-to-r from-indigo-600 to-purple-600 text-white shadow-lg hover:shadow-xl'
                      : 'bg-gray-900 text-white hover:bg-gray-800 shadow-lg hover:shadow-xl'
                  }`}
                >
                  Choisir ce plan
                </button>
              </div>
            ))}
          </div>

          {/* Section garanties */}
          <div className="mt-16 bg-white rounded-2xl p-8 shadow-xl border border-gray-100">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
              <div>
                <div className="text-4xl mb-4">🔒</div>
                <h4 className="font-bold text-gray-900 mb-2">Paiement sécurisé</h4>
                <p className="text-gray-600">Transactions protégées et chiffrées</p>
              </div>
              <div>
                <div className="text-4xl mb-4">🔄</div>
                <h4 className="font-bold text-gray-900 mb-2">Annulation facile</h4>
                <p className="text-gray-600">Résiliez à tout moment sans frais</p>
              </div>
              <div>
                <div className="text-4xl mb-4">✨</div>
                <h4 className="font-bold text-gray-900 mb-2">Satisfaction garantie</h4>
                <p className="text-gray-600">30 jours satisfait ou remboursé</p>
              </div>
            </div>
          </div>
        </section>

      </div>
    </div>
  );
}
