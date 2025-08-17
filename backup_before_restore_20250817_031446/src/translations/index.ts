// =============================================================================
// 🌍 SYSTÈME DE TRADUCTION MATH4CHILD v4.2.0
// =============================================================================

export interface Translation {
  [key: string]: string | Translation;
}

export interface TranslationData {
  title: string;
  subtitle: string;
  description: string;
  features: string[];
  cta: string;
  [key: string]: string | string[] | Translation;
}

export interface Translations {
  [languageCode: string]: TranslationData;
}

// Import des traductions
import { translations as importedTranslations } from '@/data/translations';

export const translations: Translations = importedTranslations;

export function getTranslation(languageCode: string, key: string): string {
  const langData = translations[languageCode];
  if (!langData) {
    return key; // Fallback au key si langue non trouvée
  }
  
  const keys = key.split('.');
  let current: any = langData;
  
  for (const k of keys) {
    if (current && typeof current === 'object' && k in current) {
      current = current[k];
    } else {
      return key; // Fallback au key si path non trouvé
    }
  }
  
  return typeof current === 'string' ? current : key;
}

export function getTranslationArray(languageCode: string, key: string): string[] {
  const langData = translations[languageCode];
  if (!langData) {
    return [];
  }
  
  const keys = key.split('.');
  let current: any = langData;
  
  for (const k of keys) {
    if (current && typeof current === 'object' && k in current) {
      current = current[k];
    } else {
      return [];
    }
  }
  
  return Array.isArray(current) ? current : [];
}

export function getSupportedLanguages(): string[] {
  return Object.keys(translations);
}

export default translations;
