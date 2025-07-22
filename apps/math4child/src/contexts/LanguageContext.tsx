'use client'

import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface LanguageContextType {
  currentLanguage: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

// Dictionnaire de traductions basique
const translations: Record<string, Record<string, string>> = {
  fr: {
    'select_language': 'Sélectionner une langue',
    'families_count': '100k+ familles',
    'welcome': 'Bienvenue',
  },
  en: {
    'select_language': 'Select a language',
    'families_count': '100k+ families',
    'welcome': 'Welcome',
  },
  es: {
    'select_language': 'Seleccionar idioma',
    'families_count': '100k+ familias',
    'welcome': 'Bienvenido',
  },
  de: {
    'select_language': 'Sprache auswählen',
    'families_count': '100k+ Familien',
    'welcome': 'Willkommen',
  },
}

interface LanguageProviderProps {
  children: ReactNode
}

export function LanguageProvider({ children }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState('fr')

  // Charger la langue sauvegardée
  useEffect(() => {
    const savedLanguage = localStorage.getItem('math4child-language')
    if (savedLanguage && translations[savedLanguage]) {
      setCurrentLanguage(savedLanguage)
    }
  }, [])

  const setLanguage = (lang: string) => {
    setCurrentLanguage(lang)
    localStorage.setItem('math4child-language', lang)
  }

  const t = (key: string): string => {
    return translations[currentLanguage]?.[key] || key
  }

  return (
    <LanguageContext.Provider value={{ currentLanguage, setLanguage, t }}>
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
