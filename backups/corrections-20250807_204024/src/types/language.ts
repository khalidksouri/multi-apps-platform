/**
 * Types pour le système de langues de Math4Child
 */

export interface Language {
  code: string
  name: string
  flag: string
  rtl?: boolean
  region?: string
  nativeName?: string
}

export interface Translation {
  [key: string]: string | Translation
}

export interface Translations {
  [languageCode: string]: Translation
}

export interface LanguageConfig {
  supportedLanguages: Language[]
  defaultLanguage: string
  fallbackLanguage: string
  rtlLanguages: string[]
}

export interface LanguageContextType {
  currentLanguage: Language | null
  setLanguage: (language: Language) => void
  t: (key: string, params?: Record<string, string>) => string
  isRTL: boolean
  isLoading: boolean
}

export interface LanguageDropdownProps {
  onLanguageChange?: (language: Language) => void
  className?: string
  defaultLanguage?: string
  disabled?: boolean
  showSearch?: boolean
  maxHeight?: number
  placement?: 'bottom' | 'top'
}

export interface LanguageProviderProps {
  children: React.ReactNode
  defaultLanguage?: string
  translations?: Translations
}

// Constantes pour les langues supportées
export const SUPPORTED_LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', nativeName: 'Français' },
  { code: 'en', name: 'English', flag: '🇺🇸', nativeName: 'English' },
  { code: 'es', name: 'Español', flag: '🇪🇸', nativeName: 'Español' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', nativeName: 'Deutsch' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', nativeName: 'Italiano' },
  { code: 'pt', name: 'Português', flag: '🇵🇹', nativeName: 'Português' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺', nativeName: 'Русский' },
  { code: 'zh', name: '中文', flag: '🇨🇳', nativeName: '中文' },
  { code: 'ja', name: '日本語', flag: '🇯🇵', nativeName: '日本語' },
  { code: 'ko', name: '한국어', flag: '🇰🇷', nativeName: '한국어' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', nativeName: 'العربية', rtl: true },
  { code: 'he', name: 'עברית', flag: '🇮🇱', nativeName: 'עברית', rtl: true },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', nativeName: 'हिन्दी' },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷', nativeName: 'Türkçe' },
  { code: 'pl', name: 'Polski', flag: '🇵🇱', nativeName: 'Polski' },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱', nativeName: 'Nederlands' },
  { code: 'sv', name: 'Svenska', flag: '🇸🇪', nativeName: 'Svenska' },
  { code: 'da', name: 'Dansk', flag: '🇩🇰', nativeName: 'Dansk' },
  { code: 'no', name: 'Norsk', flag: '🇳🇴', nativeName: 'Norsk' },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮', nativeName: 'Suomi' }
]

export const RTL_LANGUAGES = ['ar', 'he', 'fa', 'ur']

export const DEFAULT_LANGUAGE = 'en'
export const FALLBACK_LANGUAGE = 'en'
