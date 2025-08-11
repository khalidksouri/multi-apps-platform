// =============================================================================
// 🌍 SYSTÈME LANGUES UNIVERSEL MATH4CHILD v4.2.0 - 200+ LANGUES
// =============================================================================

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  rtl?: boolean;
  flag: string;
  region: string;
  continent: string;
}

export interface LanguageConfig {
  supported: Language[];
  default: string;
  fallback: string;
  rtlLanguages: string[];
}

// 200+ LANGUES UNIVERSELLES - Échantillon représentatif
export const UNIVERSAL_LANGUAGES: Language[] = [
  // ===== EUROPE =====
  { code: 'fr-FR', name: 'French', nativeName: 'Français', flag: '🇫🇷', region: 'Western Europe', continent: 'Europe' },
  { code: 'en-US', name: 'English', nativeName: 'English', flag: '🇺🇸', region: 'North America', continent: 'Americas' },
  { code: 'es-ES', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', region: 'Western Europe', continent: 'Europe' },
  { code: 'de-DE', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Western Europe', continent: 'Europe' },
  { code: 'it-IT', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', region: 'Southern Europe', continent: 'Europe' },
  { code: 'pt-PT', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', region: 'Western Europe', continent: 'Europe' },
  { code: 'ru-RU', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', region: 'Eastern Europe', continent: 'Europe' },
  { code: 'pl-PL', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', region: 'Eastern Europe', continent: 'Europe' },
  { code: 'nl-NL', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Western Europe', continent: 'Europe' },
  { code: 'sv-SE', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', region: 'Northern Europe', continent: 'Europe' },

  // ===== ASIE =====
  { code: 'zh-CN', name: 'Chinese Simplified', nativeName: '中文 (简体)', flag: '🇨🇳', region: 'East Asia', continent: 'Asia' },
  { code: 'ja-JP', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', region: 'East Asia', continent: 'Asia' },
  { code: 'ko-KR', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', region: 'East Asia', continent: 'Asia' },
  { code: 'hi-IN', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'South Asia', continent: 'Asia' },
  { code: 'th-TH', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', region: 'Southeast Asia', continent: 'Asia' },
  { code: 'vi-VN', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', region: 'Southeast Asia', continent: 'Asia' },
  { code: 'id-ID', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', region: 'Southeast Asia', continent: 'Asia' },
  { code: 'ms-MY', name: 'Malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾', region: 'Southeast Asia', continent: 'Asia' },

  // ===== MOYEN-ORIENT & AFRIQUE DU NORD (MENA) =====
  { code: 'ar-PS', name: 'Arabic (Middle East)', nativeName: 'العربية (الشرق الأوسط)', flag: '🇵🇸', region: 'Middle East', continent: 'Asia', rtl: true },
  { code: 'ar-MA', name: 'Arabic (Africa)', nativeName: 'العربية (أفريقيا)', flag: '🇲🇦', region: 'North Africa', continent: 'Africa', rtl: true },
  { code: 'fa-IR', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', region: 'Middle East', continent: 'Asia', rtl: true },
  { code: 'tr-TR', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', region: 'Western Asia', continent: 'Asia' },

  // ===== AFRIQUE =====
  { code: 'sw-KE', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', region: 'East Africa', continent: 'Africa' },
  { code: 'am-ET', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', region: 'East Africa', continent: 'Africa' },
  { code: 'yo-NG', name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', region: 'West Africa', continent: 'Africa' },
  { code: 'zu-ZA', name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦', region: 'Southern Africa', continent: 'Africa' },

  // ===== AMÉRIQUES =====
  { code: 'pt-BR', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', region: 'South America', continent: 'Americas' },
  { code: 'es-MX', name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', region: 'North America', continent: 'Americas' },
  { code: 'fr-CA', name: 'French (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', region: 'North America', continent: 'Americas' },

  // ===== OCÉANIE =====
  { code: 'en-AU', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', region: 'Oceania', continent: 'Oceania' },

  // Plus de 170 autres langues à ajouter...
];

export const LANGUAGE_CONFIG: LanguageConfig = {
  supported: UNIVERSAL_LANGUAGES,
  default: 'fr-FR',
  fallback: 'en-US',
  rtlLanguages: ['ar-PS', 'ar-MA', 'fa-IR']
};

// Utilitaires
export function getLanguageByCode(code: string): Language | undefined {
  return UNIVERSAL_LANGUAGES.find(lang => lang.code === code);
}

export function getLanguagesByContinent(continent: string): Language[] {
  return UNIVERSAL_LANGUAGES.filter(lang => lang.continent === continent);
}

export function getLanguagesByRegion(region: string): Language[] {
  return UNIVERSAL_LANGUAGES.filter(lang => lang.region === region);
}

export function isRTLLanguage(code: string): boolean {
  return LANGUAGE_CONFIG.rtlLanguages.includes(code);
}

export function getArabicVariant(region: 'Middle East' | 'Africa'): Language {
  return region === 'Middle East' 
    ? UNIVERSAL_LANGUAGES.find(l => l.code === 'ar-PS')!
    : UNIVERSAL_LANGUAGES.find(l => l.code === 'ar-MA')!;
}
