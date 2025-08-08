export function getTranslation(language: string, key: string): string {
  const translations: Record<string, Record<string, string>> = {
    fr: {
      appTitle: '⭐ App éducative #1 en France ⭐',
      heroTitle: "Apprends les maths en t'amusant !",
      heroSubtitle: "L'application éducative révolutionnaire"
    },
    en: {
      appTitle: '⭐ #1 Educational App in France ⭐',
      heroTitle: "Learn math while having fun!",
      heroSubtitle: "The revolutionary educational app"
    }
  }
  
  return translations[language]?.[key] || translations['fr']?.[key] || key
}
