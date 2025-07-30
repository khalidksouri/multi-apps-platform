'use client'

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import { translations } from '../translations'
import { SUPPORTED_LANGUAGES, getLanguageStats, isRTL } from '../language-config'
import { SupportedLanguage, Language } from '../types/translations'

interface LanguageContextType {
  currentLanguage: Language
  changeLanguage: (language: SupportedLanguage) => void
  t: typeof translations.fr
  isRTL: boolean
  isLoading: boolean
  stats: ReturnType<typeof getLanguageStats>
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

interface LanguageProviderProps {
  children: ReactNode
}

export function LanguageProvider({ children }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(SUPPORTED_LANGUAGES[0])
  const [isLoading, setIsLoading] = useState(true)
  
  useEffect(() => {
    // Vérification côté client uniquement pour éviter les erreurs SSR
    if (typeof window !== 'undefined') {
      const savedLanguage = localStorage.getItem('multi_apps_language') as SupportedLanguage
      if (savedLanguage && translations[savedLanguage]) {
        const foundLang = SUPPORTED_LANGUAGES.find(lang => lang.code === savedLanguage)
        if (foundLang) {
          setCurrentLanguage(foundLang)
          updateDocumentLanguage(foundLang)
        }
      }
      setIsLoading(false)
    }
  }, [])
  
  const updateDocumentLanguage = (language: Language) => {
    // Vérifications pour éviter les erreurs SSR
    if (typeof document === 'undefined') return
    
    const isLanguageRTL = isRTL(language.code)
    
    // Mise à jour des attributs du document
    document.documentElement.lang = language.code
    document.documentElement.dir = isLanguageRTL ? 'rtl' : 'ltr'
    
    // Mise à jour des classes CSS pour RTL
    if (isLanguageRTL) {
      document.body.classList.add('rtl')
      document.body.classList.remove('ltr')
    } else {
      document.body.classList.add('ltr')
      document.body.classList.remove('rtl')
    }
  }
  
  const changeLanguage = (languageCode: SupportedLanguage) => {
    const language = SUPPORTED_LANGUAGES.find(lang => lang.code === languageCode)
    if (!language) return
    
    setCurrentLanguage(language)
    
    // Sauvegarde côté client uniquement
    if (typeof window !== 'undefined') {
      localStorage.setItem('multi_apps_language', languageCode)
      
      // Événement personnalisé pour les composants qui écoutent
      window.dispatchEvent(new CustomEvent('languageChange', { detail: language }))
    }
    
    updateDocumentLanguage(language)
  }
  
  const t = translations[currentLanguage.code as SupportedLanguage] || translations.en
  
  return (
    <LanguageContext.Provider value={{
      currentLanguage,
      changeLanguage,
      t,
      isRTL: isRTL(currentLanguage.code),
      isLoading,
      stats: getLanguageStats()
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
