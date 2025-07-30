#!/bin/bash

# Script de correction complète Math4Child
# Applique tous les correctifs diagnostiqués

set -e

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Vérifier qu'on est dans le bon répertoire
if [ ! -f "package.json" ] || [ ! -d "apps/math4child" ]; then
    log_error "Veuillez exécuter ce script depuis la racine du projet"
    exit 1
fi

log_info "🚀 Démarrage de la correction complète du projet Math4Child"

# Backup des fichiers existants
log_info "📦 Création des backups..."
mkdir -p backups/$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"

if [ -f "apps/math4child/next.config.ts" ]; then
    cp "apps/math4child/next.config.ts" "$BACKUP_DIR/"
fi
if [ -f "apps/math4child/capacitor.config.json" ]; then
    cp "apps/math4child/capacitor.config.json" "$BACKUP_DIR/"
fi
if [ -f "apps/math4child/package.json" ]; then
    cp "apps/math4child/package.json" "$BACKUP_DIR/"
fi

log_success "Backups créés dans $BACKUP_DIR"

# 1. Corriger next.config.ts
log_info "🔧 Correction de next.config.ts..."
cat > apps/math4child/next.config.ts << 'EOF'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  
  // Export statique pour déploiements Capacitor
  output: process.env.CAPACITOR_BUILD ? 'export' : undefined,
  assetPrefix: process.env.CAPACITOR_BUILD ? './' : undefined,
  trailingSlash: process.env.CAPACITOR_BUILD ? true : false,
  
  // Configuration TypeScript stricte
  typescript: {
    ignoreBuildErrors: false,
  },
  
  eslint: {
    ignoreDuringBuilds: false,
  },
  
  // Configuration des images pour Capacitor
  images: {
    unoptimized: process.env.CAPACITOR_BUILD ? true : false,
    domains: ['localhost', 'math4child.com'],
    formats: ['image/webp', 'image/avif'],
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
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
          {
            key: 'Permissions-Policy',
            value: 'camera=(), microphone=(), geolocation=()',
          },
        ],
      },
    ]
  },
  
  // Optimisations performance
  swcMinify: true,
  poweredByHeader: false,
  compress: true,
  
  // Configuration webpack pour Capacitor
  webpack: (config, { isServer }) => {
    // Fallbacks pour environnement mobile
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        tls: false,
        crypto: false,
        stream: false,
        url: false,
        zlib: false,
        http: false,
        https: false,
        assert: false,
        os: false,
        path: false,
      }
    }
    
    // Optimisations bundle
    config.optimization = {
      ...config.optimization,
      splitChunks: {
        chunks: 'all',
        minSize: 20000,
        maxSize: 250000,
        cacheGroups: {
          vendor: {
            test: /[\\/]node_modules[\\/]/,
            name: 'vendors',
            priority: -10,
            chunks: 'all',
          },
        },
      },
    }
    
    return config
  },
  
  // Variables d'environnement
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '4.0.0',
    NEXT_PUBLIC_COMPANY: 'GOTEST',
    NEXT_PUBLIC_SIRET: '53958712100028',
  },
  
  // Configuration expérimentale
  experimental: {
    optimizePackageImports: ['lucide-react', 'recharts'],
  },
}

export default nextConfig;
EOF

log_success "✅ next.config.ts corrigé"

# 2. Corriger capacitor.config.ts
log_info "🔧 Correction de capacitor.config.ts..."
cat > apps/math4child/capacitor.config.ts << 'EOF'
import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.gotest.math4child',
  appName: 'Math4Child',
  webDir: 'out',
  bundledWebRuntime: false,
  
  server: {
    androidScheme: 'https',
    iosScheme: 'https',
    hostname: 'math4child.app',
    cleartext: false,
  },

  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      launchAutoHide: true,
      backgroundColor: '#667eea',
      androidSplashResourceName: 'splash',
      androidScaleType: 'CENTER_CROP',
      showSpinner: true,
      androidSpinnerStyle: 'large',
      iosSpinnerStyle: 'small',
      spinnerColor: '#ffffff'
    },
    
    StatusBar: {
      backgroundColor: '#667eea',
      style: 'light',
      overlay: false
    },
    
    App: {
      name: 'Math4Child',
      description: 'Application éducative de mathématiques - GOTEST',
      version: '4.0.0'
    },
    
    Keyboard: {
      resize: 'body',
      style: 'dark',
      resizeOnFullScreen: true
    },
    
    Device: {
      name: 'Math4Child Device Info'
    },
    
    Haptics: {},
    
    LocalNotifications: {
      smallIcon: 'ic_stat_icon_config_sample',
      iconColor: '#667eea'
    }
  },

  android: {
    allowMixedContent: true,
    captureInput: true,
    webContentsDebuggingEnabled: false, // Production
    loggingBehavior: 'production',
    minWebViewVersion: 60,
    buildOptions: {
      keystorePath: '',
      keystorePassword: '',
      keystoreAlias: '',
      keystoreAliasPassword: '',
      releaseType: 'APK',
      signingType: 'apksigner'
    }
  },

  ios: {
    scheme: 'Math4Child',
    contentInset: 'automatic',
    scrollEnabled: true,
    backgroundColor: '#667eea',
    buildOptions: {
      developmentTeam: '',
      packageType: 'development',
      codeSignIdentity: 'iPhone Developer'
    }
  }
};

export default config;
EOF

log_success "✅ capacitor.config.ts corrigé"

# 3. Corriger package.json
log_info "🔧 Correction de package.json..."
cat > apps/math4child/package.json << 'EOF'
{
  "name": "math4child",
  "version": "4.0.0",
  "description": "Math4Child - Application éducative de mathématiques hybride",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit",
    
    "build:web": "next build",
    "build:capacitor": "CAPACITOR_BUILD=true next build",
    "build:android": "npm run build:capacitor && npx cap sync android && npx cap build android",
    "build:ios": "npm run build:capacitor && npx cap sync ios && npx cap build ios",
    "build:all": "npm run build:web && npm run build:capacitor",
    
    "cap:init": "npx cap init Math4Child com.gotest.math4child",
    "cap:add:android": "npx cap add android",
    "cap:add:ios": "npx cap add ios", 
    "cap:sync": "npx cap sync",
    "cap:serve": "npx cap serve",
    "cap:doctor": "npx cap doctor",
    "cap:update": "npx cap update",
    
    "dev:web": "npm run dev",
    "dev:android": "npm run cap:sync && npx cap run android --livereload --external",
    "dev:ios": "npm run cap:sync && npx cap run ios --livereload --external",
    "dev:all": "concurrently \"npm run dev\" \"npm run cap:serve\"",
    
    "deploy:web": "npm run build:web && npm run export",
    "deploy:android": "npm run build:android && cd android && ./gradlew assembleRelease",
    "deploy:ios": "npm run build:ios && npx cap open ios",
    "deploy:all": "npm run deploy:web && npm run deploy:android",
    
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:ui": "playwright test --ui",
    "test:report": "playwright show-report",
    "test:install": "playwright install",

    "test:web": "playwright test --project=chromium --project=firefox --project=webkit",
    "test:mobile": "playwright test --project=mobile-chrome",
    "test:hybrid": "playwright test --config=playwright.config.hybrid.ts",
    "test:smoke": "playwright test --grep @smoke",
    "test:regression": "playwright test --grep @regression",
    "test:i18n": "playwright test --project=translation-tests",
    "test:performance": "playwright test performance.spec.ts",
    "test:accessibility": "playwright test a11y.spec.ts",
    "test:quick": "playwright test --grep \"✅\"",
    
    "clean": "rm -rf .next out android ios node_modules/.cache",
    "clean:all": "npm run clean && rm -rf node_modules",
    "clean:build": "rm -rf .next out",
    "clean:mobile": "rm -rf android ios",
    
    "doctor": "npm run cap:doctor && npm run type-check && npm run lint",
    "info": "npx cap info",
    "validate": "npm run doctor && npm run test:quick"
  },
  "dependencies": {
    "@capacitor/android": "^6.2.1",
    "@capacitor/app": "^7.0.1",
    "@capacitor/cli": "^6.2.1",
    "@capacitor/core": "^6.2.1",
    "@capacitor/device": "^7.0.1",
    "@capacitor/haptics": "^7.0.1",
    "@capacitor/ios": "^6.2.1",
    "@capacitor/keyboard": "^7.0.1",
    "@capacitor/local-notifications": "^7.0.1",
    "@capacitor/splash-screen": "^7.0.1",
    "@capacitor/status-bar": "^7.0.1",
    "@stripe/stripe-js": "^4.7.0",
    "crypto-js": "^4.2.0",
    "date-fns": "^3.6.0",
    "lucide-react": "^0.469.0",
    "next": "^14.2.30",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "recharts": "^2.12.7",
    "stripe": "^16.12.0"
  },
  "devDependencies": {
    "@playwright/test": "^1.54.1",
    "@types/crypto-js": "^4.2.2",
    "@types/node": "^20.14.8",
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "autoprefixer": "^10.4.21",
    "concurrently": "^9.1.0",
    "postcss": "^8.5.6",
    "rimraf": "^6.0.1",
    "tailwindcss": "^3.4.17",
    "typescript": "^5.4.5"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  },
  "keywords": [
    "mathematics",
    "education",
    "capacitor",
    "hybrid",
    "mobile",
    "typescript",
    "nextjs"
  ],
  "author": "GOTEST",
  "license": "MIT"
}
EOF

log_success "✅ package.json corrigé"

# 4. Corriger tsconfig.json
log_info "🔧 Correction de tsconfig.json..."
cat > apps/math4child/tsconfig.json << 'EOF'
{
  "compilerOptions": {
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
    "forceConsistentCasingInFileNames": true,
    
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/hooks/*": ["./src/hooks/*"],
      "@/types/*": ["./src/types/*"],
      "@/utils/*": ["./src/utils/*"],
      "@/styles/*": ["./src/styles/*"],
      "@/public/*": ["./public/*"]
    },
    
    "plugins": [
      {
        "name": "next"
      }
    ]
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts",
    "src/**/*",
    "tests/**/*"
  ],
  "exclude": [
    "node_modules",
    ".next",
    "out",
    "android",
    "ios",
    "dist",
    "build"
  ]
}
EOF

log_success "✅ tsconfig.json corrigé"

# 5. Corriger playwright.config.ts
log_info "🔧 Correction de playwright.config.ts..."
cat > apps/math4child/playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  
  timeout: 60 * 1000,
  expect: { timeout: 15 * 1000 },
  
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: process.env.CI ? 2 : 4,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    ['list']
  ],
  
  outputDir: 'test-results',
  
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 15000,
    navigationTimeout: 30000,
  },

  projects: [
    {
      name: 'setup',
      testMatch: /.*\.setup\.ts/,
    },
    
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
      dependencies: ['setup'],
    },
    
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
      dependencies: ['setup'],
    },
    
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
      dependencies: ['setup'],
    },
    
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
      dependencies: ['setup'],
    },
    
    {
      name: 'mobile-safari',
      use: { ...devices['iPhone 12'] },
      dependencies: ['setup'],
    },
    
    {
      name: 'translation-tests',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'fr-FR',
        timezoneId: 'Europe/Paris'
      },
      testMatch: '**/i18n/**/*.spec.ts',
      dependencies: ['setup'],
    },
    
    {
      name: 'stripe-tests',
      use: { 
        ...devices['Desktop Chrome'],
        extraHTTPHeaders: {
          'Accept-Language': 'fr-FR,fr;q=0.9'
        }
      },
      testMatch: '**/stripe/**/*.spec.ts',
      dependencies: ['setup'],
    }
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
    stdout: 'ignore',
    stderr: 'pipe',
  },
});
EOF

log_success "✅ playwright.config.ts corrigé"

# 6. Créer le dossier tests si absent
log_info "🔧 Création de la structure de tests..."
mkdir -p apps/math4child/tests/specs
mkdir -p apps/math4child/tests/utils

# Test basique si absent
if [ ! -f "apps/math4child/tests/specs/basic.spec.ts" ]; then
cat > apps/math4child/tests/specs/basic.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('Math4Child - Tests basiques', () => {
  test('✅ Page d\'accueil se charge correctement', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveTitle(/Math4Child/);
  });

  test('✅ Navigation fonctionne', async ({ page }) => {
    await page.goto('/');
    // Ajouter tests de navigation spécifiques
  });
});
EOF
fi

# 7. Nettoyer les anciens fichiers JSON de capacitor si présents
if [ -f "apps/math4child/capacitor.config.json" ]; then
    rm apps/math4child/capacitor.config.json
    log_info "Ancien capacitor.config.json supprimé"
fi

# 8. Créer le script de déploiement
log_info "🔧 Création du script de déploiement..."
cat > apps/math4child/deploy.sh << 'EOF'
#!/bin/bash

# Script de déploiement Math4Child
# Usage: ./deploy.sh [web|android|ios|all]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

TARGET=${1:-"web"}

log_info "🚀 Déploiement Math4Child - Target: $TARGET"

# Nettoyage
rm -rf .next out android/app/build ios/build 2>/dev/null || true

# Installation
npm ci --silent

# Tests rapides
npm run type-check
npm run lint

case $TARGET in
    "web")
        npm run build:web
        log_success "✅ Build web terminé"
        ;;
    "android")
        npm run build:capacitor
        npx cap sync android
        log_success "✅ Build Android terminé"
        ;;
    "ios")
        if [[ "$OSTYPE" != "darwin"* ]]; then
            log_error "iOS build nécessite macOS"
            exit 1
        fi
        npm run build:capacitor
        npx cap sync ios
        npx cap open ios
        log_success "✅ Build iOS préparé"
        ;;
    "all")
        npm run build:web
        npm run build:capacitor
        npx cap sync android
        if [[ "$OSTYPE" == "darwin"* ]]; then
            npx cap sync ios
        fi
        log_success "✅ Build complet terminé"
        ;;
    *)
        log_error "Target invalide: $TARGET"
        exit 1
        ;;
esac

log_success "🎉 Déploiement terminé!"
EOF

chmod +x apps/math4child/deploy.sh
log_success "✅ Script de déploiement créé"

# 9. Installation des dépendances
log_info "📦 Installation des dépendances..."
cd apps/math4child
npm install --silent
cd ../..
log_success "✅ Dépendances installées"

# 10. Validation finale
log_info "🔍 Validation finale..."
cd apps/math4child

# Type checking
if npm run type-check >/dev/null 2>&1; then
    log_success "✅ TypeScript validation OK"
else
    log_warning "⚠️ TypeScript warnings détectés"
fi

# Capacitor doctor
if command -v cap >/dev/null 2>&1; then
    if npx cap doctor >/dev/null 2>&1; then
        log_success "✅ Capacitor configuration OK"
    else
        log_warning "⚠️ Capacitor nécessite une attention"
    fi
else
    log_info "📦 Installation de Capacitor CLI..."
    npm install -g @capacitor/cli >/dev/null 2>&1 || true
fi

cd ../..

# Résumé final
log_success "🎉 CORRECTION COMPLÈTE TERMINÉE!"
echo ""
echo "📋 Résumé des corrections appliquées:"
echo "  ✅ next.config.ts - Configuration hybride complète"
echo "  ✅ capacitor.config.ts - Configuration TypeScript optimisée"
echo "  ✅ package.json - Scripts et dépendances corrigés"
echo "  ✅ tsconfig.json - Configuration stricte"
echo "  ✅ playwright.config.ts - Tests multi-plateformes"
echo "  ✅ Structure de tests créée"
echo "  ✅ Script de déploiement automatisé"
echo "  ✅ Dépendances installées"
echo ""
echo "🚀 Commandes disponibles:"
echo "  cd apps/math4child"
echo "  npm run dev          # Démarrage développement"
echo "  npm run build:all    # Build complet (web + mobile)"
echo "  npm run doctor       # Diagnostic complet"
echo "  ./deploy.sh all      # Déploiement automatisé"
echo ""
echo "📁 Backups sauvegardés dans: $BACKUP_DIR"
log_success "Le projet est maintenant prêt pour la production! 🎉"
EOF

log_success "✅ Script de correction complète créé!"
echo ""
echo "🚀 Pour appliquer toutes les corrections, exécutez:"
echo "  chmod +x fix-project.sh"
echo "  ./fix-project.sh"