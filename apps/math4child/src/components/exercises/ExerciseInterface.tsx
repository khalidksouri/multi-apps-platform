"use client"

import { useState, useEffect, useCallback } from 'react';
import { useParams, useRouter } from 'next/navigation';
import Link from 'next/link';
import { useLanguage } from '@/hooks/useLanguage';
import { LEVELS, OPERATIONS, getLevelById, getOperationById } from '@/lib/exercises/levels';
import { ExerciseGenerator, type Exercise } from '@/lib/exercises/generator';
import { LocalDatabase } from '@/lib/database/localStorage';
import { ChevronLeft, Lightbulb, Clock, Target, TrendingUp, Heart } from 'lucide-react';

export function ExerciseInterface() {
  const { t } = useLanguage();
  const params = useParams();
  const router = useRouter();
  const levelId = parseInt(params.level as string);
  const operationId = params.operation as string;
  
  const level = getLevelById(levelId);
  const operation = getOperationById(operationId);
  
  const [currentExercise, setCurrentExercise] = useState<Exercise | null>(null);
  const [userAnswer, setUserAnswer] = useState<string>('');
  const [showFeedback, setShowFeedback] = useState(false);
  const [isCorrect, setIsCorrect] = useState(false);
  const [showHint, setShowHint] = useState(false);
  const [questionCount, setQuestionCount] = useState(0);
  const [correctCount, setCorrectCount] = useState(0);
  const [startTime, setStartTime] = useState<number>(0);
  const [sessionStats, setSessionStats] = useState({
    totalTime: 0,
    streak: 0,
    bestTime: Infinity
  });
  const [canContinue, setCanContinue] = useState(true);

  // Générer un nouvel exercice
  const generateNewExercise = useCallback(() => {
    if (!level || !operation) return;
    
    const exercise = ExerciseGenerator.generateExercise(level, operation);
    setCurrentExercise(exercise);
    setUserAnswer('');
    setShowFeedback(false);
    setShowHint(false);
    setStartTime(Date.now());
  }, [level, operation]);

  // Vérifier les limites utilisateur
  useEffect(() => {
    const progress = LocalDatabase.getProgress();
    if (progress) {
      const canAnswer = LocalDatabase.canAnswerQuestion(progress);
      setCanContinue(canAnswer);
      
      if (!canAnswer) {
        // Rediriger vers la page d'abonnement
        setTimeout(() => {
          router.push('/pricing');
        }, 3000);
      }
    }
  }, [router]);

  // Initialiser le premier exercice
  useEffect(() => {
    if (canContinue) {
      generateNewExercise();
    }
  }, [generateNewExercise, canContinue]);

  // Valider la réponse
  const handleSubmitAnswer = () => {
    if (!currentExercise || userAnswer === '') return;
    
    const userNumAnswer = parseInt(userAnswer);
    const correct = userNumAnswer === currentExercise.correctAnswer;
    const timeSpent = Math.round((Date.now() - startTime) / 1000);
    
    setIsCorrect(correct);
    setShowFeedback(true);
    setQuestionCount(prev => prev + 1);
    
    if (correct) {
      setCorrectCount(prev => prev + 1);
      setSessionStats(prev => ({
        ...prev,
        streak: prev.streak + 1,
        bestTime: Math.min(prev.bestTime, timeSpent),
        totalTime: prev.totalTime + timeSpent
      }));
    } else {
      setSessionStats(prev => ({
        ...prev,
        streak: 0,
        totalTime: prev.totalTime + timeSpent
      }));
    }
    
    // Sauvegarder l'exercice
    const exerciseRecord = {
      id: currentExercise.id,
      userId: 'demo-user',
      level: levelId,
      operation: operationId,
      question: currentExercise.question.display,
      userAnswer: userNumAnswer,
      correctAnswer: currentExercise.correctAnswer,
      isCorrect: correct,
      timeSpent,
      attemptedAt: new Date()
    };
    
    LocalDatabase.saveExercise(exerciseRecord);
    
    // Mettre à jour la progression
    updateUserProgress(correct);
  };

  const updateUserProgress = (correct: boolean) => {
    const progress = LocalDatabase.getProgress();
    if (!progress) return;
    
    // Incrémenter les questions utilisées pour les utilisateurs gratuits
    const user = LocalDatabase.getUser();
    if (user?.subscriptionType === 'free') {
      progress.freeQuestionsUsed += 1;
    }
    
    // Mettre à jour la progression du niveau
    if (!progress.levelProgress[levelId]) {
      progress.levelProgress[levelId] = {
        level: levelId,
        operationProgress: {},
        totalCorrectAnswers: 0,
        isCompleted: false
      };
    }
    
    const levelProgress = progress.levelProgress[levelId];
    
    // Mettre à jour la progression de l'opération
    if (!levelProgress.operationProgress[operationId]) {
      levelProgress.operationProgress[operationId] = {
        operation: operationId,
        correctAnswers: 0,
        totalAttempts: 0,
        averageTime: 0,
        lastAttemptDate: new Date(),
        bestStreak: 0,
        currentStreak: 0
      };
    }
    
    const opProgress = levelProgress.operationProgress[operationId];
    opProgress.totalAttempts += 1;
    opProgress.lastAttemptDate = new Date();
    
    if (correct) {
      opProgress.correctAnswers += 1;
      levelProgress.totalCorrectAnswers += 1;
      progress.totalCorrectAnswers += 1;
      opProgress.currentStreak += 1;
      opProgress.bestStreak = Math.max(opProgress.bestStreak, opProgress.currentStreak);
    } else {
      opProgress.currentStreak = 0;
    }
    
    // Calculer le temps moyen
    const timeSpent = Math.round((Date.now() - startTime) / 1000);
    opProgress.averageTime = Math.round(
      (opProgress.averageTime * (opProgress.totalAttempts - 1) + timeSpent) / opProgress.totalAttempts
    );
    
    // Vérifier si le niveau est complété
    if (levelProgress.totalCorrectAnswers >= 100 && !levelProgress.isCompleted) {
      levelProgress.isCompleted = true;
      levelProgress.completedAt = new Date();
    }
    
    progress.totalQuestionsAnswered += 1;
    progress.lastActiveDate = new Date();
    
    LocalDatabase.saveProgress(progress);
  };

  const handleNextExercise = () => {
    // Vérifier les limites avant de continuer
    const progress = LocalDatabase.getProgress();
    if (progress && !LocalDatabase.canAnswerQuestion(progress)) {
      setCanContinue(false);
      return;
    }
    
    generateNewExercise();
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !showFeedback) {
      handleSubmitAnswer();
    } else if (e.key === 'Enter' && showFeedback) {
      handleNextExercise();
    }
  };

  if (!level || !operation) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-800 mb-4">Page introuvable</h1>
          <Link href="/exercises" className="text-blue-600 hover:text-blue-700">
            ← Retour aux niveaux
          </Link>
        </div>
      </div>
    );
  }

  if (!canContinue) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-purple-50">
        <div className="bg-white rounded-2xl shadow-xl p-8 text-center max-w-md">
          <div className="text-6xl mb-4">🎯</div>
          <h2 className="text-2xl font-bold text-gray-800 mb-4">
            Limite atteinte !
          </h2>
          <p className="text-gray-600 mb-6">
            Tu as utilisé tes 50 questions gratuites sur 7 jours. 
            Abonne-toi pour continuer sans limites !
          </p>
          <Link 
            href="/pricing"
            className="bg-blue-500 hover:bg-blue-600 text-white px-6 py-3 rounded-lg font-medium transition-colors"
          >
            Voir les plans
          </Link>
          <div className="mt-4">
            <Link 
              href="/exercises"
              className="text-gray-500 hover:text-gray-700 text-sm"
            >
              ← Retour aux niveaux
            </Link>
          </div>
        </div>
      </div>
    );
  }

  if (!currentExercise) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <p className="text-gray-600">Génération de l'exercice...</p>
        </div>
      </div>
    );
  }

  const accuracy = questionCount > 0 ? Math.round((correctCount / questionCount) * 100) : 0;
  const averageTime = sessionStats.totalTime > 0 && correctCount > 0 
    ? Math.round(sessionStats.totalTime / correctCount) 
    : 0;

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 py-8">
      <div className="max-w-4xl mx-auto px-4">
        {/* Header avec navigation */}
        <div className="flex items-center justify-between mb-8">
          <Link 
            href={`/exercises/${levelId}`}
            className="flex items-center gap-2 text-blue-600 hover:text-blue-700 transition-colors"
          >
            <ChevronLeft className="w-4 h-4" />
            Retour aux opérations
          </Link>
          
          {/* Stats en temps réel */}
          <div className="flex items-center gap-4 text-sm">
            <div className="flex items-center gap-1 text-green-600">
              <Target className="w-4 h-4" />
              <span>{correctCount}/{questionCount}</span>
            </div>
            {sessionStats.streak > 0 && (
              <div className="flex items-center gap-1 text-orange-600">
                <TrendingUp className="w-4 h-4" />
                <span>{sessionStats.streak} série</span>
              </div>
            )}
          </div>
        </div>

        {/* Info du niveau et opération */}
        <div className="text-center mb-8">
          <div className="flex items-center justify-center gap-3 mb-4">
            <span className="text-3xl">{level.emoji}</span>
            <span className="text-3xl">{operation.emoji}</span>
          </div>
          <h1 className="text-2xl font-bold text-gray-800 mb-2">
            {level.displayName} - {operation.displayName}
          </h1>
          <p className="text-gray-600">
            Question {questionCount + 1} • Nombres {level.numberRange[0]}-{level.numberRange[1]}
          </p>
        </div>

        {/* Interface d'exercice principale */}
        <div className="max-w-2xl mx-auto">
          <div className="bg-white rounded-3xl shadow-xl p-8 mb-6">
            {/* Question */}
            <div className="text-center mb-8">
              <div className="text-5xl font-bold text-gray-800 mb-6 font-mono">
                {currentExercise.question.display}
              </div>
              
              {/* Champ de réponse */}
              <div className="max-w-xs mx-auto">
                <input
                  type="number"
                  value={userAnswer}
                  onChange={(e) => setUserAnswer(e.target.value)}
                  onKeyPress={handleKeyPress}
                  disabled={showFeedback}
                  className={`w-full text-center text-3xl font-bold border-3 rounded-2xl py-4 transition-all ${
                    showFeedback 
                      ? isCorrect 
                        ? 'border-green-400 bg-green-50 text-green-700'
                        : 'border-red-400 bg-red-50 text-red-700'
                      : 'border-blue-300 focus:border-blue-500 focus:ring-4 focus:ring-blue-200'
                  }`}
                  placeholder="?"
                  autoFocus
                />
              </div>
            </div>

            {/* Feedback */}
            {showFeedback && (
              <div className="text-center mb-6">
                {isCorrect ? (
                  <div className="bg-green-100 border border-green-300 rounded-2xl p-4">
                    <div className="text-3xl mb-2">🎉</div>
                    <div className="text-lg font-bold text-green-700 mb-1">
                      Excellent ! Bonne réponse !
                    </div>
                    <div className="text-green-600">
                      Tu progresses très bien !
                    </div>
                  </div>
                ) : (
                  <div className="bg-red-100 border border-red-300 rounded-2xl p-4">
                    <div className="text-3xl mb-2">🤔</div>
                    <div className="text-lg font-bold text-red-700 mb-1">
                      Pas tout à fait...
                    </div>
                    <div className="text-red-600 mb-2">
                      La réponse était : <strong>{currentExercise.correctAnswer}</strong>
                    </div>
                    <div className="text-sm text-red-500">
                      Continue, tu vas y arriver !
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Actions */}
            <div className="flex items-center justify-center gap-4">
              {!showFeedback ? (
                <>
                  <button
                    onClick={() => setShowHint(!showHint)}
                    className="flex items-center gap-2 text-yellow-600 hover:text-yellow-700 transition-colors"
                  >
                    <Lightbulb className="w-4 h-4" />
                    {showHint ? 'Masquer' : 'Indice'}
                  </button>
                  
                  <button
                    onClick={handleSubmitAnswer}
                    disabled={userAnswer === ''}
                    className="bg-blue-500 hover:bg-blue-600 disabled:bg-gray-300 text-white px-8 py-3 rounded-xl font-bold text-lg transition-colors"
                  >
                    Valider
                  </button>
                </>
              ) : (
                <button
                  onClick={handleNextExercise}
                  className="bg-green-500 hover:bg-green-600 text-white px-8 py-3 rounded-xl font-bold text-lg transition-colors"
                >
                  Question suivante →
                </button>
              )}
            </div>

            {/* Indice */}
            {showHint && currentExercise.hint && (
              <div className="mt-6 bg-yellow-50 border border-yellow-200 rounded-xl p-4">
                <div className="flex items-center gap-2 text-yellow-700">
                  <Lightbulb className="w-4 h-4" />
                  <span className="font-medium">Indice :</span>
                </div>
                <p className="text-yellow-600 mt-1">{currentExercise.hint}</p>
              </div>
            )}
          </div>

          {/* Statistiques de session */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-white rounded-xl p-4 text-center shadow-lg">
              <div className="text-2xl font-bold text-blue-600">{accuracy}%</div>
              <div className="text-sm text-gray-600">Précision</div>
            </div>
            
            <div className="bg-white rounded-xl p-4 text-center shadow-lg">
              <div className="text-2xl font-bold text-green-600">{sessionStats.streak}</div>
              <div className="text-sm text-gray-600">Série actuelle</div>
            </div>
            
            {averageTime > 0 && (
              <div className="bg-white rounded-xl p-4 text-center shadow-lg">
                <div className="text-2xl font-bold text-purple-600">{averageTime}s</div>
                <div className="text-sm text-gray-600">Temps moyen</div>
              </div>
            )}
            
            {sessionStats.bestTime < Infinity && (
              <div className="bg-white rounded-xl p-4 text-center shadow-lg">
                <div className="text-2xl font-bold text-orange-600">{sessionStats.bestTime}s</div>
                <div className="text-sm text-gray-600">Meilleur temps</div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
