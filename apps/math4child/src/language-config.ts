/**
 * Configuration des langues supportées par Math4Child
 * Exactement 20 langues selon les spécifications du README.md
 */

import { Language, LanguageStats } from './types/translations'

export const SUPPORTED_LANGUAGES: Language[] = [
  // Europe/Amérique : 8 langues
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', region: 'Europe' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', region: 'Americas' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', region: 'Europe' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', region: 'Europe' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe' },
  
  // Asie : 6 langues
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', region: 'Asia' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', region: 'Asia' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', region: 'Asia' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asia' },
  { code: 'th', name: 'Thai', nativeName: 'ภาษาไทย', flag: '🇹🇭', region: 'Asia' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', region: 'Asia' },
  
  // MENA (RTL) : 3 langues
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', rtl: true, region: 'MENA' },
  { code: 'he', name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', rtl: true, region: 'MENA' },
  { code: 'fa', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', rtl: true, region: 'MENA' },
  
  // Nordique/Autres : 3 langues
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', region: 'Nordic' },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', region: 'Europe' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe' },
]

// Validation : exactement 20 langues
if (SUPPORTED_LANGUAGES.length !== 20) {
  throw new Error(`Configuration incorrecte: ${SUPPORTED_LANGUAGES.length} langues au lieu de 20`)
}

// Langues RTL (exactement 3)
export const RTL_LANGUAGES = ['ar', 'he', 'fa']

// Utilitaires
export function isRTL(languageCode: string): boolean {
  return RTL_LANGUAGES.includes(languageCode)
}

export function getLanguageByCode(code: string): Language | undefined {
  return SUPPORTED_LANGUAGES.find((lang: Language) => lang.code === code)
}

export function getLanguageStats(): LanguageStats {
  const total = SUPPORTED_LANGUAGES.length // 20
  const rtlCount = SUPPORTED_LANGUAGES.filter((lang: Language) => lang.rtl).length // 3
  const ltrCount = total - rtlCount // 17
  const regions = new Set(SUPPORTED_LANGUAGES.map((lang: Language) => lang.region)).size
  
  return {
    total,
    rtl: rtlCount,
    ltr: ltrCount,
    regions
  }
}

export const DEFAULT_LANGUAGE = 'fr'
export const FALLBACK_LANGUAGE = 'en'

// Export pour compatibilité
export { SUPPORTED_LANGUAGES as LANGUAGES }
