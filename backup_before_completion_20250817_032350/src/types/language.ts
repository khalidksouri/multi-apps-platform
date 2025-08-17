export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  continent?: string;
  region?: string;
  rtl?: boolean;
}

export const UNIVERSAL_LANGUAGES: Language[] = [
  { code: 'fr-FR', name: 'French', nativeName: 'Français', flag: '🇫🇷', continent: 'Europe' },
  { code: 'en-US', name: 'English', nativeName: 'English', flag: '🇺🇸', continent: 'Global' },
  { code: 'es-ES', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', continent: 'Europe' },
  { code: 'de-DE', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', continent: 'Europe' },
  { code: 'ar-SA', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', continent: 'MENA', rtl: true }
];

export function isRTLLanguage(langCode: string): boolean {
  return langCode.startsWith('ar-');
}
