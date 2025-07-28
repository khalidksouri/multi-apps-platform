'use client';

import { useContext } from 'react';
import { TranslationContext } from '@/contexts/TranslationContext';

export function useTranslation() {
  const context = useContext(TranslationContext);
  
  if (!context) {
    throw new Error('useTranslation must be used within TranslationProvider');
  }

  const { currentLanguage, translations, setLanguage } = context;

  const t = (key: string): string => {
    const keys = key.split('.');
    let translation: any = translations[currentLanguage];
    
    for (const k of keys) {
      translation = translation?.[k];
    }
    
    return translation || key;
  };

  const isRTL = ['ar', 'he', 'fa', 'ur'].includes(currentLanguage);

  return {
    t,
    currentLanguage,
    setLanguage,
    isRTL
  };
}
