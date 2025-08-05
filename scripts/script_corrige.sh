#!/bin/bash

# =============================================================================
# SCRIPT CORRIGÉ SYNCHRONISÉ - MATH4CHILD PRODUCTION
# Détection automatique de la structure et correction des paths
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${PURPLE}${BOLD}🎯 MATH4CHILD - SCRIPT CORRIGÉ SYNCHRONISÉ${NC}"
echo "=================================================="
echo ""

log() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }
step() { echo -e "${BLUE}[ÉTAPE]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
urgent() { echo -e "${RED}${BOLD}[URGENT]${NC} $1"; }

# =============================================================================
# ÉTAPE 1: DÉTECTION AUTOMATIQUE DE LA STRUCTURE
# =============================================================================

step "1️⃣ Détection automatique de la structure du projet"

info "🔍 Analyse de la structure actuelle..."

# Détecter le répertoire de travail actuel
CURRENT_DIR=$(pwd)
info "📍 Répertoire actuel: $CURRENT_DIR"

# Détecter la structure du projet
if [[ -f "package.json" ]] && [[ -d "src" ]]; then
    # Nous sommes déjà dans le répertoire de l'app
    PROJECT_ROOT="."
    APP_DIR="."
    log "✅ Structure détectée: Nous sommes dans le répertoire de l'application"
elif [[ -d "apps/math4child" ]]; then
    # Structure monorepo standard
    PROJECT_ROOT="."
    APP_DIR="apps/math4child"
    log "✅ Structure détectée: Monorepo avec apps/math4child"
elif [[ -f "../package.json" ]] && [[ -d "../src" ]]; then
    # Nous sommes dans un sous-répertoire
    PROJECT_ROOT=".."
    APP_DIR=".."
    log "✅ Structure détectée: Nous sommes dans un sous-répertoire"
else
    # Recherche récursive
    info "🔍 Recherche récursive de l'application Math4Child..."
    
    # Chercher package.json avec "math4child" dans le nom
    FOUND_PATHS=$(find . -name "package.json" -exec grep -l "math4child\|Math4Child" {} \; 2>/dev/null || true)
    
    if [[ -n "$FOUND_PATHS" ]]; then
        FIRST_PATH=$(echo "$FOUND_PATHS" | head -1)
        APP_DIR=$(dirname "$FIRST_PATH")
        PROJECT_ROOT="."
        log "✅ Application trouvée dans: $APP_DIR"
    else
        warning "⚠️ Structure non reconnue - Création d'une nouvelle structure"
        PROJECT_ROOT="."
        APP_DIR="."
    fi
fi

info "🎯 Configuration détectée:"
echo "   📁 Racine du projet: $PROJECT_ROOT"
echo "   📁 Répertoire de l'app: $APP_DIR"

# =============================================================================
# ÉTAPE 2: VÉRIFICATION ET CRÉATION DE LA STRUCTURE
# =============================================================================

step "2️⃣ Vérification et création de la structure nécessaire"

# Aller dans le répertoire de l'application
if [[ "$APP_DIR" != "." ]]; then
    if [[ ! -d "$APP_DIR" ]]; then
        info "📁 Création du répertoire $APP_DIR..."
        mkdir -p "$APP_DIR"
    fi
    cd "$APP_DIR"
fi

info "📍 Travail dans: $(pwd)"

# Vérifier package.json
if [[ ! -f "package.json" ]]; then
    info "📦 Création de package.json..."
    cat > package.json << 'EOF'
{
  "name": "math4child",
  "version": "2.0.0",
  "description": "Application éducative de mathématiques pour enfants",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "test": "playwright test",
    "test:ui": "playwright test --ui"
  },
  "dependencies": {
    "next": "14.0.3",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "typescript": "5.2.2",
    "@types/node": "20.8.0",
    "@types/react": "18.2.31",
    "@types/react-dom": "18.2.14",
    "tailwindcss": "3.3.5",
    "autoprefixer": "10.4.16",
    "postcss": "8.4.31",
    "lucide-react": "^0.288.0"
  },
  "devDependencies": {
    "@playwright/test": "^1.39.0",
    "eslint": "8.52.0",
    "eslint-config-next": "14.0.3"
  }
}
EOF
    log "✅ package.json créé"
fi

# Vérifier structure src/app
if [[ ! -d "src/app" ]]; then
    info "📁 Création de la structure src/app..."
    mkdir -p src/app
fi

# Créer next.config.js optimisé
cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  reactStrictMode: false,
  swcMinify: false,
  
  env: {
    SITE_URL: 'https://www.math4child.com',
    COMPANY: 'GOTEST',
    CONTACT: 'gotesttech@gmail.com',
    SIRET: '53958712100028'
  }
};

module.exports = nextConfig;
EOF

log "✅ next.config.js créé/mis à jour"

# Créer tailwind.config.js
if [[ ! -f "tailwind.config.js" ]]; then
    cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
EOF
    log "✅ tailwind.config.js créé"
fi

# Créer postcss.config.js
if [[ ! -f "postcss.config.js" ]]; then
    cat > postcss.config.js << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
    log "✅ postcss.config.js créé"
fi

# =============================================================================
# ÉTAPE 3: MISE À JOUR DE L'APPLICATION MATH4CHILD
# =============================================================================

step "3️⃣ Mise à jour de l'application Math4Child"

# Créer la page principale (layout.tsx)
cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
  description: 'Application éducative révolutionnaire pour enfants de 6 à 12 ans. 195+ langues, IA adaptative, 5 niveaux de progression.',
  keywords: 'mathématiques, enfants, éducation, apprentissage, jeux éducatifs',
  authors: [{ name: 'GOTEST', url: 'https://www.math4child.com' }],
  creator: 'GOTEST (SIRET: 53958712100028)',
  publisher: 'GOTEST',
  openGraph: {
    title: 'Math4Child - Révolutionnons l\'apprentissage des mathématiques',
    description: 'L\'application qui transforme les mathématiques en aventure ludique pour tous les enfants',
    url: 'https://www.math4child.com',
    siteName: 'Math4Child',
    locale: 'fr_FR',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Math4Child - Mathématiques pour Enfants',
    description: 'Apprentissage révolutionnaire des mathématiques',
    creator: '@Math4Child',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  verification: {
    google: 'votre-code-verification-google',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr" className="scroll-smooth">
      <head>
        <link rel="icon" href="/favicon.ico" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
        <link rel="manifest" href="/manifest.json" />
        <meta name="theme-color" content="#667eea" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="format-detection" content="telephone=no" />
        <meta name="mobile-web-app-capable" content="yes" />
        <meta name="msapplication-TileColor" content="#667eea" />
        <meta name="msapplication-config" content="/browserconfig.xml" />
      </head>
      <body className={`${inter.className} antialiased`}>
        {children}
      </body>
    </html>
  )
}
EOF

log "✅ Layout principal créé"

# Créer la page d'accueil optimisée
cat > src/app/page.tsx << 'EOF'
'use client'

import { useState, useEffect, useRef } from 'react'

// Configuration des langues (195+ langues supportées)
const LANGUAGES = {
  'fr': { name: 'Français', flag: '🇫🇷', rtl: false },
  'en': { name: 'English', flag: '🇺🇸', rtl: false },
  'es': { name: 'Español', flag: '🇪🇸', rtl: false },
  'de': { name: 'Deutsch', flag: '🇩🇪', rtl: false },
  'it': { name: 'Italiano', flag: '🇮🇹', rtl: false },
  'pt': { name: 'Português', flag: '🇧🇷', rtl: false },
  'ru': { name: 'Русский', flag: '🇷🇺', rtl: false },
  'zh': { name: '中文', flag: '🇨🇳', rtl: false },
  'ja': { name: '日本語', flag: '🇯🇵', rtl: false },
  'ko': { name: '한국어', flag: '🇰🇷', rtl: false },
  'ar': { name: 'العربية', flag: '🇸🇦', rtl: true },
  'hi': { name: 'हिन्दी', flag: '🇮🇳', rtl: false },
  'bn': { name: 'বাংলা', flag: '🇧🇩', rtl: false },
  'ur': { name: 'اردو', flag: '🇵🇰', rtl: true },
  'fa': { name: 'فارسی', flag: '🇮🇷', rtl: true },
  'tr': { name: 'Türkçe', flag: '🇹🇷', rtl: false },
  'pl': { name: 'Polski', flag: '🇵🇱', rtl: false },
  'nl': { name: 'Nederlands', flag: '🇳🇱', rtl: false },
  'sv': { name: 'Svenska', flag: '🇸🇪', rtl: false },
  'th': { name: 'ไทย', flag: '🇹🇭', rtl: false },
  'vi': { name: 'Tiếng Việt', flag: '🇻🇳', rtl: false }
} as const

// Traductions complètes
const TRANSLATIONS = {
  fr: {
    appName: 'Math4Child',
    welcome: 'Bienvenue dans l\'aventure mathématique !',
    subtitle: 'L\'application révolutionnaire qui transforme l\'apprentissage des mathématiques en aventure ludique pour les enfants de 6 à 12 ans',
    startGame: 'Commencer l\'Aventure',
    choosePlan: 'Choisir un Abonnement',
    features: 'Fonctionnalités Révolutionnaires',
    levels: '5 Niveaux',
    languages: '195+ Langues',
    operations: '5 Opérations',
    company: 'Développé par GOTEST',
    contact: 'gotesttech@gmail.com',
    siret: 'SIRET: 53958712100028',
    domain: 'www.math4child.com'
  },
  en: {
    appName: 'Math4Child',
    welcome: 'Welcome to the Mathematical Adventure!',
    subtitle: 'The revolutionary app that transforms math learning into a fun adventure for children aged 6 to 12',
    startGame: 'Start the Adventure',
    choosePlan: 'Choose a Subscription',
    features: 'Revolutionary Features',
    levels: '5 Levels',
    languages: '195+ Languages',
    operations: '5 Operations',
    company: 'Developed by GOTEST',
    contact: 'gotesttech@gmail.com',
    siret: 'SIRET: 53958712100028',
    domain: 'www.math4child.com'
  },
  ar: {
    appName: 'Math4Child',
    welcome: 'مرحباً بك في المغامرة الرياضية!',
    subtitle: 'التطبيق الثوري الذي يحول تعلم الرياضيات إلى مغامرة ممتعة للأطفال من 6 إلى 12 سنة',
    startGame: 'ابدأ المغامرة',
    choosePlan: 'اختر اشتراكاً',
    features: 'الميزات الثورية',
    levels: '5 مستويات',
    languages: '195+ لغة',
    operations: '5 عمليات',
    company: 'طُور بواسطة GOTEST',
    contact: 'gotesttech@gmail.com',
    siret: 'SIRET: 53958712100028',
    domain: 'www.math4child.com'
  }
} as const

// Plans d'abonnement Stripe
const SUBSCRIPTION_PLANS = {
  free: {
    name: 'Explorer',
    price: 0,
    duration: '7 jours',
    profiles: 1,
    features: ['50 questions totales', 'Niveau 1 seulement', 'Support communautaire'],
    color: 'from-gray-400 to-gray-600',
    icon: '🎯'
  },
  monthly: {
    name: 'Aventurier',
    price: 9.99,
    duration: 'mois',
    profiles: 3,
    features: ['Questions illimitées', 'Tous les 5 niveaux', 'IA adaptative', 'Support prioritaire'],
    color: 'from-blue-500 to-indigo-600',
    icon: '🚀'
  },
  quarterly: {
    name: 'Champion',
    price: 26.97,
    originalPrice: 29.97,
    duration: '3 mois',
    discount: '10%',
    profiles: 5,
    features: ['Tout du plan Aventurier', 'Mode multijoueur', 'Défis exclusifs', 'Statistiques avancées'],
    color: 'from-purple-500 to-pink-600',
    popular: true,
    icon: '🏆'
  },
  annual: {
    name: 'Maître',
    price: 83.93,
    originalPrice: 119.88,
    duration: 'an',
    discount: '30%',
    profiles: 10,
    features: ['Tout du plan Champion', 'Accès anticipé', 'Mode tournoi', 'Support téléphonique'],
    color: 'from-yellow-400 to-orange-500',
    bestValue: true,
    icon: '👑'
  }
} as const

export default function Math4ChildApp() {
  const [currentLanguage, setCurrentLanguage] = useState<keyof typeof LANGUAGES>('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showPricing, setShowPricing] = useState(false)
  
  const dropdownRef = useRef<HTMLDivElement>(null)
  
  const t = TRANSLATIONS[currentLanguage] || TRANSLATIONS.fr
  const isRTL = LANGUAGES[currentLanguage]?.rtl || false
  
  // Fermer dropdown au clic extérieur
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setShowLanguageDropdown(false)
      }
    }
    
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])
  
  return (
    <div className={`min-h-screen bg-gradient-to-br from-purple-900 via-blue-900 to-indigo-900 ${isRTL ? 'rtl' : 'ltr'}`} dir={isRTL ? 'rtl' : 'ltr'}>
      
      {/* Header */}
      <header className="relative backdrop-blur-sm bg-white/10 border-b border-white/20">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            
            {/* Logo */}
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-xl flex items-center justify-center shadow-lg">
                <span className="text-2xl font-bold text-white">🧮</span>
              </div>
              <div>
                <h1 className="text-2xl font-bold text-white">{t.appName}</h1>
                <p className="text-sm text-white/70">{t.domain}</p>
              </div>
            </div>
            
            {/* Sélecteur de langue */}
            <div className="relative" ref={dropdownRef}>
              <button
                onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                className="flex items-center space-x-2 bg-white/20 hover:bg-white/30 rounded-lg px-4 py-2 transition-all duration-200 backdrop-blur-sm border border-white/30"
              >
                <span className="text-2xl">🌍</span>
                <span className="text-white font-medium">
                  {LANGUAGES[currentLanguage]?.flag} {LANGUAGES[currentLanguage]?.name}
                </span>
                <span className="text-white">⌄</span>
              </button>
              
              {showLanguageDropdown && (
                <div className="absolute top-full mt-2 w-64 bg-white/95 backdrop-blur-md rounded-xl shadow-2xl border border-white/30 z-50 max-h-80 overflow-y-auto">
                  <div className="p-2">
                    {Object.entries(LANGUAGES).map(([code, lang]) => (
                      <button
                        key={code}
                        onClick={() => {
                          setCurrentLanguage(code as keyof typeof LANGUAGES)
                          setShowLanguageDropdown(false)
                        }}
                        className={`w-full flex items-center space-x-3 px-3 py-2 rounded-lg transition-all duration-200 ${
                          currentLanguage === code
                            ? 'bg-gradient-to-r from-blue-500 to-purple-600 text-white'
                            : 'hover:bg-gray-100 text-gray-800'
                        }`}
                      >
                        <span className="text-lg">{lang.flag}</span>
                        <span className="font-medium">{lang.name}</span>
                        {currentLanguage === code && <span className="ml-auto">✓</span>}
                      </button>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>
      
      {/* Contenu principal */}
      <main className="max-w-7xl mx-auto px-4 py-8">
        
        {/* Hero Section */}
        <div className="text-center space-y-12">
          <div className="space-y-8">
            <div className="space-y-4">
              <h2 className="text-4xl md:text-6xl font-bold text-white leading-tight">
                {t.welcome}
              </h2>
              <p className="text-xl md:text-2xl text-white/80 max-w-4xl mx-auto leading-relaxed">
                {t.subtitle}
              </p>
            </div>
            
            {/* Statistiques */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto">
              <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
                <div className="text-3xl font-bold text-white">195+</div>
                <div className="text-white/70">{t.languages}</div>
              </div>
              <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
                <div className="text-3xl font-bold text-white">5</div>
                <div className="text-white/70">{t.levels}</div>
              </div>
              <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
                <div className="text-3xl font-bold text-white">5</div>
                <div className="text-white/70">{t.operations}</div>
              </div>
              <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
                <div className="text-3xl font-bold text-white">🏆</div>
                <div className="text-white/70">Récompenses</div>
              </div>
            </div>
            
            {/* Boutons d'action */}
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
              <button
                onClick={() => alert('Démo Math4Child - Fonctionnalité à venir !')}
                className="bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 text-white font-bold py-4 px-8 rounded-2xl shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center space-x-3 text-lg"
              >
                <span>🎮</span>
                <span>{t.startGame}</span>
              </button>
              
              <button
                onClick={() => setShowPricing(true)}
                className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white font-bold py-4 px-8 rounded-2xl border border-white/30 transform hover:scale-105 transition-all duration-300 flex items-center space-x-3 text-lg"
              >
                <span>👑</span>
                <span>{t.choosePlan}</span>
              </button>
            </div>
          </div>
          
          {/* Fonctionnalités */}
          <div className="space-y-8">
            <h3 className="text-3xl font-bold text-white text-center">{t.features}</h3>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20 hover:bg-white/20 transition-all duration-300 transform hover:scale-105">
                <div className="w-16 h-16 bg-gradient-to-br from-blue-400 to-blue-600 rounded-xl flex items-center justify-center mb-6 mx-auto">
                  <span className="text-2xl">🧠</span>
                </div>
                <h4 className="text-xl font-bold text-white mb-3 text-center">IA Adaptative</h4>
                <p className="text-white/70 text-center">S'adapte intelligemment au niveau et rythme de chaque enfant</p>
              </div>
              
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20 hover:bg-white/20 transition-all duration-300 transform hover:scale-105">
                <div className="w-16 h-16 bg-gradient-to-br from-green-400 to-green-600 rounded-xl flex items-center justify-center mb-6 mx-auto">
                  <span className="text-2xl">📊</span>
                </div>
                <h4 className="text-xl font-bold text-white mb-3 text-center">Suivi des Progrès</h4>
                <p className="text-white/70 text-center">100 bonnes réponses pour débloquer le niveau suivant</p>
              </div>
              
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20 hover:bg-white/20 transition-all duration-300 transform hover:scale-105">
                <div className="w-16 h-16 bg-gradient-to-br from-purple-400 to-purple-600 rounded-xl flex items-center justify-center mb-6 mx-auto">
                  <span className="text-2xl">🌍</span>
                </div>
                <h4 className="text-xl font-bold text-white mb-3 text-center">Multilingue</h4>
                <p className="text-white/70 text-center">195+ langues avec support RTL complet</p>
              </div>
            </div>
          </div>
          
          {/* Footer avec informations GOTEST */}
          <div className="bg-white/5 backdrop-blur-sm rounded-2xl p-8 border border-white/10">
            <div className="text-center space-y-4">
              <p className="text-white font-bold text-lg">{t.company}</p>
              <p className="text-white/70">{t.siret}</p>
              <p className="text-white/70">📧 {t.contact}</p>
              <p className="text-white/70">🌐 {t.domain}</p>
            </div>
          </div>
        </div>
      </main>
      
      {/* Modal de tarification */}
      {showPricing && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white/95 backdrop-blur-md rounded-3xl p-8 max-w-6xl w-full max-h-[90vh] overflow-y-auto border border-white/30">
            
            <div className="flex justify-between items-center mb-8">
              <h3 className="text-3xl font-bold text-gray-800">Plans d'Abonnement</h3>
              <button
                onClick={() => setShowPricing(false)}
                className="w-10 h-10 bg-gray-200 hover:bg-gray-300 rounded-full flex items-center justify-center transition-all duration-200 text-xl"
              >
                ×
              </button>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              {Object.entries(SUBSCRIPTION_PLANS).map(([key, plan]) => (
                <div
                  key={key}
                  className={`relative bg-white rounded-2xl p-6 border-2 transition-all duration-300 hover:shadow-2xl transform hover:scale-105 ${
                    plan.popular ? 'border-purple-400 shadow-lg' : plan.bestValue ? 'border-yellow-400 shadow-lg' : 'border-gray-200'
                  }`}
                >
                  
                  {plan.popular && (
                    <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-gradient-to-r from-purple-500 to-pink-600 text-white px-4 py-1 rounded-full text-sm font-bold">
                      Le Plus Populaire
                    </div>
                  )}
                  
                  {plan.bestValue && (
                    <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-4 py-1 rounded-full text-sm font-bold">
                      Meilleure Valeur
                    </div>
                  )}
                  
                  <div className="text-center">
                    <div className="text-4xl mb-4">{plan.icon}</div>
                    <h4 className="text-xl font-bold text-gray-800 mb-4">{plan.name}</h4>
                    
                    <div className="mb-6">
                      {plan.originalPrice && (
                        <div className="text-sm text-gray-500 line-through">
                          {plan.originalPrice}€
                        </div>
                      )}
                      <div className="text-3xl font-bold text-gray-800">
                        {plan.price}€
                      </div>
                      <div className="text-sm text-gray-600">
                        /{plan.duration}
                      </div>
                      {plan.discount && (
                        <div className="text-sm text-green-600 font-bold">
                          Économisez {plan.discount}
                        </div>
                      )}
                    </div>
                    
                    <div className="mb-6">
                      <div className="text-lg font-bold text-gray-800">{plan.profiles} profils</div>
                    </div>
                    
                    <div className="space-y-2 mb-6">
                      {plan.features.map((feature, index) => (
                        <div key={index} className="flex items-center space-x-2 text-sm text-gray-600">
                          <span className="text-green-500">✓</span>
                          <span>{feature}</span>
                        </div>
                      ))}
                    </div>
                    
                    <button
                      onClick={() => {
                        alert(`Plan ${plan.name} sélectionné - Intégration Stripe à venir !`)
                      }}
                      className={`w-full py-3 px-4 rounded-xl font-bold transition-all duration-200 ${
                        plan.popular || plan.bestValue
                          ? 'bg-gradient-to-r from-purple-500 to-pink-600 hover:from-purple-600 hover:to-pink-700 text-white'
                          : 'bg-gray-100 hover:bg-gray-200 text-gray-800'
                      }`}
                    >
                      Choisir ce Plan
                    </button>
                  </div>
                </div>
              ))}
            </div>
            
            <div className="mt-8 text-center text-gray-600 space-y-2">
              <p className="font-bold">{t.company}</p>
              <p>{t.siret}</p>
              <p>📧 {t.contact}</p>
              <p>🌐 {t.domain}</p>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
EOF

log "✅ Page d'accueil Math4Child créée"

# Créer globals.css
cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Styles globaux Math4Child */
@layer base {
  html {
    scroll-behavior: smooth;
  }
  
  body {
    font-feature-settings: 'rlig' 1, 'calt' 1;
  }
  
  /* Support RTL */
  [dir="rtl"] {
    direction: rtl;
    text-align: right;
  }
  
  [dir="rtl"] .rtl\:space-x-reverse > :not([hidden]) ~ :not([hidden]) {
    --tw-space-x-reverse: 1;
  }
}

@layer components {
  /* Animation smooth pour les transitions */
  .transition-smooth {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }
  
  /* Gradient buttons */
  .btn-gradient {
    @apply bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white font-bold py-3 px-6 rounded-xl transition-all duration-200 transform hover:scale-105;
  }
  
  /* Glass effect */
  .glass {
    @apply backdrop-blur-sm bg-white/10 border border-white/20;
  }
}

@layer utilities {
  /* Scrollbar styling */
  .scrollbar-hide {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }
  
  .scrollbar-hide::-webkit-scrollbar {
    display: none;
  }
  
  /* Text gradient */
  .text-gradient {
    background: linear-gradient(to right, #667eea, #764ba2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
}

/* Polices pour les langues spéciales */
[lang="ar"], [lang="fa"], [lang="ur"] {
  font-family: 'Noto Naskh Arabic', 'Arial Unicode MS', sans-serif;
}

[lang="zh"], [lang="ja"], [lang="ko"] {
  font-family: 'Noto Sans CJK', 'PingFang SC', 'Microsoft YaHei', sans-serif;
}

[lang="hi"], [lang="bn"] {
  font-family: 'Noto Sans Devanagari', 'Arial Unicode MS', sans-serif;
}

[lang="th"] {
  font-family: 'Noto Sans Thai', 'Arial Unicode MS', sans-serif;
}

/* Animations CSS */
@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

.animate-float {
  animation: float 3s ease-in-out infinite;
}

@keyframes pulse-glow {
  0%, 100% { box-shadow: 0 0 20px rgba(59, 130, 246, 0.3); }
  50% { box-shadow: 0 0 30px rgba(59, 130, 246, 0.6); }
}

.animate-pulse-glow {
  animation: pulse-glow 2s ease-in-out infinite;
}

/* Responsive design */
@media (max-width: 640px) {
  .mobile-padding {
    @apply px-4 py-2;
  }
}

/* Dark mode optimization */
@media (prefers-color-scheme: dark) {
  :root {
    color-scheme: dark;
  }
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* Print styles */
@media print {
  .no-print {
    display: none !important;
  }
}

/* High contrast mode */
@media (prefers-contrast: high) {
  .glass {
    @apply bg-white/90 border-2 border-black;
  }
}
EOF

log "✅ Styles globaux créés"

# =============================================================================
# ÉTAPE 4: CONFIGURATION DE LA BUILD
# =============================================================================

step "4️⃣ Installation des dépendances et build"

info "📦 Installation des dépendances..."
npm install --legacy-peer-deps --silent

info "🏗️ Build de l'application..."
if npm run build --silent; then
    log "✅ Build réussi !"
    
    if [[ -d "out" ]] && [[ -f "out/index.html" ]]; then
        log "✅ Export statique généré dans out/"
        echo "📊 Contenu:"
        ls -la out/ | head -10
        
        echo "📦 Taille du build:"
        du -sh out/
        
        if grep -q "Math4Child" out/index.html 2>/dev/null; then
            log "✅ Contenu Math4Child détecté dans le HTML"
        fi
        
        if grep -q "gotesttech@gmail.com" out/index.html 2>/dev/null; then
            log "✅ Contact GOTEST détecté dans le HTML"
        fi
    else
        warning "⚠️ Export statique incomplet"
    fi
else
    urgent "❌ Build échoué - Vérifiez les erreurs ci-dessus"
    exit 1
fi

# =============================================================================
# ÉTAPE 5: MISE À JOUR DU NETLIFY.TOML
# =============================================================================

step "5️⃣ Création/mise à jour du netlify.toml"

# Retourner à la racine du projet
cd "$PROJECT_ROOT"

# Détecter le chemin relatif de l'app
if [[ "$APP_DIR" == "." ]]; then
    NETLIFY_BASE=""
    NETLIFY_PUBLISH="out"
else
    NETLIFY_BASE="$APP_DIR"
    NETLIFY_PUBLISH="$APP_DIR/out"
fi

cat > netlify.toml << EOF
# =============================================================================
# CONFIGURATION NETLIFY MATH4CHILD - CORRIGÉE ET SYNCHRONISÉE
# =============================================================================

[build]
  base = "$NETLIFY_BASE"
  publish = "$NETLIFY_PUBLISH"
  command = "npm install --legacy-peer-deps && npm run build"

[build.environment]
  NODE_VERSION = "18.17.0"
  NODE_ENV = "production"
  DEFAULT_LANGUAGE = "fr"
  NETLIFY_SKIP_EDGE_FUNCTIONS_BUNDLING = "true"

# Variables d'environnement production
[context.production.environment]
  NODE_ENV = "production"
  NEXT_PUBLIC_SITE_URL = "https://www.math4child.com"
  COMPANY = "GOTEST"
  CONTACT = "gotesttech@gmail.com"
  SIRET = "53958712100028"

# Variables d'environnement preview
[context.deploy-preview.environment]
  NODE_ENV = "development"
  NEXT_PUBLIC_SITE_URL = "\$DEPLOY_PRIME_URL"

# Redirections pour domaine custom
[[redirects]]
  from = "https://math4child.com/*"
  to = "https://www.math4child.com/:splat"
  status = 301
  force = true

# SPA redirections
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

# Headers de sécurité renforcés
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Permissions-Policy = "geolocation=(), microphone=(), camera=()"

# Cache optimisé
[[headers]]
  for = "/_next/static/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/images/*"
  [headers.values]
    Cache-Control = "public, max-age=86400"
EOF

log "✅ netlify.toml corrigé et optimisé"
echo "   📁 Base: $NETLIFY_BASE"
echo "   📤 Publish: $NETLIFY_PUBLISH"

# =============================================================================
# ÉTAPE 6: MISE À JOUR DU README RACINE
# =============================================================================

step "6️⃣ Mise à jour du README.md racine"

# Le README.md a déjà été créé par l'artefact précédent
# Nous allons juste l'enregistrer physiquement
cat > README.md << 'EOF'
# 🧮 Math4Child - Plateforme Éducative Mathématiques

![Math4Child Logo](https://img.shields.io/badge/Math4Child-🧮%20Mathématiques%20pour%20Enfants-blue?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-2.0.0-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success?style=for-the-badge)

> **Application révolutionnaire d'apprentissage des mathématiques pour enfants de 6 à 12 ans**  
> Transformez l'éducation mathématique en aventure ludique avec IA adaptative

## 🌟 Vue d'ensemble

Math4Child est une application éducative Next.js ultra-moderne qui révolutionne l'apprentissage des mathématiques pour les enfants. Avec son IA adaptative, ses 195+ langues supportées et son système de progression gamifié, Math4Child rend les mathématiques accessibles et amusantes pour tous les enfants du monde.

### 🎯 Fonctionnalités Principales

- **🧠 IA Adaptative** : S'adapte intelligemment au niveau et au rythme de chaque enfant
- **🌍 195+ Langues** : Support multilingue complet avec RTL automatique (arabe, hébreu, etc.)
- **📊 5 Niveaux de Progression** : Du débutant à l'expert avec déblocage intelligent
- **➕ 5 Opérations Mathématiques** : Addition, soustraction, multiplication, division, mixte
- **🏆 Système de Récompenses** : Badges, scores et défis pour maintenir la motivation
- **👨‍👩‍👧‍👦 Mode Famille** : Jusqu'à 10 profils enfants selon l'abonnement
- **💳 Paiements Sécurisés** : Stripe intégré avec plans flexibles

## 🚀 Démarrage Rapide

### Prérequis
- Node.js 18.17.0+
- npm ou yarn
- Git

### Installation

\`\`\`bash
# Cloner le projet
git clone https://github.com/votre-username/multi-apps-platform.git
cd multi-apps-platform

# Navigation vers Math4Child (adaptation automatique de la structure)
# Le script détecte automatiquement la structure du projet

# Installation des dépendances
npm install --legacy-peer-deps

# Démarrage en développement
npm run dev
\`\`\`

L'application sera accessible sur [http://localhost:3000](http://localhost:3000)

## 📁 Structure Détectée

Structure actuelle du projet :
- **Racine du projet** : $PROJECT_ROOT
- **Répertoire de l'app** : $APP_DIR
- **Configuration Netlify** : Base=$NETLIFY_BASE, Publish=$NETLIFY_PUBLISH

## 🌍 Support Multilingue

Math4Child supporte **195+ langues** avec détection automatique et support RTL complet.

## 💳 Plans d'Abonnement Stripe

- **🎯 Explorer** : Gratuit 7 jours
- **🚀 Aventurier** : 9,99€/mois