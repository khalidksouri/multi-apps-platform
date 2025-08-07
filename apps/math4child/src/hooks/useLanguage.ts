"use client"

import { useState, useEffect } from "react"

export function useLanguage() {
  const [language, setLanguageState] = useState("fr")

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
    const translations: { [key: string]: { [lang: string]: string } } = {
      title: {
        fr: "Math4Child - Apprendre les maths en s'amusant !",
        en: "Math4Child - Learn math while having fun!",
        ar: "Math4Child - تعلم الرياضيات والمرح!"
      },
      subtitle: {
        fr: "L'application éducative révolutionnaire pour apprendre les mathématiques",
        en: "The revolutionary educational app for learning mathematics",
        ar: "التطبيق التعليمي الثوري لتعلم الرياضيات"
      }
    }
    
    return translations[key]?.[language] || translations[key]?.["fr"] || key
  }

  return {
    language,
    setLanguage,
    t,
    isRTL: language === "ar",
    totalLanguages: 195
  }
}
