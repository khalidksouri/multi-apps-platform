'use client'

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import { translations, SUPPORTED_LANGUAGES, SupportedLanguage } from '@/lib/translations/comprehensive'

interface LanguageContextType {
  currentLanguage: SupportedLanguage
  changeLanguage: (language: SupportedLanguage) => void
  t: typeof translations.fr
  isRTL: boolean
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

interface LanguageProviderProps {
  children: ReactNode
}

export function LanguageProvider({ children }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState<SupportedLanguage>('fr')
  
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const savedLanguage = localStorage.getItem('math4child_language') as SupportedLanguage
      if (savedLanguage && translations[savedLanguage]) {
        setCurrentLanguage(savedLanguage)
        updateDocumentLanguage(savedLanguage)
      }
    }
  }, [])
  
  const updateDocumentLanguage = (language: SupportedLanguage) => {
    if (typeof document === 'undefined') return
    
    const langData = SUPPORTED_LANGUAGES.find(lang => lang.code === language)
    const isRTL = langData?.rtl || false
    
    document.documentElement.lang = language
    document.documentElement.dir = isRTL ? 'rtl' : 'ltr'
    
    if (isRTL) {
      document.body.classList.add('rtl')
      document.body.classList.remove('ltr')
    } else {
      document.body.classList.add('ltr')
      document.body.classList.remove('rtl')
    }
  }
  
  const changeLanguage = (language: SupportedLanguage) => {
    setCurrentLanguage(language)
    if (typeof window !== 'undefined') {
      localStorage.setItem('math4child_language', language)
    }
    updateDocumentLanguage(language)
    
    if (typeof window !== 'undefined') {
      window.dispatchEvent(new CustomEvent('languageChange', { detail: language }))
    }
  }
  
  const currentLangData = SUPPORTED_LANGUAGES.find(lang => lang.code === currentLanguage)
  const isRTL = currentLangData?.rtl || false
  const t = translations[currentLanguage]
  
  return (
    <LanguageContext.Provider value={{
      currentLanguage,
      changeLanguage,
      t,
      isRTL
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
