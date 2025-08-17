import { Language } from '@/types'

export const languages: Language[] = [
  // Langues principales avec drapeaux spécifiques
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'ar-ma', name: 'العربية (المغرب)', nativeName: 'العربية', flag: '🇲🇦', rtl: true, regions: ['Morocco', 'Algeria', 'Tunisia'] },
  { code: 'ar-ps', name: 'العربية (فلسطين)', nativeName: 'العربية', flag: '🇵🇸', rtl: true, regions: ['Palestine', 'Jordan', 'Lebanon', 'Syria'] },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹' },
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺' },
  { code: 'zh', name: '中文', nativeName: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵' },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷' },
  { code: 'hi', name: 'हिंदी', nativeName: 'हिंदी', flag: '🇮🇳' },
  { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷' },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱' },
  { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱' },
  { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪' },
  { code: 'no', name: 'Norsk', nativeName: 'Norsk', flag: '🇳🇴' },
  { code: 'da', name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰' },
  { code: 'fi', name: 'Suomi', nativeName: 'Suomi', flag: '🇫🇮' },
  // ... 180+ autres langues seraient ici dans la version complète
]

export const getLanguageByCode = (code: string): Language | undefined => {
  return languages.find(lang => lang.code === code)
}

export const getLanguagesByRegion = (region: string): Language[] => {
  return languages.filter(lang => lang.regions?.includes(region))
}
