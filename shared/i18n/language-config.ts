import { Translation, Language, SupportedLanguage } from './types/translations';

// ===================================================================
// EXACTEMENT 20 LANGUES OPÉRATIONNELLES
// ===================================================================

export const SUPPORTED_LANGUAGES: Language[] = [
  // Europe/Amérique (8 langues)
  { code: 'fr', name: 'Français', flag: '🇫🇷', nativeName: 'Français', region: 'Europe' },
  { code: 'en', name: 'English', flag: '🇺🇸', nativeName: 'English', region: 'Americas' },
  { code: 'es', name: 'Español', flag: '🇪🇸', nativeName: 'Español', region: 'Europe' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', nativeName: 'Deutsch', region: 'Europe' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', nativeName: 'Italiano', region: 'Europe' },
  { code: 'pt', name: 'Português', flag: '🇵🇹', nativeName: 'Português', region: 'Europe' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱', nativeName: 'Nederlands', region: 'Europe' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺', nativeName: 'Русский', region: 'Europe' },

  // Asie (6 langues)
  { code: 'zh', name: '中文', flag: '🇨🇳', nativeName: '中文简体', region: 'Asia' },
  { code: 'ja', name: '日本語', flag: '🇯🇵', nativeName: '日本語', region: 'Asia' },
  { code: 'ko', name: '한국어', flag: '🇰🇷', nativeName: '한국어', region: 'Asia' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', nativeName: 'हिन्दी', region: 'Asia' },
  { code: 'th', name: 'ไทย', flag: '🇹🇭', nativeName: 'ภาษาไทย', region: 'Asia' },
  { code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳', nativeName: 'Tiếng Việt', region: 'Asia' },

  // RTL (3 langues)
  { code: 'ar', name: 'العربية', flag: '🇸🇦', nativeName: 'العربية', rtl: true, region: 'MENA' },
  { code: 'he', name: 'עברית', flag: '🇮🇱', nativeName: 'עברית', rtl: true, region: 'MENA' },
  { code: 'fa', name: 'فارسی', flag: '🇮🇷', nativeName: 'فارسی', rtl: true, region: 'MENA' },

  // Autres (3 langues)
  { code: 'sv', name: 'Svenska', flag: '🇸🇪', nativeName: 'Svenska', region: 'Nordic' },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷', nativeName: 'Türkçe', region: 'Europe' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱', nativeName: 'Polski', region: 'Europe' }
];

// Constantes dérivées
export const TOTAL_LANGUAGES = SUPPORTED_LANGUAGES.length; // = 20
export const RTL_LANGUAGES = SUPPORTED_LANGUAGES.filter(lang => lang.rtl).map(lang => lang.code);

export function getLanguageStats() {
  return {
    total: TOTAL_LANGUAGES,
    rtl: RTL_LANGUAGES.length,
    ltr: TOTAL_LANGUAGES - RTL_LANGUAGES.length,
    regions: [...new Set(SUPPORTED_LANGUAGES.map(lang => lang.region))].length
  };
}

export function isRTL(languageCode: string): boolean {
  return RTL_LANGUAGES.includes(languageCode);
}

export function findLanguageByCode(code: string): Language | undefined {
  return SUPPORTED_LANGUAGES.find(lang => lang.code === code);
}
