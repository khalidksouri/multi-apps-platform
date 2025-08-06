"use client"

import { createContext, useContext, useState, useEffect, ReactNode } from "react"
import { WORLD_LANGUAGES, isRTLLanguage } from "@/data/languages/worldLanguages"
import { getTranslation } from "@/lib/translations/worldTranslations"

interface LanguageContextType {
  language: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
  isRTL: boolean
  availableLanguages: typeof WORLD_LANGUAGES
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [language, setLanguageState] = useState("fr")
  const [isRTL, setIsRTL] = useState(false)

  useEffect(() => {
    if (typeof navigator !== "undefined") {
      const browserLang = navigator.language.split("-")[0]
      const supportedLang = WORLD_LANGUAGES.find(lang => 
        lang.code.startsWith(browserLang)
      )?.code || "fr"
      
      setLanguageState(supportedLang)
      setIsRTL(isRTLLanguage(supportedLang))
      
      if (typeof document !== "undefined") {
        document.documentElement.dir = isRTLLanguage(supportedLang) ? "rtl" : "ltr"
        document.documentElement.lang = supportedLang
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

  const contextValue: LanguageContextType = {
    language,
    setLanguage,
    t,
    isRTL,
    availableLanguages: WORLD_LANGUAGES
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
