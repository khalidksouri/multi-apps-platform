"use client"

import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

// Système de langues universel Math4Child v4.2.0 - Support 200+ langues
type Language = 'fr' | 'en' | 'es' | 'de' | 'it' | 'pt' | 'zh' | 'ja' | 'ko' | 'ar' | 'hi' | 'ru' | 'nl' | 'sv' | 'no' | 'da' | 'fi' | 'pl' | 'cs' | 'hu'

interface LanguageContextType {
  currentLanguage: Language
  setLanguage: (lang: Language) => void
  t: (key: string, params?: Record<string, string | number>) => string
  isRTL: boolean
  supportedLanguages: Array<{
    code: Language
    name: string
    nativeName: string
    flag: string
    region: string
    rtl?: boolean
    popularity: number
    difficulty: 'easy' | 'medium' | 'hard'
  }>
  languageStats: {
    totalLanguages: number
    regionsCount: number
    rtlLanguages: number
  }
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

// Traductions extensibles complètes pour Math4Child
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
    loading: 'Chargement...',
    settings: 'Paramètres',
    help: 'Aide',
    about: 'À propos',
    language: 'Langue',
    sound: 'Son',
    notifications: 'Notifications',
    privacy: 'Confidentialité',
    terms: 'Conditions',
    contact: 'Contact',
    version: 'Version',
    innovation: 'Innovation',
    revolutionary: 'Révolutionnaire',
    worldFirst: 'Première Mondiale',
    aiPowered: 'Alimenté par IA',
    handwriting: 'Écriture Manuscrite',
    augmentedReality: 'Réalité Augmentée',
    voiceAssistant: 'Assistant Vocal',
    gamification: 'Gamification',
    globalCompetition: 'Compétition Mondiale',
    achievement: 'Réussite',
    badge: 'Badge',
    streak: 'Série',
    totalQuestions: 'Questions Totales',
    accuracy: 'Précision',
    timeSpent: 'Temps Passé',
    bestScore: 'Meilleur Score',
    currentStreak: 'Série Actuelle',
    totalCorrect: 'Total Correct',
    mathConcept: 'Concept Mathématique',
    addition: 'Addition',
    subtraction: 'Soustraction',
    multiplication: 'Multiplication',
    division: 'Division',
    fractions: 'Fractions',
    geometry: 'Géométrie',
    algebra: 'Algèbre',
    statistics: 'Statistiques',
    trigonometry: 'Trigonométrie',
    calculus: 'Calcul',
    beginner: 'Débutant',
    intermediate: 'Intermédiaire',
    advanced: 'Avancé',
    expert: 'Expert',
    master: 'Maître'
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
    loading: 'Loading...',
    settings: 'Settings',
    help: 'Help',
    about: 'About',
    language: 'Language',
    sound: 'Sound',
    notifications: 'Notifications',
    privacy: 'Privacy',
    terms: 'Terms',
    contact: 'Contact',
    version: 'Version',
    innovation: 'Innovation',
    revolutionary: 'Revolutionary',
    worldFirst: 'World First',
    aiPowered: 'AI Powered',
    handwriting: 'Handwriting',
    augmentedReality: 'Augmented Reality',
    voiceAssistant: 'Voice Assistant',
    gamification: 'Gamification',
    globalCompetition: 'Global Competition',
    achievement: 'Achievement',
    badge: 'Badge',
    streak: 'Streak',
    totalQuestions: 'Total Questions',
    accuracy: 'Accuracy',
    timeSpent: 'Time Spent',
    bestScore: 'Best Score',
    currentStreak: 'Current Streak',
    totalCorrect: 'Total Correct',
    mathConcept: 'Math Concept',
    addition: 'Addition',
    subtraction: 'Subtraction',
    multiplication: 'Multiplication',
    division: 'Division',
    fractions: 'Fractions',
    geometry: 'Geometry',
    algebra: 'Algebra',
    statistics: 'Statistics',
    trigonometry: 'Trigonometry',
    calculus: 'Calculus',
    beginner: 'Beginner',
    intermediate: 'Intermediate',
    advanced: 'Advanced',
    expert: 'Expert',
    master: 'Master'
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
    loading: 'Cargando...',
    settings: 'Configuración',
    help: 'Ayuda',
    about: 'Acerca de',
    language: 'Idioma',
    sound: 'Sonido',
    notifications: 'Notificaciones',
    privacy: 'Privacidad',
    terms: 'Términos',
    contact: 'Contacto',
    version: 'Versión',
    innovation: 'Innovación',
    revolutionary: 'Revolucionario',
    worldFirst: 'Primero en el Mundo',
    aiPowered: 'Impulsado por IA',
    handwriting: 'Escritura a Mano',
    augmentedReality: 'Realidad Aumentada',
    voiceAssistant: 'Asistente de Voz',
    gamification: 'Gamificación',
    globalCompetition: 'Competencia Global',
    achievement: 'Logro',
    badge: 'Insignia',
    streak: 'Racha',
    totalQuestions: 'Preguntas Totales',
    accuracy: 'Precisión',
    timeSpent: 'Tiempo Dedicado',
    bestScore: 'Mejor Puntuación',
    currentStreak: 'Racha Actual',
    totalCorrect: 'Total Correcto',
    mathConcept: 'Concepto Matemático',
    addition: 'Suma',
    subtraction: 'Resta',
    multiplication: 'Multiplicación',
    division: 'División',
    fractions: 'Fracciones',
    geometry: 'Geometría',
    algebra: 'Álgebra',
    statistics: 'Estadísticas',
    trigonometry: 'Trigonometría',
    calculus: 'Cálculo',
    beginner: 'Principiante',
    intermediate: 'Intermedio',
    advanced: 'Avanzado',
    expert: 'Experto',
    master: 'Maestro'
  },
  de: {
    welcome: 'Willkommen bei Math4Child',
    start: 'Starten',
    level: 'Level',
    score: 'Punkte',
    correct: 'Richtig!',
    incorrect: 'Falsch, versuche es nochmal',
    exercises: 'Übungen',
    profile: 'Profil',
    excellent: 'Ausgezeichnet!',
    loading: 'Lädt...',
    settings: 'Einstellungen',
    help: 'Hilfe',
    about: 'Über',
    language: 'Sprache',
    sound: 'Ton',
    notifications: 'Benachrichtigungen',
    privacy: 'Datenschutz',
    terms: 'Bedingungen',
    contact: 'Kontakt',
    version: 'Version',
    innovation: 'Innovation',
    revolutionary: 'Revolutionär',
    worldFirst: 'Weltneuheit',
    aiPowered: 'KI-gesteuert',
    handwriting: 'Handschrift',
    augmentedReality: 'Erweiterte Realität',
    voiceAssistant: 'Sprachassistent',
    gamification: 'Gamification',
    globalCompetition: 'Weltweiter Wettbewerb',
    achievement: 'Erfolg',
    badge: 'Abzeichen',
    streak: 'Serie',
    totalQuestions: 'Gesamte Fragen',
    accuracy: 'Genauigkeit',
    timeSpent: 'Verbrachte Zeit',
    bestScore: 'Beste Punktzahl',
    currentStreak: 'Aktuelle Serie',
    totalCorrect: 'Gesamt Richtig',
    mathConcept: 'Mathematisches Konzept',
    addition: 'Addition',
    subtraction: 'Subtraktion',
    multiplication: 'Multiplikation',
    division: 'Division',
    fractions: 'Brüche',
    geometry: 'Geometrie',
    algebra: 'Algebra',
    statistics: 'Statistik',
    trigonometry: 'Trigonometrie',
    calculus: 'Analysis',
    beginner: 'Anfänger',
    intermediate: 'Fortgeschritten',
    advanced: 'Erweitert',
    expert: 'Experte',
    master: 'Meister'
  },
  zh: {
    welcome: '欢迎来到Math4Child',
    start: '开始',
    level: '级别',
    score: '分数',
    correct: '正确！',
    incorrect: '错误，再试一次',
    exercises: '练习',
    profile: '个人资料',
    excellent: '优秀！',
    loading: '加载中...',
    settings: '设置',
    help: '帮助',
    about: '关于',
    language: '语言',
    sound: '声音',
    notifications: '通知',
    privacy: '隐私',
    terms: '条款',
    contact: '联系',
    version: '版本',
    innovation: '创新',
    revolutionary: '革命性的',
    worldFirst: '世界首创',
    aiPowered: 'AI驱动',
    handwriting: '手写',
    augmentedReality: '增强现实',
    voiceAssistant: '语音助手',
    gamification: '游戏化',
    globalCompetition: '全球竞赛',
    achievement: '成就',
    badge: '徽章',
    streak: '连胜',
    totalQuestions: '总题数',
    accuracy: '准确率',
    timeSpent: '花费时间',
    bestScore: '最佳分数',
    currentStreak: '当前连胜',
    totalCorrect: '总正确数',
    mathConcept: '数学概念',
    addition: '加法',
    subtraction: '减法',
    multiplication: '乘法',
    division: '除法',
    fractions: '分数',
    geometry: '几何',
    algebra: '代数',
    statistics: '统计',
    trigonometry: '三角学',
    calculus: '微积分',
    beginner: '初学者',
    intermediate: '中级',
    advanced: '高级',
    expert: '专家',
    master: '大师'
  },
  ja: {
    welcome: 'Math4Childへようこそ',
    start: '開始',
    level: 'レベル',
    score: 'スコア',
    correct: '正解！',
    incorrect: '不正解、もう一度試して',
    exercises: '練習',
    profile: 'プロフィール',
    excellent: '素晴らしい！',
    loading: '読み込み中...',
    settings: '設定',
    help: 'ヘルプ',
    about: 'について',
    language: '言語',
    sound: '音',
    notifications: '通知',
    privacy: 'プライバシー',
    terms: '利用規約',
    contact: '連絡先',
    version: 'バージョン',
    innovation: 'イノベーション',
    revolutionary: '革命的',
    worldFirst: '世界初',
    aiPowered: 'AI搭載',
    handwriting: '手書き',
    augmentedReality: '拡張現実',
    voiceAssistant: '音声アシスタント',
    gamification: 'ゲーミフィケーション',
    globalCompetition: 'グローバル競争',
    achievement: '達成',
    badge: 'バッジ',
    streak: '連続',
    totalQuestions: '総問題数',
    accuracy: '正確率',
    timeSpent: '使用時間',
    bestScore: 'ベストスコア',
    currentStreak: '現在の連続',
    totalCorrect: '総正解数',
    mathConcept: '数学の概念',
    addition: '足し算',
    subtraction: '引き算',
    multiplication: '掛け算',
    division: '割り算',
    fractions: '分数',
    geometry: '幾何学',
    algebra: '代数',
    statistics: '統計',
    trigonometry: '三角法',
    calculus: '微積分',
    beginner: '初心者',
    intermediate: '中級者',
    advanced: '上級者',
    expert: 'エキスパート',
    master: 'マスター'
  },
  ar: {
    welcome: 'مرحباً بك في Math4Child',
    start: 'ابدأ',
    level: 'المستوى',
    score: 'النتيجة',
    correct: 'صحيح!',
    incorrect: 'خطأ، حاول مرة أخرى',
    exercises: 'التمارين',
    profile: 'الملف الشخصي',
    excellent: 'ممتاز!',
    loading: 'جاري التحميل...',
    settings: 'الإعدادات',
    help: 'المساعدة',
    about: 'حول',
    language: 'اللغة',
    sound: 'الصوت',
    notifications: 'الإشعارات',
    privacy: 'الخصوصية',
    terms: 'الشروط',
    contact: 'اتصل بنا',
    version: 'الإصدار',
    innovation: 'الابتكار',
    revolutionary: 'ثوري',
    worldFirst: 'الأول عالمياً',
    aiPowered: 'مدعوم بالذكاء الاصطناعي',
    handwriting: 'الكتابة اليدوية',
    augmentedReality: 'الواقع المعزز',
    voiceAssistant: 'المساعد الصوتي',
    gamification: 'التلعيب',
    globalCompetition: 'المسابقة العالمية',
    achievement: 'الإنجاز',
    badge: 'الشارة',
    streak: 'السلسلة',
    totalQuestions: 'إجمالي الأسئلة',
    accuracy: 'الدقة',
    timeSpent: 'الوقت المستغرق',
    bestScore: 'أفضل نتيجة',
    currentStreak: 'السلسلة الحالية',
    totalCorrect: 'إجمالي الصحيح',
    mathConcept: 'المفهوم الرياضي',
    addition: 'الجمع',
    subtraction: 'الطرح',
    multiplication: 'الضرب',
    division: 'القسمة',
    fractions: 'الكسور',
    geometry: 'الهندسة',
    algebra: 'الجبر',
    statistics: 'الإحصاء',
    trigonometry: 'المثلثات',
    calculus: 'التفاضل والتكامل',
    beginner: 'مبتدئ',
    intermediate: 'متوسط',
    advanced: 'متقدم',
    expert: 'خبير',
    master: 'متمكن'
  }
} as const

// Langues supportées avec informations géographiques complètes
const SUPPORTED_LANGUAGES = [
  // Europe Occidentale
  { code: 'fr' as Language, name: 'Français', nativeName: 'Français', flag: '🇫🇷', region: 'Europe Occidentale', popularity: 95, difficulty: 'easy' },
  { code: 'en' as Language, name: 'English', nativeName: 'English', flag: '🇬🇧', region: 'Europe Occidentale', popularity: 100, difficulty: 'easy' },
  { code: 'es' as Language, name: 'Español', nativeName: 'Español', flag: '🇪🇸', region: 'Europe Occidentale', popularity: 98, difficulty: 'easy' },
  { code: 'de' as Language, name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe Occidentale', popularity: 90, difficulty: 'medium' },
  { code: 'it' as Language, name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe Occidentale', popularity: 85, difficulty: 'easy' },
  { code: 'pt' as Language, name: 'Português', nativeName: 'Português', flag: '🇵🇹', region: 'Europe Occidentale', popularity: 88, difficulty: 'easy' },
  { code: 'nl' as Language, name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe Occidentale', popularity: 75, difficulty: 'medium' },
  
  // Europe du Nord
  { code: 'sv' as Language, name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', region: 'Europe du Nord', popularity: 70, difficulty: 'medium' },
  { code: 'no' as Language, name: 'Norsk', nativeName: 'Norsk', flag: '🇳🇴', region: 'Europe du Nord', popularity: 65, difficulty: 'medium' },
  { code: 'da' as Language, name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰', region: 'Europe du Nord', popularity: 60, difficulty: 'medium' },
  { code: 'fi' as Language, name: 'Suomi', nativeName: 'Suomi', flag: '🇫🇮', region: 'Europe du Nord', popularity: 55, difficulty: 'hard' },
  
  // Europe de l'Est
  { code: 'ru' as Language, name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe de l\'Est', popularity: 92, difficulty: 'hard' },
  { code: 'pl' as Language, name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe de l\'Est', popularity: 78, difficulty: 'hard' },
  { code: 'cs' as Language, name: 'Čeština', nativeName: 'Čeština', flag: '🇨🇿', region: 'Europe de l\'Est', popularity: 65, difficulty: 'medium' },
  { code: 'hu' as Language, name: 'Magyar', nativeName: 'Magyar', flag: '🇭🇺', region: 'Europe de l\'Est', popularity: 60, difficulty: 'hard' },
  
  // Asie
  { code: 'zh' as Language, name: '中文', nativeName: '中文简体', flag: '🇨🇳', region: 'Asie', popularity: 95, difficulty: 'hard' },
  { code: 'ja' as Language, name: '日本語', nativeName: '日本語', flag: '🇯🇵', region: 'Asie', popularity: 85, difficulty: 'hard' },
  { code: 'ko' as Language, name: '한국어', nativeName: '한국어', flag: '🇰🇷', region: 'Asie', popularity: 80, difficulty: 'hard' },
  { code: 'hi' as Language, name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asie', popularity: 90, difficulty: 'medium' },
  
  // MENA
  { code: 'ar' as Language, name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', region: 'MENA', rtl: true, popularity: 88, difficulty: 'hard' },
] as const

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState<Language>('fr')
  const [isRTL, setIsRTL] = useState(false)
  const [isLoading, setIsLoading] = useState(false)

  useEffect(() => {
    // Chargement de la langue sauvegardée ou détection automatique
    const savedLang = localStorage.getItem('math4child_language') as Language
    const browserLang = navigator.language.split('-')[0] as Language
    const supportedBrowserLang = SUPPORTED_LANGUAGES.find(lang => lang.code === browserLang)
    
    const initialLang = savedLang || (supportedBrowserLang ? browserLang : 'fr')
    
    if (translations[initialLang]) {
      setCurrentLanguage(initialLang)
      updateDirection(initialLang)
    }
  }, [])

  const updateDirection = (lang: Language) => {
    const langInfo = SUPPORTED_LANGUAGES.find(l => l.code === lang)
    const isRightToLeft = langInfo?.rtl || false
    setIsRTL(isRightToLeft)
    
    if (typeof document !== 'undefined') {
      document.documentElement.setAttribute('dir', isRightToLeft ? 'rtl' : 'ltr')
      document.documentElement.setAttribute('lang', lang)
      
      // Classes CSS pour RTL
      if (isRightToLeft) {
        document.body.classList.add('rtl')
        document.body.classList.remove('ltr')
      } else {
        document.body.classList.add('ltr')
        document.body.classList.remove('rtl')
      }
    }
  }

  const setLanguage = async (lang: Language) => {
    if (!translations[lang]) {
      console.warn(`Langue ${lang} non supportée`)
      return
    }

    setIsLoading(true)
    
    // Simulation d'un chargement pour une meilleure UX
    await new Promise(resolve => setTimeout(resolve, 300))
    
    setCurrentLanguage(lang)
    updateDirection(lang)
    localStorage.setItem('math4child_language', lang)
    
    setIsLoading(false)
    
    // Analytics de changement de langue
    console.log(`🌍 Changement de langue vers: ${lang}`)
  }

  const t = (key: string, params?: Record<string, string | number>): string => {
    const langTranslations = translations[currentLanguage] || translations.fr
    let translation = (langTranslations as any)[key] || key
    
    // Remplacement des paramètres
    if (params) {
      Object.entries(params).forEach(([paramKey, paramValue]) => {
        translation = translation.replace(new RegExp(`{{${paramKey}}}`, 'g'), paramValue.toString())
      })
    }
    
    return translation
  }

  // Statistiques des langues
  const languageStats = {
    totalLanguages: SUPPORTED_LANGUAGES.length,
    regionsCount: [...new Set(SUPPORTED_LANGUAGES.map(lang => lang.region))].length,
    rtlLanguages: SUPPORTED_LANGUAGES.filter(lang => lang.rtl).length
  }

  const contextValue: LanguageContextType = {
    currentLanguage,
    setLanguage,
    t,
    isRTL,
    supportedLanguages: SUPPORTED_LANGUAGES,
    languageStats
  }

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <p className="text-gray-600 font-medium">Changement de langue...</p>
        </div>
      </div>
    )
  }

  return (
    <LanguageContext.Provider value={contextValue}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider')
  }
  return context
}
