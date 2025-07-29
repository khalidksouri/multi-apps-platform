'use client';

import { useState, useEffect } from 'react';
import { ArrowLeft, Settings, Trophy, Target, Clock, Star } from 'lucide-react';
import Link from 'next/link';
import { useLanguage } from '@/hooks/useLanguage';
import LanguageSelector from '@/components/language/LanguageSelector';
import './styles.css';

interface ExerciseData {
  question: string;
  answer: number;
}

interface Stats {
  correct: number;
  total: number;
  streak: number;
  accuracy: number;
}

type DifficultyLevel = 'facile' | 'moyen' | 'difficile';
type Operation = 'addition' | 'soustraction' | 'multiplication' | 'division';

export default function ExercisesPage() {
  const { t, currentLanguage } = useLanguage();
  const [currentExercise, setCurrentExercise] = useState<ExerciseData>({ question: '', answer: 0 });
  const [userAnswer, setUserAnswer] = useState<string>('');
  const [showConfig, setShowConfig] = useState(false);
  const [difficulty, setDifficulty] = useState<DifficultyLevel>('facile');
  const [operation, setOperation] = useState<Operation>('addition');
  const [stats, setStats] = useState<Stats>({ correct: 0, total: 0, streak: 0, accuracy: 0 });
  const [sessionTime, setSessionTime] = useState(0);
  const [feedback, setFeedback] = useState<{ type: 'success' | 'error' | null; message: string }>({ type: null, message: '' });
  const [badges, setBadges] = useState<string[]>([]);

  // Timer pour la session
  useEffect(() => {
    const timer = setInterval(() => {
      setSessionTime(prev => prev + 1);
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  // Générer un nouvel exercice
  const generateExercise = () => {
    let num1: number, num2: number, answer: number, question: string;
    
    const ranges = {
      facile: { min: 1, max: 10 },
      moyen: { min: 10, max: 50 },
      difficile: { min: 50, max: 100 }
    };

    const range = ranges[difficulty];
    num1 = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min;
    num2 = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min;

    switch (operation) {
      case 'addition':
        answer = num1 + num2;
        question = `${num1} + ${num2}`;
        break;
      case 'soustraction':
        if (num1 < num2) [num1, num2] = [num2, num1];
        answer = num1 - num2;
        question = `${num1} - ${num2}`;
        break;
      case 'multiplication':
        num1 = Math.floor(Math.random() * 12) + 1;
        num2 = Math.floor(Math.random() * 12) + 1;
        answer = num1 * num2;
        question = `${num1} × ${num2}`;
        break;
      case 'division':
        answer = Math.floor(Math.random() * 12) + 1;
        num1 = answer * (Math.floor(Math.random() * 12) + 1);
        question = `${num1} ÷ ${num1 / answer}`;
        break;
      default:
        answer = num1 + num2;
        question = `${num1} + ${num2}`;
    }

    setCurrentExercise({ question, answer });
  };

  // Vérifier la réponse
  const checkAnswer = () => {
    const userNum = parseInt(userAnswer);
    const isCorrect = userNum === currentExercise.answer;
    
    const newStats = {
      ...stats,
      total: stats.total + 1,
      correct: isCorrect ? stats.correct + 1 : stats.correct,
      streak: isCorrect ? stats.streak + 1 : 0,
      accuracy: ((isCorrect ? stats.correct + 1 : stats.correct) / (stats.total + 1)) * 100
    };
    
    setStats(newStats);
    
    if (isCorrect) {
      setFeedback({ type: 'success', message: '🎉 Excellent ! Bonne réponse !' });
      
      // Vérifier les badges
      if (newStats.streak >= 5 && !badges.includes('En feu')) {
        setBadges([...badges, 'En feu']);
      }
      if (newStats.accuracy >= 90 && newStats.total >= 5 && !badges.includes('Expert')) {
        setBadges([...badges, 'Expert']);
      }
      if (newStats.total >= 10 && !badges.includes('Persévérant')) {
        setBadges([...badges, 'Persévérant']);
      }
    } else {
      setFeedback({ 
        type: 'error', 
        message: `❌ Pas tout à fait ! La bonne réponse était ${currentExercise.answer}` 
      });
    }
    
    setTimeout(() => {
      setFeedback({ type: null, message: '' });
      generateExercise();
      setUserAnswer('');
    }, 2000);
  };

  // Formater le temps
  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  // Initialiser le premier exercice
  useEffect(() => {
    generateExercise();
  }, [difficulty, operation]);

  const operationIcons = {
    addition: '➕',
    soustraction: '➖',
    multiplication: '✖️',
    division: '➗'
  };

  return (
    <div className={`min-h-screen bg-gradient-to-br from-indigo-50 via-white to-cyan-50 ${currentLanguage.rtl ? 'rtl' : 'ltr'}`}>
      {/* Header Navigation */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <Link 
              href="/" 
              className="flex items-center space-x-3 text-gray-700 hover:text-indigo-600 transition-colors duration-200"
            >
              <ArrowLeft size={20} />
              <span className="font-medium">Retour à l'accueil</span>
            </Link>
            
            <div className="flex items-center space-x-4">
              <LanguageSelector />
              <div className="flex items-center space-x-2 text-gray-600">
                <div className="w-8 h-8 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center">
                  <span className="text-white text-sm font-bold">M4C</span>
                </div>
                <span className="font-semibold text-gray-800">{t('appName')}</span>
              </div>
              
              <button
                onClick={() => setShowConfig(!showConfig)}
                className="p-2 rounded-lg bg-indigo-100 text-indigo-600 hover:bg-indigo-200 transition-colors duration-200"
              >
                <Settings size={20} />
              </button>
            </div>
          </div>
        </div>
      </header>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          
          {/* Configuration Panel - Sidebar gauche */}
          <div className={`lg:col-span-3 ${showConfig ? 'block' : 'hidden lg:block'}`}>
            <div className="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
              <h3 className="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                <Settings className="mr-2 text-indigo-600" size={20} />
                Configuration
              </h3>
              
              {/* Sélecteur de difficulté */}
              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">Difficulté</label>
                <div className="space-y-2">
                  {(['facile', 'moyen', 'difficile'] as DifficultyLevel[]).map((level) => (
                    <button
                      key={level}
                      onClick={() => setDifficulty(level)}
                      className={`w-full p-3 rounded-lg text-left font-medium transition-all duration-200 ${
                        difficulty === level
                          ? 'difficulty-button-active'
                          : 'difficulty-button-inactive hover:bg-gray-100'
                      }`}
                    >
                      <div className="flex items-center justify-between">
                        <span className="capitalize">{level}</span>
                        {difficulty === level && <span className="text-emerald-600 font-bold">✓</span>}
                      </div>
                    </button>
                  ))}
                </div>
              </div>
              
              {/* Sélecteur d'opération */}
              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">Opération</label>
                <div className="grid grid-cols-2 gap-2">
                  {(['addition', 'soustraction', 'multiplication', 'division'] as Operation[]).map((op) => (
                    <button
                      key={op}
                      onClick={() => setOperation(op)}
                      className={`p-3 rounded-lg text-center font-medium transition-all duration-200 ${
                        operation === op
                          ? 'operation-button-active'
                          : 'operation-button-inactive hover:bg-gray-100'
                      }`}
                    >
                      <div className="text-lg mb-1">{operationIcons[op]}</div>
                      <div className="text-xs capitalize font-semibold">{op}</div>
                    </button>
                  ))}
                </div>
              </div>
              
              <button
                onClick={() => {
                  setStats({ correct: 0, total: 0, streak: 0, accuracy: 0 });
                  setBadges([]);
                  setSessionTime(0);
                  generateExercise();
                }}
                className="w-full bg-gradient-to-r from-purple-500 to-pink-500 text-white py-3 rounded-lg font-semibold hover:from-purple-600 hover:to-pink-600 transition-all duration-200 shadow-md hover:shadow-lg"
              >
                🔄 Nouvelle Session
              </button>
            </div>
          </div>

          {/* Zone d'exercice principale */}
          <div className="lg:col-span-6">
            <div className="bg-white rounded-2xl shadow-lg p-8 border border-gray-100">
              <div className="text-center">
                {/* Niveau et opération actuels */}
                <div className="exercise-highlight inline-flex items-center space-x-2 px-4 py-2 rounded-full mb-6">
                  <span className="text-2xl">{operationIcons[operation]}</span>
                  <span className="font-bold uppercase tracking-wide">
                    {difficulty} • {operation}
                  </span>
                </div>

                {/* Titre de l'exercice */}
                <div className="mb-8">
                  <h2 className="text-2xl font-bold text-gray-800 mb-2">🧠 Exercice #{stats.total + 1}</h2>
                </div>

                {/* Question */}
                <div className="question-display rounded-2xl p-8 mb-8">
                  <div className="text-6xl font-bold mb-4">
                    {currentExercise.question}
                  </div>
                  <div className="text-4xl font-bold">=</div>
                </div>

                {/* Input de réponse */}
                <div className="mb-6">
                  <input
                    type="number"
                    value={userAnswer}
                    onChange={(e) => setUserAnswer(e.target.value)}
                    onKeyPress={(e) => e.key === 'Enter' && userAnswer && checkAnswer()}
                    className="answer-input w-32 h-12 text-center text-2xl rounded-xl"
                    placeholder="?"
                    autoFocus
                  />
                </div>

                {/* Bouton de validation */}
                <button
                  onClick={checkAnswer}
                  disabled={!userAnswer}
                  className="validate-button px-8 py-3 rounded-xl font-bold text-lg"
                >
                  ✅ Valider
                </button>

                {/* Feedback */}
                {feedback.type && (
                  <div className={`mt-6 p-4 rounded-xl font-semibold text-lg ${
                    feedback.type === 'success' ? 'feedback-success' : 'feedback-error'
                  }`}>
                    {feedback.message}
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* Statistiques - Sidebar droite */}
          <div className="lg:col-span-3">
            <div className="space-y-4">
              
              {/* Stats principales */}
              <div className="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                <h3 className="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                  <Trophy className="mr-2 text-yellow-500" size={20} />
                  Statistiques
                </h3>
                
                <div className="space-y-4">
                  <div className="stat-card-success p-3 rounded-lg">
                    <div className="text-2xl font-bold">{stats.correct}</div>
                    <div className="text-sm font-semibold">Réussies</div>
                  </div>
                  
                  <div className="stat-card-info p-3 rounded-lg">
                    <div className="text-2xl font-bold">{Math.round(stats.accuracy)}%</div>
                    <div className="text-sm font-semibold">Précision</div>
                  </div>
                  
                  <div className="stat-card-warning p-3 rounded-lg">
                    <div className="text-2xl font-bold">{stats.streak}</div>
                    <div className="text-sm font-semibold">Série</div>
                  </div>
                  
                  <div className="stat-card-purple p-3 rounded-lg">
                    <div className="text-2xl font-bold">{formatTime(sessionTime)}</div>
                    <div className="text-sm font-semibold">Temps</div>
                  </div>
                </div>
              </div>

              {/* Badges */}
              {badges.length > 0 && (
                <div className="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
                  <h3 className="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                    <Star className="mr-2 text-yellow-500" size={20} />
                    Badges
                  </h3>
                  
                  <div className="space-y-2">
                    {badges.map((badge, index) => (
                      <div key={index} className="achievement-badge p-3 rounded-lg">
                        <div className="flex items-center">
                          <span className="text-2xl mr-2">🏆</span>
                          <span className="font-bold">{badge}</span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
