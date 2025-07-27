'use client'

import { useState, useEffect } from 'react'
import { ArrowLeft, Check, X, RotateCcw, Trophy, Star } from 'lucide-react'
import { useLanguage } from '@/contexts/LanguageContext'

interface Question {
  id: number
  operation: '+' | '-' | '*' | '/'
  operand1: number
  operand2: number
  answer: number
  userAnswer?: number
  isCorrect?: boolean
}

interface MathGameProps {
  onBack: () => void
}

export default function MathGame({ onBack }: MathGameProps) {
  const [currentQuestion, setCurrentQuestion] = useState<Question | null>(null)
  const [userInput, setUserInput] = useState('')
  const [score, setScore] = useState(0)
  const [streak, setStreak] = useState(0)
  const [questionsAnswered, setQuestionsAnswered] = useState(0)
  const [gameLevel, setGameLevel] = useState(1)
  const [showResult, setShowResult] = useState(false)
  const [gameHistory, setGameHistory] = useState<Question[]>([])
  
  const languageContext = useLanguage()
  const currentLanguage = languageContext?.currentLanguage || { code: 'fr', rtl: false }
  
  // Génération des questions selon le niveau
  const generateQuestion = (level: number): Question => {
    const operations: ('+' | '-' | '*' | '/')[] = ['+', '-', '*', '/']
    const operation = operations[Math.floor(Math.random() * (level >= 3 ? 4 : 2))]
    
    let operand1: number, operand2: number, answer: number
    
    switch (operation) {
      case '+':
        operand1 = Math.floor(Math.random() * (level * 10)) + 1
        operand2 = Math.floor(Math.random() * (level * 10)) + 1
        answer = operand1 + operand2
        break
      case '-':
        operand1 = Math.floor(Math.random() * (level * 10)) + 10
        operand2 = Math.floor(Math.random() * operand1) + 1
        answer = operand1 - operand2
        break
      case '*':
        operand1 = Math.floor(Math.random() * (level * 2)) + 2
        operand2 = Math.floor(Math.random() * (level * 2)) + 2
        answer = operand1 * operand2
        break
      case '/':
        answer = Math.floor(Math.random() * (level * 5)) + 1
        operand2 = Math.floor(Math.random() * level) + 2
        operand1 = answer * operand2
        break
      default:
        operand1 = 1
        operand2 = 1
        answer = 2
    }
    
    return {
      id: Date.now(),
      operation,
      operand1,
      operand2,
      answer
    }
  }
  
  // Initialiser le jeu
  useEffect(() => {
    setCurrentQuestion(generateQuestion(gameLevel))
  }, [gameLevel])
  
  // Soumettre la réponse
  const handleSubmit = () => {
    if (!currentQuestion || userInput === '') return
    
    const userAnswer = parseInt(userInput)
    const isCorrect = userAnswer === currentQuestion.answer
    
    const updatedQuestion: Question = {
      ...currentQuestion,
      userAnswer,
      isCorrect
    }
    
    setGameHistory(prev => [...prev, updatedQuestion])
    
    if (isCorrect) {
      setScore(prev => prev + (streak + 1) * 10)
      setStreak(prev => prev + 1)
      
      // Haptic feedback sur mobile natif (sécurisé)
      try {
        if (typeof window !== 'undefined' && (window as any).Capacitor?.Plugins?.Haptics) {
          (window as any).Capacitor.Plugins.Haptics.impact({ style: 'light' })
        }
      } catch (error) {
        // Ignore haptic errors
      }
    } else {
      setStreak(0)
    }
    
    setQuestionsAnswered(prev => prev + 1)
    setShowResult(true)
    
    // Passage au niveau suivant
    if (questionsAnswered > 0 && (questionsAnswered + 1) % 5 === 0 && streak >= 3) {
      setGameLevel(prev => Math.min(prev + 1, 5))
    }
    
    // Prochaine question après 2 secondes
    setTimeout(() => {
      setShowResult(false)
      setUserInput('')
      setCurrentQuestion(generateQuestion(gameLevel))
    }, 2000)
  }
  
  // Redémarrer le jeu
  const handleRestart = () => {
    setCurrentQuestion(generateQuestion(1))
    setUserInput('')
    setScore(0)
    setStreak(0)
    setQuestionsAnswered(0)
    setGameLevel(1)
    setShowResult(false)
    setGameHistory([])
  }
  
  if (!currentQuestion) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-green-500 to-blue-600 flex items-center justify-center">
        <div className="text-white text-xl">Chargement...</div>
      </div>
    )
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-green-500 to-blue-600 ${currentLanguage?.rtl ? 'rtl' : 'ltr'}`}>
      {/* Header */}
      <div className="bg-white/10 backdrop-blur-md border-b border-white/20 p-4">
        <div className="flex items-center justify-between max-w-4xl mx-auto">
          <button
            onClick={onBack}
            className="flex items-center space-x-2 text-white hover:text-white/80 transition-colors"
          >
            <ArrowLeft size={24} />
            <span>Retour</span>
          </button>
          
          <div className="flex items-center space-x-6 text-white">
            <div className="flex items-center space-x-2">
              <Star size={20} />
              <span className="font-bold">{score}</span>
            </div>
            
            <div className="flex items-center space-x-2">
              <Trophy size={20} />
              <span className="font-bold">{streak}</span>
            </div>
            
            <div className="bg-white/20 px-3 py-1 rounded-full">
              Niveau {gameLevel}
            </div>
          </div>
        </div>
      </div>

      {/* Jeu principal */}
      <div className="flex items-center justify-center min-h-[calc(100vh-80px)] p-4">
        <div className="bg-white/20 backdrop-blur-md rounded-2xl p-8 max-w-md w-full">
          
          {!showResult ? (
            <>
              {/* Question */}
              <div className="text-center mb-8">
                <div className="text-6xl font-bold text-white mb-4" data-testid="math-question">
                  {currentQuestion.operand1} {currentQuestion.operation} {currentQuestion.operand2} = ?
                </div>
              </div>

              {/* Input */}
              <div className="mb-6">
                <input
                  type="number"
                  value={userInput}
                  onChange={(e) => setUserInput(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && handleSubmit()}
                  className="w-full px-4 py-3 text-2xl text-center border-2 border-white/30 rounded-lg bg-white/10 text-white placeholder-white/60 focus:outline-none focus:border-white/60"
                  placeholder="Votre réponse"
                  data-testid="answer-input"
                  autoFocus
                />
              </div>

              {/* Boutons */}
              <div className="flex space-x-4">
                <button
                  onClick={handleSubmit}
                  disabled={userInput === ''}
                  className="flex-1 bg-green-500 hover:bg-green-600 disabled:bg-gray-400 text-white py-3 rounded-lg font-semibold transition-colors"
                  data-testid="submit-answer"
                >
                  Valider
                </button>
                
                <button
                  onClick={handleRestart}
                  className="bg-blue-500 hover:bg-blue-600 text-white p-3 rounded-lg transition-colors"
                  data-testid="restart-game"
                >
                  <RotateCcw size={20} />
                </button>
              </div>
            </>
          ) : (
            /* Résultat */
            <div className="text-center">
              <div className={`text-6xl mb-4 ${currentQuestion.isCorrect ? 'text-green-400' : 'text-red-400'}`}>
                {currentQuestion.isCorrect ? <Check size={80} className="mx-auto" /> : <X size={80} className="mx-auto" />}
              </div>
              
              <div className="text-2xl text-white mb-2">
                {currentQuestion.isCorrect ? 'Correct !' : 'Incorrect'}
              </div>
              
              {!currentQuestion.isCorrect && (
                <div className="text-lg text-white/80">
                  La bonne réponse était : {currentQuestion.answer}
                </div>
              )}
            </div>
          )}
          
          {/* Progression */}
          <div className="mt-6 pt-4 border-t border-white/20">
            <div className="flex justify-between text-white/80 text-sm">
              <span>Questions : {questionsAnswered}</span>
              <span>Précision : {questionsAnswered > 0 ? Math.round((gameHistory.filter(q => q.isCorrect).length / questionsAnswered) * 100) : 0}%</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
