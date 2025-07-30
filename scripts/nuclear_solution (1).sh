#!/bin/bash

# =============================================================================
# 🚀 SOLUTION NUCLÉAIRE - CRÉER UN NOUVEAU MATH4CHILD PROPRE
# Évite tous les problèmes de cache en créant tout depuis zéro
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() {
    echo -e "${CYAN}🚀 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_step "SOLUTION NUCLÉAIRE - Création d'un Math4Child tout neuf"

# =============================================================================
# ÉTAPE 1: Créer un nouveau dossier math4child-new
# =============================================================================

NEW_DIR="apps/math4child-new"

if [ -d "$NEW_DIR" ]; then
    rm -rf "$NEW_DIR"
fi

mkdir -p "$NEW_DIR"
cd "$NEW_DIR"

print_success "Nouveau dossier créé: $NEW_DIR"

# =============================================================================
# ÉTAPE 2: Initialiser Next.js + TypeScript depuis zéro
# =============================================================================

print_step "Initialisation Next.js TypeScript..."

# Créer package.json
cat << 'EOF' > package.json
{
  "name": "math4child-new",
  "version": "2.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3006",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.2.5",
    "react": "^18",
    "react-dom": "^18",
    "lucide-react": "^0.263.1"
  },
  "devDependencies": {
    "typescript": "^5",
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "tailwindcss": "^3.4.1",
    "autoprefixer": "^10.0.1",
    "postcss": "^8",
    "eslint": "^8",
    "eslint-config-next": "14.2.5"
  }
}
EOF

# Créer next.config.js
cat << 'EOF' > next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
}

module.exports = nextConfig
EOF

# Créer tsconfig.json
cat << 'EOF' > tsconfig.json
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
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

# Créer tailwind.config.js
cat << 'EOF' > tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      animation: {
        'pulse-soft': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      }
    },
  },
  plugins: [],
}
EOF

# Créer postcss.config.js
cat << 'EOF' > postcss.config.js
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

print_success "Configuration Next.js créée"

# =============================================================================
# ÉTAPE 3: Créer la structure des dossiers
# =============================================================================

mkdir -p src/app
mkdir -p src/components
mkdir -p src/styles

# =============================================================================
# ÉTAPE 4: Créer le layout.tsx
# =============================================================================

cat << 'EOF' > src/app/layout.tsx
import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math4Child - Apprends les maths en t\'amusant !',
  description: 'L\'app éducative n°1 pour apprendre les maths en famille. Plus de 100k familles nous font confiance.',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body>{children}</body>
    </html>
  )
}
EOF

# =============================================================================
# ÉTAPE 5: Créer le page.tsx avec le VRAI design Math4Child
# =============================================================================

cat << 'EOF' > src/app/page.tsx
'use client'

import React, { useState, useEffect } from 'react'
import { 
  Users, 
  Languages, 
  ChevronDown, 
  Crown, 
  Gift, 
  Globe, 
  TrendingUp,
  CheckCircle,
  ArrowRight,
  Smartphone,
  Monitor,
  Tablet
} from 'lucide-react'

// Configuration des langues
const LANGUAGE_CONFIG = {
  fr: {
    flag: '🇫🇷',
    name: 'Français',
    appName: 'Math pour enfants',
    tagline: 'App éducative n°1 en France',
    heroTitle: 'Apprends les maths en t\'amusant !',
    heroWelcome: 'Bienvenue dans l\'aventure mathématique !',
    features: [
      'Débloquez toutes les fonctionnalités premium',
      '30+ langues disponibles',
      'Web, iOS et Android',
      '5 niveaux de difficulté',
      'Suivi détaillé des progrès'
    ],
    startFree: 'Commencer gratuitement',
    freeTrial: '14j gratuit',
    comparePrices: 'Comparer les prix'
  },
  en: {
    flag: '🇺🇸',
    name: 'English',
    appName: 'Math4Child',
    tagline: '#1 Educational App in France',
    heroTitle: 'Learn math while having fun!',
    heroWelcome: 'Welcome to the mathematical adventure!',
    features: [
      'Unlock all premium features',
      '30+ languages available',
      'Web, iOS and Android',
      '5 difficulty levels',
      'Detailed progress tracking'
    ],
    startFree: 'Start Free',
    freeTrial: '14 days free',
    comparePrices: 'Compare Prices'
  }
}

export default function HomePage() {
  const [currentLang, setCurrentLang] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showPricingModal, setShowPricingModal] = useState(false)
  
  const t = LANGUAGE_CONFIG[currentLang as keyof typeof LANGUAGE_CONFIG]

  const handleStartFree = () => {
    alert(`🎉 Démarrage de l'essai gratuit de 14 jours pour ${t.appName}!`)
  }

  // Fermer dropdown au clic extérieur
  useEffect(() => {
    const handleClickOutside = () => setShowLanguageDropdown(false)
    document.addEventListener('click', handleClickOutside)
    return () => document.removeEventListener('click', handleClickOutside)
  }, [])

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {/* Header */}
      <header className="sticky top-0 z-50 bg-white/80 backdrop-blur-xl border-b border-gray-200/50 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            {/* Logo */}
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center shadow-lg">
                <span className="text-white text-xl font-bold">M4C</span>
              </div>
              <div>
                <h1 className="text-lg font-bold text-gray-900">{t.appName}</h1>
                <p className="text-xs text-gray-600 flex items-center">
                  <Crown size={12} className="mr-1 text-orange-500" />
                  {t.tagline}
                </p>
              </div>
            </div>
            
            {/* Navigation */}
            <div className="flex items-center space-x-4">
              {/* Badge familles */}
              <div className="hidden md:flex items-center space-x-2 bg-green-100 text-green-800 rounded-full px-3 py-1 text-sm font-medium">
                <Users size={14} />
                <span>100k+ familles</span>
              </div>
              
              {/* Sélecteur de langue */}
              <div className="relative">
                <button
                  onClick={(e) => {
                    e.stopPropagation()
                    setShowLanguageDropdown(!showLanguageDropdown)
                  }}
                  className="flex items-center space-x-2 bg-gray-100 hover:bg-gray-200 rounded-lg px-3 py-2 text-gray-700 transition-colors duration-200"
                >
                  <Languages size={16} />
                  <span className="text-lg">{t.flag}</span>
                  <span className="text-sm font-medium">{t.name}</span>
                  <ChevronDown size={14} className={`transform transition-transform ${showLanguageDropdown ? 'rotate-180' : ''}`} />
                </button>
                
                {/* Dropdown */}
                {showLanguageDropdown && (
                  <div className="absolute top-full right-0 mt-2 w-64 bg-white rounded-xl shadow-2xl border border-gray-200 overflow-hidden z-50">
                    <div className="p-3 border-b border-gray-100">
                      <p className="text-sm font-semibold text-gray-900">Sélectionner une langue</p>
                      <p className="text-xs text-gray-600">30+ langues disponibles</p>
                    </div>
                    <div className="max-h-60 overflow-y-auto">
                      {Object.entries(LANGUAGE_CONFIG).map(([lang, config]) => (
                        <button
                          key={lang}
                          onClick={(e) => {
                            e.stopPropagation()
                            setCurrentLang(lang)
                            setShowLanguageDropdown(false)
                          }}
                          className={`w-full text-left px-4 py-3 hover:bg-gray-50 transition-colors flex items-center space-x-3 ${
                            currentLang === lang ? 'bg-blue-50 text-blue-900 font-medium' : 'text-gray-700'
                          }`}
                        >
                          <span className="text-lg">{config.flag}</span>
                          <div>
                            <div className="font-medium">{config.name}</div>
                          </div>
                        </button>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <main className="relative">
        {/* Particules de fond */}
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute -top-40 -right-40 w-80 h-80 bg-purple-200 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
          <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-yellow-200 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
          <div className="absolute top-40 left-1/4 w-60 h-60 bg-pink-200 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        </div>

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          {/* Section hero */}
          <div className="text-center mb-16">
            {/* Badge leader mondial */}
            <div className="inline-flex items-center space-x-2 bg-gradient-to-r from-orange-100 to-red-100 rounded-full px-6 py-3 mb-8 border border-orange-200">
              <Globe size={18} className="text-orange-600" />
              <span className="text-orange-800 font-semibold">www.math4child.com • Leader mondial</span>
            </div>

            {/* Titre principal */}
            <h2 className="text-4xl sm:text-5xl lg:text-6xl font-bold text-gray-900 mb-6 leading-tight">
              <span className="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent">
                {t.heroTitle}
              </span>
            </h2>
            
            <p className="text-xl sm:text-2xl text-gray-700 mb-8 max-w-3xl mx-auto font-light">
              {t.heroWelcome}
            </p>
            
            {/* Fonctionnalités */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4 mb-12 max-w-5xl mx-auto">
              {t.features.map((feature, index) => (
                <div key={index} className="bg-white/70 backdrop-blur-sm rounded-lg p-4 border border-gray-200 shadow-sm">
                  <p className="text-sm font-medium text-gray-800">{feature}</p>
                </div>
              ))}
            </div>
          </div>
          
          {/* Boutons CTA */}
          <div className="flex flex-col sm:flex-row gap-6 justify-center items-center mb-16">
            <button 
              onClick={handleStartFree}
              className="group bg-gradient-to-r from-green-500 to-emerald-600 text-white px-8 py-4 rounded-2xl text-lg font-bold hover:from-green-600 hover:to-emerald-700 transition-all transform hover:scale-105 shadow-xl flex items-center space-x-3 min-w-[300px]"
            >
              <Gift size={24} />
              <div className="text-left">
                <div>{t.startFree}</div>
                <div className="text-sm opacity-90">{t.freeTrial}</div>
              </div>
              <ArrowRight size={20} className="group-hover:translate-x-1 transition-transform" />
            </button>
            
            <button 
              onClick={() => setShowPricingModal(true)}
              className="bg-gradient-to-r from-blue-500 to-indigo-600 text-white px-8 py-4 rounded-2xl text-lg font-bold hover:from-blue-600 hover:to-indigo-700 transition-all transform hover:scale-105 shadow-xl flex items-center space-x-3 min-w-[300px]"
            >
              <TrendingUp size={24} />
              <span>{t.comparePrices}</span>
            </button>
          </div>

          {/* Statistiques */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-8 mb-16 max-w-3xl mx-auto">
            <div className="text-center bg-white/50 backdrop-blur-sm rounded-2xl p-6 border border-gray-200">
              <div className="text-3xl font-bold text-blue-600 mb-2">100k+</div>
              <div className="text-gray-700 font-medium">Familles actives</div>
            </div>
            <div className="text-center bg-white/50 backdrop-blur-sm rounded-2xl p-6 border border-gray-200">
              <div className="text-3xl font-bold text-green-600 mb-2">98%</div>
              <div className="text-gray-700 font-medium">Satisfaction</div>
            </div>
            <div className="text-center bg-white/50 backdrop-blur-sm rounded-2xl p-6 border border-gray-200">
              <div className="text-3xl font-bold text-purple-600 mb-2">47</div>
              <div className="text-gray-700 font-medium">Pays</div>
            </div>
          </div>

          {/* Plateformes */}
          <div className="text-center">
            <h3 className="text-2xl font-bold text-gray-900 mb-8">Disponible partout</h3>
            <div className="flex justify-center items-center space-x-8">
              <div className="text-center">
                <Monitor size={48} className="text-blue-500 mx-auto mb-2" />
                <p className="text-gray-700 font-medium">Web</p>
              </div>
              <div className="text-center">
                <Smartphone size={48} className="text-green-500 mx-auto mb-2" />
                <p className="text-gray-700 font-medium">iOS</p>
              </div>
              <div className="text-center">
                <Tablet size={48} className="text-orange-500 mx-auto mb-2" />
                <p className="text-gray-700 font-medium">Android</p>
              </div>
            </div>
          </div>
        </div>
      </main>

      {/* Modal Pricing */}
      {showPricingModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-8">
              <div className="flex justify-between items-center mb-8">
                <h3 className="text-3xl font-bold text-gray-900">Nos Plans</h3>
                <button 
                  onClick={() => setShowPricingModal(false)}
                  className="text-gray-500 hover:text-gray-700 text-3xl"
                >
                  ×
                </button>
              </div>
              
              {/* Plans */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {/* Gratuit */}
                <div className="border-2 border-gray-200 rounded-2xl p-6">
                  <h4 className="text-xl font-bold mb-2">Gratuit</h4>
                  <div className="text-3xl font-bold mb-4">0€</div>
                  <ul className="space-y-2 text-sm mb-6">
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2" />Exercices de base</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2" />1 profil</li>
                  </ul>
                  <button className="w-full bg-gray-200 py-3 rounded-xl font-semibold">
                    Gratuit
                  </button>
                </div>

                {/* Premium */}
                <div className="border-2 border-purple-500 rounded-2xl p-6 bg-purple-50 relative">
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-purple-500 text-white text-xs px-3 py-1 rounded-full">
                    Populaire
                  </div>
                  <h4 className="text-xl font-bold mb-2">Famille</h4>
                  <div className="flex items-center space-x-2 mb-4">
                    <span className="text-3xl font-bold">6.99€</span>
                    <span className="text-lg line-through text-gray-500">9.99€</span>
                  </div>
                  <ul className="space-y-2 text-sm mb-6">
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2" />Exercices illimités</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2" />5 profils</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2" />Hors-ligne</li>
                  </ul>
                  <button className="w-full bg-purple-600 text-white py-3 rounded-xl font-semibold">
                    Essai 14j gratuit
                  </button>
                </div>

                {/* École */}
                <div className="border-2 border-orange-200 rounded-2xl p-6">
                  <h4 className="text-xl font-bold mb-2">École</h4>
                  <div className="text-3xl font-bold mb-4">24.99€</div>
                  <ul className="space-y-2 text-sm mb-6">
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2" />30 élèves</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2" />Dashboard prof</li>
                  </ul>
                  <button className="w-full bg-orange-600 text-white py-3 rounded-xl font-semibold">
                    Demander devis
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
EOF

# =============================================================================
# ÉTAPE 6: Créer le globals.css
# =============================================================================

cat << 'EOF' > src/app/globals.css
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

/* Scroll personnalisé */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f5f9;
}

::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}

/* Animations */
@keyframes pulse {
  0%, 100% {
    opacity: 0.3;
  }
  50% {
    opacity: 0.5;
  }
}

.animate-pulse-soft {
  animation: pulse 4s ease-in-out infinite;
}

/* Focus pour accessibilité */
button:focus-visible,
a:focus-visible {
  outline: 2px solid #3b82f6;
  outline-offset: 2px;
}
EOF

print_success "Structure Next.js complète créée"

# =============================================================================
# ÉTAPE 7: Installer les dépendances
# =============================================================================

print_step "Installation des dépendances..."

npm install

print_success "Dépendances installées"

# =============================================================================
# ÉTAPE 8: Instructions finales
# =============================================================================

echo ""
echo -e "${GREEN}🎉 MATH4CHILD NOUVEAU EST PRÊT !${NC}"
echo ""
echo -e "${YELLOW}🚀 LANCEZ MAINTENANT :${NC}"
echo ""
echo "   cd $NEW_DIR"
echo "   npm run dev"
echo ""
echo -e "${CYAN}📱 Puis ouvrez : http://localhost:3006${NC}"
echo ""
echo -e "${GREEN}✨ NOUVEAU PORT 3006 - AUCUN CACHE !${NC}"
echo ""
echo "🎯 Le design Math4Child authentique vous attend !"

print_success "Solution nucléaire terminée !"
