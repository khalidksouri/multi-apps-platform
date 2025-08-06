"use client"

import { createContext, useContext, useState, useEffect } from "react"
import { WORLD_LANGUAGES, isRTLLanguage, getTotalLanguages } from "@/data/languages/worldLanguages"
import { getTranslation, getSupportedTranslationLanguages } from "@/lib/translations/worldTranslations"

interface LanguageContextType {
  language: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
  isRTL: boolean
  availableLanguages: typeof WORLD_LANGUAGES
  currentLanguageInfo: typeof WORLD_LANGUAGES[0] | undefined
  totalLanguages: number
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export function LanguageProvider({ children }: { children: React.ReactNode }) {
  const [language, setLanguageState] = useState("fr")
  const [isRTL, setIsRTL] = useState(false)

  useEffect(() => {
    if (typeof window !== "undefined") {
      const savedLanguage = localStorage.getItem("math4child-language") || "fr"
      setLanguageState(savedLanguage)
      setIsRTL(isRTLLanguage(savedLanguage))
      
      if (typeof document !== "undefined") {
        document.documentElement.dir = isRTLLanguage(savedLanguage) ? "rtl" : "ltr"
        document.documentElement.lang = savedLanguage
      }
    }
  }, [])

  const setLanguage = (lang: string) => {
    setLanguageState(lang)
    const rtl = isRTLLanguage(lang)
    setIsRTL(rtl)
    
    if (typeof document !== "undefined") {
      document.documentElement.dir = rtl ? "rtl" : "ltr"
      document.documentElement.lang = lang
    }
    
    if (typeof window !== "undefined") {
      localStorage.setItem("math4child-language", lang)
    }
  }

  const t = (key: string): string => {
    return getTranslation(language, key)
  }

  const currentLanguageInfo = WORLD_LANGUAGES.find(lang => lang.code === language)

  const contextValue: LanguageContextType = {
    language,
    setLanguage,
    t,
    isRTL,
    availableLanguages: WORLD_LANGUAGES,
    currentLanguageInfo,
    totalLanguages: getTotalLanguages()
  }

  return (
    <LanguageContext.Provider value={contextValue}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (context === undefined) {
    throw new Error("useLanguage must be used within a LanguageProvider")
  }
  return context
}