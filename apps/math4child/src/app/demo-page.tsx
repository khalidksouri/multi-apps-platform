'use client'

import React, { useState, useEffect } from 'react'
import { Check, X, ArrowLeft, Calculator, Star, Target, Trophy } from 'lucide-react'

type SupportedLanguage = 'fr' | 'en' | 'es' | 'de' | 'ar'

const translations: Record<SupportedLanguage, any> = {
  fr: {
    calculator: {
      title: 'Calculatrice Interactive',
      placeholder: 'Tapez votre réponse...',
      validate: 'Vérifier',
      newProblem: 'Nouveau Problème',
      correct: 'Bravo ! Réponse correcte !',
      incorrect: 'Oops ! Essayez encore.',
      tryAgain: 'Réessayer',
      score: 'Score',
      streak: 'Série',
      level: 'Niveau'
    }
  },
  en: {
    calculator: {
      title: 'Interactive Calculator',
      placeholder: 'Type your answer...',
      validate: 'Check',
      newProblem: 'New Problem',
      correct: 'Great! Correct answer!',
      incorrect: 'Oops! Try again.',
      tryAgain: 'Try Again',
      score: 'Score',
      streak: 'Streak',
      level: 'Level'
    }
  },
  es: {
    calculator: {
      title: 'Calculadora Interactiva',
      placeholder: 'Escribe tu respuesta...',
      validate: 'Verificar',
      newProblem: 'Nuevo Problema',
      correct: '¡Genial! ¡Respuesta correcta!',
      incorrect: '¡Ups! Inténtalo de nuevo.',
      tryAgain: 'Intentar de Nuevo',
      score: 'Puntuación',
      streak: 'Racha',
      level: 'Nivel'
    }
  },
  de: {
    calculator: {
      title: 'Interaktiver Rechner',
      placeholder: 'Geben Sie Ihre Antwort ein...',
      validate: 'Überprüfen',
      newProblem: 'Neues Problem',
      correct: 'Großartig! Richtige Antwort!',
      incorrect: 'Ups! Versuchen Sie es nochmal.',
      tryAgain: 'Nochmal Versuchen',
      score: 'Punkte',
      streak: 'Serie',
      level: 'Level'
    }
  },
  ar: {
    calculator: {
      title: 'حاسبة تفاعلية',
      placeholder: 'اكتب إجابتك...',
      validate: 'تحقق',
      newProblem: 'مسألة جديدة',
      correct: 'رائع! إجابة صحيحة!',
      incorrect: 'أوه! حاول مرة أخرى.',
      tryAgain: 'حاول مرة أخرى',
      score: 'النقاط',
      streak: 'السلسلة',
      level: 'المستوى'
    }
  }
}

interface DemoPageProps {
  onBack: () => void
  language: SupportedLanguage
}

export default function DemoPage({ onBack, language }: DemoPageProps) {
  const [problem, setProblem] = useState({ num1: 5, num2: 3, operation: '+' })
  const [userAnswer, setUserAnswer] = useState('')
  const [feedback, setFeedback] = useState<{ type: 'correct' | 'incorrect' | null, message: string }>({ type: null, message: '' })
  const [score, setScore] = useState(0)
  const [streak, setStreak] = useState(0)
  const [level, setLevel] = useState(1)
  const [attempts, setAttempts] = useState(0)
  
  const t = translations[language] || translations['fr']

  const generateProblem = () => {
    const operations = ['+', '-', '×', '÷']
    const op = operations[Math.floor(Math.random() * operations.length)]
    
    // Adaptation du niveau de difficulté selon le level
    const maxNum = Math.min(10 + (level * 5), 50)
    let num1 = Math.floor(Math.random() * maxNum) + 1
    let num2 = Math.floor(Math.random() * (maxNum / 2)) + 1
    
    // Assurer que la division donne un résultat entier
    if (op === '÷') {
      num1 = num2 * Math.floor(Math.random() * 10 + 1)
    }
    
    // Assurer que la soustraction ne donne pas de résultat négatif
    if (op === '-' && num2 > num1) {
      [num1, num2] = [num2, num1]
    }
    
    setProblem({ num1, num2, operation: op })
    setUserAnswer('')
    setFeedback({ type: null, message: '' })
    setAttempts(0)
  }

  const getCorrectAnswer = () => {
    switch (problem.operation) {
      case '+': return problem.num1 + problem.num2
      case '-': return problem.num1 - problem.num2
      case '×': return problem.num1 * problem.num2
      case '÷': return problem.num1 / problem.num2
      default: return 0
    }
  }

  const validateAnswer = () => {
    const correct = getCorrectAnswer()
    const userNum = parseFloat(userAnswer)
    
    if (isNaN(userNum)) {
      setFeedback({
        type: 'incorrect',
        message: 'Veuillez entrer un nombre valide.'
      })
      return
    }

    if (userNum === correct) {
      // Réponse correcte
      const newScore = score + (10 * level) + (streak * 2)
      const newStreak = streak + 1
      
      setScore(newScore)
      setStreak(newStreak)
      setFeedback({
        type: 'correct',
        message: `${t.calculator.correct} +${(10 * level) + (streak * 2)} points!`
      })
      
      // Augmentation de niveau tous les 5 bonnes réponses consécutives
      if (newStreak % 5 === 0) {
        setLevel(level + 1)
      }
      
      // Générer automatiquement un nouveau problème après 2 secondes
      setTimeout(() => {
        generateProblem()
      }, 2000)
      
    } else {
      // Réponse incorrecte
      const newAttempts = attempts + 1
      setAttempts(newAttempts)
      setStreak(0) // Reset de la série
      
      setFeedback({
        type: 'incorrect',
        message: `${t.calculator.incorrect} La bonne réponse est ${correct}.${newAttempts < 2 ? ' ' + t.calculator.tryAgain : ''}`
      })
      
      // Si c'est la deuxième tentative, montrer la réponse et passer au suivant
      if (newAttempts >= 2) {
        setTimeout(() => {
          generateProblem()
        }, 3000)
      }
    }
  }

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && userAnswer.trim() !== '') {
      validateAnswer()
    }
  }

  // Générer le premier problème au montage
  useEffect(() => {
    generateProblem()
  }, [])

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 via-blue-50 to-purple-50 p-4 md:p-8">
      <div className="max-w-4xl mx-auto">
        {/* Header avec bouton retour */}
        <div className="flex justify-between items-center mb-8">
          <button 
            onClick={onBack} 
            className="flex items-center gap-2 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            Retour
          </button>
          
          {/* Stats en temps réel */}
          <div className="flex gap-4 text-sm">
            <div className="bg-white/80 backdrop-blur px-4 py-2 rounded-xl">
              <span className="font-semibold text-blue-600">{t.calculator.score}:</span> {score}
            </div>
            <div className="bg-white/80 backdrop-blur px-4 py-2 rounded-xl">
              <span className="font-semibold text-green-600">{t.calculator.streak}:</span> {streak}
            </div>
            <div className="bg-white/80 backdrop-blur px-4 py-2 rounded-xl">
              <span className="font-semibold text-purple-600">{t.calculator.level}:</span> {level}
            </div>
          </div>
        </div>
        
        <div className="text-center">
          <h1 className="text-3xl md:text-4xl font-bold text-gray-800 mb-8 flex items-center justify-center gap-3">
            <div className="p-3 bg-gradient-to-r from-blue-500 to-purple-600 rounded-2xl">
              <Calculator className="w-8 h-8 text-white" />
            </div>
            {t.calculator.title}
          </h1>
          
          {/* Zone de calcul principale */}
          <div className="bg-white/90 backdrop-blur-lg rounded-3xl shadow-2xl p-8 md:p-12 mb-8 max-w-2xl mx-auto">
            
            {/* Problème mathématique */}
            <div className="text-5xl md:text-6xl font-bold text-gray-800 mb-8 font-mono">
              {problem.num1} {problem.operation} {problem.num2} = ?
            </div>
            
            {/* Zone de feedback */}
            {feedback.type && (
              <div className={`mb-6 p-4 rounded-2xl font-semibold text-lg flex items-center justify-center gap-3 ${
                feedback.type === 'correct' 
                  ? 'bg-green-100 text-green-700 border-2 border-green-300' 
                  : 'bg-red-100 text-red-700 border-2 border-red-300'
              }`}>
                {feedback.type === 'correct' ? (
                  <Check className="w-6 h-6" />
                ) : (
                  <X className="w-6 h-6" />
                )}
                {feedback.message}
              </div>
            )}
            
            {/* Input libre SANS spinner - CORRECTION PRINCIPALE */}
            <div className="mb-8">
              <input
                type="text"
                inputMode="numeric"
                pattern="[0-9]*"
                value={userAnswer}
                onChange={(e) => {
                  // Permettre seulement les chiffres et le point décimal
                  const value = e.target.value.replace(/[^0-9.-]/g, '')
                  setUserAnswer(value)
                }}
                onKeyPress={handleKeyPress}
                placeholder={t.calculator.placeholder}
                className="w-full max-w-sm mx-auto text-3xl font-bold text-center p-4 border-2 border-gray-300 rounded-2xl focus:border-blue-500 focus:outline-none transition-colors bg-white"
                style={{ 
                  // IMPORTANT: Supprimer les spinner sur Chrome/Safari/Firefox
                  MozAppearance: 'textfield',
                  WebkitAppearance: 'none',
                }}
                disabled={feedback.type === 'correct'}
                autoComplete="off"
              />
              
              {/* Styles CSS inline pour supprimer complètement les spinners */}
              <style jsx>{`
                input::-webkit-outer-spin-button,
                input::-webkit-inner-spin-button {
                  -webkit-appearance: none;
                  margin: 0;
                  display: none;
                }
                
                input[type=number] {
                  -moz-appearance: textfield;
                  appearance: textfield;
                }
              `}</style>
            </div>
            
            {/* Boutons d'action */}
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <button
                onClick={validateAnswer}
                disabled={userAnswer.trim() === '' || feedback.type === 'correct'}
                className={`px-8 py-4 rounded-2xl font-bold text-white transition-all duration-300 transform hover:scale-105 ${
                  userAnswer.trim() === '' || feedback.type === 'correct'
                    ? 'bg-gray-400 cursor-not-allowed'
                    : 'bg-gradient-to-r from-blue-500 to-purple-600 hover:from-purple-600 hover:to-blue-500 shadow-xl'
                }`}
              >
                {t.calculator.validate}
              </button>
              
              <button
                onClick={generateProblem}
                className="px-8 py-4 bg-gradient-to-r from-green-500 to-green-600 text-white rounded-2xl font-bold hover:from-green-600 hover:to-green-700 transition-all duration-300 transform hover:scale-105 shadow-xl"
              >
                🎲 {t.calculator.newProblem}
              </button>
            </div>
          </div>
          
          {/* Zone de conseils et encouragements */}
          <div className="bg-gradient-to-r from-blue-50 to-purple-50 rounded-2xl p-6 max-w-2xl mx-auto">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
              <div className="flex items-center gap-2">
                <Star className="w-4 h-4 text-yellow-500" />
                <span>Série de {streak} bonnes réponses</span>
              </div>
              <div className="flex items-center gap-2">
                <Target className="w-4 h-4 text-green-500" />
                <span>Niveau {level} - Difficulté adaptive</span>
              </div>
              <div className="flex items-center gap-2">
                <Trophy className="w-4 h-4 text-purple-500" />
                <span>Score total: {score} points</span>
              </div>
            </div>
          </div>

          {/* Instructions pour l'utilisateur */}
          <div className="mt-6 p-4 bg-blue-50 rounded-xl text-blue-800 max-w-lg mx-auto">
            <div className="flex items-center gap-2 mb-2">
              <Calculator className="w-5 h-5" />
              <span className="font-semibold">Instructions :</span>
            </div>
            <ul className="text-sm text-left space-y-1">
              <li>• Tapez votre réponse directement dans le champ</li>
              <li>• Accepte les nombres entiers et décimaux</li>
              <li>• Appuyez sur Entrée ou cliquez sur "Vérifier"</li>
              <li>• Pas de limite : tapez 54, 127, 999...</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}
