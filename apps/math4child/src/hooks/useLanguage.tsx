"use client"

import { createContext, useContext, useState, ReactNode } from 'react'

type Language = 'fr' | 'en' | 'es'

interface LanguageContextType {
  currentLanguage: Language
  setLanguage: (lang: Language) => void
  t: (key: string) => string
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

const translations = {
  fr: {
    welcome: 'Bienvenue dans Math4Child v4.2.0',
    exercises: 'Exercices Révolutionnaires',
    profile: 'Profil'
  },
  en: {
    welcome: 'Welcome to Math4Child v4.2.0',
    exercises: 'Revolutionary Exercises',
    profile: 'Profile'
  },
  es: {
    welcome: 'Bienvenido a Math4Child v4.2.0',
    exercises: 'Ejercicios Revolucionarios',
    profile: 'Perfil'
  }
}

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState<Language>('fr')

  const setLanguage = (lang: Language) => {
    setCurrentLanguage(lang)
  }

  const t = (key: string): string => {
    return (translations[currentLanguage] as any)[key] || key
  }

  return (
    <LanguageContext.Provider value={{ currentLanguage, setLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (!context) {
    throw new Error('useLanguage must be used within a LanguageProvider')
  }
  return context
}
