'use client'

import React, { useState, useEffect } from 'react'
import Link from 'next/link'
import { ProgressionManager } from '@/lib/database/progressionManager'
import type { UserStats, LevelResult } from '@/types'

interface Exercise {
  question: string;
  answer: number;
  userAnswer?: number;
  isCorrect?: boolean;
}

export default function ExercisePage({ params }: { params: { level: string } }) {
  const level = parseInt(params.level);
  const [currentExercise, setCurrentExercise] = useState<Exercise | null>(null);
  const [userAnswer, setUserAnswer] = useState('');
  const [feedback, setFeedback] = useState<string | null>(null);
  const [isCorrect, setIsCorrect] = useState<boolean | null>(null);
  const [userStats, setUserStats] = useState<UserStats | null>(null);
  const [sessionStats, setSessionStats] = useState({
    questions: 0,
    correct: 0,
    startTime: Date.now()
  });

  const progressionManager = ProgressionManager.getInstance();

  useEffect(() => {
    loadUserStats();
    generateNewExercise();
  }, [level]);

  const loadUserStats = () => {
    const stats = progressionManager.getUserStats();
    setUserStats(stats);
  };

  const generateNewExercise = () => {
    let exercise: Exercise;
    
    switch (level) {
      case 1:
        // Addition simple (1-20)
        const a1 = Math.floor(Math.random() * 20) + 1;
        const b1 = Math.floor(Math.random() * 20) + 1;
        exercise = {
          question: `${a1} + ${b1} = ?`,
          answer: a1 + b1
        };
        break;
      
      case 2:
        // Addition/Soustraction (10-50)
        const a2 = Math.floor(Math.random() * 25) + 10;
        const b2 = Math.floor(Math.random() * 15) + 1;
        const operation = Math.random() > 0.5 ? '+' : '-';
        if (operation === '+') {
          exercise = {
            question: `${a2} + ${b2} = ?`,
            answer: a2 + b2
          };
        } else {
          // S'assurer que le résultat est positif
          const larger = Math.max(a2, b2);
          const smaller = Math.min(a2, b2);
          exercise = {
            question: `${larger} - ${smaller} = ?`,
            answer: larger - smaller
          };
        }
        break;
      
      case 3:
        // Soustraction (20-50)
        const a3 = Math.floor(Math.random() * 30) + 20;
        const b3 = Math.floor(Math.random() * 15) + 1;
        exercise = {
          question: `${a3} - ${b3} = ?`,
          answer: a3 - b3
        };
        break;
      
      case 4:
        // Soustraction avancée (30-70)
        const a4 = Math.floor(Math.random() * 40) + 30;
        const b4 = Math.floor(Math.random() * 25) + 1;
        exercise = {
          question: `${a4} - ${b4} = ?`,
          answer: a4 - b4
        };
        break;
      
      case 5:
        // Addition avancée (20-60)
        const a5 = Math.floor(Math.random() * 30) + 20;
        const b5 = Math.floor(Math.random() * 30) + 20;
        exercise = {
          question: `${a5} + ${b5} = ?`,
          answer: a5 + b5
        };
        break;
      
      default:
        exercise = {
          question: '2 + 2 = ?',
          answer: 4
        };
    }
    
    setCurrentExercise(exercise);
    setUserAnswer('');
    setFeedback(null);
    setIsCorrect(null);
  };

  const handleSubmit = () => {
    if (!currentExercise || !userAnswer) return;

    const answer = parseInt(userAnswer);
    const correct = answer === currentExercise.answer;
    const timeSpent = Date.now() - sessionStats.startTime;
    
    setIsCorrect(correct);
    
    // Mettre à jour les stats de session
    const newSessionStats = {
      questions: sessionStats.questions + 1,
      correct: sessionStats.correct + (correct ? 1 : 0),
      startTime: sessionStats.startTime
    };
    setSessionStats(newSessionStats);
    
    // Mettre à jour les stats globales
    const levelResult: LevelResult = {
      level,
      questionsAnswered: 1,
      correctAnswers: correct ? 1 : 0,
      precision: correct ? 100 : 0,
      timeSpent: Math.round(timeSpent / 1000), // en secondes
      completed: correct
    };
    
    const updatedStats = progressionManager.updateStats(levelResult);
    setUserStats(updatedStats);
    
    if (correct) {
      setFeedback('Correct !');
    } else {
      setFeedback(`Incorrect - La réponse était ${currentExercise.answer}`);
    }
  };

  const getOperationType = (level: number): string => {
    switch (level) {
      case 1: return 'addition';
      case 2: return 'arithmetic';
      case 3:
      case 4: return 'soustraction';
      case 5: return 'addition';
      default: return 'arithmetic';
    }
  };

  const getHint = (operationType: string): string => {
    switch (operationType) {
      case 'addition':
        return 'Addition simple: ajoutez les deux nombres ensemble.';
      case 'soustraction':
        return 'Soustraction: retirez le second nombre du premier.';
      case 'arithmetic':
        return 'Regardez bien l\'opération: + pour additionner, - pour soustraire.';
      default:
        return 'Prenez votre temps et réfléchissez bien.';
    }
  };

  const getLevelProgress = (): number => {
    if (!userStats) return 0;
    // Calculer le pourcentage de progression (100 questions = 100%)
    const questionsForCompletion = 100;
    return Math.min((userStats.totalQuestions / questionsForCompletion) * 100, 100);
  };

  if (!currentExercise || !userStats) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 flex items-center justify-center">
        <div className="text-center">
          <div className="text-4xl mb-4">🧠</div>
          <div className="text-xl text-gray-600">Chargement des exercices révolutionnaires...</div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50">
      <div className="container mx-auto px-4 py-8 max-w-4xl">
        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-bold text-gray-800">
            🧮 Exercices Révolutionnaires - Niveau {level}
          </h1>
          <Link
            href="/exercises"
            className="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition-colors"
          >
            ← Retour aux niveaux
          </Link>
        </div>

        {/* Statistiques Globales */}
        <div className="bg-white rounded-lg p-6 mb-8 shadow-lg">
          <h2 className="text-xl font-bold mb-4">📊 Vos Statistiques</h2>
          <div className="grid grid-cols-3 gap-4">
            <div className="text-center">
              <div className="text-3xl font-bold text-blue-600">{userStats.totalQuestions}</div>
              <div className="text-sm text-gray-600">Questions</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold text-green-600">{userStats.totalCorrect}</div>
              <div className="text-sm text-gray-600">Correctes</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold text-purple-600">{userStats.overallPrecision}%</div>
              <div className="text-sm text-gray-600">Précision</div>
            </div>
          </div>
          
          {/* Série et Badges */}
          <div className="grid grid-cols-2 gap-4 mt-4 pt-4 border-t">
            <div className="text-center">
              <div className="text-2xl font-bold text-orange-600">{userStats.currentStreak}</div>
              <div className="text-sm text-gray-600">Série Actuelle</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-red-600">{userStats.badges.length}</div>
              <div className="text-sm text-gray-600">Badges</div>
            </div>
          </div>
        </div>

        {/* Exercice Principal */}
        <div className="bg-white rounded-lg p-8 shadow-lg mb-8">
          <div className="text-center mb-6">
            <span className="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
              Exercice #{userStats.totalQuestions + 1}
            </span>
            <span className="bg-gray-100 text-gray-800 px-3 py-1 rounded-full text-sm font-medium ml-2">
              Niveau {level}
            </span>
            <span className="bg-purple-100 text-purple-800 px-3 py-1 rounded-full text-sm font-medium ml-2">
              {getOperationType(level)}
            </span>
          </div>

          <div className="text-center mb-6">
            <h3 className="text-3xl font-bold mb-6 text-gray-800">
              Calculez: {currentExercise.question}
            </h3>
            
            <input
              type="number"
              value={userAnswer}
              onChange={(e) => setUserAnswer(e.target.value)}
              className="text-center text-3xl font-bold p-4 border-2 border-gray-300 rounded-lg w-40 focus:border-blue-500 focus:outline-none"
              placeholder="?"
              disabled={feedback !== null}
              onKeyPress={(e) => {
                if (e.key === 'Enter' && userAnswer && !feedback) {
                  handleSubmit();
                }
              }}
            />
          </div>

          {feedback && (
            <div className={`p-4 rounded-lg mb-6 ${
              isCorrect 
                ? 'bg-green-100 text-green-800 border border-green-200' 
                : 'bg-red-100 text-red-800 border border-red-200'
            }`}>
              <div className="flex items-center justify-center">
                <span className="text-2xl mr-3">
                  {isCorrect ? '✅' : '❌'}
                </span>
                <div className="text-center">
                  <div className="font-bold text-lg">
                    {isCorrect ? 'Correct !' : `Incorrect - La réponse était ${currentExercise.answer}`}
                  </div>
                  <div className="text-sm mt-1">
                    {isCorrect 
                      ? 'Excellent travail ! Continuez comme ça.' 
                      : getHint(getOperationType(level))
                    }
                  </div>
                </div>
              </div>
            </div>
          )}

          <div className="text-center">
            {!feedback ? (
              <button
                onClick={handleSubmit}
                disabled={!userAnswer}
                className="bg-green-500 text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-green-600 transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed"
              >
                Valider la Réponse
              </button>
            ) : (
              <button
                onClick={generateNewExercise}
                className="bg-blue-500 text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-blue-600 transition-colors flex items-center gap-2 mx-auto"
              >
                Exercice Suivant 🚀
              </button>
            )}
          </div>
        </div>

        {/* Progression et Badges */}
        <div className="grid md:grid-cols-2 gap-6">
          {/* Progression du Niveau */}
          <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
            <div className="flex items-center justify-between mb-2">
              <span className="text-yellow-800 font-medium">🎯 Progression Globale</span>
              <span className="text-yellow-600 text-sm">
                {userStats.totalQuestions}/100 questions
              </span>
            </div>
            <div className="bg-yellow-200 rounded-full h-3">
              <div 
                className="bg-yellow-500 h-3 rounded-full transition-all duration-300"
                style={{ width: `${getLevelProgress()}%` }}
              ></div>
            </div>
          </div>

          {/* Badges Récents */}
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <div className="text-blue-800 font-medium mb-2">🏆 Badges Obtenus</div>
            <div className="flex flex-wrap gap-2">
              {userStats.badges.slice(-3).map((badge, index) => (
                <div 
                  key={badge.id}
                  className="bg-blue-100 text-blue-800 px-2 py-1 rounded-full text-xs flex items-center gap-1"
                >
                  <span>{badge.icon}</span>
                  <span>{badge.name}</span>
                </div>
              ))}
              {userStats.badges.length === 0 && (
                <div className="text-blue-600 text-sm">Continuez pour débloquer des badges !</div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
