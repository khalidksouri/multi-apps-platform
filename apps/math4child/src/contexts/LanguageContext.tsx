'use client'

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'

export interface LanguageContextType {
  currentLanguage: string
  isRTL: boolean
  t: (key: string, fallback?: string) => string
  changeLanguage: (language: string) => void
  availableLanguages: Array<{
    code: string
    name: string
    nativeName: string
    flag: string
  }>
}

interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
}

const SUPPORTED_LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', rtl: true },
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' }
]

const RTL_LANGUAGES = ['ar', 'he', 'fa', 'ur']

const TRANSLATIONS: Record<string, Record<string, string>> = {
  fr: {
    'game.start': 'Commencer le jeu',
    'game.score': 'Score',
    'nav.home': 'Accueil',
    'common.loading': 'Chargement...'
  },
  en: {
    'game.start': 'Start Game',
    'game.score': 'Score',
    'nav.home': 'Home',
    'common.loading': 'Loading...'
  },
  es: {
    'game.start': 'Empezar Juego',
    'game.score': 'Puntuación',
    'nav.home': 'Inicio',
    'common.loading': 'Cargando...'
  }
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

interface LanguageProviderProps {
  children: ReactNode
  defaultLanguage?: string
}

export function LanguageProvider({ children, defaultLanguage = 'fr' }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState(defaultLanguage)

  const isRTL = RTL_LANGUAGES.includes(currentLanguage)

  const t = (key: string, fallback?: string): string => {
    const translations = TRANSLATIONS[currentLanguage] || TRANSLATIONS['fr']
    return translations[key] || fallback || key
  }

  const changeLanguage = (language: string) => {
    if (SUPPORTED_LANGUAGES.find(lang => lang.code === language)) {
      setCurrentLanguage(language)
      
      if (typeof document !== 'undefined') {
        document.documentElement.lang = language
        document.documentElement.dir = RTL_LANGUAGES.includes(language) ? 'rtl' : 'ltr'
      }
      
      if (typeof localStorage !== 'undefined') {
        localStorage.setItem('math4child-language', language)
      }
    }
  }

  useEffect(() => {
    if (typeof localStorage !== 'undefined') {
      const savedLanguage = localStorage.getItem('math4child-language')
      if (savedLanguage && SUPPORTED_LANGUAGES.find(lang => lang.code === savedLanguage)) {
        changeLanguage(savedLanguage)
      }
    }
  }, [])

  const value: LanguageContextType = {
    currentLanguage,
    isRTL,
    t,
    changeLanguage,
    availableLanguages: SUPPORTED_LANGUAGES
  }

  return (
    <LanguageContext.Provider value={value}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage(): LanguageContextType {
  const context = useContext(LanguageContext)
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider')
  }
  return context
}

export default LanguageContext
