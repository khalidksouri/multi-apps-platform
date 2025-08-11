"use client"

import { useState, useEffect } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { ArrowLeft, Check, X, Star, Trophy } from 'lucide-react'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import { UniversalLanguageSelector } from '@/components/language/UniversalLanguageSelector'
import { MathExerciseGenerator } from '@/lib/exercises/generator'
import { getLevelById } from '@/lib/progression/levels'
import type { MathExercise } from '@/lib/exercises/generator'

export default function ExercisePage() {
  const params = useParams()
  const router = useRouter()
  const { t, isRTL } = useLanguage()
  
  const level = parseInt(params.level as string)
  const levelConfig = getLevelById(level)
  
  const [exercises, setExercises] = useState<MathExercise[]>([])
  const [currentExerciseIndex, setCurrentExerciseIndex] = useState(0)
  const [userAnswer, setUserAnswer] = useState('')
  const [showFeedback, setShowFeedback] = useState(false)
  const [isCorrect, setIsCorrect] = useState(false)
  const [sessionStats, setSessionStats] = useState({
    correct: 0,
    total: 0,
    startTime: Date.now()
  })

  // Générer les exercices au chargement
  useEffect(() => {
    if (levelConfig) {
      const generatedExercises = MathExerciseGenerator.generateBatch({
        level,
        operation: 'mixed', // Commencer par mixte
        difficulty: level,
        count: 20, // 20 exercices par session
        format: 'input'
      })
      setExercises(generatedExercises)
    }
  }, [level, levelConfig])

  if (!levelConfig) {
    return (
      <div className="min-h-screen bg-gray-100 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-800 mb-4">Niveau introuvable</h1>
          <Link href="/exercises" className="text-blue-600 hover:underline">
            Retour aux niveaux
          </Link>
        </div>
      </div>
    )
  }

  const currentExercise = exercises[currentExerciseIndex]

  const handleSubmitAnswer = () => {
    if (!currentExercise || userAnswer === '') return

    const userNum = parseFloat(userAnswer)
    const correct = userNum === currentExercise.answer
    
    setIsCorrect(correct)
    setShowFeedback(true)
    
    setSessionStats(prev => ({
      ...prev,
      correct: prev.correct + (correct ? 1 : 0),
      total: prev.total + 1
    }))

    // Passer à l'exercice suivant après 2 secondes
    setTimeout(() => {
      if (currentExerciseIndex < exercises.length - 1) {
        setCurrentExerciseIndex(prev => prev + 1)
        setUserAnswer('')
        setShowFeedback(false)
      } else {
        // Fin de session
        handleSessionComplete()
      }
    }, 2000)
  }

  const handleSessionComplete = () => {
    const accuracy = (sessionStats.correct / sessionStats.total) * 100
    const timeSpent = Date.now() - sessionStats.startTime
    
    console.log('🎯 Session terminée:', {
      level,
      correct: sessionStats.correct,
      total: sessionStats.total,
      accuracy: accuracy.toFixed(1) + '%',
      timeSpent: Math.round(timeSpent / 1000) + 's'
    })
    
    // Redirection vers la page des niveaux avec les résultats
    router.push(`/exercises?completed=${level}&score=${sessionStats.correct}&total=${sessionStats.total}`)
  }

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !showFeedback) {
      handleSubmitAnswer()
    }
  }

  if (exercises.length === 0) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-500 via-purple-600 to-pink-500 flex items-center justify-center">
        <div className="text-white text-center">
          <div className="text-6xl mb-4">🧮</div>
          <h2 className="text-2xl font-bold mb-2">Génération des exercices...</h2>
          <p className="text-white/80">Préparation de votre session d'entraînement</p>
        </div>
      </div>
    )
  }

  const progressPercentage = ((currentExerciseIndex + 1) / exercises.length) * 100

  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-500 via-purple-600 to-pink-500 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header */}
      <header className="p-6">
        <div className="flex justify-between items-center max-w-4xl mx-auto">
          <div className="flex items-center gap-4">
            <Link 
              href="/exercises"
              className="flex items-center gap-2 text-white hover:text-gray-200 transition-colors"
            >
              <ArrowLeft size={20} />
              Retour aux niveaux
            </Link>
            <div>
              <h1 className="text-xl font-bold text-white">Niveau {level} - {levelConfig.name}</h1>
              <p className="text-white/80 text-sm">{levelConfig.description}</p>
            </div>
          </div>
          
          <UniversalLanguageSelector />
        </div>
      </header>

      {/* Barre de progression */}
      <div className="px-6 mb-6">
        <div className="max-w-4xl mx-auto">
          <div className="bg-white/20 rounded-full h-3 mb-2">
            <div 
              className="bg-white rounded-full h-3 transition-all duration-300"
              style={{ width: `${progressPercentage}%` }}
            />
          </div>
          <div className="flex justify-between text-white/80 text-sm">
            <span>Question {currentExerciseIndex + 1} sur {exercises.length}</span>
            <span>{sessionStats.correct}/{sessionStats.total} correctes</span>
          </div>
        </div>
      </div>

      {/* Zone d'exercice */}
      <main className="px-6 py-8">
        <div className="max-w-2xl mx-auto">
          <div className="bg-white rounded-2xl shadow-xl p-8 text-center">
            {currentExercise && (
              <>
                {/* Question */}
                <div className="mb-8">
                  <div className="text-sm text-gray-500 mb-2">
                    {currentExercise.type === 'addition' ? '➕ Addition' :
                     currentExercise.type === 'subtraction' ? '➖ Soustraction' :
                     currentExercise.type === 'multiplication' ? '✖️ Multiplication' :
                     currentExercise.type === 'division' ? '➗ Division' : '🔀 Opération mixte'}
                  </div>
                  <div className="text-4xl md:text-6xl font-bold text-gray-800 mb-4">
                    {currentExercise.question}
                  </div>
                </div>

                {/* Zone de réponse */}
                {!showFeedback ? (
                  <div className="mb-8">
                    <input
                      type="number"
                      value={userAnswer}
                      onChange={(e) => setUserAnswer(e.target.value)}
                      onKeyPress={handleKeyPress}
                      placeholder="Votre réponse"
                      className="text-3xl text-center w-48 p-4 border-2 border-gray-300 rounded-xl focus:border-blue-500 focus:outline-none"
                      autoFocus
                    />
                    <div className="mt-4">
                      <button
                        onClick={handleSubmitAnswer}
                        disabled={userAnswer === ''}
                        className="bg-blue-600 text-white px-8 py-3 rounded-xl font-bold text-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                      >
                        Valider
                      </button>
                    </div>
                  </div>
                ) : (
                  <div className="mb-8">
                    {/* Feedback */}
                    <div className={`text-6xl mb-4 ${isCorrect ? 'text-green-500' : 'text-red-500'}`}>
                      {isCorrect ? <Check className="w-16 h-16 mx-auto" /> : <X className="w-16 h-16 mx-auto" />}
                    </div>
                    <div className={`text-2xl font-bold mb-2 ${isCorrect ? 'text-green-600' : 'text-red-600'}`}>
                      {isCorrect ? '🎉 Correct !' : '❌ Incorrect'}
                    </div>
                    {!isCorrect && (
                      <div className="text-lg text-gray-600">
                        La bonne réponse était : <strong>{currentExercise.answer}</strong>
                      </div>
                    )}
                  </div>
                )}

                {/* Statistiques de session */}
                <div className="bg-gray-50 rounded-xl p-4">
                  <div className="grid grid-cols-3 gap-4 text-center">
                    <div>
                      <div className="text-2xl font-bold text-green-600">{sessionStats.correct}</div>
                      <div className="text-sm text-gray-600">Correctes</div>
                    </div>
                    <div>
                      <div className="text-2xl font-bold text-blue-600">
                        {sessionStats.total > 0 ? Math.round((sessionStats.correct / sessionStats.total) * 100) : 0}%
                      </div>
                      <div className="text-sm text-gray-600">Précision</div>
                    </div>
                    <div>
                      <div className="text-2xl font-bold text-purple-600">{sessionStats.total}</div>
                      <div className="text-sm text-gray-600">Total</div>
                    </div>
                  </div>
                </div>
              </>
            )}
          </div>
        </div>
      </main>
    </div>
  )
}
