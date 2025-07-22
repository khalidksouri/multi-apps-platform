import { useState, useEffect } from 'react'

interface Language {
  code: string
  name: string
  flag: string
  rtl?: boolean
}

interface UseLanguageReturn {
  currentLanguage: Language | null
  setLanguage: (language: Language) => void
  isRTL: boolean
  getTranslation: (key: string) => string
}

const translations: Record<string, Record<string, string>> = {
  fr: {
    appName: 'Math4Child',
    tagline: "L'app éducative n°1 pour apprendre les maths en famille !",
    startFree: 'Commencer gratuitement',
    familiesCount: '100k+ familles nous font confiance'
  },
  en: {
    appName: 'Math4Child',
    tagline: 'The #1 educational app for learning math as a family!',
    startFree: 'Start Free',
    familiesCount: '100k+ families trust us'
  },
  es: {
    appName: 'Math4Child',
    tagline: '¡La app educativa n°1 para aprender matemáticas en familia!',
    startFree: 'Comenzar gratis',
    familiesCount: '100k+ familias confían en nosotros'
  },
  de: {
    appName: 'Math4Child',
    tagline: 'Die #1 Lern-App für Mathematik für die ganze Familie!',
    startFree: 'Kostenlos starten',
    familiesCount: '100k+ Familien vertrauen uns'
  },
  pt: {
    appName: 'Math4Child',
    tagline: 'O app educacional nº1 para aprender matemática em família!',
    startFree: 'Começar grátis',
    familiesCount: '100k+ famílias confiam em nós'
  },
  ar: {
    appName: 'Math4Child',
    tagline: 'تطبيق التعليم رقم 1 لتعلم الرياضيات مع العائلة!',
    startFree: 'ابدأ مجاناً',
    familiesCount: '100 ألف+ عائلة تثق بنا'
  },
  zh: {
    appName: 'Math4Child',
    tagline: '全家一起学数学的第一教育应用！',
    startFree: '免费开始',
    familiesCount: '10万+家庭信任我们'
  }
}

export function useLanguage(defaultLang = 'en'): UseLanguageReturn {
  const [currentLanguage, setCurrentLanguage] = useState<Language | null>(null)

  useEffect(() => {
    // Charger la langue depuis localStorage ou utiliser la langue par défaut
    const savedLang = typeof window !== 'undefined' ? localStorage.getItem('math4child-language') : null
    const langCode = savedLang || defaultLang
    
    // Trouver la langue correspondante (vous devrez importer la liste des langues)
    const defaultLanguage = {
      code: langCode,
      name: langCode === 'fr' ? 'Français' : 'English',
      flag: langCode === 'fr' ? '🇫🇷' : '🇺🇸'
    }
    
    setCurrentLanguage(defaultLanguage)
  }, [defaultLang])

  const setLanguage = (language: Language) => {
    setCurrentLanguage(language)
    if (typeof window !== 'undefined') {
      localStorage.setItem('math4child-language', language.code)
    }
  }

  const isRTL = currentLanguage?.rtl || false

  const getTranslation = (key: string): string => {
    if (!currentLanguage) return key
    
    const langTranslations = translations[currentLanguage.code]
    return langTranslations?.[key] || translations.en?.[key] || key
  }

  return {
    currentLanguage,
    setLanguage,
    isRTL,
    getTranslation
  }
}
