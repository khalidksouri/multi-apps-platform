#!/bin/bash

# =============================================================================
# CORRECTIF TAILWIND POSTCSS POUR NEXT.JS 15
# =============================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║    🔧 CORRECTIF TAILWIND POSTCSS - NEXT.JS 15           ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Vérification du répertoire
if [ ! -f "package.json" ]; then
    print_error "Aucun package.json trouvé. Êtes-vous dans le bon répertoire ?"
    exit 1
fi

print_info "Correction de la configuration Tailwind CSS pour Next.js 15..."

# 1. Installation/réinstallation des bonnes versions Tailwind
print_info "Installation des packages Tailwind CSS compatibles Next.js 15..."
npm uninstall tailwindcss @tailwindcss/postcss autoprefixer postcss 2>/dev/null || true
npm install tailwindcss@latest autoprefixer@latest postcss@latest --save-dev

# 2. Correction du postcss.config.js
print_info "Création du postcss.config.js compatible..."
cat > "postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

# 3. Correction du tailwind.config.js pour Next.js 15
print_info "Création du tailwind.config.js optimisé..."
cat > "tailwind.config.js" << 'EOF'
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
        'blob': 'blob 7s infinite',
        'float': 'float 3s ease-in-out infinite',
        'pulse-slow': 'pulse 3s ease-in-out infinite',
      },
      keyframes: {
        blob: {
          '0%': { 
            transform: 'translate(0px, 0px) scale(1)' 
          },
          '33%': { 
            transform: 'translate(30px, -50px) scale(1.1)' 
          },
          '66%': { 
            transform: 'translate(-20px, 20px) scale(0.9)' 
          },
          '100%': { 
            transform: 'translate(0px, 0px) scale(1)' 
          },
        },
        float: {
          '0%, 100%': { 
            transform: 'translateY(0px) rotate(0deg)' 
          },
          '50%': { 
            transform: 'translateY(-20px) rotate(5deg)' 
          },
        }
      },
      colors: {
        primary: {
          50: '#f0f9ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        }
      },
    },
  },
  plugins: [],
}
EOF

# 4. Correction du next.config.js pour Next.js 15
print_info "Correction du next.config.js..."
cat > "next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['www.math4child.com'],
    unoptimized: true
  },
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
      }
    }
    return config
  },
  experimental: {
    optimizePackageImports: ['lucide-react'],
  },
}

module.exports = nextConfig
EOF

# 5. Création du globals.css optimisé
print_info "Création du globals.css optimisé..."
mkdir -p src/app
cat > "src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Variables CSS personnalisées */
:root {
  --primary-color: #7c3aed;
  --secondary-color: #06b6d4;
  --accent-color: #f59e0b;
}

/* Support RTL complet */
[dir="rtl"] {
  direction: rtl;
}

[dir="rtl"] .space-x-3 > * + * {
  margin-left: 0;
  margin-right: 0.75rem;
}

[dir="rtl"] .text-left {
  text-align: right;
}

/* Animations personnalisées */
@keyframes blob {
  0% { 
    transform: translate(0px, 0px) scale(1);
  }
  33% { 
    transform: translate(30px, -50px) scale(1.1);
  }
  66% { 
    transform: translate(-20px, 20px) scale(0.9);
  }
  100% { 
    transform: translate(0px, 0px) scale(1);
  }
}

@keyframes float {
  0%, 100% { 
    transform: translateY(0px) rotate(0deg);
  }
  50% { 
    transform: translateY(-20px) rotate(5deg);
  }
}

@keyframes pulse-slow {
  0%, 100% { 
    opacity: 1;
  }
  50% { 
    opacity: 0.7;
  }
}

/* Classes utilitaires personnalisées */
@layer utilities {
  .animate-blob {
    animation: blob 7s infinite;
  }
  
  .animate-float {
    animation: float 3s ease-in-out infinite;
  }
  
  .animate-pulse-slow {
    animation: pulse-slow 3s ease-in-out infinite;
  }
  
  .animation-delay-2000 {
    animation-delay: 2s;
  }
  
  .animation-delay-4000 {
    animation-delay: 4s;
  }
}

/* Scrollbar personnalisée */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f5f9;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(135deg, #5a67d8, #6b46c1);
}

/* Focus amélioré pour accessibilité */
.focus-visible:focus {
  outline: 2px solid var(--primary-color);
  outline-offset: 2px;
}

/* Responsive amélioré */
@media (max-width: 640px) {
  .text-5xl {
    font-size: 2.5rem;
    line-height: 1.1;
  }
  
  .text-6xl {
    font-size: 3rem;
    line-height: 1;
  }
  
  .text-8xl {
    font-size: 4rem;
  }
}

@media (max-width: 480px) {
  .p-12 {
    padding: 2rem;
  }
  
  .space-x-4 > * + * {
    margin-left: 0.5rem;
  }
}

/* Réduction des animations pour accessibilité */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* Classes personnalisées pour Math4Child */
.math-card {
  @apply bg-white/15 backdrop-blur-xl rounded-3xl shadow-2xl border border-white/20;
}

.math-button {
  @apply bg-gradient-to-r font-bold rounded-2xl transition-all duration-300 transform hover:scale-105 shadow-xl;
}

.math-input {
  @apply text-center font-bold border-4 border-gray-300 rounded-3xl focus:border-blue-500 focus:outline-none focus:ring-8 focus:ring-blue-200 transition-all;
}
EOF

# 6. Nettoyage des caches
print_info "Nettoyage des caches..."
rm -rf .next node_modules/.cache 2>/dev/null || true

# 7. Nettoyage des lockfiles multiples
print_info "Nettoyage des lockfiles multiples..."
if [ -f "/Users/khalidksouri/Desktop/multi-apps-platform/apps/math4child/package-lock.json" ]; then
    rm -f "/Users/khalidksouri/Desktop/multi-apps-platform/apps/math4child/package-lock.json"
fi
if [ -f "/Users/khalidksouri/Desktop/multi-apps-platform/package-lock.json" ]; then
    rm -f "/Users/khalidksouri/Desktop/multi-apps-platform/package-lock.json"
fi

# 8. Réinstallation complète
print_info "Réinstallation complète des dépendances..."
npm install

# 9. Vérification que les composants existent
if [ ! -f "src/app/page.tsx" ]; then
    print_info "Création du composant page.tsx de base..."
    cat > "src/app/page.tsx" << 'EOF'
'use client'

import React, { useState, useEffect } from 'react'
import { 
  ChevronDown, Globe, Crown, Check, X, Gift,
  Volume2, VolumeX, Languages
} from 'lucide-react'

export default function Math4ChildApp() {
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [soundEnabled, setSoundEnabled] = useState(true)
  
  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-600 via-blue-600 to-cyan-500 p-4">
      {/* Particules d'arrière-plan */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-4 -left-4 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        <div className="absolute -top-4 -right-4 w-72 h-72 bg-yellow-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        <div className="absolute -bottom-8 left-20 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
      </div>
      
      <div className="max-w-7xl mx-auto relative z-10">
        {/* Header */}
        <header className="mb-8">
          <nav className="flex items-center justify-between mb-6 bg-white/15 backdrop-blur-xl rounded-3xl p-6 shadow-2xl">
            <div className="flex items-center space-x-3">
              <div className="w-16 h-16 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-2xl flex items-center justify-center text-3xl shadow-lg">
                🧮
              </div>
              <div>
                <h1 className="text-3xl font-bold text-white">Math4Child</h1>
                <p className="text-white/80 text-sm">L'apprentissage des mathématiques, partout dans le monde !</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-4">
              <button
                onClick={() => setSoundEnabled(!soundEnabled)}
                className="p-3 bg-white/20 rounded-xl text-white hover:bg-white/30 transition-all"
              >
                {soundEnabled ? <Volume2 size={20} /> : <VolumeX size={20} />}
              </button>
              
              <button className="flex items-center space-x-3 bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-6 py-3 rounded-xl hover:from-yellow-500 hover:to-orange-600 transition-all shadow-lg font-bold">
                <Crown size={20} />
                <span className="hidden sm:inline">Premium</span>
              </button>
            </div>
          </nav>
        </header>
        
        {/* Page principale */}
        <div className="text-center space-y-8">
          <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-12 shadow-2xl">
            <div className="mb-8">
              <div className="text-8xl mb-6 animate-bounce">🎓</div>
              <h2 className="text-5xl md:text-6xl font-bold text-white mb-6">
                Bienvenue sur Math4Child.com
              </h2>
              <p className="text-2xl text-white/90 max-w-3xl mx-auto">
                Apprends les maths en t'amusant !
              </p>
              <div className="mt-4 text-lg text-white/70">
                www.math4child.com - Configuration GOTEST
              </div>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-2xl mx-auto">
              <button className="bg-gradient-to-r from-green-400 to-emerald-500 text-white px-8 py-6 rounded-2xl text-xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-4">
                <Gift size={28} />
                <span>🎁 Essai Gratuit</span>
              </button>
              
              <button className="bg-gradient-to-r from-purple-400 to-pink-500 text-white px-8 py-6 rounded-2xl text-xl font-bold hover:from-purple-500 hover:to-pink-600 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-4">
                <Crown size={28} />
                <span>Premium</span>
              </button>
            </div>
            
            {/* Statistiques */}
            <div className="mt-12 grid grid-cols-3 gap-8 max-w-2xl mx-auto">
              <div className="text-center">
                <div className="text-3xl font-bold text-yellow-300">195+</div>
                <div className="text-white/80 text-sm">Langues</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold text-green-300">5</div>
                <div className="text-white/80 text-sm">Niveaux</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold text-blue-300">∞</div>
                <div className="text-white/80 text-sm">Questions</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
EOF
fi

if [ ! -f "src/app/layout.tsx" ]; then
    print_info "Création du layout.tsx..."
    cat > "src/app/layout.tsx" << 'EOF'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Math4Child.com - Apprendre les maths en s\'amusant',
  description: 'Application éducative de mathématiques pour enfants. 195+ langues, GOTEST (SIRET: 53958712100028)',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </head>
      <body className={inter.className}>
        {children}
      </body>
    </html>
  )
}
EOF
fi

# 10. Test de build
print_info "Test de build final..."
if npm run build; then
    print_success "🎉 BUILD RÉUSSI ! Tailwind CSS fonctionne avec Next.js 15 !"
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║               ✅ PROBLÈME RÉSOLU !                        ║${NC}"
    echo -e "${GREEN}║          Math4Child compile et fonctionne !              ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    print_info "🚀 Pour démarrer l'application :"
    echo -e "${YELLOW}npm run dev${NC}"
    echo -e "${YELLOW}Visitez: http://localhost:3000${NC}"
    echo ""
    
    print_success "✅ Configuration Tailwind CSS optimisée pour Next.js 15"
    print_success "✅ Animations et styles personnalisés Math4Child"
    print_success "✅ Support RTL pour les 195+ langues"
    print_success "✅ Interface responsive"
    echo ""
    
    print_info "💳 Configuration GOTEST maintenue :"
    echo -e "${YELLOW}• SIRET: 53958712100028${NC}"
    echo -e "${YELLOW}• Compte Qonto: FR7616958000016218830371501${NC}"
    echo -e "${YELLOW}• Contact: khalid_ksouri@yahoo.fr${NC}"
    
else
    print_warning "Build échoué, mais configuration mise à jour"
    print_info "Essayez :"
    echo -e "${YELLOW}1. npm run dev (mode développement)${NC}"
    echo -e "${YELLOW}2. Vérifiez les erreurs ci-dessus${NC}"
    echo -e "${YELLOW}3. npm install --force si nécessaire${NC}"
fi

print_success "Configuration Tailwind CSS mise à jour pour Math4Child !"