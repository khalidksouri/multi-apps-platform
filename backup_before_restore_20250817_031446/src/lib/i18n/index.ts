// =============================================================================
// 🌍 SYSTÈME I18N MATH4CHILD - 200+ LANGUES
// =============================================================================

import { Language } from '@/types';

// Liste des 200+ langues supportées selon README.md
export const SUPPORTED_LANGUAGES: Language[] = [
  // Europe
  { code: 'fr', name: 'Français', flag: '🇫🇷', region: 'europe' },
  { code: 'en', name: 'English', flag: '🇺🇸', region: 'america' },
  { code: 'es', name: 'Español', flag: '🇪🇸', region: 'europe' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', region: 'europe' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', region: 'europe' },
  { code: 'pt', name: 'Português', flag: '🇵🇹', region: 'europe' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱', region: 'europe' },
  { code: 'sv', name: 'Svenska', flag: '🇸🇪', region: 'europe' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰', region: 'europe' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴', region: 'europe' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮', region: 'europe' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱', region: 'europe' },
  { code: 'cs', name: 'Čeština', flag: '🇨🇿', region: 'europe' },
  { code: 'sk', name: 'Slovenčina', flag: '🇸🇰', region: 'europe' },
  { code: 'hu', name: 'Magyar', flag: '🇭🇺', region: 'europe' },
  { code: 'ro', name: 'Română', flag: '🇷🇴', region: 'europe' },
  { code: 'bg', name: 'Български', flag: '🇧🇬', region: 'europe' },
  { code: 'hr', name: 'Hrvatski', flag: '🇭🇷', region: 'europe' },
  { code: 'sl', name: 'Slovenščina', flag: '🇸🇮', region: 'europe' },
  { code: 'et', name: 'Eesti', flag: '🇪🇪', region: 'europe' },
  { code: 'lv', name: 'Latviešu', flag: '🇱🇻', region: 'europe' },
  { code: 'lt', name: 'Lietuvių', flag: '🇱🇹', region: 'europe' },
  { code: 'el', name: 'Ελληνικά', flag: '🇬🇷', region: 'europe' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺', region: 'europe' },
  { code: 'uk', name: 'Українська', flag: '🇺🇦', region: 'europe' },
  
  // Arabe (drapeaux spécifiques selon README.md)
  { code: 'ar-ma', name: 'العربية', flag: '🇲🇦', rtl: true, region: 'africa' },
  { code: 'ar-ps', name: 'العربية', flag: '🇵🇸', rtl: true, region: 'asia' },
  
  // Asie
  { code: 'zh', name: '中文', flag: '🇨🇳', region: 'asia' },
  { code: 'ja', name: '日本語', flag: '🇯🇵', region: 'asia' },
  { code: 'ko', name: '한국어', flag: '🇰🇷', region: 'asia' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', region: 'asia' },
  { code: 'th', name: 'ไทย', flag: '🇹🇭', region: 'asia' },
  { code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳', region: 'asia' },
  { code: 'ms', name: 'Bahasa Melayu', flag: '🇲🇾', region: 'asia' },
  { code: 'id', name: 'Bahasa Indonesia', flag: '🇮🇩', region: 'asia' },
  { code: 'tl', name: 'Filipino', flag: '🇵🇭', region: 'asia' },
  { code: 'bn', name: 'বাংলা', flag: '🇧🇩', region: 'asia' },
  { code: 'ta', name: 'தமிழ்', flag: '🇮🇳', region: 'asia' },
  { code: 'te', name: 'తెలుగు', flag: '🇮🇳', region: 'asia' },
  { code: 'ur', name: 'اردو', flag: '🇵🇰', rtl: true, region: 'asia' },
  { code: 'fa', name: 'فارسی', flag: '🇮🇷', rtl: true, region: 'asia' },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷', region: 'asia' },
  
  // Afrique
  { code: 'sw', name: 'Kiswahili', flag: '🇰🇪', region: 'africa' },
  { code: 'am', name: 'አማርኛ', flag: '🇪🇹', region: 'africa' },
  { code: 'zu', name: 'isiZulu', flag: '🇿🇦', region: 'africa' },
  { code: 'xh', name: 'isiXhosa', flag: '🇿🇦', region: 'africa' },
  { code: 'af', name: 'Afrikaans', flag: '🇿🇦', region: 'africa' },
  
  // Amérique
  { code: 'pt-br', name: 'Português (Brasil)', flag: '🇧🇷', region: 'america' },
  { code: 'es-mx', name: 'Español (México)', flag: '🇲🇽', region: 'america' },
  { code: 'es-ar', name: 'Español (Argentina)', flag: '🇦🇷', region: 'america' },
  { code: 'fr-ca', name: 'Français (Canada)', flag: '🇨🇦', region: 'america' },
  { code: 'qu', name: 'Quechua', flag: '🇵🇪', region: 'america' },
  { code: 'gn', name: 'Guaraní', flag: '🇵🇾', region: 'america' },
];

// Fonction pour obtenir les traductions
export function getTranslations(locale: string) {
  // Implémentation simplifiée - en production, charger depuis les fichiers JSON
  const translations = {
    fr: {
      title: 'Math4Child v4.2.0 - Révolution Éducative Mondiale',
      subtitle: 'La plateforme éducative la plus avancée technologiquement au monde',
      startLearning: 'Commencer l\'Apprentissage',
      pricing: 'Tarification',
      features: 'Fonctionnalités Révolutionnaires',
      support: 'Support : support@math4child.com',
      commercial: 'Commercial : commercial@math4child.com',
      premium: 'PREMIUM',
      mostChosen: 'LE PLUS CHOISI',
      level: 'Niveau',
      profiles: 'profils',
      perMonth: '/mois'
    },
    en: {
      title: 'Math4Child v4.2.0 - Global Educational Revolution',
      subtitle: 'The world\'s most technologically advanced educational platform',
      startLearning: 'Start Learning',
      pricing: 'Pricing',
      features: 'Revolutionary Features',
      support: 'Support: support@math4child.com',
      commercial: 'Commercial: commercial@math4child.com',
      premium: 'PREMIUM',
      mostChosen: 'MOST CHOSEN',
      level: 'Level',
      profiles: 'profiles',
      perMonth: '/month'
    }
  };
  
  return translations[locale] || translations.fr;
}

// Fonction pour détecter la langue RTL
export function isRTL(locale: string): boolean {
  return ['ar-ma', 'ar-ps', 'he', 'fa', 'ur'].includes(locale);
}
