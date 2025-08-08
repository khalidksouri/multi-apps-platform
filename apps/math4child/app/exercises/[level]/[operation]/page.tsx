"use client"

import { useState, useEffect } from "react"
import { useParams, useRouter } from "next/navigation"
import Navigation from "@/components/navigation/Navigation"
import { useLanguage } from "@/hooks/useLanguage"

interface Question {
  id: number
  question: string
  answer: number
  userAnswer?: number
  isCorrect?: boolean
}

const generateQuestion = (level: number, operation: string): Question => {
  const maxNumber = level === 1 ? 10 : level === 2 ? 20 : level === 3 ? 50 : level === 4 ? 100 : 1000
  
  let a = Math.floor(Math.random() * maxNumber) + 1
  let b = Math.floor(Math.random() * maxNumber) + 1
  let question = ""
  let answer = 0
  
  switch (operation) {
    case 'addition':
      question = `${a} + ${b}`
      answer = a + b
      break
    case 'subtraction':
      if (a < b) [a, b] = [b, a] // Éviter les résultats négatifs
      question = `${a} - ${b}`
      answer = a - b
      break
    case 'multiplication':
      a = Math.floor(Math.random() * Math.min(12, maxNumber)) + 1
      b = Math.floor(Math.random() * Math.min(12, maxNumber)) + 1
      question = `${a} × ${b}`
      answer = a * b
      break
    case 'division':
      answer = Math.floor(Math.random() * Math.min(12, maxNumber)) + 1
      b = Math.floor(Math.random() * Math.min(12, maxNumber)) + 1
      a = answer * b
      question = `${a} ÷ ${b}`
      break
    default:
      // Mixte - choisir aléatoirement
      const ops = ['addition', 'subtraction', 'multiplication', 'division']
      return generateQuestion(level, ops[Math.floor(Math.random() * ops.length)])
  }
  
  return {
    id: Date.now() + Math.random(),
    question,
    answer
  }
}

export default function ExercisePage() {
  const params = useParams()
  const router = useRouter()
  const { isRTL } = useLanguage()
  
  const level = parseInt(params.level as string)
  const operation = params.operation as string
  
  const [currentQuestion, setCurrentQuestion] = useState<Question | null>(null)
  const [userInput, setUserInput] = useState("")
  const [score, setScore] = useState(0)
  const [totalQuestions, setTotalQuestions] = useState(0)
  const [feedback, setFeedback] = useState<"correct" | "incorrect" | null>(null)
  
  useEffect(() => {
    setCurrentQuestion(generateQuestion(level, operation))
  }, [level, operation])
  
  const handleSubmit = () => {
    if (!currentQuestion || userInput === "") return
    
    const userAnswer = parseInt(userInput)
    const isCorrect = userAnswer === currentQuestion.answer
    
    setFeedback(isCorrect ? "correct" : "incorrect")
    setTotalQuestions(prev => prev + 1)
    
    if (isCorrect) {
      setScore(prev => prev + 1)
    }
    
    setTimeout(() => {
      setCurrentQuestion(generateQuestion(level, operation))
      setUserInput("")
      setFeedback(null)
    }, 1500)
  }
  
  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === "Enter") {
      handleSubmit()
    }
  }
  
  const operationNames: { [key: string]: string } = {
    'addition': '➕ Addition',
    'subtraction': '➖ Soustraction', 
    'multiplication': '✖️ Multiplication',
    'division': '➗ Division',
    'mixed': '🎯 Mixte'
  }
  
  const progressPercentage = Math.min((score / 100) * 100, 100)
  
  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 ${isRTL ? 'rtl' : 'ltr'}`}>
      <Navigation />
      
      <div className="max-w-4xl mx-auto px-4 py-8">
        {/* Header */}
        <div className="text-center mb-8">
          <button
            onClick={() => router.back()}
            className="mb-4 px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors"
          >
            ← Retour
          </button>
          <h1 className="text-3xl font-bold text-gray-800 mb-2">
            Niveau {level} - {operationNames[operation]}
          </h1>
          <p className="text-gray-600">
            Résous 100 questions pour débloquer le niveau suivant
          </p>
        </div>
        
        {/* Progress */}
        <div className="mb-8 bg-white rounded-xl p-6 shadow-lg">
          <div className="flex justify-between items-center mb-4">
            <span className="text-lg font-semibold">Progression</span>
            <span className="text-lg font-bold text-blue-600">{score}/100</span>
          </div>
          <div className="w-full bg-gray-200 rounded-full h-4">
            <div 
              className="bg-gradient-to-r from-blue-500 to-purple-500 h-4 rounded-full transition-all duration-500"
              style={{ width: `${progressPercentage}%` }}
            ></div>
          </div>
          <div className="mt-2 text-sm text-gray-600">
            {score < 100 ? `Plus que ${100 - score} bonnes réponses !` : "🎉 Niveau terminé !"}
          </div>
        </div>
        
        {/* Question */}
        {currentQuestion && (
          <div className="bg-white rounded-xl p-8 shadow-lg text-center">
            <div className="text-4xl font-bold text-gray-800 mb-8">
              {currentQuestion.question} = ?
            </div>
            
            <div className="flex justify-center items-center space-x-4 mb-6">
              <input
                type="number"
                value={userInput}
                onChange={(e) => setUserInput(e.target.value)}
                onKeyPress={handleKeyPress}
                className="text-2xl font-bold text-center border-2 border-blue-300 rounded-lg px-4 py-3 w-32 focus:outline-none focus:border-blue-500"
                placeholder="?"
                disabled={feedback !== null}
              />
              <button
                onClick={handleSubmit}
                disabled={userInput === "" || feedback !== null}
                className="px-6 py-3 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              >
                Valider
              </button>
            </div>
            
            {/* Feedback */}
            {feedback && (
              <div className={`text-2xl font-bold ${
                feedback === "correct" ? "text-green-600" : "text-red-600"
              }`}>
                {feedback === "correct" ? "🎉 Correct !" : `❌ Incorrect. La réponse était ${currentQuestion.answer}`}
              </div>
            )}
          </div>
        )}
        
        {/* Stats */}
        <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-white rounded-lg p-4 shadow text-center">
            <div className="text-2xl font-bold text-green-600">{score}</div>
            <div className="text-gray-600">Bonnes réponses</div>
          </div>
          <div className="bg-white rounded-lg p-4 shadow text-center">
            <div className="text-2xl font-bold text-red-600">{totalQuestions - score}</div>
            <div className="text-gray-600">Erreurs</div>
          </div>
          <div className="bg-white rounded-lg p-4 shadow text-center">
            <div className="text-2xl font-bold text-blue-600">
              {totalQuestions > 0 ? Math.round((score / totalQuestions) * 100) : 0}%
            </div>
            <div className="text-gray-600">Précision</div>
          </div>
        </div>
      </div>
    </div>
  )
}
