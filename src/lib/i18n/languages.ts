// ===================================================================
// 🌍 SYSTÈME DE LANGUES MONDIAL - 75+ LANGUES
// Toutes les langues du monde avec drapeaux et support RTL
// ===================================================================

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  region: string;
  rtl?: boolean;
  currency?: string;
  country?: string;
}

// LANGUES MONDIALES (sans hébreu selon spécifications)
export const WORLD_LANGUAGES: Language[] = [
  // EUROPE
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', region: 'Europe', currency: 'EUR', country: 'France' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧', region: 'Europe', currency: 'GBP', country: 'United Kingdom' },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', region: 'Europe', currency: 'EUR', country: 'Spain' },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe', currency: 'EUR', country: 'Germany' },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe', currency: 'EUR', country: 'Italy' },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', region: 'Europe', currency: 'EUR', country: 'Portugal' },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe', currency: 'RUB', country: 'Russia' },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', region: 'Europe', currency: 'EUR', country: 'Netherlands' },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', region: 'Europe', currency: 'PLN', country: 'Poland' },
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', region: 'Europe', currency: 'SEK', country: 'Sweden' },
  { code: 'no', name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', region: 'Europe', currency: 'NOK', country: 'Norway' },
  { code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', region: 'Europe', currency: 'DKK', country: 'Denmark' },
  { code: 'fi', name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮', region: 'Europe', currency: 'EUR', country: 'Finland' },
  { code: 'cs', name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿', region: 'Europe', currency: 'CZK', country: 'Czech Republic' },
  { code: 'hu', name: 'Hungarian', nativeName: 'Magyar', flag: '🇭🇺', region: 'Europe', currency: 'HUF', country: 'Hungary' },
  { code: 'ro', name: 'Romanian', nativeName: 'Română', flag: '🇷🇴', region: 'Europe', currency: 'RON', country: 'Romania' },
  { code: 'bg', name: 'Bulgarian', nativeName: 'Български', flag: '🇧🇬', region: 'Europe', currency: 'BGN', country: 'Bulgaria' },
  { code: 'hr', name: 'Croatian', nativeName: 'Hrvatski', flag: '🇭🇷', region: 'Europe', currency: 'EUR', country: 'Croatia' },
  { code: 'sk', name: 'Slovak', nativeName: 'Slovenčina', flag: '🇸🇰', region: 'Europe', currency: 'EUR', country: 'Slovakia' },
  { code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina', flag: '🇸🇮', region: 'Europe', currency: 'EUR', country: 'Slovenia' },
  { code: 'et', name: 'Estonian', nativeName: 'Eesti', flag: '🇪🇪', region: 'Europe', currency: 'EUR', country: 'Estonia' },
  { code: 'lv', name: 'Latvian', nativeName: 'Latviešu', flag: '🇱🇻', region: 'Europe', currency: 'EUR', country: 'Latvia' },
  { code: 'lt', name: 'Lithuanian', nativeName: 'Lietuvių', flag: '🇱🇹', region: 'Europe', currency: 'EUR', country: 'Lithuania' },
  { code: 'el', name: 'Greek', nativeName: 'Ελληνικά', flag: '🇬🇷', region: 'Europe', currency: 'EUR', country: 'Greece' },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', region: 'Europe', currency: 'TRY', country: 'Turkey' },
  
  // MOYEN-ORIENT & AFRIQUE DU NORD (ARABE AVEC DRAPEAU MAROCAIN)
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇲🇦', region: 'MENA', rtl: true, currency: 'MAD', country: 'Morocco' },
  { code: 'fa', name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', region: 'MENA', rtl: true, currency: 'IRR', country: 'Iran' },
  
  // ASIE
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', region: 'Asia', currency: 'CNY', country: 'China' },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', region: 'Asia', currency: 'JPY', country: 'Japan' },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', region: 'Asia', currency: 'KRW', country: 'South Korea' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'th', name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', region: 'Asia', currency: 'THB', country: 'Thailand' },
  { code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', region: 'Asia', currency: 'VND', country: 'Vietnam' },
  { code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', region: 'Asia', currency: 'IDR', country: 'Indonesia' },
  { code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾', region: 'Asia', currency: 'MYR', country: 'Malaysia' },
  { code: 'tl', name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭', region: 'Asia', currency: 'PHP', country: 'Philippines' },
  { code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩', region: 'Asia', currency: 'BDT', country: 'Bangladesh' },
  { code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰', region: 'Asia', rtl: true, currency: 'PKR', country: 'Pakistan' },
  { code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇱🇰', region: 'Asia', currency: 'LKR', country: 'Sri Lanka' },
  { code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'mr', name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳', region: 'Asia', currency: 'INR', country: 'India' },
  { code: 'si', name: 'Sinhala', nativeName: 'සිංහල', flag: '🇱🇰', region: 'Asia', currency: 'LKR', country: 'Sri Lanka' },
  { code: 'my', name: 'Myanmar', nativeName: 'မြန်မာ', flag: '🇲🇲', region: 'Asia', currency: 'MMK', country: 'Myanmar' },
  { code: 'km', name: 'Khmer', nativeName: 'ខ្មែរ', flag: '🇰🇭', region: 'Asia', currency: 'KHR', country: 'Cambodia' },
  { code: 'lo', name: 'Lao', nativeName: 'ລາວ', flag: '🇱🇦', region: 'Asia', currency: 'LAK', country: 'Laos' },
  { code: 'ka', name: 'Georgian', nativeName: 'ქართული', flag: '🇬🇪', region: 'Asia', currency: 'GEL', country: 'Georgia' },
  { code: 'hy', name: 'Armenian', nativeName: 'Հայերեն', flag: '🇦🇲', region: 'Asia', currency: 'AMD', country: 'Armenia' },
  { code: 'az', name: 'Azerbaijani', nativeName: 'Azərbaycan', flag: '🇦🇿', region: 'Asia', currency: 'AZN', country: 'Azerbaijan' },
  { code: 'kk', name: 'Kazakh', nativeName: 'Қазақ', flag: '🇰🇿', region: 'Asia', currency: 'KZT', country: 'Kazakhstan' },
  { code: 'ky', name: 'Kyrgyz', nativeName: 'Кыргыз', flag: '🇰🇬', region: 'Asia', currency: 'KGS', country: 'Kyrgyzstan' },
  { code: 'uz', name: 'Uzbek', nativeName: 'Oʻzbek', flag: '🇺🇿', region: 'Asia', currency: 'UZS', country: 'Uzbekistan' },
  { code: 'tj', name: 'Tajik', nativeName: 'Тоҷикӣ', flag: '🇹🇯', region: 'Asia', currency: 'TJS', country: 'Tajikistan' },
  { code: 'tm', name: 'Turkmen', nativeName: 'Türkmen', flag: '🇹🇲', region: 'Asia', currency: 'TMT', country: 'Turkmenistan' },
  { code: 'mn', name: 'Mongolian', nativeName: 'Монгол', flag: '🇲🇳', region: 'Asia', currency: 'MNT', country: 'Mongolia' },
  
  // AMÉRIQUES
  { code: 'pt-br', name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', region: 'Americas', currency: 'BRL', country: 'Brazil' },
  { code: 'es-mx', name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', region: 'Americas', currency: 'MXN', country: 'Mexico' },
  { code: 'es-ar', name: 'Spanish (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', region: 'Americas', currency: 'ARS', country: 'Argentina' },
  { code: 'es-co', name: 'Spanish (Colombia)', nativeName: 'Español (Colombia)', flag: '🇨🇴', region: 'Americas', currency: 'COP', country: 'Colombia' },
  { code: 'es-pe', name: 'Spanish (Peru)', nativeName: 'Español (Perú)', flag: '🇵🇪', region: 'Americas', currency: 'PEN', country: 'Peru' },
  { code: 'es-cl', name: 'Spanish (Chile)', nativeName: 'Español (Chile)', flag: '🇨🇱', region: 'Americas', currency: 'CLP', country: 'Chile' },
  { code: 'en-us', name: 'English (US)', nativeName: 'English (US)', flag: '🇺🇸', region: 'Americas', currency: 'USD', country: 'United States' },
  { code: 'en-ca', name: 'English (Canada)', nativeName: 'English (Canada)', flag: '🇨🇦', region: 'Americas', currency: 'CAD', country: 'Canada' },
  { code: 'fr-ca', name: 'French (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', region: 'Americas', currency: 'CAD', country: 'Canada' },
  { code: 'qu', name: 'Quechua', nativeName: 'Runasimi', flag: '🇵🇪', region: 'Americas', currency: 'PEN', country: 'Peru' },
  { code: 'gn', name: 'Guarani', nativeName: 'Avañe\'ẽ', flag: '🇵🇾', region: 'Americas', currency: 'PYG', country: 'Paraguay' },
  
  // AFRIQUE
  { code: 'sw', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', region: 'Africa', currency: 'KES', country: 'Kenya' },
  { code: 'am', name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', region: 'Africa', currency: 'ETB', country: 'Ethiopia' },
  { code: 'ha', name: 'Hausa', nativeName: 'Hausa', flag: '🇳🇬', region: 'Africa', currency: 'NGN', country: 'Nigeria' },
  { code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', region: 'Africa', currency: 'NGN', country: 'Nigeria' },
  { code: 'ig', name: 'Igbo', nativeName: 'Igbo', flag: '🇳🇬', region: 'Africa', currency: 'NGN', country: 'Nigeria' },
  { code: 'zu', name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦', region: 'Africa', currency: 'ZAR', country: 'South Africa' },
  { code: 'xh', name: 'Xhosa', nativeName: 'isiXhosa', flag: '🇿🇦', region: 'Africa', currency: 'ZAR', country: 'South Africa' },
  { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', region: 'Africa', currency: 'ZAR', country: 'South Africa' },
  { code: 'mg', name: 'Malagasy', nativeName: 'Malagasy', flag: '🇲🇬', region: 'Africa', currency: 'MGA', country: 'Madagascar' },
  
  // OCÉANIE
  { code: 'en-au', name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', region: 'Oceania', currency: 'AUD', country: 'Australia' },
  { code: 'en-nz', name: 'English (New Zealand)', nativeName: 'English (New Zealand)', flag: '🇳🇿', region: 'Oceania', currency: 'NZD', country: 'New Zealand' },
  { code: 'mi', name: 'Maori', nativeName: 'Te Reo Māori', flag: '🇳🇿', region: 'Oceania', currency: 'NZD', country: 'New Zealand' },
  { code: 'haw', name: 'Hawaiian', nativeName: 'ʻŌlelo Hawaiʻi', flag: '🏝️', region: 'Oceania', currency: 'USD', country: 'Hawaii' },
  { code: 'sm', name: 'Samoan', nativeName: 'Gagana Samoa', flag: '🇼🇸', region: 'Oceania', currency: 'WST', country: 'Samoa' },
  { code: 'to', name: 'Tongan', nativeName: 'Lea Fakatonga', flag: '🇹🇴', region: 'Oceania', currency: 'TOP', country: 'Tonga' },
  { code: 'fj', name: 'Fijian', nativeName: 'Na Vosa Vakaviti', flag: '🇫🇯', region: 'Oceania', currency: 'FJD', country: 'Fiji' }
];

export const RTL_LANGUAGES = ['ar', 'fa', 'ur'];

export const REGIONS = {
  Europe: '🇪🇺',
  MENA: '🕌',
  Asia: '🌏',
  Americas: '🌎',
  Africa: '🌍',
  Oceania: '🏝️'
};

export function getLanguagesByRegion() {
  return WORLD_LANGUAGES.reduce((acc, lang) => {
    if (!acc[lang.region]) acc[lang.region] = [];
    acc[lang.region].push(lang);
    return acc;
  }, {} as Record<string, Language[]>);
}

export function getLanguageByCode(code: string): Language | undefined {
  return WORLD_LANGUAGES.find(lang => lang.code === code);
}

export function isRTL(languageCode: string): boolean {
  return RTL_LANGUAGES.includes(languageCode);
}
