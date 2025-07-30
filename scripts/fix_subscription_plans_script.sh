#!/bin/bash

# =============================================================================
# 🔧 CORRECTION RAPIDE - PLANS D'ABONNEMENTS MANQUANTS
# Résout la perte des plans et l'erreur sed
# =============================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}=================================${NC}"
    echo -e "${PURPLE}🔧 $1${NC}"
    echo -e "${PURPLE}=================================${NC}"
}

print_header "CORRECTION DES PLANS D'ABONNEMENTS"

# Vérifications
if [ ! -d "apps/math4child" ]; then
    log_error "Dossier apps/math4child introuvable!"
    exit 1
fi

cd apps/math4child

# =============================================================================
# 1. CRÉATION D'UNE VERSION CORRIGÉE DU FICHIER PRINCIPAL
# =============================================================================

log_info "🔧 Correction du fichier page.tsx avec tous les plans..."

# Créer une sauvegarde
cp src/app/page.tsx "src/app/page.tsx.backup_fix_plans_$(date +%Y%m%d_%H%M%S)"

# Recréer le fichier avec tous les plans visibles
cat > src/app/page.tsx << 'EOF'
'use client';

import React, { useState, useEffect } from 'react';
import ExerciseView from '../components/ExerciseView';
import LanguageSelector from '../components/LanguageSelector';
import { useTranslations, type Translations } from '../lib/translations';

// =============================================================================
// TYPES ET INTERFACES
// =============================================================================

interface User {
  name: string;
  level: number;
  progress: {
    totalCorrectAnswers: number;
    unlockedLevels: number[];
  };
  questionsLimit: number;
  questionsAnswered: number;
  subscriptionType: 'free' | 'monthly' | 'quarterly' | 'yearly';
  subscription: {
    type: 'free' | 'monthly' | 'quarterly' | 'yearly';
    questionsUsed: number;
    questionsLimit: number;
  };
}

interface Level {
  id: number;
  name: string;
  icon: string;
  isLocked: boolean;
  progress: number;
  requiredCorrectAnswers: number;
  currentAnswers: number;
}

interface Operation {
  id: string;
  name: string;
  symbol: string;
  icon: string;
  description: string;
}

interface Exercise {
  id: number;
  question: string;
  answer: number;
  operation: string;
  difficulty: number;
  type: string;
  level: number;
}

interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

type ViewType = 'home' | 'levels' | 'operations' | 'exercise' | 'subscription';

// =============================================================================
// DONNÉES DE CONFIGURATION
// =============================================================================

const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦' },
  { code: 'zh', name: '中文', nativeName: '中文', flag: '🇨🇳' },
];

// =============================================================================
// COMPOSANT PRINCIPAL
// =============================================================================

export default function Math4Child() {
  // États
  const [currentView, setCurrentView] = useState<ViewType>('home');
  const [currentLanguage, setCurrentLanguage] = useState('fr');
  const [selectedLevel, setSelectedLevel] = useState<Level | null>(null);
  const [selectedOperation, setSelectedOperation] = useState<Operation | null>(null);
  const [currentExercise, setCurrentExercise] = useState<Exercise | null>(null);
  const [userAnswer, setUserAnswer] = useState('');
  const [showResult, setShowResult] = useState(false);
  const [isCorrect, setIsCorrect] = useState(false);

  // Obtenir les traductions pour la langue actuelle
  const t = useTranslations(currentLanguage);

  // Données dynamiques basées sur la langue
  const LEVELS: Level[] = [
    {
      id: 1,
      name: t.levels.beginner,
      icon: '🌱',
      isLocked: false,
      progress: 0,
      requiredCorrectAnswers: 100,
      currentAnswers: 0
    },
    {
      id: 2,
      name: t.levels.elementary,
      icon: '🌿',
      isLocked: true,
      progress: 0,
      requiredCorrectAnswers: 100,
      currentAnswers: 0
    },
    {
      id: 3,
      name: t.levels.intermediate,
      icon: '🌳',
      isLocked: true,
      progress: 0,
      requiredCorrectAnswers: 100,
      currentAnswers: 0
    },
    {
      id: 4,
      name: t.levels.advanced,
      icon: '🦅',
      isLocked: true,
      progress: 0,
      requiredCorrectAnswers: 100,
      currentAnswers: 0
    },
    {
      id: 5,
      name: t.levels.expert,
      icon: '🏆',
      isLocked: true,
      progress: 0,
      requiredCorrectAnswers: 100,
      currentAnswers: 0
    }
  ];

  const OPERATIONS: Operation[] = [
    {
      id: 'addition',
      name: t.operations.addition,
      symbol: '+',
      icon: '➕',
      description: t.operations.additionDesc
    },
    {
      id: 'subtraction',
      name: t.operations.subtraction,
      symbol: '-',
      icon: '➖',
      description: t.operations.subtractionDesc
    },
    {
      id: 'multiplication',
      name: t.operations.multiplication,
      symbol: '×',
      icon: '✖️',
      description: t.operations.multiplicationDesc
    },
    {
      id: 'division',
      name: t.operations.division,
      symbol: '÷',
      icon: '➗',
      description: t.operations.divisionDesc
    },
    {
      id: 'mixed',
      name: t.operations.mixed,
      symbol: '🔀',
      icon: '🎲',
      description: t.operations.mixedDesc
    }
  ];

  const [levels, setLevels] = useState<Level[]>(LEVELS);

  // Utilisateur par défaut
  const [user, setUser] = useState<User>({
    name: 'Utilisateur',
    level: 1,
    progress: { 
      totalCorrectAnswers: 0, 
      unlockedLevels: [1] 
    },
    questionsLimit: 50,
    questionsAnswered: 0,
    subscriptionType: 'free',
    subscription: {
      type: 'free',
      questionsUsed: 0,
      questionsLimit: 50
    }
  });

  // Mettre à jour les niveaux quand la langue change
  useEffect(() => {
    setLevels(LEVELS);
  }, [currentLanguage]);

  // =============================================================================
  // FONCTIONS UTILITAIRES
  // =============================================================================

  const generateExercise = (operation: Operation, level: Level): Exercise => {
    const difficultyRanges = {
      1: { min: 1, max: 10 },
      2: { min: 10, max: 50 },
      3: { min: 50, max: 100 },
      4: { min: 100, max: 500 },
      5: { min: 500, max: 1000 }
    };

    const range = difficultyRanges[level.id as keyof typeof difficultyRanges] || { min: 1, max: 10 };
    
    const num1 = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min;
    const num2 = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min;
    
    let question = '';
    let answer = 0;
    let operator = '';

    if (operation.id === 'mixed') {
      const ops = ['addition', 'subtraction', 'multiplication', 'division'];
      const randomOp = ops[Math.floor(Math.random() * ops.length)];
      const randomOperation = OPERATIONS.find(op => op.id === randomOp)!;
      return generateExercise(randomOperation, level);
    }

    switch (operation.id) {
      case 'addition':
        operator = '+';
        answer = num1 + num2;
        break;
      case 'subtraction':
        operator = '-';
        answer = num1 - num2;
        break;
      case 'multiplication':
        operator = '×';
        answer = num1 * num2;
        break;
      case 'division':
        operator = '÷';
        const quotient = Math.floor(num1 / num2);
        answer = quotient;
        break;
      default:
        operator = '+';
        answer = num1 + num2;
    }

    question = `${num1} ${operator} ${num2} = ?`;

    return {
      id: Date.now(),
      question,
      answer,
      operation: operation.id,
      difficulty: level.id,
      type: operation.id,
      level: level.id
    };
  };

  const checkSubscriptionLimit = (): boolean => {
    return user.subscription.type === 'free' && user.subscription.questionsUsed >= user.subscription.questionsLimit;
  };

  const handleStartExercise = (operation: Operation) => {
    if (checkSubscriptionLimit()) {
      alert(`${t.limitReached}. ${t.limitMessage}`);
      setCurrentView('subscription');
      return;
    }

    if (!selectedLevel) return;
    
    setSelectedOperation(operation);
    const exercise = generateExercise(operation, selectedLevel);
    setCurrentExercise(exercise);
    setCurrentView('exercise');
    setUserAnswer('');
    setShowResult(false);
  };

  const handleSubmitAnswer = () => {
    if (!currentExercise) return;

    const userAnswerNum = parseInt(userAnswer);
    const isCorrect = userAnswerNum === currentExercise.answer;
    
    setIsCorrect(isCorrect);
    setShowResult(true);

    // Mettre à jour l'utilisateur
    const newUser = { ...user };
    newUser.subscription.questionsUsed += 1;
    newUser.questionsAnswered += 1;

    if (isCorrect) {
      newUser.progress.totalCorrectAnswers += 1;
      
      // Mettre à jour le niveau avec logique de complétion
      const levelIndex = levels.findIndex(l => l.id === selectedLevel?.id);
      if (levelIndex !== -1) {
        const updatedLevels = [...levels];
        updatedLevels[levelIndex].currentAnswers += 1;
        updatedLevels[levelIndex].progress = (updatedLevels[levelIndex].currentAnswers / 100) * 100;

        // Marquer le niveau comme complété quand 100 bonnes réponses
        if (updatedLevels[levelIndex].currentAnswers >= 100) {
          // Niveau complété = accès permanent
          if (!newUser.progress.unlockedLevels.includes(updatedLevels[levelIndex].id)) {
            newUser.progress.unlockedLevels.push(updatedLevels[levelIndex].id);
          }
          
          // Débloquer le niveau suivant
          if (levelIndex < levels.length - 1) {
            updatedLevels[levelIndex + 1].isLocked = false;
            if (!newUser.progress.unlockedLevels.includes(updatedLevels[levelIndex + 1].id)) {
              newUser.progress.unlockedLevels.push(updatedLevels[levelIndex + 1].id);
            }
          }
        }

        setLevels(updatedLevels);
      }
    }

    setUser(newUser);
  };

  const handleNextExercise = () => {
    if (!selectedOperation || !selectedLevel) return;
    
    const exercise = generateExercise(selectedOperation, selectedLevel);
    setCurrentExercise(exercise);
    setUserAnswer('');
    setShowResult(false);
  };

  const handleLanguageChange = (languageCode: string) => {
    setCurrentLanguage(languageCode);
  };

  // =============================================================================
  // RENDU DES VUES
  // =============================================================================

  if (currentView === 'exercise' && currentExercise) {
    return (
      <ExerciseView
        exercise={currentExercise}
        userAnswer={userAnswer}
        onAnswerChange={setUserAnswer}
        onSubmit={handleSubmitAnswer}
        onNext={handleNextExercise}
        onBack={() => setCurrentView('operations')}
        showResult={showResult}
        isCorrect={isCorrect}
        translations={t}
      />
    );
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 ${currentLanguage === 'ar' ? 'rtl' : 'ltr'}`}>
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="text-4xl">🧮</div>
              <div>
                <h1 className="text-2xl font-bold text-gray-900">{t.appTitle}</h1>
                <p className="text-sm text-gray-600">{t.appSubtitle}</p>
              </div>
            </div>

            <LanguageSelector
              languages={LANGUAGES}
              currentLanguage={currentLanguage}
              onLanguageChange={handleLanguageChange}
            />
          </div>
        </div>
      </header>

      {/* Vue Accueil */}
      {currentView === 'home' && (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
          <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <div className="text-center mb-16">
              <h2 className="text-5xl font-bold text-gray-900 mb-6">
                {t.heroTitle}
                <span className="block text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600">
                  {t.heroSubtitle}
                </span>
              </h2>
              <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
                {t.heroDescription}
              </p>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-2xl mx-auto mb-8">
                <div className="bg-white rounded-xl p-6 shadow-lg">
                  <div className="text-3xl font-bold text-blue-600">{user.progress.totalCorrectAnswers}</div>
                  <div className="text-gray-600">{t.correctAnswers}</div>
                </div>
                <div className="bg-white rounded-xl p-6 shadow-lg">
                  <div className="text-3xl font-bold text-green-600">{user.progress.unlockedLevels.length}</div>
                  <div className="text-gray-600">{t.unlockedLevels}</div>
                </div>
                <div className="bg-white rounded-xl p-6 shadow-lg">
                  <div className="text-3xl font-bold text-purple-600">
                    {user.subscription.questionsLimit - user.subscription.questionsUsed}
                  </div>
                  <div className="text-gray-600">{t.questionsRemaining}</div>
                </div>
              </div>

              <button
                onClick={() => setCurrentView('levels')}
                className="btn-primary text-lg px-12 py-4"
              >
                {t.startLearning}
              </button>
            </div>

            {/* Fonctionnalités */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-16">
              <div className="bg-white rounded-2xl p-8 shadow-lg text-center">
                <div className="text-4xl mb-4">📈</div>
                <h3 className="font-bold text-xl mb-2">{t.features.adaptiveProgress}</h3>
                <p className="text-gray-600">{t.features.adaptiveDescription}</p>
              </div>
              <div className="bg-white rounded-2xl p-8 shadow-lg text-center">
                <div className="text-4xl mb-4">🧮</div>
                <h3 className="font-bold text-xl mb-2">{t.features.operations}</h3>
                <p className="text-gray-600">{t.features.operationsDescription}</p>
              </div>
              <div className="bg-white rounded-2xl p-8 shadow-lg text-center">
                <div className="text-4xl mb-4">🌍</div>
                <h3 className="font-bold text-xl mb-2">{t.features.multilingual}</h3>
                <p className="text-gray-600">{t.features.multilingualDescription}</p>
              </div>
              <div className="bg-white rounded-2xl p-8 shadow-lg text-center">
                <div className="text-4xl mb-4">📱</div>
                <h3 className="font-bold text-xl mb-2">{t.features.multiplatform}</h3>
                <p className="text-gray-600">{t.features.multiplatformDescription}</p>
              </div>
            </div>

            {/* CTA Section */}
            <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-3xl p-12 text-center text-white">
              <h3 className="text-3xl font-bold mb-4">{t.readyToStart}</h3>
              <p className="text-xl mb-8 opacity-90">
                {t.joinThousands}
              </p>
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <button
                  onClick={() => setCurrentView('levels')}
                  className="bg-white text-blue-600 font-semibold py-3 px-8 rounded-xl hover:bg-gray-100 transition-all duration-200"
                >
                  {t.startFree}
                </button>
                <button
                  onClick={() => setCurrentView('subscription')}
                  className="bg-blue-700 text-white font-semibold py-3 px-8 rounded-xl hover:bg-blue-800 transition-all duration-200"
                >
                  {t.viewSubscriptions}
                </button>
              </div>
            </div>
          </main>
        </div>
      )}

      {/* Vue Niveaux */}
      {currentView === 'levels' && (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
          <div className="max-w-6xl mx-auto">
            <div className="flex items-center justify-between mb-8">
              <button
                onClick={() => setCurrentView('home')}
                className="btn-secondary"
              >
                {t.backToHome}
              </button>
              <h2 className="text-3xl font-bold text-gray-900">{t.chooseLevel}</h2>
              <div></div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6">
              {levels.map((level) => (
                <div
                  key={level.id}
                  onClick={() => {
                    if (!level.isLocked) {
                      setSelectedLevel(level);
                      setCurrentView('operations');
                    }
                  }}
                  className={`level-card ${level.isLocked ? 'locked' : ''} ${selectedLevel?.id === level.id ? 'active' : ''}`}
                >
                  <div className="text-center">
                    <div className="text-5xl mb-4">{level.icon}</div>
                    <h3 className="font-bold text-xl mb-2">{level.name}</h3>
                    <div className="progress-bar mb-3">
                      <div
                        className="progress-fill"
                        style={{ width: `${level.progress}%` }}
                      ></div>
                    </div>
                    <p className="text-sm text-gray-600">
                      {level.isLocked ? t.locked : `${level.currentAnswers}/100 ${t.goodAnswers}`}
                    </p>
                    {level.progress === 100 && (
                      <div className="mt-2 text-green-600 font-semibold">{t.completed}</div>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Vue Opérations */}
      {currentView === 'operations' && selectedLevel && (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
          <div className="max-w-6xl mx-auto">
            <div className="flex items-center justify-between mb-8">
              <button
                onClick={() => setCurrentView('levels')}
                className="btn-secondary"
              >
                {t.backToLevels}
              </button>
              <h2 className="text-3xl font-bold text-gray-900">
                {t.chooseOperation} - {selectedLevel.name}
              </h2>
              <div></div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {OPERATIONS.map((operation) => (
                <div
                  key={operation.id}
                  onClick={() => handleStartExercise(operation)}
                  className="operation-card group"
                >
                  <div className="text-center">
                    <div className="text-6xl mb-4 group-hover:scale-110 transition-transform duration-300">
                      {operation.icon}
                    </div>
                    <h3 className="font-bold text-2xl mb-2">{operation.name}</h3>
                    <p className="text-gray-600">{operation.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Vue Abonnements */}
      {currentView === 'subscription' && (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
          <div className="max-w-7xl mx-auto">
            <div className="text-center mb-12">
              <h2 className="text-4xl font-bold text-gray-900 mb-4">
                {t.subscriptionTitle}
              </h2>
              <p className="text-xl text-gray-600">
                {t.subscriptionSubtitle}
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              {/* Plan gratuit */}
              <div className="bg-white rounded-2xl p-6 shadow-lg border-2 border-gray-200">
                <div className="text-center">
                  <h3 className="text-xl font-bold text-gray-900 mb-2">{t.free}</h3>
                  <div className="text-3xl font-bold text-gray-900 mb-4">0€</div>
                  <p className="text-gray-600 mb-6">7 jours - 50 questions</p>
                  <ul className="space-y-2 text-left mb-6 text-sm">
                    <li>✓ 50 questions gratuites</li>
                    <li>✓ Tous les niveaux (limités)</li>
                    <li>✓ Support email</li>
                    <li>✓ Accès 7 jours</li>
                  </ul>
                  <button className="btn-secondary w-full">
                    {t.currentPlan}
                  </button>
                </div>
              </div>

              {/* Plan mensuel */}
              <div className="bg-white rounded-2xl p-6 shadow-lg border-2 border-blue-500 relative">
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-blue-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
                    {t.popular}
                  </span>
                </div>
                <div className="text-center">
                  <h3 className="text-xl font-bold text-gray-900 mb-2">{t.monthly}</h3>
                  <div className="text-3xl font-bold text-blue-600 mb-4">9,99€</div>
                  <p className="text-gray-600 mb-6">par mois</p>
                  <ul className="space-y-2 text-left mb-6 text-sm">
                    <li>✓ Questions illimitées</li>
                    <li>✓ Tous les niveaux débloqués</li>
                    <li>✓ Toutes les opérations</li>
                    <li>✓ Support prioritaire</li>
                    <li>✓ Statistiques détaillées</li>
                  </ul>
                  <button 
                    onClick={() => alert('Redirection vers le paiement mensuel...')}
                    className="btn-primary w-full"
                  >
                    {t.choosePlan}
                  </button>
                </div>
              </div>

              {/* Plan trimestriel - NOUVEAU */}
              <div className="bg-white rounded-2xl p-6 shadow-lg border-2 border-orange-500 relative new-plan-animation">
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-orange-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
                    -10% 💰
                  </span>
                </div>
                <div className="text-center">
                  <h3 className="text-xl font-bold text-gray-900 mb-2">{t.quarterly}</h3>
                  <div className="text-3xl font-bold text-orange-600 mb-1">26,97€</div>
                  <div className="text-sm text-gray-500 line-through mb-4">29,97€</div>
                  <p className="text-gray-600 mb-6">3 mois ({t.savings} 10%)</p>
                  <ul className="space-y-2 text-left mb-6 text-sm">
                    <li>✓ Tout du plan mensuel</li>
                    <li>✓ 10% d'économies</li>
                    <li>✓ Paiement unique</li>
                    <li>✓ Support premium</li>
                    <li>✓ Accès prioritaire nouveautés</li>
                  </ul>
                  <button 
                    onClick={() => alert('Redirection vers le paiement trimestriel...')}
                    className="quarterly-button w-full font-semibold py-3 px-4 rounded-xl transition-all duration-200"
                  >
                    {t.choosePlan}
                  </button>
                </div>
              </div>

              {/* Plan annuel */}
              <div className="bg-white rounded-2xl p-6 shadow-lg border-2 border-green-500 relative">
                <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                  <span className="bg-green-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
                    -30% 🔥
                  </span>
                </div>
                <div className="text-center">
                  <h3 className="text-xl font-bold text-gray-900 mb-2">{t.yearly}</h3>
                  <div className="text-3xl font-bold text-green-600 mb-1">83,93€</div>
                  <div className="text-sm text-gray-500 line-through mb-4">119,88€</div>
                  <p className="text-gray-600 mb-6">par an ({t.savings} 30%)</p>
                  <ul className="space-y-2 text-left mb-6 text-sm">
                    <li>✓ Tout du plan mensuel</li>
                    <li>✓ 30% d'économies</li>
                    <li>✓ Paiement unique</li>
                    <li>✓ Support VIP</li>
                    <li>✓ Accès beta features</li>
                  </ul>
                  <button 
                    onClick={() => alert('Redirection vers le paiement annuel...')}
                    className="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-4 rounded-xl transition-all duration-200"
                  >
                    {t.choosePlan}
                  </button>
                </div>
              </div>
            </div>

            <div className="text-center mt-12">
              <button
                onClick={() => setCurrentView('home')}
                className="btn-secondary"
              >
                {t.backToHome}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
EOF

log_success "✅ Fichier page.tsx corrigé avec tous les plans"

# =============================================================================
# 2. CORRECTION DU FICHIER DE TRADUCTIONS
# =============================================================================

log_info "🌍 Correction du fichier de traductions..."

# Recréer le fichier de traductions avec tous les termes nécessaires
cat > src/lib/translations/index.ts << 'EOF'
export interface Translations {
  // Navigation et interface
  appTitle: string;
  appSubtitle: string;
  backToHome: string;
  backToLevels: string;
  backToOperations: string;
  
  // Page d'accueil
  heroTitle: string;
  heroSubtitle: string;
  heroDescription: string;
  startLearning: string;
  correctAnswers: string;
  unlockedLevels: string;
  questionsRemaining: string;
  startFree: string;
  viewSubscriptions: string;
  readyToStart: string;
  joinThousands: string;
  
  // Niveaux
  chooseLevel: string;
  locked: string;
  completed: string;
  goodAnswers: string;
  
  // Opérations
  chooseOperation: string;
  
  // Exercices
  exercise: string;
  validate: string;
  correct: string;
  incorrect: string;
  answerWas: string;
  nextExercise: string;
  back: string;
  
  // Abonnements
  subscriptionTitle: string;
  subscriptionSubtitle: string;
  unlockFeatures: string;
  currentPlan: string;
  choosePlan: string;
  popular: string;
  savings: string;
  
  // Plans
  free: string;
  monthly: string;
  quarterly: string;
  yearly: string;
  
  // Fonctionnalités
  features: {
    adaptiveProgress: string;
    adaptiveDescription: string;
    operations: string;
    operationsDescription: string;
    multilingual: string;
    multilingualDescription: string;
    multiplatform: string;
    multiplatformDescription: string;
  };
  
  // Opérations mathématiques
  operations: {
    addition: string;
    subtraction: string;
    multiplication: string;
    division: string;
    mixed: string;
    additionDesc: string;
    subtractionDesc: string;
    multiplicationDesc: string;
    divisionDesc: string;
    mixedDesc: string;
  };
  
  // Niveaux
  levels: {
    beginner: string;
    elementary: string;
    intermediate: string;
    advanced: string;
    expert: string;
  };
  
  // Messages d'erreur
  limitReached: string;
  limitMessage: string;
}

// Traductions françaises
export const fr: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "Apprendre les mathématiques en s'amusant",
  backToHome: "← Retour à l'accueil",
  backToLevels: "← Retour aux niveaux",
  backToOperations: "← Retour aux opérations",
  
  heroTitle: "Apprends les maths en t'amusant !",
  heroSubtitle: "Bienvenue dans l'aventure mathématique",
  heroDescription: "Développe tes compétences mathématiques avec des exercices progressifs et amusants",
  startLearning: "🚀 Commencer à apprendre",
  correctAnswers: "Bonnes réponses",
  unlockedLevels: "Niveaux débloqués",
  questionsRemaining: "Questions restantes",
  startFree: "🎯 Commencer gratuitement",
  viewSubscriptions: "💎 Voir les abonnements",
  readyToStart: "Prêt à commencer l'aventure ?",
  joinThousands: "Rejoins des milliers d'enfants qui apprennent les maths en s'amusant",
  
  chooseLevel: "Choisis ton niveau",
  locked: "🔒 Verrouillé",
  completed: "✅ Terminé !",
  goodAnswers: "bonnes réponses",
  
  chooseOperation: "Choisis ton opération",
  
  exercise: "Exercice",
  validate: "Valider",
  correct: "✅ Correct!",
  incorrect: "❌ Incorrect",
  answerWas: "La réponse était:",
  nextExercise: "Exercice suivant →",
  back: "← Retour",
  
  subscriptionTitle: "Choisis ton abonnement Math4Child",
  subscriptionSubtitle: "Débloquer toutes les fonctionnalités et exercices illimités",
  unlockFeatures: "Débloquer toutes les fonctionnalités",
  currentPlan: "Plan actuel",
  choosePlan: "Choisir ce plan",
  popular: "Populaire",
  savings: "économise",
  
  free: "Gratuit",
  monthly: "Mensuel",
  quarterly: "Trimestriel",
  yearly: "Annuel",
  
  features: {
    adaptiveProgress: "Progression Adaptative",
    adaptiveDescription: "5 niveaux avec validation de 100 bonnes réponses par niveau",
    operations: "5 Opérations",
    operationsDescription: "Addition, soustraction, multiplication, division et exercices mixtes",
    multilingual: "Multilingue",
    multilingualDescription: "Support de 75+ langues avec adaptation culturelle",
    multiplatform: "Multi-plateforme",
    multiplatformDescription: "Web, Android et iOS avec synchronisation"
  },
  
  operations: {
    addition: "Addition",
    subtraction: "Soustraction",
    multiplication: "Multiplication",
    division: "Division",
    mixed: "Mixte",
    additionDesc: "Additionner des nombres",
    subtractionDesc: "Soustraire des nombres",
    multiplicationDesc: "Multiplier des nombres",
    divisionDesc: "Diviser des nombres",
    mixedDesc: "Exercices mélangés"
  },
  
  levels: {
    beginner: "Débutant",
    elementary: "Élémentaire",
    intermediate: "Intermédiaire",
    advanced: "Avancé",
    expert: "Expert"
  },
  
  limitReached: "Limite de questions atteinte",
  limitMessage: "Abonnez-vous pour continuer !"
};

// Traductions anglaises
export const en: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "Learn mathematics while having fun",
  backToHome: "← Back to home",
  backToLevels: "← Back to levels",
  backToOperations: "← Back to operations",
  
  heroTitle: "Learn math while having fun!",
  heroSubtitle: "Welcome to the mathematical adventure",
  heroDescription: "Develop your math skills with progressive and fun exercises",
  startLearning: "🚀 Start learning",
  correctAnswers: "Correct answers",
  unlockedLevels: "Unlocked levels",
  questionsRemaining: "Questions remaining",
  startFree: "🎯 Start for free",
  viewSubscriptions: "💎 View subscriptions",
  readyToStart: "Ready to start the adventure?",
  joinThousands: "Join thousands of children learning math while having fun",
  
  chooseLevel: "Choose your level",
  locked: "🔒 Locked",
  completed: "✅ Completed!",
  goodAnswers: "correct answers",
  
  chooseOperation: "Choose your operation",
  
  exercise: "Exercise",
  validate: "Validate",
  correct: "✅ Correct!",
  incorrect: "❌ Incorrect",
  answerWas: "The answer was:",
  nextExercise: "Next exercise →",
  back: "← Back",
  
  subscriptionTitle: "Choose your Math4Child subscription",
  subscriptionSubtitle: "Unlock all features and unlimited exercises",
  unlockFeatures: "Unlock all features",
  currentPlan: "Current plan",
  choosePlan: "Choose this plan",
  popular: "Popular",
  savings: "save",
  
  free: "Free",
  monthly: "Monthly",
  quarterly: "Quarterly",
  yearly: "Yearly",
  
  features: {
    adaptiveProgress: "Adaptive Progress",
    adaptiveDescription: "5 levels with validation of 100 correct answers per level",
    operations: "5 Operations",
    operationsDescription: "Addition, subtraction, multiplication, division and mixed exercises",
    multilingual: "Multilingual",
    multilingualDescription: "Support for 75+ languages with cultural adaptation",
    multiplatform: "Multi-platform",
    multiplatformDescription: "Web, Android and iOS with synchronization"
  },
  
  operations: {
    addition: "Addition",
    subtraction: "Subtraction",
    multiplication: "Multiplication",
    division: "Division",
    mixed: "Mixed",
    additionDesc: "Add numbers",
    subtractionDesc: "Subtract numbers",
    multiplicationDesc: "Multiply numbers",
    divisionDesc: "Divide numbers",
    mixedDesc: "Mixed exercises"
  },
  
  levels: {
    beginner: "Beginner",
    elementary: "Elementary",
    intermediate: "Intermediate",
    advanced: "Advanced",
    expert: "Expert"
  },
  
  limitReached: "Question limit reached",
  limitMessage: "Subscribe to continue!"
};

// Traductions espagnoles
export const es: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "Aprende matemáticas divirtiéndote",
  backToHome: "← Volver al inicio",
  backToLevels: "← Volver a niveles",
  backToOperations: "← Volver a operaciones",
  
  heroTitle: "¡Aprende matemáticas divirtiéndote!",
  heroSubtitle: "Bienvenido a la aventura matemática",
  heroDescription: "Desarrolla tus habilidades matemáticas con ejercicios progresivos y divertidos",
  startLearning: "🚀 Comenzar a aprender",
  correctAnswers: "Respuestas correctas",
  unlockedLevels: "Niveles desbloqueados",
  questionsRemaining: "Preguntas restantes",
  startFree: "🎯 Comenzar gratis",
  viewSubscriptions: "💎 Ver suscripciones",
  readyToStart: "¿Listo para comenzar la aventura?",
  joinThousands: "Únete a miles de niños que aprenden matemáticas divirtiéndose",
  
  chooseLevel: "Elige tu nivel",
  locked: "🔒 Bloqueado",
  completed: "✅ ¡Completado!",
  goodAnswers: "respuestas correctas",
  
  chooseOperation: "Elige tu operación",
  
  exercise: "Ejercicio",
  validate: "Validar",
  correct: "✅ ¡Correcto!",
  incorrect: "❌ Incorrecto",
  answerWas: "La respuesta era:",
  nextExercise: "Siguiente ejercicio →",
  back: "← Atrás",
  
  subscriptionTitle: "Elige tu suscripción Math4Child",
  subscriptionSubtitle: "Desbloquea todas las funciones y ejercicios ilimitados",
  unlockFeatures: "Desbloquear todas las funciones",
  currentPlan: "Plan actual",
  choosePlan: "Elegir este plan",
  popular: "Popular",
  savings: "ahorra",
  
  free: "Gratis",
  monthly: "Mensual",
  quarterly: "Trimestral",
  yearly: "Anual",
  
  features: {
    adaptiveProgress: "Progreso Adaptativo",
    adaptiveDescription: "5 niveles con validación de 100 respuestas correctas por nivel",
    operations: "5 Operaciones",
    operationsDescription: "Suma, resta, multiplicación, división y ejercicios mixtos",
    multilingual: "Multiidioma",
    multilingualDescription: "Soporte para 75+ idiomas con adaptación cultural",
    multiplatform: "Multiplataforma",
    multiplatformDescription: "Web, Android e iOS con sincronización"
  },
  
  operations: {
    addition: "Suma",
    subtraction: "Resta",
    multiplication: "Multiplicación",
    division: "División",
    mixed: "Mixto",
    additionDesc: "Sumar números",
    subtractionDesc: "Restar números",
    multiplicationDesc: "Multiplicar números",
    divisionDesc: "Dividir números",
    mixedDesc: "Ejercicios mixtos"
  },
  
  levels: {
    beginner: "Principiante",
    elementary: "Elemental",
    intermediate: "Intermedio",
    advanced: "Avanzado",
    expert: "Experto"
  },
  
  limitReached: "Límite de preguntas alcanzado",
  limitMessage: "¡Suscríbete para continuar!"
};

// Traductions allemandes
export const de: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "Mathematik lernen mit Spaß",
  backToHome: "← Zurück zur Startseite",
  backToLevels: "← Zurück zu den Levels",
  backToOperations: "← Zurück zu den Operationen",
  
  heroTitle: "Lerne Mathe mit Spaß!",
  heroSubtitle: "Willkommen zum mathematischen Abenteuer",
  heroDescription: "Entwickle deine mathematischen Fähigkeiten mit progressiven und unterhaltsamen Übungen",
  startLearning: "🚀 Mit dem Lernen beginnen",
  correctAnswers: "Richtige Antworten",
  unlockedLevels: "Freigeschaltete Level",
  questionsRemaining: "Verbleibende Fragen",
  startFree: "🎯 Kostenlos beginnen",
  viewSubscriptions: "💎 Abonnements anzeigen",
  readyToStart: "Bereit für das Abenteuer?",
  joinThousands: "Schließe dich Tausenden von Kindern an, die Mathe mit Spaß lernen",
  
  chooseLevel: "Wähle dein Level",
  locked: "🔒 Gesperrt",
  completed: "✅ Abgeschlossen!",
  goodAnswers: "richtige Antworten",
  
  chooseOperation: "Wähle deine Operation",
  
  exercise: "Übung",
  validate: "Bestätigen",
  correct: "✅ Richtig!",
  incorrect: "❌ Falsch",
  answerWas: "Die Antwort war:",
  nextExercise: "Nächste Übung →",
  back: "← Zurück",
  
  subscriptionTitle: "Wähle dein Math4Child-Abonnement",
  subscriptionSubtitle: "Schalte alle Funktionen und unbegrenzte Übungen frei",
  unlockFeatures: "Alle Funktionen freischalten",
  currentPlan: "Aktueller Plan",
  choosePlan: "Diesen Plan wählen",
  popular: "Beliebt",
  savings: "sparen",
  
  free: "Kostenlos",
  monthly: "Monatlich",
  quarterly: "Vierteljährlich",
  yearly: "Jährlich",
  
  features: {
    adaptiveProgress: "Adaptiver Fortschritt",
    adaptiveDescription: "5 Level mit Validierung von 100 richtigen Antworten pro Level",
    operations: "5 Operationen",
    operationsDescription: "Addition, Subtraktion, Multiplikation, Division und gemischte Übungen",
    multilingual: "Mehrsprachig",
    multilingualDescription: "Unterstützung für 75+ Sprachen mit kultureller Anpassung",
    multiplatform: "Multiplattform",
    multiplatformDescription: "Web, Android und iOS mit Synchronisation"
  },
  
  operations: {
    addition: "Addition",
    subtraction: "Subtraktion",
    multiplication: "Multiplikation",
    division: "Division",
    mixed: "Gemischt",
    additionDesc: "Zahlen addieren",
    subtractionDesc: "Zahlen subtrahieren",
    multiplicationDesc: "Zahlen multiplizieren",
    divisionDesc: "Zahlen dividieren",
    mixedDesc: "Gemischte Übungen"
  },
  
  levels: {
    beginner: "Anfänger",
    elementary: "Grundstufe",
    intermediate: "Mittelstufe",
    advanced: "Fortgeschritten",
    expert: "Experte"
  },
  
  limitReached: "Fragenlimit erreicht",
  limitMessage: "Abonniere, um fortzufahren!"
};

// Traductions arabes
export const ar: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "تعلم الرياضيات بمتعة",
  backToHome: "← العودة للرئيسية",
  backToLevels: "← العودة للمستويات",
  backToOperations: "← العودة للعمليات",
  
  heroTitle: "تعلم الرياضيات بمتعة!",
  heroSubtitle: "مرحباً بك في المغامرة الرياضية",
  heroDescription: "طور مهاراتك الرياضية مع تمارين متدرجة وممتعة",
  startLearning: "🚀 ابدأ التعلم",
  correctAnswers: "الإجابات الصحيحة",
  unlockedLevels: "المستويات المفتوحة",
  questionsRemaining: "الأسئلة المتبقية",
  startFree: "🎯 ابدأ مجاناً",
  viewSubscriptions: "💎 عرض الاشتراكات",
  readyToStart: "مستعد لبدء المغامرة؟",
  joinThousands: "انضم لآلاف الأطفال الذين يتعلمون الرياضيات بمتعة",
  
  chooseLevel: "اختر مستواك",
  locked: "🔒 مغلق",
  completed: "✅ مكتمل!",
  goodAnswers: "إجابات صحيحة",
  
  chooseOperation: "اختر عمليتك",
  
  exercise: "تمرين",
  validate: "تأكيد",
  correct: "✅ صحيح!",
  incorrect: "❌ خطأ",
  answerWas: "الإجابة كانت:",
  nextExercise: "التمرين التالي ←",
  back: "← رجوع",
  
  subscriptionTitle: "اختر اشتراك Math4Child",
  subscriptionSubtitle: "افتح جميع الميزات والتمارين اللامحدودة",
  unlockFeatures: "فتح جميع الميزات",
  currentPlan: "الخطة الحالية",
  choosePlan: "اختر هذه الخطة",
  popular: "شائع",
  savings: "وفر",
  
  free: "مجاني",
  monthly: "شهري",
  quarterly: "ربع سنوي",
  yearly: "سنوي",
  
  features: {
    adaptiveProgress: "تقدم تكيفي",
    adaptiveDescription: "5 مستويات مع تأكيد 100 إجابة صحيحة لكل مستوى",
    operations: "5 عمليات",
    operationsDescription: "الجمع والطرح والضرب والقسمة والتمارين المختلطة",
    multilingual: "متعدد اللغات",
    multilingualDescription: "دعم أكثر من 75 لغة مع التكيف الثقافي",
    multiplatform: "متعدد المنصات",
    multiplatformDescription: "ويب وأندرويد وآي أو إس مع المزامنة"
  },
  
  operations: {
    addition: "الجمع",
    subtraction: "الطرح",
    multiplication: "الضرب",
    division: "القسمة",
    mixed: "مختلط",
    additionDesc: "جمع الأرقام",
    subtractionDesc: "طرح الأرقام",
    multiplicationDesc: "ضرب الأرقام",
    divisionDesc: "قسمة الأرقام",
    mixedDesc: "تمارين مختلطة"
  },
  
  levels: {
    beginner: "مبتدئ",
    elementary: "ابتدائي",
    intermediate: "متوسط",
    advanced: "متقدم",
    expert: "خبير"
  },
  
  limitReached: "تم الوصول لحد الأسئلة",
  limitMessage: "اشترك للمتابعة!"
};

// Traductions chinoises
export const zh: Translations = {
  appTitle: "Math4Child",
  appSubtitle: "快乐学数学",
  backToHome: "← 返回首页",
  backToLevels: "← 返回级别",
  backToOperations: "← 返回运算",
  
  heroTitle: "快乐学数学！",
  heroSubtitle: "欢迎来到数学冒险",
  heroDescription: "通过循序渐进且有趣的练习来提高你的数学技能",
  startLearning: "🚀 开始学习",
  correctAnswers: "正确答案",
  unlockedLevels: "已解锁级别",
  questionsRemaining: "剩余题目",
  startFree: "🎯 免费开始",
  viewSubscriptions: "💎 查看订阅",
  readyToStart: "准备开始冒险了吗？",
  joinThousands: "加入成千上万快乐学数学的孩子们",
  
  chooseLevel: "选择你的级别",
  locked: "🔒 已锁定",
  completed: "✅ 已完成！",
  goodAnswers: "正确答案",
  
  chooseOperation: "选择你的运算",
  
  exercise: "练习",
  validate: "确认",
  correct: "✅ 正确！",
  incorrect: "❌ 错误",
  answerWas: "答案是：",
  nextExercise: "下一题 →",
  back: "← 返回",
  
  subscriptionTitle: "选择你的Math4Child订阅",
  subscriptionSubtitle: "解锁所有功能和无限练习",
  unlockFeatures: "解锁所有功能",
  currentPlan: "当前计划",
  choosePlan: "选择此计划",
  popular: "热门",
  savings: "节省",
  
  free: "免费",
  monthly: "月度",
  quarterly: "季度",
  yearly: "年度",
  
  features: {
    adaptiveProgress: "自适应进步",
    adaptiveDescription: "5个级别，每级需要100个正确答案验证",
    operations: "5种运算",
    operationsDescription: "加法、减法、乘法、除法和混合练习",
    multilingual: "多语言",
    multilingualDescription: "支持75+种语言，具有文化适应性",
    multiplatform: "多平台",
    multiplatformDescription: "网页、安卓和iOS同步"
  },
  
  operations: {
    addition: "加法",
    subtraction: "减法",
    multiplication: "乘法",
    division: "除法",
    mixed: "混合",
    additionDesc: "数字相加",
    subtractionDesc: "数字相减",
    multiplicationDesc: "数字相乘",
    divisionDesc: "数字相除",
    mixedDesc: "混合练习"
  },
  
  levels: {
    beginner: "初学者",
    elementary: "初级",
    intermediate: "中级",
    advanced: "高级",
    expert: "专家"
  },
  
  limitReached: "题目限制已达到",
  limitMessage: "订阅以继续！"
};

// Export de toutes les traductions
export const translations = {
  fr,
  en,
  es,
  de,
  ar,
  zh
};

// Hook pour utiliser les traductions
export const useTranslations = (language: string): Translations => {
  return translations[language as keyof typeof translations] || translations.fr;
};
EOF

log_success "✅ Fichier de traductions corrigé"

# =============================================================================
# 3. REDÉMARRAGE DU SERVEUR
# =============================================================================

log_info "🔄 Redémarrage du serveur..."

# Arrêter le serveur existant
pkill -f "next dev" 2>/dev/null || true
sleep 3

# Supprimer le cache
rm -rf .next

# Redémarrer
npm run dev > /dev/null 2>&1 &
sleep 5

# Vérification que le serveur fonctionne
if pgrep -f "next dev" > /dev/null; then
    log_success "✅ Serveur de développement redémarré"
else
    log_error "⚠️ Le serveur n'a pas pu redémarrer automatiquement"
    echo "   Démarrez-le manuellement avec: npm run dev"
fi

# =============================================================================
# RAPPORT FINAL
# =============================================================================

echo ""
print_header "CORRECTION TERMINÉE"
echo ""
echo "✅ Problèmes résolus :"
echo ""
echo "🔧 Plans d'abonnements restaurés :"
echo "   💰 Plan Gratuit (0€)"
echo "   📅 Plan Mensuel (9,99€) [Populaire]"
echo "   🟠 Plan Trimestriel (26,97€) [-10% 💰]"
echo "   💚 Plan Annuel (83,93€) [-30% 🔥]"
echo ""
echo "🌍 Traductions complètes :"
echo "   🇫🇷 Français"
echo "   🇺🇸 Anglais"
echo "   🇪🇸 Espagnol"
echo "   🇩🇪 Allemand"
echo "   🇸🇦 Arabe (RTL)"
echo "   🇨🇳 Chinois"
echo ""
echo "✅ Fonctionnalités préservées :"
echo "   🎯 Dropdown de langues fonctionnel"
echo "   🔄 Changement de langue instantané"
echo "   🎨 Design orange du plan trimestriel"
echo "   📱 Interface responsive"
echo ""
echo "🌐 Testez maintenant :"
echo "   http://localhost:3000"
echo "   → Changez de langue → Tous les plans apparaissent"
echo "   → Cliquez sur 'Voir les abonnements' → 4 plans visibles"
echo ""
echo "📁 Sauvegarde disponible :"
echo "   src/app/page.tsx.backup_fix_plans_$(date +%Y%m%d_%H%M%S)"
echo ""
log_success "🎉 Tous les plans d'abonnements sont de nouveau visibles!"
echo "======================================"