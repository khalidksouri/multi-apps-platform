'use client';

import React, { createContext, useState, useEffect, ReactNode } from 'react';
import { SUPPORTED_LANGUAGES, DEFAULT_LANGUAGE } from '@/lib/constants/languages';
import { translations } from '@/lib/translations';
import type { Translations } from '@/types/i18n';

interface TranslationContextType {
  currentLanguage: string;
  translations: Translations;
  setLanguage: (languageCode: string) => void;
}

export const TranslationContext = createContext<TranslationContextType | undefined>(undefined);

interface TranslationProviderProps {
  children: ReactNode;
}

export function TranslationProvider({ children }: TranslationProviderProps) {
  const [currentLanguage, setCurrentLanguage] = useState(DEFAULT_LANGUAGE);

  useEffect(() => {
    const savedLanguage = localStorage.getItem('math4child-language') || DEFAULT_LANGUAGE;
    setCurrentLanguage(savedLanguage);
  }, []);

  const setLanguage = (languageCode: string) => {
    if (SUPPORTED_LANGUAGES.find(lang => lang.code === languageCode)) {
      setCurrentLanguage(languageCode);
      localStorage.setItem('math4child-language', languageCode);
      
      const language = SUPPORTED_LANGUAGES.find(lang => lang.code === languageCode);
      document.documentElement.dir = language?.dir || 'ltr';
      document.documentElement.lang = languageCode;
    }
  };

  return (
    <TranslationContext.Provider value={{ currentLanguage, translations, setLanguage }}>
      {children}
    </TranslationContext.Provider>
  );
}
