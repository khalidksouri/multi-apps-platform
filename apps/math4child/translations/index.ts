export interface Translation {
  [key: string]: string | Translation
}

export interface Translations {
  [languageCode: string]: Translation
}

export const translations: Translations = {
  fr: {
    home: {
      title: 'Math4Child',
      subtitle: "L'app éducative n°1 pour apprendre les maths en famille !",
      startFree: 'Commencer gratuitement',
      comparePrices: 'Comparer les prix'
    },
    language: {
      select: 'Sélectionner une langue',
      search: 'Tapez pour rechercher...',
      directTyping: 'Tapez directement dans la liste',
      available: 'disponibles'
    }
  },
  en: {
    home: {
      title: 'Math4Child',
      subtitle: 'The #1 educational app for learning math as a family!',
      startFree: 'Start Free',
      comparePrices: 'Compare Prices'
    },
    language: {
      select: 'Select a language',
      search: 'Type to search...',
      directTyping: 'Type directly in the list',
      available: 'available'
    }
  },
  es: {
    home: {
      title: 'Math4Child',
      subtitle: '¡La app educativa n°1 para aprender matemáticas en familia!',
      startFree: 'Comenzar gratis',
      comparePrices: 'Comparar precios'
    },
    language: {
      select: 'Seleccionar idioma',
      search: 'Escribe para buscar...',
      directTyping: 'Escribe directamente en la lista',
      available: 'disponibles'
    }
  },
  de: {
    home: {
      title: 'Math4Child',
      subtitle: 'Die #1 Lern-App für Mathematik in der Familie!',
      startFree: 'Kostenlos starten',
      comparePrices: 'Preise vergleichen'
    },
    language: {
      select: 'Sprache auswählen',
      search: 'Tippen zum Suchen...',
      directTyping: 'Direkt in die Liste tippen',
      available: 'verfügbar'
    }
  }
}

export function getTranslation(
  translations: Translations,
  language: string,
  key: string,
  fallbackLanguage = 'en'
): string {
  const keys = key.split('.')
  let current: unknown = translations[language]
  
  for (const k of keys) {
    current = current?.[k]
  }
  
  if (typeof current === 'string') {
    return current
  }
  
  current = translations[fallbackLanguage]
  for (const k of keys) {
    current = current?.[k]
  }
  
  return typeof current === 'string' ? current : key
}

export function useTranslation(language: string) {
  const t = (key: string) => getTranslation(translations, language, key)
  return { t, language }
}
