"use client"

import { useState, useEffect, useCallback } from 'react'

export type Operation = 'addition' | 'subtraction' | 'multiplication' | 'division'

interface ExerciseEngineProps {
  level: number
  operation: Operation
  onAnswer: (isCorrect: boolean) => void
  onComplete: () => void
}

interface Question {
  id: string
  num1: number
  num2: number
  operation: Operation
  question: string
  correctAnswer: number
}

export function ExerciseEngine({ level, operation, onAnswer, onComplete }: ExerciseEngineProps) {
  const [currentQuestion, setCurrentQuestion] = useState<Question | null>(null)
  const [userAnswer, setUserAnswer] = useState('')
  const [showResult, setShowResult] = useState(false)
  const [isCorrect, setIsCorrect] = useState(false)
  const [score, setScore] = useState(0)
  const [questionsAnswered, setQuestionsAnswered] = useState(0)

  const generateQuestion = useCallback((): Question => {
    const maxNum = level * 10
    let num1 = Math.floor(Math.random() * maxNum) + 1
    let num2 = Math.floor(Math.random() * maxNum) + 1
    let correctAnswer: number
    let questionText: string

    switch (operation) {
      case 'addition':
        correctAnswer = num1 + num2
        questionText = `${num1} + ${num2} = ?`
        break
      case 'subtraction':
        if (num1 < num2) [num1, num2] = [num2, num1]
        correctAnswer = num1 - num2
        questionText = `${num1} - ${num2} = ?`
        break
      case 'multiplication':
        num1 = Math.floor(Math.random() * 10) + 1
        num2 = Math.floor(Math.random() * 10) + 1
        correctAnswer = num1 * num2
        questionText = `${num1} × ${num2} = ?`
        break
      case 'division':
        correctAnswer = Math.floor(Math.random() * 10) + 1
        num1 = correctAnswer * (Math.floor(Math.random() * 10) + 1)
        num2 = num1 / correctAnswer
        questionText = `${num1} ÷ ${num2} = ?`
        break
      default:
        correctAnswer = num1 + num2
        questionText = `${num1} + ${num2} = ?`
    }

    return {
      id: Math.random().toString(36).substr(2, 9),
      num1,
      num2,
      operation,
      question: questionText,
      correctAnswer
    }
  }, [level, operation])

  useEffect(() => {
    setCurrentQuestion(generateQuestion())
  }, [generateQuestion])

  const checkAnswer = (answer: string) => {
    if (!currentQuestion) return

    const numAnswer = parseInt(answer)
    const correct = numAnswer === currentQuestion.correctAnswer
    
    setIsCorrect(correct)
    setShowResult(true)
    
    if (correct) {
      setScore(prev => prev + 1)
    }
    
    setQuestionsAnswered(prev => prev + 1)
    onAnswer(correct)

    setTimeout(() => {
      setShowResult(false)
      setUserAnswer('')
      setCurrentQuestion(generateQuestion())
    }, 1500)
  }

  if (!currentQuestion) {
    return <div className="text-center">Génération de la question révolutionnaire...</div>
  }

  return (
    <div className="max-w-2xl mx-auto">
      {/* Header révolutionnaire */}
      <div className="bg-white rounded-xl p-4 shadow-lg mb-6">
        <div className="flex justify-between items-center">
          <div className="flex gap-6">
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">{score}</div>
              <div className="text-xs text-gray-500">Score IA</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-purple-600">{questionsAnswered}</div>
              <div className="text-xs text-gray-500">Questions</div>
            </div>
          </div>
          <div className="text-right">
            <div className="text-sm font-bold text-green-600">🧠 IA Adaptative Active</div>
            <div className="text-xs text-gray-500">Niveau {level} - Révolutionnaire</div>
          </div>
        </div>
      </div>

      {/* Question principale révolutionnaire */}
      <div className="bg-gradient-to-br from-white to-blue-50 rounded-2xl p-8 shadow-xl text-center border-2 border-blue-200">
        {showResult ? (
          <div className={`animate-bounce ${isCorrect ? 'text-green-600' : 'text-red-500'}`}>
            <div className="text-6xl mb-4">
              {isCorrect ? '🎉' : '🔄'}
            </div>
            <div className="text-2xl font-bold mb-2">
              {isCorrect ? 'Excellent ! IA Fière !' : 'IA vous encourage !'}
            </div>
            <div className="text-lg text-gray-600">
              La réponse était : <strong>{currentQuestion.correctAnswer}</strong>
            </div>
            {isCorrect && (
              <div className="mt-2 text-sm text-blue-600">
                🧠 L'IA adapte la prochaine question !
              </div>
            )}
          </div>
        ) : (
          <>
            <div className="text-sm text-purple-600 mb-2">
              🚀 Math4Child v4.2.0 - Moteur IA Révolutionnaire
            </div>
            <div className="text-5xl font-bold text-gray-800 mb-8">
              {currentQuestion.question}
            </div>
            
            <div className="space-y-4">
              <input
                type="number"
                value={userAnswer}
                onChange={(e) => setUserAnswer(e.target.value)}
                onKeyPress={(e) => {
                  if (e.key === 'Enter' && userAnswer) {
                    checkAnswer(userAnswer)
                  }
                }}
                className="text-3xl text-center border-2 border-blue-300 rounded-xl px-6 py-4 w-48 mx-auto focus:border-purple-500 focus:outline-none bg-white shadow-lg"
                placeholder="?"
                autoFocus
              />
              <div>
                <button
                  onClick={() => userAnswer && checkAnswer(userAnswer)}
                  disabled={!userAnswer}
                  className="bg-gradient-to-r from-blue-500 to-purple-500 hover:from-blue-600 hover:to-purple-600 disabled:from-gray-300 disabled:to-gray-400 text-white px-8 py-3 rounded-lg font-medium transition-all transform hover:scale-105 shadow-lg"
                >
                  🧠 Valider avec IA ✓
                </button>
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  )
}
