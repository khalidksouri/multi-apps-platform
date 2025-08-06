// Système de traductions Math4Child
export const TRANSLATIONS = {
  fr: {
    title: "Math4Child - Apprendre les maths en s amusant !",
    subtitle: "L application révolutionnaire qui transforme l apprentissage des mathématiques en aventure ludique",
    startAdventure: "Commencer l Aventure",
    viewPlans: "Voir les Plans",
    exercises: "Exercices",
    profile: "Profil",
    whyMath4Child: "Pourquoi Math4Child ?",
    adaptiveAI: "IA Adaptative",
    multiLanguage: "195+ Langues",
    features: "Fonctionnalités",
    pricing: "Plans",
    currentLanguage: "Français"
  },
  en: {
    title: "Math4Child - Learn math while having fun!",
    subtitle: "The revolutionary app that transforms mathematics learning into a fun adventure",
    startAdventure: "Start Adventure",
    viewPlans: "View Plans",
    exercises: "Exercises",
    profile: "Profile",
    whyMath4Child: "Why Math4Child?",
    adaptiveAI: "Adaptive AI",
    multiLanguage: "195+ Languages",
    features: "Features",
    pricing: "Plans",
    currentLanguage: "English"
  },
  ar: {
    title: "Math4Child - تعلم الرياضيات بالمتعة!",
    subtitle: "التطبيق الثوري الذي يحول تعلم الرياضيات إلى مغامرة ممتعة",
    startAdventure: "ابدأ المغامرة",
    viewPlans: "عرض الخطط",
    exercises: "التمارين",
    profile: "الملف الشخصي",
    whyMath4Child: "لماذا Math4Child؟",
    adaptiveAI: "ذكاء اصطناعي تكيفي",
    multiLanguage: "195+ لغة",
    features: "المميزات",
    pricing: "الخطط",
    currentLanguage: "العربية"
  },
  es: {
    title: "Math4Child - ¡Aprende matemáticas divirtiéndote!",
    subtitle: "La aplicación revolucionaria que transforma el aprendizaje de matemáticas",
    startAdventure: "Comenzar Aventura",
    viewPlans: "Ver Planes",
    exercises: "Ejercicios",
    profile: "Perfil",
    whyMath4Child: "¿Por qué Math4Child?",
    adaptiveAI: "IA Adaptativa",
    multiLanguage: "195+ Idiomas",
    features: "Características",
    pricing: "Planes",
    currentLanguage: "Español"
  },
  de: {
    title: "Math4Child - Mathe lernen mit Spaß!",
    subtitle: "Die revolutionäre App, die das Mathematiklernen in ein Abenteuer verwandelt",
    startAdventure: "Abenteuer beginnen",
    viewPlans: "Pläne ansehen",
    exercises: "Übungen",
    profile: "Profil",
    whyMath4Child: "Warum Math4Child?",
    adaptiveAI: "Adaptive KI",
    multiLanguage: "195+ Sprachen",
    features: "Funktionen",
    pricing: "Pläne",
    currentLanguage: "Deutsch"
  },
  zh: {
    title: "Math4Child - 快乐学数学！",
    subtitle: "将数学学习转变为有趣冒险的革命性应用",
    startAdventure: "开始冒险",
    viewPlans: "查看计划",
    exercises: "练习",
    profile: "个人资料",
    whyMath4Child: "为什么选择Math4Child？",
    adaptiveAI: "自适应AI",
    multiLanguage: "195+种语言",
    features: "功能",
    pricing: "计划",
    currentLanguage: "中文"
  },
  ja: {
    title: "Math4Child - 楽しく数学を学ぼう！",
    subtitle: "数学学習を楽しい冒険に変える革命的なアプリ",
    startAdventure: "冒険を始める",
    viewPlans: "プランを見る",
    exercises: "練習",
    profile: "プロフィール",
    whyMath4Child: "なぜMath4Child？",
    adaptiveAI: "適応AI",
    multiLanguage: "195+言語",
    features: "機能",
    pricing: "プラン",
    currentLanguage: "日本語"
  }
}

export const getTranslation = (language: string, key: string): string => {
  const translations = TRANSLATIONS[language as keyof typeof TRANSLATIONS] || TRANSLATIONS.fr
  return translations[key as keyof typeof translations] || key
}

export const getSupportedTranslationLanguages = () => Object.keys(TRANSLATIONS)
