'use client'

import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
}

interface LanguageContextType {
  currentLanguage: Language
  setLanguage: (code: string) => void
  isRTL: boolean
  availableLanguages: Language[]
}

const DEFAULT_LANGUAGE: Language = {
  code: 'fr',
  name: 'French',
  nativeName: 'Français',
  flag: '🇫🇷'
}

const AVAILABLE_LANGUAGES: Language[] = [
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', rtl: true },
  { code: 'he', name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', rtl: true },
  // ... autres langues
]

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(DEFAULT_LANGUAGE)

  // Charger la langue depuis localStorage au démarrage
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const savedLanguageCode = localStorage.getItem('math4child_language')
      if (savedLanguageCode) {
        const savedLanguage = AVAILABLE_LANGUAGES.find(lang => lang.code === savedLanguageCode)
        if (savedLanguage) {
          setCurrentLanguage(savedLanguage)
        }
      }
    }
  }, [])

  // Sauvegarder la langue dans localStorage
  const setLanguage = (code: string) => {
    const language = AVAILABLE_LANGUAGES.find(lang => lang.code === code)
    if (language) {
      setCurrentLanguage(language)
      if (typeof window !== 'undefined') {
        localStorage.setItem('math4child_language', code)
      }
    }
  }

  const isRTL = currentLanguage.rtl || false

  // Appliquer la direction RTL au document
  useEffect(() => {
    if (typeof document !== 'undefined') {
      document.documentElement.dir = isRTL ? 'rtl' : 'ltr'
      document.documentElement.lang = currentLanguage.code
    }
  }, [isRTL, currentLanguage.code])

  return (
    <LanguageContext.Provider value={{
      currentLanguage,
      setLanguage,
      isRTL,
      availableLanguages: AVAILABLE_LANGUAGES
    }}>
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
