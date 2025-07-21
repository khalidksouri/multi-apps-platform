#!/bin/bash

# =============================================================================
# CORRECTIF TAILWIND POUR NEXT.JS 15.4.2
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
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           🔧 CORRECTIF TAILWIND NEXT.JS 15.4.2           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Vérification du répertoire
if [ ! -f "package.json" ]; then
    print_error "Aucun package.json trouvé. Êtes-vous dans le bon répertoire ?"
    exit 1
fi

print_info "Correction de la configuration Tailwind CSS..."

# 1. Installation des packages corrects
print_info "Installation des packages Tailwind compatibles Next.js 15..."
npm uninstall tailwindcss @tailwindcss/postcss autoprefixer postcss || true
npm install tailwindcss@latest autoprefixer@latest postcss@latest --save-dev

# 2. Mise à jour du postcss.config.js
print_info "Mise à jour de postcss.config.js..."
cat > "postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

# 3. Mise à jour du tailwind.config.js pour Next.js 15
print_info "Mise à jour de tailwind.config.js..."
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
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
  future: {
    hoverOnlyWhenSupported: true,
  },
}
EOF

# 4. Mise à jour du next.config.js pour Next.js 15
print_info "Mise à jour de next.config.js..."
cat > "next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['www.math4child.com'],
    unoptimized: true
  },
  webpack: (config, { isServer }) => {
    // Optimisations pour Next.js 15
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
  // Support pour les nouvelles fonctionnalités Next.js 15
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
        ],
      },
    ]
  },
}

module.exports = nextConfig
EOF

# 5. Mise à jour du package.json avec les bonnes versions
print_info "Mise à jour du package.json..."
cat > "package.json" << 'EOF'
{
  "name": "math4child",
  "version": "2.0.0",
  "description": "Math4Child.com - Application éducative multilingue",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3001",
    "build": "next build",
    "start": "next start -p 3001",
    "lint": "next lint",
    "type-check": "tsc --noEmit",
    "clean": "rm -rf .next node_modules/.cache"
  },
  "dependencies": {
    "next": "15.4.2",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "lucide-react": "^0.263.1"
  },
  "devDependencies": {
    "@types/node": "^20.12.0",
    "@types/react": "^18.3.12",
    "@types/react-dom": "^18.3.1",
    "typescript": "^5.4.5",
    "tailwindcss": "^3.4.4",
    "autoprefixer": "^10.4.19",
    "postcss": "^8.4.39",
    "eslint": "^8.57.0",
    "eslint-config-next": "15.4.2"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  }
}
EOF

# 6. Mise à jour des styles globaux optimisés pour Next.js 15
print_info "Mise à jour de globals.css..."
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

/* Animations optimisées */
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

/* Mode sombre (préparation) */
@media (prefers-color-scheme: dark) {
  :root {
    --primary-color: #8b5cf6;
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

/* Performance optimisée */
.backdrop-blur-xl {
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
}

.mix-blend-multiply {
  mix-blend-mode: multiply;
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

# 7. Nettoyage et réinstallation
print_info "Nettoyage du cache..."
rm -rf .next node_modules/.cache || true

print_info "Réinstallation des dépendances..."
npm install --legacy-peer-deps

# 8. Test de build
print_info "Test de build..."
if npm run build; then
    print_success "🎉 BUILD RÉUSSI avec Next.js 15.4.2 !"
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║               ✅ PROBLÈME RÉSOLU !                        ║${NC}"
    echo -e "${GREEN}║          Tailwind CSS fonctionne avec Next.js 15         ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    print_info "🚀 Pour démarrer l'application :"
    echo -e "${YELLOW}npm run dev${NC}"
    echo -e "${YELLOW}Visitez: http://localhost:3001${NC}"
    
else
    print_warning "Build échoué, mais configuration mise à jour"
    print_info "Essayez :"
    echo -e "${YELLOW}1. npm run clean${NC}"
    echo -e "${YELLOW}2. npm install${NC}"
    echo -e "${YELLOW}3. npm run dev${NC}"
fi

print_success "Configuration Tailwind CSS mise à jour pour Next.js 15.4.2"