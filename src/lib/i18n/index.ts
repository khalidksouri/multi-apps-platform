// =============================================================================
// 🌍 INTERNATIONALISATION MATH4CHILD v4.2.0 - CORRIGÉE
// =============================================================================

import { Language } from '@/types'

export const supportedLanguages: Language[] = [
  { code: 'fr-FR', name: 'Français', nativeName: 'Français', flag: '🇫🇷', regions: ['Europe', 'Afrique'] },
  { code: 'en-US', name: 'English', nativeName: 'English', flag: '🇺🇸', regions: ['Amérique'] },
  { code: 'es-ES', name: 'Español', nativeName: 'Español', flag: '🇪🇸', regions: ['Europe'] },
  { code: 'de-DE', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', regions: ['Europe'] },
  { code: 'it-IT', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', regions: ['Europe'] },
  { code: 'pt-PT', name: 'Português', nativeName: 'Português', flag: '🇵🇹', regions: ['Europe'] },
  { code: 'ru-RU', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', regions: ['Europe'] },
  { code: 'zh-CN', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', regions: ['Asie'] },
  { code: 'ja-JP', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', regions: ['Asie'] },
  { code: 'ko-KR', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', regions: ['Asie'] },
  { code: 'ar-MA', name: 'العربية', nativeName: 'العربية', flag: '🇲🇦', regions: ['Afrique'] },
  { code: 'ar-PS', name: 'العربية', nativeName: 'العربية', flag: '🇵🇸', regions: ['Moyen-Orient'] },
  { code: 'hi-IN', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', regions: ['Asie'] },
  { code: 'tr-TR', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷', regions: ['Europe'] },
  { code: 'pl-PL', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', regions: ['Europe'] },
  { code: 'nl-NL', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', regions: ['Europe'] },
  { code: 'sv-SE', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', regions: ['Europe'] },
  { code: 'da-DK', name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰', regions: ['Europe'] }
]

// Fonction pour obtenir une langue par code
export const getLanguageByCode = (code: string): Language | undefined => {
  return supportedLanguages.find(lang => lang.code === code)
}

// Fonction pour obtenir toutes les langues d'une région
export const getLanguagesByRegion = (region: string): Language[] => {
  return supportedLanguages.filter(lang => lang.regions.includes(region))
}

export default supportedLanguages
