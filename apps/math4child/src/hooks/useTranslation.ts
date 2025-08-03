'use client'

import { useState, useEffect, useCallback } from 'react'
import { translations } from '../translations'
import { TranslationKey } from '../types/translations'

export interface Language {
  code: string
  name: string
  flag: string
  rtl?: boolean
  region?: string
}

// 25 LANGUES MONDIALES (toutes sauf hébreu selon les specs)
const SUPPORTED_LANGUAGES: Language[] = [
  // Europe (13 langues)
  { code: 'fr', name: 'Français', flag: '🇫🇷', region: 'Europe' },
  { code: 'en', name: 'English', flag: '🇺🇸', region: 'World' },
  { code: 'es', name: 'Español', flag: '🇪🇸', region: 'Europe' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', region: 'Europe' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', region: 'Europe' },
  { code: 'pt', name: 'Português', flag: '🇵🇹', region: 'Europe' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱', region: 'Europe' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺', region: 'Europe' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱', region: 'Europe' },
  { code: 'sv', name: 'Svenska', flag: '🇸🇪', region: 'Europe' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰', region: 'Europe' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴', region: 'Europe' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮', region: 'Europe' },
  
  // Asie (8 langues)
  { code: 'zh', name: '中文', flag: '🇨🇳', region: 'Asie' },
  { code: 'ja', name: '日本語', flag: '🇯🇵', region: 'Asie' },
  { code: 'ko', name: '한국어', flag: '🇰🇷', region: 'Asie' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', region: 'Asie' },
  { code: 'th', name: 'ไทย', flag: '🇹🇭', region: 'Asie' },
  { code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳', region: 'Asie' },
  { code: 'id', name: 'Bahasa Indonesia', flag: '🇮🇩', region: 'Asie' },
  { code: 'ms', name: 'Bahasa Melayu', flag: '🇲🇾', region: 'Asie' },
  
  // Moyen-Orient & Afrique (3 langues RTL - PAS d'hébreu selon specs)
  { code: 'ar', name: 'العربية', flag: '🇲🇦', region: 'Moyen-Orient', rtl: true }, // Drapeau marocain
  { code: 'fa', name: 'فارسی', flag: '🇮🇷', region: 'Moyen-Orient', rtl: true },
  { code: 'ur', name: 'اردو', flag: '🇵🇰', region: 'Moyen-Orient', rtl: true },
  
  // Autres (2 langues)
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷', region: 'Autres' },
  { code: 'sw', name: 'Kiswahili', flag: '🇰🇪', region: 'Afrique' },
]

// Langue par défaut
const DEFAULT_LANGUAGE: Language = SUPPORTED_LANGUAGES.find(lang => lang.code === 'fr') || SUPPORTED_LANGUAGES[0]

export function useTranslation() {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(DEFAULT_LANGUAGE)

  // Fonction de traduction sécurisée
  const t = useCallback((key: keyof TranslationKey): string => {
    try {
      const translation = translations[currentLanguage.code]
      if (translation && translation[key]) {
        return translation[key]
      }
      
      // Fallback vers l'anglais
      const fallback = translations['en']
      if (fallback && fallback[key]) {
        return fallback[key]
      }
      
      // Fallback vers le français
      const frenchFallback = translations['fr']
      if (frenchFallback && frenchFallback[key]) {
        return frenchFallback[key]
      }
      
      // Retourner la clé si aucune traduction trouvée
      return String(key)
    } catch (error) {
      console.error('Erreur de traduction:', error)
      return String(key)
    }
  }, [currentLanguage])

  // Changer de langue avec gestion d'erreur
  const changeLanguage = useCallback((languageCode: string) => {
    try {
      const language = SUPPORTED_LANGUAGES.find(lang => lang.code === languageCode)
      if (language) {
        setCurrentLanguage(language)
        
        // Persister en localStorage avec gestion d'erreur
        if (typeof window !== 'undefined') {
          try {
            localStorage.setItem('math4child-language', languageCode)
            document.documentElement.lang = languageCode
            document.documentElement.dir = language.rtl ? 'rtl' : 'ltr'
          } catch (storageError) {
            console.warn('Impossible de sauvegarder la langue:', storageError)
          }
        }
      }
    } catch (error) {
      console.error('Erreur lors du changement de langue:', error)
    }
  }, [])

  // Charger la langue sauvegardée au démarrage
  useEffect(() => {
    if (typeof window !== 'undefined') {
      try {
        const savedLanguage = localStorage.getItem('math4child-language')
        if (savedLanguage && translations[savedLanguage]) {
          changeLanguage(savedLanguage)
        } else {
          // Détecter la langue du navigateur
          const browserLanguage = navigator.language.split('-')[0]
          if (translations[browserLanguage]) {
            changeLanguage(browserLanguage)
          }
        }
      } catch (error) {
        console.warn('Impossible de charger la langue sauvegardée:', error)
        setCurrentLanguage(DEFAULT_LANGUAGE)
      }
    }
  }, [changeLanguage])

  // Fonctions utilitaires
  const getLanguagesByRegion = useCallback(() => {
    const regions: { [key: string]: Language[] } = {}
    SUPPORTED_LANGUAGES.forEach(lang => {
      const region = lang.region || 'Autres'
      if (!regions[region]) regions[region] = []
      regions[region].push(lang)
    })
    return regions
  }, [])

  const getRTLLanguages = useCallback(() => {
    return SUPPORTED_LANGUAGES.filter(lang => lang.rtl)
  }, [])

  return {
    t,
    currentLanguage,
    changeLanguage,
    availableLanguages: SUPPORTED_LANGUAGES,
    isRTL: currentLanguage.rtl || false,
    getLanguagesByRegion,
    getRTLLanguages,
    totalLanguages: SUPPORTED_LANGUAGES.length
  }
}

// Export des constantes pour utilisation externe
export { SUPPORTED_LANGUAGES, DEFAULT_LANGUAGE }
