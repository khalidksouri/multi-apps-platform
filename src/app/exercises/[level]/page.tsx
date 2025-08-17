"use client"

import { useState, useEffect } from 'react'
import { useParams, useRouter } from 'next/navigation'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import { MathExerciseGenerator, type MathExercise } from '@/lib/exercises/generator'
import { 
  ArrowLeft, 
  Check, 
  X, 
  Star, 
  Trophy,
  Brain,
  Clock,
  Lightbulb,
  Volume2,
  RotateCcw
} from 'lucide-react'

export default function ExercisePage() {
  const params = useParams()
  const router = useRouter()
  const { t } = useLanguage()
  
  const level = parseInt(params?.level as string || "1")
  const [exercises, setExercises] = useState<MathExercise[]>([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [userAnswer, setUserAnswer] = useState('')
  const [showFeedback, setShowFeedback] = useState(false)
  const [isCorrect, setIsCorrect] = useState(false)
  const [sessionStats, setSessionStats] = useState({
    correct: 0,
    total: 0,
    startTime: Date.now(),
    timeSpent: 0
  })
  const [showHint, setShowHint] = useState(false)
  const [exerciseStartTime, setExerciseStartTime] = useState(Date.now())

  // Générer les exercices au chargement
  useEffect(() => {
    const config = {
      level,
      operation: 'mixed',
      difficulty: level,
      count: 10,
      format: 'input' as const
    }
    
    const generatedExercises = MathExerciseGenerator.generateBatch(config)
    setExercises(generatedExercises)
    setExerciseStartTime(Date.now())
  }, [level])

  const currentExercise = exercises[currentIndex]

  const handleSubmitAnswer = () => {
    if (!currentExercise || userAnswer === '') return

    const userNum = parseFloat(userAnswer)
    const correct = userNum === currentExercise.answer
    const timeSpent = Date.now() - exerciseStartTime
    
    setIsCorrect(correct)
    setShowFeedback(true)
    
    setSessionStats(prev => ({
      ...prev,
      correct: prev.correct + (correct ? 1 : 0),
      total: prev.total + 1,
      timeSpent: prev.timeSpent + timeSpent
    }))

    // Passer au suivant après 2 secondes
    setTimeout(() => {
      if (currentIndex < exercises.length - 1) {
        setCurrentIndex(currentIndex + 1)
        setUserAnswer('')
        setShowFeedback(false)
        setShowHint(false)
        setExerciseStartTime(Date.now())
      } else {
        // Fin de session
        router.push(`/exercises/results?level=${level}&correct=${sessionStats.correct + (correct ? 1 : 0)}&total=${sessionStats.total + 1}`)
      }
    }, 2000)
  }

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !showFeedback) {
      handleSubmitAnswer()
    }
  }

  const speakExercise = () => {
    if ('speechSynthesis' in window && currentExercise) {
      const utterance = new SpeechSynthesisUtterance(
        `Combien font ${currentExercise.question.replace('=', 'égal').replace('?', '')}`
      )
      utterance.lang = 'fr-FR'
      speechSynthesis.speak(utterance)
    }
  }

  if (!currentExercise) {
    return (
      <div className="min-h-screen bg-gray-100 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <p className="text-gray-600">Génération des exercices...</p>
        </div>
      </div>
    )
  }

  const progress = ((currentIndex + 1) / exercises.length) * 100
  const accuracy = sessionStats.total > 0 ? (sessionStats.correct / sessionStats.total) * 100 : 0

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header avec progression */}
      <header className="bg-white shadow-sm border-b">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Link 
                href="/exercises"
                className="flex items-center space-x-2 text-gray-600 hover:text-blue-600"
              >
                <ArrowLeft className="w-5 h-5" />
                <span>Retour</span>
              </Link>
              
              <div className="flex items-center space-x-2">
                <Brain className="w-6 h-6 text-blue-600" />
                <span className="text-lg font-bold text-gray-800">Niveau {level}</span>
              </div>
            </div>
            
            <div className="flex items-center space-x-6">
              <div className="text-center">
                <div className="text-sm text-gray-600">Progression</div>
                <div className="font-bold text-blue-600">{currentIndex + 1}/{exercises.length}</div>
              </div>
              
              <div className="text-center">
                <div className="text-sm text-gray-600">Précision</div>
                <div className="font-bold text-green-600">{Math.round(accuracy)}%</div>
              </div>
            </div>
          </div>
          
          {/* Barre de progression */}
          <div className="mt-4">
            <div className="w-full bg-gray-200 rounded-full h-2">
              <div 
                className="bg-gradient-to-r from-blue-500 to-purple-600 h-2 rounded-full transition-all duration-300"
                style={{ width: `${progress}%` }}
              ></div>
            </div>
          </div>
        </div>
      </header>

      {/* Exercice principal */}
      <div className="container mx-auto px-4 py-12">
        <div className="max-w-2xl mx-auto">
          
          {/* Carte d'exercice */}
          <div className="bg-white rounded-3xl shadow-xl p-8 mb-8 text-center">
            
            {/* Question */}
            <div className="mb-8">
              <h2 className="text-5xl font-bold text-gray-800 mb-4">
                {currentExercise.question}
              </h2>
              
              {/* Aide visuelle */}
              {currentExercise.visualAid && (
                <div className="text-2xl mb-4 p-4 bg-blue-50 rounded-xl">
                  {currentExercise.visualAid}
                </div>
              )}
            </div>

            {/* Zone de réponse */}
            <div className="mb-8">
              {!showFeedback ? (
                <div className="flex items-center justify-center space-x-4">
                  <input
                    type="number"
                    value={userAnswer}
                    onChange={(e) => setUserAnswer(e.target.value)}
                    onKeyPress={handleKeyPress}
                    className="text-4xl font-bold text-center w-40 p-4 border-2 border-blue-300 rounded-xl focus:border-blue-500 focus:outline-none"
                    placeholder="?"
                    autoFocus
                  />
                  
                  <button
                    onClick={handleSubmitAnswer}
                    disabled={userAnswer === ''}
                    className="bg-gradient-to-r from-green-500 to-green-600 text-white px-6 py-4 rounded-xl font-bold hover:from-green-600 hover:to-green-700 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <Check className="w-6 h-6" />
                  </button>
                </div>
              ) : (
                <div className={`text-6xl font-bold ${isCorrect ? 'text-green-600' : 'text-red-600'}`}>
                  {isCorrect ? (
                    <div className="flex items-center justify-center space-x-4">
                      <Check className="w-16 h-16" />
                      <span>Bravo !</span>
                      <Trophy className="w-16 h-16 text-yellow-500" />
                    </div>
                  ) : (
                    <div className="flex items-center justify-center space-x-4">
                      <X className="w-16 h-16" />
                      <span>La réponse était {currentExercise.answer}</span>
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Actions d'aide */}
            {!showFeedback && (
              <div className="flex justify-center space-x-4">
                <button
                  onClick={() => setShowHint(!showHint)}
                  className="flex items-center space-x-2 bg-yellow-100 text-yellow-800 px-4 py-2 rounded-lg hover:bg-yellow-200"
                >
                  <Lightbulb className="w-4 h-4" />
                  <span>Indice</span>
                </button>
                
                <button
                  onClick={speakExercise}
                  className="flex items-center space-x-2 bg-blue-100 text-blue-800 px-4 py-2 rounded-lg hover:bg-blue-200"
                >
                  <Volume2 className="w-4 h-4" />
                  <span>Écouter</span>
                </button>
              </div>
            )}

            {/* Indice */}
            {showHint && currentExercise.hints && (
              <div className="mt-6 p-4 bg-yellow-50 border border-yellow-200 rounded-xl">
                <div className="flex items-center space-x-2 mb-2">
                  <Lightbulb className="w-5 h-5 text-yellow-600" />
                  <span className="font-bold text-yellow-800">Indice :</span>
                </div>
                <p className="text-yellow-700">{currentExercise.hints[0]}</p>
              </div>
            )}
          </div>

          {/* Statistiques de session */}
          <div className="grid grid-cols-3 gap-4 text-center">
            <div className="bg-white p-4 rounded-xl shadow-lg">
              <div className="text-2xl font-bold text-blue-600">{sessionStats.correct}</div>
              <div className="text-sm text-gray-600">Bonnes réponses</div>
            </div>
            
            <div className="bg-white p-4 rounded-xl shadow-lg">
              <div className="text-2xl font-bold text-orange-600">{currentIndex + 1}</div>
              <div className="text-sm text-gray-600">Exercice actuel</div>
            </div>
            
            <div className="bg-white p-4 rounded-xl shadow-lg">
              <div className="text-2xl font-bold text-purple-600">
                {Math.round((Date.now() - sessionStats.startTime) / 1000)}s
              </div>
              <div className="text-sm text-gray-600">Temps total</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
