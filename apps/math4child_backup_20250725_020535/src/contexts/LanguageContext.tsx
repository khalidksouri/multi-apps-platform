'use client'

import { createContext, useContext, useState, useEffect, ReactNode } from 'react'

interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
}

interface Translation {
  [key: string]: string | Translation
}

interface LanguageContextType {
  currentLanguage: Language
  setLanguage: (code: string) => void
  isRTL: boolean
  availableLanguages: Language[]
  t: Translation
}

const DEFAULT_LANGUAGE: Language = {
  code: 'fr',
  name: 'French', 
  nativeName: 'Français',
  flag: '🇫🇷'
}

const AVAILABLE_LANGUAGES: Language[] = [
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', rtl: true },
  { code: 'he', name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', rtl: true },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺' },
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳' },
]

// Traductions intégrées pour éviter les imports manquants
const BASE_TRANSLATIONS: Record<string, Translation> = {
  fr: {
    subtitle: 'L\'app éducative n°1 pour apprendre les maths en famille !',
    description: 'Plus de 100 000 familles nous font confiance',
    startFree: 'Commencer gratuitement',
    daysFree: ' jours gratuits',
    competitivePrice: 'Prix compétitif',
    competitivePriceDesc: 'Le meilleur rapport qualité-prix',
    competitivePriceStat: '50% moins cher',
    familyManagement: 'Gestion famille',
    familyManagementDesc: 'Jusqu\'à 5 profils enfants',
    familyManagementStat: '5 profils inclus',
    offlineMode: 'Mode hors ligne',
    offlineModeDesc: 'Continuez à apprendre sans internet',
    offlineModeStat: '100% fonctionnel',
    analytics: 'Analytiques avancées',
    analyticsDesc: 'Suivez les progrès en détail',
    analyticsStat: 'Rapports complets'
  },
  en: {
    subtitle: 'The #1 educational app for learning math as a family!',
    description: 'Over 100,000 families trust us',
    startFree: 'Start for free',
    daysFree: ' days free',
    competitivePrice: 'Competitive price',
    competitivePriceDesc: 'Best value for money',
    competitivePriceStat: '50% cheaper',
    familyManagement: 'Family management',
    familyManagementDesc: 'Up to 5 child profiles',
    familyManagementStat: '5 profiles included',
    offlineMode: 'Offline mode',
    offlineModeDesc: 'Continue learning without internet',
    offlineModeStat: '100% functional',
    analytics: 'Advanced analytics',
    analyticsDesc: 'Track progress in detail',
    analyticsStat: 'Complete reports'
  }
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(DEFAULT_LANGUAGE)

  // Charger la langue depuis localStorage au démarrage
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const savedLanguageCode = localStorage.getItem('math4child_language')
      if (savedLanguageCode) {
        const savedLanguage = AVAILABLE_LANGUAGES.find(lang => lang.code === savedLanguageCode)
        if (savedLanguage) {
          setCurrentLanguage(savedLanguage)
        }
      }
    }
  }, [])

  // Sauvegarder la langue dans localStorage
  const setLanguage = (code: string) => {
    const language = AVAILABLE_LANGUAGES.find(lang => lang.code === code)
    if (language) {
      setCurrentLanguage(language)
      if (typeof window !== 'undefined') {
        localStorage.setItem('math4child_language', code)
      }
    }
  }

  const isRTL = currentLanguage?.rtl || false

  // Appliquer la direction RTL au document
  useEffect(() => {
    if (typeof document !== 'undefined') {
      document.documentElement.dir = isRTL ? 'rtl' : 'ltr'
      document.documentElement.lang = currentLanguage?.code || 'fr'
    }
  }, [isRTL, currentLanguage])

  // Traductions sécurisées avec fallback
  const t = BASE_TRANSLATIONS[currentLanguage?.code] || BASE_TRANSLATIONS.fr || {}

  return (
    <LanguageContext.Provider value={{
      currentLanguage,
      setLanguage,
      isRTL,
      availableLanguages: AVAILABLE_LANGUAGES,
      t
    }}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  // Retourner un contexte par défaut si undefined pour éviter les erreurs
  if (context === undefined) {
    console.warn('useLanguage doit être utilisé dans un LanguageProvider')
    return {
      currentLanguage: DEFAULT_LANGUAGE,
      setLanguage: () => {},
      isRTL: false,
      availableLanguages: AVAILABLE_LANGUAGES,
      t: BASE_TRANSLATIONS.fr
    }
  }
  return context
}
