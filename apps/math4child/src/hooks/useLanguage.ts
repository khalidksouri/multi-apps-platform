"use client"

import { useState, useEffect } from "react"
import { getTranslation, t as translateFunction } from "@/lib/translations/translations"
import { isRTLLanguage, getTotalLanguages, getLanguageByCode, WORLD_LANGUAGES } from "@/data/languages/worldLanguages"

export function useLanguage() {
  const [language, setLanguageState] = useState("fr")
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    if (typeof window !== "undefined") {
      // Récupérer la langue sauvegardée ou détecter la langue du navigateur
      const savedLanguage = localStorage.getItem("math4child-language")
      const browserLanguage = navigator.language.split('-')[0]
      const hasTranslation = WORLD_LANGUAGES.some(lang => lang.code === browserLanguage)
      
      const initialLanguage = savedLanguage || (hasTranslation ? browserLanguage : "fr")
      setLanguageState(initialLanguage)
      
      // Appliquer la direction RTL/LTR au document
      applyLanguageDirection(initialLanguage)
      
      setIsLoading(false)
    }
  }, [])

  const applyLanguageDirection = (lang: string) => {
    if (typeof document !== "undefined") {
      const isRTL = isRTLLanguage(lang)
      document.documentElement.dir = isRTL ? 'rtl' : 'ltr'
      document.documentElement.lang = lang
      
      // Ajouter classes CSS pour RTL
      if (isRTL) {
        document.body.classList.add('rtl')
        document.body.classList.remove('ltr')
      } else {
        document.body.classList.add('ltr')
        document.body.classList.remove('rtl')
      }
    }
  }

  const setLanguage = (lang: string) => {
    setLanguageState(lang)
    
    if (typeof window !== "undefined") {
      localStorage.setItem("math4child-language", lang)
      applyLanguageDirection(lang)
    }
  }

  const t = (key: string, params?: { [key: string]: string | number }): string => {
    return translateFunction(language, key, params)
  }

  const currentLanguageInfo = getLanguageByCode(language)
  
  return {
    language,
    setLanguage,
    t,
    isRTL: isRTLLanguage(language),
    totalLanguages: getTotalLanguages(),
    currentLanguageInfo,
    isLoading,
    availableLanguages: WORLD_LANGUAGES
  }
}
