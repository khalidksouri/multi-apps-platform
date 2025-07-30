#!/bin/bash

# =====================================
# Script de corrections et améliorations
# Version hybride Math4Child
# =====================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

echo -e "${BLUE}"
echo "======================================================="
echo "🎨 CORRECTIONS ET AMÉLIORATIONS VERSION HYBRIDE"
echo "======================================================="
echo -e "${NC}"

cd apps/math4child

# Sauvegarde
print_step "Sauvegarde de la version actuelle..."
cp src/app/page.tsx src/app/page.tsx.before-polish

# Corrections et améliorations
print_step "Application des corrections et améliorations..."

cat > "src/app/page.tsx" << 'EOF'
'use client';

import { useState } from 'react';
import { UNIVERSAL_LANGUAGES, type Language } from '@/lib/i18n/languages';

// Types pour les niveaux et abonnements
interface Level {
  id: string;
  name: string;
  description: string;
  icon: string;
  minAge: number;
  maxAge: number;
}

interface SubscriptionPlan {
  id: string;
  name: string;
  profiles: number;
  monthlyPrice: number;
  quarterlyPrice: number;
  annualPrice: number;
  quarterlyDiscount: number;
  annualDiscount: number;
  features: string[];
  popular?: boolean;
  recommended?: boolean;
}

// Configuration des niveaux d'apprentissage
const LEARNING_LEVELS: Level[] = [
  {
    id: 'beginner',
    name: 'Débutant',
    description: 'Premiers pas avec les chiffres',
    icon: '🌱',
    minAge: 3,
    maxAge: 5
  },
  {
    id: 'elementary',
    name: 'Élémentaire',
    description: 'Addition, soustraction simple',
    icon: '📝',
    minAge: 5,
    maxAge: 7
  },
  {
    id: 'intermediate',
    name: 'Intermédiaire',
    description: 'Multiplication, division',
    icon: '🧮',
    minAge: 7,
    maxAge: 10
  },
  {
    id: 'advanced',
    name: 'Avancé',
    description: 'Fractions, géométrie',
    icon: '📊',
    minAge: 10,
    maxAge: 13
  },
  {
    id: 'expert',
    name: 'Expert',
    description: 'Algèbre, équations',
    icon: '🎓',
    minAge: 13,
    maxAge: 16
  }
];

// Plans d'abonnement avec prix corrigés
const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: 'gratuit',
    name: 'Gratuit',
    profiles: 1,
    monthlyPrice: 0,
    quarterlyPrice: 0,
    annualPrice: 0,
    quarterlyDiscount: 0,
    annualDiscount: 0,
    features: [
      '1 profil enfant',
      'Niveau débutant seulement',
      '10 exercices par jour',
      'Suivi de base',
      'Pas de statistiques avancées'
    ]
  },
  {
    id: 'famille',
    name: 'Famille',
    profiles: 3,
    monthlyPrice: 9.99,
    quarterlyPrice: 26.99,
    annualPrice: 89.99,
    quarterlyDiscount: 10,
    annualDiscount: 25,
    features: [
      '3 profils enfants',
      'Tous les niveaux débloqués',
      'Exercices illimités',
      'Suivi des progrès détaillé',
      'Statistiques et rapports',
      'Mode hors-ligne',
      'Support email'
    ],
    popular: true
  },
  {
    id: 'premium',
    name: 'Premium',
    profiles: 5,
    monthlyPrice: 14.99,
    quarterlyPrice: 40.49,
    annualPrice: 134.99,
    quarterlyDiscount: 10,
    annualDiscount: 25,
    features: [
      '5 profils enfants',
      'Tous les niveaux + contenus bonus',
      'Exercices illimités + défis',
      'Suivi avancé et prédictif',
      'Rapports personnalisés parents',
      'Mode hors-ligne complet',
      'Support prioritaire 24/7',
      'Accès aux nouveautés en avant-première'
    ],
    recommended: true
  },
  {
    id: 'ecole',
    name: 'École',
    profiles: 30,
    monthlyPrice: 49.99,
    quarterlyPrice: 134.99,
    annualPrice: 449.99,
    quarterlyDiscount: 10,
    annualDiscount: 25,
    features: [
      '30 profils élèves',
      'Tous les niveaux + outils pédagogiques',
      'Tableau de bord enseignant',
      'Création de devoirs personnalisés',
      'Évaluations automatiques',
      'Rapports de classe détaillés',
      'Formation enseignant incluse',
      'Support pédagogique dédié'
    ]
  }
];

export default function Math4ChildHybrid() {
  const [selectedLanguage, setSelectedLanguage] = useState<Language>(() => {
    const firstLang = UNIVERSAL_LANGUAGES[0];
    if (!firstLang) {
      throw new Error('UNIVERSAL_LANGUAGES ne peut pas être vide');
    }
    return firstLang;
  });
  
  const [selectedLevel, setSelectedLevel] = useState<Level | null>(null);
  const [selectedPlan, setSelectedPlan] = useState<SubscriptionPlan | null>(null);
  const [billingPeriod, setBillingPeriod] = useState<'monthly' | 'quarterly' | 'annual'>('monthly');
  const [isLanguageOpen, setIsLanguageOpen] = useState(false);

  // Fonction pour obtenir le prix selon la période
  const getPrice = (plan: SubscriptionPlan) => {
    switch (billingPeriod) {
      case 'quarterly':
        return plan.quarterlyPrice;
      case 'annual':
        return plan.annualPrice;
      default:
        return plan.monthlyPrice;
    }
  };

  // Fonction pour obtenir la période d'affichage
  const getPeriodLabel = () => {
    switch (billingPeriod) {
      case 'quarterly':
        return '/trimestre';
      case 'annual':
        return '/an';
      default:
        return '/mois';
    }
  };

  // Fonction pour obtenir l'économie
  const getSavings = (plan: SubscriptionPlan) => {
    switch (billingPeriod) {
      case 'quarterly':
        return plan.quarterlyDiscount;
      case 'annual':
        return plan.annualDiscount;
      default:
        return 0;
    }
  };

  const handlePlanSelect = (plan: SubscriptionPlan) => {
    setSelectedPlan(plan);
    console.log(`Plan sélectionné: ${plan.name} (${billingPeriod}) - ${getPrice(plan)}€`);
    
    // Simulation d'action selon le plan
    if (plan.id === 'gratuit') {
      console.log('Redirection vers inscription gratuite');
    } else {
      console.log('Redirection vers paiement Stripe');
    }
  };

  const handleLevelSelect = (level: Level) => {
    setSelectedLevel(level);
    console.log(`Niveau sélectionné: ${level.name} (${level.minAge}-${level.maxAge} ans)`);
  };

  const getTexts = (langCode: string) => {
    const texts = {
      'fr': {
        title: 'Math4Child',
        subtitle: 'Apprentissage des maths par niveaux',
        description: 'De débutant à expert, chaque enfant progresse à son rythme',
        chooseLevel: 'Choisissez votre niveau',
        choosePlan: 'Choisissez votre abonnement',
        profiles: 'profils',
        startFree: 'Commencer gratuitement',
        selectPlan: 'Choisir ce plan',
        popular: 'Populaire',
        recommended: 'Recommandé',
        save: 'Économisez',
        monthly: 'Mensuel',
        quarterly: 'Trimestriel',
        annual: 'Annuel',
        age: 'ans',
        yourSelection: 'Votre sélection',
        level: 'Niveau',
        plan: 'Plan',
        profilesIncluded: 'profils inclus',
        startAdventure: 'Commencer l\'aventure Math4Child',
        recommendedFor: 'Recommandé pour',
        free: 'Gratuit'
      },
      'en': {
        title: 'Math4Child',
        subtitle: 'Level-based math learning',
        description: 'From beginner to expert, every child progresses at their own pace',
        chooseLevel: 'Choose your level',
        choosePlan: 'Choose your subscription',
        profiles: 'profiles',
        startFree: 'Start for free',
        selectPlan: 'Choose this plan',
        popular: 'Popular',
        recommended: 'Recommended',
        save: 'Save',
        monthly: 'Monthly',
        quarterly: 'Quarterly',
        annual: 'Annual',
        age: 'years old',
        yourSelection: 'Your selection',
        level: 'Level',
        plan: 'Plan',
        profilesIncluded: 'profiles included',
        startAdventure: 'Start Math4Child adventure',
        recommendedFor: 'Recommended for',
        free: 'Free'
      }
    };
    
    return texts[langCode as keyof typeof texts] || texts.fr;
  };

  const currentTexts = getTexts(selectedLanguage.code);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="container mx-auto px-4 py-8 max-w-6xl">
        {/* Header */}
        <header className="flex justify-between items-center mb-12">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 bg-indigo-600 rounded-xl flex items-center justify-center">
              <span className="text-white text-xl font-bold">M4C</span>
            </div>
            <h1 className="text-3xl font-bold text-indigo-900">{currentTexts.title}</h1>
          </div>
          
          {/* Sélecteur de langue amélioré */}
          <div className="relative">
            <button
              onClick={() => setIsLanguageOpen(!isLanguageOpen)}
              className="flex items-center space-x-2 px-4 py-2 bg-white border border-gray-300 rounded-lg shadow-sm hover:bg-gray-50 transition-colors"
            >
              <span className="text-xl">{selectedLanguage.flag}</span>
              <span className="font-medium">{selectedLanguage.name}</span>
              <svg className={`w-4 h-4 text-gray-400 transition-transform ${isLanguageOpen ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
              </svg>
            </button>
            
            {isLanguageOpen && (
              <div className="absolute right-0 mt-2 w-64 bg-white border border-gray-200 rounded-lg shadow-lg max-h-64 overflow-y-auto z-50">
                {UNIVERSAL_LANGUAGES.slice(0, 8).map((language) => (
                  <button
                    key={language.code}
                    onClick={() => {
                      setSelectedLanguage(language);
                      setIsLanguageOpen(false);
                    }}
                    className={`w-full px-4 py-3 text-left hover:bg-gray-50 flex items-center space-x-3 transition-colors ${
                      selectedLanguage.code === language.code ? 'bg-indigo-50 text-indigo-600' : ''
                    }`}
                  >
                    <span className="text-xl">{language.flag}</span>
                    <div>
                      <div className="font-medium">{language.name}</div>
                      <div className="text-xs text-gray-500">{language.nativeName}</div>
                    </div>
                    {selectedLanguage.code === language.code && (
                      <div className="text-indigo-600 ml-auto">✓</div>
                    )}
                  </button>
                ))}
              </div>
            )}
          </div>
        </header>

        {/* Hero Section */}
        <section className="text-center mb-16">
          <h2 className="text-5xl font-bold text-gray-900 mb-6">
            {currentTexts.subtitle}
          </h2>
          <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            {currentTexts.description}
          </p>
        </section>

        {/* Sélection des niveaux */}
        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center text-gray-900 mb-12">
            {currentTexts.chooseLevel}
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6">
            {LEARNING_LEVELS.map((level) => (
              <div
                key={level.id}
                onClick={() => handleLevelSelect(level)}
                className={`p-6 bg-white rounded-xl shadow-sm border-2 cursor-pointer transition-all duration-200 hover:shadow-md hover:scale-105 ${
                  selectedLevel?.id === level.id 
                    ? 'border-indigo-500 bg-indigo-50 shadow-lg scale-105' 
                    : 'border-gray-200 hover:border-indigo-300'
                }`}
              >
                <div className="text-center">
                  <div className="text-4xl mb-3">{level.icon}</div>
                  <h4 className="text-lg font-bold text-gray-900 mb-2">{level.name}</h4>
                  <p className="text-sm text-gray-600 mb-3">{level.description}</p>
                  <div className="text-xs text-indigo-600 bg-indigo-100 px-2 py-1 rounded-full">
                    {level.minAge}-{level.maxAge} {currentTexts.age}
                  </div>
                </div>
              </div>
            ))}
          </div>
          
          {selectedLevel && (
            <div className="mt-8 p-6 bg-white rounded-lg shadow-sm border border-indigo-200 animate-fadeIn">
              <div className="flex items-center space-x-4">
                <div className="text-3xl">{selectedLevel.icon}</div>
                <div>
                  <h4 className="text-xl font-bold text-indigo-900">{selectedLevel.name}</h4>
                  <p className="text-gray-600">{selectedLevel.description}</p>
                  <p className="text-sm text-indigo-600">
                    {currentTexts.recommendedFor} {selectedLevel.minAge}-{selectedLevel.maxAge} {currentTexts.age}
                  </p>
                </div>
                <div className="ml-auto">
                  <div className="w-12 h-12 bg-indigo-100 rounded-full flex items-center justify-center">
                    <svg className="w-6 h-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                    </svg>
                  </div>
                </div>
              </div>
            </div>
          )}
        </section>

        {/* Plans d'abonnement */}
        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center text-gray-900 mb-8">
            {currentTexts.choosePlan}
          </h3>
          
          {/* Sélecteur de période amélioré */}
          <div className="flex justify-center mb-12">
            <div className="bg-white rounded-lg p-1 shadow-sm border border-gray-200">
              <button
                onClick={() => setBillingPeriod('monthly')}
                className={`px-6 py-3 rounded-md transition-colors text-sm font-medium ${
                  billingPeriod === 'monthly' 
                    ? 'bg-indigo-600 text-white shadow-sm' 
                    : 'text-gray-600 hover:text-gray-800'
                }`}
              >
                {currentTexts.monthly}
              </button>
              <button
                onClick={() => setBillingPeriod('quarterly')}
                className={`px-6 py-3 rounded-md transition-colors text-sm font-medium relative ${
                  billingPeriod === 'quarterly' 
                    ? 'bg-indigo-600 text-white shadow-sm' 
                    : 'text-gray-600 hover:text-gray-800'
                }`}
              >
                {currentTexts.quarterly}
                <span className="absolute -top-2 -right-2 text-xs bg-green-500 text-white px-2 py-1 rounded-full">
                  -10%
                </span>
              </button>
              <button
                onClick={() => setBillingPeriod('annual')}
                className={`px-6 py-3 rounded-md transition-colors text-sm font-medium relative ${
                  billingPeriod === 'annual' 
                    ? 'bg-indigo-600 text-white shadow-sm' 
                    : 'text-gray-600 hover:text-gray-800'
                }`}
              >
                {currentTexts.annual}
                <span className="absolute -top-2 -right-2 text-xs bg-green-500 text-white px-2 py-1 rounded-full">
                  -25%
                </span>
              </button>
            </div>
          </div>

          {/* Cartes des plans améliorées */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {SUBSCRIPTION_PLANS.map((plan) => (
              <div
                key={plan.id}
                className={`relative p-6 bg-white rounded-xl shadow-sm border-2 transition-all duration-200 hover:shadow-lg hover:scale-105 ${
                  plan.popular ? 'border-indigo-500 ring-2 ring-indigo-200' : 'border-gray-200'
                } ${
                  selectedPlan?.id === plan.id ? 'ring-2 ring-indigo-400 shadow-lg scale-105' : ''
                }`}
              >
                {/* Badges */}
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-indigo-600 text-white text-xs font-bold px-3 py-1 rounded-full">
                      {currentTexts.popular}
                    </span>
                  </div>
                )}
                {plan.recommended && (
                  <div className="absolute -top-3 right-4">
                    <span className="bg-green-600 text-white text-xs font-bold px-3 py-1 rounded-full">
                      {currentTexts.recommended}
                    </span>
                  </div>
                )}

                <div className="text-center mb-6">
                  <h4 className="text-xl font-bold text-gray-900 mb-2">{plan.name}</h4>
                  <div className="mb-2">
                    <span className="text-3xl font-bold text-indigo-600">
                      {getPrice(plan) === 0 ? currentTexts.free : `${getPrice(plan).toFixed(2)}€`}
                    </span>
                    {getPrice(plan) > 0 && (
                      <span className="text-gray-500 text-sm">{getPeriodLabel()}</span>
                    )}
                  </div>
                  
                  {getSavings(plan) > 0 && (
                    <div className="text-sm text-green-600 font-medium">
                      {currentTexts.save} {getSavings(plan)}%
                    </div>
                  )}
                  
                  <div className="text-sm text-gray-600 mb-4">
                    {plan.profiles} {currentTexts.profiles}
                  </div>
                </div>

                <ul className="space-y-2 mb-6 text-sm">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-start space-x-2">
                      <svg className="w-4 h-4 text-green-500 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd"/>
                      </svg>
                      <span className="text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>

                <button 
                  onClick={() => handlePlanSelect(plan)}
                  className={`w-full py-3 px-4 rounded-lg font-semibold transition-all duration-200 hover:scale-105 ${
                    plan.id === 'gratuit'
                      ? 'bg-gray-100 text-gray-800 hover:bg-gray-200'
                      : plan.popular || plan.recommended
                      ? 'bg-indigo-600 text-white hover:bg-indigo-700 shadow-sm'
                      : 'bg-indigo-100 text-indigo-700 hover:bg-indigo-200'
                  }`}
                >
                  {plan.id === 'gratuit' ? currentTexts.startFree : currentTexts.selectPlan}
                </button>
              </div>
            ))}
          </div>
        </section>

        {/* Résumé de sélection amélioré */}
        {(selectedLevel || selectedPlan) && (
          <section className="bg-white rounded-lg shadow-sm p-6 border border-indigo-200 animate-fadeIn">
            <h3 className="text-xl font-bold text-gray-900 mb-4">{currentTexts.yourSelection}</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {selectedLevel && (
                <div className="flex items-center space-x-4 p-4 bg-indigo-50 rounded-lg">
                  <div className="text-2xl">{selectedLevel.icon}</div>
                  <div>
                    <h4 className="font-semibold text-gray-900">{currentTexts.level}: {selectedLevel.name}</h4>
                    <p className="text-sm text-gray-600">{selectedLevel.description}</p>
                    <p className="text-xs text-indigo-600">
                      {selectedLevel.minAge}-{selectedLevel.maxAge} {currentTexts.age}
                    </p>
                  </div>
                </div>
              )}
              {selectedPlan && (
                <div className="flex items-center space-x-4 p-4 bg-green-50 rounded-lg">
                  <div className="text-2xl">💎</div>
                  <div>
                    <h4 className="font-semibold text-gray-900">
                      {currentTexts.plan}: {selectedPlan.name}
                      {getPrice(selectedPlan) > 0 && ` - ${getPrice(selectedPlan).toFixed(2)}€${getPeriodLabel()}`}
                    </h4>
                    <p className="text-sm text-gray-600">{selectedPlan.profiles} {currentTexts.profilesIncluded}</p>
                    {getSavings(selectedPlan) > 0 && (
                      <p className="text-xs text-green-600">
                        Économie de {getSavings(selectedPlan)}%
                      </p>
                    )}
                  </div>
                </div>
              )}
            </div>
            
            {selectedLevel && selectedPlan && (
              <div className="mt-6 pt-6 border-t border-gray-200">
                <button className="w-full bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 text-white font-bold py-4 px-8 rounded-lg text-lg transition-all duration-200 hover:scale-105 shadow-lg">
                  {currentTexts.startAdventure}
                </button>
              </div>
            )}
          </section>
        )}
      </div>
      
      {/* CSS pour les animations */}
      <style jsx>{`
        @keyframes fadeIn {
          from {
            opacity: 0;
            transform: translateY(20px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        
        .animate-fadeIn {
          animation: fadeIn 0.5s ease-out;
        }
      `}</style>
    </div>
  );
}
EOF

print_success "Corrections et améliorations appliquées"

# Test de compilation
print_step "Test de compilation..."
if npm run type-check --silent 2>/dev/null; then
    print_success "Compilation réussie"
else
    echo "Erreurs détectées:"
    npm run type-check 2>&1 | head -10
fi

echo ""
echo -e "${GREEN}✅ AMÉLIORATIONS APPLIQUÉES :${NC}"
echo "🎨 Animations et transitions fluides"
echo "🔄 Sélecteur de langue amélioré avec indicateur visuel"
echo "💰 Badges de réduction repositionnés et plus visibles"
echo "📝 Fonctionnalités des plans enrichies et détaillées"
echo "✨ Effets hover et scale sur les éléments interactifs"
echo "📊 Résumé de sélection avec codes couleur"
echo "🎯 Bouton d'action principal avec dégradé"
echo "🔔 Feedback console pour les actions utilisateur"
echo ""
echo -e "${BLUE}🚀 Rafraîchissez votre navigateur pour voir les améliorations !${NC}"

cd ../..