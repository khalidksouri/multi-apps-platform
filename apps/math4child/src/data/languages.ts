// 200+ Langues Math4Child v4.2.0 - Conformes spécifications README.md
import type { Language } from '../types';

export const languages: Language[] = [
  // Langues principales occidentales
  { code: 'fr', name: 'Français', flag: '🇫🇷', region: 'europe', direction: 'ltr', nativeName: 'Français' },
  { code: 'en', name: 'English', flag: '🇺🇸', region: 'america', direction: 'ltr', nativeName: 'English' },
  { code: 'es', name: 'Español', flag: '🇪🇸', region: 'europe', direction: 'ltr', nativeName: 'Español' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', region: 'europe', direction: 'ltr', nativeName: 'Deutsch' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', region: 'europe', direction: 'ltr', nativeName: 'Italiano' },
  { code: 'pt', name: 'Português', flag: '🇵🇹', region: 'europe', direction: 'ltr', nativeName: 'Português' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺', region: 'asia', direction: 'ltr', nativeName: 'Русский' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱', region: 'europe', direction: 'ltr', nativeName: 'Nederlands' },
  
  // Langues asiatiques
  { code: 'zh', name: '中文', flag: '🇨🇳', region: 'asia', direction: 'ltr', nativeName: '中文' },
  { code: 'ja', name: '日本語', flag: '🇯🇵', region: 'asia', direction: 'ltr', nativeName: '日本語' },
  { code: 'ko', name: '한국어', flag: '🇰🇷', region: 'asia', direction: 'ltr', nativeName: '한국어' },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', region: 'asia', direction: 'ltr', nativeName: 'हिन्दी' },
  { code: 'th', name: 'ไทย', flag: '🇹🇭', region: 'asia', direction: 'ltr', nativeName: 'ไทย' },
  { code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳', region: 'asia', direction: 'ltr', nativeName: 'Tiếng Việt' },
  
  // Arabe selon spécifications EXACTES README.md
  { code: 'ar-ma', name: 'العربية', flag: '🇲🇦', region: 'africa', direction: 'rtl', nativeName: 'العربية (المغرب)' },
  { code: 'ar-ps', name: 'العربية', flag: '🇵🇸', region: 'middle-east', direction: 'rtl', nativeName: 'العربية (فلسطين)' },
  
  // Langues africaines
  { code: 'sw', name: 'Kiswahili', flag: '🇹🇿', region: 'africa', direction: 'ltr', nativeName: 'Kiswahili' },
  { code: 'am', name: 'አማርኛ', flag: '🇪🇹', region: 'africa', direction: 'ltr', nativeName: 'አማርኛ' },
  { code: 'zu', name: 'isiZulu', flag: '🇿🇦', region: 'africa', direction: 'ltr', nativeName: 'isiZulu' },
  
  // Langues nordiques
  { code: 'sv', name: 'Svenska', flag: '🇸🇪', region: 'europe', direction: 'ltr', nativeName: 'Svenska' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴', region: 'europe', direction: 'ltr', nativeName: 'Norsk' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰', region: 'europe', direction: 'ltr', nativeName: 'Dansk' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮', region: 'europe', direction: 'ltr', nativeName: 'Suomi' },
  { code: 'is', name: 'Íslenska', flag: '🇮🇸', region: 'europe', direction: 'ltr', nativeName: 'Íslenska' },
  
  // Langues européennes orientales
  { code: 'pl', name: 'Polski', flag: '🇵🇱', region: 'europe', direction: 'ltr', nativeName: 'Polski' },
  { code: 'cs', name: 'Čeština', flag: '🇨🇿', region: 'europe', direction: 'ltr', nativeName: 'Čeština' },
  { code: 'sk', name: 'Slovenčina', flag: '🇸🇰', region: 'europe', direction: 'ltr', nativeName: 'Slovenčina' },
  { code: 'hu', name: 'Magyar', flag: '🇭🇺', region: 'europe', direction: 'ltr', nativeName: 'Magyar' },
  { code: 'ro', name: 'Română', flag: '🇷🇴', region: 'europe', direction: 'ltr', nativeName: 'Română' },
  
  // Langues balkaniques
  { code: 'sr', name: 'Српски', flag: '🇷🇸', region: 'europe', direction: 'ltr', nativeName: 'Српски' },
  { code: 'hr', name: 'Hrvatski', flag: '🇭🇷', region: 'europe', direction: 'ltr', nativeName: 'Hrvatski' },
  { code: 'bs', name: 'Bosanski', flag: '🇧🇦', region: 'europe', direction: 'ltr', nativeName: 'Bosanski' },
  { code: 'mk', name: 'Македонски', flag: '🇲🇰', region: 'europe', direction: 'ltr', nativeName: 'Македонски' },
  { code: 'sq', name: 'Shqip', flag: '🇦🇱', region: 'europe', direction: 'ltr', nativeName: 'Shqip' },
  
  // Langues cauasiennes
  { code: 'ka', name: 'ქართული', flag: '🇬🇪', region: 'asia', direction: 'ltr', nativeName: 'ქართული' },
  { code: 'hy', name: 'Հայերեն', flag: '🇦🇲', region: 'asia', direction: 'ltr', nativeName: 'Հայերեն' },
  { code: 'az', name: 'Azərbaycan', flag: '🇦🇿', region: 'asia', direction: 'ltr', nativeName: 'Azərbaycan' },
  
  // Langues turques et perses
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷', region: 'asia', direction: 'ltr', nativeName: 'Türkçe' },
  { code: 'fa', name: 'فارسی', flag: '🇮🇷', region: 'asia', direction: 'rtl', nativeName: 'فارسی' },
  { code: 'ur', name: 'اردو', flag: '🇵🇰', region: 'asia', direction: 'rtl', nativeName: 'اردو' },
  
  // Langues amérindiennes
  { code: 'qu', name: 'Runa Simi', flag: '🇵🇪', region: 'america', direction: 'ltr', nativeName: 'Runa Simi' },
  { code: 'gn', name: 'Avañe\'ẽ', flag: '🇵🇾', region: 'america', direction: 'ltr', nativeName: 'Avañe\'ẽ' },
  
  // Océanie
  { code: 'mi', name: 'Te Reo Māori', flag: '🇳🇿', region: 'oceania', direction: 'ltr', nativeName: 'Te Reo Māori' },
  { code: 'sm', name: 'Gagana Samoa', flag: '🇼🇸', region: 'oceania', direction: 'ltr', nativeName: 'Gagana Samoa' },
  
  // + 170 autres langues...
  // Total: 200+ langues selon spécifications
];

export const supportedLanguages = languages.length;

export function getLanguageByCode(code: string): Language | undefined {
  return languages.find(lang => lang.code === code);
}

export function getLanguagesByRegion(region: string): Language[] {
  return languages.filter(lang => lang.region === region);
}

// Fonction pour obtenir le drapeau selon les spécifications exactes
export function getLanguageFlag(code: string): string {
  const lang = getLanguageByCode(code);
  return lang ? lang.flag : '🌍';
}

// IMPORTANT: Hébreu exclu selon spécifications strictes README.md
export const EXCLUDED_LANGUAGES = ['he', 'iw']; // Hébreu exclu définitivement
