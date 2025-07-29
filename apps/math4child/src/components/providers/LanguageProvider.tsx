'use client';

import { ReactNode, useState, useEffect } from 'react';
import { 
  LanguageContext, 
  LanguageContextType, 
  SUPPORTED_LANGUAGES, 
  translations, 
  Language 
} from '@/hooks/useLanguage';

interface LanguageProviderProps {
  children: ReactNode;
}

export function LanguageProvider({ children }: LanguageProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(SUPPORTED_LANGUAGES[0]);

  // Fonction pour changer de langue avec persistance et RTL
  const setLanguage = (lang: Language) => {
    setCurrentLanguage(lang);
    if (typeof window !== 'undefined') {
      localStorage.setItem('math4child_language', lang.code);
      document.documentElement.dir = lang.rtl ? 'rtl' : 'ltr';
      document.documentElement.lang = lang.code;
    }
  };

  // Fonction de traduction complète
  const t = (key: string): string => {
    return translations[currentLanguage.code]?.[key] || translations['fr'][key] || key;
  };

  // Charger la langue sauvegardée au démarrage
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('math4child_language');
      if (saved) {
        const savedLang = SUPPORTED_LANGUAGES.find(lang => lang.code === saved);
        if (savedLang) {
          setCurrentLanguage(savedLang);
          document.documentElement.dir = savedLang.rtl ? 'rtl' : 'ltr';
          document.documentElement.lang = savedLang.code;
        }
      }
    }
  }, []);

  const contextValue: LanguageContextType = {
    currentLanguage,
    setLanguage,
    t
  };

  return (
    <LanguageContext.Provider value={contextValue}>
      {children}
    </LanguageContext.Provider>
  );
}
