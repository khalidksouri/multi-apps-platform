"use client"
import { useState, useEffect, createContext, useContext, useCallback } from 'react'
import { getLanguageByCode, type Language } from '@/data/languages'

// Interface RICHE avec toutes fonctionnalités
interface LanguageContextType {
  currentLanguage: string
  setLanguage: (code: string) => void
  isRTL: boolean
  t: (key: string, params?: Record<string, string>) => string
  formatNumber: (num: number) => string
  formatCurrency: (amount: number, currency?: string) => string
  formatDate: (date: Date) => string
  getLanguageInfo: () => Language | undefined
  loadingStates: {
    changing: boolean
    loading: boolean
  }
  preferences: {
    autoDetect: boolean
    fallbackLanguage: string
    cacheTranslations: boolean
  }
  setPreferences: (prefs: Partial<LanguageContextType['preferences']>) => void
}

// Context avec valeurs par défaut RICHES
const defaultValue: LanguageContextType = {
  currentLanguage: 'fr',
  setLanguage: () => {},
  isRTL: false,
  t: (key: string) => key,
  formatNumber: (num: number) => num.toString(),
  formatCurrency: (amount: number) => `${amount}€`,
  formatDate: (date: Date) => date.toLocaleDateString(),
  getLanguageInfo: () => undefined,
  loadingStates: { changing: false, loading: false },
  preferences: { autoDetect: true, fallbackLanguage: 'fr', cacheTranslations: true },
  setPreferences: () => {}
}

const LanguageContext = createContext<LanguageContextType>(defaultValue)

// Hook principal RICHE
export function useLanguage(): LanguageContextType {
  return useContext(LanguageContext)
}

// Provider RICHE avec toutes fonctionnalités avancées
export function LanguageProvider({ children }: { children: React.ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  const [loadingStates, setLoadingStates] = useState({ changing: false, loading: false })
  const [preferences, setPreferencesState] = useState({
    autoDetect: true,
    fallbackLanguage: 'fr',
    cacheTranslations: true
  })

  // Cache des traductions pour performance
  const [translationCache, setTranslationCache] = useState<Record<string, Record<string, string>>>({})
  
  // Informations langue actuelle
  const currentLangInfo = getLanguageByCode(currentLanguage)
  const isRTL = currentLangInfo?.rtl || false
  
  // TRADUCTIONS COMPLÈTES ET RICHES - Toutes fonctionnalités
  const translations: Record<string, Record<string, string>> = {
    fr: {
      // Navigation et interface
      appTitle: '⭐ App éducative #1 en France ⭐',
      heroTitle: "Apprends les maths en t'amusant !",
      heroSubtitle: "L'application éducative révolutionnaire hybride",
      heroDescription: "Développe tes compétences mathématiques avec des exercices progressifs et amusants adaptés à ton niveau. Interface premium avec 200+ langues, IA adaptive et système de progression rigoureux.",
      startFree: "🎯 Commencer gratuitement →",
      viewPlans: "💎 Voir les plans premium",
      trustedBy: "100k+ familles nous font confiance",
      
      // Langues et sélection
      selectLanguage: "Sélectionner une langue",
      searchLanguage: "Rechercher parmi 200+ langues...",
      filterByContinent: "Filtrer par continent",
      filterByRegion: "Filtrer par région",
      languageStats: "{{count}} langues disponibles",
      rtlSupport: "Support RTL activé",
      fontLoading: "Chargement police spécialisée...",
      
      // Exercices et progression
      exercisesTitle: "🧮 Exercices Mathématiques Adaptatifs",
      chooseLevel: "📊 Choisis ton niveau de progression",
      level1: "🎯 Niveau 1 - Découverte (1-10)",
      level2: "🚀 Niveau 2 - Exploration (1-20)", 
      level3: "⭐ Niveau 3 - Maîtrise (1-50)",
      level4: "🏆 Niveau 4 - Expert (1-100)",
      level5: "👑 Niveau 5 - Champion (1-1000+)",
      validationRequired: "{{count}}/100 bonnes réponses requises",
      unlockNext: "Débloque le niveau suivant",
      
      // IA et génération
      aiGenerating: "🤖 IA génère question adaptée...",
      aiDifficulty: "Difficulté ajustée selon performance",
      aiHint: "💡 Indice IA : {{hint}}",
      adaptiveSystem: "Système adaptatif IA activé",
      
      // Pricing et abonnements
      pricingTitle: "💎 Plans Premium Multi-Appareils",
      planFree: "Gratuit - Découverte",
      planPremium: "Premium - 3 profils enfants",
      planFamily: "Famille - 5 profils enfants", 
      planUltimate: "Ultimate - 8 profils enfants",
      multiDevice: "Multi-appareils : -50% 2ème, -75% 3ème",
      geoPricing: "Prix adapté selon votre région",
      
      // Gamification
      badges: "🏅 Badges de progression",
      achievements: "🎖️ Réalisations débloquées",
      leaderboard: "🏆 Classement global",
      streaks: "🔥 Série de {{days}} jours",
      xpEarned: "⭐ {{xp}} XP gagnés",
      
      // Analytics et stats
      statsTitle: "📊 Analytiques Détaillées",
      accuracy: "Précision : {{percent}}%",
      timeSpent: "Temps passé : {{time}}",
      questionsAnswered: "Questions résolues : {{count}}",
      improvementRate: "Taux d'amélioration : +{{rate}}%",
      strongAreas: "Points forts : {{areas}}",
      weakAreas: "À améliorer : {{areas}}",
      
      // Notifications et feedback
      correctAnswer: "🎉 Excellente réponse !",
      incorrectAnswer: "💭 Réfléchis encore, tu peux y arriver !",
      levelCompleted: "🎊 Niveau {{level}} terminé ! Félicitations !",
      newBadgeUnlocked: "🏅 Nouveau badge débloqué : {{badge}}",
      streakBroken: "📱 Série interrompue, continue demain !",
      dailyGoalReached: "🎯 Objectif quotidien atteint !",
      
      // Support et aide
      helpTitle: "❓ Centre d'aide complet",
      tutorials: "📚 Tutoriels interactifs",
      parentGuide: "👨‍👩‍👧‍👦 Guide parents",
      troubleshooting: "🔧 Résolution problèmes",
      contactSupport: "📞 Contacter support 24/7",
      
      // Accessibilité
      accessibilityMode: "♿ Mode accessibilité",
      voiceOver: "🔊 Lecture vocale activée", 
      highContrast: "🔍 Contraste élevé",
      largeText: "📝 Texte agrandie",
      colorBlindMode: "🌈 Mode daltonisme"
    },
    en: {
      // Navigation and interface
      appTitle: '⭐ #1 Educational App in France ⭐',
      heroTitle: "Learn math while having fun!",
      heroSubtitle: "The revolutionary hybrid educational app",
      heroDescription: "Develop your mathematical skills with progressive and fun exercises adapted to your level. Premium interface with 200+ languages, adaptive AI and rigorous progression system.",
      startFree: "🎯 Start for free →",
      viewPlans: "💎 View premium plans",
      trustedBy: "100k+ families trust us",
      
      // Languages and selection
      selectLanguage: "Select a language",
      searchLanguage: "Search among 200+ languages...",
      filterByContinent: "Filter by continent",
      filterByRegion: "Filter by region", 
      languageStats: "{{count}} languages available",
      rtlSupport: "RTL support enabled",
      fontLoading: "Loading specialized font...",
      
      // Exercises and progression
      exercisesTitle: "🧮 Adaptive Math Exercises",
      chooseLevel: "📊 Choose your progression level",
      level1: "🎯 Level 1 - Discovery (1-10)",
      level2: "🚀 Level 2 - Exploration (1-20)",
      level3: "⭐ Level 3 - Mastery (1-50)",
      level4: "🏆 Level 4 - Expert (1-100)",
      level5: "👑 Level 5 - Champion (1-1000+)",
      validationRequired: "{{count}}/100 correct answers required",
      unlockNext: "Unlock next level",
      
      // AI and generation
      aiGenerating: "🤖 AI generating adapted question...",
      aiDifficulty: "Difficulty adjusted based on performance",
      aiHint: "💡 AI Hint: {{hint}}",
      adaptiveSystem: "Adaptive AI system enabled",
      
      // Pricing and subscriptions
      pricingTitle: "💎 Premium Multi-Device Plans",
      planFree: "Free - Discovery",
      planPremium: "Premium - 3 child profiles",
      planFamily: "Family - 5 child profiles",
      planUltimate: "Ultimate - 8 child profiles",
      multiDevice: "Multi-device: -50% 2nd, -75% 3rd",
      geoPricing: "Price adapted to your region",
      
      // Gamification
      badges: "🏅 Progress badges",
      achievements: "🎖️ Unlocked achievements",
      leaderboard: "🏆 Global ranking",
      streaks: "🔥 {{days}} day streak",
      xpEarned: "⭐ {{xp}} XP earned",
      
      // Analytics and stats
      statsTitle: "📊 Detailed Analytics",
      accuracy: "Accuracy: {{percent}}%",
      timeSpent: "Time spent: {{time}}",
      questionsAnswered: "Questions solved: {{count}}",
      improvementRate: "Improvement rate: +{{rate}}%",
      strongAreas: "Strengths: {{areas}}",
      weakAreas: "To improve: {{areas}}",
      
      // Notifications and feedback
      correctAnswer: "🎉 Excellent answer!",
      incorrectAnswer: "💭 Think again, you can do it!",
      levelCompleted: "🎊 Level {{level}} completed! Congratulations!",
      newBadgeUnlocked: "🏅 New badge unlocked: {{badge}}",
      streakBroken: "📱 Streak broken, continue tomorrow!",
      dailyGoalReached: "🎯 Daily goal reached!",
      
      // Support and help
      helpTitle: "❓ Complete Help Center",
      tutorials: "📚 Interactive tutorials",
      parentGuide: "👨‍👩‍👧‍👦 Parent guide",
      troubleshooting: "🔧 Troubleshooting",
      contactSupport: "📞 Contact 24/7 support",
      
      // Accessibility
      accessibilityMode: "♿ Accessibility mode",
      voiceOver: "🔊 Voice reading enabled",
      highContrast: "🔍 High contrast",
      largeText: "📝 Large text",
      colorBlindMode: "🌈 Color blind mode"
    },
    es: {
      appTitle: '⭐ App Educativa #1 en Francia ⭐',
      heroTitle: "¡Aprende matemáticas divirtiéndote!",
      heroSubtitle: "La aplicación educativa híbrida revolucionaria",
      heroDescription: "Desarrolla tus habilidades matemáticas con ejercicios progresivos y divertidos adaptados a tu nivel. Interfaz premium con 200+ idiomas, IA adaptativa y sistema de progresión riguroso.",
      startFree: "🎯 Comenzar gratis →",
      viewPlans: "💎 Ver planes premium",
      trustedBy: "100k+ familias confían en nosotros"
    },
    ar: {
      appTitle: '⭐ تطبيق تعليمي #1 في فرنسا ⭐',
      heroTitle: "تعلم الرياضيات بالمرح!",
      heroSubtitle: "التطبيق التعليمي الهجين الثوري",
      heroDescription: "طور مهاراتك في الرياضيات بتمارين ممتعة ومتدرجة تناسب مستواك. واجهة متميزة مع 200+ لغة، ذكاء اصطناعي تكيفي ونظام تقدم صارم.",
      startFree: "🎯 ابدأ مجاناً ←",
      viewPlans: "💎 اعرض الخطط المتميزة",
      trustedBy: "100k+ عائلة تثق بنا"
    },
    de: {
      appTitle: '⭐ #1 Bildungs-App in Frankreich ⭐',
      heroTitle: "Lerne Mathe mit Spaß!",
      heroSubtitle: "Die revolutionäre hybride Bildungs-App",
      heroDescription: "Entwickle deine mathematischen Fähigkeiten mit progressiven und unterhaltsamen Übungen, die an dein Niveau angepasst sind. Premium-Interface mit 200+ Sprachen, adaptiver KI und rigorosem Fortschrittssystem.",
      startFree: "🎯 Kostenlos starten →",
      viewPlans: "💎 Premium-Pläne ansehen",
      trustedBy: "100k+ Familien vertrauen uns"
    },
    zh: {
      appTitle: '⭐ 法国第一教育应用 ⭐',
      heroTitle: "快乐学数学!",
      heroSubtitle: "革命性混合教育应用",
      heroDescription: "通过适合你水平的渐进式趣味练习来提高数学技能。具有200+种语言、自适应AI和严格进度系统的高级界面。",
      startFree: "🎯 免费开始 →",
      viewPlans: "💎 查看高级计划",
      trustedBy: "100k+ 家庭信任我们"
    },
    ja: {
      appTitle: '⭐ フランス第1位教育アプリ ⭐',
      heroTitle: "楽しく数学を学ぼう!",
      heroSubtitle: "革命的なハイブリッド教育アプリ",
      heroDescription: "あなたのレベルに合わせた段階的で楽しい練習で数学スキルを向上させましょう。200+言語、適応AI、厳格な進歩システムを備えたプレミアムインターフェース。",
      startFree: "🎯 無料で始める →",
      viewPlans: "💎 プレミアムプランを見る",
      trustedBy: "100k+ 家族が信頼"
    }
  }
  
  // Fonction de traduction AVANCÉE avec interpolation
  const t = useCallback((key: string, params?: Record<string, string>): string => {
    const langTranslations = translations[currentLanguage] || translations[preferences.fallbackLanguage] || translations['fr']
    
    // Support for nested keys like 'stats.families'
    const keys = key.split('.')
    let value = langTranslations
    
    for (const k of keys) {
      value = (value as any)?.[k]
    }
    
    let result = (value as string) || key
    
    // Interpolation des paramètres {{param}}
    if (params) {
      for (const [paramKey, paramValue] of Object.entries(params)) {
        result = result.replace(new RegExp(`{{${paramKey}}}`, 'g'), paramValue)
      }
    }
    
    return result
  }, [currentLanguage, preferences.fallbackLanguage])
  
  // Formatage des nombres selon la locale
  const formatNumber = useCallback((num: number): string => {
    try {
      return new Intl.NumberFormat(currentLanguage).format(num)
    } catch {
      return num.toString()
    }
  }, [currentLanguage])
  
  // Formatage des devises
  const formatCurrency = useCallback((amount: number, currency = 'EUR'): string => {
    try {
      return new Intl.NumberFormat(currentLanguage, {
        style: 'currency',
        currency: currency
      }).format(amount)
    } catch {
      return `${amount}${currency === 'EUR' ? '€' : currency}`
    }
  }, [currentLanguage])
  
  // Formatage des dates
  const formatDate = useCallback((date: Date): string => {
    try {
      return new Intl.DateTimeFormat(currentLanguage, {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      }).format(date)
    } catch {
      return date.toLocaleDateString()
    }
  }, [currentLanguage])
  
  // Obtenir infos langue actuelle
  const getLanguageInfo = useCallback((): Language | undefined => {
    return currentLangInfo
  }, [currentLangInfo])
  
  // Détection automatique de la langue
  useEffect(() => {
    if (typeof window !== 'undefined' && preferences.autoDetect) {
      setLoadingStates(prev => ({ ...prev, loading: true }))
      
      // Charger langue sauvegardée ou détecter
      const savedLanguage = localStorage.getItem('math4child-language')
      const browserLanguage = navigator.language.split('-')[0]
      const detectedLanguage = savedLanguage || browserLanguage
      
      if (getLanguageByCode(detectedLanguage)) {
        setCurrentLanguage(detectedLanguage)
      }
      
      setLoadingStates(prev => ({ ...prev, loading: false }))
    }
  }, [preferences.autoDetect])
  
  // Application des changements de langue avec animations
  useEffect(() => {
    if (typeof window !== 'undefined') {
      setLoadingStates(prev => ({ ...prev, changing: true }))
      
      // Sauvegarder préférences
      localStorage.setItem('math4child-language', currentLanguage)
      localStorage.setItem('math4child-preferences', JSON.stringify(preferences))
      
      // Appliquer RTL
      document.documentElement.dir = isRTL ? 'rtl' : 'ltr'
      document.documentElement.lang = currentLanguage
      
      // Charger police spécialisée si nécessaire
      const fontFamily = currentLangInfo?.font
      if (fontFamily) {
        document.documentElement.style.fontFamily = `"${fontFamily}", system-ui, sans-serif`
        
        // Précharger la police
        const link = document.createElement('link')
        link.href = `https://fonts.googleapis.com/css2?family=${fontFamily.replace(/ /g, '+')}&display=swap`
        link.rel = 'stylesheet'
        document.head.appendChild(link)
      } else {
        document.documentElement.style.fontFamily = 'system-ui, sans-serif'
      }
      
      // Animation de transition
      document.body.style.transition = 'all 0.3s ease'
      setTimeout(() => {
        setLoadingStates(prev => ({ ...prev, changing: false }))
      }, 300)
    }
  }, [currentLanguage, isRTL, currentLangInfo, preferences])
  
  // Fonction de changement de langue avec validation
  const setLanguage = useCallback((code: string) => {
    const language = getLanguageByCode(code)
    if (language) {
      setCurrentLanguage(code)
      
      // Cache des traductions si activé
      if (preferences.cacheTranslations && !translationCache[code]) {
        setTranslationCache(prev => ({
          ...prev,
          [code]: translations[code] || {}
        }))
      }
    }
  }, [preferences.cacheTranslations, translationCache, translations])
  
  // Fonction de mise à jour des préférences
  const setPreferences = useCallback((newPrefs: Partial<LanguageContextType['preferences']>) => {
    setPreferencesState(prev => ({ ...prev, ...newPrefs }))
  }, [])
  
  // Valeur du contexte RICHE
  const contextValue: LanguageContextType = {
    currentLanguage,
    setLanguage,
    isRTL,
    t,
    formatNumber,
    formatCurrency,
    formatDate,
    getLanguageInfo,
    loadingStates,
    preferences,
    setPreferences
  }
  
  return (
    <LanguageContext.Provider value={contextValue}>
      {children}
    </LanguageContext.Provider>
  )
}
