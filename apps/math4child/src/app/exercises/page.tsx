'use client'

import { useState, useEffect } from 'react'
import { useTranslation } from '@/hooks/useTranslation'
import { LanguageSelector } from '@/components/language/LanguageSelector'
import { Calculator, Plus, Minus, X, Divide, Play, Trophy, Target, RotateCcw, Home } from 'lucide-react'
import Link from 'next/link'

interface Exercise {
  id: string
  type: 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed'
  question: string
  answer: number
  options: number[]
  level: number
}

interface UserProgress {
  level: number
  correctAnswers: number
  totalQuestions: number
  unlockedLevels: number[]
}

export default function ExercisesPage() {
  const { t, isRTL } = useTranslation()
  const [selectedOperation, setSelectedOperation] = useState<string>('addition')
  const [currentLevel, setCurrentLevel] = useState<number>(1)
  const [score, setScore] = useState<number>(0)
  const [userProgress, setUserProgress] = useState<UserProgress>({
    level: 1,
    correctAnswers: 0,
    totalQuestions: 0,
    unlockedLevels: [1]
  })
  const [showResult, setShowResult] = useState<{ show: boolean; correct: boolean; message: string }>({
    show: false,
    correct: false,
    message: ''
  })

  // Charger la progression sauvegardée
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('math4child-progress')
      if (saved) {
        try {
          const progress = JSON.parse(saved)
          setUserProgress(progress)
          setCurrentLevel(progress.level)
        } catch (error) {
          console.error('Erreur chargement progression:', error)
        }
      }
    }
  }, [])

  // Sauvegarder la progression
  const saveProgress = (progress: UserProgress) => {
    if (typeof window !== 'undefined') {
      localStorage.setItem('math4child-progress', JSON.stringify(progress))
    }
  }

  // Générer un exercice selon le niveau et l'opération
  const generateExercise = (operation: string, level: number): Exercise => {
    const maxNum = Math.min(10 + (level * 10), 100)
    let a = Math.floor(Math.random() * maxNum) + 1
    let b = Math.floor(Math.random() * maxNum) + 1
    
    // S'assurer que a >= b pour éviter les nombres négatifs
    if (operation === 'subtraction' && a < b) {
      [a, b] = [b, a]
    }
    
    let question: string
    let answer: number
    
    if (operation === 'mixed') {
      const operations = ['addition', 'subtraction', 'multiplication', 'division']
      operation = operations[Math.floor(Math.random() * operations.length)]
    }
    
    switch (operation) {
      case 'addition':
        question = `${a} + ${b} = ?`
        answer = a + b
        break
      case 'subtraction':
        question = `${a} - ${b} = ?`
        answer = a - b
        break
      case 'multiplication':
        a = Math.floor(Math.random() * Math.min(12, level + 2)) + 1
        b = Math.floor(Math.random() * Math.min(12, level + 2)) + 1
        question = `${a} × ${b} = ?`
        answer = a * b
        break
      case 'division':
        answer = Math.floor(Math.random() * 12) + 1
        const multiplier = Math.floor(Math.random() * 12) + 1
        const dividend = answer * multiplier
        question = `${dividend} ÷ ${multiplier} = ?`
        break
      default:
        question = `${a} + ${b} = ?`
        answer = a + b
    }
    
    // Générer des options de réponse
    const options = [answer]
    while (options.length < 4) {
      let wrongAnswer: number
      if (answer <= 20) {
        wrongAnswer = Math.max(0, answer + Math.floor(Math.random() * 10) - 5)
      } else {
        wrongAnswer = Math.max(0, answer + Math.floor(Math.random() * 20) - 10)
      }
      
      if (wrongAnswer !== answer && !options.includes(wrongAnswer)) {
        options.push(wrongAnswer)
      }
    }
    
    return {
      id: Date.now().toString(),
      type: operation as any,
      question,
      answer,
      options: options.sort(() => Math.random() - 0.5),
      level
    }
  }

  const [currentExercise, setCurrentExercise] = useState<Exercise>(
    generateExercise(selectedOperation, currentLevel)
  )

  const handleOperationChange = (operation: string) => {
    setSelectedOperation(operation)
    setCurrentExercise(generateExercise(operation, currentLevel))
  }

  const handleAnswer = (selectedAnswer: number) => {
    const isCorrect = selectedAnswer === currentExercise.answer
    const newProgress = { ...userProgress }
    
    newProgress.totalQuestions += 1
    
    if (isCorrect) {
      setScore(score + 10)
      newProgress.correctAnswers += 1
      
      setShowResult({
        show: true,
        correct: true,
        message: t('correct')
      })
      
      // Vérifier si le niveau est validé (100 bonnes réponses)
      if (newProgress.correctAnswers >= 100 && !newProgress.unlockedLevels.includes(currentLevel + 1)) {
        newProgress.level = currentLevel + 1
        newProgress.unlockedLevels.push(currentLevel + 1)
        newProgress.correctAnswers = 0 // Reset pour le nouveau niveau
        
        setShowResult({
          show: true,
          correct: true,
          message: `${t('levelComplete')} Niveau ${currentLevel + 1} débloqué !`
        })
      }
    } else {
      setShowResult({
        show: true,
        correct: false,
        message: `${t('incorrect')} La réponse était ${currentExercise.answer}`
      })
    }
    
    setUserProgress(newProgress)
    saveProgress(newProgress)
    
    // Génération du prochain exercice après 2 secondes
    setTimeout(() => {
      setShowResult({ show: false, correct: false, message: '' })
      setCurrentExercise(generateExercise(selectedOperation, currentLevel))
    }, 2000)
  }

  const handleLevelChange = (level: number) => {
    if (userProgress.unlockedLevels.includes(level)) {
      setCurrentLevel(level)
      setCurrentExercise(generateExercise(selectedOperation, level))
    }
  }

  const getOperationIcon = (operation: string) => {
    switch (operation) {
      case 'addition': return <Plus className="w-5 h-5" />
      case 'subtraction': return <Minus className="w-5 h-5" />
      case 'multiplication': return <X className="w-5 h-5" />
      case 'division': return <Divide className="w-5 h-5" />
      case 'mixed': return <Target className="w-5 h-5" />
      default: return <Calculator className="w-5 h-5" />
    }
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-green-400 via-blue-500 to-purple-500 ${isRTL ? 'rtl' : 'ltr'}`}>
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <header className="flex justify-between items-center mb-8">
          <div className="flex items-center space-x-3">
            <Link href="/" className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm hover:bg-white/30 transition-colors">
              <Home className="w-6 h-6 text-white" />
            </Link>
            <div>
              <h1 className="text-3xl font-bold text-white">{t('exercises')}</h1>
              <p className="text-white/80">Niveau {currentLevel} • {userProgress.correctAnswers}/100 bonnes réponses</p>
            </div>
          </div>
          
          <div className="flex items-center space-x-4">
            <div className="bg-white/20 backdrop-blur-sm rounded-lg px-4 py-2 text-white">
              <div className="flex items-center space-x-2">
                <Trophy className="w-4 h-4" />
                <span>{t('score')}: {score}</span>
              </div>
            </div>
            <LanguageSelector />
          </div>
        </header>

        {/* Sélection de niveau */}
        <section className="mb-6">
          <h2 className="text-lg font-bold text-white mb-3">Niveaux :</h2>
          <div className="flex space-x-2 overflow-x-auto pb-2">
            {[1, 2, 3, 4, 5].map((level) => (
              <button
                key={level}
                onClick={() => handleLevelChange(level)}
                disabled={!userProgress.unlockedLevels.includes(level)}
                className={`
                  flex-shrink-0 px-4 py-2 rounded-lg font-semibold transition-all duration-200
                  ${currentLevel === level
                    ? 'bg-white text-purple-600 shadow-lg'
                    : userProgress.unlockedLevels.includes(level)
                      ? 'bg-white/20 text-white hover:bg-white/30'
                      : 'bg-gray-600 text-gray-400 cursor-not-allowed'
                  }
                `}
              >
                {level}
                {!userProgress.unlockedLevels.includes(level) && ' 🔒'}
              </button>
            ))}
          </div>
        </section>

        {/* Sélection d'opération */}
        <section className="mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Choisissez votre opération :</h2>
          <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
            {[
              { key: 'addition', label: t('addition') },
              { key: 'subtraction', label: t('subtraction') },
              { key: 'multiplication', label: t('multiplication') },
              { key: 'division', label: t('division') },
              { key: 'mixed', label: 'Mixte' }
            ].map((operation) => (
              <button
                key={operation.key}
                onClick={() => handleOperationChange(operation.key)}
                className={`
                  flex items-center justify-center space-x-2 p-4 rounded-xl font-semibold transition-all duration-200
                  ${selectedOperation === operation.key
                    ? 'bg-white text-purple-600 shadow-lg scale-105'
                    : 'bg-white/20 text-white hover:bg-white/30'
                  }
                `}
              >
                {getOperationIcon(operation.key)}
                <span>{operation.label}</span>
              </button>
            ))}
          </div>
        </section>

        {/* Exercice actuel */}
        <main className="max-w-2xl mx-auto">
          <div className="bg-white/10 backdrop-blur-sm rounded-3xl p-8 text-center relative overflow-hidden">
            {/* Résultat overlay */}
            {showResult.show && (
              <div className={`absolute inset-0 flex items-center justify-center ${
                showResult.correct ? 'bg-green-500/90' : 'bg-red-500/90'
              } backdrop-blur-sm z-10 rounded-3xl`}>
                <div className="text-center text-white">
                  <div className="text-6xl mb-4">
                    {showResult.correct ? '🎉' : '❌'}
                  </div>
                  <h3 className="text-2xl font-bold mb-2">{showResult.message}</h3>
                </div>
              </div>
            )}

            <div className="mb-6">
              <div className="inline-flex items-center bg-blue-500/20 text-blue-100 px-4 py-2 rounded-full text-sm font-medium mb-4">
                <Target className="w-4 h-4 mr-2" />
                {t(selectedOperation as any)} - Niveau {currentLevel}
              </div>
              <h3 className="text-4xl font-bold text-white mb-8">
                {currentExercise.question}
              </h3>
            </div>

            {/* Options de réponse */}
            <div className="grid grid-cols-2 gap-4 mb-8">
              {currentExercise.options.map((option, index) => (
                <button
                  key={index}
                  onClick={() => handleAnswer(option)}
                  disabled={showResult.show}
                  className="bg-white/20 hover:bg-white/30 text-white text-2xl font-bold py-6 rounded-xl transition-all duration-200 hover:scale-105 border border-white/30 disabled:opacity-50"
                >
                  {option}
                </button>
              ))}
            </div>

            {/* Bouton nouveau exercice */}
            <button
              onClick={() => setCurrentExercise(generateExercise(selectedOperation, currentLevel))}
              className="flex items-center justify-center space-x-2 bg-green-500 hover:bg-green-600 text-white px-6 py-3 rounded-full font-semibold transition-colors mx-auto"
            >
              <RotateCcw className="w-4 h-4" />
              <span>Nouvel exercice</span>
            </button>
          </div>
        </main>

        {/* Stats */}
        <footer className="mt-12 text-center">
          <div className="inline-flex items-center space-x-6 bg-white/10 backdrop-blur-sm rounded-full px-6 py-3">
            <div className="text-white">
              <span className="font-medium">Score: </span>
              <span className="text-green-300 font-bold">{score}</span>
            </div>
            <div className="text-white">
              <span className="font-medium">Niveau: </span>
              <span className="text-blue-300 font-bold">{currentLevel}</span>
            </div>
            <div className="text-white">
              <span className="font-medium">Progression: </span>
              <span className="text-purple-300 font-bold">{userProgress.correctAnswers}/100</span>
            </div>
          </div>
        </footer>
      </div>
    </div>
  )
}
