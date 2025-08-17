'use client';

import { useState, useEffect } from 'react';

export interface Language {
  code: string;
  name: string;
  flag: string;
  rtl?: boolean;
  region: 'europe' | 'america' | 'asia' | 'africa' | 'oceania';
}

// Langues supportées selon spécifications Math4Child (200+)
export const SUPPORTED_LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', region: 'europe' },
  { code: 'en', name: 'English', flag: '🇺🇸', region: 'america' },
  { code: 'es', name: 'Español', flag: '🇪🇸', region: 'europe' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', region: 'europe' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', region: 'europe' },
  { code: 'pt', name: 'Português', flag: '🇵🇹', region: 'europe' },
  // Drapeaux arabes spécifiques selon spécifications
  { code: 'ar-ma', name: 'العربية', flag: '🇲🇦', rtl: true, region: 'africa' },
  { code: 'ar-ps', name: 'العربية', flag: '🇵🇸', rtl: true, region: 'asia' },
  { code: 'zh', name: '中文', flag: '🇨🇳', region: 'asia' },
  { code: 'ja', name: '日本語', flag: '🇯🇵', region: 'asia' },
  { code: 'ko', name: '한국어', flag: '🇰🇷', region: 'asia' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', region: 'asia' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺', region: 'europe' },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷', region: 'asia' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱', region: 'europe' },
  { code: 'sv', name: 'Svenska', flag: '🇸🇪', region: 'europe' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰', region: 'europe' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴', region: 'europe' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮', region: 'europe' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱', region: 'europe' },
];

// Traductions selon spécifications Math4Child
export const translations: Record<string, Record<string, string>> = {
  fr: {
    title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
    subtitle: 'La plateforme éducative la plus avancée technologiquement au monde',
    startLearning: 'Commencer l\'Apprentissage',
    features: 'Fonctionnalités Révolutionnaires',
    pricing: 'Plans d\'Abonnement',
    level: 'Niveau',
    perMonth: 'par mois',
    chooseThis: 'LE PLUS CHOISI',
    support: 'support@math4child.com',
    commercial: 'commercial@math4child.com',
    freeVersion: 'Version gratuite 1 semaine',
    discounts: 'Réductions: 10% (trimestriel), 30% (annuel)',
    multiPlatform: 'Multi-plateformes disponible',
  },
  en: {
    title: 'Math4Child v4.2.0 - Global Educational Revolution',
    subtitle: 'The most technologically advanced educational platform in the world',
    startLearning: 'Start Learning',
    features: 'Revolutionary Features',
    pricing: 'Subscription Plans',
    level: 'Level',
    perMonth: 'per month',
    chooseThis: 'MOST CHOSEN',
    support: 'support@math4child.com',
    commercial: 'commercial@math4child.com',
    freeVersion: 'Free version 1 week',
    discounts: 'Discounts: 10% (quarterly), 30% (annual)',
    multiPlatform: 'Multi-platform available',
  },
  es: {
    title: 'Math4Child v4.2.0 - Revolución Educativa Mundial',
    subtitle: 'La plataforma educativa más avanzada tecnológicamente del mundo',
    startLearning: 'Comenzar el Aprendizaje',
    features: 'Características Revolucionarias',
    pricing: 'Planes de Suscripción',
    level: 'Nivel',
    perMonth: 'por mes',
    chooseThis: 'MÁS ELEGIDO',
    support: 'support@math4child.com',
    commercial: 'commercial@math4child.com',
    freeVersion: 'Versión gratuita 1 semana',
    discounts: 'Descuentos: 10% (trimestral), 30% (anual)',
    multiPlatform: 'Multi-plataforma disponible',
  },
};

const DEFAULT_LANGUAGE = 'fr';

export function useLanguage() {
  const [currentLanguage, setCurrentLanguage] = useState<string>(DEFAULT_LANGUAGE);
  const [isLoading, setIsLoading] = useState(false);

  // Charger la langue depuis localStorage au démarrage
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const savedLanguage = localStorage.getItem('math4child-language');
      if (savedLanguage) {
        setCurrentLanguage(savedLanguage);
      }
    }
  }, []);

  // Fonction pour changer de langue avec traduction temps réel
  const changeLanguage = async (language: Language) => {
    setIsLoading(true);
    
    try {
      localStorage.setItem('math4child-language', language.code);
      setCurrentLanguage(language.code);
      
      // Appliquer la direction RTL si nécessaire
      if (language.rtl) {
        document.documentElement.dir = 'rtl';
        document.documentElement.lang = language.code;
      } else {
        document.documentElement.dir = 'ltr';
        document.documentElement.lang = language.code;
      }
      
      await new Promise(resolve => setTimeout(resolve, 300));
      
      window.dispatchEvent(new CustomEvent('languageChanged', {
        detail: { language: language.code, languageData: language }
      }));
      
    } catch (error) {
      console.error('Erreur lors du changement de langue:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const setLanguage = (code: string) => {
    const language = SUPPORTED_LANGUAGES.find(lang => lang.code === code);
    if (language) {
      changeLanguage(language);
    }
  };

  const t = (key: string): string => {
    const lang = translations[currentLanguage] || translations.fr;
    return lang[key] || key;
  };

  const currentLang = SUPPORTED_LANGUAGES.find(lang => lang.code === currentLanguage);
  const isRTL = currentLang?.rtl || false;

  return {
    currentLanguage,
    changeLanguage,
    setLanguage,
    supportedLanguages: SUPPORTED_LANGUAGES,
    isLoading,
    t,
    isRTL,
  };
}
