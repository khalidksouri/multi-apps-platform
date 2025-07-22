'use client'

import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface LanguageContextType {
  currentLanguage: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

const translations: Record<string, Record<string, string>> = {
  fr: { 
    'welcome': 'Bienvenue', 
    'select_language': 'Choisir une langue',
    'math_learning': 'Apprentissage des mathématiques',
    'families_trust': '100k+ familles nous font confiance'
  },
  en: { 
    'welcome': 'Welcome', 
    'select_language': 'Choose a language',
    'math_learning': 'Math learning',
    'families_trust': '100k+ families trust us'
  },
  es: { 
    'welcome': 'Bienvenido', 
    'select_language': 'Elegir idioma',
    'math_learning': 'Aprendizaje matemático',
    'families_trust': '100k+ familias confían en nosotros'
  },
  de: { 
    'welcome': 'Willkommen', 
    'select_language': 'Sprache wählen',
    'math_learning': 'Mathematik lernen',
    'families_trust': '100k+ Familien vertrauen uns'
  },
  it: { 
    'welcome': 'Benvenuto', 
    'select_language': 'Scegli lingua',
    'math_learning': 'Apprendimento matematico',
    'families_trust': '100k+ famiglie si fidano di noi'
  },
  pt: { 
    'welcome': 'Bem-vindo', 
    'select_language': 'Escolher idioma',
    'math_learning': 'Aprendizagem matemática',
    'families_trust': '100k+ famílias confiam em nós'
  },
}

interface LanguageProviderProps {
  children: ReactNode
}

export function LanguageProvider({ children }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState('fr')

  useEffect(() => {
    // Charger la langue sauvegardée
    const savedLanguage = localStorage.getItem('math4child-language')
    if (savedLanguage && translations[savedLanguage]) {
      setCurrentLanguage(savedLanguage)
    } else {
      // Détecter la langue du navigateur
      const browserLang = navigator.language.split('-')[0]
      if (translations[browserLang]) {
        setCurrentLanguage(browserLang)
      }
    }
  }, [])

  const setLanguage = (lang: string) => {
    setCurrentLanguage(lang)
    localStorage.setItem('math4child-language', lang)
    
    // Log pour debug
    console.log('🌍 Langue changée vers:', lang)
    
    // Feedback haptic
    if ('vibrate' in navigator) {
      navigator.vibrate(50)
    }
  }

  const t = (key: string): string => {
    return translations[currentLanguage]?.[key] || translations['en']?.[key] || key
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
