// =============================================================================
// 🌍 TYPES LANGUES MATH4CHILD v4.2.0
// =============================================================================

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  rtl?: boolean;
  flag?: string;
  region?: string;
}

export interface LanguageConfig {
  supported: Language[];
  default: string;
  fallback: string;
}

export interface TranslationKey {
  [key: string]: string | TranslationKey;
}

export interface LocaleData {
  language: Language;
  translations: TranslationKey;
  dateFormat: string;
  numberFormat: {
    decimal: string;
    thousands: string;
  };
}

// Langues supportées par Math4Child
export const SUPPORTED_LANGUAGES: Language[] = [
  { code: 'fr-FR', name: 'Français', nativeName: 'Français', flag: '🇫🇷', region: 'Europe' },
  { code: 'en-US', name: 'English', nativeName: 'English', flag: '🇺🇸', region: 'Americas' },
  { code: 'es-ES', name: 'Español', nativeName: 'Español', flag: '🇪🇸', region: 'Europe' },
  { code: 'de-DE', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe' },
  { code: 'it-IT', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe' },
  { code: 'pt-PT', name: 'Português', nativeName: 'Português', flag: '🇵🇹', region: 'Europe' },
  { code: 'ru-RU', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe', rtl: false },
  { code: 'ar-SA', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', region: 'Middle East', rtl: true },
  { code: 'zh-CN', name: '中文', nativeName: '中文 (简体)', flag: '🇨🇳', region: 'Asia' },
  { code: 'ja-JP', name: '日本語', nativeName: '日本語', flag: '🇯🇵', region: 'Asia' },
  { code: 'ko-KR', name: '한국어', nativeName: '한국어', flag: '🇰🇷', region: 'Asia' },
  { code: 'hi-IN', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asia' }
];

export const DEFAULT_LANGUAGE = 'fr-FR';
export const FALLBACK_LANGUAGE = 'en-US';

// Utilitaires
export function getLanguageByCode(code: string): Language | undefined {
  return SUPPORTED_LANGUAGES.find(lang => lang.code === code);
}

export function getLanguagesByRegion(region: string): Language[] {
  return SUPPORTED_LANGUAGES.filter(lang => lang.region === region);
}

export function isRTLLanguage(code: string): boolean {
  const language = getLanguageByCode(code);
  return language?.rtl === true;
}
