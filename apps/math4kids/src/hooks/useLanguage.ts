import { useState, useEffect } from 'react';

interface LanguageHook {
  changeLanguage: (lng: string) => void;
  getCurrentLanguage: () => string;
  currentLanguage: string;
}

export const useLanguage = (): LanguageHook => {
  const [currentLanguage, setCurrentLanguage] = useState('en');

  const changeLanguage = (lng: string) => {
    setCurrentLanguage(lng);
    localStorage.setItem('language', lng);
  };

  const getCurrentLanguage = () => currentLanguage;

  useEffect(() => {
    const savedLanguage = localStorage.getItem('language') || 'en';
    setCurrentLanguage(savedLanguage);
  }, []);

  return {
    changeLanguage,
    getCurrentLanguage,
    currentLanguage,
  };
};
