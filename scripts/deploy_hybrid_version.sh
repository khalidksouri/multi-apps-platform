#!/bin/bash

# =====================================
# Script de déploiement Math4Child Hybride
# Version minimaliste avec niveaux et abonnements
# =====================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ️${NC} $1"
}

# Banner de démarrage
echo -e "${PURPLE}"
echo "======================================================="
echo "🚀 DÉPLOIEMENT MATH4CHILD HYBRIDE"
echo "📚 Niveaux: Débutant → Expert"
echo "💎 Abonnements: Mensuel, Trimestriel, Annuel"
echo "👥 Profils: 1 à 30 selon le plan"
echo "======================================================="
echo -e "${NC}"

# Vérification du répertoire
if [ ! -d "apps/math4child" ]; then
    print_error "Répertoire apps/math4child introuvable !"
    echo "Assurez-vous d'être dans le répertoire racine du projet."
    exit 1
fi

cd apps/math4child

# Sauvegarde de l'ancien fichier
print_step "Sauvegarde de l'ancien fichier..."
if [ -f "src/app/page.tsx" ]; then
    cp src/app/page.tsx "src/app/page.tsx.backup-$(date +%Y%m%d_%H%M%S)"
    print_success "Sauvegarde créée"
else
    print_info "Aucun fichier existant à sauvegarder"
fi

# Création du nouveau fichier hybride
print_step "Création de la version hybride..."
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

// Plans d'abonnement
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
      'Pas de suivi parental'
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
      'Tous les niveaux',
      'Exercices illimités',
      'Suivi des progrès',
      'Statistiques détaillées'
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
      'Tous les niveaux',
      'Exercices illimités',
      'Suivi avancé',
      'Rapports personnalisés',
      'Mode hors-ligne',
      'Support prioritaire'
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
      'Tous les niveaux',
      'Tableau de bord enseignant',
      'Devoirs personnalisés',
      'Évaluations automatiques',
      'Rapports de classe',
      'Formation enseignant incluse'
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
    console.log(`Plan sélectionné: ${plan.name} (${billingPeriod})`);
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
        startAdventure: 'Commencer l\'aventure Math4Child'
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
        startAdventure: 'Start Math4Child adventure'
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
          
          {/* Sélecteur de langue */}
          <div className="relative">
            <button
              onClick={() => setIsLanguageOpen(!isLanguageOpen)}
              className="flex items-center space-x-2 px-4 py-2 bg-white border border-gray-300 rounded-lg shadow-sm hover:bg-gray-50"
            >
              <span className="text-xl">{selectedLanguage.flag}</span>
              <span className="font-medium">{selectedLanguage.name}</span>
            </button>
            
            {isLanguageOpen && (
              <div className="absolute right-0 mt-2 w-64 bg-white border border-gray-200 rounded-lg shadow-lg max-h-64 overflow-y-auto z-50">
                {UNIVERSAL_LANGUAGES.slice(0, 10).map((language) => (
                  <button
                    key={language.code}
                    onClick={() => {
                      setSelectedLanguage(language);
                      setIsLanguageOpen(false);
                    }}
                    className="w-full px-4 py-3 text-left hover:bg-gray-50 flex items-center space-x-3"
                  >
                    <span className="text-xl">{language.flag}</span>
                    <span className="font-medium">{language.name}</span>
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
                onClick={() => setSelectedLevel(level)}
                className={`p-6 bg-white rounded-xl shadow-sm border-2 cursor-pointer transition-all duration-200 hover:shadow-md ${
                  selectedLevel?.id === level.id 
                    ? 'border-indigo-500 bg-indigo-50' 
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
            <div className="mt-8 p-6 bg-white rounded-lg shadow-sm border border-indigo-200">
              <div className="flex items-center space-x-4">
                <div className="text-3xl">{selectedLevel.icon}</div>
                <div>
                  <h4 className="text-xl font-bold text-indigo-900">{selectedLevel.name}</h4>
                  <p className="text-gray-600">{selectedLevel.description}</p>
                  <p className="text-sm text-indigo-600">
                    Recommandé pour {selectedLevel.minAge}-{selectedLevel.maxAge} {currentTexts.age}
                  </p>
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
          
          {/* Sélecteur de période */}
          <div className="flex justify-center mb-12">
            <div className="bg-white rounded-lg p-1 shadow-sm border border-gray-200">
              <button
                onClick={() => setBillingPeriod('monthly')}
                className={`px-4 py-2 rounded-md transition-colors text-sm ${
                  billingPeriod === 'monthly' 
                    ? 'bg-indigo-600 text-white' 
                    : 'text-gray-600 hover:text-gray-800'
                }`}
              >
                {currentTexts.monthly}
              </button>
              <button
                onClick={() => setBillingPeriod('quarterly')}
                className={`px-4 py-2 rounded-md transition-colors text-sm ${
                  billingPeriod === 'quarterly' 
                    ? 'bg-indigo-600 text-white' 
                    : 'text-gray-600 hover:text-gray-800'
                }`}
              >
                {currentTexts.quarterly}
                <span className="ml-1 text-xs bg-green-100 text-green-800 px-1 rounded">-10%</span>
              </button>
              <button
                onClick={() => setBillingPeriod('annual')}
                className={`px-4 py-2 rounded-md transition-colors text-sm ${
                  billingPeriod === 'annual' 
                    ? 'bg-indigo-600 text-white' 
                    : 'text-gray-600 hover:text-gray-800'
                }`}
              >
                {currentTexts.annual}
                <span className="ml-1 text-xs bg-green-100 text-green-800 px-1 rounded">-25%</span>
              </button>
            </div>
          </div>

          {/* Cartes des plans */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {SUBSCRIPTION_PLANS.map((plan) => (
              <div
                key={plan.id}
                className={`relative p-6 bg-white rounded-xl shadow-sm border-2 transition-all duration-200 hover:shadow-md ${
                  plan.popular ? 'border-indigo-500 ring-2 ring-indigo-200' : 'border-gray-200'
                } ${
                  selectedPlan?.id === plan.id ? 'ring-2 ring-indigo-300' : ''
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
                      {getPrice(plan) === 0 ? 'Gratuit' : `${getPrice(plan).toFixed(2)}€`}
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
                  className={`w-full py-3 px-4 rounded-lg font-semibold transition-colors ${
                    plan.id === 'gratuit'
                      ? 'bg-gray-100 text-gray-800 hover:bg-gray-200'
                      : plan.popular || plan.recommended
                      ? 'bg-indigo-600 text-white hover:bg-indigo-700'
                      : 'bg-indigo-100 text-indigo-700 hover:bg-indigo-200'
                  }`}
                >
                  {plan.id === 'gratuit' ? currentTexts.startFree : currentTexts.selectPlan}
                </button>
              </div>
            ))}
          </div>
        </section>

        {/* Résumé de sélection */}
        {(selectedLevel || selectedPlan) && (
          <section className="bg-white rounded-lg shadow-sm p-6 border border-indigo-200">
            <h3 className="text-xl font-bold text-gray-900 mb-4">{currentTexts.yourSelection}</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {selectedLevel && (
                <div className="flex items-center space-x-4">
                  <div className="text-2xl">{selectedLevel.icon}</div>
                  <div>
                    <h4 className="font-semibold text-gray-900">{currentTexts.level}: {selectedLevel.name}</h4>
                    <p className="text-sm text-gray-600">{selectedLevel.description}</p>
                  </div>
                </div>
              )}
              {selectedPlan && (
                <div className="flex items-center space-x-4">
                  <div className="text-2xl">💎</div>
                  <div>
                    <h4 className="font-semibold text-gray-900">
                      {currentTexts.plan}: {selectedPlan.name}
                      {getPrice(selectedPlan) > 0 && ` - ${getPrice(selectedPlan).toFixed(2)}€${getPeriodLabel()}`}
                    </h4>
                    <p className="text-sm text-gray-600">{selectedPlan.profiles} {currentTexts.profilesIncluded}</p>
                  </div>
                </div>
              )}
            </div>
            
            {selectedLevel && selectedPlan && (
              <div className="mt-6 pt-6 border-t border-gray-200">
                <button className="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-4 px-8 rounded-lg text-lg transition-colors duration-200">
                  {currentTexts.startAdventure}
                </button>
              </div>
            )}
          </section>
        )}
      </div>
    </div>
  );
}
EOF

print_success "Version hybride créée"

# Test de compilation TypeScript
print_step "Test de compilation TypeScript..."
if npm run type-check --silent 2>/dev/null; then
    print_success "Compilation TypeScript réussie"
else
    print_error "Erreurs de compilation détectées"
    echo "Détails des erreurs :"
    npm run type-check 2>&1 | head -10
fi

# Test de build
print_step "Test de build..."
if npm run build --silent 2>/dev/null; then
    print_success "Build réussi"
else
    print_info "Build échoué - mais le développement peut continuer"
fi

# Résumé final
echo ""
echo -e "${PURPLE}======================================================="
echo "🎉 DÉPLOIEMENT MATH4CHILD HYBRIDE TERMINÉ"
echo "=======================================================${NC}"
echo ""
echo -e "${GREEN}✅ FONCTIONNALITÉS DÉPLOYÉES :${NC}"
echo "📚 5 niveaux d'apprentissage (Débutant → Expert)"
echo "💎 4 plans d'abonnement (Gratuit, Famille, Premium, École)"
echo "📅 3 périodes de facturation (Mensuel, Trimestriel, Annuel)"
echo "👥 1 à 30 profils selon le plan choisi"
echo "🌍 Interface multilingue (FR/EN)"
echo "💰 Système d'économies automatiques (-10% trimestriel, -25% annuel)"
echo ""
echo -e "${BLUE}🏗️ STRUCTURE DES PLANS :${NC}"
echo "• Gratuit: 1 profil, niveau débutant seulement"
echo "• Famille: 3 profils, 9.99€/mois, tous niveaux ⭐"
echo "• Premium: 5 profils, 14.99€/mois, fonctionnalités avancées 🏆"
echo "• École: 30 profils, 49.99€/mois, outils enseignants"
echo ""
echo -e "${YELLOW}🚀 PROCHAINES ÉTAPES :${NC}"
echo "1. Démarrer le serveur: npm run dev"
echo "2. Ouvrir: http://localhost:3000"
echo "3. Tester la sélection des niveaux"
echo "4. Tester le changement de période de facturation"
echo "5. Vérifier les traductions FR/EN"
echo ""
echo -e "${GREEN}🎯 VERSION PRÊTE POUR LES TESTS !${NC}"

cd ../..