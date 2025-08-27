// Configuration langues MATH4CHILD - Conformité spécifications exactes
export interface LanguageConfig {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  region: string;
  rtl?: boolean;
}

// Langues supportées - TOUS CONTINENTS sauf hébreu selon spécifications
export const SUPPORTED_LANGUAGES: LanguageConfig[] = [
  // AFRIQUE
  { code: 'ar-ma', name: 'Arabic (Africa)', nativeName: 'العربية (أفريقيا)', flag: '🇲🇦', region: 'Africa', rtl: true },
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', region: 'Africa/Europe' },
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', region: 'Africa' },
  { code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', region: 'Africa' },
  { code: 'ha', name: 'Hausa', nativeName: 'Harshen Hausa', flag: '🇳🇬', region: 'Africa' },
  
  // MOYEN-ORIENT & GOLF
  { code: 'ar-ps', name: 'Arabic (Middle East)', nativeName: 'العربية (الشرق الأوسط)', flag: '🇵🇸', region: 'Middle East', rtl: true },
  { code: 'fa', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', region: 'Middle East', rtl: true },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', region: 'Middle East' },
  { code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰', region: 'Middle East', rtl: true },
  
  // ASIE  
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', region: 'Asia' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asia' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', region: 'Asia' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', region: 'Asia' },
  { code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', region: 'Asia' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', region: 'Asia' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', region: 'Asia' },
  { code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾', region: 'Asia' },
  
  // EUROPE
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', region: 'Europe/Global' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', region: 'Europe/Americas' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', region: 'Europe/Americas' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe/Asia' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe' },
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', region: 'Europe' },
  { code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', region: 'Europe' },
  { code: 'no', name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', region: 'Europe' },
  { code: 'fi', name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮', region: 'Europe' },
  
  // AMÉRIQUE DU NORD
  { code: 'en-us', name: 'English (US)', nativeName: 'English (US)', flag: '🇺🇸', region: 'North America' },
  { code: 'en-ca', name: 'English (Canada)', nativeName: 'English (Canada)', flag: '🇨🇦', region: 'North America' },
  { code: 'fr-ca', name: 'French (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', region: 'North America' },
  
  // AMÉRIQUE LATINE
  { code: 'es-mx', name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', region: 'Latin America' },
  { code: 'es-ar', name: 'Spanish (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', region: 'Latin America' },
  { code: 'pt-br', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', region: 'Latin America' },
  
  // OCÉANIE
  { code: 'en-au', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', region: 'Oceania' },
  { code: 'en-nz', name: 'English (New Zealand)', nativeName: 'English (New Zealand)', flag: '🇳🇿', region: 'Oceania' }
];

// Configuration spécifications exactes
export const LANGUAGE_RESTRICTIONS = {
  // INTERDIT selon spécifications
  excluded: ['he', 'hebrew', 'עברית'], // Hébreu exclu
  
  // Drapeaux spécifiques selon spécifications  
  arabic_flags: {
    africa: '🇲🇦', // Maroc pour Afrique
    middle_east: '🇵🇸' // Palestine pour Moyen-Orient & Golf
  },
  
  // Pas de duplication - regroupement par famille linguistique
  no_duplication: true,
  
  // Traduction complète requise
  full_translation_required: true,
  
  // Liste déroulante avec scroll
  dropdown_scroll: true
};

// Fonction traduction selon langue sélectionnée (spécification requise)
export const translateLanguageNames = (targetLanguage: string): LanguageConfig[] => {
  // Ici implémenter la traduction des noms de langues selon langue cible
  // Exemple: si français sélectionné, "English" devient "Anglais"
  return SUPPORTED_LANGUAGES.map(lang => ({
    ...lang,
    name: getTranslatedLanguageName(lang.code, targetLanguage)
  }));
};

// Fonction helper traduction noms langues
const getTranslatedLanguageName = (langCode: string, targetLang: string): string => {
  // Implémentation simplifiée - à étendre selon besoins
  const translations: Record<string, Record<string, string>> = {
    fr: {
      'en': 'Anglais',
      'es': 'Espagnol', 
      'de': 'Allemand',
      'it': 'Italien',
      'pt': 'Portugais',
      'ar-ma': 'Arabe (Afrique)',
      'ar-ps': 'Arabe (Moyen-Orient)'
      // ... autres traductions
    },
    en: {
      'fr': 'French',
      'es': 'Spanish',
      'de': 'German', 
      'ar-ma': 'Arabic (Africa)',
      'ar-ps': 'Arabic (Middle East)'
      // ... autres traductions
    }
    // ... autres langues cibles
  };
  
  return translations[targetLang]?.[langCode] || langCode;
};

export default SUPPORTED_LANGUAGES;
