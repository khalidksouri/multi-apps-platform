"use client"

import { createContext, useContext, useState, ReactNode, useEffect } from 'react'

type Language = 'fr' | 'en' | 'es' | 'de' | 'it' | 'pt' | 'ru' | 'zh' | 'ja' | 'ko' | 'ar' | 'hi' | 'th' | 'vi' | 'id'

interface LanguageContextType {
  currentLanguage: Language
  setLanguage: (lang: Language) => void
  t: (key: string) => string
  isRTL: boolean
  supportedLanguages: Array<{code: Language, name: string, nativeName: string, flag: string, region: string}>
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

// Base de langues universelles (échantillon des 200+)
const SUPPORTED_LANGUAGES = [
  // Europe
  { code: 'fr' as Language, name: 'French', nativeName: 'Français', flag: '🇫🇷', region: 'Europe' },
  { code: 'en' as Language, name: 'English', nativeName: 'English', flag: '🇺🇸', region: 'Global' },
  { code: 'es' as Language, name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', region: 'Europe' },
  { code: 'de' as Language, name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', region: 'Europe' },
  { code: 'it' as Language, name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', region: 'Europe' },
  { code: 'pt' as Language, name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', region: 'Europe' },
  { code: 'ru' as Language, name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', region: 'Europe' },
  
  // Asie
  { code: 'zh' as Language, name: 'Chinese', nativeName: '中文', flag: '🇨🇳', region: 'Asia' },
  { code: 'ja' as Language, name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', region: 'Asia' },
  { code: 'ko' as Language, name: 'Korean', nativeName: '한국어', flag: '🇰��', region: 'Asia' },
  { code: 'hi' as Language, name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', region: 'Asia' },
  { code: 'th' as Language, name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', region: 'Asia' },
  { code: 'vi' as Language, name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', region: 'Asia' },
  { code: 'id' as Language, name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', region: 'Asia' },
  
  // MENA (RTL)
  { code: 'ar' as Language, name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', region: 'MENA' }
]

const RTL_LANGUAGES: Language[] = ['ar']

const translations = {
  fr: {
    welcome: 'Bienvenue dans Math4Child v4.2.0',
    exercises: 'Exercices Révolutionnaires',
    profile: 'Profil',
    pricing: 'Tarifs',
    home: 'Accueil',
    revolutionaryEducation: 'Révolution Éducative Mondiale',
    discoverInnovations: 'Découvrir les Innovations'
  },
  en: {
    welcome: 'Welcome to Math4Child v4.2.0',
    exercises: 'Revolutionary Exercises',
    profile: 'Profile',
    pricing: 'Pricing',
    home: 'Home',
    revolutionaryEducation: 'Global Educational Revolution',
    discoverInnovations: 'Discover Innovations'
  },
  es: {
    welcome: 'Bienvenido a Math4Child v4.2.0',
    exercises: 'Ejercicios Revolucionarios',
    profile: 'Perfil',
    pricing: 'Precios',
    home: 'Inicio',
    revolutionaryEducation: 'Revolución Educativa Mundial',
    discoverInnovations: 'Descubrir Innovaciones'
  },
  de: {
    welcome: 'Willkommen bei Math4Child v4.2.0',
    exercises: 'Revolutionäre Übungen',
    profile: 'Profil',
    pricing: 'Preise',
    home: 'Startseite',
    revolutionaryEducation: 'Globale Bildungsrevolution',
    discoverInnovations: 'Innovationen Entdecken'
  },
  it: {
    welcome: 'Benvenuto in Math4Child v4.2.0',
    exercises: 'Esercizi Rivoluzionari',
    profile: 'Profilo',
    pricing: 'Prezzi',
    home: 'Home',
    revolutionaryEducation: 'Rivoluzione Educativa Mondiale',
    discoverInnovations: 'Scopri le Innovazioni'
  },
  pt: {
    welcome: 'Bem-vindo ao Math4Child v4.2.0',
    exercises: 'Exercícios Revolucionários',
    profile: 'Perfil',
    pricing: 'Preços',
    home: 'Início',
    revolutionaryEducation: 'Revolução Educativa Mundial',
    discoverInnovations: 'Descobrir Inovações'
  },
  ru: {
    welcome: 'Добро пожаловать в Math4Child v4.2.0',
    exercises: 'Революционные упражнения',
    profile: 'Профиль',
    pricing: 'Цены',
    home: 'Главная',
    revolutionaryEducation: 'Мировая образовательная революция',
    discoverInnovations: 'Открыть инновации'
  },
  zh: {
    welcome: '欢迎来到Math4Child v4.2.0',
    exercises: '革命性练习',
    profile: '个人资料',
    pricing: '价格',
    home: '首页',
    revolutionaryEducation: '全球教育革命',
    discoverInnovations: '发现创新'
  },
  ja: {
    welcome: 'Math4Child v4.2.0へようこそ',
    exercises: '革命的な演習',
    profile: 'プロフィール',
    pricing: '価格',
    home: 'ホーム',
    revolutionaryEducation: 'グローバル教育革命',
    discoverInnovations: 'イノベーションを発見'
  },
  ko: {
    welcome: 'Math4Child v4.2.0에 오신 것을 환영합니다',
    exercises: '혁명적인 연습',
    profile: '프로필',
    pricing: '가격',
    home: '홈',
    revolutionaryEducation: '글로벌 교육 혁명',
    discoverInnovations: '혁신 발견'
  },
  ar: {
    welcome: 'مرحباً بك في Math4Child v4.2.0',
    exercises: 'تمارين ثورية',
    profile: 'الملف الشخصي',
    pricing: 'الأسعار',
    home: 'الصفحة الرئيسية',
    revolutionaryEducation: 'ثورة تعليمية عالمية',
    discoverInnovations: 'اكتشف الابتكارات'
  },
  hi: {
    welcome: 'Math4Child v4.2.0 में आपका स्वागत है',
    exercises: 'क्रांतिकारी अभ्यास',
    profile: 'प्रोफ़ाइल',
    pricing: 'मूल्य निर्धारण',
    home: 'होम',
    revolutionaryEducation: 'वैश्विक शैक्षिक क्रांति',
    discoverInnovations: 'नवाचार खोजें'
  },
  th: {
    welcome: 'ยินดีต้อนรับสู่ Math4Child v4.2.0',
    exercises: 'แบบฝึกหัดปฏิวัติ',
    profile: 'โปรไฟล์',
    pricing: 'ราคา',
    home: 'หน้าแรก',
    revolutionaryEducation: 'การปฏิวัติการศึกษาระดับโลก',
    discoverInnovations: 'ค้นพบนวัตกรรม'
  },
  vi: {
    welcome: 'Chào mừng đến với Math4Child v4.2.0',
    exercises: 'Bài tập Cách mạng',
    profile: 'Hồ sơ',
    pricing: 'Giá cả',
    home: 'Trang chủ',
    revolutionaryEducation: 'Cuộc cách mạng Giáo dục Toàn cầu',
    discoverInnovations: 'Khám phá Đổi mới'
  },
  id: {
    welcome: 'Selamat datang di Math4Child v4.2.0',
    exercises: 'Latihan Revolusioner',
    profile: 'Profil',
    pricing: 'Harga',
    home: 'Beranda',
    revolutionaryEducation: 'Revolusi Pendidikan Global',
    discoverInnovations: 'Temukan Inovasi'
  }
}

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState<Language>('fr')

  useEffect(() => {
    if (typeof window !== 'undefined') {
      const savedLanguage = localStorage.getItem('math4child_language') as Language
      if (savedLanguage && SUPPORTED_LANGUAGES.find(l => l.code === savedLanguage)) {
        setCurrentLanguage(savedLanguage)
        updateHTMLAttributes(savedLanguage)
      }
    }
  }, [])

  const setLanguage = (lang: Language) => {
    setCurrentLanguage(lang)
    updateHTMLAttributes(lang)
    
    if (typeof window !== 'undefined') {
      localStorage.setItem('math4child_language', lang)
    }
  }

  const updateHTMLAttributes = (lang: Language) => {
    if (typeof document !== 'undefined') {
      document.documentElement.lang = lang
      document.documentElement.dir = RTL_LANGUAGES.includes(lang) ? 'rtl' : 'ltr'
    }
  }

  const t = (key: string): string => {
    const languageTranslations = translations[currentLanguage] as Record<string, string>
    return languageTranslations?.[key] || key
  }

  const value: LanguageContextType = {
    currentLanguage,
    setLanguage,
    t,
    isRTL: RTL_LANGUAGES.includes(currentLanguage),
    supportedLanguages: SUPPORTED_LANGUAGES
  }

  return (
    <LanguageContext.Provider value={value}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider')
  }
  return context
}
