'use client'
import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface Language {
  code: string
  name: string
  flag: string
  rtl?: boolean
}

interface LanguageContextType {
  currentLanguage: Language
  setLanguage: (language: Language) => void
  availableLanguages: Language[]
  isRTL: boolean
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', flag: '🇵🇹' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺' }
]

interface LanguageProviderProps {
  children: ReactNode
  defaultLanguage?: string
}

export function LanguageProvider({ children, defaultLanguage = 'fr' }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(
    LANGUAGES.find(lang => lang.code === defaultLanguage) || LANGUAGES[0]
  )

  const setLanguage = (language: Language) => {
    setCurrentLanguage(language)
    if (typeof document !== 'undefined') {
      document.documentElement.lang = language.code
      document.documentElement.dir = language.rtl ? 'rtl' : 'ltr'
    }
    
    if (typeof window !== 'undefined') {
      localStorage.setItem('preferred-language', language.code)
    }
  }

  useEffect(() => {
    if (typeof window !== 'undefined') {
      const savedLanguage = localStorage.getItem('preferred-language')
      if (savedLanguage) {
        const language = LANGUAGES.find(lang => lang.code === savedLanguage)
        if (language) {
          setLanguage(language)
        }
      }
    }
  }, [])

  const value: LanguageContextType = {
    currentLanguage,
    setLanguage,
    availableLanguages: LANGUAGES,
    isRTL: currentLanguage.rtl || false
  }

  return (
    <LanguageContext.Provider value={value}>
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
