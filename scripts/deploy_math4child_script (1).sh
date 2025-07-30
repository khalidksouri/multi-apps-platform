#!/bin/bash

# =============================================================================
# 🚀 SCRIPT DE DÉPLOIEMENT MATH4CHILD V4.0
# Déploiement complet de la nouvelle version Math4Child
# =============================================================================

set -e  # Arrêter en cas d'erreur

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
APP_DIR="$PROJECT_ROOT/apps/math4child"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_DIR="$PROJECT_ROOT/backup_$TIMESTAMP"

# Couleurs pour output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fonctions utilitaires
log() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

info() {
    echo -e "${CYAN}[INFO] $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Vérification des prérequis
check_prerequisites() {
    log "🔍 Vérification des prérequis..."
    
    # Node.js
    if ! command -v node &> /dev/null; then
        error "Node.js n'est pas installé. Version requise: >= 18.0.0"
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2)
    if [[ $(echo "$NODE_VERSION 18.0.0" | tr " " "\n" | sort -V | head -n1) != "18.0.0" ]]; then
        error "Node.js version >= 18.0.0 requise. Version actuelle: $NODE_VERSION"
    fi
    
    # npm
    if ! command -v npm &> /dev/null; then
        error "npm n'est pas installé"
    fi
    
    # Git
    if ! command -v git &> /dev/null; then
        warn "Git n'est pas installé - sauvegarde manuelle recommandée"
    fi
    
    success "Prérequis validés"
}

# Sauvegarde du projet existant
backup_existing() {
    log "💾 Sauvegarde du projet existant..."
    
    if [[ -d "$APP_DIR" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$APP_DIR" "$BACKUP_DIR/" 2>/dev/null || true
        success "Sauvegarde créée dans: $BACKUP_DIR"
    else
        info "Aucun projet existant à sauvegarder"
    fi
}

# Création de la structure de projet
create_project_structure() {
    log "📁 Création de la structure de projet..."
    
    # Créer la structure principale
    mkdir -p "$APP_DIR"/{src,public,scripts,tests}
    mkdir -p "$APP_DIR"/src/{app,components,styles,types,utils,stores}
    mkdir -p "$APP_DIR"/src/app/{api,globals.css}
    mkdir -p "$APP_DIR"/public
    
    success "Structure de projet créée"
}

# Configuration Next.js et TypeScript
setup_nextjs_config() {
    log "⚙️ Configuration Next.js et TypeScript..."
    
    # next.config.js
    cat > "$APP_DIR/next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  output: 'export',
  trailingSlash: true,
  skipTrailingSlashRedirect: true,
  distDir: 'out',
  assetPrefix: process.env.NODE_ENV === 'production' ? '/math4child' : '',
  basePath: process.env.NODE_ENV === 'production' ? '/math4child' : '',
  images: {
    unoptimized: true,
    domains: [],
    loader: 'custom',
    loaderFile: './src/utils/imageLoader.js'
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  experimental: {
    appDir: true,
  }
}

module.exports = nextConfig
EOF

    # tsconfig.json
    cat > "$APP_DIR/tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "es6"],
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
      "@/utils/*": ["./src/utils/*"],
      "@/types/*": ["./src/types/*"],
      "@/stores/*": ["./src/stores/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

    # tailwind.config.js
    cat > "$APP_DIR/tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
EOF

    # postcss.config.js
    cat > "$APP_DIR/postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

    # Image loader utility
    mkdir -p "$APP_DIR/src/utils"
    cat > "$APP_DIR/src/utils/imageLoader.js" << 'EOF'
export default function imageLoader({ src, width, quality }) {
  return `${src}?w=${width}&q=${quality || 75}`
}
EOF

    success "Configuration Next.js créée"
}

# Package.json
create_package_json() {
    log "📦 Création du package.json..."
    
    cat > "$APP_DIR/package.json" << 'EOF'
{
  "name": "math4child",
  "version": "4.0.0",
  "description": "Math4Child - Application éducative de mathématiques pour enfants",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start",
    "export": "next build && next export",
    "lint": "next lint",
    "type-check": "tsc --noEmit",
    "clean": "rm -rf .next out node_modules/.cache",
    "test": "npm run type-check && npm run lint",
    "build:web": "npm run build",
    "build:android": "npm run build && npx cap add android && npx cap sync android",
    "build:ios": "npm run build && npx cap add ios && npx cap sync ios",
    "android:build": "npm run build:android && npx cap open android",
    "ios:build": "npm run build:ios && npx cap open ios"
  },
  "dependencies": {
    "next": "14.2.30",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "typescript": "5.4.5",
    "@types/react": "18.3.3",
    "@types/react-dom": "18.3.0",
    "@types/node": "20.14.8",
    "zustand": "^4.4.7",
    "lucide-react": "^0.263.1"
  },
  "devDependencies": {
    "tailwindcss": "^3.3.6",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.32",
    "eslint": "^8.57.0",
    "eslint-config-next": "14.2.30",
    "@capacitor/core": "^5.0.0",
    "@capacitor/cli": "^5.0.0",
    "@capacitor/android": "^5.0.0",
    "@capacitor/ios": "^5.0.0"
  },
  "keywords": [
    "math",
    "education",
    "children",
    "learning",
    "mathematics",
    "kids",
    "multilingual"
  ],
  "author": "GOTEST",
  "license": "MIT"
}
EOF

    success "Package.json créé"
}

# Types TypeScript
create_types() {
    log "🏷️ Création des types TypeScript..."
    
    # Types globaux
    cat > "$APP_DIR/src/types/global.d.ts" << 'EOF'
declare global {
  interface Window {
    gtag?: (...args: unknown[]) => void
  }
  
  namespace NodeJS {
    interface ProcessEnv {
      NEXT_PUBLIC_BASE_URL: string
      NEXT_PUBLIC_APP_ENV: 'development' | 'production' | 'preview'
      NODE_ENV: 'development' | 'production' | 'test'
    }
  }
}

export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  countries: string[]
}

export interface Level {
  id: string
  name: string
  color: string
  range: [number, number]
  requiredAnswers: number
  description: string
}

export interface Operation {
  id: string
  name: string
  symbol: string
  color: string
}

export interface Question {
  questionText: string
  answer: number
  num1: number
  num2: number
  operation: string
}

export interface SubscriptionPlan {
  id: string
  title: string
  price: string
  duration: string
  features: string[]
  buttonText: string
  popular?: boolean
  bestValue?: boolean
  platforms: string[]
}

export {}
EOF

    success "Types TypeScript créés"
}

# Store Zustand
create_store() {
    log "🗄️ Création du store Zustand..."
    
    cat > "$APP_DIR/src/stores/gameStore.ts" << 'EOF'
import { create } from 'zustand'
import { Question, Level, Operation } from '@/types/global'

interface GameState {
  // État du jeu
  currentView: string
  currentLanguage: string
  currentCountry: string
  selectedLevel: string
  selectedOperation: string
  currentQuestion: Question | null
  userAnswer: string
  score: number
  streak: number
  questionsAnswered: number
  lives: number
  feedback: string
  isCorrect: boolean | null
  freeQuestionsLeft: number
  
  // Progression
  correctAnswers: Record<string, number>
  unlockedLevels: string[]
  
  // Actions
  setCurrentView: (view: string) => void
  setLanguage: (lang: string) => void
  setLevel: (level: string) => void
  setOperation: (operation: string) => void
  setCurrentQuestion: (question: Question | null) => void
  setUserAnswer: (answer: string) => void
  updateScore: (points: number) => void
  setFeedback: (feedback: string, correct: boolean | null) => void
  nextQuestion: () => void
  resetGame: () => void
}

export const useGameStore = create<GameState>((set, get) => ({
  // État initial
  currentView: 'home',
  currentLanguage: 'fr',
  currentCountry: 'FR',
  selectedLevel: '',
  selectedOperation: '',
  currentQuestion: null,
  userAnswer: '',
  score: 0,
  streak: 0,
  questionsAnswered: 0,
  lives: 3,
  feedback: '',
  isCorrect: null,
  freeQuestionsLeft: 50,
  correctAnswers: {
    beginner: 0,
    elementary: 0,
    intermediate: 0,
    advanced: 0,
    expert: 0
  },
  unlockedLevels: ['beginner'],
  
  // Actions
  setCurrentView: (view) => set({ currentView: view }),
  setLanguage: (lang) => set({ currentLanguage: lang }),
  setLevel: (level) => set({ selectedLevel: level }),
  setOperation: (operation) => set({ selectedOperation: operation }),
  setCurrentQuestion: (question) => set({ currentQuestion: question }),
  setUserAnswer: (answer) => set({ userAnswer: answer }),
  updateScore: (points) => set((state) => ({ 
    score: state.score + points,
    streak: points > 0 ? state.streak + 1 : 0
  })),
  setFeedback: (feedback, correct) => set({ feedback, isCorrect: correct }),
  nextQuestion: () => {
    const state = get()
    set({
      userAnswer: '',
      feedback: '',
      isCorrect: null,
      questionsAnswered: state.questionsAnswered + 1,
      freeQuestionsLeft: Math.max(0, state.freeQuestionsLeft - 1)
    })
  },
  resetGame: () => set({
    score: 0,
    streak: 0,
    questionsAnswered: 0,
    lives: 3,
    feedback: '',
    isCorrect: null,
    userAnswer: '',
    currentQuestion: null
  })
}))
EOF

    success "Store Zustand créé"
}

# Composant principal
create_main_component() {
    log "⚛️ Création du composant principal..."
    
    # Layout principal
    cat > "$APP_DIR/src/app/layout.tsx" << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - Apprendre les maths en s\'amusant',
  description: 'Application éducative de mathématiques pour enfants - 195+ langues supportées',
  keywords: 'math, éducation, enfants, apprentissage, mathématiques',
  authors: [{ name: 'GOTEST' }],
  viewport: 'width=device-width, initial-scale=1, maximum-scale=1',
  themeColor: '#3b82f6',
  manifest: '/manifest.json',
  icons: {
    icon: '/favicon.svg',
    apple: '/icon-192.png'
  }
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
      </head>
      <body className={inter.className}>
        <div id="root">{children}</div>
      </body>
    </html>
  )
}
EOF

    # Page principale - copie exacte du composant React de l'artefact
    cat > "$APP_DIR/src/app/page.tsx" << 'EOF'
'use client'

import React, { useState, useEffect } from 'react';
import { ChevronDown, Star, Play, Users, Trophy, Zap, Globe, Smartphone, BookOpen, BarChart3, Heart, ArrowRight, ArrowLeft, Calculator, Target, Award, Lock, Check, Crown, Shield } from 'lucide-react';

const Math4ChildProduction = () => {
  // États principaux
  const [currentLanguage, setCurrentLanguage] = useState('fr');
  const [currentCountry, setCurrentCountry] = useState('FR');
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false);
  const [currentView, setCurrentView] = useState('home');
  const [selectedLevel, setSelectedLevel] = useState('');
  const [selectedOperation, setSelectedOperation] = useState('');
  const [currentQuestion, setCurrentQuestion] = useState(null);
  const [userAnswer, setUserAnswer] = useState('');
  const [score, setScore] = useState(0);
  const [streak, setStreak] = useState(0);
  const [questionsAnswered, setQuestionsAnswered] = useState(0);
  const [correctAnswers, setCorrectAnswers] = useState({
    beginner: 0, 
    elementary: 0, 
    intermediate: 0, 
    advanced: 0, 
    expert: 0
  });
  const [unlockedLevels, setUnlockedLevels] = useState(['beginner']);
  const [lives, setLives] = useState(3);
  const [feedback, setFeedback] = useState('');
  const [isCorrect, setIsCorrect] = useState(null);
  const [freeQuestionsLeft, setFreeQuestionsLeft] = useState(50);
  const [userSubscriptions, setUserSubscriptions] = useState([]); // ['web', 'android', 'ios']
  const [selectedPricingPeriod, setSelectedPricingPeriod] = useState('monthly');

  // Configuration des langues mondiales (sans duplication)
  const worldLanguages = [
    // Europe
    { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', countries: ['FR', 'BE', 'CH', 'CA', 'SN', 'CI', 'ML', 'BF', 'NE', 'TD', 'MG', 'CM', 'TG', 'BJ', 'BI', 'RW', 'DJ', 'KM', 'SC', 'VU', 'NC', 'PF'] },
    { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', countries: ['US', 'UK', 'CA', 'AU', 'NZ', 'ZA', 'NG', 'KE', 'UG', 'TZ', 'ZW', 'ZM', 'MW', 'BW', 'NA', 'SZ', 'LS', 'LR', 'SL', 'GH', 'GM', 'IE', 'MT'] },
    { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', countries: ['ES', 'MX', 'AR', 'CO', 'PE', 'VE', 'CL', 'EC', 'GT', 'CU', 'BO', 'DO', 'HN', 'PY', 'SV', 'NI', 'CR', 'PA', 'UY', 'GQ'] },
    { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', countries: ['DE', 'AT', 'CH', 'LI', 'LU'] },
    { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', countries: ['IT', 'CH', 'SM', 'VA'] },
    { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹', countries: ['PT', 'BR', 'AO', 'MZ', 'CV', 'GW', 'ST', 'TL', 'MO'] },
    { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', countries: ['RU', 'BY', 'KZ', 'KG', 'TJ', 'UZ', 'TM', 'MD'] },
    { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', countries: ['NL', 'BE', 'SR'] },
    { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', countries: ['PL'] },
    { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', countries: ['SE', 'FI'] },
    { code: 'no', name: 'Norsk', nativeName: 'Norsk', flag: '🇳🇴', countries: ['NO'] },
    { code: 'da', name: 'Dansk', nativeName: 'Dansk', flag: '🇩🇰', countries: ['DK'] },
    { code: 'fi', name: 'Suomi', nativeName: 'Suomi', flag: '🇫🇮', countries: ['FI'] },
    { code: 'cs', name: 'Čeština', nativeName: 'Čeština', flag: '🇨🇿', countries: ['CZ'] },
    { code: 'sk', name: 'Slovenčina', nativeName: 'Slovenčina', flag: '🇸🇰', countries: ['SK'] },
    { code: 'hu', name: 'Magyar', nativeName: 'Magyar', flag: '🇭🇺', countries: ['HU'] },
    { code: 'ro', name: 'Română', nativeName: 'Română', flag: '🇷🇴', countries: ['RO', 'MD'] },
    { code: 'bg', name: 'Български', nativeName: 'Български', flag: '🇧🇬', countries: ['BG'] },
    { code: 'hr', name: 'Hrvatski', nativeName: 'Hrvatski', flag: '🇭🇷', countries: ['HR'] },
    { code: 'sr', name: 'Српски', nativeName: 'Српски', flag: '🇷🇸', countries: ['RS', 'BA', 'ME'] },
    { code: 'sl', name: 'Slovenščina', nativeName: 'Slovenščina', flag: '🇸🇮', countries: ['SI'] },
    { code: 'et', name: 'Eesti', nativeName: 'Eesti', flag: '🇪🇪', countries: ['EE'] },
    { code: 'lv', name: 'Latviešu', nativeName: 'Latviešu', flag: '🇱🇻', countries: ['LV'] },
    { code: 'lt', name: 'Lietuvių', nativeName: 'Lietuvių', flag: '🇱🇹', countries: ['LT'] },
    { code: 'el', name: 'Ελληνικά', nativeName: 'Ελληνικά', flag: '🇬🇷', countries: ['GR', 'CY'] },
    { code: 'tr', name: 'Türkçe', nativeName: 'Türkçe', flag: '🇹🇷', countries: ['TR', 'CY'] },
    { code: 'uk', name: 'Українська', nativeName: 'Українська', flag: '🇺🇦', countries: ['UA'] },
    
    // Asie
    { code: 'zh', name: '中文', nativeName: '中文', flag: '🇨🇳', countries: ['CN', 'TW', 'HK', 'MO', 'SG'] },
    { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', countries: ['JP'] },
    { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', countries: ['KR', 'KP'] },
    { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', countries: ['IN'] },
    { code: 'bn', name: 'বাংলা', nativeName: 'বাংলা', flag: '🇧🇩', countries: ['BD', 'IN'] },
    { code: 'ur', name: 'اردو', nativeName: 'اردو', flag: '🇵🇰', countries: ['PK', 'IN'] },
    { code: 'fa', name: 'فارسی', nativeName: 'فارسی', flag: '🇮🇷', countries: ['IR', 'AF', 'TJ'] },
    { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇲🇦', countries: ['SA', 'EG', 'DZ', 'SD', 'IQ', 'MA', 'YE', 'SY', 'TN', 'JO', 'AE', 'LB', 'LY', 'OM', 'KW', 'MR', 'QA', 'BH', 'DJ', 'SO', 'KM'] },
    { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭', countries: ['TH'] },
    { code: 'vi', name: 'Tiếng Việt', nativeName: 'Tiếng Việt', flag: '🇻🇳', countries: ['VN'] },
    { code: 'id', name: 'Bahasa Indonesia', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', countries: ['ID'] },
    { code: 'ms', name: 'Bahasa Melayu', nativeName: 'Bahasa Melayu', flag: '🇲🇾', countries: ['MY', 'BN', 'SG'] },
    { code: 'tl', name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭', countries: ['PH'] },
    { code: 'my', name: 'မြန်မာ', nativeName: 'မြန်မာ', flag: '🇲🇲', countries: ['MM'] },
    { code: 'km', name: 'ខ្មែរ', nativeName: 'ខ្មែរ', flag: '🇰🇭', countries: ['KH'] },
    { code: 'lo', name: 'ລາວ', nativeName: 'ລາວ', flag: '🇱🇦', countries: ['LA'] },
    { code: 'ka', name: 'ქართული', nativeName: 'ქართული', flag: '🇬🇪', countries: ['GE'] },
    { code: 'hy', name: 'Հայերեն', nativeName: 'Հայերեն', flag: '🇦🇲', countries: ['AM'] },
    { code: 'az', name: 'Azərbaycan', nativeName: 'Azərbaycan', flag: '🇦🇿', countries: ['AZ'] },
    
    // Afrique
    { code: 'sw', name: 'Kiswahili', nativeName: 'Kiswahili', flag: '🇹🇿', countries: ['TZ', 'KE', 'UG', 'RW', 'BI', 'CD', 'MZ'] },
    { code: 'am', name: 'አማርኛ', nativeName: 'አማርኛ', flag: '🇪🇹', countries: ['ET'] },
    { code: 'ha', name: 'Hausa', nativeName: 'Hausa', flag: '🇳🇬', countries: ['NG', 'NE', 'GH', 'TD', 'CM'] },
    { code: 'yo', name: 'Yorùbá', nativeName: 'Yorùbá', flag: '🇳🇬', countries: ['NG', 'BJ'] },
    { code: 'ig', name: 'Igbo', nativeName: 'Igbo', flag: '🇳🇬', countries: ['NG'] },
    { code: 'zu', name: 'isiZulu', nativeName: 'isiZulu', flag: '🇿🇦', countries: ['ZA'] },
    { code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', countries: ['ZA', 'NA'] },
    { code: 'xh', name: 'isiXhosa', nativeName: 'isiXhosa', flag: '🇿🇦', countries: ['ZA'] },
    
    // Amérique
    { code: 'qu', name: 'Quechua', nativeName: 'Quechua', flag: '🇵🇪', countries: ['PE', 'BO', 'EC'] },
    { code: 'gn', name: 'Guaraní', nativeName: 'Guaraní', flag: '🇵🇾', countries: ['PY'] },
    
    // Océanie
    { code: 'mi', name: 'Te Reo Māori', nativeName: 'Te Reo Māori', flag: '🇳🇿', countries: ['NZ'] },
    { code: 'fj', name: 'Na Vosa Vakaviti', nativeName: 'Na Vosa Vakaviti', flag: '🇫🇯', countries: ['FJ'] },
    { code: 'to', name: 'Lea Fakatonga', nativeName: 'Lea Fakatonga', flag: '🇹🇴', countries: ['TO'] },
    { code: 'sm', name: 'Gagana Samoa', nativeName: 'Gagana Samoa', flag: '🇼🇸', countries: ['WS'] }
  ];

  // Configuration des monnaies et pouvoir d'achat par pays
  const countryPricing = {
    // Amérique du Nord (Pouvoir d'achat élevé)
    US: { currency: 'USD', symbol: '$', multiplier: 1.0, monthly: 9.99, quarterly: 26.97, yearly: 69.93 },
    CA: { currency: 'CAD', symbol: 'C$', multiplier: 1.35, monthly: 13.49, quarterly: 36.44, yearly: 94.41 },
    
    // Europe Occidentale (Pouvoir d'achat élevé)
    FR: { currency: 'EUR', symbol: '€', multiplier: 0.85, monthly: 8.49, quarterly: 22.92, yearly: 59.43 },
    DE: { currency: 'EUR', symbol: '€', multiplier: 0.85, monthly: 8.49, quarterly: 22.92, yearly: 59.43 },
    UK: { currency: 'GBP', symbol: '£', multiplier: 0.75, monthly: 7.49, quarterly: 20.22, yearly: 52.44 },
    CH: { currency: 'CHF', symbol: 'CHF', multiplier: 0.92, monthly: 9.19, quarterly: 24.81, yearly: 64.33 },
    NO: { currency: 'NOK', symbol: 'kr', multiplier: 10.5, monthly: 104.90, quarterly: 283.23, yearly: 734.30 },
    DK: { currency: 'DKK', symbol: 'kr', multiplier: 6.8, monthly: 67.93, quarterly: 183.42, yearly: 475.51 },
    SE: { currency: 'SEK', symbol: 'kr', multiplier: 10.2, monthly: 101.90, quarterly: 275.13, yearly: 713.27 },
    
    // Europe de l'Est (Pouvoir d'achat moyen)
    PL: { currency: 'PLN', symbol: 'zł', multiplier: 4.2, monthly: 27.99, quarterly: 75.57, yearly: 195.93 },
    CZ: { currency: 'CZK', symbol: 'Kč', multiplier: 22.5, monthly: 149.99, quarterly: 404.97, yearly: 1049.43 },
    HU: { currency: 'HUF', symbol: 'Ft', multiplier: 350, monthly: 2499, quarterly: 6747, yearly: 17493 },
    RO: { currency: 'RON', symbol: 'lei', multiplier: 4.6, monthly: 30.99, quarterly: 83.67, yearly: 216.93 },
    
    // Asie développée (Pouvoir d'achat élevé)
    JP: { currency: 'JPY', symbol: '¥', multiplier: 145, monthly: 1449, quarterly: 3912, yearly: 10143 },
    KR: { currency: 'KRW', symbol: '₩', multiplier: 1320, monthly: 13199, quarterly: 35637, yearly: 92373 },
    SG: { currency: 'SGD', symbol: 'S$', multiplier: 1.35, monthly: 13.49, quarterly: 36.44, yearly: 94.41 },
    HK: { currency: 'HKD', symbol: 'HK$', multiplier: 7.8, monthly: 77.92, quarterly: 210.36, yearly: 545.54 },
    
    // Asie émergente (Pouvoir d'achat moyen-faible)
    CN: { currency: 'CNY', symbol: '¥', multiplier: 7.2, monthly: 35.99, quarterly: 97.17, yearly: 251.93 },
    IN: { currency: 'INR', symbol: '₹', multiplier: 83, monthly: 399, quarterly: 1077, yearly: 2793 },
    ID: { currency: 'IDR', symbol: 'Rp', multiplier: 15500, monthly: 77500, quarterly: 209250, yearly: 542500 },
    TH: { currency: 'THB', symbol: '฿', multiplier: 35, monthly: 175, quarterly: 472, yearly: 1225 },
    MY: { currency: 'MYR', symbol: 'RM', multiplier: 4.6, monthly: 22.99, quarterly: 62.07, yearly: 160.93 },
    PH: { currency: 'PHP', symbol: '₱', multiplier: 55, monthly: 274.99, quarterly: 742.47, yearly: 1924.43 },
    VN: { currency: 'VND', symbol: '₫', multiplier: 24000, monthly: 119999, quarterly: 323997, yearly: 839993 },
    
    // Moyen-Orient (Pouvoir d'achat variable)
    SA: { currency: 'SAR', symbol: 'ر.س', multiplier: 3.75, monthly: 18.74, quarterly: 50.60, yearly: 131.19 },
    AE: { currency: 'AED', symbol: 'د.إ', multiplier: 3.67, multiplier: 18.35, quarterly: 49.54, yearly: 128.44 },
    IL: { currency: 'ILS', symbol: '₪', multiplier: 3.7, monthly: 18.49, quarterly: 49.92, yearly: 129.43 },
    TR: { currency: 'TRY', symbol: '₺', multiplier: 30, monthly: 149.99, quarterly: 404.97, yearly: 1049.43 },
    
    // Afrique (Pouvoir d'achat faible-moyen)
    ZA: { currency: 'ZAR', symbol: 'R', multiplier: 18.5, monthly: 92.49, quarterly: 249.72, yearly: 647.43 },
    NG: { currency: 'NGN', symbol: '₦', multiplier: 850, monthly: 4249, quarterly: 11472, yearly: 29743 },
    EG: { currency: 'EGP', symbol: 'ج.م', multiplier: 48, monthly: 239.99, quarterly: 647.97, yearly: 1679.43 },
    MA: { currency: 'MAD', symbol: 'د.م.', multiplier: 10, monthly: 49.99, quarterly: 134.97, yearly: 349.93 },
    
    // Amérique Latine (Pouvoir d'achat moyen-faible)
    BR: { currency: 'BRL', symbol: 'R$', multiplier: 5.2, monthly: 25.99, quarterly: 70.17, yearly: 181.93 },
    MX: { currency: 'MXN', symbol: '$', multiplier: 18, monthly: 89.99, quarterly: 242.97, yearly: 629.93 },
    AR: { currency: 'ARS', symbol: '$', multiplier: 850, monthly: 4249, quarterly: 11472, yearly: 29743 },
    CL: { currency: 'CLP', symbol: '$', multiplier: 900, monthly: 4499, quarterly: 12147, yearly: 31493 },
    CO: { currency: 'COP', symbol: '$', multiplier: 4200, monthly: 20999, quarterly: 56697, yearly: 146993 },
    
    // Océanie
    AU: { currency: 'AUD', symbol: 'A$', multiplier: 1.5, monthly: 14.99, quarterly: 40.47, yearly: 104.93 },
    NZ: { currency: 'NZD', symbol: 'NZ$', multiplier: 1.6, monthly: 15.99, quarterly: 43.17, yearly: 111.93 }
  };

  // Système de traductions complet
  const translations = {
    fr: {
      // Header & Navigation
      appName: 'Math4Child',
      tagline: 'Apprendre les maths en s\'amusant !',
      home: 'Accueil',
      game: 'Jeu',
      levels: 'Niveaux',
      subscription: 'Abonnement',
      back: 'Retour',
      
      // Hero Section
      heroTitle: 'Math4Child',
      heroSubtitle: 'L\'application éducative n°1 pour apprendre les mathématiques',
      heroDescription: 'Domaine officiel: www.math4child.com - Application hybride disponible sur Web, Android et iOS',
      startFree: 'Essai gratuit (7 jours)',
      viewPlans: 'Voir les abonnements',
      freeWeekTrial: 'Essai gratuit d\'une semaine',
      questionsRemaining: 'questions restantes',
      
      // Levels
      chooseLevel: 'Choisissez votre niveau',
      levelProgression: 'Progression des niveaux',
      needCorrectAnswers: 'bonnes réponses requises pour débloquer',
      currentProgress: 'Progression actuelle',
      locked: 'Verrouillé',
      unlocked: 'Débloqué',
      
      // Level Names
      beginner: 'Débutant (4-6 ans)',
      elementary: 'Élémentaire (6-8 ans)', 
      intermediate: 'Intermédiaire (8-10 ans)',
      advanced: 'Avancé (10-12 ans)',
      expert: 'Expert (12+ ans)',
      
      // Operations
      chooseOperation: 'Choisissez votre opération',
      addition: 'Addition (+)',
      subtraction: 'Soustraction (-)',
      multiplication: 'Multiplication (×)',
      division: 'Division (÷)',
      mixed: 'Exercices mixtes',
      
      // Game
      question: 'Question',
      yourAnswer: 'Votre réponse',
      validate: 'Valider',
      next: 'Suivant',
      correct: 'Correct !',
      incorrect: 'Incorrect',
      theAnswerWas: 'La réponse était',
      score: 'Score',
      streak: 'Série',
      lives: 'Vies',
      gameOver: 'Jeu terminé !',
      finalScore: 'Score final',
      playAgain: 'Rejouer',
      
      // Subscription
      subscriptionTitle: 'Choisissez votre abonnement',
      subscriptionSubtitle: 'Débloquez toutes les fonctionnalités sur une plateforme',
      multiDeviceDiscount: 'Réductions multi-plateformes disponibles',
      freeTrialTitle: 'Essai gratuit',
      monthlyTitle: 'Mensuel',
      quarterlyTitle: 'Trimestriel',
      yearlyTitle: 'Annuel',
      
      // Pricing Features
      freeTrialFeatures: 'Essai d\'une semaine - 50 questions',
      monthlyFeatures: 'Accès complet - Une plateforme',
      quarterlyFeatures: 'Accès complet - 10% de réduction',
      yearlyFeatures: 'Accès complet - 30% de réduction',
      multiDeviceOffer: 'Deuxième plateforme à -50%, troisième à -75%',
      
      choosePlan: 'Choisir ce plan',
      popular: 'Populaire',
      bestValue: 'Meilleur rapport qualité-prix',
      recommended: 'Recommandé',
      
      // Platforms
      webVersion: 'Version Web',
      androidVersion: 'Version Android',
      iosVersion: 'Version iOS',
      
      // Features
      features: 'Fonctionnalités',
      allLevels: 'Tous les 5 niveaux',
      allOperations: 'Toutes les opérations',
      unlimitedQuestions: 'Questions illimitées',
      progressTracking: 'Suivi des progrès',
      multipleProfiles: 'profils multiples',
      prioritySupport: 'Support prioritaire',
      
      // Countries & Currencies
      localPricing: 'Prix adaptés au pouvoir d\'achat local',
      paymentMethods: 'Tous types de paiements acceptés',
      
      // Messages
      subscriptionRequired: 'Abonnement requis',
      trialExpired: 'Essai gratuit expiré',
      upgradeNow: 'Mettre à niveau maintenant',
      availableLanguages: 'langues disponibles',
      scrollToExplore: 'Faites défiler pour explorer'
    },
    
    en: {
      // Header & Navigation
      appName: 'Math4Child',
      tagline: 'Learn math while having fun!',
      home: 'Home',
      game: 'Game',
      levels: 'Levels',
      subscription: 'Subscription',
      back: 'Back',
      
      // Hero Section
      heroTitle: 'Math4Child',
      heroSubtitle: 'The #1 educational app for learning mathematics',
      heroDescription: 'Official domain: www.math4child.com - Hybrid app available on Web, Android and iOS',
      startFree: 'Free trial (7 days)',
      viewPlans: 'View subscriptions',
      freeWeekTrial: 'One week free trial',
      questionsRemaining: 'questions remaining',
      
      // Levels
      chooseLevel: 'Choose your level',
      levelProgression: 'Level progression',
      needCorrectAnswers: 'correct answers required to unlock',
      currentProgress: 'Current progress',
      locked: 'Locked',
      unlocked: 'Unlocked',
      
      // Level Names
      beginner: 'Beginner (4-6 years)',
      elementary: 'Elementary (6-8 years)',
      intermediate: 'Intermediate (8-10 years)',
      advanced: 'Advanced (10-12 years)',
      expert: 'Expert (12+ years)',
      
      // Operations
      chooseOperation: 'Choose your operation',
      addition: 'Addition (+)',
      subtraction: 'Subtraction (-)',
      multiplication: 'Multiplication (×)',
      division: 'Division (÷)',
      mixed: 'Mixed exercises',
      
      // Game
      question: 'Question',
      yourAnswer: 'Your answer',
      validate: 'Validate',
      next: 'Next',
      correct: 'Correct!',
      incorrect: 'Incorrect',
      theAnswerWas: 'The answer was',
      score: 'Score',
      streak: 'Streak',
      lives: 'Lives',
      gameOver: 'Game over!',
      finalScore: 'Final score',
      playAgain: 'Play again',
      
      // Subscription
      subscriptionTitle: 'Choose your subscription',
      subscriptionSubtitle: 'Unlock all features on one platform',
      multiDeviceDiscount: 'Multi-platform discounts available',
      freeTrialTitle: 'Free trial',
      monthlyTitle: 'Monthly',
      quarterlyTitle: 'Quarterly',
      yearlyTitle: 'Yearly',
      
      // Pricing Features
      freeTrialFeatures: 'One week trial - 50 questions',
      monthlyFeatures: 'Full access - One platform',
      quarterlyFeatures: 'Full access - 10% discount',
      yearlyFeatures: 'Full access - 30% discount',
      multiDeviceOffer: 'Second platform -50%, third -75%',
      
      choosePlan: 'Choose this plan',
      popular: 'Popular',
      bestValue: 'Best value',
      recommended: 'Recommended',
      
      // Platforms
      webVersion: 'Web Version',
      androidVersion: 'Android Version',
      iosVersion: 'iOS Version',
      
      // Features
      features: 'Features',
      allLevels: 'All 5 levels',
      allOperations: 'All operations',
      unlimitedQuestions: 'Unlimited questions',
      progressTracking: 'Progress tracking',
      multipleProfiles: 'multiple profiles',
      prioritySupport: 'Priority support',
      
      // Countries & Currencies
      localPricing: 'Pricing adapted to local purchasing power',
      paymentMethods: 'All payment types accepted',
      
      // Messages
      subscriptionRequired: 'Subscription required',
      trialExpired: 'Free trial expired',
      upgradeNow: 'Upgrade now',
      availableLanguages: 'available languages',
      scrollToExplore: 'Scroll to explore'
    },

    es: {
      appName: 'Math4Child',
      tagline: '¡Aprende matemáticas divirtiéndote!',
      home: 'Inicio',
      game: 'Juego',
      levels: 'Niveles',
      subscription: 'Suscripción',
      back: 'Atrás',
      heroTitle: 'Math4Child',
      heroSubtitle: 'La app educativa #1 para aprender matemáticas',
      heroDescription: 'Dominio oficial: www.math4child.com - App híbrida disponible en Web, Android e iOS',
      startFree: 'Prueba gratuita (7 días)',
      viewPlans: 'Ver suscripciones',
      chooseLevel: 'Elige tu nivel',
      beginner: 'Principiante (4-6 años)',
      elementary: 'Elemental (6-8 años)',
      intermediate: 'Intermedio (8-10 años)',
      advanced: 'Avanzado (10-12 años)',
      expert: 'Experto (12+ años)',
      chooseOperation: 'Elige tu operación',
      addition: 'Suma (+)',
      subtraction: 'Resta (-)',
      multiplication: 'Multiplicación (×)',
      division: 'División (÷)',
      mixed: 'Ejercicios mixtos',
      validate: 'Validar',
      correct: '¡Correcto!',
      incorrect: 'Incorrecto',
      score: 'Puntuación',
      choosePlan: 'Elegir este plan',
      monthlyTitle: 'Mensual',
      quarterlyTitle: 'Trimestral',
      yearlyTitle: 'Anual',
      availableLanguages: 'idiomas disponibles',
      scrollToExplore: 'Desplázate para explorar'
    },

    ar: {
      appName: 'Math4Child',
      tagline: 'تعلم الرياضيات بمتعة!',
      home: 'الرئيسية',
      game: 'لعبة',
      levels: 'المستويات',
      subscription: 'الاشتراك',
      back: 'رجوع',
      heroTitle: 'Math4Child',
      heroSubtitle: 'التطبيق التعليمي رقم 1 لتعلم الرياضيات',
      heroDescription: 'النطاق الرسمي: www.math4child.com - تطبيق مختلط متاح على الويب وأندرويد وiOS',
      startFree: 'تجربة مجانية (7 أيام)',
      viewPlans: 'عرض الاشتراكات',
      chooseLevel: 'اختر مستواك',
      beginner: 'مبتدئ (4-6 سنوات)',
      elementary: 'ابتدائي (6-8 سنوات)',
      intermediate: 'متوسط (8-10 سنوات)',
      advanced: 'متقدم (10-12 سنة)',
      expert: 'خبير (12+ سنة)',
      chooseOperation: 'اختر العملية',
      addition: 'جمع (+)',
      subtraction: 'طرح (-)',
      multiplication: 'ضرب (×)',
      division: 'قسمة (÷)',
      mixed: 'تمارين مختلطة',
      validate: 'تأكيد',
      correct: 'صحيح!',
      incorrect: 'خطأ',
      score: 'النقاط',
      choosePlan: 'اختر هذه الخطة',
      monthlyTitle: 'شهري',
      quarterlyTitle: 'ربع سنوي',
      yearlyTitle: 'سنوي',
      availableLanguages: 'اللغات المتاحة',
      scrollToExplore: 'مرر للاستكشاف'
    },

    zh: {
      appName: 'Math4Child',
      tagline: '寓教于乐学数学！',
      home: '首页',
      game: '游戏',
      levels: '级别',
      subscription: '订阅',
      back: '返回',
      heroTitle: 'Math4Child',
      heroSubtitle: '排名第一的数学学习教育应用',
      heroDescription: '官方域名：www.math4child.com - 混合应用，支持网页版、安卓版和iOS版',
      startFree: '免费试用（7天）',
      viewPlans: '查看订阅',
      chooseLevel: '选择你的级别',
      beginner: '初学者（4-6岁）',
      elementary: '小学级（6-8岁）',
      intermediate: '中级（8-10岁）',
      advanced: '高级（10-12岁）',
      expert: '专家级（12+岁）',
      chooseOperation: '选择运算',
      addition: '加法 (+)',
      subtraction: '减法 (-)',
      multiplication: '乘法 (×)',
      division: '除法 (÷)',
      mixed: '综合练习',
      validate: '确认',
      correct: '正确！',
      incorrect: '错误',
      score: '得分',
      choosePlan: '选择此计划',
      monthlyTitle: '月订阅',
      quarterlyTitle: '季订阅',
      yearlyTitle: '年订阅',
      availableLanguages: '可用语言',
      scrollToExplore: '滚动探索'
    }
  };

  // Fonction de traduction
  const t = (key) => {
    const lang = translations[currentLanguage] || translations.fr;
    return lang[key] || translations.fr[key] || key;
  };

  // Configuration des niveaux avec progression
  const levels = [
    { 
      id: 'beginner', 
      name: t('beginner'), 
      color: 'bg-green-500', 
      range: [1, 10],
      requiredAnswers: 100,
      description: 'Nombres 1-10'
    },
    { 
      id: 'elementary', 
      name: t('elementary'), 
      color: 'bg-blue-500', 
      range: [1, 50],
      requiredAnswers: 100,
      description: 'Nombres 1-50'
    },
    { 
      id: 'intermediate', 
      name: t('intermediate'), 
      color: 'bg-purple-500', 
      range: [1, 100],
      requiredAnswers: 100,
      description: 'Nombres 1-100'
    },
    { 
      id: 'advanced', 
      name: t('advanced'), 
      color: 'bg-red-500', 
      range: [1, 500],
      requiredAnswers: 100,
      description: 'Nombres 1-500'
    },
    { 
      id: 'expert', 
      name: t('expert'), 
      color: 'bg-gray-800', 
      range: [1, 1000],
      requiredAnswers: 100,
      description: 'Nombres 1-1000'
    }
  ];

  // Configuration des opérations
  const operations = [
    { id: 'addition', name: t('addition'), symbol: '+', color: 'bg-green-500' },
    { id: 'subtraction', name: t('subtraction'), symbol: '-', color: 'bg-blue-500' },
    { id: 'multiplication', name: t('multiplication'), symbol: '×', color: 'bg-purple-500' },
    { id: 'division', name: t('division'), symbol: '÷', color: 'bg-red-500' },
    { id: 'mixed', name: t('mixed'), symbol: '?', color: 'bg-gray-600' }
  ];

  // Configuration des abonnements
  const getSubscriptionPlans = () => {
    const country = countryPricing[currentCountry] || countryPricing.US;
    
    return [
      {
        id: 'free-trial',
        title: t('freeTrialTitle'),
        price: `${t('freeWeekTrial')}`,
        duration: '7 jours',
        features: [
          '50 questions totales',
          'Tous les niveaux',
          'Toutes les opérations',
          'Une seule plateforme'
        ],
        buttonText: t('choosePlan'),
        popular: false,
        platforms: ['web', 'android', 'ios']
      },
      {
        id: 'monthly',
        title: t('monthlyTitle'),
        price: `${country.symbol}${country.monthly}`,
        duration: '/mois',
        features: [
          t('unlimitedQuestions'),
          t('allLevels'),
          t('allOperations'),
          '1 plateforme incluse',
          `10 ${t('multipleProfiles')}`,
          t('progressTracking')
        ],
        buttonText: t('choosePlan'),
        popular: true,
        platforms: ['web', 'android', 'ios']
      },
      {
        id: 'quarterly',
        title: t('quarterlyTitle'),
        price: `${country.symbol}${country.quarterly}`,
        originalPrice: `${country.symbol}${(country.monthly * 3).toFixed(2)}`,
        duration: '/3 mois',
        discount: '10%',
        features: [
          t('unlimitedQuestions'),
          t('allLevels'),
          t('allOperations'),
          '1 plateforme incluse',
          `15 ${t('multipleProfiles')}`,
          t('progressTracking'),
          t('prioritySupport')
        ],
        buttonText: t('choosePlan'),
        popular: false,
        platforms: ['web', 'android', 'ios']
      },
      {
        id: 'yearly',
        title: t('yearlyTitle'),
        price: `${country.symbol}${country.yearly}`,
        originalPrice: `${country.symbol}${(country.monthly * 12).toFixed(2)}`,
        duration: '/an',
        discount: '30%',
        features: [
          t('unlimitedQuestions'),
          t('allLevels'),
          t('allOperations'),
          '1 plateforme incluse',
          `25 ${t('multipleProfiles')}`,
          t('progressTracking'),
          t('prioritySupport'),
          'Accès beta features'
        ],
        buttonText: t('choosePlan'),
        popular: false,
        bestValue: true,
        platforms: ['web', 'android', 'ios']
      }
    ];
  };

  // Générateur d'opérations mathématiques
  const generateQuestion = () => {
    const level = levels.find(l => l.id === selectedLevel);
    const operation = operations.find(op => op.id === selectedOperation);
    
    if (!level || !operation) return null;

    const [min, max] = level.range;
    let num1, num2, answer, questionText;

    // Adaptation de la difficulté selon le niveau
    const maxNum = Math.min(max, level.id === 'beginner' ? 10 : level.id === 'elementary' ? 20 : max);

    switch (operation.id) {
      case 'addition':
        num1 = Math.floor(Math.random() * maxNum) + min;
        num2 = Math.floor(Math.random() * maxNum) + min;
        answer = num1 + num2;
        questionText = `${num1} + ${num2} = ?`;
        break;
        
      case 'subtraction':
        num1 = Math.floor(Math.random() * maxNum) + min;
        num2 = Math.floor(Math.random() * num1) + 1;
        answer = num1 - num2;
        questionText = `${num1} - ${num2} = ?`;
        break;
        
      case 'multiplication':
        const multMax = level.id === 'beginner' ? 5 : level.id === 'elementary' ? 10 : 12;
        num1 = Math.floor(Math.random() * multMax) + 1;
        num2 = Math.floor(Math.random() * multMax) + 1;
        answer = num1 * num2;
        questionText = `${num1} × ${num2} = ?`;
        break;
        
      case 'division':
        const divMax = level.id === 'beginner' ? 5 : level.id === 'elementary' ? 10 : 12;
        answer = Math.floor(Math.random() * divMax) + 1;
        num2 = Math.floor(Math.random() * divMax) + 1;
        num1 = answer * num2;
        questionText = `${num1} ÷ ${num2} = ?`;
        break;
        
      case 'mixed':
        const ops = ['addition', 'subtraction'];
        if (level.id !== 'beginner') ops.push('multiplication');
        if (level.id === 'advanced' || level.id === 'expert') ops.push('division');
        const randomOp = ops[Math.floor(Math.random() * ops.length)];
        return generateQuestionForOperation(randomOp, level);
        
      default:
        return null;
    }

    return { questionText, answer, num1, num2, operation: operation.id };
  };

  // Fonction helper pour mixed operations
  const generateQuestionForOperation = (opType, level) => {
    const tempOperation = operations.find(op => op.id === opType);
    const tempSelectedOperation = selectedOperation;
    setSelectedOperation(opType);
    const question = generateQuestion();
    setSelectedOperation(tempSelectedOperation);
    return question;
  };

  // Validation et progression
  const validateAnswer = () => {
    const userNum = parseInt(userAnswer);
    const correct = userNum === currentQuestion.answer;
    
    setIsCorrect(correct);
    
    if (correct) {
      setScore(score + 10);
      setStreak(streak + 1);
      setFeedback(t('correct'));
      
      // Mise à jour de la progression du niveau
      const newCorrectAnswers = { ...correctAnswers };
      newCorrectAnswers[selectedLevel]++;
      setCorrectAnswers(newCorrectAnswers);
      
      // Déblocage du niveau suivant si 100 bonnes réponses atteintes
      if (newCorrectAnswers[selectedLevel] >= 100) {
        const currentLevelIndex = levels.findIndex(l => l.id === selectedLevel);
        if (currentLevelIndex < levels.length - 1) {
          const nextLevel = levels[currentLevelIndex + 1];
          if (!unlockedLevels.includes(nextLevel.id)) {
            setUnlockedLevels([...unlockedLevels, nextLevel.id]);
            setFeedback(`${t('correct')} 🎉 Niveau ${nextLevel.name} débloqué !`);
          }
        }
      }
    } else {
      setLives(lives - 1);
      setStreak(0);
      setFeedback(`${t('incorrect')} ${t('theAnswerWas')} ${currentQuestion.answer}`);
    }
    
    setQuestionsAnswered(questionsAnswered + 1);
    
    // Décrémenter les questions gratuites
    if (freeQuestionsLeft > 0) {
      setFreeQuestionsLeft(freeQuestionsLeft - 1);
    }
  };

  // Question suivante
  const nextQuestion = () => {
    // Vérifier les limites
    if (freeQuestionsLeft <= 0 && userSubscriptions.length === 0) {
      alert(t('subscriptionRequired'));
      setCurrentView('subscription');
      return;
    }
    
    if (lives <= 0) {
      alert(`${t('gameOver')} ${t('finalScore')}: ${score}`);
      setCurrentView('levels');
      return;
    }
    
    const question = generateQuestion();
    if (question) {
      setCurrentQuestion(question);
      setUserAnswer('');
      setFeedback('');
      setIsCorrect(null);
    }
  };

  // Démarrer le jeu
  const startGame = () => {
    if (freeQuestionsLeft <= 0 && userSubscriptions.length === 0) {
      alert(t('subscriptionRequired'));
      setCurrentView('subscription');
      return;
    }
    
    const question = generateQuestion();
    if (question) {
      setCurrentQuestion(question);
      setCurrentView('game');
      setQuestionsAnswered(0);
      setScore(0);
      setStreak(0);
      setLives(3);
      setFeedback('');
      setIsCorrect(null);
      setUserAnswer('');
    }
  };

  // Gestion du changement de langue
  const handleLanguageChange = (langCode) => {
    setCurrentLanguage(langCode);
    setShowLanguageDropdown(false);
    
    // Déterminer le pays basé sur la langue
    const language = worldLanguages.find(l => l.code === langCode);
    if (language && language.countries.length > 0) {
      setCurrentCountry(language.countries[0]);
    }
    
    if (typeof window !== 'undefined') {
      localStorage.setItem('math4child-language', langCode);
      localStorage.setItem('math4child-country', currentCountry);
    }
    
    // Appliquer direction RTL pour les langues qui le nécessitent
    const rtlLanguages = ['ar', 'fa', 'ur'];
    if (typeof document !== 'undefined') {
      document.documentElement.dir = rtlLanguages.includes(langCode) ? 'rtl' : 'ltr';
    }
  };

  // Gestion des achats d'abonnement
  const handleSubscriptionPurchase = (planId, platform) => {
    // Simulation de l'achat - ici on intégrerait Stripe/Payment Gateway
    alert(`Achat simulé: ${planId} pour ${platform}`);
    
    // Logique de réduction multi-plateformes
    let discount = 0;
    if (userSubscriptions.length === 1) discount = 50; // -50% pour la 2ème plateforme
    if (userSubscriptions.length === 2) discount = 75; // -75% pour la 3ème plateforme
    
    setUserSubscriptions([...userSubscriptions, platform]);
    setFreeQuestionsLeft(999999); // Questions illimitées
  };

  // Initialisation
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const savedLang = localStorage.getItem('math4child-language') || 'fr';
      const savedCountry = localStorage.getItem('math4child-country') || 'FR';
      setCurrentLanguage(savedLang);
      setCurrentCountry(savedCountry);
      
      const rtlLanguages = ['ar', 'fa', 'ur'];
      document.documentElement.dir = rtlLanguages.includes(savedLang) ? 'rtl' : 'ltr';
    }
  }, []);

  // Rendu conditionnel des vues
  const renderCurrentView = () => {
    switch (currentView) {
      case 'levels':
        return (
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-20">
            <div className="max-w-6xl mx-auto px-4">
              <button 
                onClick={() => setCurrentView('home')}
                className="mb-8 flex items-center text-blue-600 hover:text-blue-800 font-medium"
              >
                <ArrowLeft className="w-5 h-5 mr-2" />
                {t('back')}
              </button>
              
              <div className="text-center mb-12">
                <h1 className="text-4xl font-bold text-gray-900 mb-4">{t('chooseLevel')}</h1>
                <p className="text-lg text-gray-600">{t('levelProgression')}</p>
                <div className="mt-4 text-sm text-blue-600">
                  {freeQuestionsLeft > 0 ? `${freeQuestionsLeft} ${t('questionsRemaining')}` : t('subscriptionRequired')}
                </div>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                {levels.map((level, index) => {
                  const isUnlocked = unlockedLevels.includes(level.id);
                  const progress = correctAnswers[level.id] || 0;
                  
                  return (
                    <div 
                      key={level.id}
                      onClick={() => {
                        if (isUnlocked) {
                          setSelectedLevel(level.id);
                          setCurrentView('operations');
                        }
                      }}
                      className={`cursor-pointer group bg-white rounded-2xl p-6 shadow-lg transition-all duration-300 border-2 ${
                        isUnlocked 
                          ? 'hover:shadow-2xl transform hover:-translate-y-2 border-gray-100 hover:border-blue-300' 
                          : 'opacity-60 cursor-not-allowed border-gray-200'
                      }`}
                    >
                      <div className={`w-16 h-16 ${isUnlocked ? level.color : 'bg-gray-400'} rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg ${isUnlocked ? 'group-hover:scale-110' : ''} transition-transform relative`}>
                        {isUnlocked ? (
                          <span className="text-white font-bold text-xl">{index + 1}</span>
                        ) : (
                          <Lock className="w-8 h-8 text-white" />
                        )}
                      </div>
                      
                      <h3 className="text-xl font-bold text-center text-gray-900 mb-2">{level.name}</h3>
                      <p className="text-center text-gray-600 text-sm mb-4">{level.description}</p>
                      
                      {/* Barre de progression */}
                      <div className="mb-4">
                        <div className="flex justify-between text-xs text-gray-500 mb-1">
                          <span>{progress}/100</span>
                          <span>{isUnlocked ? t('unlocked') : t('locked')}</span>
                        </div>
                        <div className="w-full bg-gray-200 rounded-full h-2">
                          <div 
                            className={`${level.color} h-2 rounded-full transition-all duration-500`}
                            style={{ width: `${Math.min((progress / 100) * 100, 100)}%` }}
                          ></div>
                        </div>
                      </div>
                      
                      {!isUnlocked && (
                        <p className="text-center text-xs text-gray-500">
                          {100 - (correctAnswers[levels[index - 1]?.id] || 0)} {t('needCorrectAnswers')}
                        </p>
                      )}
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        );

      case 'operations':
        return (
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-20">
            <div className="max-w-4xl mx-auto px-4">
              <button 
                onClick={() => setCurrentView('levels')}
                className="mb-8 flex items-center text-blue-600 hover:text-blue-800 font-medium"
              >
                <ArrowLeft className="w-5 h-5 mr-2" />
                {t('back')}
              </button>
              
              <h1 className="text-4xl font-bold text-center mb-12 text-gray-900">
                {t('chooseOperation')}
              </h1>
              
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {operations.map((operation) => (
                  <div 
                    key={operation.id}
                    onClick={() => {
                      setSelectedOperation(operation.id);
                      startGame();
                    }}
                    className="cursor-pointer group bg-white rounded-2xl p-6 shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 border border-gray-100"
                  >
                    <div className={`w-16 h-16 ${operation.color} rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg group-hover:scale-110 transition-transform`}>
                      <span className="text-white font-bold text-2xl">{operation.symbol}</span>
                    </div>
                    <h3 className="text-xl font-bold text-center text-gray-900">{operation.name}</h3>
                  </div>
                ))}
              </div>
            </div>
          </div>
        );

      case 'game':
        return (
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-20">
            <div className="max-w-2xl mx-auto px-4">
              <div className="bg-white rounded-2xl p-8 shadow-xl">
                {/* Stats du jeu */}
                <div className="flex justify-between items-center mb-8">
                  <div className="text-center">
                    <div className="text-2xl font-bold text-blue-600">{score}</div>
                    <div className="text-sm text-gray-600">{t('score')}</div>
                  </div>
                  <div className="text-center">
                    <div className="text-2xl font-bold text-green-600">{streak}</div>
                    <div className="text-sm text-gray-600">{t('streak')}</div>
                  </div>
                  <div className="text-center">
                    <div className="text-2xl font-bold text-red-600">{lives}</div>
                    <div className="text-sm text-gray-600">{t('lives')}</div>
                  </div>
                  <div className="text-center">
                    <div className="text-lg font-bold text-purple-600">{correctAnswers[selectedLevel]}/100</div>
                    <div className="text-sm text-gray-600">Progression</div>
                  </div>
                </div>

                {/* Question */}
                <div className="text-center mb-8">
                  <h2 className="text-6xl font-bold text-gray-900 mb-6">
                    {currentQuestion?.questionText}
                  </h2>
                  
                  <input
                    type="number"
                    value={userAnswer}
                    onChange={(e) => setUserAnswer(e.target.value)}
                    placeholder={t('yourAnswer')}
                    className="text-3xl text-center border-2 border-gray-300 rounded-xl px-6 py-4 w-64 focus:border-blue-500 focus:outline-none"
                    onKeyPress={(e) => {
                      if (e.key === 'Enter' && userAnswer && !isCorrect) {
                        validateAnswer();
                      }
                    }}
                  />
                </div>

                {/* Feedback */}
                {feedback && (
                  <div className={`text-center mb-6 p-4 rounded-xl ${
                    isCorrect 
                      ? 'bg-green-100 text-green-800' 
                      : 'bg-red-100 text-red-800'
                  }`}>
                    <div className="text-xl font-bold">{feedback}</div>
                  </div>
                )}

                {/* Boutons */}
                <div className="flex justify-center space-x-4">
                  {!feedback ? (
                    <button
                      onClick={validateAnswer}
                      disabled={!userAnswer}
                      className="bg-blue-600 text-white px-8 py-4 rounded-xl font-bold text-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      {t('validate')}
                    </button>
                  ) : (
                    <button
                      onClick={nextQuestion}
                      className="bg-green-600 text-white px-8 py-4 rounded-xl font-bold text-lg hover:bg-green-700"
                    >
                      {t('next')}
                    </button>
                  )}
                  
                  <button
                    onClick={() => setCurrentView('operations')}
                    className="bg-gray-600 text-white px-8 py-4 rounded-xl font-bold text-lg hover:bg-gray-700"
                  >
                    {t('back')}
                  </button>
                </div>

                {/* Indicateur questions restantes */}
                {freeQuestionsLeft <= 50 && (
                  <div className="text-center mt-6 p-3 bg-yellow-100 rounded-lg">
                    <span className="text-yellow-800 font-medium">
                      {freeQuestionsLeft} {t('questionsRemaining')}
                    </span>
                  </div>
                )}
              </div>
            </div>
          </div>
        );

      case 'subscription':
        return (
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-20">
            <div className="max-w-7xl mx-auto px-4">
              <button 
                onClick={() => setCurrentView('home')}
                className="mb-8 flex items-center text-blue-600 hover:text-blue-800 font-medium"
              >
                <ArrowLeft className="w-5 h-5 mr-2" />
                {t('back')}
              </button>
              
              <div className="text-center mb-16">
                <h1 className="text-4xl font-bold text-gray-900 mb-4">{t('subscriptionTitle')}</h1>
                <p className="text-xl text-gray-600 mb-4">{t('subscriptionSubtitle')}</p>
                <p className="text-lg text-blue-600">{t('multiDeviceDiscount')}</p>
                <div className="text-sm text-gray-500 mt-2">
                  {t('localPricing')} - {t('paymentMethods')}
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                {getSubscriptionPlans().map((plan) => (
                  <div 
                    key={plan.id}
                    className={`relative bg-white rounded-3xl p-6 shadow-xl transition-all duration-300 transform hover:scale-105 border-2 ${
                      plan.popular ? 'ring-4 ring-blue-200 ring-opacity-50 border-blue-300' : 
                      plan.bestValue ? 'ring-4 ring-green-200 ring-opacity-50 border-green-300' : 
                      'border-gray-200'
                    }`}
                  >
                    {plan.popular && (
                      <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                        <div className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-2 rounded-full text-sm font-bold shadow-lg">
                          ⭐ {t('popular')}
                        </div>
                      </div>
                    )}
                    
                    {plan.bestValue && (
                      <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                        <div className="bg-gradient-to-r from-green-600 to-emerald-600 text-white px-4 py-2 rounded-full text-sm font-bold shadow-lg">
                          💎 {t('bestValue')}
                        </div>
                      </div>
                    )}
                    
                    <div className="text-center mb-6">
                      <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.title}</h3>
                      <div className="mb-2">
                        <span className="text-3xl font-bold text-blue-600">{plan.price}</span>
                        <span className="text-gray-600 text-sm">{plan.duration}</span>
                      </div>
                      
                      {plan.originalPrice && (
                        <div className="text-center">
                          <span className="text-sm text-gray-500 line-through">{plan.originalPrice}</span>
                          <span className="text-green-600 text-sm font-bold ml-2">-{plan.discount}</span>
                        </div>
                      )}
                    </div>
                    
                    <ul className="space-y-3 mb-8">
                      {plan.features.map((feature, index) => (
                        <li key={index} className="flex items-start">
                          <Check className="w-5 h-5 text-green-500 mr-3 mt-0.5 flex-shrink-0" />
                          <span className="text-gray-700 text-sm">{feature}</span>
                        </li>
                      ))}
                    </ul>
                    
                    <button 
                      onClick={() => {
                        alert(`Sélection du plan: ${plan.title}`);
                      }}
                      className={`w-full py-3 rounded-xl font-bold text-lg transition-all duration-300 ${
                        plan.popular || plan.bestValue
                          ? 'bg-gradient-to-r from-blue-600 to-purple-600 text-white shadow-lg hover:shadow-xl transform hover:scale-105' 
                          : 'bg-gray-100 text-gray-900 hover:bg-gray-200'
                      }`}
                    >
                      {plan.buttonText}
                    </button>
                  </div>
                ))}
              </div>
            </div>
          </div>
        );

      default: // home
        return (
          <div>
            {/* Hero Section */}
            <section className="py-20 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
              <div className="max-w-7xl mx-auto text-center">
                <div className="inline-flex items-center px-4 py-2 rounded-full bg-gradient-to-r from-blue-100 to-purple-100 text-blue-800 text-sm font-semibold mb-8 shadow-sm">
                  <Globe className="w-4 h-4 mr-2" />
                  {worldLanguages.length}+ langues supportées dans le monde entier
                </div>

                <h1 className="text-5xl md:text-7xl font-bold mb-8 leading-tight">
                  <span className="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent">
                    {t('heroTitle')}
                  </span>
                </h1>
                
                <p className="text-xl md:text-2xl text-gray-600 mb-8 max-w-4xl mx-auto">
                  {t('heroSubtitle')}
                </p>
                
                <p className="text-lg text-gray-500 mb-12 max-w-3xl mx-auto">
                  {t('heroDescription')}
                </p>
                
                {/* Compteur questions gratuites */}
                <div className="bg-gradient-to-r from-green-100 to-blue-100 rounded-2xl p-6 mb-12 max-w-md mx-auto">
                  <h3 className="text-lg font-bold text-gray-900 mb-2">{t('freeWeekTrial')}</h3>
                  <div className="text-3xl font-bold text-green-600 mb-2">{freeQuestionsLeft}/50</div>
                  <p className="text-sm text-gray-600">{t('questionsRemaining')}</p>
                  <div className="w-full bg-gray-200 rounded-full h-2 mt-3">
                    <div 
                      className="bg-gradient-to-r from-green-400 to-blue-500 h-2 rounded-full transition-all duration-500"
                      style={{ width: `${(freeQuestionsLeft / 50) * 100}%` }}
                    ></div>
                  </div>
                </div>
                
                <div className="flex flex-col sm:flex-row gap-6 justify-center items-center mb-16">
                  <button 
                    onClick={() => setCurrentView('levels')}
                    className="group bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-xl font-bold text-lg shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center"
                  >
                    <Play className="w-6 h-6 mr-3" />
                    {t('startFree')}
                    <ArrowRight className="w-5 h-5 ml-2 group-hover:translate-x-1 transition-transform" />
                  </button>
                  
                  <button 
                    onClick={() => setCurrentView('subscription')}
                    className="group bg-white text-gray-800 px-8 py-4 rounded-xl font-bold text-lg border-2 border-gray-200 hover:border-blue-300 shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 flex items-center"
                  >
                    <Crown className="w-6 h-6 mr-3 text-blue-600" />
                    {t('viewPlans')}
                  </button>
                </div>

                {/* Progression des niveaux preview */}
                <div className="bg-white rounded-2xl p-8 shadow-xl max-w-4xl mx-auto">
                  <h3 className="text-2xl font-bold text-gray-900 mb-6">{t('levelProgression')}</h3>
                  <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
                    {levels.map((level, index) => {
                      const isUnlocked = unlockedLevels.includes(level.id);
                      const progress = correctAnswers[level.id] || 0;
                      
                      return (
                        <div key={level.id} className="text-center">
                          <div className={`w-12 h-12 ${isUnlocked ? level.color : 'bg-gray-300'} rounded-full flex items-center justify-center mb-2 mx-auto`}>
                            {isUnlocked ? (
                              <span className="text-white font-bold">{index + 1}</span>
                            ) : (
                              <Lock className="w-6 h-6 text-white" />
                            )}
                          </div>
                          <div className="text-sm font-medium text-gray-900 mb-1">{level.name.split(' ')[0]}</div>
                          <div className="text-xs text-gray-500">{progress}/100</div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            </section>
          </div>
        );
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {/* Header fonctionnel avec langues mondiales */}
      <header className="bg-white/90 backdrop-blur-sm shadow-lg sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-20">
            <div 
              onClick={() => setCurrentView('home')}
              className="flex items-center space-x-4 cursor-pointer"
            >
              <div className="w-12 h-12 bg-gradient-to-br from-orange-400 via-red-500 to-pink-500 rounded-xl flex items-center justify-center shadow-lg">
                <span className="text-white text-xl font-bold">M4C</span>
              </div>
              <div>
                <span className="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                  {t('appName')}
                </span>
                <div className="text-xs text-gray-500 font-medium">www.math4child.com</div>
              </div>
            </div>
            
            <div className="flex items-center space-x-6">
              {/* Navigation */}
              <nav className="hidden md:flex space-x-8">
                <button 
                  onClick={() => setCurrentView('home')}
                  className="text-gray-700 hover:text-blue-600 font-medium transition-colors"
                >
                  {t('home')}
                </button>
                <button 
                  onClick={() => setCurrentView('levels')}
                  className="text-gray-700 hover:text-blue-600 font-medium transition-colors"
                >
                  {t('game')}
                </button>
                <button 
                  onClick={() => setCurrentView('subscription')}
                  className="text-gray-700 hover:text-blue-600 font-medium transition-colors"
                >
                  {t('subscription')}
                </button>
              </nav>
              
              {/* Sélecteur de langue mondial */}
              <div className="relative">
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  className="flex items-center space-x-2 px-4 py-2 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 transition-all shadow-sm"
                >
                  <span className="text-xl">{worldLanguages.find(l => l.code === currentLanguage)?.flag}</span>
                  <span className="hidden sm:inline font-medium">{worldLanguages.find(l => l.code === currentLanguage)?.name}</span>
                  <ChevronDown className="w-4 h-4 text-gray-500" />
                </button>
                
                {showLanguageDropdown && (
                  <div className="absolute right-0 mt-2 w-80 bg-white rounded-xl shadow-2xl border border-gray-100 z-50">
                    <div className="p-3 border-b border-gray-100 bg-gray-50 rounded-t-xl">
                      <div className="text-xs text-gray-600 text-center font-medium">
                        {worldLanguages.length} {t('availableLanguages') || 'langues disponibles'}
                      </div>
                    </div>
                    
                    <div className="max-h-80 overflow-y-auto">
                      <div className="p-2">
                        {worldLanguages.map((lang) => (
                          <button
                            key={lang.code}
                            onClick={() => handleLanguageChange(lang.code)}
                            className={`w-full flex items-center space-x-3 px-3 py-2 hover:bg-blue-50 transition-colors rounded-lg ${
                              currentLanguage === lang.code ? 'bg-blue-50 border-r-4 border-blue-500' : ''
                            }`}
                          >
                            <span className="text-lg">{lang.flag}</span>
                            <div className="text-left flex-1">
                              <div className="font-medium text-gray-900 text-sm">{lang.name}</div>
                              <div className="text-xs text-gray-500">{lang.nativeName}</div>
                            </div>
                            {currentLanguage === lang.code && <Check className="w-4 h-4 text-blue-500" />}
                          </button>
                        ))}
                      </div>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Rendu de la vue actuelle */}
      {renderCurrentView()}
    </div>
  );
};

export default Math4ChildProduction;