/**
 * Types pour le système de traductions Math4Child - Version finale
 */

export interface Language {
  code: string
  name: string
  flag: string
  rtl?: boolean
  region?: string
}

export interface TranslationKey {
  // Navigation
  home: string
  exercises: string
  progress: string
  settings: string
  help: string
  
  // App principale
  appName: string
  tagline: string
  startLearning: string
  welcomeMessage: string
  description: string
  
  // Marketing
  badge: string
  startFree: string
  freeTrial: string
  viewPlans: string
  choosePlan: string
  familiesCount: string
  
  // Pricing
  pricing: string
  monthly: string
  quarterly: string
  annual: string
  save: string
  mostPopular: string
  recommended: string
  
  // Plans
  freeVersion: string
  premiumPlan: string
  familyPlan: string
  free: string
  
  // Footer
  testimonials: string
  faq: string
  featuresFooter: string
  contact: string
  allRightsReserved: string
  
  // Math operations
  addition: string
  subtraction: string
  multiplication: string
  division: string
  
  // Levels
  beginner: string
  intermediate: string
  advanced: string
  expert: string
  master: string
  
  // Game interface
  score: string
  level: string
  streak: string
  timeLeft: string
  correct: string
  incorrect: string
  congratulations: string
  
  // Actions
  next: string
  previous: string
  continue: string
  restart: string
  quit: string
  play: string
  pause: string
  
  // Common
  yes: string
  no: string
  ok: string
  cancel: string
  loading: string
  error: string
  
  // Stats
  gamesPlayed: string
  averageScore: string
  totalTime: string
  bestStreak: string
  
  // Messages
  welcome: string
  goodJob: string
  tryAgain: string
  levelComplete: string
  newRecord: string
}

export interface Translations {
  [languageCode: string]: TranslationKey
}

// Types pour le contexte de langue (si nécessaire)
export interface LanguageContextType {
  currentLanguage: Language
  changeLanguage: (code: string) => void
  t: (key: keyof TranslationKey) => string
  isRTL: boolean
  availableLanguages: Language[]
}

// Types utilitaires
export interface LanguageStats {
  totalLanguages: number
  rtlLanguages: number
  regions: string[]
}
