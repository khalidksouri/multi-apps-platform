#!/bin/bash

# =============================================================================
# CORRECTION FINALE MATH4CHILD - RÉSOLUTION ASSETPREFIX + GOOGLE FONTS
# =============================================================================

set -e

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
echo "║   🔧 CORRECTION FINALE - ASSETPREFIX + GOOGLE FONTS     ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

print_info "Correction de l'erreur assetPrefix avec Google Fonts..."

# 1. CORRECTION NEXT.CONFIG.JS - VERSION FINALE
print_info "Configuration Next.js - Version finale sans assetPrefix problématique..."
cat > "next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const isProd = process.env.NODE_ENV === 'production';
const isCapacitor = process.env.CAPACITOR_BUILD === 'true';

const nextConfig = {
  // Configuration d'export pour Capacitor
  ...(isProd && {
    output: 'export',
    trailingSlash: true,
    distDir: 'out',
  }),
  
  // Configuration des images
  images: {
    domains: ['www.math4child.com', 'math4child.com'],
    unoptimized: true,
  },
  
  // SUPPRESSION ASSETPREFIX - Cause du problème avec Google Fonts
  // Capacitor peut fonctionner sans assetPrefix
  
  // Configuration Webpack
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        tls: false,
      };
    }
    return config;
  },
  
  // Configuration expérimentale
  experimental: {
    optimizePackageImports: ['lucide-react'],
  },
  
  // Variables d'environnement
  env: {
    CAPACITOR_PLATFORM: process.env.CAPACITOR_PLATFORM || 'web',
    CAPACITOR_BUILD: process.env.CAPACITOR_BUILD || 'false',
  },
  
  // Pas de headers personnalisés en mode export (cause des warnings)
  // Les headers seront gérés par le serveur en production
};

module.exports = nextConfig;
EOF

# 2. CORRECTION LAYOUT.TSX - GOOGLE FONTS AVEC FALLBACK
print_info "Correction du layout.tsx avec gestion Google Fonts fallback..."
cat > "src/app/layout.tsx" << 'EOF'
import { Inter } from 'next/font/google'
import './globals.css'

// Configuration Google Fonts avec fallback pour Capacitor
const inter = Inter({ 
  subsets: ['latin'],
  display: 'swap',
  fallback: ['system-ui', 'arial'] // Fallback pour Capacitor
})

export const metadata = {
  title: 'Math4Child.com - Apprendre les maths en s\'amusant',
  description: 'Application éducative de mathématiques pour enfants. 195+ langues supportées, 5 niveaux de difficulté.',
  manifest: '/manifest.json',
  themeColor: '#667eea',
  viewport: {
    width: 'device-width',
    initialScale: 1,
    maximumScale: 1,
    userScalable: false,
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
        <meta name="theme-color" content="#667eea" />
        <link rel="icon" href="/favicon.ico" />
        <link rel="manifest" href="/manifest.json" />
        {/* Preload Google Fonts pour performance */}
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
      </head>
      <body className={`${inter.className} overflow-x-hidden`}>
        <div id="capacitor-app">
          {children}
        </div>
      </body>
    </html>
  )
}
EOF

# 3. ALTERNATIVE SANS GOOGLE FONTS SI PROBLÈME PERSISTE
print_info "Création d'une version sans Google Fonts en backup..."
cat > "src/app/layout.backup.tsx" << 'EOF'
import './globals.css'

export const metadata = {
  title: 'Math4Child.com - Apprendre les maths en s\'amusant',
  description: 'Application éducative de mathématiques pour enfants. 195+ langues supportées, 5 niveaux de difficulté.',
  manifest: '/manifest.json',
  themeColor: '#667eea',
  viewport: {
    width: 'device-width',
    initialScale: 1,
    maximumScale: 1,
    userScalable: false,
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
        <meta name="theme-color" content="#667eea" />
        <link rel="icon" href="/favicon.ico" />
        <link rel="manifest" href="/manifest.json" />
      </head>
      <body className="font-sans overflow-x-hidden">
        <div id="capacitor-app">
          {children}
        </div>
      </body>
    </html>
  )
}
EOF

# 4. MISE À JOUR CSS AVEC FALLBACK FONTS
print_info "Mise à jour CSS avec fallback fonts..."
cat > "src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Import Google Fonts avec fallback */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

/* Fallback font system pour Capacitor */
@layer base {
  body {
    font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  }
}

/* Support RTL */
[dir="rtl"] {
  direction: rtl;
}

/* Animations personnalisées */
@keyframes blob {
  0% { transform: translate(0px, 0px) scale(1); }
  33% { transform: translate(30px, -50px) scale(1.1); }
  66% { transform: translate(-20px, 20px) scale(0.9); }
  100% { transform: translate(0px, 0px) scale(1); }
}

.animate-blob {
  animation: blob 7s infinite;
}

/* Scrollbar personnalisée */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 4px;
}

/* Safe areas pour iOS */
.safe-area-bottom {
  padding-bottom: env(safe-area-inset-bottom, 16px);
}

.safe-area-top {
  padding-top: env(safe-area-inset-top, 0px);
}

/* Optimisations Capacitor */
.capacitor-app {
  -webkit-overflow-scrolling: touch;
  touch-action: manipulation;
}

/* Fixes pour mobile */
input, textarea, button {
  -webkit-appearance: none;
  border-radius: 0;
}

button {
  touch-action: manipulation;
}
EOF

# 5. CORRECTION DES VERSIONS CAPACITOR (RÉSOLUTION DES WARNINGS)
print_info "Correction des versions Capacitor pour éviter les warnings..."

# Installer des versions cohérentes
npm install @capacitor/core@6.1.2 @capacitor/cli@6.1.2 --save-dev
npm install @capacitor/android@6.1.2 @capacitor/ios@6.1.2 --save
npm install @capacitor/app@6.0.1 @capacitor/haptics@6.0.1 @capacitor/keyboard@6.0.2 @capacitor/status-bar@6.0.1 @capacitor/splash-screen@6.0.2 --save

# 6. TEST DE BUILD SANS ASSETPREFIX
print_info "Test de build sans assetPrefix..."
if CAPACITOR_BUILD=true npm run build:capacitor; then
    print_success "🎉 BUILD RÉUSSI sans assetPrefix !"
else
    print_warning "Build échoué, utilisation du layout sans Google Fonts..."
    
    # Backup avec layout sans Google Fonts
    mv "src/app/layout.tsx" "src/app/layout.google.tsx"
    mv "src/app/layout.backup.tsx" "src/app/layout.tsx"
    
    print_info "Nouveau test de build sans Google Fonts..."
    if CAPACITOR_BUILD=true npm run build:capacitor; then
        print_success "🎉 BUILD RÉUSSI avec layout sans Google Fonts !"
        print_info "Google Fonts désactivées pour éviter l'erreur assetPrefix"
    else
        print_error "Build échoue toujours, vérifiez la configuration"
        # Restaurer layout original
        mv "src/app/layout.google.tsx" "src/app/layout.tsx"
        exit 1
    fi
fi

# 7. SYNCHRONISATION CAPACITOR
print_info "Synchronisation Capacitor..."
npx cap sync

# 8. CRÉATION D'UN SCRIPT DE DEBUG
print_info "Création d'un script de debug..."
cat > "debug_build.sh" << 'EOF'
#!/bin/bash

echo "🔍 DEBUG BUILD MATH4CHILD"
echo "=========================="

echo "1. Variables d'environnement:"
echo "NODE_ENV: $NODE_ENV"
echo "CAPACITOR_BUILD: $CAPACITOR_BUILD"

echo ""
echo "2. Versions installées:"
echo "Next.js: $(npx next --version)"
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"

echo ""
echo "3. Structure des fichiers:"
ls -la src/app/

echo ""
echo "4. Test build step by step:"
echo "🔸 Nettoyage..."
rm -rf .next out

echo "🔸 Build Next.js..."
NODE_ENV=production next build

echo "🔸 Export statique..."
NODE_ENV=production next export

echo "🔸 Vérification dossier out/..."
ls -la out/

echo "✅ Debug terminé"
EOF

chmod +x debug_build.sh

# 9. GUIDE DE RÉSOLUTION RAPIDE
print_info "Création du guide de résolution rapide..."
cat > "QUICK_FIX_GUIDE.md" << 'EOF'
# 🚑 Guide de Résolution Rapide - Math4Child

## ❌ Problème assetPrefix résolu

### 🔧 Solutions appliquées:

1. **Suppression assetPrefix** - Next.js export + Google Fonts incompatible
2. **Layout avec fallback** - Fonts système si Google Fonts échoue  
3. **Versions Capacitor cohérentes** - Suppression des warnings
4. **Configuration Next.js simplifiée** - Suppression des headers en mode export

### 🚀 Tests de validation:

```bash
# Test build simple
npm run build:web

# Test build Capacitor
CAPACITOR_BUILD=true npm run build:capacitor

# Debug complet
./debug_build.sh
```

### 🔍 Si problème persiste:

1. **Vérifier les versions:**
```bash
node --version  # Doit être >=18
npm --version
npx next --version
```

2. **Nettoyer complètement:**
```bash
rm -rf .next out node_modules package-lock.json
npm install
```

3. **Test sans Google Fonts:**
```bash
# Utiliser le layout sans Google Fonts
mv src/app/layout.tsx src/app/layout.google.tsx
mv src/app/layout.backup.tsx src/app/layout.tsx
npm run build:capacitor
```

### 🎯 Configuration finale:

- ✅ assetPrefix supprimé (cause du problème)
- ✅ Google Fonts avec fallback système  
- ✅ Capacitor versions cohérentes (6.x)
- ✅ Next.js export optimisé
- ✅ CSS avec safe-areas iOS

### 📱 Commandes de déploiement:

```bash
# Android
npm run android:build

# iOS  
npm run ios:build

# Web
npm run build:web
```

## ✅ Status: RÉSOLU !
EOF

print_success "🎉 CORRECTION FINALE APPLIQUÉE !"
print_success "✅ AssetPrefix problématique supprimé"
print_success "✅ Google Fonts avec fallback système" 
print_success "✅ Versions Capacitor cohérentes"
print_success "✅ Configuration Next.js optimisée"

echo ""
print_info "📋 Prochaines étapes :"
echo -e "${YELLOW}1. Test: npm run build:capacitor${NC}"
echo -e "${YELLOW}2. Android: npm run android:build${NC}"
echo -e "${YELLOW}3. iOS: npm run ios:build${NC}"
echo -e "${YELLOW}4. Si problème: ./debug_build.sh${NC}"

echo ""
print_info "📚 Documentation créée :"
echo -e "${YELLOW}- QUICK_FIX_GUIDE.md (guide de résolution)${NC}"
echo -e "${YELLOW}- debug_build.sh (script de debug)${NC}"
echo -e "${YELLOW}- layout.backup.tsx (version sans Google Fonts)${NC}"

print_success "🚀 Math4Child prêt pour le déploiement mobile !"
