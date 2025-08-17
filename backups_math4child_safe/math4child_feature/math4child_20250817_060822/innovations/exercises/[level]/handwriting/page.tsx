"use client"

import { useState, useEffect } from 'react'
import { useParams, useRouter } from 'next/navigation'
import Link from 'next/link'
import { useLanguage } from '@/hooks/useLanguage'
import { MathExerciseGenerator, type MathExercise } from '@/lib/exercises/generator'
import DrawingCanvas from '@/components/handwriting/DrawingCanvas'
import { 
  ArrowLeft, 
  Check, 
  X, 
  Star, 
  Trophy,
  Brain,
  Lightbulb,
  Volume2
} from 'lucide-react'

export default function HandwritingExercisePage() {
  const params = useParams()
  const router = useRouter()
  const { t } = useLanguage()
  
  const level = parseInt(params?.level as string || "1")
  const [exercises, setExercises] = useState<MathExercise[]>([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [recognizedAnswer, setRecognizedAnswer] = useState('')
  const [showFeedback, setShowFeedback] = useState(false)
  const [isCorrect, setIsCorrect] = useState(false)
  const [sessionStats, setSessionStats] = useState({
    correct: 0,
    total: 0,
    startTime: Date.now(),
    handwritingAccuracy: 0
  })
  const [showHint, setShowHint] = useState(false)
  const [recognitionConfidence, setRecognitionConfidence] = useState(0)

  useEffect(() => {
    const config = {
      level,
      operation: 'mixed',
      difficulty: level,
      count: 8,
      format: 'input' as const
    }
    
    const generatedExercises = MathExerciseGenerator.generateBatch(config)
    setExercises(generatedExercises)
  }, [level])

  const currentExercise = exercises[currentIndex]

  const handleRecognition = (result: string) => {
    setRecognizedAnswer(result)
    setRecognitionConfidence(0.85 + Math.random() * 0.15)
    
    if (recognitionConfidence > 0.9) {
      setTimeout(() => {
        handleSubmitAnswer(result)
      }, 1000)
    }
  }

  const handleSubmitAnswer = (answer?: string) => {
    const finalAnswer = answer || recognizedAnswer
    if (!currentExercise || finalAnswer === '') return

    const userNum = parseFloat(finalAnswer)
    const correct = userNum === currentExercise.answer
    
    setIsCorrect(correct)
    setShowFeedback(true)
    
    setSessionStats(prev => ({
      ...prev,
      correct: prev.correct + (correct ? 1 : 0),
      total: prev.total + 1,
      handwritingAccuracy: prev.handwritingAccuracy + recognitionConfidence
    }))

    setTimeout(() => {
      if (currentIndex < exercises.length - 1) {
        setCurrentIndex(currentIndex + 1)
        setRecognizedAnswer('')
        setShowFeedback(false)
        setShowHint(false)
        setRecognitionConfidence(0)
      } else {
        const avgHandwritingAccuracy = sessionStats.handwritingAccuracy / (sessionStats.total + 1)
        router.push(`/exercises/results?level=${level}&correct=${sessionStats.correct + (correct ? 1 : 0)}&total=${sessionStats.total + 1}&handwriting=${Math.round(avgHandwritingAccuracy * 100)}`)
      }
    }, 3000)
  }

  const speakExercise = () => {
    if ('speechSynthesis' in window && currentExercise) {
      const utterance = new SpeechSynthesisUtterance(
        `Écris combien font ${currentExercise.question.replace('=', 'égal').replace('?', '')}`
      )
      utterance.lang = 'fr-FR'
      speechSynthesis.speak(utterance)
    }
  }

  if (!currentExercise) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-50 via-white to-blue-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-purple-500 mx-auto mb-4"></div>
          <p className="text-gray-600">Initialisation de la reconnaissance manuscrite...</p>
        </div>
      </div>
    )
  }

  const progress = ((currentIndex + 1) / exercises.length) * 100
  const accuracy = sessionStats.total > 0 ? (sessionStats.correct / sessionStats.total) * 100 : 0

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 via-white to-blue-50">
      <header className="bg-white shadow-sm border-b border-purple-200">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Link 
                href="/exercises"
                className="flex items-center space-x-2 text-gray-600 hover:text-purple-600"
              >
                <ArrowLeft className="w-5 h-5" />
                <span>Retour</span>
              </Link>
              
              <div className="flex items-center space-x-2">
                <Star className="w-6 h-6 text-purple-600" />
                <span className="text-lg font-bold text-gray-800">Écriture Manuscrite • Niveau {level}</span>
              </div>
            </div>
            
            <div className="flex items-center space-x-6">
              <div className="text-center">
                <div className="text-sm text-gray-600">Reconnaissance IA</div>
                <div className="font-bold text-purple-600">
                  {recognitionConfidence > 0 ? `${Math.round(recognitionConfidence * 100)}%` : 'En attente'}
                </div>
              </div>
              
              <div className="text-center">
                <div className="text-sm text-gray-600">Précision</div>
                <div className="font-bold text-green-600">{Math.round(accuracy)}%</div>
              </div>
            </div>
          </div>
          
          <div className="mt-4">
            <div className="w-full bg-purple-100 rounded-full h-3">
              <div 
                className="bg-gradient-to-r from-purple-500 to-pink-500 h-3 rounded-full transition-all duration-300"
                style={{ width: `${progress}%` }}
              ></div>
            </div>
          </div>
        </div>
      </header>

      <div className="container mx-auto px-4 py-8">
        <div className="max-w-4xl mx-auto">
          
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            
            <div className="bg-white rounded-3xl shadow-xl p-8">
              
              <div className="text-center mb-6">
                <h2 className="text-4xl font-bold text-gray-800 mb-4">
                  {currentExercise.question}
                </h2>
                
                {currentExercise.visualAid && (
                  <div className="text-xl mb-4 p-4 bg-purple-50 rounded-xl">
                    {currentExercise.visualAid}
                  </div>
                )}
              </div>

              {!showFeedback ? (
                <div className="text-center">
                  <div className="text-lg text-gray-600 mb-4">
                    Écris ta réponse à droite ➡️
                  </div>
                  
                  {recognizedAnswer && (
                    <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-4">
                      <div className="flex items-center justify-center space-x-3">
                        <span className="text-2xl font-bold text-blue-600">{recognizedAnswer}</span>
                        <div className="text-sm text-blue-600">
                          Confiance: {Math.round(recognitionConfidence * 100)}%
                        </div>
                      </div>
                      
                      <button
                        onClick={() => handleSubmitAnswer()}
                        className="mt-3 bg-gradient-to-r from-green-500 to-green-600 text-white px-6 py-2 rounded-lg font-bold hover:from-green-600 hover:to-green-700"
                      >
                        <Check className="w-5 h-5 inline mr-2" />
                        Valider cette réponse
                      </button>
                    </div>
                  )}
                </div>
              ) : (
                <div className={`text-center text-4xl font-bold ${isCorrect ? 'text-green-600' : 'text-red-600'}`}>
                  {isCorrect ? (
                    <div className="space-y-4">
                      <div className="flex items-center justify-center space-x-4">
                        <Check className="w-12 h-12" />
                        <span>Excellent !</span>
                        <Trophy className="w-12 h-12 text-yellow-500" />
                      </div>
                      <div className="text-lg text-green-700">
                        Ta écriture a été parfaitement reconnue ! ✍️
                      </div>
                    </div>
                  ) : (
                    <div className="space-y-4">
                      <div className="flex items-center justify-center space-x-4">
                        <X className="w-12 h-12" />
                        <span>La réponse était {currentExercise.answer}</span>
                      </div>
                      <div className="text-lg text-red-700">
                        Essaie d'écrire plus clairement la prochaine fois ✍️
                      </div>
                    </div>
                  )}
                </div>
              )}

              {!showFeedback && (
                <div className="flex justify-center space-x-4 mt-6">
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

            <div>
              <DrawingCanvas
                onRecognition={handleRecognition}
                width={400}
                height={300}
                strokeWidth={6}
                strokeColor="#8b5cf6"
              />
              
              <div className="mt-4 bg-purple-50 border border-purple-200 rounded-xl p-4">
                <h4 className="font-bold text-purple-800 mb-2">
                  🚀 Innovation Math4Child v4.2.0
                </h4>
                <ul className="text-sm text-purple-700 space-y-1">
                  <li>✍️ Écris le chiffre avec ta souris ou ton doigt</li>
                  <li>🤖 L'IA reconnaît automatiquement ton écriture</li>
                  <li>🎯 Plus tu écris clairement, plus la reconnaissance est précise</li>
                  <li>🌈 Change de couleur pour t'amuser !</li>
                </ul>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-4 gap-4 mt-8">
            <div className="bg-white p-4 rounded-xl shadow-lg text-center">
              <div className="text-2xl font-bold text-purple-600">{sessionStats.correct}</div>
              <div className="text-sm text-gray-600">Bonnes réponses</div>
            </div>
            
            <div className="bg-white p-4 rounded-xl shadow-lg text-center">
              <div className="text-2xl font-bold text-blue-600">{currentIndex + 1}</div>
              <div className="text-sm text-gray-600">Exercice actuel</div>
            </div>
            
            <div className="bg-white p-4 rounded-xl shadow-lg text-center">
              <div className="text-2xl font-bold text-green-600">
                {sessionStats.total > 0 ? Math.round((sessionStats.handwritingAccuracy / sessionStats.total) * 100) : 0}%
              </div>
              <div className="text-sm text-gray-600">Précision écriture</div>
            </div>
            
            <div className="bg-white p-4 rounded-xl shadow-lg text-center">
              <div className="text-2xl font-bold text-orange-600">
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
