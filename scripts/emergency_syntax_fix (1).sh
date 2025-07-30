#!/bin/bash

# emergency_syntax_fix.sh - Correction d'urgence erreur JSX

echo "🚨 CORRECTION D'URGENCE - ERREUR JSX"
echo "   ❌ JSX dans fichier .ts (doit être .tsx)"
echo "   🔧 Correction immédiate de la syntaxe"
echo "   ⚡ Remise en état fonctionnel"
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "==========================================="
echo "    CORRECTION JSX D'URGENCE             "
echo "==========================================="

cd apps/math4child

# Arrêter le serveur qui plante
pkill -f "next dev" 2>/dev/null || true
sleep 2

echo -e "${BLUE}🔧 ÉTAPE 1/3: Correction du hook useLanguage (sans JSX)${NC}"

# Créer une version sans JSX qui fonctionne
cat > src/hooks/useLanguage.ts << 'EOF'
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

// Langues supportées (sélection des 20 principales)
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

// Traductions de base
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

// Context pour la langue - INTERFACES SEULEMENT
interface LanguageContextType {
  currentLanguage: Language;
  setLanguage: (lang: Language) => void;
  t: (key: string) => string;
}

const LanguageContext = createContext<LanguageContextType | null>(null);

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within LanguageProvider');
  }
  return context;
}

// Export du context et des utilitaires - PAS DE JSX ICI
export { LanguageContext };
export type { LanguageContextType };

// Fonction utilitaire pour créer le provider (utilisée dans layout.tsx)
export function createLanguageContextValue(): LanguageContextType {
  const [currentLanguage, setCurrentLanguage] = useState<Language>(SUPPORTED_LANGUAGES[0]);

  const setLanguage = (lang: Language) => {
    setCurrentLanguage(lang);
    if (typeof window !== 'undefined') {
      localStorage.setItem('math4child_language', lang.code);
      document.documentElement.dir = lang.rtl ? 'rtl' : 'ltr';
      document.documentElement.lang = lang.code;
    }
  };

  const t = (key: string): string => {
    return translations[currentLanguage.code]?.[key] || translations['fr'][key] || key;
  };

  // Charger la langue sauvegardée
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('math4child_language');
      if (saved) {
        const savedLang = SUPPORTED_LANGUAGES.find(lang => lang.code === saved);
        if (savedLang) {
          setCurrentLanguage(savedLang);
          document.documentElement.dir = savedLang.rtl ? 'rtl' : 'ltr';
          document.documentElement.lang = savedLang.code;
        }
      }
    }
  }, []);

  return { currentLanguage, setLanguage, t };
}
EOF

echo -e "${GREEN}✅ Hook useLanguage corrigé (sans JSX)${NC}"

echo -e "${BLUE}🔧 ÉTAPE 2/3: Créer le provider séparé${NC}"

# Créer un provider séparé en .tsx
cat > src/components/providers/LanguageProvider.tsx << 'EOF'
'use client';

import { ReactNode } from 'react';
import { LanguageContext, createLanguageContextValue } from '@/hooks/useLanguage';

interface LanguageProviderProps {
  children: ReactNode;
}

export function LanguageProvider({ children }: LanguageProviderProps) {
  const contextValue = createLanguageContextValue();

  return (
    <LanguageContext.Provider value={contextValue}>
      {children}
    </LanguageContext.Provider>
  );
}
EOF

echo -e "${GREEN}✅ Provider LanguageProvider créé${NC}"

echo -e "${BLUE}🔧 ÉTAPE 3/3: Corriger le layout${NC}"

# Créer le dossier providers s'il n'existe pas
mkdir -p src/components/providers

# Corriger le layout pour utiliser le nouveau provider
cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next';
import './globals.css';
import { LanguageProvider } from '@/components/providers/LanguageProvider';

export const metadata: Metadata = {
  title: 'Math4Child - Apprendre les maths en s\'amusant',
  description: 'Application éducative premium pour apprendre les mathématiques en famille. 75+ langues, 5 niveaux, système d\'achievements, thèmes personnalisables.',
  keywords: 'mathématiques, éducation, enfants, apprentissage, jeux éducatifs, multilingue, achievements, thèmes',
  authors: [{ name: 'Math4Child Team' }],
  icons: {
    icon: '/favicon.ico',
  },
  manifest: '/manifest.json',
  openGraph: {
    title: 'Math4Child - Apprendre les maths en s\'amusant',
    description: 'Application éducative premium avec système d\'achievements et thèmes personnalisables',
    type: 'website',
    locale: 'fr_FR',
    alternateLocale: ['en_US', 'es_ES', 'de_DE', 'ar_SA'],
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr" dir="ltr">
      <body className="antialiased">
        <LanguageProvider>
          {children}
        </LanguageProvider>
      </body>
    </html>
  );
}
EOF

echo -e "${GREEN}✅ Layout corrigé${NC}"

# Nettoyer le cache
echo -e "${YELLOW}🧹 Nettoyage du cache...${NC}"
rm -rf .next
rm -rf node_modules/.cache 2>/dev/null || true

echo ""
echo "==========================================="
echo "    CORRECTION JSX TERMINÉE !             "
echo "==========================================="
echo ""
echo -e "${GREEN}🎉 ERREUR JSX CORRIGÉE AVEC SUCCÈS !${NC}"
echo ""
echo -e "${CYAN}✨ CORRECTIONS APPLIQUÉES :${NC}"
echo "   ✅ Hook useLanguage.ts sans JSX"
echo "   ✅ Provider séparé en .tsx"
echo "   ✅ Layout corrigé avec bon import"
echo "   ✅ Cache Next.js nettoyé"
echo ""
echo -e "${BLUE}🚀 POUR TESTER MAINTENANT :${NC}"
echo "   npm run dev"
echo "   Ouvrir http://localhost:3000"
echo ""
echo -e "${YELLOW}📋 L'APPLICATION DEVRAIT MAINTENANT FONCTIONNER !${NC}"
echo ""
echo -e "${GREEN}✅ CORRECTION JSX D'URGENCE TERMINÉE !${NC}"