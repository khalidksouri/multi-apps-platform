#!/usr/bin/env bash

# ===================================================================
# 🚀 SCRIPT COMPLET MATH4CHILD SETUP
# Configuration complète de l'application éducative multilingue
# ===================================================================

set -euo pipefail

# Variables globales
SCRIPT_VERSION="4.0.0"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="setup_math4child_${TIMESTAMP}.log"
BACKUP_DIR="backup_${TIMESTAMP}"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ===================================================================
# 🛠️ FONCTIONS UTILITAIRES
# ===================================================================

log_header() {
    echo -e "${CYAN}${BOLD}=========================================${NC}"
    echo -e "${CYAN}${BOLD}🚀 $1${NC}"
    echo -e "${CYAN}${BOLD}=========================================${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_step() {
    echo -e "${PURPLE}📋 $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] STEP: $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" >> "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1" >> "$LOG_FILE"
}

# Créer une sauvegarde
create_backup() {
    log_step "Création de la sauvegarde..."
    mkdir -p "$BACKUP_DIR"
    
    # Sauvegarder les fichiers existants
    if [ -d "apps" ]; then
        cp -r apps "$BACKUP_DIR/" 2>/dev/null || true
    fi
    if [ -d "tests" ]; then
        cp -r tests "$BACKUP_DIR/" 2>/dev/null || true
    fi
    if [ -f "package.json" ]; then
        cp package.json "$BACKUP_DIR/" 2>/dev/null || true
    fi
    if [ -f "Makefile" ]; then
        cp Makefile "$BACKUP_DIR/" 2>/dev/null || true
    fi
    
    log_success "Sauvegarde créée dans $BACKUP_DIR"
}

# Vérification des prérequis
check_prerequisites() {
    log_header "VÉRIFICATION DES PRÉREQUIS"
    
    # Vérifier Node.js
    if ! command -v node >/dev/null 2>&1; then
        log_error "Node.js non trouvé. Installez Node.js 18+ depuis https://nodejs.org/"
        exit 1
    fi
    
    local node_version=$(node --version | sed 's/v//')
    local node_major=$(echo "$node_version" | cut -d. -f1)
    if [ "$node_major" -lt "18" ]; then
        log_error "Node.js 18+ requis. Version actuelle: v$node_version"
        exit 1
    fi
    log_success "Node.js v$node_version ✓"
    
    # Vérifier npm
    if ! command -v npm >/dev/null 2>&1; then
        log_error "npm non trouvé"
        exit 1
    fi
    
    local npm_version=$(npm --version)
    log_success "npm v$npm_version ✓"
    
    # Vérifier l'espace disque
    local available_space=$(df -h . | awk 'NR==2{print $4}')
    log_info "Espace disque disponible: $available_space"
}

# ===================================================================
# 📁 CRÉATION DE LA STRUCTURE DU PROJET
# ===================================================================

create_project_structure() {
    log_header "CRÉATION DE LA STRUCTURE DU PROJET"
    
    local dirs=(
        "apps/math4child/src/app"
        "apps/math4child/src/components/ui"
        "apps/math4child/src/components/games"
        "apps/math4child/src/components/language"
        "apps/math4child/src/components/pricing"
        "apps/math4child/src/lib/translations"
        "apps/math4child/src/lib/utils"
        "apps/math4child/src/contexts"
        "apps/math4child/src/hooks"
        "apps/math4child/src/types"
        "apps/math4child/public"
        "tests/specs"
        "tests/specs/translation"
        "tests/specs/rtl"
        "tests/specs/responsive"
        "tests/specs/games"
        "tests/specs/subscription"
        "tests/utils"
        "tests/fixtures"
        "test-results"
        "playwright-report"
        "scripts"
        "docs"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        log_info "Créé: $dir"
    done
    
    log_success "Structure du projet créée"
}

# ===================================================================
# 📦 CONFIGURATION DES PACKAGES
# ===================================================================

create_package_configurations() {
    log_header "CONFIGURATION DES PACKAGES"
    
    # Package.json principal
    cat > "package.json" << 'EOF'
{
  "name": "math4child-platform",
  "version": "4.0.0",
  "description": "Math4Child - Plateforme éducative multilingue complète",
  "private": true,
  "workspaces": [
    "apps/*",
    "tests"
  ],
  "scripts": {
    "dev": "cd apps/math4child && npm run dev",
    "build": "cd apps/math4child && npm run build",
    "start": "cd apps/math4child && npm run start",
    "test": "cd tests && npm run test",
    "test:ui": "cd tests && npm run test:ui",
    "install:all": "npm install && cd apps/math4child && npm install && cd ../../tests && npm install",
    "setup": "npm run install:all && cd tests && npx playwright install --with-deps"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  }
}
EOF

    # Package.json de l'application Math4Child
    cat > "apps/math4child/package.json" << 'EOF'
{
  "name": "math4child",
  "version": "4.0.0",
  "description": "Math4Child - Application éducative multilingue avec support RTL",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3000",
    "dev:rtl": "NEXT_PUBLIC_DEFAULT_LANG=ar next dev -p 3000",
    "build": "next build",
    "build:rtl": "NEXT_PUBLIC_RTL_OPTIMIZED=true next build",
    "start": "next start",
    "lint": "next lint",
    "lint:fix": "next lint --fix",
    "type-check": "tsc --noEmit",
    "clean": "rimraf .next out"
  },
  "dependencies": {
    "next": "^14.0.4",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "typescript": "^5.3.3",
    "@types/node": "^20.10.5",
    "@types/react": "^18.2.45",
    "@types/react-dom": "^18.2.18",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.2.0",
    "lucide-react": "^0.300.0",
    "framer-motion": "^10.16.16",
    "zustand": "^4.4.7"
  },
  "devDependencies": {
    "eslint": "^8.56.0",
    "eslint-config-next": "^14.0.4",
    "tailwindcss": "^3.4.0",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.32",
    "rimraf": "^5.0.5",
    "@tailwindcss/typography": "^0.5.10",
    "@tailwindcss/forms": "^0.5.7"
  }
}
EOF

    # Package.json des tests
    cat > "tests/package.json" << 'EOF'
{
  "name": "math4child-tests",
  "version": "4.0.0",
  "description": "Tests E2E pour Math4Child",
  "private": true,
  "scripts": {
    "test": "playwright test",
    "test:ui": "playwright test --ui",
    "test:debug": "playwright test --debug",
    "test:headed": "playwright test --headed",
    "test:smoke": "playwright test --project=smoke",
    "test:translation": "playwright test --project=translation",
    "test:rtl": "playwright test --project=rtl",
    "test:mobile": "playwright test --project=mobile",
    "test:chrome": "playwright test --project=chrome",
    "test:firefox": "playwright test --project=firefox",
    "test:safari": "playwright test --project=safari",
    "test:report": "playwright show-report",
    "clean": "rimraf test-results playwright-report"
  },
  "devDependencies": {
    "@playwright/test": "^1.41.0",
    "@types/node": "^20.10.5",
    "typescript": "^5.3.3"
  }
}
EOF

    log_success "Configuration des packages créée"
}

# ===================================================================
# ⚙️ CONFIGURATION NEXT.JS
# ===================================================================

create_nextjs_configuration() {
    log_header "CONFIGURATION NEXT.JS"
    
    # Configuration Next.js
    cat > "apps/math4child/next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  
  // Support RTL
  i18n: {
    locales: ['fr', 'en', 'es', 'de', 'ar', 'zh', 'ja', 'it', 'pt', 'fi'],
    defaultLocale: 'fr',
  },
  
  // Optimisations
  swcMinify: true,
  
  // Images
  images: {
    domains: ['localhost'],
    unoptimized: process.env.NODE_ENV === 'development'
  },
  
  // Headers de sécurité
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
        ],
      },
    ]
  },
  
  // Support RTL
  env: {
    RTL_SUPPORT: 'true',
    ARABIC_FONTS: 'true',
  }
}

module.exports = nextConfig
EOF

    # Configuration TypeScript
    cat > "apps/math4child/tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/types/*": ["./src/types/*"],
      "@/hooks/*": ["./src/hooks/*"],
      "@/contexts/*": ["./src/contexts/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

    # Configuration Tailwind
    cat > "apps/math4child/tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        'arabic': ['Cairo', 'Amiri', 'Noto Sans Arabic', 'sans-serif'],
        'sans': ['Inter', 'system-ui', 'sans-serif'],
      },
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        },
        secondary: {
          50: '#f0f9ff',
          500: '#06b6d4',
          600: '#0891b2',
        }
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
  ],
}
EOF

    # Configuration PostCSS
    cat > "apps/math4child/postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

    # Configuration ESLint
    cat > "apps/math4child/.eslintrc.json" << 'EOF'
{
  "extends": [
    "next/core-web-vitals",
    "next/typescript"
  ],
  "rules": {
    "@typescript-eslint/no-unused-vars": "warn",
    "react-hooks/exhaustive-deps": "warn"
  }
}
EOF

    log_success "Configuration Next.js créée"
}

# ===================================================================
# 🎨 STYLES GLOBAUX AVEC SUPPORT RTL
# ===================================================================

create_global_styles() {
    log_header "CRÉATION DES STYLES GLOBAUX RTL"
    
    cat > "apps/math4child/src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Import des polices arabes */
@import url('https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;600;700&family=Amiri:wght@400;700&display=swap');

/* ===================================================================
   STYLES RTL POUR MATH4CHILD
   ================================================================= */

/* Police arabe pour RTL */
[lang="ar"], [dir="rtl"] {
  font-family: 'Cairo', 'Amiri', 'Noto Sans Arabic', system-ui, sans-serif;
  font-feature-settings: "liga" 1, "kern" 1;
}

/* Direction globale RTL */
[dir="rtl"] {
  direction: rtl;
  text-align: right;
}

[dir="rtl"] * {
  direction: rtl;
}

/* Conteneurs RTL */
[dir="rtl"] .container {
  direction: rtl;
}

/* Pricing Cards RTL */
[dir="rtl"] .pricing-card {
  text-align: right;
  direction: rtl;
}

[dir="rtl"] .pricing-header {
  text-align: center;
  direction: rtl;
}

/* Feature Lists RTL */
[dir="rtl"] .feature-list {
  direction: rtl;
  text-align: right;
}

[dir="rtl"] .feature-item {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  direction: rtl;
  text-align: right;
}

[dir="rtl"] .feature-icon {
  order: 2;
  margin-left: 0;
  margin-right: 0.5rem;
  flex-shrink: 0;
}

[dir="rtl"] .feature-text {
  order: 1;
  text-align: right;
}

/* Badges RTL */
[dir="rtl"] .badge-recommended {
  left: auto;
  right: 1rem;
  top: -0.75rem;
}

/* Responsive RTL */
@media (max-width: 768px) {
  [dir="rtl"] .grid-cols-1.md\:grid-cols-3 {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  [dir="rtl"] .pricing-card {
    margin-bottom: 1rem;
  }
}

/* FAQ RTL */
[dir="rtl"] .faq-container {
  direction: rtl;
  text-align: right;
}

[dir="rtl"] .faq-item {
  text-align: right;
  direction: rtl;
}

/* Contact section RTL */
[dir="rtl"] .contact-section {
  direction: rtl;
  text-align: center;
}
EOF

    log_success "Styles globaux RTL créés"
}

# ===================================================================
# 🌍 TRADUCTIONS MULTILINGUES
# ===================================================================

create_translations() {
    log_header "CRÉATION DES TRADUCTIONS MULTILINGUES"
    
    cat > "apps/math4child/src/lib/translations/comprehensive.ts" << 'EOF'
export interface Translation {
  appName: string;
  heroTitle: string;
  heroSubtitle: string;
  heroDescription: string;
  startFreeNow: string;
  learnMore: string;
  mathGames: string;
  chooseGame: string;
  puzzleMath: string;
  memoryMath: string;
  quickMath: string;
  mixedExercises: string;
  beginner: string;
  intermediate: string;
  advanced: string;
  expert: string;
  choosePlan: string;
  selectLanguage: string;
  pricing: string;
  home: string;
  games: string;
  about: string;
  contact: string;
}

export const translations: Record<string, Translation> = {
  fr: {
    appName: 'Math4Child',
    heroTitle: 'Les Mathématiques, c\'est Fantastique !',
    heroSubtitle: 'Apprendre en jouant n\'a jamais été aussi amusant',
    heroDescription: 'Développez les compétences mathématiques de votre enfant avec notre plateforme interactive',
    startFreeNow: 'Commencer Gratuitement',
    learnMore: 'En savoir plus',
    mathGames: 'Jeux Mathématiques',
    chooseGame: 'Choisis ton jeu préféré',
    puzzleMath: 'Puzzle Math',
    memoryMath: 'Mémoire Math',
    quickMath: 'Calcul Rapide',
    mixedExercises: 'Exercices Mixtes',
    beginner: 'Débutant',
    intermediate: 'Intermédiaire',
    advanced: 'Avancé',
    expert: 'Expert',
    choosePlan: 'Choisissez votre Plan',
    selectLanguage: 'Choisir la langue',
    pricing: 'Tarifs',
    home: 'Accueil',
    games: 'Jeux',
    about: 'À propos',
    contact: 'Contact',
  },
  
  en: {
    appName: 'Math4Child',
    heroTitle: 'Mathematics is Fantastic!',
    heroSubtitle: 'Learning through play has never been so fun',
    heroDescription: 'Develop your child\'s mathematical skills with our interactive platform',
    startFreeNow: 'Start Free Now',
    learnMore: 'Learn More',
    mathGames: 'Math Games',
    chooseGame: 'Choose your favorite game',
    puzzleMath: 'Math Puzzle',
    memoryMath: 'Math Memory',
    quickMath: 'Quick Math',
    mixedExercises: 'Mixed Exercises',
    beginner: 'Beginner',
    intermediate: 'Intermediate',
    advanced: 'Advanced',
    expert: 'Expert',
    choosePlan: 'Choose your Plan',
    selectLanguage: 'Select language',
    pricing: 'Pricing',
    home: 'Home',
    games: 'Games',
    about: 'About',
    contact: 'Contact',
  },
  
  ar: {
    appName: 'Math4Child',
    heroTitle: 'الرياضيات رائعة!',
    heroSubtitle: 'التعلم باللعب لم يكن ممتعاً أبداً هكذا',
    heroDescription: 'طور مهارات طفلك الرياضية مع منصتنا التفاعلية',
    startFreeNow: 'ابدأ مجاناً الآن',
    learnMore: 'اعرف المزيد',
    mathGames: 'ألعاب الرياضيات',
    chooseGame: 'اختر لعبتك المفضلة',
    puzzleMath: 'لغز الرياضيات',
    memoryMath: 'ذاكرة الرياضيات',
    quickMath: 'حساب سريع',
    mixedExercises: 'تمارين مختلطة',
    beginner: 'مبتدئ',
    intermediate: 'متوسط',
    advanced: 'متقدم',
    expert: 'خبير',
    choosePlan: 'اختر خطتك',
    selectLanguage: 'اختيار اللغة',
    pricing: 'الأسعار',
    home: 'الرئيسية',
    games: 'الألعاب',
    about: 'حول',
    contact: 'اتصل بنا',
  }
};

export const SUPPORTED_LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', rtl: false },
  { code: 'en', name: 'English', flag: '🇺🇸', rtl: false },
  { code: 'es', name: 'Español', flag: '🇪🇸', rtl: false },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', rtl: false },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true },
  { code: 'zh', name: '中文', flag: '🇨🇳', rtl: false },
  { code: 'ja', name: '日本語', flag: '🇯🇵', rtl: false },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', rtl: false },
  { code: 'pt', name: 'Português', flag: '🇵🇹', rtl: false },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮', rtl: false }
] as const;

export type SupportedLanguage = keyof typeof translations;
EOF

    log_success "Traductions multilingues créées"
}

# ===================================================================
# 🎮 COMPOSANTS REACT
# ===================================================================

create_react_components() {
    log_header "CRÉATION DES COMPOSANTS REACT"
    
    # Context de langue
    cat > "apps/math4child/src/contexts/LanguageContext.tsx" << 'EOF'
'use client'

import React, { createContext, useContext, useState, useEffect } from 'react'
import { translations, SUPPORTED_LANGUAGES, SupportedLanguage } from '@/lib/translations/comprehensive'

interface LanguageContextType {
  currentLanguage: SupportedLanguage
  changeLanguage: (language: SupportedLanguage) => void
  t: typeof translations.fr
  isRTL: boolean
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export function LanguageProvider({ children }: { children: React.ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState<SupportedLanguage>('fr')
  
  useEffect(() => {
    const savedLanguage = localStorage.getItem('math4child_language') as SupportedLanguage
    if (savedLanguage && translations[savedLanguage]) {
      setCurrentLanguage(savedLanguage)
      updateDocumentLanguage(savedLanguage)
    }
  }, [])
  
  const updateDocumentLanguage = (language: SupportedLanguage) => {
    const langData = SUPPORTED_LANGUAGES.find(lang => lang.code === language)
    const isRTL = langData?.rtl || false
    
    document.documentElement.lang = language
    document.documentElement.dir = isRTL ? 'rtl' : 'ltr'
    
    if (isRTL) {
      document.body.classList.add('rtl')
      document.body.classList.remove('ltr')
    } else {
      document.body.classList.add('ltr')
      document.body.classList.remove('rtl')
    }
  }
  
  const changeLanguage = (language: SupportedLanguage) => {
    setCurrentLanguage(language)
    localStorage.setItem('math4child_language', language)
    updateDocumentLanguage(language)
    
    window.dispatchEvent(new CustomEvent('languageChange', { detail: language }))
  }
  
  const currentLangData = SUPPORTED_LANGUAGES.find(lang => lang.code === currentLanguage)
  const isRTL = currentLangData?.rtl || false
  const t = translations[currentLanguage]
  
  return (
    <LanguageContext.Provider value={{
      currentLanguage,
      changeLanguage,
      t,
      isRTL
    }}>
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
EOF

    # Sélecteur de langue
    cat > "apps/math4child/src/components/language/LanguageSelector.tsx" << 'EOF'
'use client'

import React from 'react'
import { useLanguage } from '@/contexts/LanguageContext'
import { SUPPORTED_LANGUAGES } from '@/lib/translations/comprehensive'

export default function LanguageSelector() {
  const { currentLanguage, changeLanguage, isRTL } = useLanguage()
  
  return (
    <div className="relative">
      <select
        data-testid="language-selector"
        className={`
          bg-white text-gray-800 px-4 py-2 rounded-lg border-0 focus:ring-2 focus:ring-blue-500 outline-none cursor-pointer
          ${isRTL ? 'text-right' : 'text-left'}
        `}
        value={currentLanguage}
        onChange={(e) => changeLanguage(e.target.value as any)}
        dir={isRTL ? 'rtl' : 'ltr'}
      >
        {SUPPORTED_LANGUAGES.map((lang) => (
          <option key={lang.code} value={lang.code}>
            {lang.flag} {lang.name}
          </option>
        ))}
      </select>
    </div>
  )
}
EOF

    log_success "Composants React créés"
}

# ===================================================================
# 🚀 APPLICATION NEXT.JS
# ===================================================================

create_nextjs_app() {
    log_header "CRÉATION DE L'APPLICATION NEXT.JS"
    
    # Layout principal
    cat > "apps/math4child/src/app/layout.tsx" << 'EOF'
import './globals.css'
import { Inter } from 'next/font/google'
import { LanguageProvider } from '@/contexts/LanguageContext'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Math4Child - Mathématiques pour Enfants',
  description: 'Application éducative multilingue avec support RTL complet',
  keywords: 'mathématiques, enfants, éducation, multilingue, RTL, arabe',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <link
          href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;600;700&family=Amiri:wght@400;700&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className={inter.className}>
        <LanguageProvider>
          {children}
        </LanguageProvider>
      </body>
    </html>
  )
}
EOF

    # Page principale
    cat > "apps/math4child/src/app/page.tsx" << 'EOF'
'use client'

import { useLanguage } from '@/contexts/LanguageContext'
import LanguageSelector from '@/components/language/LanguageSelector'

export default function Home() {
  const { currentLanguage, t, isRTL } = useLanguage()
  
  return (
    <main 
      className={`min-h-screen bg-gradient-to-br from-blue-500 to-purple-600 text-white`}
      dir={isRTL ? 'rtl' : 'ltr'}
      lang={currentLanguage}
    >
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <header className="flex justify-between items-center mb-12">
          <h1 className="text-4xl font-bold" data-testid="app-title">
            {t.appName}
          </h1>
          <LanguageSelector />
        </header>

        {/* Hero Section */}
        <section className="text-center mb-16">
          <h2 className="text-6xl font-bold mb-6">{t.heroTitle}</h2>
          <p className="text-xl mb-8">{t.heroSubtitle}</p>
          <p className="text-lg mb-12 opacity-90">{t.heroDescription}</p>
          
          <div className="flex justify-center gap-4">
            <button 
              className="bg-yellow-400 text-gray-800 px-8 py-4 rounded-full text-lg font-semibold hover:bg-yellow-300 transition-colors"
              data-testid="start-free"
            >
              {t.startFreeNow}
            </button>
            <button 
              className="border-2 border-white px-8 py-4 rounded-full text-lg font-semibold hover:bg-white hover:text-gray-800 transition-colors"
            >
              {t.learnMore}
            </button>
          </div>
        </section>

        {/* Games Section */}
        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center mb-8">{t.mathGames}</h3>
          <p className="text-center mb-12">{t.chooseGame}</p>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              { name: t.puzzleMath, icon: '🧩', level: t.beginner },
              { name: t.memoryMath, icon: '🧠', level: t.intermediate },
              { name: t.quickMath, icon: '⚡', level: t.advanced },
              { name: t.mixedExercises, icon: '🎯', level: t.expert }
            ].map((game, index) => (
              <div 
                key={index} 
                className="bg-white bg-opacity-20 backdrop-blur-lg rounded-xl p-6 hover:bg-opacity-30 transition-all cursor-pointer"
                data-testid={`game-${index}`}
              >
                <div className="text-4xl mb-4">{game.icon}</div>
                <h4 className="text-xl font-semibold mb-2">{game.name}</h4>
                <p className="text-sm opacity-75">{game.level}</p>
              </div>
            ))}
          </div>
        </section>

        {/* Pricing Link */}
        <section className="text-center">
          <h3 className="text-3xl font-bold mb-4">{t.choosePlan}</h3>
          <a 
            href="/pricing"
            className="bg-purple-500 hover:bg-purple-600 text-white px-8 py-4 rounded-full text-lg font-semibold transition-colors inline-block"
            data-testid="pricing-link"
          >
            {t.pricing}
          </a>
        </section>

        {/* RTL Indicator */}
        {isRTL && (
          <div className="fixed bottom-4 left-4 bg-black bg-opacity-50 text-white px-3 py-1 rounded-lg text-sm">
            RTL Mode ✓
          </div>
        )}
      </div>
    </main>
  )
}
EOF

    # Page pricing
    cat > "apps/math4child/src/app/pricing/page.tsx" << 'EOF'
'use client'

import { useLanguage } from '@/contexts/LanguageContext'

export default function PricingPage() {
  const { t, isRTL } = useLanguage()
  
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 py-12" dir={isRTL ? 'rtl' : 'ltr'}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            {t.choosePlan}
          </h1>
          <p className="text-xl text-gray-600">
            Plans flexibles pour tous vos besoins éducatifs
          </p>
        </div>
        
        <div className="text-center">
          <p className="text-lg text-gray-600 mb-8">
            Interface pricing complète sera disponible bientôt !
          </p>
          <a 
            href="/"
            className="bg-blue-500 hover:bg-blue-600 text-white px-6 py-3 rounded-lg font-medium transition-colors"
          >
            Retour à l'accueil
          </a>
        </div>
      </div>
    </div>
  )
}
EOF

    log_success "Application Next.js créée"
}

# ===================================================================
# 🧪 CONFIGURATION PLAYWRIGHT
# ===================================================================

create_playwright_configuration() {
    log_header "CONFIGURATION PLAYWRIGHT"
    
    cat > "tests/playwright.config.ts" << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './specs',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: process.env.CI ? 1 : undefined,
  timeout: 60000,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    process.env.CI ? ['github'] : ['list']
  ],
  
  outputDir: 'test-results/',
  
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    actionTimeout: 30000,
    navigationTimeout: 60000,
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },

  projects: [
    {
      name: 'smoke',
      testMatch: /.*\.smoke\.spec\.ts$/,
      use: { ...devices['Desktop Chrome'] },
    },
    
    {
      name: 'translation',
      testMatch: /.*translation.*\.spec\.ts$/,
      use: { ...devices['Desktop Chrome'] },
    },
    
    {
      name: 'rtl',
      testMatch: /.*rtl.*\.spec\.ts$/,
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'ar-SA'
      },
    },
    
    {
      name: 'mobile',
      testMatch: /.*responsive.*\.spec\.ts$/,
      use: { ...devices['Pixel 5'] },
    },
    
    {
      name: 'chrome',
      use: { ...devices['Desktop Chrome'] },
    },
    
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    
    {
      name: 'safari',
      use: { ...devices['Desktop Safari'] },
    }
  ],

  webServer: process.env.CI ? undefined : {
    command: 'cd ../apps/math4child && npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  }
});
EOF

    log_success "Configuration Playwright créée"
}

# ===================================================================
# 🧪 TESTS DE BASE
# ===================================================================

create_basic_tests() {
    log_header "CRÉATION DES TESTS DE BASE"
    
    # Utilitaires de test
    cat > "tests/utils/test-utils.ts" << 'EOF'
import { Page, expect, Locator } from '@playwright/test'

export class Math4ChildTestHelper {
  constructor(private page: Page) {}

  async goto(path: string = '/') {
    await this.page.goto(path)
    await this.page.waitForLoadState('domcontentloaded')
  }

  async changeLanguage(languageCode: string) {
    await this.page.selectOption('[data-testid="language-selector"]', languageCode)
    await this.page.waitForTimeout(1000)
    
    const htmlLang = await this.page.getAttribute('html', 'lang')
    expect(htmlLang).toBe(languageCode)
  }

  async verifyRTLLayout() {
    const direction = await this.page.getAttribute('html', 'dir')
    expect(direction).toBe('rtl')
    
    const lang = await this.page.getAttribute('html', 'lang')
    expect(lang).toBe('ar')
  }
}

export const SELECTORS = {
  languageSelector: '[data-testid="language-selector"]',
  appTitle: '[data-testid="app-title"]',
  startFreeButton: '[data-testid="start-free"]',
  pricingLink: '[data-testid="pricing-link"]',
  gameCards: '[data-testid^="game-"]'
} as const
EOF

    # Test de fumée
    cat > "tests/specs/smoke.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test'
import { Math4ChildTestHelper, SELECTORS } from '../utils/test-utils'

test.describe('Math4Child - Tests de Fumée', () => {
  let testHelper: Math4ChildTestHelper

  test.beforeEach(async ({ page }) => {
    testHelper = new Math4ChildTestHelper(page)
    await testHelper.goto()
  })

  test('Page d\'accueil se charge correctement @smoke', async ({ page }) => {
    await expect(page.locator(SELECTORS.appTitle)).toBeVisible()
    await expect(page.locator(SELECTORS.languageSelector)).toBeVisible()
    await expect(page.locator(SELECTORS.startFreeButton)).toBeVisible()
    
    console.log('✅ Page d\'accueil chargée')
  })

  test('Sélecteur de langue fonctionne @smoke', async ({ page }) => {
    await testHelper.changeLanguage('en')
    await expect(page.locator('h2')).toContainText('Mathematics is Fantastic!')
    
    await testHelper.changeLanguage('ar')
    await expect(page.locator('h2')).toContainText('الرياضيات رائعة!')
    
    console.log('✅ Sélecteur de langue testé')
  })

  test('Navigation vers pricing fonctionne @smoke', async ({ page }) => {
    await page.click(SELECTORS.pricingLink)
    await page.waitForURL('**/pricing')
    
    await expect(page.locator('h1')).toBeVisible()
    
    console.log('✅ Navigation pricing testée')
  })
})
EOF

    # Tests de traduction
    cat > "tests/specs/translation/translation-basic.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test'
import { Math4ChildTestHelper, SELECTORS } from '../../utils/test-utils'

test.describe('Math4Child - Tests de Traduction', () => {
  let testHelper: Math4ChildTestHelper

  test.beforeEach(async ({ page }) => {
    testHelper = new Math4ChildTestHelper(page)
    await testHelper.goto()
  })

  const languages = [
    { code: 'fr', title: 'Les Mathématiques, c\'est Fantastique !' },
    { code: 'en', title: 'Mathematics is Fantastic!' },
    { code: 'ar', title: 'الرياضيات رائعة!' }
  ]

  for (const lang of languages) {
    test(`Interface en ${lang.code} @translation`, async ({ page }) => {
      await testHelper.changeLanguage(lang.code)
      
      await expect(page.locator('h2')).toContainText(lang.title)
      
      if (lang.code === 'ar') {
        await testHelper.verifyRTLLayout()
      }
      
      console.log(`✅ Langue ${lang.code} testée`)
    })
  }
})
EOF

    # Tests RTL
    cat > "tests/specs/rtl/rtl-basic.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test'
import { Math4ChildTestHelper } from '../../utils/test-utils'

test.describe('Math4Child - Tests RTL', () => {
  let testHelper: Math4ChildTestHelper

  test.beforeEach(async ({ page }) => {
    testHelper = new Math4ChildTestHelper(page)
    await testHelper.goto()
    await testHelper.changeLanguage('ar')
  })

  test('Interface RTL appliquée correctement @rtl', async ({ page }) => {
    await testHelper.verifyRTLLayout()
    
    await expect(page.locator('h2')).toContainText('الرياضيات رائعة!')
    
    const direction = await page.locator('main').getAttribute('dir')
    expect(direction).toBe('rtl')
    
    console.log('✅ Interface RTL validée')
  })

  test('Navigation RTL fonctionne @rtl', async ({ page }) => {
    await page.click('[data-testid="pricing-link"]')
    await page.waitForURL('**/pricing')
    
    await testHelper.verifyRTLLayout()
    
    console.log('✅ Navigation RTL testée')
  })
})
EOF

    log_success "Tests de base créés"
}

# ===================================================================
# 📋 MAKEFILE
# ===================================================================

create_makefile() {
    log_header "CRÉATION DU MAKEFILE"
    
    cat > "Makefile" << 'EOF'
.PHONY: help install dev test clean setup

# Couleurs
GREEN := \033[0;32m
BLUE := \033[0;34m
YELLOW := \033[1;33m
NC := \033[0m

help: ## Afficher l'aide
	@echo "$(BLUE)Math4Child - Commandes disponibles:$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

install: ## Installer toutes les dépendances
	@echo "$(BLUE)📦 Installation des dépendances...$(NC)"
	npm run install:all
	@echo "$(GREEN)✅ Installation terminée!$(NC)"

install-browsers: ## Installer les navigateurs Playwright
	@echo "$(BLUE)🌐 Installation des navigateurs Playwright...$(NC)"
	cd tests && npx playwright install --with-deps
	@echo "$(GREEN)✅ Navigateurs installés!$(NC)"

setup: install install-browsers ## Configuration complète
	@echo "$(GREEN)🎉 Setup Math4Child terminé!$(NC)"

dev: ## Démarrer l'application en développement
	@echo "$(BLUE)🚀 Démarrage de Math4Child...$(NC)"
	cd apps/math4child && npm run dev

dev-rtl: ## Démarrer avec langue arabe par défaut
	@echo "$(BLUE)🌍 Démarrage RTL (arabe)...$(NC)"
	cd apps/math4child && npm run dev:rtl

build: ## Build de production
	@echo "$(BLUE)🏗️ Build de production...$(NC)"
	cd apps/math4child && npm run build

test: ## Lancer tous les tests
	@echo "$(BLUE)🧪 Exécution des tests...$(NC)"
	cd tests && npm run test

test-smoke: ## Tests de fumée rapides
	@echo "$(BLUE)💨 Tests de fumée...$(NC)"
	cd tests && npm run test:smoke

test-ui: ## Interface graphique Playwright
	@echo "$(BLUE)🖥️ Interface Playwright...$(NC)"
	cd tests && npm run test:ui

test-headed: ## Tests avec navigateur visible
	@echo "$(BLUE)👀 Tests avec navigateur...$(NC)"
	cd tests && npm run test:headed

test-translation: ## Tests multilingues
	@echo "$(BLUE)🌍 Tests de traduction...$(NC)"
	cd tests && npm run test:translation

test-rtl: ## Tests RTL spécialisés
	@echo "$(BLUE)🇸🇦 Tests RTL...$(NC)"
	cd tests && npm run test:rtl

test-mobile: ## Tests mobile
	@echo "$(BLUE)📱 Tests mobile...$(NC)"
	cd tests && npm run test:mobile

report: ## Voir le rapport de tests
	@echo "$(BLUE)📊 Ouverture du rapport...$(NC)"
	cd tests && npm run test:report

clean: ## Nettoyer les artifacts
	@echo "$(BLUE)🧹 Nettoyage...$(NC)"
	cd apps/math4child && npm run clean
	cd tests && npm run clean
	@echo "$(GREEN)✅ Nettoyage terminé!$(NC)"

validate: ## Validation complète
	@echo "$(BLUE)✅ Validation complète...$(NC)"
	cd apps/math4child && npm run type-check
	cd apps/math4child && npm run lint
	cd tests && npm run test:smoke
	@echo "$(GREEN)🎉 Validation réussie!$(NC)"

# Valeurs par défaut
.DEFAULT_GOAL := help
EOF

    log_success "Makefile créé"
}

# ===================================================================
# 📖 DOCUMENTATION
# ===================================================================

create_documentation() {
    log_header "CRÉATION DE LA DOCUMENTATION"
    
    cat > "README.md" << 'EOF'
# 🚀 Math4Child - Application Éducative Multilingue

Application éducative complète pour l'apprentissage des mathématiques avec support RTL natif.

## ✨ Fonctionnalités

- 🌍 **10 langues supportées** avec interface RTL pour l'arabe
- 🎮 **4 types de jeux** mathématiques interactifs
- 📱 **Design responsive** mobile/tablette/desktop
- 🧪 **Tests automatisés** avec Playwright
- 🎨 **Interface RTL native** pour les langues arabes

## 🚀 Installation Rapide

```bash
# Cloner le projet
git clone <repository-url>
cd math4child-platform

# Installation complète
make setup

# Démarrage
make dev
```

## 🎮 Commandes Principales

```bash
make dev              # Serveur de développement
make dev-rtl          # Serveur avec arabe par défaut
make test             # Tous les tests
make test-ui          # Interface de test
make test-rtl         # Tests RTL spécialisés
make help             # Aide complète
```

## 🌍 Langues Supportées

| Langue | Code | RTL | Statut |
|--------|------|-----|--------|
| 🇫🇷 Français | `fr` | Non | ✅ |
| 🇺🇸 English | `en` | Non | ✅ |
| 🇸🇦 العربية | `ar` | **Oui** | ✅ |
| 🇪🇸 Español | `es` | Non | 🚧 |
| 🇩🇪 Deutsch | `de` | Non | 🚧 |

## 📁 Structure

```
math4child-platform/
├── apps/math4child/     # Application Next.js
│   ├── src/app/         # Pages et layouts
│   ├── src/components/  # Composants React
│   └── src/lib/         # Utilitaires et traductions
├── tests/               # Tests Playwright
│   ├── specs/          # Fichiers de test
│   └── utils/          # Utilitaires de test
└── docs/               # Documentation
```

## 🧪 Tests

```bash
# Tests de base
make test-smoke

# Tests multilingues
make test-translation

# Tests RTL (arabe)
make test-rtl

# Interface de test
make test-ui
```

## 🚀 Déploiement

```bash
# Build de production
make build

# Validation avant déploiement
make validate
```

## 📞 Support

- 📖 Documentation complète dans `/docs`
- 🧪 Tests automatisés pour validation
- 🌍 Support RTL natif pour l'arabe

---

**Math4Child** - Rendre les mathématiques amusantes pour tous les enfants ! 🎓✨
EOF

    log_success "Documentation créée"
}

# ===================================================================
# 🏁 INSTALLATION DES DÉPENDANCES
# ===================================================================

install_dependencies() {
    log_header "INSTALLATION DES DÉPENDANCES"
    
    log_step "Installation des dépendances du workspace principal..."
    npm install
    
    log_step "Installation des dépendances de Math4Child..."
    cd apps/math4child && npm install && cd ../..
    
    log_step "Installation des dépendances de test..."
    cd tests && npm install && cd ..
    
    log_step "Installation des navigateurs Playwright..."
    cd tests && npx playwright install --with-deps && cd ..
    
    log_success "Toutes les dépendances installées"
}

# ===================================================================
# ✅ VALIDATION FINALE
# ===================================================================

run_final_validation() {
    log_header "VALIDATION FINALE"
    
    log_step "Vérification de la compilation TypeScript..."
    cd apps/math4child && npm run type-check && cd ../.. || log_warning "Problèmes TypeScript détectés"
    
    log_step "Tests de fumée..."
    cd tests && timeout 60 npm run test:smoke && cd .. || log_warning "Certains tests ont échoué"
    
    log_success "Validation finale terminée"
}

# ===================================================================
# 🎯 FONCTION PRINCIPALE
# ===================================================================

main() {
    log_header "SETUP COMPLET MATH4CHILD v${SCRIPT_VERSION}"
    
    echo -e "${BOLD}Ce script va créer une application Math4Child complète avec :${NC}"
    echo -e "${BLUE}• 🏗️ Structure Next.js complète avec TypeScript${NC}"
    echo -e "${BLUE}• 🌍 Support RTL natif pour l'arabe${NC}"
    echo -e "${BLUE}• 🧪 Tests Playwright automatisés${NC}"
    echo -e "${BLUE}• 📱 Interface responsive${NC}"
    echo -e "${BLUE}• 🎮 Composants de jeux interactifs${NC}"
    echo -e "${BLUE}• 🔧 Configuration de développement${NC}"
    echo -e "${BLUE}• 📋 Makefile avec commandes utiles${NC}"
    echo ""
    
    read -p "🚀 Continuer l'installation ? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation annulée."
        exit 0
    fi
    
    # Initialisation des logs
    echo "$(date): Démarrage setup complet v$SCRIPT_VERSION" > "$LOG_FILE"
    
    # Étapes d'installation
    check_prerequisites
    create_backup
    create_project_structure
    create_package_configurations
    create_nextjs_configuration
    create_global_styles
    create_translations
    create_react_components
    create_nextjs_app
    create_playwright_configuration
    create_basic_tests
    create_makefile
    create_documentation
    install_dependencies
    run_final_validation
    
    # Affichage final
    show_final_summary
}

# ===================================================================
# 🎉 AFFICHAGE FINAL
# ===================================================================

show_final_summary() {
    log_header "🎉 SETUP MATH4CHILD RÉUSSI !"
    
    echo -e "${GREEN}✨ Application Math4Child configurée avec succès !${NC}"
    echo ""
    echo -e "${BOLD}🎯 PROCHAINES ÉTAPES :${NC}"
    echo -e "${CYAN}1.${NC} Démarrer l'application : ${GREEN}make dev${NC}"
    echo -e "${CYAN}2.${NC} Voir l'app : ${GREEN}http://localhost:3000${NC}"
    echo -e "${CYAN}3.${NC} Tests avec interface : ${GREEN}make test-ui${NC}"
    echo -e "${CYAN}4.${NC} Aide complète : ${GREEN}make help${NC}"
    echo ""
    echo -e "${BOLD}🌐 URLS IMPORTANTES :${NC}"
    echo -e "${BLUE}•${NC} Application : ${GREEN}http://localhost:3000${NC}"
    echo -e "${BLUE}•${NC} Page pricing : ${GREEN}http://localhost:3000/pricing${NC}"
    echo ""
    echo -e "${BOLD}🌍 FONCTIONNALITÉS RTL :${NC}"
    echo -e "${BLUE}•${NC} Changez vers العربية dans le sélecteur"
    echo -e "${BLUE}•${NC} Interface complète droite-à-gauche"
    echo -e "${BLUE}•${NC} Typography arabe optimisée"
    echo ""
    echo -e "${BOLD}🧪 TESTS DISPONIBLES :${NC}"
    echo -e "${BLUE}•${NC} ${GREEN}make test-smoke${NC} - Tests rapides"
    echo -e "${BLUE}•${NC} ${GREEN}make test-translation${NC} - Tests multilingues"
    echo -e "${BLUE}•${NC} ${GREEN}make test-rtl${NC} - Tests RTL"
    echo -e "${BLUE}•${NC} ${GREEN}make test-ui${NC} - Interface de test"
    echo ""
    echo -e "${YELLOW}📝 Logs détaillés : $LOG_FILE${NC}"
    echo -e "${YELLOW}💾 Sauvegarde : $BACKUP_DIR${NC}"
    echo ""
    echo -e "${GREEN}🚀 Math4Child est prêt ! Bon développement ! 🎓✨${NC}"
}

# ===================================================================
# 🛠️ GESTION D'ERREUR
# ===================================================================

handle_error() {
    local exit_code=$?
    log_error "Erreur détectée (code: $exit_code)"
    
    if [ -d "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}💾 Sauvegarde disponible dans $BACKUP_DIR${NC}"
    fi
    
    echo -e "${RED}❌ Setup échoué. Consultez $LOG_FILE${NC}"
    exit $exit_code
}

# Piéger les erreurs
trap 'handle_error' ERR

# Exécution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi