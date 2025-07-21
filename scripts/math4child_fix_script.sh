#!/bin/bash

# =============================================================================
# SCRIPT DE CORRECTION MATH4CHILD - ERREUR CRITTERS
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
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║        🔧 CORRECTION ERREUR CRITTERS - MATH4CHILD 🔧            ║"
echo "║           Résolution du problème Next.js 15 + optimizeCss        ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Vérification du répertoire
if [[ ! -f "package.json" ]]; then
    print_error "Erreur: package.json introuvable. Exécutez ce script dans le dossier math4child."
    exit 1
fi

print_info "Répertoire de travail: $(pwd)"

# =============================================================================
# ÉTAPE 1: INSTALLATION DE CRITTERS
# =============================================================================
print_info "ÉTAPE 1: Installation du module critters..."
npm install critters --save-dev
print_success "Module critters installé"

# =============================================================================
# ÉTAPE 2: CORRECTION DE NEXT.CONFIG.JS
# =============================================================================
print_info "ÉTAPE 2: Correction de next.config.js..."
cat > "next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  images: {
    domains: ['www.math4child.com'],
    unoptimized: false
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
    // Désactivation temporaire de optimizeCss car problématique avec Next.js 15
    // optimizeCss: true,
  },
  swcMinify: true,
  poweredByHeader: false,
  generateEtags: false,
  compress: true,
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '2.0.0',
  },
}

module.exports = nextConfig
EOF
print_success "next.config.js corrigé"

# =============================================================================
# ÉTAPE 3: MISE À JOUR DE PACKAGE.JSON
# =============================================================================
print_info "ÉTAPE 3: Mise à jour des scripts package.json..."
cat > "package.json" << 'EOF'
{
  "name": "math4child-app",
  "version": "2.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "export": "next build && next export",
    "clean": "rm -rf .next out node_modules/.cache",
    "type-check": "tsc --noEmit",
    "test:build": "npm run build && echo 'Build successful!'"
  },
  "dependencies": {
    "@stripe/stripe-js": "^4.10.0",
    "lucide-react": "^0.469.0",
    "next": "15.4.2",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "stripe": "^17.4.0"
  },
  "devDependencies": {
    "@playwright/test": "^1.51.0",
    "@tailwindcss/postcss": "^4.1.11",
    "@types/node": "^20.17.10",
    "@types/react": "^18.2.48",
    "@types/react-dom": "^18.2.18",
    "@types/stripe": "^8.0.417",
    "autoprefixer": "^10.4.20",
    "babel-plugin-react-compiler": "0.0.0-experimental-6067d4e-20241221",
    "critters": "^0.0.22",
    "eslint": "^8.56.0",
    "eslint-config-next": "15.4.2",
    "jiti": "^1.21.6",
    "postcss": "^8.4.33",
    "sass": "^1.70.0",
    "tailwindcss": "^3.4.1",
    "typescript": "^5.7.3"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  }
}
EOF
print_success "package.json mis à jour"

# =============================================================================
# ÉTAPE 4: CORRECTION DU TAILWIND CONFIG
# =============================================================================
print_info "ÉTAPE 4: Vérification de tailwind.config.js..."
cat > "tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          200: '#bae6fd',
          300: '#7dd3fc',
          400: '#38bdf8',
          500: '#0ea5e9',
          600: '#0284c7',
          700: '#0369a1',
          800: '#075985',
          900: '#0c4a6e',
        },
        secondary: {
          50: '#fef7ee',
          100: '#fdedd7',
          200: '#fbd7ae',
          300: '#f8ba7a',
          400: '#f59444',
          500: '#f37420',
          600: '#e45916',
          700: '#bd4214',
          800: '#973518',
          900: '#7a2e16',
        }
      },
      fontFamily: {
        'display': ['Inter', 'system-ui', 'sans-serif'],
        'body': ['Inter', 'system-ui', 'sans-serif'],
      },
      animation: {
        'bounce-slow': 'bounce 2s infinite',
        'pulse-slow': 'pulse 3s infinite',
        'spin-slow': 'spin 3s linear infinite',
      }
    },
  },
  plugins: [],
  darkMode: 'class',
}
EOF
print_success "tailwind.config.js configuré"

# =============================================================================
# ÉTAPE 5: POSTCSS CONFIG
# =============================================================================
print_info "ÉTAPE 5: Configuration PostCSS..."
cat > "postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
print_success "postcss.config.js configuré"

# =============================================================================
# ÉTAPE 6: NETTOYAGE ET RÉINSTALLATION
# =============================================================================
print_info "ÉTAPE 6: Nettoyage complet..."
rm -rf .next out node_modules/.cache
print_success "Cache nettoyé"

print_info "Réinstallation des dépendances..."
npm install
print_success "Dépendances installées"

# =============================================================================
# ÉTAPE 7: TEST DE BUILD
# =============================================================================
print_info "ÉTAPE 7: Test de build..."
if npm run build; then
    print_success "Build réussi ! 🎉"
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║                    ✅ CORRECTION RÉUSSIE ✅                      ║"
    echo "║                                                                   ║"
    echo "║  🎯 Math4Child est maintenant prêt !                            ║"
    echo "║  📦 Build terminé sans erreurs                                   ║"
    echo "║  🚀 Vous pouvez démarrer avec: npm run dev                      ║"
    echo "║                                                                   ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
else
    print_error "Build échoué. Diagnostic en cours..."
    
    print_info "Diagnostic: Tentative avec build simplifié..."
    
    # Configuration Next.js encore plus simple
    cat > "next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    unoptimized: true
  },
  swcMinify: true,
  poweredByHeader: false,
}

module.exports = nextConfig
EOF
    
    print_info "Test avec configuration simplifiée..."
    if npm run build; then
        print_success "Build réussi avec configuration simplifiée !"
    else
        print_error "Build encore en échec. Vérifiez les logs ci-dessus."
        echo ""
        print_info "Solutions possibles :"
        echo "1. Vérifiez la version de Node.js (minimum 18.0.0)"
        echo "2. Supprimez node_modules et package-lock.json puis réinstallez"
        echo "3. Vérifiez l'espace disque disponible"
        echo "4. Consultez les logs d'erreur pour plus de détails"
    fi
fi

echo ""
print_info "Script terminé. Consultez les messages ci-dessus pour le statut."