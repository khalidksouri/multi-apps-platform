'use client'

import React, { useState, useCallback } from 'react'
import { ChevronDown, Settings, Star, Trophy, Lock, Crown, Globe, Smartphone, Monitor, Check, X, Zap } from 'lucide-react'

// Configuration multilingue complète
const SUPPORTED_LANGUAGES = {
  'fr': { name: 'Français', flag: '🇫🇷', continent: 'Europe', appName: 'Maths4Enfants' },
  'en': { name: 'English', flag: '🇬🇧', continent: 'Europe', appName: 'Math4Kids' },
  'de': { name: 'Deutsch', flag: '🇩🇪', continent: 'Europe', appName: 'Mathe4Kinder' },
  'es': { name: 'Español', flag: '🇪🇸', continent: 'Europe', appName: 'Mates4Niños' },
  'it': { name: 'Italiano', flag: '🇮🇹', continent: 'Europe', appName: 'Math4Bambini' },
  'pt': { name: 'Português', flag: '🇵🇹', continent: 'Europe', appName: 'Mat4Crianças' },
  'ru': { name: 'Русский', flag: '🇷🇺', continent: 'Europe', appName: 'Мат4Дети' },
  'nl': { name: 'Nederlands', flag: '🇳🇱', continent: 'Europe', appName: 'Wisk4Kids' },
  'sv': { name: 'Svenska', flag: '🇸🇪', continent: 'Europe', appName: 'Matte4Barn' },
  'pl': { name: 'Polski', flag: '🇵🇱', continent: 'Europe', appName: 'Mat4Dzieci' },
  'zh': { name: '中文', flag: '🇨🇳', continent: 'Asie', appName: '快乐学数学' },
  'ja': { name: '日本語', flag: '🇯🇵', continent: 'Asie', appName: '算数4キッズ' },
  'ko': { name: '한국어', flag: '🇰🇷', continent: 'Asie', appName: '수학4키즈' },
  'hi': { name: 'हिंदी', flag: '🇮🇳', continent: 'Asie', appName: 'गणित4बच्चे' },
  'ar': { name: 'العربية', flag: '🇸🇦', continent: 'Asie', appName: 'رياضيات4أطفال', rtl: true },
  'th': { name: 'ไทย', flag: '🇹🇭', continent: 'Asie', appName: 'คณิต4เด็ก' },
  'vi': { name: 'Tiếng Việt', flag: '🇻🇳', continent: 'Asie', appName: 'Toán4TrẻEm' },
  'id': { name: 'Bahasa Indonesia', flag: '🇮🇩', continent: 'Asie', appName: 'Matematika4Anak' },
  'ms': { name: 'Bahasa Melayu', flag: '🇲🇾', continent: 'Asie', appName: 'Matematik4Kanak' },
  'he': { name: 'עברית', flag: '🇮🇱', continent: 'Asie', appName: 'מתמטיקה4ילדים', rtl: true },
  'en-us': { name: 'English (US)', flag: '🇺🇸', continent: 'Amériques', appName: 'Math4Kids' },
  'es-mx': { name: 'Español (México)', flag: '🇲🇽', continent: 'Amériques', appName: 'Mates4Niños' },
  'pt-br': { name: 'Português (Brasil)', flag: '🇧🇷', continent: 'Amériques', appName: 'Mat4Crianças' },
  'fr-ca': { name: 'Français (Canada)', flag: '🇨🇦', continent: 'Amériques', appName: 'Maths4Enfants' },
  'sw': { name: 'Kiswahili', flag: '🇰🇪', continent: 'Afrique', appName: 'Hesabu4Watoto' },
  'am': { name: 'አማርኛ', flag: '🇪🇹', continent: 'Afrique', appName: 'ሂሳብ4ህፃናት' },
  'af': { name: 'Afrikaans', flag: '🇿🇦', continent: 'Afrique', appName: 'Wiskunde4Kinders' },
  'en-au': { name: 'English (Australia)', flag: '🇦🇺', continent: 'Océanie', appName: 'Maths4Kids' }
}

// Traductions complètes
const translations = {
  fr: {
    appName: "Maths4Enfants",
    title: "Maths4Enfants",
    subtitle: "Apprends les maths en t'amusant !",
    welcomeMessage: "Bienvenue dans l'aventure mathématique !",
    level: "Niveau", score: "Score", lives: "Vies", streak: "Série",
    answer: "Réponse", check: "Vérifier", next: "Suivant", restart: "Recommencer",
    settings: "Paramètres", language: "Langue", sound: "Son", difficulty: "Difficulté",
    correct: "🎉 Excellent !", incorrect: "❌ Oups ! Essaie encore !",
    excellent: "🌟 Formidable !", tryAgain: "Réessaie !",
    gameOver: "Partie terminée !", finalScore: "Score final", newRecord: "🏆 Nouveau record !",
    achievements: "Succès", playAgain: "Rejouer", startGame: "🚀 Commencer le jeu",
    selectLanguage: "Choisir la langue", instructions: "Instructions",
    chooseLevel: "Choisis ton niveau", chooseOperation: "Choisis l'opération",
    progress: "Progression", questionsCompleted: "Questions réussies", questionsRemaining: "Questions restantes",
    levelLocked: "Niveau verrouillé", levelUnlocked: "Niveau débloqué",
    subscribeToPremium: "S'abonner à Premium", premiumFeatures: "Fonctionnalités Premium",
    freeVersion: "Version Gratuite", premiumVersion: "Version Premium", upgradeNow: "Passer à Premium",
    freeTrialEnds: "Essai gratuit se termine dans",
    day: "jour", days: "jours", questionsLeft: "questions restantes aujourd'hui",
    operations: {
      addition: "Addition", subtraction: "Soustraction",
      multiplication: "Multiplication", division: "Division", mixed: "Mélangé"
    },
    levels: { 1: "Débutant", 2: "Facile", 3: "Moyen", 4: "Difficile", 5: "Expert" },
    subscription: {
      title: "Choisissez votre abonnement Math4Kids",
      freeTitle: "Version Gratuite", freeDuration: "7 jours d'essai",
      monthlyTitle: "Mensuel", monthlyPrice: "9,99€", monthlyDuration: "/mois",
      quarterlyTitle: "Trimestriel", quarterlyPrice: "26,97€", quarterlyDuration: "/3 mois",
      quarterlySavings: "ÉCONOMIE 10%", yearlyTitle: "Annuel", yearlyPrice: "83,93€",
      yearlyDuration: "/an", yearlySavings: "ÉCONOMIE 30%", bestValue: "MEILLEUR CHOIX",
      selectPlan: "Choisir ce forfait", currentPlan: "Forfait actuel",
      features: {
        freeFeatures: ["Niveau débutant seulement", "50 questions/jour max", "Version web uniquement", "Avec publicités"],
        premiumFeatures: ["Tous les 5 niveaux débloqués", "Accès web illimité", "Applications mobiles (iOS & Android)", "Aucune publicité", "Support prioritaire", "Statistiques avancées", "Mode multijoueur", "Défis quotidiens"]
      },
      platforms: { webAccess: "Accès Web", mobileAccess: "Apps Mobiles", allLevels: "Tous les niveaux", noAds: "Sans publicité", support: "Support prioritaire" }
    }
  },
  en: {
    appName: "Math4Kids", title: "Math4Kids", subtitle: "Learn math while having fun!", welcomeMessage: "Welcome to the math adventure!",
    level: "Level", score: "Score", lives: "Lives", streak: "Streak", answer: "Answer", check: "Check", next: "Next", restart: "Restart",
    settings: "Settings", language: "Language", sound: "Sound", difficulty: "Difficulty", correct: "🎉 Excellent!", incorrect: "❌ Oops! Try again!",
    excellent: "🌟 Amazing!", tryAgain: "Try again!", gameOver: "Game Over!", finalScore: "Final Score", newRecord: "🏆 New Record!",
    achievements: "Achievements", playAgain: "Play Again", startGame: "🚀 Start Game", selectLanguage: "Select Language", instructions: "Instructions",
    chooseLevel: "Choose your level", chooseOperation: "Choose operation", progress: "Progress", questionsCompleted: "Questions completed", questionsRemaining: "Questions remaining",
    levelLocked: "Level locked", levelUnlocked: "Level unlocked", subscribeToPremium: "Subscribe to Premium", premiumFeatures: "Premium Features",
    freeVersion: "Free Version", premiumVersion: "Premium Version", upgradeNow: "Upgrade Now", freeTrialEnds: "Free trial ends in",
    day: "day", days: "days", questionsLeft: "questions left today",
    operations: { addition: "Addition", subtraction: "Subtraction", multiplication: "Multiplication", division: "Division", mixed: "Mixed" },
    levels: { 1: "Beginner", 2: "Easy", 3: "Medium", 4: "Hard", 5: "Expert" },
    subscription: {
      title: "Choose your Math4Kids subscription", freeTitle: "Free Version", freeDuration: "7-day trial",
      monthlyTitle: "Monthly", monthlyPrice: "$9.99", monthlyDuration: "/month", quarterlyTitle: "Quarterly", quarterlyPrice: "$26.97", quarterlyDuration: "/3 months",
      quarterlySavings: "SAVE 10%", yearlyTitle: "Annual", yearlyPrice: "$83.93", yearlyDuration: "/year", yearlySavings: "SAVE 30%", bestValue: "BEST VALUE",
      selectPlan: "Select this plan", currentPlan: "Current plan",
      features: {
        freeFeatures: ["Beginner level only", "50 questions/day max", "Web version only", "With advertisements"],
        premiumFeatures: ["All 5 levels unlocked", "Unlimited web access", "Mobile apps (iOS & Android)", "No advertisements", "Priority support", "Advanced statistics", "Multiplayer mode", "Daily challenges"]
      },
      platforms: { webAccess: "Web Access", mobileAccess: "Mobile Apps", allLevels: "All Levels", noAds: "No Ads", support: "Priority Support" }
    }
  }
}

// Créer des fallbacks pour toutes les autres langues
Object.assign(translations, {
  'en-us': translations.en, 'es-mx': translations.fr, 'pt-br': translations.fr, 'fr-ca': translations.fr,
  'en-au': translations.en, de: translations.en, it: translations.en, pt: translations.fr,
  ru: translations.en, nl: translations.en, sv: translations.en, pl: translations.en,
  ja: translations.en, ko: translations.en, hi: translations.en, he: translations.en,
  th: translations.en, vi: translations.en, id: translations.en, ms: translations.en,
  sw: translations.en, am: translations.en, af: translations.en, es: translations.fr,
  zh: translations.en, ar: translations.en
})

// Fonctions utilitaires
const groupBy = (array: any[], key: string) => {
  return array.reduce((result, item) => {
    const group = item[key]
    if (!result[group]) result[group] = []
    result[group].push(item)
    return result
  }, {})
}

const generateMathQuestion = (level: number, operation: string) => {
  const ranges = {
    1: { min: 1, max: 10 },
    2: { min: 5, max: 25 },
    3: { min: 10, max: 50 },
    4: { min: 25, max: 100 },
    5: { min: 50, max: 200 }
  }
  
  const range = ranges[level as keyof typeof ranges]
  const a = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min
  const b = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min
  
  let question, answer
  
  switch (operation) {
    case 'addition':
      question = `${a} + ${b}`
      answer = a + b
      break
    case 'subtraction':
      const larger = Math.max(a, b)
      const smaller = Math.min(a, b)
      question = `${larger} - ${smaller}`
      answer = larger - smaller
      break
    case 'multiplication':
      const factor1 = Math.floor(Math.random() * 12) + 1
      const factor2 = Math.floor(Math.random() * 12) + 1
      question = `${factor1} × ${factor2}`
      answer = factor1 * factor2
      break
    case 'division':
      const dividend = a * b
      question = `${dividend} ÷ ${a}`
      answer = b
      break
    default:
      question = `${a} + ${b}`
      answer = a + b
  }
  
  return { question, answer }
}

export default function Math4KidsApp() {
  // États principaux
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showSubscriptionModal, setShowSubscriptionModal] = useState(false)
  const [selectedLevel, setSelectedLevel] = useState(1)
  const [selectedOperation, setSelectedOperation] = useState('addition')
  const [gameState, setGameState] = useState('menu')
  const [currentQuestion, setCurrentQuestion] = useState<any>(null)
  const [userAnswer, setUserAnswer] = useState('')
  const [score, setScore] = useState(0)
  const [streak, setStreak] = useState(0)
  const [lives, setLives] = useState(3)
  
  // États d'abonnement et progression
  const [subscriptionType, setSubscriptionType] = useState('free')
  const [freeTrialDaysLeft, setFreeTrialDaysLeft] = useState(7)
  const [levelProgress, setLevelProgress] = useState({
    1: { completed: 45, required: 100 },
    2: { completed: 0, required: 100 },
    3: { completed: 0, required: 100 },
    4: { completed: 0, required: 100 },
    5: { completed: 0, required: 100 }
  })
  const [dailyQuestionsCount, setDailyQuestionsCount] = useState(12)
  const [languageKey, setLanguageKey] = useState(0)
  
  // Configuration actuelle de la langue
  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage as keyof typeof SUPPORTED_LANGUAGES] || SUPPORTED_LANGUAGES['fr']
  const t = translations[currentLanguage as keyof typeof translations] || translations['fr']
  const isRTL = currentLangConfig.rtl || false
  
  // Langues groupées par continent
  const languagesByContinent = groupBy(
    Object.entries(SUPPORTED_LANGUAGES).map(([code, config]) => ({
      code,
      ...config
    })),
    'continent'
  )
  
  // Vérification du déverrouillage des niveaux
  const isLevelUnlocked = (level: number) => {
    if (subscriptionType !== 'free') return true
    if (level === 1) return true
    return levelProgress[level - 1 as keyof typeof levelProgress]?.completed >= 100
  }
  
  // Génération de nouvelle question
  const generateNewQuestion = useCallback(() => {
    const question = generateMathQuestion(selectedLevel, selectedOperation)
    setCurrentQuestion(question)
    setUserAnswer('')
  }, [selectedLevel, selectedOperation])
  
  // Démarrage du jeu
  const startGame = () => {
    if (subscriptionType === 'free' && dailyQuestionsCount >= 50) {
      setShowSubscriptionModal(true)
      return
    }
    
    setGameState('playing')
    setScore(0)
    setStreak(0)
    setLives(3)
    generateNewQuestion()
  }
  
  // Vérification de la réponse
  const checkAnswer = () => {
    const userNum = parseInt(userAnswer)
    const isCorrect = userNum === currentQuestion.answer
    
    if (isCorrect) {
      setScore(score + 10 + streak)
      setStreak(streak + 1)
      
      const newProgress = { ...levelProgress }
      newProgress[selectedLevel as keyof typeof levelProgress].completed++
      setLevelProgress(newProgress)
      
      if (subscriptionType === 'free') {
        setDailyQuestionsCount(dailyQuestionsCount + 1)
      }
      
      generateNewQuestion()
    } else {
      setStreak(0)
      setLives(lives - 1)
      
      if (lives <= 1) {
        setGameState('menu')
      }
    }
  }
  
  // Changement de langue avec traduction complète garantie
  const changeLanguage = (langCode: string) => {
    setCurrentLanguage(langCode)
    setLanguageKey(prev => prev + 1)
    
    const langConfig = SUPPORTED_LANGUAGES[langCode as keyof typeof SUPPORTED_LANGUAGES]
    if (langConfig) {
      document.documentElement.setAttribute('dir', langConfig.rtl ? 'rtl' : 'ltr')
      document.documentElement.setAttribute('lang', langCode)
    }
    
    setShowLanguageDropdown(false)
  }
  
  // Plans d'abonnement
  const subscriptionPlans = [
    {
      id: 'free',
      title: t.subscription.freeTitle,
      price: '0€',
      duration: t.subscription.freeDuration,
      features: t.subscription.features.freeFeatures,
      color: 'bg-gray-100 text-gray-800',
      buttonColor: 'bg-gray-500 hover:bg-gray-600',
      current: subscriptionType === 'free'
    },
    {
      id: 'monthly',
      title: t.subscription.monthlyTitle,
      price: t.subscription.monthlyPrice,
      duration: t.subscription.monthlyDuration,
      features: t.subscription.features.premiumFeatures,
      color: 'bg-blue-100 text-blue-800',
      buttonColor: 'bg-blue-500 hover:bg-blue-600',
      current: subscriptionType === 'monthly'
    },
    {
      id: 'quarterly',
      title: t.subscription.quarterlyTitle,
      price: t.subscription.quarterlyPrice,
      duration: t.subscription.quarterlyDuration,
      badge: t.subscription.quarterlySavings,
      features: t.subscription.features.premiumFeatures,
      color: 'bg-green-100 text-green-800',
      buttonColor: 'bg-green-500 hover:bg-green-600',
      current: subscriptionType === 'quarterly'
    },
    {
      id: 'yearly',
      title: t.subscription.yearlyTitle,
      price: t.subscription.yearlyPrice,
      duration: t.subscription.yearlyDuration,
      badge: t.subscription.yearlySavings,
      popular: true,
      features: t.subscription.features.premiumFeatures,
      color: 'bg-purple-100 text-purple-800',
      buttonColor: 'bg-purple-500 hover:bg-purple-600',
      current: subscriptionType === 'yearly'
    }
  ]
  
  return (
    <div key={languageKey} className={`min-h-screen bg-gradient-to-br from-purple-600 via-blue-600 to-cyan-500 p-4 ${isRTL ? 'rtl' : 'ltr'}`}>
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <header className="text-center mb-8">
          <div className="flex items-center justify-between mb-4">
            {/* Sélecteur de langue */}
            <div className="relative">
              <button
                onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                className="flex items-center space-x-2 bg-white/20 backdrop-blur-sm rounded-lg px-4 py-2 text-white hover:bg-white/30 transition-all"
              >
                <Globe size={20} />
                <span>{currentLangConfig.flag} {currentLangConfig.name}</span>
                <ChevronDown size={16} className={`transform transition-transform ${showLanguageDropdown ? 'rotate-180' : ''}`} />
              </button>
              
              {showLanguageDropdown && (
                <div className="absolute top-full left-0 mt-2 bg-white rounded-lg shadow-xl z-50 min-w-64 max-h-96 overflow-y-auto">
                  {Object.entries(languagesByContinent).map(([continent, languages]) => (
                    <div key={continent} className="p-2">
                      <div className="font-semibold text-gray-500 text-sm px-2 py-1">{continent}</div>
                      {languages.map((lang: any) => (
                        <button
                          key={lang.code}
                          onClick={() => changeLanguage(lang.code)}
                          className={`w-full text-left px-3 py-2 rounded flex items-center space-x-2 hover:bg-blue-50 transition-colors ${
                            currentLanguage === lang.code ? 'bg-blue-100 text-blue-600' : 'text-gray-700'
                          }`}
                        >
                          <span>{lang.flag}</span>
                          <span>{lang.name}</span>
                        </button>
                      ))}
                    </div>
                  ))}
                </div>
              )}
            </div>
            
            {/* Bouton abonnement */}
            <button
              onClick={() => setShowSubscriptionModal(true)}
              className="flex items-center space-x-2 bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-4 py-2 rounded-lg hover:from-yellow-500 hover:to-orange-600 transition-all transform hover:scale-105"
            >
              <Crown size={20} />
              <span>{subscriptionType === 'free' ? t.upgradeNow : t.subscription.currentPlan}</span>
            </button>
          </div>
          
          <h1 className="text-5xl font-bold text-white mb-2">{t.appName}</h1>
          <p className="text-xl text-white/90 mb-4">{t.subtitle}</p>
          
          {/* Informations d'abonnement */}
          {subscriptionType === 'free' && (
            <div className="bg-yellow-100 border border-yellow-300 rounded-lg p-3 mb-4">
              <p className="text-yellow-800">
                <Zap className="inline mr-1" size={16} />
                {t.freeTrialEnds} {freeTrialDaysLeft} {freeTrialDaysLeft === 1 ? t.day : t.days}
              </p>
              <p className="text-sm text-yellow-700">
                {50 - dailyQuestionsCount} {t.questionsLeft}
              </p>
            </div>
          )}
        </header>
        
        {/* Interface principale */}
        {gameState === 'menu' && (
          <div className="space-y-6">
            {/* Sélection niveau */}
            <div className="bg-white/20 backdrop-blur-sm rounded-xl p-6">
              <h2 className="text-2xl font-bold text-white mb-4">{t.chooseLevel}</h2>
              <div className="grid grid-cols-5 gap-3">
                {[1, 2, 3, 4, 5].map((level) => {
                  const unlocked = isLevelUnlocked(level)
                  const progress = levelProgress[level as keyof typeof levelProgress]
                  const progressPercent = Math.min((progress.completed / progress.required) * 100, 100)
                  
                  return (
                    <button
                      key={level}
                      onClick={() => unlocked && setSelectedLevel(level)}
                      disabled={!unlocked}
                      className={`relative p-4 rounded-lg transition-all transform hover:scale-105 ${
                        unlocked
                          ? selectedLevel === level
                            ? 'bg-white text-purple-600 shadow-lg'
                            : 'bg-white/30 text-white hover:bg-white/40'
                          : 'bg-gray-400/50 text-gray-300 cursor-not-allowed'
                      }`}
                    >
                      {!unlocked && <Lock className="absolute top-2 right-2" size={16} />}
                      <div className="text-center">
                        <div className="text-2xl font-bold mb-1">{level}</div>
                        <div className="text-sm">{t.levels[level as keyof typeof t.levels]}</div>
                        {unlocked && (
                          <div className="mt-2">
                            <div className="bg-gray-200 rounded-full h-2 mb-1">
                              <div
                                className="bg-green-500 rounded-full h-2 transition-all"
                                style={{ width: `${progressPercent}%` }}
                              />
                            </div>
                            <div className="text-xs">{progress.completed}/{progress.required}</div>
                          </div>
                        )}
                      </div>
                    </button>
                  )
                })}
              </div>
            </div>
            
            {/* Sélection opération */}
            <div className="bg-white/20 backdrop-blur-sm rounded-xl p-6">
              <h2 className="text-2xl font-bold text-white mb-4">{t.chooseOperation}</h2>
              <div className="grid grid-cols-2 md:grid-cols-5 gap-3">
                {Object.entries(t.operations).map(([key, name]) => (
                  <button
                    key={key}
                    onClick={() => setSelectedOperation(key)}
                    className={`p-3 rounded-lg transition-all transform hover:scale-105 ${
                      selectedOperation === key
                        ? 'bg-white text-purple-600 shadow-lg'
                        : 'bg-white/30 text-white hover:bg-white/40'
                    }`}
                  >
                    {name}
                  </button>
                ))}
              </div>
            </div>
            
            {/* Bouton démarrer */}
            <div className="text-center">
              <button
                onClick={startGame}
                className="bg-gradient-to-r from-green-400 to-blue-500 text-white px-8 py-4 rounded-xl text-xl font-bold hover:from-green-500 hover:to-blue-600 transition-all transform hover:scale-105 shadow-lg"
              >
                {t.startGame}
              </button>
            </div>
          </div>
        )}
        
        {/* Interface de jeu */}
        {gameState === 'playing' && currentQuestion && (
          <div className="space-y-6">
            {/* Statistiques */}
            <div className="grid grid-cols-4 gap-4">
              <div className="bg-white/20 backdrop-blur-sm rounded-lg p-4 text-center">
                <div className="text-2xl font-bold text-white">{score}</div>
                <div className="text-white/80">{t.score}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-sm rounded-lg p-4 text-center">
                <div className="text-2xl font-bold text-white">{streak}</div>
                <div className="text-white/80">{t.streak}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-sm rounded-lg p-4 text-center">
                <div className="text-2xl font-bold text-white">{'❤️'.repeat(lives)}</div>
                <div className="text-white/80">{t.lives}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-sm rounded-lg p-4 text-center">
                <div className="text-2xl font-bold text-white">{selectedLevel}</div>
                <div className="text-white/80">{t.level}</div>
              </div>
            </div>
            
            {/* Question */}
            <div className="bg-white rounded-xl p-8 text-center shadow-xl">
              <div className="text-6xl font-bold text-gray-800 mb-6">
                {currentQuestion.question} = ?
              </div>
              
              <div className="space-y-4">
                <input
                  type="number"
                  value={userAnswer}
                  onChange={(e) => setUserAnswer(e.target.value)}
                  className="text-center text-4xl font-bold border-2 border-gray-300 rounded-lg px-4 py-3 w-64 focus:border-blue-500 focus:outline-none"
                  placeholder="?"
                  autoFocus
                />
                
                <div className="space-x-4">
                  <button
                    onClick={checkAnswer}
                    disabled={!userAnswer}
                    className="bg-green-500 text-white px-6 py-3 rounded-lg font-bold hover:bg-green-600 transition-colors disabled:bg-gray-400"
                  >
                    {t.check}
                  </button>
                  <button
                    onClick={() => setGameState('menu')}
                    className="bg-gray-500 text-white px-6 py-3 rounded-lg font-bold hover:bg-gray-600 transition-colors"
                  >
                    {t.restart}
                  </button>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
      
      {/* Modal d'abonnement */}
      {showSubscriptionModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl max-w-6xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-6">
              <div className="flex justify-between items-center mb-6">
                <h2 className="text-3xl font-bold text-gray-800">{t.subscription.title}</h2>
                <button
                  onClick={() => setShowSubscriptionModal(false)}
                  className="text-gray-500 hover:text-gray-700 transition-colors"
                >
                  <X size={24} />
                </button>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                {subscriptionPlans.map((plan) => (
                  <div
                    key={plan.id}
                    className={`relative border-2 rounded-xl p-6 transition-all transform hover:scale-105 ${
                      plan.popular ? 'border-purple-500 shadow-lg' : 'border-gray-200'
                    } ${plan.current ? 'ring-2 ring-blue-500' : ''}`}
                  >
                    {plan.popular && (
                      <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                        <span className="bg-purple-500 text-white px-3 py-1 rounded-full text-sm font-bold">
                          {t.subscription.bestValue}
                        </span>
                      </div>
                    )}
                    
                    {plan.badge && (
                      <div className="absolute -top-3 right-4">
                        <span className="bg-green-500 text-white px-2 py-1 rounded-full text-xs font-bold">
                          {plan.badge}
                        </span>
                      </div>
                    )}
                    
                    <div className="text-center mb-4">
                      <h3 className="text-xl font-bold text-gray-800 mb-2">{plan.title}</h3>
                      <div className="text-3xl font-bold text-gray-900 mb-1">
                        {plan.price}
                      </div>
                      <div className="text-gray-600">{plan.duration}</div>
                    </div>
                    
                    <div className="space-y-3 mb-6">
                      {plan.features.map((feature, index) => (
                        <div key={index} className="flex items-start space-x-2">
                          <Check size={16} className="text-green-500 mt-0.5 flex-shrink-0" />
                          <span className="text-sm text-gray-700">{feature}</span>
                        </div>
                      ))}
                    </div>
                    
                    <button
                      onClick={() => {
                        if (!plan.current) {
                          setSubscriptionType(plan.id)
                        }
                        setShowSubscriptionModal(false)
                      }}
                      disabled={plan.current}
                      className={`w-full py-3 rounded-lg font-bold transition-colors ${
                        plan.current
                          ? 'bg-gray-200 text-gray-500 cursor-not-allowed'
                          : plan.buttonColor + ' text-white hover:opacity-90'
                      }`}
                    >
                      {plan.current ? t.subscription.currentPlan : t.subscription.selectPlan}
                    </button>
                  </div>
                ))}
              </div>
              
              {/* Avantages platformes */}
              <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="text-center p-4 bg-blue-50 rounded-lg">
                  <Monitor className="mx-auto mb-2 text-blue-500" size={32} />
                  <div className="font-semibold text-blue-800">{t.subscription.platforms.webAccess}</div>
                  <div className="text-sm text-blue-600">math4child.com</div>
                </div>
                <div className="text-center p-4 bg-green-50 rounded-lg">
                  <Smartphone className="mx-auto mb-2 text-green-500" size={32} />
                  <div className="font-semibold text-green-800">{t.subscription.platforms.mobileAccess}</div>
                  <div className="text-sm text-green-600">iOS & Android</div>
                </div>
                <div className="text-center p-4 bg-purple-50 rounded-lg">
                  <Trophy className="mx-auto mb-2 text-purple-500" size={32} />
                  <div className="font-semibold text-purple-800">{t.subscription.platforms.allLevels}</div>
                  <div className="text-sm text-purple-600">{t.subscription.platforms.support}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
