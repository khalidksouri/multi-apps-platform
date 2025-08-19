'use client'
import React, { createContext, useState, useEffect, ReactNode } from 'react'

export interface LanguageContextType {
  language: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
}

export const LanguageContext = createContext<LanguageContextType | null>(null)

interface LanguageProviderProps {
  children: ReactNode
}

const translations = {
  fr: {
    welcome: 'Bienvenue sur Math4Child',
    start: 'Commencer',
    exercises: 'Exercices',
    handwriting: 'Manuscrit',
    voice: 'Vocal',
    ar3d: 'AR 3D'
  },
  en: {
    welcome: 'Welcome to Math4Child',
    start: 'Start',
    exercises: 'Exercises',
    handwriting: 'Handwriting',
    voice: 'Voice',
    ar3d: 'AR 3D'
  }
}

export const LanguageProvider: React.FC<LanguageProviderProps> = ({ children }) => {
  const [language, setLanguage] = useState('fr')

  const t = (key: string): string => {
    return translations[language as keyof typeof translations]?.[key as keyof typeof translations.fr] || key
  }

  useEffect(() => {
    const savedLang = localStorage.getItem('math4child-language') || 'fr'
    setLanguage(savedLang)
  }, [])

  const handleSetLanguage = (lang: string) => {
    setLanguage(lang)
    localStorage.setItem('math4child-language', lang)
  }

  return (
    <LanguageContext.Provider value={{ language, setLanguage: handleSetLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  )
}

export default LanguageProvider
