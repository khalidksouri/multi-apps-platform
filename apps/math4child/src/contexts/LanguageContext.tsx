'use client'

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'

export interface Language {
  code: string
  name: string
  nativeName: string
  direction: 'ltr' | 'rtl'
}

interface LanguageContextType {
  currentLanguage: string
  changeLanguage: (language: string) => void
  t: (key: string, fallback?: string) => string
  availableLanguages: Language[]
}

const SUPPORTED_LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', direction: 'ltr' },
  { code: 'en', name: 'English', nativeName: 'English', direction: 'ltr' },
  { code: 'es', name: 'Español', nativeName: 'Español', direction: 'ltr' }
]

const TRANSLATIONS: Record<string, Record<string, string>> = {
  fr: {
    'home.title': 'Math4Child',
    'home.subtitle': 'Apprendre les mathématiques en s\'amusant',
    'home.startFree': 'Commencer gratuitement',
    'home.comparePrices': 'Voir les prix',
  },
  en: {
    'home.title': 'Math4Child',
    'home.subtitle': 'Learn mathematics while having fun',
    'home.startFree': 'Start for free',
    'home.comparePrices': 'Compare prices',
  },
  es: {
    'home.title': 'Math4Child',
    'home.subtitle': 'Aprende matemáticas divirtiéndote',
    'home.startFree': 'Empezar gratis',
    'home.comparePrices': 'Comparar precios',
  }
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

interface LanguageProviderProps {
  children: ReactNode
  defaultLanguage?: string
}

export function LanguageProvider({ children, defaultLanguage = 'fr' }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState(defaultLanguage)

  const t = (key: string, fallback?: string): string => {
    const translations = TRANSLATIONS[currentLanguage] || TRANSLATIONS.fr
    return translations[key] || fallback || key
  }

  const changeLanguage = (language: string) => {
    if (SUPPORTED_LANGUAGES.some(lang => lang.code === language)) {
      setCurrentLanguage(language)
    }
  }

  const value: LanguageContextType = {
    currentLanguage,
    changeLanguage,
    t,
    availableLanguages: SUPPORTED_LANGUAGES,
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
