'use client'

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import { translations } from '../translations'
import { 
  SUPPORTED_LANGUAGES, 
  getLanguageStats, 
  isRTL, 
  DEFAULT_LANGUAGE,
  getLanguageByCode 
} from '../language-config'
import { 
  Language, 
  LanguageContextType, 
  TranslationKeys,
  LanguageStats
} from '../types/translations'

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

interface LanguageProviderProps {
  children: ReactNode
}

export const LanguageProvider: React.FC<LanguageProviderProps> = ({ children }) => {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(() => {
    return SUPPORTED_LANGUAGES.find(lang => lang.code === DEFAULT_LANGUAGE) || SUPPORTED_LANGUAGES[0]
  })
  const [isLoading, setIsLoading] = useState(true)

  // Charger la langue sauvegardée au démarrage
  useEffect(() => {
    if (typeof window !== 'undefined') {
      setIsLoading(true)
      
      try {
        const savedLanguage = localStorage.getItem('math4child_language')
        if (savedLanguage) {
          const foundLang = getLanguageByCode(savedLanguage)
          if (foundLang) {
            setCurrentLanguage(foundLang)
          }
        } else {
          // Détecter la langue du navigateur
          const browserLang = navigator.language.split('-')[0]
          const foundLang = getLanguageByCode(browserLang)
          if (foundLang) {
            setCurrentLanguage(foundLang)
          }
        }
      } catch (error) {
        console.warn('Erreur lors du chargement de la langue:', error)
      } finally {
        setIsLoading(false)
      }
    } else {
      setIsLoading(false)
    }
  }, [])

  // Sauvegarder la langue et appliquer les styles RTL
  useEffect(() => {
    if (typeof window !== 'undefined' && !isLoading) {
      try {
        localStorage.setItem('math4child_language', currentLanguage.code)
        
        // Appliquer le style RTL
        const html = document.documentElement
        if (currentLanguage.rtl) {
          html.setAttribute('dir', 'rtl')
          html.style.direction = 'rtl'
          html.lang = currentLanguage.code
        } else {
          html.setAttribute('dir', 'ltr')
          html.style.direction = 'ltr'
          html.lang = currentLanguage.code
        }
      } catch (error) {
        console.warn('Erreur lors de la sauvegarde de la langue:', error)
      }
    }
  }, [currentLanguage, isLoading])

  const changeLanguage = (languageCode: string) => {
    const language = getLanguageByCode(languageCode)
    if (language) {
      setCurrentLanguage(language)
    }
  }

  // Récupérer les traductions pour la langue actuelle
  const getTranslations = (): TranslationKeys => {
    const langTranslations = translations[currentLanguage.code]
    if (!langTranslations) {
      console.warn(`Traductions manquantes pour ${currentLanguage.code}, utilisation du fallback anglais`)
      return translations['en'] || {} as TranslationKeys
    }
    return langTranslations
  }

  const contextValue: LanguageContextType = {
    currentLanguage,
    translations: getTranslations(),
    t: getTranslations(),
    changeLanguage,
    isRTL: currentLanguage.rtl || false,
    stats: getLanguageStats(),
    availableLanguages: SUPPORTED_LANGUAGES,
    isLoading,
  }

  return (
    <LanguageContext.Provider value={contextValue}>
      {children}
    </LanguageContext.Provider>
  )
}

export const useLanguage = (): LanguageContextType => {
  const context = useContext(LanguageContext)
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider')
  }
  return context
}

export default LanguageProvider
