'use client';

import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { getLanguageTranslations, Translation, isLanguageSupported } from '@/lib/translations';
import { getLanguageByCode, isRTL } from '@/lib/i18n/languages';

interface LanguageContextType {
  currentLanguage: string;
  setLanguage: (lang: string) => void;
  t: (key: keyof Translation) => string;
  isRTL: boolean;
  currentLangInfo: any;
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState('fr');

  useEffect(() => {
    // Charger la langue sauvegardée
    const savedLang = localStorage.getItem('math4child-language');
    if (savedLang && isLanguageSupported(savedLang)) {
      setCurrentLanguage(savedLang);
    }
  }, []);

  const setLanguage = (lang: string) => {
    console.log('🌍 Changement de langue vers:', lang);
    setCurrentLanguage(lang);
    localStorage.setItem('math4child-language', lang);
    
    // Définir la direction RTL pour l'arabe
    if (isRTL(lang)) {
      document.documentElement.setAttribute('dir', 'rtl');
      document.documentElement.setAttribute('lang', lang);
    } else {
      document.documentElement.setAttribute('dir', 'ltr');
      document.documentElement.setAttribute('lang', lang);
    }
  };

  const t = (key: keyof Translation): string => {
    const translations = getLanguageTranslations(currentLanguage);
    return translations[key] || key;
  };

  const currentLangInfo = getLanguageByCode(currentLanguage);

  return (
    <LanguageContext.Provider value={{ 
      currentLanguage, 
      setLanguage, 
      t, 
      isRTL: isRTL(currentLanguage),
      currentLangInfo
    }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
}
