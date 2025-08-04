'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'

type Operation = '+' | '-' | '×' | '÷'
type Difficulty = 'facile' | 'moyen' | 'difficile'

interface Exercise {
  id: number
  num1: number
  num2: number
  operation: Operation
  correctAnswer: number
  userAnswer: string
  isCorrect: boolean | null
}

export default function ExercisesPage() {
  const [difficulty, setDifficulty] = useState<Difficulty>('facile')
  const [operation, setOperation] = useState<Operation>('+')
  const [currentExercise, setCurrentExercise] = useState<Exercise | null>(null)
  const [score, setScore] = useState({ correct: 0, total: 0 })
  const [showResult, setShowResult] = useState(false)
  const [streak, setStreak] = useState(0)
  const [sessionTime, setSessionTime] = useState(0)
  const [isActive, setIsActive] = useState(false)

  // Timer pour la session
  useEffect(() => {
    let interval: NodeJS.Timeout | null = null
    if (isActive) {
      interval = setInterval(() => {
        setSessionTime(time => time + 1)
      }, 1000)
    } else if (!isActive && sessionTime !== 0) {
      if (interval) clearInterval(interval)
    }
    return () => {
      if (interval) clearInterval(interval)
    }
  }, [isActive, sessionTime])

  // Générer un nouvel exercice
  const generateExercise = (): Exercise => {
    const ranges = {
      facile: { min: 1, max: 10 },
      moyen: { min: 5, max: 50 },
      difficile: { min: 10, max: 100 }
    }

    const range = ranges[difficulty]
    let num1 = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min
    let num2 = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min
    let correctAnswer: number

    switch (operation) {
      case '+':
        correctAnswer = num1 + num2
        break
      case '-':
        if (num1 < num2) [num1, num2] = [num2, num1]
        correctAnswer = num1 - num2
        break
      case '×':
        num1 = Math.floor(Math.random() * 12) + 1
        num2 = Math.floor(Math.random() * 12) + 1
        correctAnswer = num1 * num2
        break
      case '÷':
        correctAnswer = Math.floor(Math.random() * 12) + 1
        num2 = Math.floor(Math.random() * 12) + 1
        num1 = correctAnswer * num2
        break
    }

    return {
      id: Date.now(),
      num1,
      num2,
      operation,
      correctAnswer,
      userAnswer: '',
      isCorrect: null
    }
  }

  // Vérifier la réponse
  const checkAnswer = () => {
    if (!currentExercise) return
    setIsActive(true)

    const userNum = parseInt(currentExercise.userAnswer)
    const isCorrect = userNum === currentExercise.correctAnswer

    setCurrentExercise(prev => prev ? { ...prev, isCorrect } : null)
    setShowResult(true)
    
    setScore(prev => ({
      correct: prev.correct + (isCorrect ? 1 : 0),
      total: prev.total + 1
    }))

    setStreak(prev => isCorrect ? prev + 1 : 0)

    setTimeout(() => {
      setCurrentExercise(generateExercise())
      setShowResult(false)
    }, 2000)
  }

  // Démarrer une nouvelle session
  const startNewSession = () => {
    setScore({ correct: 0, total: 0 })
    setStreak(0)
    setSessionTime(0)
    setIsActive(false)
    setCurrentExercise(generateExercise())
    setShowResult(false)
  }

  useEffect(() => {
    setCurrentExercise(generateExercise())
  }, [difficulty, operation])

  const accuracyPercentage = score.total > 0 ? Math.round((score.correct / score.total) * 100) : 0
  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }

  return (
    <div className="min-h-screen bg-gradient-to-br">
      {/* Header */}
      <header className="bg-white/10 backdrop-blur-sm border-white/20">
        <div className="max-w-6xl mx-auto px-4 py-4">
          <Link href="/" className="text-white hover:text-yellow-300 mb-4 block">
            ← Retour à l'accueil
          </Link>
          <h1 className="text-3xl font-bold text-white">📚 Exercices Math4Child</h1>
          <p className="text-white/80">Entraîne-toi avec des exercices adaptés à ton niveau</p>
        </div>
      </header>

      <div className="max-w-4xl mx-auto px-4 py-8">
        {/* Configuration */}
        <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-6 mb-8 border-white/30">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl font-bold text-white">⚙️ Configuration</h2>
            <button
              onClick={startNewSession}
              className="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-xl font-semibold transition-all"
            >
              🔄 Nouvelle Session
            </button>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-white font-semibold mb-2">Difficulté :</label>
              <select 
                value={difficulty} 
                onChange={(e) => setDifficulty(e.target.value as Difficulty)}
                className="w-full p-3 rounded-xl bg-white/20 text-white border-white/30"
              >
                <option value="facile">🟢 Facile (1-10)</option>
                <option value="moyen">🟡 Moyen (5-50)</option>
                <option value="difficile">🔴 Difficile (10-100)</option>
              </select>
            </div>

            <div>
              <label className="block text-white font-semibold mb-2">Opération :</label>
              <select 
                value={operation} 
                onChange={(e) => setOperation(e.target.value as Operation)}
                className="w-full p-3 rounded-xl bg-white/20 text-white border-white/30"
              >
                <option value="+">➕ Addition</option>
                <option value="-">➖ Soustraction</option>
                <option value="×">✖️ Multiplication</option>
                <option value="÷">➗ Division</option>
              </select>
            </div>
          </div>
        </div>

        {/* Statistiques */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          <div className="bg-green-500/80 rounded-2xl p-4 text-center">
            <div className="text-2xl font-bold text-white">{score.correct}</div>
            <div className="text-white/80">Réussies</div>
          </div>
          <div className="bg-blue-500/80 rounded-2xl p-4 text-center">
            <div className="text-2xl font-bold text-white">{accuracyPercentage}%</div>
            <div className="text-white/80">Précision</div>
          </div>
          <div className="bg-orange-500/80 rounded-2xl p-4 text-center">
            <div className="text-2xl font-bold text-white">{streak}</div>
            <div className="text-white/80">Suite</div>
          </div>
          <div className="bg-purple-500/80 rounded-2xl p-4 text-center">
            <div className="text-2xl font-bold text-white">{formatTime(sessionTime)}</div>
            <div className="text-white/80">Temps</div>
          </div>
        </div>

        {/* Exercice actuel */}
        {currentExercise && (
          <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 text-center border-white/30">
            <h3 className="text-2xl font-bold text-white mb-6">
              🧠 Exercice #{score.total + 1}
            </h3>

            <div className="text-6xl font-bold text-white mb-8">
              {currentExercise.num1} {currentExercise.operation} {currentExercise.num2} = ?
            </div>

            {!showResult ? (
              <div className="space-y-6">
                <input
                  type="number"
                  value={currentExercise.userAnswer}
                  onChange={(e) => setCurrentExercise(prev => 
                    prev ? { ...prev, userAnswer: e.target.value } : null
                  )}
                  className="text-4xl text-center p-4 rounded-xl bg-white/20 text-white border-white/30 w-48"
                  placeholder="?"
                  autoFocus
                />

                <div>
                  <button
                    onClick={checkAnswer}
                    disabled={!currentExercise.userAnswer}
                    className="bg-green-500 hover:bg-green-600 text-white px-8 py-4 rounded-xl font-bold text-lg transition-all disabled:opacity-50"
                  >
                    ✅ Vérifier
                  </button>
                </div>
              </div>
            ) : (
              <div className="space-y-4">
                {currentExercise.isCorrect ? (
                  <div className="bg-green-500/80 rounded-2xl p-6">
                    <div className="text-4xl mb-2">🎉</div>
                    <div className="text-2xl font-bold text-white">Bravo !</div>
                    <div className="text-white/80">Réponse correcte : {currentExercise.correctAnswer}</div>
                  </div>
                ) : (
                  <div className="bg-red-500/80 rounded-2xl p-6">
                    <div className="text-4xl mb-2">🤔</div>
                    <div className="text-2xl font-bold text-white">Pas tout à fait...</div>
                    <div className="text-white/80">
                      Ta réponse : {currentExercise.userAnswer} | 
                      Bonne réponse : {currentExercise.correctAnswer}
                    </div>
                  </div>
                )}
                
                <div className="text-white/60">
                  Nouvel exercice dans 2 secondes...
                </div>
              </div>
            )}
          </div>
        )}

        {/* Badges et encouragements */}
        <div className="mt-8 grid grid-cols-1 md:grid-cols-2 gap-4">
          {streak >= 5 && (
            <div className="bg-yellow-500/80 rounded-2xl p-6 text-center">
              <div className="text-3xl mb-2">🔥</div>
              <div className="text-xl font-bold text-white">
                En feu ! {streak} bonnes réponses !
              </div>
            </div>
          )}
          
          {accuracyPercentage >= 90 && score.total >= 5 && (
            <div className="bg-pink-500/80 rounded-2xl p-6 text-center">
              <div className="text-3xl mb-2">🏆</div>
              <div className="text-xl font-bold text-white">
                Expert ! {accuracyPercentage}% de précision !
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
