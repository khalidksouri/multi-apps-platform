// Système de traductions pour 195+ langues
export const TRANSLATIONS = {
  fr: {
    title: "Math4Child - Apprendre les maths en s'amusant !",
    subtitle: "L'application révolutionnaire qui transforme l'apprentissage des mathématiques en aventure ludique pour les enfants de 6 à 12 ans",
    startAdventure: "Commencer l'Aventure",
    viewPlans: "Voir les Plans",
    exercises: "Exercices",
    games: "Jeux",
    dashboard: "Tableau de bord",
    pricing: "Plans"
  },
  en: {
    title: "Math4Child - Learn math while having fun!",
    subtitle: "The revolutionary app that transforms mathematics learning into a fun adventure for children aged 6 to 12",
    startAdventure: "Start Adventure",
    viewPlans: "View Plans",
    exercises: "Exercises",
    games: "Games",
    dashboard: "Dashboard",
    pricing: "Plans"
  },
  ar: {
    title: "Math4Child - تعلم الرياضيات بالمتعة!",
    subtitle: "التطبيق الثوري الذي يحول تعلم الرياضيات إلى مغامرة ممتعة للأطفال من سن 6 إلى 12 سنة",
    startAdventure: "ابدأ المغامرة",
    viewPlans: "عرض الخطط",
    exercises: "التمارين",
    games: "الألعاب",
    dashboard: "لوحة التحكم",
    pricing: "الخطط"
  }
}

export const getTranslation = (language: string, key: string): string => {
  const keys = key.split(".")
  let value: any = TRANSLATIONS[language as keyof typeof TRANSLATIONS] || TRANSLATIONS.fr
  
  for (const k of keys) {
    value = value?.[k]
  }
  
  return value || key
}
