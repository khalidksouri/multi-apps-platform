export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  rtl?: boolean;
  continent: string;
  currency: string;
  dateFormat: string;
}

export const UNIVERSAL_LANGUAGES: Language[] = [
  // Europe
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', continent: 'Europe', currency: 'EUR', dateFormat: 'DD/MM/YYYY' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', continent: 'Europe', currency: 'GBP', dateFormat: 'DD/MM/YYYY' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', continent: 'Europe', currency: 'EUR', dateFormat: 'DD.MM.YYYY' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', continent: 'Europe', currency: 'EUR', dateFormat: 'DD/MM/YYYY' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', continent: 'Europe', currency: 'EUR', dateFormat: 'DD/MM/YYYY' },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹', continent: 'Europe', currency: 'EUR', dateFormat: 'DD/MM/YYYY' },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', continent: 'Europe', currency: 'EUR', dateFormat: 'DD-MM-YYYY' },
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', continent: 'Europe', currency: 'RUB', dateFormat: 'DD.MM.YYYY' },

  // Amérique du Nord
  { code: 'en-US', name: 'English (United States)', nativeName: 'English (United States)', flag: '🇺🇸', continent: 'North America', currency: 'USD', dateFormat: 'MM/DD/YYYY' },
  { code: 'en-CA', name: 'English (Canada)', nativeName: 'English (Canada)', flag: '🇨🇦', continent: 'North America', currency: 'CAD', dateFormat: 'DD/MM/YYYY' },
  { code: 'fr-CA', name: 'Français (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', continent: 'North America', currency: 'CAD', dateFormat: 'YYYY-MM-DD' },
  { code: 'es-MX', name: 'Español (México)', nativeName: 'Español (México)', flag: '🇲🇽', continent: 'North America', currency: 'MXN', dateFormat: 'DD/MM/YYYY' },

  // Amérique du Sud
  { code: 'pt-BR', name: 'Português (Brasil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', continent: 'South America', currency: 'BRL', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-AR', name: 'Español (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', continent: 'South America', currency: 'ARS', dateFormat: 'DD/MM/YYYY' },

  // Asie - Extrême-Orient
  { code: 'zh-CN', name: '中文 (简体)', nativeName: '中文 (简体)', flag: '🇨🇳', continent: 'Asia', currency: 'CNY', dateFormat: 'YYYY/MM/DD' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', continent: 'Asia', currency: 'JPY', dateFormat: 'YYYY/MM/DD' },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', continent: 'Asia', currency: 'KRW', dateFormat: 'YYYY.MM.DD' },
  { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', continent: 'Asia', currency: 'INR', dateFormat: 'DD/MM/YYYY' },
  { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭', continent: 'Asia', currency: 'THB', dateFormat: 'DD/MM/YYYY' },

  // Moyen-Orient - MODIFICATIONS APPLIQUÉES
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', continent: 'Asia', currency: 'SAR', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-AE', name: 'العربية (الإمارات)', nativeName: 'العربية (الإمارات)', flag: '🇦🇪', continent: 'Asia', currency: 'AED', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-PS', name: 'العربية (فلسطين)', nativeName: 'العربية (فلسطين)', flag: '🇵🇸', continent: 'Asia', currency: 'ILS', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'fa', name: 'فارسی', nativeName: 'فارسی', flag: '🇮🇷', continent: 'Asia', currency: 'IRR', dateFormat: 'YYYY/MM/DD', rtl: true },
  { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷', continent: 'Asia', currency: 'TRY', dateFormat: 'DD.MM.YYYY' },

  // Afrique - MODIFICATIONS APPLIQUÉES (Égypte supprimée, Maroc avec drapeau marocain)
  { code: 'sw', name: 'Kiswahili', nativeName: 'Kiswahili', flag: '🇰🇪', continent: 'Africa', currency: 'KES', dateFormat: 'DD/MM/YYYY' },
  { code: 'am', name: 'አማርኛ', nativeName: 'አማርኛ', flag: '🇪🇹', continent: 'Africa', currency: 'ETB', dateFormat: 'DD/MM/YYYY' },
  { code: 'ha', name: 'Hausa', nativeName: 'Hausa', flag: '🇳🇬', continent: 'Africa', currency: 'NGN', dateFormat: 'DD/MM/YYYY' },
  { code: 'ar-MA', name: 'العربية (المغرب)', nativeName: 'العربية (المغرب)', flag: '🇲🇦', continent: 'Africa', currency: 'MAD', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-TN', name: 'العربية (تونس)', nativeName: 'العربية (تونس)', flag: '🇹🇳', continent: 'Africa', currency: 'TND', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-DZ', name: 'العربية (الجزائر)', nativeName: 'العربية (الجزائر)', flag: '🇩🇿', continent: 'Africa', currency: 'DZD', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'fr-MA', name: 'Français (Maroc)', nativeName: 'Français (Maroc)', flag: '🇲🇦', continent: 'Africa', currency: 'MAD', dateFormat: 'DD/MM/YYYY' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', continent: 'Africa', currency: 'ZAR', dateFormat: 'DD/MM/YYYY' },

  // Océanie
  { code: 'en-AU', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', continent: 'Oceania', currency: 'AUD', dateFormat: 'DD/MM/YYYY' },
  { code: 'en-NZ', name: 'English (New Zealand)', nativeName: 'English (New Zealand)', flag: '🇳🇿', continent: 'Oceania', currency: 'NZD', dateFormat: 'DD/MM/YYYY' }
];

// Groupement par continent pour l'interface utilisateur
export const CONTINENTS = [
  'Europe',
  'North America', 
  'South America',
  'Asia',
  'Africa',
  'Oceania'
] as const;

export type Continent = typeof CONTINENTS[number];

// Fonction utilitaire pour grouper les langues par continent
export function getLanguagesByContinent(): Record<Continent, Language[]> {
  const grouped = {} as Record<Continent, Language[]>;
  
  CONTINENTS.forEach(continent => {
    grouped[continent] = UNIVERSAL_LANGUAGES.filter(lang => lang.continent === continent);
  });
  
  return grouped;
}

// Fonction pour obtenir une langue par son code
export function getLanguageByCode(code: string): Language | undefined {
  return UNIVERSAL_LANGUAGES.find(lang => lang.code === code);
}

// Langues populaires (pour affichage prioritaire)
export const POPULAR_LANGUAGES = [
  'fr', 'en', 'es', 'de', 'ar', 'ar-MA', 'ar-PS', 'zh-CN', 'ja'
];

// Fonction pour obtenir les langues populaires
export function getPopularLanguages(): Language[] {
  return POPULAR_LANGUAGES.map(code => getLanguageByCode(code)).filter(Boolean) as Language[];
}
