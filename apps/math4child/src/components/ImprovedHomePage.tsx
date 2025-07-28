'use client';

import React, { useState } from 'react';
import { Button } from '@/components/ui/Button';
import { Modal } from '@/components/ui/Modal';
import { FeatureCard } from '@/components/ui/FeatureCard';

// Types simplifiés
interface SimplifiedLanguage {
  code: string;
  name: string;
  flag: string;
}

interface PricingPlan {
  id: string;
  name: string;
  price: string;
  features: string[];
}

// Langues supportées (version simplifiée pour éviter les erreurs)
const SIMPLIFIED_LANGUAGES: SimplifiedLanguage[] = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', flag: '🇵🇹' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦' },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' }
];

// Fonctionnalités principales
const MAIN_FEATURES = [
  {
    icon: '🎯',
    title: 'Exercices Adaptatifs',
    description: 'Exercices qui s\'adaptent au niveau de votre enfant pour un apprentissage optimal.'
  },
  {
    icon: '📊',
    title: 'Suivi des Progrès',
    description: 'Tableaux de bord détaillés pour suivre les progrès et identifier les points à améliorer.'
  },
  {
    icon: '🎮',
    title: 'Gamification',
    description: 'Système de points, badges et récompenses pour motiver l\'apprentissage.'
  },
  {
    icon: '🌍',
    title: 'Multilingue',
    description: 'Interface disponible en 47+ langues avec support RTL complet.'
  },
  {
    icon: '📱',
    title: 'Multi-plateforme',
    description: 'Disponible sur Web, iOS et Android avec synchronisation.'
  },
  {
    icon: '👨‍👩‍👧‍👦',
    title: 'Gestion Familiale',
    description: 'Plusieurs profils enfants avec contrôles parentaux avancés.'
  }
];

// Plans de tarification
const PRICING_PLANS_MONTHLY: PricingPlan[] = [
  { 
    id: 'free', 
    name: 'Gratuit', 
    price: '0€', 
    features: ['1 profil enfant', 'Exercices de base', '10 questions/jour'] 
  },
  { 
    id: 'premium', 
    name: 'Premium', 
    price: '4.99€', 
    features: ['3 profils', 'Tous les exercices', 'Statistiques avancées'] 
  },
  { 
    id: 'family', 
    name: 'Famille', 
    price: '6.99€', 
    features: ['5 profils', 'Contenu premium', 'Support prioritaire'] 
  }
];

const PRICING_PLANS_YEARLY: PricingPlan[] = [
  { 
    id: 'free', 
    name: 'Gratuit', 
    price: '0€', 
    features: ['1 profil enfant', 'Exercices de base', '10 questions/jour'] 
  },
  { 
    id: 'premium', 
    name: 'Premium', 
    price: '41.94€', 
    features: ['3 profils', 'Tous les exercices', 'Économie de 30%'] 
  },
  { 
    id: 'family', 
    name: 'Famille', 
    price: '58.32€', 
    features: ['5 profils', 'Contenu premium', 'Économie de 30%'] 
  }
];

const getPricingPlans = (period: string): PricingPlan[] => {
  return period === 'yearly' ? PRICING_PLANS_YEARLY : PRICING_PLANS_MONTHLY;
};

export default function ImprovedHomePage() {
  // États
  const [selectedLanguage, setSelectedLanguage] = useState<SimplifiedLanguage>(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('math4child-language');
      if (saved) {
        return SIMPLIFIED_LANGUAGES.find(lang => lang.code === saved) || SIMPLIFIED_LANGUAGES[0];
      }
    }
    return SIMPLIFIED_LANGUAGES[0];
  });

  const [selectedPeriod, setSelectedPeriod] = useState<'monthly' | 'yearly'>('monthly');

  const trackLanguageChange = (oldLang: string, newLang: string) => {
    // console.log('Language changed from', oldLang, 'to', newLang);
  };

  const trackPlanSelection = (planId: string, period: string) => {
    // console.log('Plan selected:', planId, 'for period:', period);
  };

  const handleLanguageChange = (language: SimplifiedLanguage) => {
    trackLanguageChange(selectedLanguage.code, language.code);
    setSelectedLanguage(language);
    if (typeof window !== 'undefined') {
      localStorage.setItem('math4child-language', language.code);
    }
  };

  const handlePlanSelect = (planId: string) => {
    trackPlanSelection(planId, selectedPeriod);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      {/* Header avec sélecteur de langue */}
      <header className="bg-white/90 backdrop-blur-sm shadow-sm sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center">
                <span className="text-white text-lg font-bold">M4C</span>
              </div>
              <span className="text-xl font-bold text-gray-900">Math4Child</span>
            </div>
            
            {/* Sélecteur de langue simplifié */}
            <div className="relative">
              <select 
                value={selectedLanguage.code}
                onChange={(e) => {
                  const lang = SIMPLIFIED_LANGUAGES.find(l => l.code === e.target.value);
                  if (lang) handleLanguageChange(lang);
                }}
                className="appearance-none bg-white border border-gray-300 rounded-lg px-4 py-2 pr-8 text-sm font-medium focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                {SIMPLIFIED_LANGUAGES.map((lang) => (
                  <option key={lang.code} value={lang.code}>
                    {lang.flag} {lang.name}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="inline-flex items-center px-4 py-2 rounded-full bg-blue-100 text-blue-800 text-sm font-medium mb-8">
            ⭐ App éducative #1 en France
          </div>
          
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
            <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              Math4Child
            </span>
          </h1>
          
          <p className="text-xl md:text-2xl text-gray-600 mb-8 max-w-3xl mx-auto">
            L&apos;application éducative n°1 pour apprendre les mathématiques en famille
          </p>
          
          <p className="text-lg text-gray-500 mb-12 max-w-2xl mx-auto">
            Une application complète pour apprendre les mathématiques de façon ludique et interactive.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <Button size="lg" className="shadow-lg hover:shadow-xl transform hover:scale-105">
              Commencer gratuitement
            </Button>
            
            <Button variant="outline" size="lg" className="shadow-lg hover:shadow-xl">
              Voir les abonnements
            </Button>
          </div>
          
          <div className="mt-16 text-center">
            <p className="text-green-600 font-medium mb-4">100k+ familles nous font confiance</p>
            <div className="flex justify-center items-center space-x-2">
              <div className="flex">
                {[...Array(5)].map((_, i) => (
                  <span key={i} className="text-yellow-400 text-xl">⭐</span>
                ))}
              </div>
              <span className="text-gray-600 text-sm ml-2">4.9/5 sur l&apos;App Store</span>
            </div>
          </div>
        </div>
      </section>

      {/* Section des fonctionnalités */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">Fonctionnalités principales</h2>
            <p className="text-xl text-gray-600">Découvrez tout ce qui fait de Math4Child l&apos;app n°1</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {MAIN_FEATURES.map((feature, index) => (
              <FeatureCard
                key={index}
                icon={feature.icon}
                title={feature.title}
                description={feature.description}
              />
            ))}
          </div>
        </div>
      </section>

      {/* Section pricing */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">Choisissez votre plan</h2>
            <p className="text-xl text-gray-600">Débloquez toutes les fonctionnalités</p>
            
            {/* Toggle période */}
            <div className="flex justify-center mt-8">
              <div className="bg-white rounded-lg p-1 shadow-sm">
                <button
                  onClick={() => setSelectedPeriod('monthly')}
                  className={`px-6 py-2 rounded-md text-sm font-medium transition-colors ${
                    selectedPeriod === 'monthly'
                      ? 'bg-blue-600 text-white'
                      : 'text-gray-600 hover:text-gray-900'
                  }`}
                >
                  Mensuel
                </button>
                <button
                  onClick={() => setSelectedPeriod('yearly')}
                  className={`px-6 py-2 rounded-md text-sm font-medium transition-colors ${
                    selectedPeriod === 'yearly'
                      ? 'bg-blue-600 text-white'
                      : 'text-gray-600 hover:text-gray-900'
                  }`}
                >
                  Annuel <span className="text-green-600 text-xs ml-1">-30%</span>
                </button>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {getPricingPlans(selectedPeriod).map((plan) => (
              <div
                key={plan.id}
                className={`bg-white rounded-xl shadow-lg p-8 ${
                  plan.id === 'premium' ? 'ring-2 ring-blue-500 relative' : ''
                }`}
              >
                {plan.id === 'premium' && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-medium">
                      Populaire
                    </span>
                  </div>
                )}
                
                <div className="text-center mb-8">
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                  <div className="mb-4">
                    <span className="text-4xl font-bold text-gray-900">{plan.price}</span>
                    {plan.id !== 'free' && (
                      <span className="text-gray-500">/{selectedPeriod === 'yearly' ? 'an' : 'mois'}</span>
                    )}
                  </div>
                </div>
                
                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-start">
                      <span className="text-green-500 mr-3 mt-0.5">✓</span>
                      <span className="text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>
                
                <Button
                  onClick={() => handlePlanSelect(plan.id)}
                  variant={plan.id === 'premium' ? 'primary' : 'outline'}
                  className="w-full"
                >
                  {plan.id === 'free' ? 'Commencer gratuitement' : 'Choisir ce plan'}
                </Button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="flex items-center justify-center space-x-3 mb-8">
            <div className="w-10 h-10 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center">
              <span className="text-white text-lg font-bold">M4C</span>
            </div>
            <span className="text-2xl font-bold">Math4Child</span>
          </div>
          
          <p className="text-gray-400 mb-8 max-w-2xl mx-auto">
            L&apos;application éducative de référence pour apprendre les mathématiques en famille.
          </p>
          
          <div className="border-t border-gray-800 pt-8">
            <p className="text-gray-400 text-sm">
              &copy; 2024 Math4Child. Tous droits réservés.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
