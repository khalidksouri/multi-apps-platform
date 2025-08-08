"use client"

import { useState, useEffect } from 'react'

interface Exercise {
  id: string
  type: string
  question: string
  options?: string[]
  correctAnswer: string | number
  difficulty: number
  explanation: string
}

interface ExerciseEngineProps {
  level: number
  onComplete?: (result: any) => void
}

export default function ExerciseEngine({ level, onComplete }: ExerciseEngineProps) {
  const [currentExercise, setCurrentExercise] = useState<Exercise | null>(null)
  const [userAnswer, setUserAnswer] = useState('')
  const [isCorrect, setIsCorrect] = useState<boolean | null>(null)
  const [showExplanation, setShowExplanation] = useState(false)
  const [exerciseCount, setExerciseCount] = useState(0)
  const [correctCount, setCorrectCount] = useState(0)

  useEffect(() => {
    generateNewExercise()
  }, [level])

  const generateNewExercise = () => {
    const exercises: Exercise[] = [
      {
        id: '1',
        type: 'arithmetic',
        question: `Calculez: ${15 + level * 5} + ${8 + level * 3} = ?`,
        correctAnswer: (15 + level * 5) + (8 + level * 3),
        difficulty: level,
        explanation: 'Addition simple: ajoutez les deux nombres ensemble.'
      },
      {
        id: '2',
        type: 'arithmetic',
        question: `Calculez: ${20 + level * 4} - ${6 + level * 2} = ?`,
        correctAnswer: (20 + level * 4) - (6 + level * 2),
        difficulty: level,
        explanation: 'Soustraction: retirez le second nombre du premier.'
      },
      {
        id: '3',
        type: 'multiplication',
        question: `Calculez: ${3 + level} × ${2 + level} = ?`,
        correctAnswer: (3 + level) * (2 + level),
        difficulty: level + 1,
        explanation: 'Multiplication: multipliez les deux nombres.'
      }
    ]

    const randomExercise = exercises[Math.floor(Math.random() * exercises.length)]
    setCurrentExercise(randomExercise)
    setUserAnswer('')
    setIsCorrect(null)
    setShowExplanation(false)
  }

  const checkAnswer = () => {
    if (!currentExercise) return

    const correct = userAnswer.toString() === currentExercise.correctAnswer.toString()
    setIsCorrect(correct)
    setShowExplanation(true)

    if (correct) {
      setCorrectCount(prev => prev + 1)
    }

    setExerciseCount(prev => prev + 1)

    if (onComplete) {
      onComplete({
        correct,
        exercise: currentExercise,
        answer: userAnswer,
        count: exerciseCount + 1
      })
    }
  }

  const nextExercise = () => {
    generateNewExercise()
  }

  if (!currentExercise) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <p className="text-gray-600">🧠 Préparation de l'exercice...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="max-w-2xl mx-auto p-6">
      {/* Statistiques */}
      <div className="bg-gradient-to-r from-blue-100 to-purple-100 p-4 rounded-lg mb-6 border border-blue-200">
        <h3 className="font-bold text-blue-800 mb-2">📊 Vos Statistiques</h3>
        <div className="grid grid-cols-3 gap-4 text-center">
          <div>
            <div className="text-2xl font-bold text-blue-600">{exerciseCount}</div>
            <div className="text-sm text-blue-700">Questions</div>
          </div>
          <div>
            <div className="text-2xl font-bold text-green-600">{correctCount}</div>
            <div className="text-sm text-green-700">Correctes</div>
          </div>
          <div>
            <div className="text-2xl font-bold text-purple-600">
              {exerciseCount > 0 ? Math.round((correctCount / exerciseCount) * 100) : 0}%
            </div>
            <div className="text-sm text-purple-700">Précision</div>
          </div>
        </div>
      </div>

      {/* Exercice */}
      <div className="bg-white rounded-xl shadow-lg p-6 border border-gray-200">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-bold text-gray-800">
            🧮 Exercice #{exerciseCount + 1}
          </h2>
          <div className="flex items-center space-x-2">
            <span className="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
              Niveau {level}
            </span>
            <span className="bg-gray-100 text-gray-600 px-3 py-1 rounded-full text-sm">
              {currentExercise.type}
            </span>
          </div>
        </div>

        <div className="mb-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">
            {currentExercise.question}
          </h3>

          <input
            type="text"
            value={userAnswer}
            onChange={(e) => setUserAnswer(e.target.value)}
            className="w-full p-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none text-center text-xl"
            placeholder="Tapez votre réponse..."
            disabled={showExplanation}
          />
        </div>

        {/* Résultat */}
        {isCorrect !== null && (
          <div className={`p-4 rounded-lg mb-4 ${
            isCorrect ? 'bg-green-100 border border-green-200' : 'bg-red-100 border border-red-200'
          }`}>
            <div className="flex items-center">
              <span className="text-2xl mr-2">
                {isCorrect ? '✅' : '❌'}
              </span>
              <span className={`font-semibold ${
                isCorrect ? 'text-green-800' : 'text-red-800'
              }`}>
                {isCorrect ? 'Correct !' : `Incorrect - La réponse était ${currentExercise.correctAnswer}`}
              </span>
            </div>
            {showExplanation && (
              <p className={`mt-2 text-sm ${
                isCorrect ? 'text-green-700' : 'text-red-700'
              }`}>
                {currentExercise.explanation}
              </p>
            )}
          </div>
        )}

        {/* Boutons */}
        <div className="flex justify-center">
          {isCorrect === null ? (
            <button
              onClick={checkAnswer}
              disabled={!userAnswer}
              className="bg-blue-500 text-white px-6 py-2 rounded-lg font-semibold hover:bg-blue-600 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
            >
              Vérifier
            </button>
          ) : (
            <button
              onClick={nextExercise}
              className="bg-green-500 text-white px-6 py-2 rounded-lg font-semibold hover:bg-green-600 transition-colors"
            >
              Exercice Suivant 🚀
            </button>
          )}
        </div>
      </div>

      {/* Progression vers validation niveau */}
      <div className="mt-6 bg-yellow-50 border border-yellow-200 rounded-lg p-4">
        <h4 className="font-semibold text-yellow-800 mb-2">🎯 Progression du Niveau</h4>
        <div className="w-full bg-yellow-200 rounded-full h-3">
          <div
            className="bg-yellow-500 h-3 rounded-full transition-all duration-500"
            style={{ width: `${Math.min((correctCount / 100) * 100, 100)}%` }}
          ></div>
        </div>
        <p className="text-sm text-yellow-700 mt-2">
          {correctCount}/100 bonnes réponses pour valider le niveau {level}
          {correctCount >= 100 && " - ✅ Niveau validé !"}
        </p>
      </div>
    </div>
  )
}
