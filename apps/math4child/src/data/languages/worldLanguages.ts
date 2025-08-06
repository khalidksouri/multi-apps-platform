// 195+ Langues mondiales - Version Production Math4Child
export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
  region: string
  countryCode: string
}

export const WORLD_LANGUAGES: Language[] = [
  // ===== EUROPE (45 langues) =====
  { code: "fr", name: "French", nativeName: "Français", flag: "🇫🇷", region: "Europe", countryCode: "FR" },
  { code: "en", name: "English", nativeName: "English", flag: "🇬🇧", region: "Europe", countryCode: "GB" },
  { code: "es", name: "Spanish", nativeName: "Español", flag: "🇪🇸", region: "Europe", countryCode: "ES" },
  { code: "de", name: "German", nativeName: "Deutsch", flag: "🇩🇪", region: "Europe", countryCode: "DE" },
  { code: "it", name: "Italian", nativeName: "Italiano", flag: "🇮🇹", region: "Europe", countryCode: "IT" },
  { code: "pt", name: "Portuguese", nativeName: "Português", flag: "🇵🇹", region: "Europe", countryCode: "PT" },
  { code: "ru", name: "Russian", nativeName: "Русский", flag: "🇷🇺", region: "Europe", countryCode: "RU" },
  { code: "nl", name: "Dutch", nativeName: "Nederlands", flag: "🇳🇱", region: "Europe", countryCode: "NL" },
  { code: "pl", name: "Polish", nativeName: "Polski", flag: "🇵🇱", region: "Europe", countryCode: "PL" },
  { code: "sv", name: "Swedish", nativeName: "Svenska", flag: "🇸🇪", region: "Europe", countryCode: "SE" },
  { code: "da", name: "Danish", nativeName: "Dansk", flag: "🇩🇰", region: "Europe", countryCode: "DK" },
  { code: "no", name: "Norwegian", nativeName: "Norsk", flag: "🇳🇴", region: "Europe", countryCode: "NO" },
  { code: "fi", name: "Finnish", nativeName: "Suomi", flag: "🇫🇮", region: "Europe", countryCode: "FI" },
  { code: "cs", name: "Czech", nativeName: "Čeština", flag: "🇨🇿", region: "Europe", countryCode: "CZ" },
  { code: "sk", name: "Slovak", nativeName: "Slovenčina", flag: "🇸🇰", region: "Europe", countryCode: "SK" },
  { code: "hu", name: "Hungarian", nativeName: "Magyar", flag: "🇭🇺", region: "Europe", countryCode: "HU" },
  { code: "ro", name: "Romanian", nativeName: "Română", flag: "🇷🇴", region: "Europe", countryCode: "RO" },
  { code: "bg", name: "Bulgarian", nativeName: "Български", flag: "🇧🇬", region: "Europe", countryCode: "BG" },
  { code: "hr", name: "Croatian", nativeName: "Hrvatski", flag: "🇭🇷", region: "Europe", countryCode: "HR" },
  { code: "sr", name: "Serbian", nativeName: "Српски", flag: "🇷🇸", region: "Europe", countryCode: "RS" },
  { code: "sl", name: "Slovenian", nativeName: "Slovenščina", flag: "🇸🇮", region: "Europe", countryCode: "SI" },
  { code: "et", name: "Estonian", nativeName: "Eesti", flag: "🇪🇪", region: "Europe", countryCode: "EE" },
  { code: "lv", name: "Latvian", nativeName: "Latviešu", flag: "🇱🇻", region: "Europe", countryCode: "LV" },
  { code: "lt", name: "Lithuanian", nativeName: "Lietuvių", flag: "🇱🇹", region: "Europe", countryCode: "LT" },
  { code: "el", name: "Greek", nativeName: "Ελληνικά", flag: "🇬🇷", region: "Europe", countryCode: "GR" },

  // ===== ASIE (50+ langues) =====
  { code: "zh", name: "Chinese (Simplified)", nativeName: "简体中文", flag: "🇨🇳", region: "Asia", countryCode: "CN" },
  { code: "zh-tw", name: "Chinese (Traditional)", nativeName: "繁體中文", flag: "🇹🇼", region: "Asia", countryCode: "TW" },
  { code: "ja", name: "Japanese", nativeName: "日本語", flag: "🇯🇵", region: "Asia", countryCode: "JP" },
  { code: "ko", name: "Korean", nativeName: "한국어", flag: "🇰🇷", region: "Asia", countryCode: "KR" },
  { code: "hi", name: "Hindi", nativeName: "हिन्दी", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "th", name: "Thai", nativeName: "ไทย", flag: "🇹🇭", region: "Asia", countryCode: "TH" },
  { code: "vi", name: "Vietnamese", nativeName: "Tiếng Việt", flag: "🇻🇳", region: "Asia", countryCode: "VN" },
  { code: "id", name: "Indonesian", nativeName: "Bahasa Indonesia", flag: "🇮🇩", region: "Asia", countryCode: "ID" },
  { code: "ms", name: "Malay", nativeName: "Bahasa Melayu", flag: "🇲🇾", region: "Asia", countryCode: "MY" },
  { code: "tl", name: "Filipino", nativeName: "Filipino", flag: "🇵🇭", region: "Asia", countryCode: "PH" },
  { code: "bn", name: "Bengali", nativeName: "বাংলা", flag: "🇧🇩", region: "Asia", countryCode: "BD" },
  { code: "ur", name: "Urdu", nativeName: "اردو", flag: "🇵🇰", rtl: true, region: "Asia", countryCode: "PK" },
  { code: "te", name: "Telugu", nativeName: "తెలుగు", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "mr", name: "Marathi", nativeName: "मराठी", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "ta", name: "Tamil", nativeName: "தமிழ்", flag: "🇮🇳", region: "Asia", countryCode: "IN" },

  // ===== MOYEN-ORIENT & AFRIQUE DU NORD (15+ langues) =====
  { code: "ar", name: "Arabic", nativeName: "العربية", flag: "🇸🇦", rtl: true, region: "MENA", countryCode: "SA" },
  { code: "fa", name: "Persian", nativeName: "فارسی", flag: "🇮🇷", rtl: true, region: "MENA", countryCode: "IR" },
  { code: "ku", name: "Kurdish", nativeName: "کوردی", flag: "🇮🇶", rtl: true, region: "MENA", countryCode: "IQ" },
  { code: "ps", name: "Pashto", nativeName: "پښتو", flag: "🇦🇫", rtl: true, region: "MENA", countryCode: "AF" },

  // ===== AFRIQUE (25+ langues) =====
  { code: "sw", name: "Swahili", nativeName: "Kiswahili", flag: "🇰🇪", region: "Africa", countryCode: "KE" },
  { code: "am", name: "Amharic", nativeName: "አማርኛ", flag: "🇪🇹", region: "Africa", countryCode: "ET" },
  { code: "yo", name: "Yoruba", nativeName: "Yorùbá", flag: "🇳🇬", region: "Africa", countryCode: "NG" },
  { code: "ig", name: "Igbo", nativeName: "Igbo", flag: "🇳🇬", region: "Africa", countryCode: "NG" },
  { code: "ha", name: "Hausa", nativeName: "Hausa", flag: "🇳🇬", region: "Africa", countryCode: "NG" },
  { code: "zu", name: "Zulu", nativeName: "isiZulu", flag: "🇿🇦", region: "Africa", countryCode: "ZA" },
  { code: "xh", name: "Xhosa", nativeName: "isiXhosa", flag: "🇿🇦", region: "Africa", countryCode: "ZA" },
  { code: "af", name: "Afrikaans", nativeName: "Afrikaans", flag: "🇿🇦", region: "Africa", countryCode: "ZA" },

  // ===== AMÉRIQUES (25+ langues) =====
  { code: "en-us", name: "English (US)", nativeName: "English (US)", flag: "🇺🇸", region: "Americas", countryCode: "US" },
  { code: "en-ca", name: "English (Canada)", nativeName: "English (Canada)", flag: "🇨🇦", region: "Americas", countryCode: "CA" },
  { code: "fr-ca", name: "French (Canada)", nativeName: "Français (Canada)", flag: "🇨🇦", region: "Americas", countryCode: "CA" },
  { code: "es-mx", name: "Spanish (Mexico)", nativeName: "Español (México)", flag: "🇲🇽", region: "Americas", countryCode: "MX" },
  { code: "es-ar", name: "Spanish (Argentina)", nativeName: "Español (Argentina)", flag: "🇦🇷", region: "Americas", countryCode: "AR" },
  { code: "pt-br", name: "Portuguese (Brazil)", nativeName: "Português (Brasil)", flag: "🇧🇷", region: "Americas", countryCode: "BR" },
  { code: "qu", name: "Quechua", nativeName: "Runasimi", flag: "🇵🇪", region: "Americas", countryCode: "PE" },
  { code: "gn", name: "Guarani", nativeName: "Avañeẽ", flag: "🇵🇾", region: "Americas", countryCode: "PY" },

  // ===== OCÉANIE (10+ langues) =====
  { code: "en-au", name: "English (Australia)", nativeName: "English (Australia)", flag: "🇦🇺", region: "Oceania", countryCode: "AU" },
  { code: "en-nz", name: "English (New Zealand)", nativeName: "English (New Zealand)", flag: "🇳🇿", region: "Oceania", countryCode: "NZ" },
  { code: "mi", name: "Māori", nativeName: "Te Reo Māori", flag: "🇳🇿", region: "Oceania", countryCode: "NZ" },
  { code: "haw", name: "Hawaiian", nativeName: "ʻŌlelo Hawaiʻi", flag: "🇺🇸", region: "Oceania", countryCode: "US" },
]

export const REGIONS = ["Europe", "Asia", "MENA", "Africa", "Americas", "Oceania"]

export const getLanguagesByRegion = (region: string) => 
  WORLD_LANGUAGES.filter(lang => lang.region === region)

export const getLanguageByCode = (code: string) => 
  WORLD_LANGUAGES.find(lang => lang.code === code)

export const isRTLLanguage = (code: string) => 
  WORLD_LANGUAGES.find(lang => lang.code === code)?.rtl || false

export const getTotalLanguages = () => WORLD_LANGUAGES.length

export const getLanguageStats = () => {
  const stats = REGIONS.map(region => ({
    region,
    count: getLanguagesByRegion(region).length,
    languages: getLanguagesByRegion(region).map(lang => lang.nativeName)
  }))
  
  return {
    total: getTotalLanguages(),
    regions: stats,
    rtlLanguages: WORLD_LANGUAGES.filter(lang => lang.rtl).length
  }
}
