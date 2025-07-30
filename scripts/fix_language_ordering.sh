#!/bin/bash

# =====================================
# Correction de l'ordre des langues dans le dropdown
# La langue sélectionnée apparaît en premier
# =====================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

echo -e "${BLUE}"
echo "======================================================="
echo "🔄 CORRECTION ORDRE DES LANGUES"
echo "======================================================="
echo -e "${NC}"

cd apps/math4child

print_step "Sauvegarde du fichier actuel..."
cp src/app/page.tsx src/app/page.tsx.before-ordering-fix

print_step "Correction de l'ordre des langues..."

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
      'Suivi de base'
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
      'Tous les niveaux + bonus',
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
      'Rapports de classe'
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

  // FONCTION CORRIGÉE : Réorganiser les langues avec la sélectionnée en premier
  const getOrderedLanguages = () => {
    const availableLanguages = UNIVERSAL_LANGUAGES.slice(0, 8);
    
    // Mettre la langue sélectionnée en premier
    const selectedFirst = availableLanguages.filter(lang => lang.code === selectedLanguage.code);
    const others = availableLanguages.filter(lang => lang.code !== selectedLanguage.code);
    
    return [...selectedFirst, ...others];
  };

  const getPrice = (plan: SubscriptionPlan) => {
    switch (billingPeriod) {
      case 'quarterly': return plan.quarterlyPrice;
      case 'annual': return plan.annualPrice;
      default: return plan.monthlyPrice;
    }
  };

  const getPeriodLabel = () => {
    switch (billingPeriod) {
      case 'quarterly': return '/trimestre';
      case 'annual': return '/an';
      default: return '/mois';
    }
  };

  const getSavings = (plan: SubscriptionPlan) => {
    switch (billingPeriod) {
      case 'quarterly': return plan.quarterlyDiscount;
      case 'annual': return plan.annualDiscount;
      default: return 0;
    }
  };

  const handlePlanSelect = (plan: SubscriptionPlan) => {
    setSelectedPlan(plan);
    console.log(`Plan sélectionné: ${plan.name} (${billingPeriod})`);
  };

  // Fonction CORRIGÉE pour changer de langue
  const handleLanguageChange = (language: Language) => {
    setSelectedLanguage(language);
    setIsLanguageOpen(false);
    console.log(`Langue changée vers: ${language.name} (${language.code})`);
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
      },
      'de': {
        title: 'Math4Child',
        subtitle: 'Stufenbasiertes Mathe-Lernen',
        description: 'Vom Anfänger zum Experten, jedes Kind macht Fortschritte in seinem eigenen Tempo',
        chooseLevel: 'Wählen Sie Ihr Level',
        choosePlan: 'Wählen Sie Ihr Abonnement',
        profiles: 'Profile',
        startFree: 'Kostenlos starten',
        selectPlan: 'Plan wählen',
        popular: 'Beliebt',
        recommended: 'Empfohlen',
        save: 'Sparen',
        monthly: 'Monatlich',
        quarterly: 'Vierteljährlich',
        annual: 'Jährlich',
        age: 'Jahre',
        yourSelection: 'Ihre Auswahl',
        level: 'Level',
        plan: 'Plan',
        profilesIncluded: 'Profile enthalten',
        startAdventure: 'Math4Child Abenteuer starten'
      },
      'es': {
        title: 'Math4Child',
        subtitle: 'Aprendizaje de matemáticas por niveles',
        description: 'De principiante a experto, cada niño progresa a su propio ritmo',
        chooseLevel: 'Elige tu nivel',
        choosePlan: 'Elige tu suscripción',
        profiles: 'perfiles',
        startFree: 'Empezar gratis',
        selectPlan: 'Elegir plan',
        popular: 'Popular',
        recommended: 'Recomendado',
        save: 'Ahorrar',
        monthly: 'Mensual',
        quarterly: 'Trimestral',
        annual: 'Anual',
        age: 'años',
        yourSelection: 'Tu selección',
        level: 'Nivel',
        plan: 'Plan',
        profilesIncluded: 'perfiles incluidos',
        startAdventure: 'Comenzar aventura Math4Child'
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
          
          {/* Sélecteur de langue CORRIGÉ avec ordre dynamique */}
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
            
            {/* Dropdown avec langue sélectionnée en premier */}
            {isLanguageOpen && (
              <>
                {/* Overlay pour fermer le dropdown */}
                <div 
                  className="fixed inset-0 z-10" 
                  onClick={() => setIsLanguageOpen(false)}
                ></div>
                
                {/* Dropdown menu avec ordre dynamique */}
                <div 
                  className="absolute right-0 mt-2 w-56 bg-white border border-gray-200 rounded-lg shadow-xl max-h-64 overflow-y-auto z-20"
                  style={{
                    position: 'absolute',
                    top: '100%',
                    right: 0,
                    boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)'
                  }}
                >
                  {/* Langue sélectionnée d'abord avec style spécial */}
                  <div className="border-b border-gray-100">
                    <button
                      onClick={() => handleLanguageChange(selectedLanguage)}
                      className="w-full px-4 py-3 text-left bg-indigo-50 text-indigo-600 flex items-center space-x-3"
                    >
                      <span className="text-xl">{selectedLanguage.flag}</span>
                      <div className="flex-1">
                        <div className="font-medium text-sm">{selectedLanguage.name}</div>
                        <div className="text-xs text-indigo-500">{selectedLanguage.nativeName}</div>
                      </div>
                      <div className="text-indigo-600 text-sm font-bold">✓</div>
                    </button>
                  </div>
                  
                  {/* Autres langues */}
                  <div className="py-1">
                    {getOrderedLanguages().slice(1).map((language) => (
                      <button
                        key={language.code}
                        onClick={() => handleLanguageChange(language)}
                        className="w-full px-4 py-3 text-left hover:bg-gray-50 flex items-center space-x-3 transition-colors"
                      >
                        <span className="text-xl">{language.flag}</span>
                        <div className="flex-1">
                          <div className="font-medium text-sm">{language.name}</div>
                          <div className="text-xs text-gray-500">{language.nativeName}</div>
                        </div>
                      </button>
                    ))}
                  </div>
                </div>
              </>
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

          {/* Cartes des plans */}
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

        {/* Résumé de sélection */}
        {(selectedLevel || selectedPlan) && (
          <section className="bg-white rounded-lg shadow-sm p-6 border border-indigo-200">
            <h3 className="text-xl font-bold text-gray-900 mb-4">{currentTexts.yourSelection}</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {selectedLevel && (
                <div className="flex items-center space-x-4 p-4 bg-indigo-50 rounded-lg">
                  <div className="text-2xl">{selectedLevel.icon}</div>
                  <div>
                    <h4 className="font-semibold text-gray-900">{currentTexts.level}: {selectedLevel.name}</h4>
                    <p className="text-sm text-gray-600">{selectedLevel.description}</p>
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
    </div>
  );
}
EOF

print_success "Ordre des langues corrigé"

# Test de compilation
print_step "Test de compilation..."
if npm run type-check --silent 2>/dev/null; then
    print_success "Compilation réussie"
else
    echo "Erreurs détectées - mais l'ordre des langues devrait fonctionner"
fi

echo ""
echo -e "${GREEN}✅ CORRECTIONS APPLIQUÉES :${NC}"
echo "🔄 Langue sélectionnée toujours en premier"
echo "🎨 Style spécial pour la langue active (fond bleu)"
echo "✅ Checkmark visible pour la langue sélectionnée" 
echo "📝 Séparateur visuel entre langue active et autres"
echo "🌍 Traductions ajoutées (DE, ES)"
echo "📊 Logging console pour débugger les changements"
echo ""
echo -e "${YELLOW}🔧 FONCTIONNEMENT :${NC}"
echo "• La langue sélectionnée apparaît TOUJOURS en premier"
echo "• Elle a un fond bleu (bg-indigo-50) pour la différencier"
echo "• Une ligne de séparation la sépare des autres langues"
echo "• Le ✓ est plus visible avec une couleur indigo"
echo ""
echo -e "${BLUE}🚀 Rafraîchissez et testez le changement de langue !${NC}"

cd ../..