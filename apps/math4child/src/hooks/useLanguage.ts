"use client"

import { useState, useEffect } from "react"
import { WORLD_LANGUAGES, getTotalLanguages } from "@/data/languages/worldLanguages"
import { getTranslation } from "@/lib/translations/worldTranslations"

export function useLanguage() {
  const [language, setLanguageState] = useState("fr")
  const [isRTL, setIsRTL] = useState(false)

  useEffect(() => {
    if (typeof window !== "undefined") {
      const savedLanguage = localStorage.getItem("math4child-language") || "fr"
      setLanguageState(savedLanguage)
    }
  }, [])

  const setLanguage = (lang: string) => {
    setLanguageState(lang)
    if (typeof window !== "undefined") {
      localStorage.setItem("math4child-language", lang)
    }
  }

  const t = (key: string): string => {
    return getTranslation(language, key)
  }

  const currentLanguageInfo = WORLD_LANGUAGES.find(lang => lang.code === language)

  return {
    language,
    setLanguage,
    t,
    isRTL,
    availableLanguages: WORLD_LANGUAGES,
    currentLanguageInfo,
    totalLanguages: getTotalLanguages()
  }
}
