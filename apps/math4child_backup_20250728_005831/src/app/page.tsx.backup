'use client';

import { useState, useRef, useEffect } from 'react';
import ExerciseView from '../components/ExerciseView';
import LanguageSelector from '../components/LanguageSelector';

// Types et interfaces
interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

interface Level {
  id: string;
  name: string;
  icon: string;
  progress: number;
  isLocked: boolean;
  requiredAnswers: number;
  currentAnswers: number;
}

interface MathOperation {
  id: string;
  name: string;
  icon: string;
  description: string;
  color: string;
}

interface Exercise {
  id: string;
  type: string;
  level: string;
  question: {
    num1: number;
    num2: number;
    operator: string;
    correctAnswer: number;
  };
  userAnswer?: number;
  isCorrect?: boolean;
}

interface User {
  id?: string;
  name?: string;
  email?: string;
  subscription: {
    type: 'free' | 'monthly' | 'quarterly' | 'yearly';
    questionsUsed: number;
    questionsLimit: number;
  };
  progress: {
    currentLevel: string;
    unlockedLevels: string[];
    totalCorrectAnswers: number;
  };
}

// Données de configuration
const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦' },
  { code: 'zh', name: '中文', nativeName: '中文', flag: '🇨🇳' },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵' }
];

const LEVELS: Level[] = [
  { id: 'beginner', name: 'Débutant', icon: '🌱', progress: 0, isLocked: false, requiredAnswers: 100, currentAnswers: 0 },
  { id: 'elementary', name: 'Élémentaire', icon: '🌿', progress: 0, isLocked: true, requiredAnswers: 100, currentAnswers: 0 },
  { id: 'intermediate', name: 'Intermédiaire', icon: '🌳', progress: 0, isLocked: true, requiredAnswers: 100, currentAnswers: 0 },
  { id: 'advanced', name: 'Avancé', icon: '🏔️', progress: 0, isLocked: true, requiredAnswers: 100, currentAnswers: 0 },
  { id: 'expert', name: 'Expert', icon: '🏆', progress: 0, isLocked: true, requiredAnswers: 100, currentAnswers: 0 }
];

const OPERATIONS: MathOperation[] = [
  { id: 'addition', name: 'Addition', icon: '➕', description: 'Apprendre à additionner', color: 'from-green-400 to-emerald-500' },
  { id: 'subtraction', name: 'Soustraction', icon: '➖', description: 'Apprendre à soustraire', color: 'from-red-400 to-pink-500' },
  { id: 'multiplication', name: 'Multiplication', icon: '✖️', description: 'Apprendre à multiplier', color: 'from-blue-400 to-indigo-500' },
  { id: 'division', name: 'Division', icon: '➗', description: 'Apprendre à diviser', color: 'from-purple-400 to-violet-500' },
  { id: 'mixed', name: 'Mixte', icon: '🎯', description: 'Toutes les opérations', color: 'from-yellow-400 to-orange-500' }
];

// Composant principal
export default function Math4ChildApp() {
  // État local
  const [currentLanguage, setCurrentLanguage] = useState<Language>(LANGUAGES[0]);
  const [currentView, setCurrentView] = useState<'home' | 'levels' | 'operations' | 'exercise' | 'login' | 'subscription'>('home');
  const [selectedLevel, setSelectedLevel] = useState<Level | null>(null);
  const [selectedOperation, setSelectedOperation] = useState<MathOperation | null>(null);
  const [currentExercise, setCurrentExercise] = useState<Exercise | null>(null);
  const [exerciseCount, setExerciseCount] = useState(0);
  const [showResult, setShowResult] = useState(false);
  const [levels, setLevels] = useState<Level[]>(LEVELS);
  const [user, setUser] = useState<User>({
    subscription: { type: 'free', questionsUsed: 0, questionsLimit: 50 },
    progress: { currentLevel: 'beginner', unlockedLevels: ['beginner'], totalCorrectAnswers: 0 }
  });

  // Fonction de génération d'exercices ROBUSTE
  const generateExercise = (operation: MathOperation, level: Level): Exercise => {
    console.log('🔧 Génération exercice:', operation.name, level.name);
    
    const difficultyRanges = {
      beginner: { min: 1, max: 10 },
      elementary: { min: 1, max: 50 },
      intermediate: { min: 1, max: 100 },
      advanced: { min: 1, max: 500 },
      expert: { min: 1, max: 1000 }
    };

    const range = difficultyRanges[level.id as keyof typeof difficultyRanges] || { min: 1, max: 10 };
    let num1: number, num2: number, operator: string, correctAnswer: number;

    const randomInRange = (min: number, max: number) => Math.floor(Math.random() * (max - min + 1)) + min;

    switch (operation.id) {
      case 'addition':
        num1 = randomInRange(range.min, range.max);
        num2 = randomInRange(range.min, range.max);
        operator = '+';
        correctAnswer = num1 + num2;
        break;

      case 'subtraction':
        num1 = randomInRange(range.min, range.max);
        num2 = randomInRange(range.min, num1);
        operator = '-';
        correctAnswer = num1 - num2;
        break;

      case 'multiplication':
        const maxMult = Math.min(Math.sqrt(range.max), 12);
        num1 = randomInRange(range.min, Math.max(maxMult, 2));
        num2 = randomInRange(range.min, Math.max(maxMult, 2));
        operator = '×';
        correctAnswer = num1 * num2;
        break;

      case 'division':
        correctAnswer = randomInRange(range.min, Math.min(range.max / 2, 20));
        num2 = randomInRange(2, 10);
        num1 = correctAnswer * num2;
        operator = '÷';
        break;

      case 'mixed':
        const availableOps = ['addition', 'subtraction', 'multiplication', 'division'];
        const randomOpId = availableOps[Math.floor(Math.random() * availableOps.length)];
        const mixedOperation = { ...operation, id: randomOpId };
        return generateExercise(mixedOperation, level);

      default:
        num1 = randomInRange(1, 10);
        num2 = randomInRange(1, 10);
        operator = '+';
        correctAnswer = num1 + num2;
        break;
    }

    const exercise: Exercise = {
      id: `${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      type: operation.id,
      level: level.id,
      question: { num1, num2, operator, correctAnswer }
    };

    console.log('✅ Exercice généré:', exercise);
    return exercise;
  };

  const handleLanguageChange = (language: Language) => {
    console.log('🌍 Changement de langue:', language);
    setCurrentLanguage(language);
  };

  const handleStartExercise = () => {
    console.log('🚀 Démarrage exercice...');
    
    if (!selectedLevel || !selectedOperation) {
      console.error('❌ Niveau ou opération manquant');
      return;
    }
    
    if (user.subscription.type === 'free' && user.subscription.questionsUsed >= user.subscription.questionsLimit) {
      setCurrentView('subscription');
      return;
    }

    const exercise = generateExercise(selectedOperation, selectedLevel);
    setCurrentExercise(exercise);
    setShowResult(false);
    setCurrentView('exercise');
  };

  const handleSubmitAnswer = (userAnswer: string) => {
    console.log('📝 Soumission réponse:', userAnswer);
    
    if (!currentExercise || !userAnswer.trim()) return;

    const userAnswerNum = parseInt(userAnswer);
    const isCorrect = userAnswerNum === currentExercise.question.correctAnswer;
    
    setCurrentExercise(prev => prev ? { ...prev, userAnswer: userAnswerNum, isCorrect } : null);
    setShowResult(true);
    setExerciseCount(prev => prev + 1);

    const newUser = { ...user };
    newUser.subscription.questionsUsed += 1;
    
    if (isCorrect) {
      newUser.progress.totalCorrectAnswers += 1;
      
      const levelIndex = levels.findIndex(l => l.id === selectedLevel?.id);
      if (levelIndex !== -1) {
        const updatedLevels = [...levels];
        updatedLevels[levelIndex].currentAnswers += 1;
        updatedLevels[levelIndex].progress = (updatedLevels[levelIndex].currentAnswers / 100) * 100;
        
        if (updatedLevels[levelIndex].currentAnswers >= 100 && levelIndex < levels.length - 1) {
          updatedLevels[levelIndex + 1].isLocked = false;
          newUser.progress.unlockedLevels.push(updatedLevels[levelIndex + 1].id);
        }
        
        setLevels(updatedLevels);
      }
    }
    
    setUser(newUser);
  };

  const handleNextExercise = () => {
    if (selectedLevel && selectedOperation) {
      const exercise = generateExercise(selectedOperation, selectedLevel);
      setCurrentExercise(exercise);
      setShowResult(false);
    }
  };

  // Rendu conditionnel pour la vue exercice
  if (currentView === 'exercise' && currentExercise) {
    return (
      <ExerciseView
        exercise={currentExercise}
        exerciseCount={exerciseCount}
        selectedOperation={selectedOperation}
        selectedLevel={selectedLevel}
        questionsRemaining={user.subscription.questionsLimit - user.subscription.questionsUsed}
        onSubmitAnswer={handleSubmitAnswer}
        onNextExercise={handleNextExercise}
        onBack={() => setCurrentView('operations')}
        showResult={showResult}
      />
    );
  }

  // Composant de rendu pour le header avec sélecteur de langues
  const renderHeader = () => (
    <header className="bg-white shadow-sm border-b border-gray-200">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="text-4xl">🧮</div>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">Math4Child</h1>
              <p className="text-sm text-gray-600">Apprendre les mathématiques en s'amusant</p>
            </div>
          </div>
          
          {/* Sélecteur de langues corrigé */}
          <LanguageSelector
            languages={LANGUAGES}
            currentLanguage={currentLanguage}
            onLanguageChange={handleLanguageChange}
          />
        </div>
      </div>
    </header>
  );

  const renderHome = () => (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {renderHeader()}

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="text-center mb-16">
          <h2 className="text-5xl font-bold text-gray-900 mb-6">
            Découvre les mathématiques
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600">
              en t'amusant !
            </span>
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
            Une application éducative complète avec 5 niveaux de progression, exercices adaptatifs et support multilingue pour apprendre les mathématiques de façon ludique.
          </p>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-2xl mx-auto mb-8">
            <div className="bg-white rounded-xl p-6 shadow-lg">
              <div className="text-3xl font-bold text-blue-600">{user.progress.totalCorrectAnswers}</div>
              <div className="text-gray-600">Bonnes réponses</div>
            </div>
            <div className="bg-white rounded-xl p-6 shadow-lg">
              <div className="text-3xl font-bold text-green-600">{user.progress.unlockedLevels.length}</div>
              <div className="text-gray-600">Niveaux débloqués</div>
            </div>
            <div className="bg-white rounded-xl p-6 shadow-lg">
              <div className="text-3xl font-bold text-purple-600">
                {user.subscription.questionsLimit - user.subscription.questionsUsed}
              </div>
              <div className="text-gray-600">Questions restantes</div>
            </div>
          </div>
          
          <button
            onClick={() => setCurrentView('levels')}
            className="btn-primary text-lg px-12 py-4"
          >
            🚀 Commencer à apprendre
          </button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-16">
          <div className="bg-white rounded-2xl p-8 shadow-lg text-center">
            <div className="text-4xl mb-4">📈</div>
            <h3 className="font-bold text-xl mb-2">Progression Adaptative</h3>
            <p className="text-gray-600">5 niveaux avec validation de 100 bonnes réponses par niveau</p>
          </div>
          <div className="bg-white rounded-2xl p-8 shadow-lg text-center">
            <div className="text-4xl mb-4">🧮</div>
            <h3 className="font-bold text-xl mb-2">5 Opérations</h3>
            <p className="text-gray-600">Addition, soustraction, multiplication, division et exercices mixtes</p>
          </div>
          <div className="bg-white rounded-2xl p-8 shadow-lg text-center">
            <div className="text-4xl mb-4">🌍</div>
            <h3 className="font-bold text-xl mb-2">Multilingue</h3>
            <p className="text-gray-600">Support de 75+ langues avec adaptation culturelle</p>
          </div>
          <div className="bg-white rounded-2xl p-8 shadow-lg text-center">
            <div className="text-4xl mb-4">📱</div>
            <h3 className="font-bold text-xl mb-2">Multi-plateforme</h3>
            <p className="text-gray-600">Web, Android et iOS avec synchronisation</p>
          </div>
        </div>

        <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-3xl p-12 text-center text-white">
          <h3 className="text-3xl font-bold mb-4">Prêt à commencer l'aventure ?</h3>
          <p className="text-xl mb-8 opacity-90">
            Rejoins des milliers d'enfants qui apprennent déjà avec Math4Child !
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <button
              onClick={() => setCurrentView('levels')}
              className="bg-white text-blue-600 font-semibold py-3 px-8 rounded-xl hover:bg-gray-100 transition-all duration-200"
            >
              🎯 Essai gratuit (50 questions)
            </button>
            <button
              onClick={() => setCurrentView('subscription')}
              className="bg-blue-700 text-white font-semibold py-3 px-8 rounded-xl hover:bg-blue-800 transition-all duration-200"
            >
              💎 Voir les abonnements
            </button>
          </div>
        </div>
      </main>
    </div>
  );

  const renderLevels = () => (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
      <div className="max-w-6xl mx-auto">
        <div className="flex items-center justify-between mb-8">
          <button
            onClick={() => setCurrentView('home')}
            className="btn-secondary"
          >
            ← Retour
          </button>
          <h2 className="text-3xl font-bold text-gray-900">Choisis ton niveau</h2>
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
                  {level.isLocked ? '🔒 Verrouillé' : `${level.currentAnswers}/100 bonnes réponses`}
                </p>
                {level.progress === 100 && (
                  <div className="mt-2 text-green-600 font-semibold">✅ Terminé !</div>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );

  const renderOperations = () => (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
      <div className="max-w-6xl mx-auto">
        <div className="flex items-center justify-between mb-8">
          <button
            onClick={() => setCurrentView('levels')}
            className="btn-secondary"
          >
            ← Retour aux niveaux
          </button>
          <h2 className="text-3xl font-bold text-gray-900">
            Choisis une opération - {selectedLevel?.name}
          </h2>
          <div></div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {OPERATIONS.map((operation) => (
            <div
              key={operation.id}
              onClick={() => {
                setSelectedOperation(operation);
                handleStartExercise();
              }}
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
  );

  const renderSubscription = () => (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
      <div className="max-w-6xl mx-auto">
        <div className="text-center mb-12">
          <h2 className="text-4xl font-bold text-gray-900 mb-4">
            Choisis ton abonnement Math4Child
          </h2>
          <p className="text-xl text-gray-600">
            Débloquer toutes les fonctionnalités et exercices illimités
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="bg-white rounded-2xl p-8 shadow-lg border-2 border-gray-200">
            <div className="text-center">
              <h3 className="text-2xl font-bold text-gray-900 mb-2">Gratuit</h3>
              <div className="text-4xl font-bold text-gray-900 mb-4">0€</div>
              <p className="text-gray-600 mb-6">7 jours - 50 questions</p>
              <ul className="space-y-3 text-left mb-8">
                <li>✓ 50 questions gratuites</li>
                <li>✓ Tous les niveaux (limités)</li>
                <li>✓ Support email</li>
                <li>✓ Accès 7 jours</li>
              </ul>
              <button className="btn-secondary w-full">
                Plan actuel
              </button>
            </div>
          </div>

          <div className="bg-white rounded-2xl p-8 shadow-lg border-2 border-blue-500 relative">
            <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
              <span className="bg-blue-500 text-white px-4 py-2 rounded-full text-sm font-semibold">
                Populaire
              </span>
            </div>
            <div className="text-center">
              <h3 className="text-2xl font-bold text-gray-900 mb-2">Mensuel</h3>
              <div className="text-4xl font-bold text-blue-600 mb-4">9,99€</div>
              <p className="text-gray-600 mb-6">par mois</p>
              <ul className="space-y-3 text-left mb-8">
                <li>✓ Questions illimitées</li>
                <li>✓ Tous les niveaux débloqués</li>
                <li>✓ Toutes les opérations</li>
                <li>✓ Support prioritaire</li>
                <li>✓ Statistiques détaillées</li>
              </ul>
              <button 
                onClick={() => alert('Redirection vers le paiement...')}
                className="btn-primary w-full"
              >
                Choisir ce plan
              </button>
            </div>
          </div>

          <div className="bg-white rounded-2xl p-8 shadow-lg border-2 border-green-500 relative">
            <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
              <span className="bg-green-500 text-white px-4 py-2 rounded-full text-sm font-semibold">
                -30% 🔥
              </span>
            </div>
            <div className="text-center">
              <h3 className="text-2xl font-bold text-gray-900 mb-2">Annuel</h3>
              <div className="text-4xl font-bold text-green-600 mb-1">83,93€</div>
              <div className="text-sm text-gray-500 line-through mb-4">119,88€</div>
              <p className="text-gray-600 mb-6">par an (économise 30%)</p>
              <ul className="space-y-3 text-left mb-8">
                <li>✓ Tout du plan mensuel</li>
                <li>✓ 30% d'économies</li>
                <li>✓ Paiement unique</li>
                <li>✓ Support VIP</li>
                <li>✓ Accès beta features</li>
              </ul>
              <button 
                onClick={() => alert('Redirection vers le paiement...')}
                className="btn-primary w-full bg-green-600 hover:bg-green-700"
              >
                Choisir ce plan
              </button>
            </div>
          </div>
        </div>

        <div className="text-center mt-12">
          <button
            onClick={() => setCurrentView('home')}
            className="btn-secondary"
          >
            ← Retour à l'accueil
          </button>
        </div>
      </div>
    </div>
  );

  // Rendu principal
  switch (currentView) {
    case 'levels':
      return renderLevels();
    case 'operations':
      return renderOperations();
    case 'subscription':
      return renderSubscription();
    default:
      return renderHome();
  }
}
