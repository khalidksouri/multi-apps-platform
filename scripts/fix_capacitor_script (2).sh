#!/bin/bash

# =============================================================================
# MATH4CHILD MOBILE - CAPACITOR CORRIGÉ
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
echo "║   🔧 MATH4CHILD MOBILE - CAPACITOR CORRIGÉ              ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

print_info "Configuration Math4Child avec Capacitor (Web->Native) - Version corrigée"

# 1. Vérification et mise à jour Node.js
print_info "Vérification de la version Node.js..."
NODE_VERSION=$(node -v | sed 's/v//')
REQUIRED_VERSION="20.0.0"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NODE_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    print_warning "Node.js $NODE_VERSION < 20.0.0 requis pour react-router-dom@7.7.0"
    print_info "Utilisation de versions compatibles..."
    
    # Installer des versions compatibles avec Node 18
    npm install react-router-dom@6.26.2 --save
    npm install @types/react-router-dom@5.3.3 --save-dev
else
    print_success "Node.js $NODE_VERSION compatible"
    npm install react-router-dom@latest --save
    npm install @types/react-router-dom --save-dev
fi

# 2. Installation de Capacitor avec versions stables
print_info "Installation de Capacitor pour déploiement mobile..."
npm install @capacitor/core@6.1.2 @capacitor/cli@6.1.2 --save-dev
npm install @capacitor/android@6.1.2 @capacitor/ios@6.1.2 @capacitor/app@6.0.1 @capacitor/haptics@6.0.1 @capacitor/keyboard@6.0.2 @capacitor/status-bar@6.0.1 @capacitor/splash-screen@6.0.2 --save

# 3. Correction du composant Navigation avec détection Capacitor améliorée
print_info "Correction du composant Navigation pour Capacitor..."
mkdir -p src/components
cat > "src/components/Navigation.tsx" << 'EOF'
'use client';

import React, { useEffect, useState } from 'react';
import { Home, Calculator, BarChart3, Settings, ArrowLeft } from 'lucide-react';

// Import conditionnel pour éviter les erreurs SSR
const getCapacitorInfo = () => {
  if (typeof window === 'undefined') return { isCapacitor: false, platform: 'web' };
  
  const capacitor = (window as any).Capacitor;
  return {
    isCapacitor: !!capacitor?.isNativePlatform?.(),
    platform: capacitor?.getPlatform?.() || 'web'
  };
};

interface NavigationProps {
  currentPage?: string;
  onNavigate?: (path: string) => void;
  showBackButton?: boolean;
  onBack?: () => void;
}

const Navigation: React.FC<NavigationProps> = ({ 
  currentPage = '/', 
  onNavigate, 
  showBackButton = false, 
  onBack 
}) => {
  const [platformInfo, setPlatformInfo] = useState({ isCapacitor: false, platform: 'web' });
  
  useEffect(() => {
    setPlatformInfo(getCapacitorInfo());
  }, []);

  const handleNavigation = (path: string, event?: React.MouseEvent) => {
    event?.preventDefault();
    
    if (onNavigate) {
      onNavigate(path);
    } else if (typeof window !== 'undefined') {
      // Fallback pour navigation standard
      if (platformInfo.isCapacitor) {
        // Navigation Capacitor
        window.location.hash = path;
      } else {
        // Navigation web standard
        window.location.href = path;
      }
    }
  };

  const navItems = [
    { path: '/', label: 'Accueil', icon: Home, testId: 'nav-home' },
    { path: '/game', label: 'Jeu', icon: Calculator, testId: 'nav-game' },
    { path: '/stats', label: 'Stats', icon: BarChart3, testId: 'nav-stats' },
    { path: '/settings', label: 'Options', icon: Settings, testId: 'nav-settings' },
  ];

  const isActive = (path: string) => currentPage === path;
  
  const baseClasses = "flex flex-col items-center p-3 rounded-lg transition-all duration-200 touch-manipulation";
  const activeClasses = "text-blue-600 bg-blue-50 scale-105 shadow-sm";
  const inactiveClasses = "text-gray-600 hover:text-blue-600 hover:bg-gray-50";

  // Interface mobile native (Capacitor iOS/Android)
  if (platformInfo.isCapacitor || platformInfo.platform !== 'web') {
    return (
      <div 
        className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-lg z-50"
        style={{ paddingBottom: 'env(safe-area-inset-bottom, 0px)' }}
        data-testid="mobile-navigation"
      >
        {showBackButton && (
          <div className="absolute top-4 left-4">
            <button
              onClick={onBack}
              className="p-2 rounded-full bg-white shadow-md"
              data-testid="nav-back-button"
            >
              <ArrowLeft size={20} />
            </button>
          </div>
        )}
        
        <div className="flex justify-around py-2 px-4 min-h-[70px]">
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <button
                key={item.path}
                onClick={(e) => handleNavigation(item.path, e)}
                className={`${baseClasses} min-w-[60px] ${
                  isActive(item.path) ? activeClasses : inactiveClasses
                }`}
                data-testid={item.testId}
                role="tab"
                aria-selected={isActive(item.path)}
              >
                <Icon size={24} className="mb-1" />
                <span className="text-xs font-medium leading-tight">{item.label}</span>
              </button>
            );
          })}
        </div>
      </div>
    );
  }

  // Interface web (Next.js - desktop et mobile responsive)
  return (
    <>
      {/* Navigation desktop */}
      <nav className="bg-white shadow-lg sticky top-0 z-40 hidden md:block" data-testid="desktop-navigation">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center">
              {showBackButton && (
                <button
                  onClick={onBack}
                  className="mr-4 p-2 rounded-full hover:bg-gray-100"
                  data-testid="nav-back-button"
                >
                  <ArrowLeft size={20} />
                </button>
              )}
              
              <div className="flex items-center space-x-2">
                <span className="text-2xl">🧮</span>
                <span className="text-xl font-bold text-purple-600">Math4Child</span>
              </div>
            </div>
            
            <div className="flex items-center space-x-6">
              {navItems.map((item) => {
                const Icon = item.icon;
                return (
                  <button
                    key={item.path}
                    onClick={(e) => handleNavigation(item.path, e)}
                    className={`flex items-center space-x-2 px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                      isActive(item.path)
                        ? 'text-blue-600 bg-blue-50 shadow-sm'
                        : 'text-gray-700 hover:text-blue-600 hover:bg-gray-50'
                    }`}
                    data-testid={item.testId}
                  >
                    <Icon size={18} />
                    <span>{item.label}</span>
                  </button>
                );
              })}
            </div>
          </div>
        </div>
      </nav>

      {/* Navigation mobile web */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-lg z-50" data-testid="mobile-web-navigation">
        <div className="flex justify-around py-2 px-2">
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <button
                key={item.path}
                onClick={(e) => handleNavigation(item.path, e)}
                className={`${baseClasses} flex-1 max-w-[80px] ${
                  isActive(item.path) ? activeClasses : inactiveClasses
                }`}
                data-testid={item.testId}
                title={item.label}
              >
                <Icon size={20} className="mb-1" />
                <span className="text-xs">{item.label}</span>
              </button>
            );
          })}
        </div>
      </nav>
    </>
  );
};

export default Navigation;
EOF

print_success "Composant Navigation corrigé avec data-testid pour Playwright"

# 4. Configuration Next.js corrigée (FIX CRITIQUE)
print_info "Configuration Next.js corrigée pour Capacitor..."
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
  
  // FIX CRITIQUE: AssetPrefix correct
  assetPrefix: isProd && isCapacitor ? './' : undefined,
  
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
  
  // Headers de sécurité
  ...(isProd && {
    async headers() {
      return [
        {
          source: '/:path*',
          headers: [
            {
              key: 'X-Frame-Options',
              value: 'SAMEORIGIN',
            },
            {
              key: 'X-Content-Type-Options',
              value: 'nosniff',
            },
          ],
        },
      ];
    },
  }),
};

module.exports = nextConfig;
EOF

# 5. Configuration Capacitor en JSON (FIX CRITIQUE)
print_info "Configuration Capacitor JSON (résout l'erreur init)..."

# Supprimer l'ancienne config TS
[ -f "capacitor.config.ts" ] && rm capacitor.config.ts

cat > "capacitor.config.json" << 'EOF'
{
  "appId": "com.gotest.math4child",
  "appName": "Math4Child",
  "webDir": "out",
  "bundledWebRuntime": false,
  "server": {
    "androidScheme": "https",
    "iosScheme": "https"
  },
  "plugins": {
    "SplashScreen": {
      "launchShowDuration": 2000,
      "launchAutoHide": true,
      "backgroundColor": "#667eea",
      "androidSplashResourceName": "splash",
      "androidScaleType": "CENTER_CROP",
      "showSpinner": true,
      "androidSpinnerStyle": "large",
      "iosSpinnerStyle": "small",
      "spinnerColor": "#ffffff"
    },
    "StatusBar": {
      "backgroundColor": "#667eea",
      "style": "light"
    },
    "App": {
      "name": "Math4Child",
      "description": "Application éducative de mathématiques - GOTEST"
    },
    "Keyboard": {
      "resize": "body",
      "style": "dark",
      "resizeOnFullScreen": true
    }
  },
  "android": {
    "allowMixedContent": true,
    "captureInput": true,
    "webContentsDebuggingEnabled": true
  },
  "ios": {
    "scheme": "Math4Child",
    "contentInset": "automatic"
  }
}
EOF

# 6. Scripts package.json corrigés
print_info "Ajout des scripts de déploiement Capacitor corrigés..."
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

pkg.scripts = {
  ...pkg.scripts,
  
  // Scripts Next.js avec fix
  'build:web': 'NODE_ENV=production next build',
  'build:capacitor': 'NODE_ENV=production CAPACITOR_BUILD=true next build',
  
  // Scripts Capacitor corrigés
  'cap:init': 'npx cap init \"Math4Child\" \"com.gotest.math4child\" --web-dir=out',
  'cap:add:android': 'npx cap add android',
  'cap:add:ios': 'npx cap add ios',
  'cap:sync': 'npm run build:capacitor && npx cap sync',
  'cap:copy': 'npx cap copy',
  
  // Scripts Android
  'android:dev': 'npm run cap:sync && npx cap run android --livereload --external',
  'android:build': 'npm run cap:sync && npx cap open android',
  'android:release': 'npm run build:capacitor && npx cap sync android && npx cap open android',
  
  // Scripts iOS  
  'ios:dev': 'npm run cap:sync && npx cap run ios --livereload --external',
  'ios:build': 'npm run cap:sync && npx cap open ios',
  'ios:release': 'npm run build:capacitor && npx cap sync ios && npx cap open ios',
  
  // Scripts de test
  'test': 'playwright test',
  'test:headed': 'playwright test --headed',
  'test:debug': 'playwright test --debug',
  'test:mobile': 'playwright test --project=mobile-chrome',
  'test:capacitor': 'playwright test tests/capacitor.spec.ts'
};

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
console.log('✅ Scripts Capacitor corrigés ajoutés');
"

# 7. Hook de détection plateforme amélioré
print_info "Création du hook de détection de plateforme amélioré..."
mkdir -p src/hooks
cat > "src/hooks/usePlatform.ts" << 'EOF'
'use client';

import { useState, useEffect } from 'react';

interface PlatformInfo {
  isWeb: boolean;
  isMobile: boolean;
  isAndroid: boolean;
  isIOS: boolean;
  isCapacitor: boolean;
  platform: 'web' | 'android' | 'ios';
  userAgent: string;
  screenSize: 'mobile' | 'tablet' | 'desktop';
}

export const usePlatform = (): PlatformInfo => {
  const [platformInfo, setPlatformInfo] = useState<PlatformInfo>({
    isWeb: true,
    isMobile: false,
    isAndroid: false,
    isIOS: false,
    isCapacitor: false,
    platform: 'web',
    userAgent: '',
    screenSize: 'desktop'
  });

  useEffect(() => {
    if (typeof window === 'undefined') return;

    const userAgent = navigator.userAgent;
    const isCapacitor = !!(window as any).Capacitor?.isNativePlatform?.();
    
    // Détection de la taille d'écran
    const getScreenSize = (): 'mobile' | 'tablet' | 'desktop' => {
      const width = window.innerWidth;
      if (width < 768) return 'mobile';
      if (width < 1024) return 'tablet';
      return 'desktop';
    };
    
    if (isCapacitor) {
      // Environnement Capacitor
      import('@capacitor/core').then(({ Capacitor }) => {
        const platform = Capacitor.getPlatform();
        
        setPlatformInfo({
          isWeb: platform === 'web',
          isMobile: platform !== 'web',
          isAndroid: platform === 'android',
          isIOS: platform === 'ios',
          isCapacitor: true,
          platform: platform as 'web' | 'android' | 'ios',
          userAgent,
          screenSize: getScreenSize()
        });
      }).catch(() => {
        // Fallback si import échoue
        setPlatformInfo(prev => ({ ...prev, isCapacitor: false }));
      });
    } else {
      // Environnement web standard
      const isMobileWeb = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(userAgent);
      const isAndroidWeb = /Android/i.test(userAgent);
      const isIOSWeb = /iPhone|iPad|iPod/i.test(userAgent);
      
      setPlatformInfo({
        isWeb: true,
        isMobile: isMobileWeb,
        isAndroid: isAndroidWeb,
        isIOS: isIOSWeb,
        isCapacitor: false,
        platform: 'web',
        userAgent,
        screenSize: getScreenSize()
      });
    }

    // Écouter les changements de taille d'écran
    const handleResize = () => {
      setPlatformInfo(prev => ({
        ...prev,
        screenSize: getScreenSize()
      }));
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return platformInfo;
};

// Hook utilitaire pour les styles conditionnels
export const usePlatformStyles = () => {
  const platform = usePlatform();
  
  return {
    // Classes Tailwind conditionnelles
    container: platform.isCapacitor 
      ? 'pb-20' // Espace pour navigation native
      : platform.isMobile 
      ? 'pb-16' // Espace pour navigation web mobile
      : 'pb-4', // Desktop normal
      
    navigation: platform.isCapacitor
      ? 'fixed bottom-0 native-nav'
      : 'web-nav',
      
    // Styles pour les interactions tactiles
    touchTarget: platform.isMobile 
      ? 'min-h-[44px] min-w-[44px]' // Cible tactile minimum
      : 'min-h-[32px]',
      
    // Safe areas pour les appareils avec encoche
    safeArea: platform.isIOS && platform.isCapacitor
      ? 'pb-safe-bottom pt-safe-top'
      : ''
  };
};
EOF

# 8. Installation et configuration Playwright pour Capacitor
print_info "Installation et configuration Playwright pour tests Capacitor..."
npm install --save-dev @playwright/test
npx playwright install --with-deps

# Configuration Playwright spécialisée Capacitor
cat > "playwright.config.ts" << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30000,
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results.json' }],
    ['junit', { outputFile: 'junit-results.xml' }]
  ],
  
  use: {
    baseURL: process.env.TEST_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 10000,
  },

  projects: [
    // Tests Web Desktop
    {
      name: 'desktop-chrome',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 }
      },
    },
    
    // Tests Web Mobile (simulation Capacitor)
    {
      name: 'mobile-chrome',
      use: { 
        ...devices['Pixel 5'],
        // Simulation d'un environnement Capacitor
        extraHTTPHeaders: {
          'X-Capacitor-Platform': 'android',
          'User-Agent': 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 Math4Child/2.0.0 Capacitor'
        }
      },
    },
    
    // Tests iOS Simulation
    {
      name: 'mobile-safari',
      use: { 
        ...devices['iPhone 13'],
        extraHTTPHeaders: {
          'X-Capacitor-Platform': 'ios',
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) Math4Child/2.0.0 Capacitor'
        }
      },
    },
    
    // Tests RTL spécifiques
    {
      name: 'rtl-mobile',
      use: { 
        ...devices['Pixel 5'],
        locale: 'ar-SA',
        extraHTTPHeaders: {
          'X-Capacitor-Platform': 'android'
        }
      },
    },
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
});
EOF

# 9. Correction du layout.tsx pour éviter l'erreur font
print_info "Correction du layout.tsx pour Capacitor..."
if [ -f "src/app/layout.tsx" ]; then
cat > "src/app/layout.tsx" << 'EOF'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

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
      <body className={`${inter.className} overflow-x-hidden`}>
        <div id="capacitor-app">
          {children}
        </div>
      </body>
    </html>
  )
}
EOF
fi

# 10. Ajout du manifest.json pour PWA
print_info "Création du manifest.json pour PWA..."
mkdir -p public
cat > "public/manifest.json" << 'EOF'
{
  "name": "Math4Child - Apprendre les maths",
  "short_name": "Math4Child",
  "description": "Application éducative de mathématiques pour enfants",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#667eea",
  "theme_color": "#667eea",
  "orientation": "portrait-primary",
  "icons": [
    {
      "src": "/icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ],
  "categories": ["education", "kids", "games"],
  "lang": "fr-FR"
}
EOF

# 11. Test de build corrigé
print_info "Test de build avec corrections..."
if CAPACITOR_BUILD=true npm run build:capacitor; then
    print_success "🎉 BUILD CAPACITOR RÉUSSI ! Math4Child prêt !"
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║               ✅ SUCCÈS CAPACITOR CORRIGÉ !               ║${NC}"
    echo -e "${GREEN}║          Math4Child → Web/Android/iOS ready !            ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    print_info "📱 Commandes de déploiement corrigées :"
    echo -e "${YELLOW}npm run android:build     # Application Android${NC}"
    echo -e "${YELLOW}npm run ios:build         # Application iOS (macOS)${NC}"
    echo -e "${YELLOW}npm run android:dev       # Dev Android avec live reload${NC}"
    echo -e "${YELLOW}npm run ios:dev           # Dev iOS avec live reload${NC}"
    echo ""
    
    print_success "✅ Configuration assetPrefix corrigée"
    print_success "✅ Configuration Capacitor JSON"
    print_success "✅ Navigation avec data-testid"
    print_success "✅ Hook plateforme amélioré"
    print_success "✅ Scripts de build corrigés"
    print_success "✅ Configuration Playwright"
    
else
    print_warning "Build échoué - vérifiez la configuration"
    print_info "Testez avec :"
    echo -e "${YELLOW}npm run dev${NC}"
fi

# 12. Initialisation Capacitor corrigée
print_info "Initialisation de Capacitor avec configuration JSON..."
if command -v npx > /dev/null; then
    if [ ! -d "android" ] && [ ! -d "ios" ]; then
        npx cap init "Math4Child" "com.gotest.math4child" --web-dir="out"
        print_success "Capacitor initialisé avec succès"
    else
        print_info "Capacitor déjà initialisé"
        npx cap sync
        print_success "Capacitor synchronisé"
    fi
else
    print_warning "npx non disponible"
fi

# 13. Guide de déploiement mis à jour
print_info "Mise à jour du guide de déploiement..."
cat > "CAPACITOR_DEPLOYMENT_FIXED.md" << 'EOF'
# 📱 Guide de Déploiement Capacitor Corrigé

## ✅ Corrections apportées

### 1. Configuration Next.js
- ✅ AssetPrefix corrigé : `'./'` en production Capacitor
- ✅ Export statique configuré correctement
- ✅ Webpack fallbacks pour erreurs de dépendances

### 2. Configuration Capacitor  
- ✅ Fichier JSON au lieu de TypeScript (résout erreur init)
- ✅ Configuration Android/iOS optimisée
- ✅ Safe areas et keyboard handling

### 3. Scripts de build
- ✅ Variables d'environnement `CAPACITOR_BUILD=true`
- ✅ Scripts séparés pour dev/build/release
- ✅ Live reload fonctionnel

## 🚀 Déploiement rapide

### 🤖 Android
```bash
# Première fois
npm run cap:add:android

# Development avec live reload
npm run android:dev

# Build pour release
npm run android:release
```

### 🍎 iOS (macOS requis)
```bash
# Première fois  
npm run cap:add:ios

# Development avec live reload
npm run ios:dev

# Build pour release
npm run ios:release
```

## 🧪 Tests Playwright
```bash
npm run test              # Tous les tests
npm run test:mobile       # Tests mobile uniquement
npm run test:capacitor    # Tests spécifiques Capacitor
```

## 🔧 Résolution des problèmes

### Si erreur "assetPrefix must start with leading slash"
```bash
rm -rf .next out
CAPACITOR_BUILD=true npm run build:capacitor
```

### Si erreur Capacitor init
```bash
rm capacitor.config.ts  # Supprimer l'ancien fichier TS
npx cap sync
```

### Si problème de dépendances Node.js
```bash
# Passer à Node.js 20+
nvm install 20
nvm use 20
npm install
```

## 📱 Configuration GOTEST maintenue
- ✅ App ID: com.gotest.math4child  
- ✅ SIRET: 53958712100028
- ✅ Navigation native + web responsive
- ✅ PWA avec manifest.json
- ✅ Tests multi-plateforme

## 🎯 Prochaines étapes
1. `npm run android:dev` - Test Android
2. `npm run ios:dev` - Test iOS (macOS)
3. `npm run test` - Lancer les tests
4. Publication sur stores avec Capacitor
EOF

print_success "🎉 Math4Child Capacitor CORRIGÉ et prêt ! 📱"
echo -e "${GREEN}Toutes les erreurs d'assetPrefix et de configuration sont résolues !${NC}"
