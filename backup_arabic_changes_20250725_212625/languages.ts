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
  { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', continent: 'Europe', currency: 'SEK', dateFormat: 'YYYY-MM-DD' },
  { code: 'no', name: 'Norsk', nativeName: 'Norsk', flag: '🇳🇴', continent: 'Europe', currency: 'NOK', dateFormat: 'DD.MM.YYYY' },
  { code: 'da', name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰', continent: 'Europe', currency: 'DKK', dateFormat: 'DD.MM.YYYY' },
  { code: 'fi', name: 'Suomi', nativeName: 'Suomi', flag: '🇫🇮', continent: 'Europe', currency: 'EUR', dateFormat: 'DD.MM.YYYY' },
  { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', continent: 'Europe', currency: 'PLN', dateFormat: 'DD.MM.YYYY' },
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', continent: 'Europe', currency: 'RUB', dateFormat: 'DD.MM.YYYY' },
  { code: 'uk', name: 'Українська', nativeName: 'Українська', flag: '🇺🇦', continent: 'Europe', currency: 'UAH', dateFormat: 'DD.MM.YYYY' },
  { code: 'cs', name: 'Čeština', nativeName: 'Čeština', flag: '🇨🇿', continent: 'Europe', currency: 'CZK', dateFormat: 'DD.MM.YYYY' },
  { code: 'sk', name: 'Slovenčina', nativeName: 'Slovenčina', flag: '🇸🇰', continent: 'Europe', currency: 'EUR', dateFormat: 'DD.MM.YYYY' },
  { code: 'hu', name: 'Magyar', nativeName: 'Magyar', flag: '🇭🇺', continent: 'Europe', currency: 'HUF', dateFormat: 'YYYY.MM.DD' },
  { code: 'ro', name: 'Română', nativeName: 'Română', flag: '🇷🇴', continent: 'Europe', currency: 'RON', dateFormat: 'DD.MM.YYYY' },
  { code: 'bg', name: 'Български', nativeName: 'Български', flag: '🇧🇬', continent: 'Europe', currency: 'BGN', dateFormat: 'DD.MM.YYYY' },
  { code: 'hr', name: 'Hrvatski', nativeName: 'Hrvatski', flag: '🇭🇷', continent: 'Europe', currency: 'EUR', dateFormat: 'DD.MM.YYYY' },
  { code: 'sr', name: 'Српски', nativeName: 'Српски', flag: '🇷🇸', continent: 'Europe', currency: 'RSD', dateFormat: 'DD.MM.YYYY' },
  { code: 'el', name: 'Ελληνικά', nativeName: 'Ελληνικά', flag: '🇬🇷', continent: 'Europe', currency: 'EUR', dateFormat: 'DD/MM/YYYY' },

  // Amérique du Nord
  { code: 'en-US', name: 'English (US)', nativeName: 'English (US)', flag: '🇺🇸', continent: 'North America', currency: 'USD', dateFormat: 'MM/DD/YYYY' },
  { code: 'en-CA', name: 'English (Canada)', nativeName: 'English (Canada)', flag: '🇨🇦', continent: 'North America', currency: 'CAD', dateFormat: 'DD/MM/YYYY' },
  { code: 'fr-CA', name: 'Français (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', continent: 'North America', currency: 'CAD', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-MX', name: 'Español (México)', nativeName: 'Español (México)', flag: '🇲🇽', continent: 'North America', currency: 'MXN', dateFormat: 'DD/MM/YYYY' },

  // Amérique du Sud
  { code: 'pt-BR', name: 'Português (Brasil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', continent: 'South America', currency: 'BRL', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-AR', name: 'Español (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', continent: 'South America', currency: 'ARS', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-CL', name: 'Español (Chile)', nativeName: 'Español (Chile)', flag: '🇨🇱', continent: 'South America', currency: 'CLP', dateFormat: 'DD-MM-YYYY' },
  { code: 'es-CO', name: 'Español (Colombia)', nativeName: 'Español (Colombia)', flag: '🇨🇴', continent: 'South America', currency: 'COP', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-PE', name: 'Español (Perú)', nativeName: 'Español (Perú)', flag: '🇵🇪', continent: 'South America', currency: 'PEN', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-VE', name: 'Español (Venezuela)', nativeName: 'Español (Venezuela)', flag: '🇻🇪', continent: 'South America', currency: 'VES', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-UY', name: 'Español (Uruguay)', nativeName: 'Español (Uruguay)', flag: '🇺🇾', continent: 'South America', currency: 'UYU', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-PY', name: 'Español (Paraguay)', nativeName: 'Español (Paraguay)', flag: '🇵🇾', continent: 'South America', currency: 'PYG', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-BO', name: 'Español (Bolivia)', nativeName: 'Español (Bolivia)', flag: '🇧🇴', continent: 'South America', currency: 'BOB', dateFormat: 'DD/MM/YYYY' },
  { code: 'es-EC', name: 'Español (Ecuador)', nativeName: 'Español (Ecuador)', flag: '🇪🇨', continent: 'South America', currency: 'USD', dateFormat: 'DD/MM/YYYY' },

  // Asie
  { code: 'zh-CN', name: '中文 (简体)', nativeName: '中文 (简体)', flag: '🇨🇳', continent: 'Asia', currency: 'CNY', dateFormat: 'YYYY/MM/DD' },
  { code: 'zh-TW', name: '中文 (繁體)', nativeName: '中文 (繁體)', flag: '🇹🇼', continent: 'Asia', currency: 'TWD', dateFormat: 'YYYY/MM/DD' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', continent: 'Asia', currency: 'JPY', dateFormat: 'YYYY/MM/DD' },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', continent: 'Asia', currency: 'KRW', dateFormat: 'YYYY.MM.DD' },
  { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', continent: 'Asia', currency: 'INR', dateFormat: 'DD/MM/YYYY' },
  { code: 'en-IN', name: 'English (India)', nativeName: 'English (India)', flag: '🇮🇳', continent: 'Asia', currency: 'INR', dateFormat: 'DD/MM/YYYY' },
  { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭', continent: 'Asia', currency: 'THB', dateFormat: 'DD/MM/YYYY' },
  { code: 'vi', name: 'Tiếng Việt', nativeName: 'Tiếng Việt', flag: '🇻🇳', continent: 'Asia', currency: 'VND', dateFormat: 'DD/MM/YYYY' },
  { code: 'id', name: 'Bahasa Indonesia', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', continent: 'Asia', currency: 'IDR', dateFormat: 'DD/MM/YYYY' },
  { code: 'ms', name: 'Bahasa Melayu', nativeName: 'Bahasa Melayu', flag: '🇲🇾', continent: 'Asia', currency: 'MYR', dateFormat: 'DD/MM/YYYY' },
  { code: 'tl', name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭', continent: 'Asia', currency: 'PHP', dateFormat: 'MM/DD/YYYY' },
  { code: 'en-SG', name: 'English (Singapore)', nativeName: 'English (Singapore)', flag: '🇸🇬', continent: 'Asia', currency: 'SGD', dateFormat: 'DD/MM/YYYY' },
  { code: 'en-HK', name: 'English (Hong Kong)', nativeName: 'English (Hong Kong)', flag: '🇭🇰', continent: 'Asia', currency: 'HKD', dateFormat: 'DD/MM/YYYY' },

  // Moyen-Orient
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', continent: 'Asia', currency: 'SAR', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-AE', name: 'العربية (الإمارات)', nativeName: 'العربية (الإمارات)', flag: '🇦🇪', continent: 'Asia', currency: 'AED', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-EG', name: 'العربية (مصر)', nativeName: 'العربية (مصر)', flag: '🇪🇬', continent: 'Africa', currency: 'EGP', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-MA', name: 'العربية (المغرب)', nativeName: 'العربية (المغرب)', flag: '🇲🇦', continent: 'Africa', currency: 'MAD', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-TN', name: 'العربية (تونس)', nativeName: 'العربية (تونس)', flag: '🇹🇳', continent: 'Africa', currency: 'TND', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'ar-DZ', name: 'العربية (الجزائر)', nativeName: 'العربية (الجزائر)', flag: '🇩🇿', continent: 'Africa', currency: 'DZD', dateFormat: 'DD/MM/YYYY', rtl: true },
  { code: 'fa', name: 'فارسی', nativeName: 'فارسی', flag: '🇮🇷', continent: 'Asia', currency: 'IRR', dateFormat: 'YYYY/MM/DD', rtl: true },
  { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷', continent: 'Asia', currency: 'TRY', dateFormat: 'DD.MM.YYYY' },
  { code: 'he', name: 'עברית', nativeName: 'עברית', flag: '🇮🇱', continent: 'Asia', currency: 'ILS', dateFormat: 'DD/MM/YYYY', rtl: true },

  // Afrique
  { code: 'sw', name: 'Kiswahili', nativeName: 'Kiswahili', flag: '🇰🇪', continent: 'Africa', currency: 'KES', dateFormat: 'DD/MM/YYYY' },
  { code: 'am', name: 'አማርኛ', nativeName: 'አማርኛ', flag: '🇪🇹', continent: 'Africa', currency: 'ETB', dateFormat: 'DD/MM/YYYY' },
  { code: 'ha', name: 'Hausa', nativeName: 'Hausa', flag: '🇳🇬', continent: 'Africa', currency: 'NGN', dateFormat: 'DD/MM/YYYY' },
  { code: 'yo', name: 'Yorùbá', nativeName: 'Yorùbá', flag: '🇳🇬', continent: 'Africa', currency: 'NGN', dateFormat: 'DD/MM/YYYY' },
  { code: 'ig', name: 'Igbo', nativeName: 'Igbo', flag: '🇳🇬', continent: 'Africa', currency: 'NGN', dateFormat: 'DD/MM/YYYY' },
  { code: 'fr-MA', name: 'Français (Maroc)', nativeName: 'Français (Maroc)', flag: '🇲🇦', continent: 'Africa', currency: 'MAD', dateFormat: 'DD/MM/YYYY' },
  { code: 'fr-SN', name: 'Français (Sénégal)', nativeName: 'Français (Sénégal)', flag: '🇸🇳', continent: 'Africa', currency: 'XOF', dateFormat: 'DD/MM/YYYY' },
  { code: 'fr-CI', name: 'Français (Côte d\'Ivoire)', nativeName: 'Français (Côte d\'Ivoire)', flag: '🇨🇮', continent: 'Africa', currency: 'XOF', dateFormat: 'DD/MM/YYYY' },
  { code: 'pt-AO', name: 'Português (Angola)', nativeName: 'Português (Angola)', flag: '🇦🇴', continent: 'Africa', currency: 'AOA', dateFormat: 'DD/MM/YYYY' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', continent: 'Africa', currency: 'ZAR', dateFormat: 'DD/MM/YYYY' },
  { code: 'zu', name: 'isiZulu', nativeName: 'isiZulu', flag: '🇿🇦', continent: 'Africa', currency: 'ZAR', dateFormat: 'DD/MM/YYYY' },

  // Océanie
  { code: 'en-AU', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', continent: 'Oceania', currency: 'AUD', dateFormat: 'DD/MM/YYYY' },
  { code: 'en-NZ', name: 'English (New Zealand)', nativeName: 'English (New Zealand)', flag: '🇳🇿', continent: 'Oceania', currency: 'NZD', dateFormat: 'DD/MM/YYYY' },
  { code: 'fj', name: 'Fijian', nativeName: 'Na Vosa Vakaviti', flag: '🇫🇯', continent: 'Oceania', currency: 'FJD', dateFormat: 'DD/MM/YYYY' },
];

export const CONTINENTS = [
  { code: 'europe', name: 'Europe', emoji: '🇪🇺' },
  { code: 'north-america', name: 'North America', emoji: '🌎' },
  { code: 'south-america', name: 'South America', emoji: '🌎' },
  { code: 'asia', name: 'Asia', emoji: '🌏' },
  { code: 'africa', name: 'Africa', emoji: '🌍' },
  { code: 'oceania', name: 'Oceania', emoji: '🇦🇺' },
];

export const CURRENCIES = [
  { code: 'USD', symbol: '$', name: 'US Dollar' },
  { code: 'EUR', symbol: '€', name: 'Euro' },
  { code: 'GBP', symbol: '£', name: 'British Pound' },
  { code: 'JPY', symbol: '¥', name: 'Japanese Yen' },
  { code: 'CNY', symbol: '¥', name: 'Chinese Yuan' },
  { code: 'INR', symbol: '₹', name: 'Indian Rupee' },
  { code: 'BRL', symbol: 'R$', name: 'Brazilian Real' },
  { code: 'CAD', symbol: 'C$', name: 'Canadian Dollar' },
  { code: 'AUD', symbol: 'A$', name: 'Australian Dollar' },
  { code: 'SAR', symbol: '﷼', name: 'Saudi Riyal' },
  { code: 'AED', symbol: 'د.إ', name: 'UAE Dirham' },
  { code: 'EGP', symbol: 'E£', name: 'Egyptian Pound' },
  { code: 'ZAR', symbol: 'R', name: 'South African Rand' },
  { code: 'NGN', symbol: '₦', name: 'Nigerian Naira' },
  { code: 'KES', symbol: 'KSh', name: 'Kenyan Shilling' },
  { code: 'MAD', symbol: 'DH', name: 'Moroccan Dirham' },
];
