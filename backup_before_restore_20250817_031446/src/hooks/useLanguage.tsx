"use client"

import { useState } from 'react'

// Hook useLanguage autonome (sans contexte pour éviter les erreurs)
export function useLanguage() {
  const [currentLanguage] = useState('fr-FR')
  const [isRTL] = useState(false)
  const [isLoading] = useState(false)

  const supportedLanguages = [
    { code: 'fr-FR', name: 'Français', flag: '🇫🇷', continent: 'Europe' },
    { code: 'en-US', name: 'English', flag: '🇺🇸', continent: 'Global' },
    { code: 'es-ES', name: 'Español', flag: '🇪🇸', continent: 'Europe' }
  ]

  const setLanguage = (lang: string) => {
    console.log('🌍 Changement de langue vers:', lang)
  }

  const t = (key: string): string => {
    const translations: Record<string, string> = {
      'app_title': 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
      'select_language': 'Sélectionner une langue',
      'start_learning': 'Commencer l\'apprentissage',
      'view_plans': 'Voir les plans'
    }
    return translations[key] || key
  }

  const getLanguagesByContinent = (continent: string) => {
    return supportedLanguages.filter(lang => lang.continent === continent)
  }

  return {
    currentLanguage,
    setLanguage,
    t,
    isRTL,
    supportedLanguages,
    getLanguagesByContinent,
    isLoading
  }
}

// Export factice pour satisfaire TypeScript (ne sera pas utilisé)
export function LanguageProvider({ children }: { children: React.ReactNode }) {
  return <>{children}</>
}
