"use client"

import { useState, useEffect } from 'react'
import { useParams, useRouter } from 'next/navigation'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import { MathExerciseGenerator, type MathExercise } from '@/lib/exercises/generator'
import { ArrowLeft, Check, X, Star, Trophy, Brain, Eye } from 'lucide-react'

export default function AR3DExercisePage() {
  const params = useParams()
  const router = useRouter()
  const { t } = useLanguage()
  
  const level = parseInt(params?.level as string || "1")
  const [exercises, setExercises] = useState<MathExercise[]>([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [userAnswer, setUserAnswer] = useState('')
  const [showFeedback, setShowFeedback] = useState(false)
  const [isCorrect, setIsCorrect] = useState(false)

  useEffect(() => {
    const config = {
      level,
      operation: 'mixed',
      difficulty: level,
      count: 6,
      format: 'input' as const
    }
    
    const generatedExercises = MathExerciseGenerator.generateBatch(config)
    setExercises(generatedExercises)
  }, [level])

  const currentExercise = exercises[currentIndex]

  const handleSubmitAnswer = () => {
    if (!currentExercise || userAnswer === '') return

    const userNum = parseFloat(userAnswer)
    const correct = userNum === currentExercise.answer
    
    setIsCorrect(correct)
    setShowFeedback(true)

    setTimeout(() => {
      if (currentIndex < exercises.length - 1) {
        setCurrentIndex(currentIndex + 1)
        setUserAnswer('')
        setShowFeedback(false)
      } else {
        router.push(`/exercises/results?level=${level}`)
      }
    }, 2000)
  }

  if (!currentExercise) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-50 via-blue-50 to-cyan-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-purple-500 mx-auto mb-4"></div>
          <p className="text-gray-600">Initialisation de la Réalité Augmentée 3D...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 via-blue-50 to-cyan-50">
      <header className="bg-gradient-to-r from-purple-600 via-blue-600 to-cyan-600 text-white shadow-lg">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <Link href="/exercises" className="flex items-center space-x-2 text-white hover:text-cyan-200">
              <ArrowLeft className="w-5 h-5" />
              <span>Retour</span>
            </Link>
            
            <div className="flex items-center space-x-2">
              <span className="text-2xl">🥽</span>
              <span className="text-lg font-bold">Réalité Augmentée 3D • Niveau {level}</span>
            </div>
          </div>
        </div>
      </header>

      <div className="container mx-auto px-4 py-8">
        <div className="max-w-4xl mx-auto">
          
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            
            {/* Simulation 3D (en attendant Three.js) */}
            <div className="bg-white rounded-xl shadow-xl p-8">
              <h3 className="text-xl font-bold mb-4 flex items-center space-x-2">
                <span>🥽</span>
                <span>Visualisation 3D</span>
              </h3>
              
              <div className="bg-gradient-to-br from-blue-100 to-purple-100 rounded-xl p-6 h-64 flex items-center justify-center">
                <div className="text-center">
                  <div className="text-6xl mb-4">
                    {currentExercise.operation === 'addition' ? '🧮➕' : 
                     currentExercise.operation === 'subtraction' ? '🧮➖' :
                     currentExercise.operation === 'multiplication' ? '🧮✖️' : '🧮➗'}
                  </div>
                  <p className="text-purple-800 font-medium">
                    Rendu 3D : {currentExercise.question}
                  </p>
                  <p className="text-purple-600 text-sm mt-2">
                    Innovation Math4Child v4.2.0
                  </p>
                </div>
              </div>
              
              <div className="mt-4 bg-purple-50 border border-purple-200 rounded-xl p-4">
                <h4 className="font-bold text-purple-800 mb-2">🌟 Réalité Augmentée 3D</h4>
                <ul className="text-sm text-purple-700 space-y-1">
                  <li>🧠 Visualisation spatiale des concepts</li>
                  <li>🎯 Compréhension intuitive des opérations</li>
                  <li>🎨 Apprentissage visuel et immersif</li>
                  <li>⚡ Three.js en cours d'initialisation...</li>
                </ul>
              </div>
            </div>

            {/* Interface d'exercice */}
            <div className="bg-white rounded-3xl shadow-xl p-8">
              <div className="text-center mb-6">
                <h2 className="text-4xl font-bold text-gray-800 mb-4">
                  {currentExercise.question}
                </h2>
              </div>

              {!showFeedback ? (
                <div className="text-center mb-6">
                  <div className="flex items-center justify-center space-x-4">
                    <input
                      type="number"
                      value={userAnswer}
                      onChange={(e) => setUserAnswer(e.target.value)}
                      className="text-3xl font-bold text-center w-32 p-4 border-2 border-purple-300 rounded-xl focus:border-purple-500 focus:outline-none"
                      placeholder="?"
                      autoFocus
                    />
                    
                    <button
                      onClick={handleSubmitAnswer}
                      disabled={userAnswer === ''}
                      className="bg-gradient-to-r from-green-500 to-green-600 text-white px-6 py-4 rounded-xl font-bold hover:from-green-600 hover:to-green-700 disabled:opacity-50"
                    >
                      <Check className="w-6 h-6" />
                    </button>
                  </div>
                </div>
              ) : (
                <div className={`text-center text-3xl font-bold mb-6 ${isCorrect ? 'text-green-600' : 'text-red-600'}`}>
                  {isCorrect ? (
                    <div className="space-y-4">
                      <div className="flex items-center justify-center space-x-4">
                        <Check className="w-12 h-12" />
                        <span>Fantastique !</span>
                        <Trophy className="w-12 h-12 text-yellow-500" />
                      </div>
                    </div>
                  ) : (
                    <div className="space-y-4">
                      <div className="flex items-center justify-center space-x-4">
                        <X className="w-12 h-12" />
                        <span>La réponse était {currentExercise.answer}</span>
                      </div>
                    </div>
                  )}
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
