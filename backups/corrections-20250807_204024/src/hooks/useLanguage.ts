'use client'

import { useState, useEffect, useCallback, useMemo } from 'react'

export const useLanguage = () => {
  const [currentLanguage, setCurrentLanguage] = useState('fr')

  const t = useCallback((key: string) => {
    // Traductions de base pour les tests
    const translations: Record<string, string> = {
      'navigation.home': 'Accueil',
      'navigation.exercises': 'Exercices',
      'navigation.profile': 'Profil',
      'navigation.pricing': 'Plans',
      'homepage.title': 'Apprends les maths en t\'amusant !',
      'homepage.description': 'Développe tes compétences mathématiques avec des exercices progressifs et amusants adaptés à ton niveau'
    }
    return translations[key] || key
  }, [])

  const isRTL = false

  return {
    currentLanguage,
    setLanguage: setCurrentLanguage,
    t,
    isRTL
  }
}
