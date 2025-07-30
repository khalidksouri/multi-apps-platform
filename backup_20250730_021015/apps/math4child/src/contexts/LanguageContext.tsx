'use client'

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface LanguageContextType {
  currentLanguage: string
  setLanguage: (language: string) => void
  isRTL: boolean
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    const savedLanguage = localStorage.getItem('math4child-language')
    if (savedLanguage) setCurrentLanguage(savedLanguage)
  }, [])

  const setLanguage = (language: string) => {
    setCurrentLanguage(language)
    if (mounted) localStorage.setItem('math4child-language', language)
  }

  return (
    <LanguageContext.Provider value={{ currentLanguage, setLanguage, isRTL: currentLanguage === 'ar' }}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (!context) throw new Error('useLanguage must be used within a LanguageProvider')
  return context
}
