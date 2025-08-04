/**
 * Types pour le système de traductions Math4Child
 * Système multilingue avec support RTL complet
 */

export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
  region?: string
}

export interface TranslationKeys {
  // Navigation
  home: string
  exercises: string
  progress: string
  settings: string
  help: string
  
  // Math4Child specifique
  appName: string
  tagline: string
  startLearning: string
  welcomeMessage: string
  description: string
  
  // Opérations mathématiques
  addition: string
  subtraction: string
  multiplication: string
  division: string
  
  // Niveaux de difficulté
  beginner: string
  intermediate: string
  advanced: string
  expert: string
  master: string
  
  // Interface de jeu
  score: string
  level: string
  streak: string
  timeLeft: string
  correct: string
  incorrect: string
  congratulations: string
  
  // Boutons et actions
  next: string
  previous: string
  continue: string
  restart: string
  quit: string
  play: string
  pause: string
  
  // Interface générale
  yes: string
  no: string
  ok: string
  cancel: string
  save: string
  load: string
  loading: string
  error: string
  
  // Statistiques
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

export interface LanguageStats {
  total: number
  rtl: number
  ltr: number
  regions: number
}

export interface LanguageContextType {
  currentLanguage: Language
  translations: TranslationKeys
  t: TranslationKeys
  changeLanguage: (code: string) => void
  isRTL: boolean
  stats: LanguageStats
  availableLanguages: Language[]
  isLoading: boolean
}

export type SupportedLanguage = Language
export type Translations = Record<string, TranslationKeys>

// Constantes pour l'export
export const RTL_LANGUAGES = ['ar', 'he', 'fa', 'ur'] as const
export const DEFAULT_LANGUAGE = 'fr' as const
