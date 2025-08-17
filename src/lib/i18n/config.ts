// =============================================================================
// 🌍 CONFIGURATION I18N MATH4CHILD v4.2.0
// =============================================================================
// Configuration séparée pour éviter les conflits avec output: export

export const SUPPORTED_LOCALES = [
  'fr', 'en', 'es', 'de', 'it', 'pt', 'ar', 'zh', 'ja', 'ko', 
  'hi', 'ru', 'tr', 'nl', 'sv', 'da', 'no', 'fi', 'pl'
] as const;

export const DEFAULT_LOCALE = 'fr';

export const LOCALE_NAMES: Record<string, string> = {
  fr: 'Français',
  en: 'English', 
  es: 'Español',
  de: 'Deutsch',
  it: 'Italiano',
  pt: 'Português',
  ar: 'العربية',
  zh: '中文',
  ja: '日本語',
  ko: '한국어',
  hi: 'हिन्दी',
  ru: 'Русский',
  tr: 'Türkçe',
  nl: 'Nederlands',
  sv: 'Svenska',
  da: 'Dansk',
  no: 'Norsk',
  fi: 'Suomi',
  pl: 'Polski',
};

export const RTL_LOCALES = ['ar'] as const;

export type SupportedLocale = typeof SUPPORTED_LOCALES[number];

export function isValidLocale(locale: string): locale is SupportedLocale {
  return SUPPORTED_LOCALES.includes(locale as SupportedLocale);
}

export function isRTL(locale: string): boolean {
  return RTL_LOCALES.includes(locale as any);
}
