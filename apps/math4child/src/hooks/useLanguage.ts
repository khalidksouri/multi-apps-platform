"use client"

import { useState, useEffect } from "react"

export function useLanguage() {
  const [language, setLanguageState] = useState("fr")
  const [isRTL, setIsRTL] = useState(false)

  useEffect(() => {
    if (typeof window !== "undefined") {
      const savedLanguage = localStorage.getItem("math4child-language") || "fr"
      setLanguageState(savedLanguage)
      setIsRTL(isRTLLanguage(savedLanguage))
    }
  }, [])

  const isRTLLanguage = (lang: string): boolean => {
    const rtlLanguages = ['ar', 'fa', 'ur', 'ku', 'he']
    return rtlLanguages.includes(lang)
  }

  const setLanguage = (lang: string) => {
    setLanguageState(lang)
    setIsRTL(isRTLLanguage(lang))
    if (typeof window !== "undefined") {
      localStorage.setItem("math4child-language", lang)
    }
  }

  const t = (key: string): string => {
    const translations: { [key: string]: { [lang: string]: string } } = {
      title: {
        fr: "Math4Child - Apprendre les maths en s'amusant !",
        en: "Math4Child - Learn math while having fun!",
        ar: "Math4Child - تعلم الرياضيات والمرح!",
        es: "Math4Child - ¡Aprende matemáticas divirtiéndote!",
        de: "Math4Child - Mathe lernen macht Spaß!",
        it: "Math4Child - Impara la matematica divertendoti!",
        pt: "Math4Child - Aprenda matemática se divertindo!",
        ru: "Math4Child - Изучай математику с удовольствием!",
        zh: "Math4Child - 快乐学数学！",
        ja: "Math4Child - 楽しく数学を学ぼう！"
      },
      subtitle: {
        fr: "L'application éducative révolutionnaire pour apprendre les mathématiques",
        en: "The revolutionary educational app for learning mathematics",
        ar: "التطبيق التعليمي الثوري لتعلم الرياضيات",
        es: "La aplicación educativa revolucionaria para aprender matemáticas",
        de: "Die revolutionäre Bildungsapp zum Mathematiklernen",
        it: "L'app educativa rivoluzionaria per imparare la matematica",
        pt: "O aplicativo educacional revolucionário para aprender matemática",
        ru: "Революционное образовательное приложение для изучения математики",
        zh: "学习数学的革命性教育应用",
        ja: "数学を学ぶための革新的な教育アプリ"
      },
      startAdventure: {
        fr: "Commencer l'Aventure",
        en: "Start Adventure",
        ar: "ابدأ المغامرة",
        es: "Comenzar Aventura",
        de: "Abenteuer Starten",
        it: "Inizia Avventura",
        pt: "Começar Aventura",
        ru: "Начать Приключение",
        zh: "开始冒险",
        ja: "冒険を始める"
      },
      viewPlans: {
        fr: "Voir les Plans",
        en: "View Plans",
        ar: "عرض الخطط",
        es: "Ver Planes",
        de: "Pläne Anzeigen",
        it: "Vedi Piani",
        pt: "Ver Planos",
        ru: "Посмотреть Планы",
        zh: "查看计划",
        ja: "プランを見る"
      },
      exercises: {
        fr: "Exercices",
        en: "Exercises",
        ar: "التمارين",
        es: "Ejercicios",
        de: "Übungen",
        it: "Esercizi",
        pt: "Exercícios",
        ru: "Упражнения",
        zh: "练习",
        ja: "練習"
      },
      profile: {
        fr: "Profil",
        en: "Profile",
        ar: "الملف الشخصي",
        es: "Perfil",
        de: "Profil",
        it: "Profilo",
        pt: "Perfil",
        ru: "Профиль",
        zh: "个人资料",
        ja: "プロフィール"
      },
      pricing: {
        fr: "Plans",
        en: "Plans",
        ar: "الخطط",
        es: "Planes",
        de: "Pläne",
        it: "Piani",
        pt: "Planos",
        ru: "Планы",
        zh: "计划",
        ja: "プラン"
      },
      whyMath4Child: {
        fr: "Pourquoi Math4Child ?",
        en: "Why Math4Child?",
        ar: "لماذا Math4Child؟",
        es: "¿Por qué Math4Child?",
        de: "Warum Math4Child?",
        it: "Perché Math4Child?",
        pt: "Por que Math4Child?",
        ru: "Почему Math4Child?",
        zh: "为什么选择 Math4Child？",
        ja: "なぜMath4Child？"
      },
      adaptiveAI: {
        fr: "IA Adaptative",
        en: "Adaptive AI",
        ar: "الذكاء الاصطناعي التكيفي",
        es: "IA Adaptativa",
        de: "Adaptive KI",
        it: "IA Adattiva",
        pt: "IA Adaptativa",
        ru: "Адаптивный ИИ",
        zh: "自适应人工智能",
        ja: "適応型AI"
      },
      multiLanguage: {
        fr: "Langues",
        en: "Languages",
        ar: "اللغات",
        es: "Idiomas",
        de: "Sprachen",
        it: "Lingue",
        pt: "Idiomas",
        ru: "Языки",
        zh: "语言",
        ja: "言語"
      }
    }
    
    return translations[key]?.[language] || translations[key]?.["fr"] || key
  }

  const currentLanguageInfo = {
    code: language,
    flag: getLanguageFlag(language),
    nativeName: getLanguageNativeName(language)
  }

  const getLanguageFlag = (lang: string): string => {
    const flags: { [key: string]: string } = {
      fr: '🇫🇷', en: '🇺🇸', ar: '🇲🇦', es: '🇪🇸', de: '🇩🇪',
      it: '🇮🇹', pt: '🇵🇹', ru: '🇷🇺', zh: '🇨🇳', ja: '🇯🇵',
      ko: '🇰🇷', hi: '🇮🇳', th: '🇹🇭', vi: '🇻🇳', nl: '🇳🇱',
      sv: '🇸🇪', da: '🇩🇰', no: '🇳🇴', fi: '🇫🇮', pl: '🇵🇱'
    }
    return flags[lang] || '🌍'
  }

  const getLanguageNativeName = (lang: string): string => {
    const names: { [key: string]: string } = {
      fr: 'Français', en: 'English', ar: 'العربية', es: 'Español', de: 'Deutsch',
      it: 'Italiano', pt: 'Português', ru: 'Русский', zh: '中文', ja: '日本語',
      ko: '한국어', hi: 'हिन्दी', th: 'ไทย', vi: 'Tiếng Việt', nl: 'Nederlands',
      sv: 'Svenska', da: 'Dansk', no: 'Norsk', fi: 'Suomi', pl: 'Polski'
    }
    return names[lang] || lang.toUpperCase()
  }

  return {
    language,
    setLanguage,
    t,
    isRTL,
    totalLanguages: 195,
    currentLanguageInfo
  }
}
