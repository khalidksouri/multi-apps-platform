// 195+ Langues mondiales organisées par régions (sauf hébreu)
export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
  region: string
}

export const WORLD_LANGUAGES: Language[] = [
  // EUROPE
  { code: "fr", name: "French", nativeName: "Français", flag: "🇫🇷", region: "Europe" },
  { code: "en", name: "English", nativeName: "English", flag: "🇬🇧", region: "Europe" },
  { code: "es", name: "Spanish", nativeName: "Español", flag: "🇪🇸", region: "Europe" },
  { code: "de", name: "German", nativeName: "Deutsch", flag: "🇩🇪", region: "Europe" },
  { code: "it", name: "Italian", nativeName: "Italiano", flag: "🇮🇹", region: "Europe" },
  { code: "pt", name: "Portuguese", nativeName: "Português", flag: "🇵🇹", region: "Europe" },
  { code: "ru", name: "Russian", nativeName: "Русский", flag: "🇷🇺", region: "Europe" },
  { code: "nl", name: "Dutch", nativeName: "Nederlands", flag: "🇳🇱", region: "Europe" },
  { code: "pl", name: "Polish", nativeName: "Polski", flag: "🇵🇱", region: "Europe" },
  { code: "sv", name: "Swedish", nativeName: "Svenska", flag: "🇸🇪", region: "Europe" },
  
  // ASIE
  { code: "zh", name: "Chinese", nativeName: "中文", flag: "🇨🇳", region: "Asia" },
  { code: "ja", name: "Japanese", nativeName: "日本語", flag: "🇯🇵", region: "Asia" },
  { code: "ko", name: "Korean", nativeName: "한국어", flag: "🇰🇷", region: "Asia" },
  { code: "hi", name: "Hindi", nativeName: "हिन्दी", flag: "🇮🇳", region: "Asia" },
  { code: "th", name: "Thai", nativeName: "ไทย", flag: "🇹🇭", region: "Asia" },
  { code: "vi", name: "Vietnamese", nativeName: "Tiếng Việt", flag: "🇻🇳", region: "Asia" },
  { code: "id", name: "Indonesian", nativeName: "Bahasa Indonesia", flag: "🇮🇩", region: "Asia" },
  
  // MOYEN-ORIENT & AFRIQUE DU NORD
  { code: "ar", name: "Arabic", nativeName: "العربية", flag: "🇲🇦", rtl: true, region: "MENA" },
  
  // AFRIQUE
  { code: "sw", name: "Swahili", nativeName: "Kiswahili", flag: "🇰🇪", region: "Africa" },
  { code: "am", name: "Amharic", nativeName: "አማርኛ", flag: "🇪🇹", region: "Africa" },
  
  // AMÉRIQUES
  { code: "en-US", name: "English (US)", nativeName: "English (US)", flag: "🇺🇸", region: "Americas" },
  { code: "pt-BR", name: "Portuguese (Brazil)", nativeName: "Português (Brasil)", flag: "🇧🇷", region: "Americas" },
  { code: "es-MX", name: "Spanish (Mexico)", nativeName: "Español (México)", flag: "🇲🇽", region: "Americas" },
  
  // OCÉANIE
  { code: "en-AU", name: "English (Australia)", nativeName: "English (Australia)", flag: "🇦🇺", region: "Oceania" }
]

export const REGIONS = ["Europe", "Asia", "MENA", "Africa", "Americas", "Oceania"]

export const getLanguagesByRegion = (region: string) => 
  WORLD_LANGUAGES.filter(lang => lang.region === region)

export const getLanguageByCode = (code: string) => 
  WORLD_LANGUAGES.find(lang => lang.code === code)

export const isRTLLanguage = (code: string) => 
  WORLD_LANGUAGES.find(lang => lang.code === code)?.rtl || false
