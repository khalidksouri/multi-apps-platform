"use client"

import { createContext, useContext, useState, ReactNode, useEffect } from 'react'
import { UNIVERSAL_LANGUAGES, isRTLLanguage, type Language } from '@/types/language'

type LanguageCode = string;

interface LanguageContextType {
  currentLanguage: LanguageCode
  setLanguage: (lang: LanguageCode) => void
  t: (key: string) => string
  isRTL: boolean
  supportedLanguages: Language[]
  getLanguagesByContinent: (continent: string) => Language[]
  isLoading: boolean
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

// Traductions étendues
const translations: Record<LanguageCode, Record<string, string>> = {
  'fr-FR': {
    'app_title': 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
    'app_subtitle': 'La plateforme éducative la plus avancée technologiquement au monde',
    'select_language': 'Sélectionner une langue',
    'universal_languages': 'Langues Universelles',
    'search_language': 'Rechercher une langue...',
    'start_learning': 'Commencer l\'apprentissage',
    'view_plans': 'Voir les plans',
    'levels_available': 'niveaux disponibles',
    'questions_total': 'questions au total',
    'operations_supported': 'opérations supportées',
    'global_first': 'PREMIÈRE MONDIALE',
    'ai_adaptive': 'IA Adaptative',
    'handwriting_recognition': 'Reconnaissance Manuscrite',
    'augmented_reality': 'Réalité Augmentée 3D',
    'voice_assistant': 'Assistant Vocal IA',
    'exercise_engine': 'Moteur d\'Exercices',
    'universal_languages_system': 'Système Langues Universel',
    'pricing': 'Tarification',
    'free_trial': 'Essai gratuit',
    'choose_plan': 'Choisir ce plan',
    'most_popular': 'Le plus populaire',
    'best_value': 'Meilleur rapport qualité-prix',
    'profiles_included': 'profils inclus',
    'monthly': 'Mensuel',
    'quarterly': 'Trimestriel',
    'annual': 'Annuel',
    'save': 'Économisez',
    'per_month': '/mois',
    'per_year': '/an',
    'per_quarter': '/3 mois'
  },
  'en-US': {
    'app_title': 'Math4Child v4.2.0 - Global Educational Revolution',
    'app_subtitle': 'The world\'s most technologically advanced educational platform',
    'select_language': 'Select a language',
    'universal_languages': 'Universal Languages',
    'search_language': 'Search language...',
    'start_learning': 'Start Learning',
    'view_plans': 'View Plans',
    'levels_available': 'levels available',
    'questions_total': 'total questions',
    'operations_supported': 'operations supported',
    'global_first': 'GLOBAL FIRST',
    'ai_adaptive': 'Adaptive AI',
    'handwriting_recognition': 'Handwriting Recognition',
    'augmented_reality': 'Augmented Reality 3D',
    'voice_assistant': 'AI Voice Assistant',
    'exercise_engine': 'Exercise Engine',
    'universal_languages_system': 'Universal Languages System',
    'pricing': 'Pricing',
    'free_trial': 'Free trial',
    'choose_plan': 'Choose this plan',
    'most_popular': 'Most popular',
    'best_value': 'Best value',
    'profiles_included': 'profiles included',
    'monthly': 'Monthly',
    'quarterly': 'Quarterly',
    'annual': 'Annual',
    'save': 'Save',
    'per_month': '/month',
    'per_year': '/year',
    'per_quarter': '/quarter'
  },
  'ar-PS': {
    'app_title': 'Math4Child v4.2.0 - ثورة تعليمية عالمية',
    'app_subtitle': 'المنصة التعليمية الأكثر تقدماً تكنولوجياً في العالم',
    'select_language': 'اختر لغة',
    'universal_languages': 'لغات عالمية',
    'search_language': 'البحث عن لغة...',
    'start_learning': 'ابدأ التعلم',
    'view_plans': 'عرض الخطط',
    'levels_available': 'مستويات متاحة',
    'questions_total': 'إجمالي الأسئلة',
    'operations_supported': 'عمليات مدعومة',
    'global_first': 'الأولى عالمياً',
    'ai_adaptive': 'ذكاء اصطناعي تكيفي',
    'handwriting_recognition': 'تمييز الكتابة اليدوية',
    'augmented_reality': 'واقع معزز ثلاثي الأبعاد',
    'voice_assistant': 'مساعد صوتي ذكي',
    'exercise_engine': 'محرك التمارين',
    'universal_languages_system': 'نظام اللغات العالمي',
    'pricing': 'التسعير',
    'free_trial': 'تجربة مجانية',
    'choose_plan': 'اختر هذه الخطة',
    'most_popular': 'الأكثر شعبية',
    'best_value': 'أفضل قيمة',
    'profiles_included': 'ملفات شخصية مشمولة',
    'monthly': 'شهرياً',
    'quarterly': 'ربع سنوي',
    'annual': 'سنوي',
    'save': 'وفر',
    'per_month': '/شهر',
    'per_year': '/سنة',
    'per_quarter': '/ربع سنة'
  },
  'ar-MA': {
    'app_title': 'Math4Child v4.2.0 - ثورة تعليمية عالمية',
    'app_subtitle': 'المنصة التعليمية الأكثر تقدماً تكنولوجياً في العالم',
    'select_language': 'اختر لغة',
    'universal_languages': 'لغات عالمية',
    'search_language': 'البحث عن لغة...',
    'start_learning': 'ابدأ التعلم',
    'view_plans': 'عرض الخطط',
    'levels_available': 'مستويات متاحة',
    'questions_total': 'إجمالي الأسئلة',
    'operations_supported': 'عمليات مدعومة',
    'global_first': 'الأولى عالمياً',
    'ai_adaptive': 'ذكاء اصطناعي تكيفي',
    'handwriting_recognition': 'تمييز الكتابة اليدوية',
    'augmented_reality': 'واقع معزز ثلاثي الأبعاد',
    'voice_assistant': 'مساعد صوتي ذكي',
    'exercise_engine': 'محرك التمارين',
    'universal_languages_system': 'نظام اللغات العالمي',
    'pricing': 'التسعير',
    'free_trial': 'تجربة مجانية',
    'choose_plan': 'اختر هذه الخطة',
    'most_popular': 'الأكثر شعبية',
    'best_value': 'أفضل قيمة',
    'profiles_included': 'ملفات شخصية مشمولة',
    'monthly': 'شهرياً',
    'quarterly': 'ربع سنوي',
    'annual': 'سنوي',
    'save': 'وفر',
    'per_month': '/شهر',
    'per_year': '/سنة',
    'per_quarter': '/ربع سنة'
  }
}

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState<LanguageCode>('fr-FR')
  const [isRTL, setIsRTL] = useState(false)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    // Fonction pour charger la langue de façon safe
    const loadSavedLanguage = () => {
      try {
        if (typeof window !== 'undefined') {
          const savedLang = localStorage.getItem('math4child-language') || 'fr-FR'
          setCurrentLanguage(savedLang)
          setIsRTL(isRTLLanguage(savedLang))
          
          // Mettre à jour les attributs du document
          document.documentElement.dir = isRTLLanguage(savedLang) ? 'rtl' : 'ltr'
          document.documentElement.lang = savedLang.split('-')[0]
        }
      } catch (error) {
        console.warn('🌍 [LANGUAGE] Erreur chargement langue:', error)
        // Fallback vers français
        setCurrentLanguage('fr-FR')
        setIsRTL(false)
      } finally {
        setIsLoading(false)
      }
    }

    loadSavedLanguage()
  }, [])

  const setLanguage = (lang: LanguageCode) => {
    console.log('🌍 [MATH4CHILD] Changement de langue vers:', lang)
    
    try {
      setCurrentLanguage(lang)
      setIsRTL(isRTLLanguage(lang))
      
      if (typeof window !== 'undefined') {
        localStorage.setItem('math4child-language', lang)
        
        // Mettre à jour les attributs du document
        document.documentElement.dir = isRTLLanguage(lang) ? 'rtl' : 'ltr'
        document.documentElement.lang = lang.split('-')[0]
      }
    } catch (error) {
      console.error('🌍 [LANGUAGE] Erreur changement langue:', error)
    }
  }

  const t = (key: string): string => {
    const translation = translations[currentLanguage]?.[key] || 
                       translations['en-US']?.[key] || 
                       translations['fr-FR']?.[key] ||
                       key
    return translation
  }

  const getLanguagesByContinent = (continent: string): Language[] => {
    return UNIVERSAL_LANGUAGES.filter(lang => lang.continent === continent)
  }

  return (
    <LanguageContext.Provider value={{
      currentLanguage,
      setLanguage,
      t,
      isRTL,
      supportedLanguages: UNIVERSAL_LANGUAGES,
      getLanguagesByContinent,
      isLoading
    }}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (!context) {
    throw new Error('useLanguage must be used within a LanguageProvider')
  }
  return context
}
