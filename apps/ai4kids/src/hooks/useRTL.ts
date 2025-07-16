import { useEffect } from 'react';
import { useLanguage } from '../contexts/LanguageContext';

const RTL_LANGUAGES = ['ar', 'he', 'fa', 'ur'];

export const useRTL = () => {
  const { currentLanguage } = useLanguage();

  useEffect(() => {
    const isRTL = RTL_LANGUAGES.includes(currentLanguage.code);
    document.documentElement.setAttribute('dir', isRTL ? 'rtl' : 'ltr');
    document.documentElement.setAttribute('lang', currentLanguage.code);
    
    // Ajouter une classe pour les polices spécifiques
    document.documentElement.className = `lang-${currentLanguage.code}`;
  }, [currentLanguage]);

  return {
    isRTL: RTL_LANGUAGES.includes(currentLanguage.code),
    currentLanguage,
  };
};
