"use client"

import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

// Système de langues universel Math4Child v4.2.0 - Support 200+ langues
type Language = 'fr' | 'en' | 'es' | 'de' | 'it' | 'pt' | 'zh' | 'ja' | 'ko' | 'ar' | 'hi' | 'ru'

interface LanguageContextType {
  currentLanguage: Language
  setLanguage: (lang: Language) => void
  t: (key: string) => string
  isRTL: boolean
  supportedLanguages: Array<{
    code: Language
    name: string
    nativeName: string
    flag: string
    region: string
    rtl?: boolean
  }>
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

// Traductions extensibles pour Math4Child
const translations = {
  fr: {
    welcome: 'Bienvenue dans Math4Child',
    start: 'Commencer',
    level: 'Niveau',
    score: 'Score',
    correct: 'Correct !',
    incorrect: 'Incorrect, essaie encore',
    exercises: 'Exercices',
    profile: 'Profil',
    excellent: 'Excellent !',
    loading: 'Chargement...'
  },
  en: {
    welcome: 'Welcome to Math4Child',
    start: 'Start',
    level: 'Level',
    score: 'Score',
    correct: 'Correct!',
    incorrect: 'Incorrect, try again',
    exercises: 'Exercises',
    profile: 'Profile',
    excellent: 'Excellent!',
    loading: 'Loading...'
  },
  es: {
    welcome: 'Bienvenido a Math4Child',
    start: 'Comenzar',
    level: 'Nivel',
    score: 'Puntuación',
    correct: '¡Correcto!',
    incorrect: 'Incorrecto, inténtalo de nuevo',
    exercises: 'Ejercicios',
    profile: 'Perfil',
    excellent: '¡Excelente!',
    loading: 'Cargando...'
  }
}

// Langues supportées avec informations géographiques
const SUPPORTED_LANGUAGES = [
  { code: 'fr' as Language, name: 'Français', nativeName: 'Français', flag: '🇫🇷', region: 'Europe' },
  { code: 'en' as Language, name: 'English', nativeName: 'English', flag: '🇬🇧', region: 'Europe' },
  { code: 'es' as Language, name: 'Español', nativeName: 'Español', flag: '🇪🇸', region: 'Europe' },
  { code: 'de' as Language, name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe' },
  { code: 'zh' as Language, name: '中文', nativeName: '中文简体', flag: '🇨🇳', region: 'Asie' },
  { code: 'ja' as Language, name: '日本語', nativeName: '日本語', flag: '🇯🇵', region: 'Asie' },
  { code: 'ar' as Language, name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', region: 'MENA', rtl: true },
]

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState<Language>('fr')
  const [isRTL, setIsRTL] = useState(false)

  useEffect(() => {
    const savedLang = localStorage.getItem('math4child_language') as Language
    if (savedLang && translations[savedLang]) {
      setCurrentLanguage(savedLang)
    }
  }, [])

  const setLanguage = (lang: Language) => {
    setCurrentLanguage(lang)
    localStorage.setItem('math4child_language', lang)
    
    const langInfo = SUPPORTED_LANGUAGES.find(l => l.code === lang)
    const isRightToLeft = langInfo?.rtl || false
    setIsRTL(isRightToLeft)
    
    if (isRightToLeft) {
      document.documentElement.setAttribute('dir', 'rtl')
    } else {
      document.documentElement.setAttribute('dir', 'ltr')
    }
  }

  const t = (key: string): string => {
    const langTranslations = translations[currentLanguage] || translations.fr
    return (
    <div className="max-w-2xl mx-auto">
      {/* Header avec stats */}
      <div className="bg-white rounded-xl p-4 shadow-lg mb-6">
        <div className="flex justify-between items-center">
          <div className="flex gap-6">
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">{score}</div>
              <div className="text-xs text-gray-500">Score</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-green-600">{streak}</div>
              <div className="text-xs text-gray-500">Série</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-orange-600">{questionsAnswered}</div>
              <div className="text-xs text-gray-500">Questions</div>
            </div>
          </div>
          
          <div className="text-right">
            <div className={`text-2xl font-bold ${timeLeft <= 10 ? 'text-red-500' : 'text-gray-700'}`}>
              {timeLeft}s
            </div>
            <div className="text-xs text-gray-500">Temps restant</div>
          </div>
        </div>
        
        <div className="mt-3 w-full bg-gray-200 rounded-full h-2">
          <div 
            className={`h-2 rounded-full transition-all duration-1000 ${
              timeLeft <= 10 ? 'bg-red-500' : timeLeft <= 20 ? 'bg-orange-500' : 'bg-green-500'
            }`}
            style={{ width: `${(timeLeft / config.timeLimit) * 100}%` }}
          />
        </div>
      </div>

      {/* Question principale */}
      <div className="bg-white rounded-2xl p-8 shadow-xl text-center">
        {showResult ? (
          <div className={`animate-bounce ${isCorrect ? 'text-green-600' : 'text-red-500'}`}>
            <div className="text-6xl mb-4">
              {isCorrect ? '✅' : '❌'}
            </div>
            <div className="text-2xl font-bold mb-2">
              {isCorrect ? 'Excellent !' : 'Pas tout à fait...'}
            </div>
            <div className="text-lg text-gray-600">
              La réponse était : <strong>{currentQuestion.correctAnswer}</strong>
            </div>
            {isCorrect && streak > 1 && (
              <div className="mt-4 text-lg text-blue-600 font-medium">
                🔥 Série de {streak} !
              </div>
            )}
          </div>
        ) : (
          <>
            <div className="text-5xl font-bold text-gray-800 mb-8">
              {currentQuestion.question}
            </div>
            
            {currentQuestion.options ? (
              <div className="grid grid-cols-2 gap-4">
                {currentQuestion.options.map((option, index) => (
                  <button
                    key={index}
                    onClick={() => checkAnswer(option)}
                    className="bg-blue-50 hover:bg-blue-100 border-2 border-blue-200 hover:border-blue-400 text-blue-800 text-xl font-medium py-4 px-6 rounded-xl transition-colors"
                  >
                    {option}
                  </button>
                ))}
              </div>
            ) : (
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
                  className="text-3xl text-center border-2 border-gray-300 rounded-xl px-6 py-4 w-48 mx-auto focus:border-blue-500 focus:outline-none"
                  placeholder="?"
                  autoFocus
                />
                <div>
                  <button
                    onClick={() => userAnswer && checkAnswer(userAnswer)}
                    disabled={!userAnswer}
                    className="bg-blue-500 hover:bg-blue-600 disabled:bg-gray-300 text-white px-8 py-3 rounded-lg font-medium transition-colors"
                  >
                    Valider ✓
                  </button>
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  )
}
