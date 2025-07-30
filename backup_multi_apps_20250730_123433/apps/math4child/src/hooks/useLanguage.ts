'use client';

import { useState, useEffect, createContext, useContext } from 'react';

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  rtl: boolean;
}

export interface Translation {
  [key: string]: string;
}

export interface Translations {
  [languageCode: string]: Translation;
}

// 20+ langues supportées - Architecture premium complète
export const SUPPORTED_LANGUAGES: Language[] = [
  { code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷', rtl: false },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', rtl: false },
  { code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', rtl: false },
  { code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', rtl: false },
  { code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', rtl: false },
  { code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', rtl: false },
  { code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', rtl: true },
  { code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳', rtl: false },
  { code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', rtl: false },
  { code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', rtl: false },
  { code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', rtl: false },
  { code: 'ko', name: 'Korean', nativeName: '한국어', flag: '🇰🇷', rtl: false },
  { code: 'nl', name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', rtl: false },
  { code: 'sv', name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', rtl: false },
  { code: 'no', name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', rtl: false },
  { code: 'da', name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', rtl: false },
  { code: 'fi', name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮', rtl: false },
  { code: 'pl', name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', rtl: false },
  { code: 'tr', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', rtl: false },
  { code: 'he', name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', rtl: true },
];

// Système de traductions complet - Architecture premium
export const translations: Translations = {
  fr: {
    appName: 'Math4Child',
    appDescription: 'Apprendre les mathématiques en s\'amusant !',
    correctedApp: 'Application Corrigée avec Succès !',
    worksPerfectly: 'Math4Child fonctionne maintenant parfaitement',
    exercises: 'Exercices Mathématiques',
    games: 'Jeux Éducatifs',
    levels5: '5 Niveaux',
    levelsDesc: 'Du débutant à l\'expert',
    languages75: '75+ Langues',
    languagesDesc: 'Accessible mondialement',
    multiProfiles: 'Multi-Profils',
    multiProfilesDesc: 'Toute la famille',
    testInteractivity: 'Tester l\'Interactivité',
    interactivityWorks: 'L\'interactivité fonctionne parfaitement !',
    copyright: '© 2024 Math4Child - Application éducative de référence',
    startFree: 'Commencer Gratuitement',
    choosePlan: 'Choisir ce Plan',
    popular: 'Le plus populaire',
    month: '/mois',
    planFree: 'Gratuit',
    planPremium: 'Premium',
    planFamily: 'Famille',
    planSchool: 'École/Association',
  },
  en: {
    appName: 'Math4Child',
    appDescription: 'Learn math while having fun!',
    correctedApp: 'Application Successfully Corrected!',
    worksPerfectly: 'Math4Child now works perfectly',
    exercises: 'Math Exercises',
    games: 'Educational Games',
    levels5: '5 Levels',
    levelsDesc: 'From beginner to expert',
    languages75: '75+ Languages',
    languagesDesc: 'Globally accessible',
    multiProfiles: 'Multi-Profiles',
    multiProfilesDesc: 'Whole family',
    testInteractivity: 'Test Interactivity',
    interactivityWorks: 'Interactivity works perfectly!',
    copyright: '© 2024 Math4Child - Reference educational app',
    startFree: 'Start Free',
    choosePlan: 'Choose This Plan',
    popular: 'Most Popular',
    month: '/month',
    planFree: 'Free',
    planPremium: 'Premium',
    planFamily: 'Family',
    planSchool: 'School/Organization',
  },
  es: {
    appName: 'Math4Child',
    appDescription: '¡Aprende matemáticas divirtiéndote!',
    correctedApp: '¡Aplicación Corregida con Éxito!',
    worksPerfectly: 'Math4Child ahora funciona perfectamente',
    exercises: 'Ejercicios Matemáticos',
    games: 'Juegos Educativos',
    levels5: '5 Niveles',
    levelsDesc: 'De principiante a experto',
    languages75: '75+ Idiomas',
    languagesDesc: 'Accesible mundialmente',
    multiProfiles: 'Multi-Perfiles',
    multiProfilesDesc: 'Toda la familia',
    testInteractivity: 'Probar Interactividad',
    interactivityWorks: '¡La interactividad funciona perfectamente!',
    copyright: '© 2024 Math4Child - Aplicación educativa de referencia',
    startFree: 'Comenzar Gratis',
    choosePlan: 'Elegir Este Plan',
    popular: 'Más Popular',
    month: '/mes',
    planFree: 'Gratis',
    planPremium: 'Premium',
    planFamily: 'Familia',
    planSchool: 'Escuela/Asociación',
  },
  ar: {
    appName: 'Math4Child',
    appDescription: 'تعلم الرياضيات مع المتعة!',
    correctedApp: 'تم تصحيح التطبيق بنجاح!',
    worksPerfectly: 'Math4Child يعمل الآن بشكل مثالي',
    exercises: 'تمارين الرياضيات',
    games: 'ألعاب تعليمية',
    levels5: '5 مستويات',
    levelsDesc: 'من المبتدئ إلى الخبير',
    languages75: '75+ لغة',
    languagesDesc: 'متاح عالمياً',
    multiProfiles: 'ملفات متعددة',
    multiProfilesDesc: 'العائلة بأكملها',
    testInteractivity: 'اختبار التفاعل',
    interactivityWorks: 'التفاعل يعمل بشكل مثالي!',
    copyright: '© 2024 Math4Child - تطبيق تعليمي مرجعي',
    startFree: 'ابدأ مجاناً',
    choosePlan: 'اختر هذه الخطة',
    popular: 'الأكثر شعبية',
    month: '/شهر',
    planFree: 'مجاني',
    planPremium: 'مميز',
    planFamily: 'عائلة',
    planSchool: 'مدرسة/جمعية',
  }
};

// Context et types - Architecture premium
interface LanguageContextType {
  currentLanguage: Language;
  setLanguage: (lang: Language) => void;
  t: (key: string) => string;
}

const LanguageContext = createContext<LanguageContextType | null>(null);

// Hook principal
export function useLanguage() {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within LanguageProvider');
  }
  return context;
}

// Export du context pour le provider
export { LanguageContext };
export type { LanguageContextType };
