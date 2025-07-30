#!/bin/bash

# =====================================
# CHANGEMENT VERS NIVEAUX 1-5
# CP->Niveau 1, CE1->Niveau 2, etc.
# =====================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}▶️${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

echo -e "${PURPLE}"
echo "============================================"
echo "🔄 CHANGEMENT VERS NIVEAUX 1-5"
echo "============================================"
echo -e "${NC}"

cd apps/math4child

print_step "Sauvegarde du fichier actuel..."
cp src/app/page.tsx src/app/page.tsx.backup-before-levels-$(date +%Y%m%d-%H%M%S)

print_step "Modification des niveaux CP-CM2 vers Niveaux 1-5..."

cat > "src/app/page.tsx" << 'EOF'
'use client';

import { useState } from 'react';
import { UNIVERSAL_LANGUAGES } from '@/lib/i18n/languages';

// Types simplifiés pour éviter TOUS les conflits
interface SimpleLanguage {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

interface PrimaryLevel {
  id: string;
  name: string;
  className: string;
  description: string;
  icon: string;
  age: string;
  operations: string[];
  examples: string[];
  requiredCorrectAnswers: number;
  isLocked: boolean;
  isCompleted: boolean;
  progress: number;
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

// Configuration des niveaux 1-5 (anciennement CP-CM2)
const PRIMARY_LEVELS: PrimaryLevel[] = [
  {
    id: 'niveau1',
    name: 'Niveau 1',
    className: 'Addition et soustraction de base',
    description: 'Addition et soustraction jusqu\'à 20',
    icon: '🌟',
    age: '6-7 ans',
    operations: ['Addition simple', 'Soustraction simple'],
    examples: ['5 + 3 = ?', '8 - 2 = ?', '10 + 7 = ?'],
    requiredCorrectAnswers: 100,
    isLocked: false,
    isCompleted: false,
    progress: 0
  },
  {
    id: 'niveau2',
    name: 'Niveau 2',
    className: 'Calculs jusqu\'à 100',
    description: 'Addition et soustraction jusqu\'à 100',
    icon: '📝',
    age: '7-8 ans',
    operations: ['Addition à 2 chiffres', 'Soustraction à 2 chiffres', 'Calcul mental'],
    examples: ['23 + 15 = ?', '47 - 12 = ?', '30 + 25 = ?'],
    requiredCorrectAnswers: 100,
    isLocked: true,
    isCompleted: false,
    progress: 0
  },
  {
    id: 'niveau3',
    name: 'Niveau 3',
    className: 'Introduction multiplication et division',
    description: 'Tables de multiplication et division simple',
    icon: '✖️',
    age: '8-9 ans',
    operations: ['Tables de multiplication', 'Division simple', 'Addition/soustraction avancées'],
    examples: ['7 × 4 = ?', '24 ÷ 3 = ?', '156 + 87 = ?'],
    requiredCorrectAnswers: 100,
    isLocked: true,
    isCompleted: false,
    progress: 0
  },
  {
    id: 'niveau4',
    name: 'Niveau 4',
    className: 'Maîtrise des 4 opérations',
    description: 'Multiplication et division avancées',
    icon: '🧮',
    age: '9-10 ans',
    operations: ['Multiplication à 2 chiffres', 'Division euclidienne', 'Problèmes complexes'],
    examples: ['24 × 16 = ?', '156 ÷ 12 = ?', '(25 + 15) × 3 = ?'],
    requiredCorrectAnswers: 100,
    isLocked: true,
    isCompleted: false,
    progress: 0
  },
  {
    id: 'niveau5',
    name: 'Niveau 5',
    className: 'Mathématiques avancées',
    description: 'Fractions, décimaux et géométrie',
    icon: '🎓',
    age: '10-11 ans',
    operations: ['Fractions simples', 'Décimaux', 'Géométrie de base', 'Problèmes multi-étapes'],
    examples: ['1/2 + 1/4 = ?', '12.5 × 4 = ?', 'Aire d\'un rectangle 8×6'],
    requiredCorrectAnswers: 100,
    isLocked: true,
    isCompleted: false,
    progress: 0
  }
];

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
      'Accès Niveau 1 seulement',
      '10 exercices par jour',
      'Suivi de base des progrès'
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
      'Tous les niveaux 1 → 5',
      'Exercices illimités',
      'Suivi détaillé des 100 bonnes réponses',
      'Statistiques par opération',
      'Rapports de progression'
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
      'Tous les niveaux + exercices bonus',
      'Mode révision niveaux validés',
      'Défis chronométrés',
      'Analyse détaillée des erreurs',
      'Recommandations personnalisées',
      'Mode hors-ligne complet'
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
      'Gestion par niveaux (1 à 5)',
      'Tableau de bord enseignant',
      'Suivi collectif des validations',
      'Attribution d\'exercices ciblés',
      'Rapports de classe détaillés',
      'Support pédagogique dédié'
    ]
  }
];

// Langue par défaut sécurisée
const DEFAULT_LANGUAGE: SimpleLanguage = {
  code: 'fr',
  name: 'Français',
  nativeName: 'Français',
  flag: '🇫🇷'
};

// Fonction pour convertir les langues complexes en simples
const convertToSimpleLanguage = (lang: any): SimpleLanguage => {
  if (!lang) return DEFAULT_LANGUAGE;
  return {
    code: lang.code || 'fr',
    name: lang.name || 'Français',
    nativeName: lang.nativeName || 'Français',
    flag: lang.flag || '🇫🇷'
  };
};

export default function Math4ChildPrimary() {
  // État de la langue sélectionnée - 100% SÉCURISÉ
  const [selectedLanguage, setSelectedLanguage] = useState<SimpleLanguage>(() => {
    try {
      if (UNIVERSAL_LANGUAGES && UNIVERSAL_LANGUAGES.length > 0) {
        return convertToSimpleLanguage(UNIVERSAL_LANGUAGES[0]);
      }
    } catch (error) {
      console.warn('Erreur lors du chargement des langues:', error);
    }
    return DEFAULT_LANGUAGE;
  });
  
  // État des niveaux avec progression simulée - 100% SÉCURISÉ
  const [levels, setLevels] = useState<PrimaryLevel[]>(() => {
    const initialLevels = [...PRIMARY_LEVELS];
    
    try {
      // Vérifications sécurisées avant modification
      if (initialLevels.length >= 3) {
        // Niveau 1 validé (index 0)
        if (initialLevels[0]) {
          initialLevels[0].isCompleted = true;
          initialLevels[0].progress = 100;
        }
        
        // Niveau 2 débloqué et validé (index 1)
        if (initialLevels[1]) {
          initialLevels[1].isLocked = false;
          initialLevels[1].isCompleted = true;
          initialLevels[1].progress = 100;
        }
        
        // Niveau 3 débloqué (niveau en cours) (index 2)
        if (initialLevels[2]) {
          initialLevels[2].isLocked = false;
          initialLevels[2].progress = 67;
        }
      }
    } catch (error) {
      console.warn('Erreur lors de l\'initialisation des niveaux:', error);
    }
    
    return initialLevels;
  });
  
  const [selectedLevel, setSelectedLevel] = useState<PrimaryLevel | null>(null);
  const [selectedPlan, setSelectedPlan] = useState<SubscriptionPlan | null>(null);
  const [billingPeriod, setBillingPeriod] = useState<'monthly' | 'quarterly' | 'annual'>('monthly');
  const [isLanguageOpen, setIsLanguageOpen] = useState(false);

  // Fonction pour organiser les langues - 100% SÉCURISÉE
  const getOrderedLanguages = (): SimpleLanguage[] => {
    try {
      if (!UNIVERSAL_LANGUAGES || UNIVERSAL_LANGUAGES.length === 0) {
        return [DEFAULT_LANGUAGE];
      }
      
      const availableLanguages = UNIVERSAL_LANGUAGES.slice(0, 8);
      const convertedLanguages = availableLanguages.map(convertToSimpleLanguage);
      
      const selectedFirst = convertedLanguages.filter(lang => lang.code === selectedLanguage.code);
      const others = convertedLanguages.filter(lang => lang.code !== selectedLanguage.code);
      
      return [...selectedFirst, ...others];
    } catch (error) {
      console.warn('Erreur lors de l\'organisation des langues:', error);
      return [DEFAULT_LANGUAGE];
    }
  };

  const getPrice = (plan: SubscriptionPlan): number => {
    switch (billingPeriod) {
      case 'quarterly': return plan.quarterlyPrice;
      case 'annual': return plan.annualPrice;
      default: return plan.monthlyPrice;
    }
  };

  const getPeriodLabel = (): string => {
    switch (billingPeriod) {
      case 'quarterly': return '/trimestre';
      case 'annual': return '/an';
      default: return '/mois';
    }
  };

  const getSavings = (plan: SubscriptionPlan): number => {
    switch (billingPeriod) {
      case 'quarterly': return plan.quarterlyDiscount;
      case 'annual': return plan.annualDiscount;
      default: return 0;
    }
  };

  const handlePlanSelect = (plan: SubscriptionPlan): void => {
    setSelectedPlan(plan);
    console.log(`Plan sélectionné: ${plan.name} (${billingPeriod})`);
  };

  const handleLevelSelect = (level: PrimaryLevel): void => {
    if (level.isLocked) {
      console.log(`${level.name} verrouillé - doit valider le niveau précédent`);
      return;
    }
    setSelectedLevel(level);
    console.log(`${level.name} sélectionné - Progression: ${level.progress}/100`);
  };

  const handleLanguageChange = (language: SimpleLanguage): void => {
    setSelectedLanguage(language);
    setIsLanguageOpen(false);
    console.log(`Langue changée vers: ${language.name} (${language.code})`);
  };

  // Fonction de mise à jour de progression - 100% SÉCURISÉE
  const updateLevelProgress = (levelId: string, newProgress: number): void => {
    setLevels(prevLevels => 
      prevLevels.map((level, index) => {
        if (level.id === levelId) {
          const updatedLevel = { ...level, progress: newProgress };
          
          // Validation automatique si 100 bonnes réponses
          if (newProgress >= 100) {
            updatedLevel.isCompleted = true;
            updatedLevel.progress = 100;
            
            // Débloquer le niveau suivant - SÉCURISÉ
            if (index + 1 < prevLevels.length && prevLevels[index + 1]) {
              prevLevels[index + 1].isLocked = false;
            }
          }
          
          return updatedLevel;
        }
        return level;
      })
    );
  };

  const getTexts = (langCode: string) => {
    const texts = {
      'fr': {
        title: 'Math4Child',
        subtitle: 'Progression Niveaux 1 → 5',
        description: '100 bonnes réponses pour valider chaque niveau et débloquer le suivant',
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
        yourSelection: 'Votre sélection',
        level: 'Niveau',
        plan: 'Plan',
        profilesIncluded: 'profils inclus',
        startAdventure: 'Commencer l\'apprentissage',
        completed: 'Validé',
        locked: 'Verrouillé',  
        inProgress: 'En cours',
        correctAnswers: 'bonnes réponses',
        unlocked: 'Débloqué',
        practiceMode: 'Mode révision disponible',
        simulateProgress: 'Simuler +10 bonnes réponses',
        generalProgress: 'Progression générale',
        levelsValidated: 'niveaux validés',
        operations: 'Opérations',
        exerciseExamples: 'Exemples d\'exercices',
        progression: 'Progression'
      },
      'en': {
        title: 'Math4Child',
        subtitle: 'Progress Levels 1 → 5',
        description: '100 correct answers to validate each level and unlock the next',
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
        yourSelection: 'Your selection',
        level: 'Level',
        plan: 'Plan',
        profilesIncluded: 'profiles included',
        startAdventure: 'Start learning',
        completed: 'Completed',
        locked: 'Locked',
        inProgress: 'In Progress',
        correctAnswers: 'correct answers',
        unlocked: 'Unlocked',
        practiceMode: 'Practice mode available',
        simulateProgress: 'Simulate +10 correct answers',
        generalProgress: 'General Progress',
        levelsValidated: 'levels validated',
        operations: 'Operations',
        exerciseExamples: 'Exercise Examples',
        progression: 'Progress'
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
              className="flex items-center space-x-2 px-4 py-2 bg-white border border-gray-300 rounded-lg shadow-sm hover:bg-gray-50 transition-colors"
            >
              <span className="text-xl">{selectedLanguage.flag}</span>
              <span className="font-medium">{selectedLanguage.name}</span>
              <svg className={`w-4 h-4 text-gray-400 transition-transform ${isLanguageOpen ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
              </svg>
            </button>
            
            {isLanguageOpen && (
              <>
                <div 
                  className="fixed inset-0 z-10" 
                  onClick={() => setIsLanguageOpen(false)}
                ></div>
                
                <div className="absolute right-0 mt-2 w-56 bg-white border border-gray-200 rounded-lg shadow-xl max-h-64 overflow-y-auto z-20">
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

        {/* Progression des niveaux 1 → 5 */}
        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center text-gray-900 mb-12">
            {currentTexts.chooseLevel}
          </h3>
          
          {/* Barre de progression globale */}
          <div className="mb-8 bg-white rounded-lg p-6 shadow-sm">
            <div className="flex items-center justify-between mb-4">
              <h4 className="text-lg font-semibold text-gray-900">{currentTexts.generalProgress}</h4>
              <span className="text-sm text-gray-600">
                {levels.filter(l => l.isCompleted).length} / {levels.length} {currentTexts.levelsValidated}
              </span>
            </div>
            <div className="flex space-x-2">
              {levels.map((level) => (
                <div key={level.id} className="flex-1">
                  <div className={`h-3 rounded-full ${
                    level.isCompleted 
                      ? 'bg-green-500' 
                      : level.progress > 0 
                      ? 'bg-yellow-400' 
                      : 'bg-gray-200'
                  }`}>
                    {level.progress > 0 && !level.isCompleted && (
                      <div 
                        className="h-full bg-yellow-400 rounded-full transition-all duration-500"
                        style={{ width: `${level.progress}%` }}
                      ></div>
                    )}
                  </div>
                  <div className="text-xs text-center mt-1 font-medium">{level.name}</div>
                </div>
              ))}
            </div>
          </div>

          {/* Cartes des niveaux */}
          <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6">
            {levels.map((level) => (
              <div
                key={level.id}
                onClick={() => handleLevelSelect(level)}
                className={`p-6 bg-white rounded-xl shadow-sm border-2 transition-all duration-200 relative ${
                  level.isLocked
                    ? 'border-gray-300 bg-gray-50 cursor-not-allowed opacity-60'
                    : level.isCompleted
                    ? 'border-green-500 bg-green-50 cursor-pointer hover:shadow-lg'
                    : level.progress > 0
                    ? 'border-yellow-400 bg-yellow-50 cursor-pointer hover:shadow-lg hover:scale-105'
                    : 'border-blue-300 bg-blue-50 cursor-pointer hover:shadow-lg hover:scale-105'
                } ${
                  selectedLevel?.id === level.id ? 'ring-2 ring-indigo-400 scale-105' : ''
                }`}
              >
                {/* Badge de statut */}
                <div className="absolute -top-3 -right-2">
                  {level.isLocked && (
                    <div className="bg-gray-500 text-white text-xs px-2 py-1 rounded-full">
                      🔒 {currentTexts.locked}
                    </div>
                  )}
                  {level.isCompleted && (
                    <div className="bg-green-500 text-white text-xs px-2 py-1 rounded-full">
                      ✅ {currentTexts.completed}
                    </div>
                  )}
                  {!level.isLocked && !level.isCompleted && level.progress > 0 && (
                    <div className="bg-yellow-500 text-white text-xs px-2 py-1 rounded-full">
                      ⏳ {currentTexts.inProgress}
                    </div>
                  )}
                </div>

                <div className="text-center">
                  <div className="text-4xl mb-3">{level.icon}</div>
                  <h4 className="text-xl font-bold text-gray-900 mb-1">{level.name}</h4>
                  <p className="text-sm text-gray-600 mb-2">{level.className}</p>
                  <p className="text-xs text-gray-500 mb-3">{level.age}</p>
                  <p className="text-sm text-gray-700 mb-4">{level.description}</p>
                  
                  {/* Barre de progression individuelle */}
                  <div className="mb-3">
                    <div className="flex justify-between text-xs text-gray-600 mb-1">
                      <span>{currentTexts.progression}</span>
                      <span>{level.progress}/100</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className={`h-2 rounded-full transition-all duration-500 ${
                          level.isCompleted ? 'bg-green-500' : 'bg-yellow-400'
                        }`}
                        style={{ width: `${level.progress}%` }}
                      ></div>
                    </div>
                  </div>

                  {/* Opérations */}
                  <div className="text-xs text-gray-600">
                    <div className="font-medium mb-1">{currentTexts.operations} :</div>
                    <ul className="space-y-1">
                      {level.operations.map((op, idx) => (
                        <li key={idx} className="flex items-center">
                          <span className="text-green-500 mr-1">•</span>
                          {op}
                        </li>
                      ))}
                    </ul>
                  </div>
                </div>
              </div>
            ))}
          </div>
          
          {/* Détails du niveau sélectionné */}
          {selectedLevel && (
            <div className="mt-8 p-6 bg-white rounded-lg shadow-sm border border-indigo-200">
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <div className="flex items-center space-x-4">
                  <div className="text-4xl">{selectedLevel.icon}</div>
                  <div>
                    <h4 className="text-2xl font-bold text-indigo-900">{selectedLevel.name} - {selectedLevel.className}</h4>
                    <p className="text-gray-600">{selectedLevel.description}</p>
                    <p className="text-sm text-indigo-600">{selectedLevel.age}</p>
                    
                    {selectedLevel.isCompleted && (
                      <div className="mt-2 text-sm text-green-600 font-medium">
                        ✅ Niveau validé ! {currentTexts.practiceMode}
                      </div>
                    )}
                    
                    {!selectedLevel.isCompleted && selectedLevel.progress > 0 && (
                      <div className="mt-2 text-sm text-yellow-600 font-medium">
                        🎯 {selectedLevel.progress}/100 {currentTexts.correctAnswers}
                      </div>
                    )}
                  </div>
                </div>
                
                <div>
                  <h5 className="font-semibold text-gray-900 mb-3">{currentTexts.exerciseExamples} :</h5>
                  <div className="space-y-2">
                    {selectedLevel.examples.map((example, idx) => (
                      <div key={idx} className="bg-gray-50 px-3 py-2 rounded text-sm font-mono">
                        {example}
                      </div>
                    ))}
                  </div>
                  
                  {/* Bouton de simulation */}
                  {!selectedLevel.isCompleted && selectedLevel.progress < 100 && (
                    <div className="mt-4">
                      <button
                        onClick={() => updateLevelProgress(selectedLevel.id, Math.min(selectedLevel.progress + 10, 100))}
                        className="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm hover:bg-indigo-700 transition-colors"
                      >
                        {currentTexts.simulateProgress}
                      </button>
                    </div>
                  )}
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
                    <p className="text-sm text-gray-600">{selectedLevel.className}</p>
                    <p className="text-xs text-indigo-600">{selectedLevel.progress}/100 {currentTexts.correctAnswers}</p>
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

print_success "Changement vers Niveaux 1-5 appliqué"

print_step "Mise à jour du générateur d'exercices pour les nouveaux niveaux..."
if [ -f "scripts/generate-exercises.js" ]; then
    cat > "scripts/generate-exercises.js" << 'EOF'
#!/usr/bin/env node

// Générateur d'exercices mathématiques pour Math4Child - Niveaux 1-5

const levels = {
  niveau1: { range: [1, 20], operations: ['addition', 'subtraction'] },
  niveau2: { range: [1, 100], operations: ['addition', 'subtraction'] },
  niveau3: { range: [1, 100], operations: ['addition', 'subtraction', 'multiplication', 'division'] },
  niveau4: { range: [1, 1000], operations: ['addition', 'subtraction', 'multiplication', 'division'] },
  niveau5: { range: [1, 1000], operations: ['all'] }
};

function generateExercise(level, operation) {
  const config = levels[level];
  const [min, max] = config.range;
  
  const a = Math.floor(Math.random() * (max - min + 1)) + min;
  const b = Math.floor(Math.random() * (max - min + 1)) + min;
  
  switch(operation) {
    case 'addition':
      return { question: `${a} + ${b} = ?`, answer: a + b };
    case 'subtraction':
      return { question: `${Math.max(a,b)} - ${Math.min(a,b)} = ?`, answer: Math.max(a,b) - Math.min(a,b) };
    case 'multiplication':
      const smallA = Math.floor(Math.random() * 10) + 1;
      const smallB = Math.floor(Math.random() * 10) + 1;
      return { question: `${smallA} × ${smallB} = ?`, answer: smallA * smallB };
    case 'division':
      const divisor = Math.floor(Math.random() * 9) + 1;
      const quotient = Math.floor(Math.random() * 10) + 1;
      const dividend = divisor * quotient;
      return { question: `${dividend} ÷ ${divisor} = ?`, answer: quotient };
    default:
      return generateExercise(level, 'addition');
  }
}

// Générer un set d'exercices
function generateExerciseSet(level, count = 10) {
  const config = levels[level];
  if (!config) {
    console.error(`Niveau ${level} non reconnu. Niveaux disponibles: niveau1, niveau2, niveau3, niveau4, niveau5`);
    return [];
  }
  
  const exercises = [];
  
  for (let i = 0; i < count; i++) {
    const operation = config.operations[Math.floor(Math.random() * config.operations.length)];
    exercises.push({
      id: `${level}_${i + 1}`,
      ...generateExercise(level, operation),
      level,
      operation
    });
  }
  
  return exercises;
}

// Usage en ligne de commande
if (require.main === module) {
  const level = process.argv[2] || 'niveau1';
  const count = parseInt(process.argv[3]) || 10;
  
  console.log(`🎯 Génération de ${count} exercices pour le ${level.toUpperCase()}`);
  const exercises = generateExerciseSet(level, count);
  if (exercises.length > 0) {
    console.log(JSON.stringify(exercises, null, 2));
  }
}

module.exports = { generateExercise, generateExerciseSet };
EOF
    print_success "Générateur d'exercices mis à jour pour les niveaux 1-5"
fi

print_step "Test TypeScript..."
if npm run type-check --silent 2>/dev/null; then
    print_success "🎉 TypeScript: AUCUNE ERREUR !"
else
    echo -e "${YELLOW}Vérification des erreurs TypeScript :${NC}"
    npm run type-check | head -3
fi

print_step "Test du générateur mis à jour..."
if [ -f "scripts/generate-exercises.js" ]; then
    echo -e "${BLUE}Test Niveau 3 :${NC}"
    node scripts/generate-exercises.js niveau3 3
fi

echo ""
echo -e "${GREEN}🎉 CHANGEMENT VERS NIVEAUX 1-5 TERMINÉ !${NC}"
echo ""
echo -e "${BLUE}✅ MODIFICATIONS APPLIQUÉES :${NC}"
echo "• CP → Niveau 1 (Addition/soustraction jusqu'à 20)"
echo "• CE1 → Niveau 2 (Calculs jusqu'à 100)"
echo "• CE2 → Niveau 3 (Introduction multiplication/division)"
echo "• CM1 → Niveau 4 (Maîtrise des 4 opérations)"
echo "• CM2 → Niveau 5 (Mathématiques avancées)"
echo ""
echo -e "${PURPLE}📊 ÉTAT DE LA PROGRESSION :${NC}"
echo "• Niveau 1: ✅ Validé (100/100)"
echo "• Niveau 2: ✅ Validé (100/100)"
echo "• Niveau 3: ⏳ En cours (67/100)"
echo "• Niveau 4: 🔒 Verrouillé"
echo "• Niveau 5: 🔒 Verrouillé"
echo ""
echo -e "${GREEN}🎮 TESTEZ MAINTENANT :${NC}"
echo "npm run dev"
echo "node scripts/generate-exercises.js niveau4 10"
echo ""
echo -e "${BLUE}🌟 Interface mise à jour avec le nouveau système de niveaux !${NC}"

cd ../..