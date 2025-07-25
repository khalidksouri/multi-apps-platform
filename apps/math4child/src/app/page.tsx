'use client';

import React, { useState, useRef, useEffect } from 'react';
import { ChevronDown, X, Star, Globe, Users, BookOpen, Trophy, Zap } from 'lucide-react';

// Types locaux
interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  rtl?: boolean;
}

interface PricingPlan {
  id: string;
  name: string;
  price: number;
  originalPrice?: number;
  features: string[];
  popular?: boolean;
}

// Données
const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', rtl: true },
];

const FEATURES = [
  {
    id: 'premium-features',
    title: 'Fonctionnalités premium',
    description: 'Plus de 10 000 exercices personnalisés',
    icon: <Trophy className="w-8 h-8" />,
    gradient: 'from-yellow-400 to-orange-500',
    stats: '10 000+ exercices'
  },
  {
    id: 'progress-tracking',
    title: 'Suivi détaillé des progrès',
    description: 'Rapports hebdomadaires parents',
    icon: <BookOpen className="w-8 h-8" />,
    gradient: 'from-green-400 to-blue-500',
    stats: 'Rapports hebdomadaires'
  },
  {
    id: 'interactive-games',
    title: 'Jeux interactifs',
    description: '50+ mini-jeux disponibles',
    icon: <Zap className="w-8 h-8" />,
    gradient: 'from-purple-400 to-pink-500',
    stats: '50+ mini-jeux'
  }
];

const PRICING_PLANS: Record<string, PricingPlan[]> = {
  monthly: [
    {
      id: 'famille',
      name: 'Famille',
      price: 9.99,
      features: ['3 enfants max', 'Suivi basique', 'Support email']
    },
    {
      id: 'premium',
      name: 'Premium',
      price: 19.99,
      features: ['Enfants illimités', 'Suivi avancé', 'Support prioritaire', 'Rapports PDF'],
      popular: true
    },
    {
      id: 'ecole',
      name: 'École',
      price: 29.99,
      features: ['Classes multiples', 'Dashboard enseignant', 'API intégration']
    }
  ],
  quarterly: [
    {
      id: 'famille',
      name: 'Famille',
      price: 8.99,
      originalPrice: 9.99,
      features: ['3 enfants max', 'Suivi basique', 'Support email']
    },
    {
      id: 'premium',
      name: 'Premium',
      price: 17.99,
      originalPrice: 19.99,
      features: ['Enfants illimités', 'Suivi avancé', 'Support prioritaire', 'Rapports PDF'],
      popular: true
    },
    {
      id: 'ecole',
      name: 'École',
      price: 26.99,
      originalPrice: 29.99,
      features: ['Classes multiples', 'Dashboard enseignant', 'API intégration']
    }
  ],
  annual: [
    {
      id: 'famille',
      name: 'Famille',
      price: 6.99,
      originalPrice: 9.99,
      features: ['3 enfants max', 'Suivi basique', 'Support email']
    },
    {
      id: 'premium',
      name: 'Premium',
      price: 13.99,
      originalPrice: 19.99,
      features: ['Enfants illimités', 'Suivi avancé', 'Support prioritaire', 'Rapports PDF'],
      popular: true
    },
    {
      id: 'ecole',
      name: 'École',
      price: 20.99,
      originalPrice: 29.99,
      features: ['Classes multiples', 'Dashboard enseignant', 'API intégration']
    }
  ]
};

export default function HomePage() {
  const [selectedLanguage, setSelectedLanguage] = useState<Language>(LANGUAGES[0]);
  const [isLanguageDropdownOpen, setIsLanguageDropdownOpen] = useState<boolean>(false);
  const [isPricingModalOpen, setIsPricingModalOpen] = useState<boolean>(false);
  const [selectedPeriod, setSelectedPeriod] = useState<keyof typeof PRICING_PLANS>('monthly');
  const [languageSearch, setLanguageSearch] = useState<string>('');

  const languageDropdownRef = useRef<HTMLDivElement>(null);
  const pricingModalRef = useRef<HTMLDivElement>(null);

  // Fermer les dropdowns en cliquant à l'extérieur
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (languageDropdownRef.current && !languageDropdownRef.current.contains(event.target as Node)) {
        setIsLanguageDropdownOpen(false);
      }
      if (pricingModalRef.current && !pricingModalRef.current.contains(event.target as Node)) {
        setIsPricingModalOpen(false);
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Gestion du scroll pour le modal
  useEffect(() => {
    if (isPricingModalOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = 'unset';
    }
    return () => {
      document.body.style.overflow = 'unset';
    };
  }, [isPricingModalOpen]);

  const filteredLanguages = LANGUAGES.filter(lang =>
    lang.name.toLowerCase().includes(languageSearch.toLowerCase()) ||
    lang.nativeName.toLowerCase().includes(languageSearch.toLowerCase())
  );

  const handleLanguageChange = (language: Language) => {
    setSelectedLanguage(language);
    setIsLanguageDropdownOpen(false);
    setLanguageSearch('');
    console.log('Changement de langue vers:', language.code);
  };

  const handlePlanSelect = (planId: string, period: string) => {
    console.log('Plan sélectionné:', planId, 'Période:', period);
    setIsPricingModalOpen(false);
    // Ici vous ajouteriez votre logique de paiement
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-indigo-50">
      {/* Header moderne */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-lg border-b border-gray-200/50 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            
            {/* Logo avec animation */}
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center shadow-lg transform hover:scale-110 hover:rotate-3 transition-all duration-300 cursor-pointer">
                <span className="text-white font-bold text-xl">M4C</span>
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">Math pour enfants</h1>
                <p className="text-sm text-gray-600">L'app n°1 des familles</p>
              </div>
            </div>

            {/* Statistiques en temps réel */}
            <div className="hidden md:flex items-center space-x-6">
              <div className="flex items-center space-x-2 text-green-600">
                <Users className="w-4 h-4" />
                <span className="font-semibold">100k+ familles</span>
              </div>
              <div className="flex items-center space-x-2 text-blue-600">
                <Globe className="w-4 h-4" />
                <span className="font-semibold">47+ langues</span>
              </div>
            </div>

            {/* Sélecteur de langue amélioré */}
            <div className="relative" ref={languageDropdownRef}>
              <button
                onClick={() => setIsLanguageDropdownOpen(!isLanguageDropdownOpen)}
                className="flex items-center space-x-2 px-4 py-2 rounded-lg border border-gray-200 hover:border-gray-300 bg-white transition-all duration-200 hover:shadow-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                aria-label="Sélectionner une langue"
              >
                <span className="text-xl">{selectedLanguage.flag}</span>
                <span className="font-medium text-gray-700">{selectedLanguage.name}</span>
                <ChevronDown className={`w-4 h-4 text-gray-500 transition-transform duration-200 ${isLanguageDropdownOpen ? 'rotate-180' : ''}`} />
              </button>

              {isLanguageDropdownOpen && (
                <div className="absolute right-0 mt-2 w-72 bg-white rounded-xl shadow-2xl border border-gray-200 z-50 max-h-96 overflow-hidden">
                  <div className="p-3 border-b border-gray-100">
                    <input
                      type="text"
                      placeholder="Rechercher une langue..."
                      value={languageSearch}
                      onChange={(e) => setLanguageSearch(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div className="max-h-64 overflow-y-auto">
                    {filteredLanguages.map((language) => (
                      <button
                        key={language.code}
                        onClick={() => handleLanguageChange(language)}
                        className={`w-full flex items-center space-x-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left ${
                          selectedLanguage.code === language.code ? 'bg-blue-50 text-blue-600' : 'text-gray-700'
                        }`}
                      >
                        <span className="text-xl">{language.flag}</span>
                        <div>
                          <div className="font-medium">{language.name}</div>
                          {language.nativeName !== language.name && (
                            <div className="text-sm text-gray-500">{language.nativeName}</div>
                          )}
                        </div>
                        {selectedLanguage.code === language.code && (
                          <div className="ml-auto text-blue-600">✓</div>
                        )}
                      </button>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* Section Hero */}
      <main className="relative">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          
          {/* Badge de confiance */}
          <div className="text-center mb-8">
            <div className="inline-flex items-center space-x-2 bg-green-100 text-green-800 px-4 py-2 rounded-full text-sm font-medium">
              <Star className="w-4 h-4 text-green-600" />
              <span>Plus de 100k familles nous font déjà confiance !</span>
            </div>
          </div>

          {/* Titre principal */}
          <div className="text-center mb-12">
            <h1 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-blue-800 bg-clip-text text-transparent mb-6">
              Apprends les maths en
              <br />
              t'amusant !
            </h1>
            <p className="text-xl md:text-2xl text-gray-600 max-w-3xl mx-auto mb-8 leading-relaxed">
              Rejoins plus de 100 000 enfants qui progressent chaque jour avec des jeux 
              interactifs, des défis passionnants et un suivi personnalisé.
            </p>
          </div>

          {/* Boutons d'action */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
            <button className="group bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 hover:scale-105 shadow-lg hover:shadow-xl">
              <span className="mr-2">🎁</span>
              Commencer gratuitement
              <div className="text-sm opacity-90 group-hover:opacity-100">Essai gratuit 14 jours</div>
            </button>
            <button
              onClick={() => setIsPricingModalOpen(true)}
              className="group bg-white text-blue-600 px-8 py-4 rounded-xl font-semibold text-lg border-2 border-blue-600 hover:bg-blue-50 transition-all duration-300 hover:scale-105 shadow-lg hover:shadow-xl"
            >
              <span className="mr-2">💰</span>
              Voir les prix
              <div className="text-sm opacity-75 group-hover:opacity-100">À partir de 6,99€/mois</div>
            </button>
          </div>

          {/* Section des fonctionnalités */}
          <div className="grid md:grid-cols-3 gap-8 mb-16">
            {FEATURES.map((feature) => (
              <div
                key={feature.id}
                className="group relative bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 border border-gray-100"
              >
                <div className={`w-16 h-16 rounded-2xl bg-gradient-to-r ${feature.gradient} flex items-center justify-center mb-6 text-white group-hover:scale-110 transition-transform duration-300`}>
                  {feature.icon}
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">{feature.title}</h3>
                <p className="text-gray-600 mb-4">{feature.description}</p>
                {feature.stats && (
                  <div className="text-sm font-semibold text-blue-600 bg-blue-50 rounded-lg px-3 py-1 inline-block">
                    {feature.stats}
                  </div>
                )}
              </div>
            ))}
          </div>

          {/* Section statistiques */}
          <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-3xl p-8 md:p-12 text-white text-center">
            <h2 className="text-3xl md:text-4xl font-bold mb-8">
              Disponible sur toutes vos plateformes
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              {[
                { icon: '💻', title: 'Web', subtitle: 'Navigateur' },
                { icon: '📱', title: 'iOS', subtitle: 'iPhone/iPad' },
                { icon: '🤖', title: 'Android', subtitle: 'Tablette/Mobile' }
              ].map((platform, index) => (
                <div key={index} className="text-center">
                  <div className="text-6xl mb-4">{platform.icon}</div>
                  <h3 className="text-xl font-bold mb-2">{platform.title}</h3>
                  <p className="text-blue-100">{platform.subtitle}</p>
                </div>
              ))}
            </div>
            
            <div className="grid grid-cols-3 gap-8 mt-12 pt-8 border-t border-blue-500/30">
              {[
                { value: '100k+', label: 'Familles actives', desc: 'Utilisent Math4Child quotidiennement' },
                { value: '98%', label: 'Satisfaction parents', desc: 'Recommandent notre application' },
                { value: '47', label: 'Pays disponibles', desc: 'Et plus chaque mois' }
              ].map((stat, index) => (
                <div key={index} className="text-center">
                  <div className="text-3xl md:text-4xl font-bold mb-2">{stat.value}</div>
                  <div className="text-lg font-semibold mb-1">{stat.label}</div>
                  <div className="text-sm text-blue-100">{stat.desc}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </main>

      {/* Modal de pricing */}
      {isPricingModalOpen && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 overflow-y-auto">
          <div 
            ref={pricingModalRef}
            className="bg-white rounded-2xl max-w-5xl w-full max-h-[90vh] overflow-y-auto my-8"
          >
            {/* Header du modal */}
            <div className="sticky top-0 bg-white p-6 border-b border-gray-200 flex justify-between items-center rounded-t-2xl">
              <div>
                <h2 className="text-2xl md:text-3xl font-bold text-gray-900">Choisissez votre plan</h2>
                <p className="text-gray-600 mt-1">Commencez votre essai gratuit de 14 jours, annulable à tout moment</p>
              </div>
              <button
                onClick={() => setIsPricingModalOpen(false)}
                className="w-10 h-10 flex items-center justify-center rounded-full bg-gray-100 hover:bg-gray-200 transition-colors text-gray-500 hover:text-gray-700"
                aria-label="Fermer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="p-6">
              {/* Sélecteur de période */}
              <div className="flex justify-center mb-8">
                <div className="bg-gray-100 rounded-xl p-1 flex">
                  {[
                    { key: 'monthly' as const, label: 'Mensuel' },
                    { key: 'quarterly' as const, label: 'Trimestriel', badge: '10% de réduction' },
                    { key: 'annual' as const, label: 'Annuel', badge: '30% de réduction' }
                  ].map((period) => (
                    <button
                      key={period.key}
                      onClick={() => setSelectedPeriod(period.key)}
                      className={`px-6 py-3 rounded-lg font-medium transition-all relative ${
                        selectedPeriod === period.key
                          ? 'bg-white text-blue-600 shadow-md'
                          : 'text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      {period.label}
                      {period.badge && (
                        <div className="absolute -top-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full whitespace-nowrap">
                          {period.badge}
                        </div>
                      )}
                    </button>
                  ))}
                </div>
              </div>

              {/* Grille des plans */}
              <div className="grid md:grid-cols-3 gap-6">
                {PRICING_PLANS[selectedPeriod].map((plan) => (
                  <div
                    key={plan.id}
                    className={`relative bg-white rounded-2xl p-6 border-2 transition-all duration-300 hover:shadow-lg ${
                      plan.popular 
                        ? 'border-purple-500 shadow-lg' 
                        : 'border-gray-200 hover:border-gray-300'
                    }`}
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
                          <div className="w-5 h-5 bg-green-100 rounded-full flex items-center justify-center">
                            <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                          </div>
                          <span className="text-gray-700">{feature}</span>
                        </li>
                      ))}
                    </ul>

                    <button
                      onClick={() => handlePlanSelect(plan.id, selectedPeriod)}
                      className={`w-full py-3 px-4 rounded-xl font-semibold transition-all duration-300 hover:scale-105 ${
                        plan.popular
                          ? 'bg-gradient-to-r from-purple-500 to-purple-600 text-white hover:from-purple-600 hover:to-purple-700 shadow-lg'
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      }`}
                    >
                      {plan.popular ? 'Commencer l\'essai gratuit' : 'Choisir ce plan'}
                    </button>
                  </div>
                ))}
              </div>

              {/* Footer du modal */}
              <div className="text-center mt-8 pt-6 border-t border-gray-200">
                <p className="text-sm text-gray-600 mb-2">
                  ✅ Essai gratuit de 14 jours • ✅ Annulation à tout moment • ✅ Garantie satisfait ou remboursé
                </p>
                <p className="text-xs text-gray-500">
                  Les prix sont en euros, TVA incluse. Facturation récurrente, résiliable à tout moment.
                </p>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
