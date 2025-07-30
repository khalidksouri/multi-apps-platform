export const defaultLanguage = 'fr'

export const supportedLanguages = ['fr', 'en', 'es', 'de', 'it', 'pt', 'nl', 'ru', 'pl', 'sv', 'da', 'no', 'fi', 'zh', 'ja', 'ko', 'hi', 'th', 'vi', 'ar', 'he', 'fa', 'ur', 'tr'] as const

export type SupportedLanguage = typeof supportedLanguages[number]

export const languageNames: Record<SupportedLanguage, string> = {
  fr: 'Français', en: 'English', es: 'Español', de: 'Deutsch', it: 'Italiano',
  pt: 'Português', nl: 'Nederlands', ru: 'Русский', pl: 'Polski', sv: 'Svenska',
  da: 'Dansk', no: 'Norsk', fi: 'Suomi', zh: '中文', ja: '日本語',
  ko: '한국어', hi: 'हिन्दी', th: 'ไทย', vi: 'Tiếng Việt', ar: 'العربية',
  he: 'עברית', fa: 'فارسی', ur: 'اردو', tr: 'Türkçe'
}

export const rtlLanguages: SupportedLanguage[] = ['ar', 'he', 'fa', 'ur']

export function isRTL(language: SupportedLanguage): boolean {
  return rtlLanguages.includes(language)
}
