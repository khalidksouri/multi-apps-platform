import { UNIVERSAL_LANGUAGES } from './languages';

// Fonction pour détecter la langue du navigateur - FIX ligne 14
export function detectUserLanguage(): string {
  if (typeof window === 'undefined') return 'fr';
  
  const browserLang = navigator.language;
  if (!browserLang) return 'fr';
  
  const langParts = browserLang.split('-');
  const mainLang = langParts[0];
  if (!mainLang) return 'fr'; // FIX: vérification mainLang undefined
  
  const supportedLang = UNIVERSAL_LANGUAGES.find(
    lang => lang.code === browserLang || lang.code.startsWith(mainLang)
  );
  
  return supportedLang?.code || 'fr';
}

// Fonction pour formater une date selon la locale
export function formatDate(date: Date, locale: string): string {
  const language = UNIVERSAL_LANGUAGES.find(lang => lang.code === locale);
  
  if (!language) return date.toLocaleDateString();
  
  try {
    return date.toLocaleDateString(locale, {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    });
  } catch {
    return date.toLocaleDateString();
  }
}

// Fonction pour obtenir la direction du texte
export function getTextDirection(languageCode: string): 'ltr' | 'rtl' {
  const language = UNIVERSAL_LANGUAGES.find(lang => lang.code === languageCode);
  return language?.rtl ? 'rtl' : 'ltr';
}

// Fonction pour obtenir le symbole de devise
export function getCurrencySymbol(currencyCode: string): string {
  const currencySymbols: Record<string, string> = {
    'EUR': '€',
    'USD': '$',
    'GBP': '£',
    'MAD': 'MAD',
    'ILS': '₪',
    'SAR': 'ر.س',
    'AED': 'د.إ',
    'TND': 'د.ت',
    'DZD': 'د.ج'
  };
  
  return currencySymbols[currencyCode] || currencyCode;
}

// Export alternatif pour éviter les conflits
export { detectUserLanguage as detectBrowserLanguage };
