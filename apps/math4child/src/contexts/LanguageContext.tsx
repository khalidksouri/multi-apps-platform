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
  { code: 'es', name: 'Español', nativeName: 'Español', direction: 'ltr' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', direction: 'ltr' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', direction: 'ltr' },
  { code: 'pt', name: 'Português', nativeName: 'Português', direction: 'ltr' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', direction: 'rtl' },
]

const TRANSLATIONS: Record<string, Record<string, string>> = {
  fr: {
    'language.search': 'Rechercher une langue...',
    'language.noResults': 'Aucune langue trouvée',
    'home.title': 'Math4Child',
    'home.subtitle': 'Apprendre les mathématiques en s\'amusant',
    'home.startFree': 'Commencer gratuitement',
    'home.comparePrices': 'Voir les prix',
  },
  en: {
    'language.search': 'Search language...',
    'language.noResults': 'No language found',
    'home.title': 'Math4Child',
    'home.subtitle': 'Learn mathematics while having fun',
    'home.startFree': 'Start for free',
    'home.comparePrices': 'Compare prices',
  },
  es: {
    'language.search': 'Buscar idioma...',
    'language.noResults': 'Ningún idioma encontrado',
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
      
      if (typeof window !== 'undefined' && window.localStorage) {
        try {
          localStorage.setItem('preferred-language', language)
        } catch (e) {
          // Ignore localStorage errors
        }
      }
    }
  }

  useEffect(() => {
    if (typeof window !== 'undefined' && window.localStorage) {
      try {
        const savedLanguage = localStorage.getItem('preferred-language')
        if (savedLanguage && SUPPORTED_LANGUAGES.some(lang => lang.code === savedLanguage)) {
          setCurrentLanguage(savedLanguage)
        }
      } catch (e) {
        // Ignore localStorage errors
      }
    }
  }, [])

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
