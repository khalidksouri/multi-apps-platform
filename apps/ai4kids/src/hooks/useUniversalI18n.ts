import { useState, useEffect, useCallback } from 'react';

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  direction: 'ltr' | 'rtl';
}

export const SUPPORTED_LANGUAGES: Language[] = [
  // Europe
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', direction: 'ltr' },
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', direction: 'ltr' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', direction: 'ltr' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', direction: 'ltr' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', direction: 'ltr' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', direction: 'ltr' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', direction: 'ltr' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', direction: 'ltr' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', direction: 'ltr' },
  { code: 'cs', name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿', direction: 'ltr' },
  // Asie
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', direction: 'ltr' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', direction: 'ltr' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', direction: 'ltr' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', direction: 'ltr' },
  { code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', direction: 'ltr' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', direction: 'ltr' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', direction: 'ltr' },
  { code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩', direction: 'ltr' },
  { code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰', direction: 'rtl' },
  { code: 'fa', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', direction: 'rtl' },
  { code: 'he', name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', direction: 'rtl' },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', direction: 'ltr' },
  // Moyen-Orient et Afrique
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', direction: 'rtl' },
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇹🇿', direction: 'ltr' },
  { code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', direction: 'ltr' },
  { code: 'ha', name: 'Hausa', nativeName: 'Harshen Hausa', flag: '🇳🇬', direction: 'ltr' },
  { code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', direction: 'ltr' },
  { code: 'ig', name: 'Igbo', nativeName: 'Asụsụ Igbo', flag: '🇳🇬', direction: 'ltr' },
  { code: 'zu', name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦', direction: 'ltr' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', direction: 'ltr' },
  // Amériques
  { code: 'pt-BR', name: 'Brazilian Portuguese', nativeName: 'Português (Brasil)', flag: '🇧🇷', direction: 'ltr' },
  { code: 'es-MX', name: 'Mexican Spanish', nativeName: 'Español (México)', flag: '🇲🇽', direction: 'ltr' },
  { code: 'fr-CA', name: 'Canadian French', nativeName: 'Français (Canada)', flag: '🇨🇦', direction: 'ltr' },
  { code: 'qu', name: 'Quechua', nativeName: 'Runasimi', flag: '🇵🇪', direction: 'ltr' },
  // Océanie
  { code: 'mi', name: 'Maori', nativeName: 'Te Reo Māori', flag: '🇳🇿', direction: 'ltr' },
  { code: 'sm', name: 'Samoan', nativeName: 'Gagana Samoa', flag: '🇼🇸', direction: 'ltr' },
];

const detectBrowserLanguage = (): string => {
  if (typeof window === 'undefined') return 'en';
  const lang = navigator.language || navigator.languages?.[0] || 'en';
  const primary = lang.split('-')[0];
  
  if (SUPPORTED_LANGUAGES.some(l => l.code === lang)) return lang;
  if (SUPPORTED_LANGUAGES.some(l => l.code === primary)) return primary;
  return 'en';
};

const STORAGE_KEY = 'universal_app_language';
const LANGUAGE_CHANGE_EVENT = 'universal_language_change';

export const useUniversalI18n = () => {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(() => {
    if (typeof window === 'undefined') {
      return SUPPORTED_LANGUAGES.find(l => l.code === 'en')!;
    }
    
    const savedLang = localStorage.getItem(STORAGE_KEY);
    const detectedLang = detectBrowserLanguage();
    const langCode = savedLang || detectedLang;
    
    return SUPPORTED_LANGUAGES.find(l => l.code === langCode) || 
           SUPPORTED_LANGUAGES.find(l => l.code === 'en')!;
  });

  const [isLoading, setIsLoading] = useState(false);

  const changeLanguage = useCallback(async (languageCode: string) => {
    setIsLoading(true);
    
    try {
      const language = SUPPORTED_LANGUAGES.find(l => l.code === languageCode);
      if (!language) throw new Error(`Language ${languageCode} not supported`);

      setCurrentLanguage(language);
      localStorage.setItem(STORAGE_KEY, languageCode);
      
      document.documentElement.lang = languageCode;
      document.documentElement.dir = language.direction;

      const event = new CustomEvent(LANGUAGE_CHANGE_EVENT, {
        detail: { language, timestamp: Date.now() }
      });
      window.dispatchEvent(event);

      window.dispatchEvent(new StorageEvent('storage', {
        key: STORAGE_KEY,
        newValue: languageCode,
        oldValue: localStorage.getItem(STORAGE_KEY)
      }));

    } catch (error) {
      console.error('Erreur lors du changement de langue:', error);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    const handleStorageChange = (event: StorageEvent) => {
      if (event.key === STORAGE_KEY && event.newValue) {
        const language = SUPPORTED_LANGUAGES.find(l => l.code === event.newValue);
        if (language) {
          setCurrentLanguage(language);
          document.documentElement.lang = language.code;
          document.documentElement.dir = language.direction;
        }
      }
    };

    const handleLanguageChange = (event: CustomEvent) => {
      const { language } = event.detail;
      setCurrentLanguage(language);
      document.documentElement.lang = language.code;
      document.documentElement.dir = language.direction;
    };

    window.addEventListener('storage', handleStorageChange);
    window.addEventListener(LANGUAGE_CHANGE_EVENT, handleLanguageChange as EventListener);

    return () => {
      window.removeEventListener('storage', handleStorageChange);
      window.removeEventListener(LANGUAGE_CHANGE_EVENT, handleLanguageChange as EventListener);
    };
  }, []);

  useEffect(() => {
    document.documentElement.lang = currentLanguage.code;
    document.documentElement.dir = currentLanguage.direction;
  }, [currentLanguage]);

  return {
    currentLanguage,
    changeLanguage,
    isLoading,
    supportedLanguages: SUPPORTED_LANGUAGES,
    isRTL: currentLanguage.direction === 'rtl'
  };
};

export const useTranslation = (translations: Record<string, Record<string, string>>) => {
  const { currentLanguage } = useUniversalI18n();

  const t = useCallback((key: string, params?: Record<string, string>): string => {
    const keys = key.split('.');
    let value: any = translations[currentLanguage.code] || translations['en'] || {};
    
    for (const k of keys) {
      value = value?.[k];
    }
    
    if (typeof value !== 'string') {
      console.warn(`Translation missing for key: ${key} in language: ${currentLanguage.code}`);
      return key;
    }

    if (params) {
      return value.replace(/\{\{(\w+)\}\}/g, (match: string, paramKey: string) => {
        return params[paramKey] || match;
      });
    }

    return value;
  }, [currentLanguage.code, translations]);

  return { t, currentLanguage };
};

export const LanguageSelector = ({ 
  className = "",
  onChange
}: {
  className?: string;
  onChange?: (language: Language) => void;
}) => {
  const { currentLanguage, changeLanguage } = useUniversalI18n();

  const handleLanguageChange = async (langCode: string) => {
    await changeLanguage(langCode);
    const language = SUPPORTED_LANGUAGES.find(l => l.code === langCode);
    if (language && onChange) {
      onChange(language);
    }
  };

  return (
    <select 
      value={currentLanguage.code} 
      onChange={(e) => handleLanguageChange(e.target.value)}
      className={`border rounded px-3 py-2 bg-white shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 ${className}`}
    >
      {SUPPORTED_LANGUAGES.map(lang => (
        <option key={lang.code} value={lang.code}>
          {lang.flag} {lang.nativeName}
        </option>
      ))}
    </select>
  );
};
