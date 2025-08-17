'use client';

import React, { createContext, useContext, ReactNode } from 'react';
import { useLanguage as useLanguageHook, Language } from '@/hooks/useLanguage';

interface LanguageContextType {
  currentLanguage: string;
  changeLanguage: (language: Language) => Promise<void>;
  setLanguage: (code: string) => void;
  supportedLanguages: Language[];
  isLoading: boolean;
  t: (key: string) => string;
  isRTL: boolean;
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

interface LanguageProviderProps {
  children: ReactNode;
}

export function LanguageProvider({ children }: LanguageProviderProps) {
  const languageData = useLanguageHook();

  return (
    <LanguageContext.Provider value={languageData}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (context === undefined) {
    // Fallback pour les composants qui ne sont pas dans le provider
    return useLanguageHook();
  }
  return context;
}

// Export du type Language
export type { Language };
