#!/bin/bash

# setup-hybrid-project.sh - Script principal de migration
# Ce script transforme le projet en application hybride

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'affichage
print_step() {
    echo -e "${BLUE}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Vérification des prérequis
check_prerequisites() {
    print_step "Vérification des prérequis..."
    
    # Vérifier Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js n'est pas installé. Veuillez l'installer."
        exit 1
    fi
    
    # Vérifier npm
    if ! command -v npm &> /dev/null; then
        print_error "npm n'est pas installé. Veuillez l'installer."
        exit 1
    fi
    
    # Vérifier la version de Node.js
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        print_error "Node.js version 18+ requis. Version actuelle: $(node -v)"
        exit 1
    fi
    
    print_success "Prérequis validés"
}

# Sauvegarde du projet actuel
backup_project() {
    print_step "Sauvegarde du projet actuel..."
    
    BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
    
    # Créer une sauvegarde du package.json actuel
    if [ -f "package.json" ]; then
        cp package.json "package.json.backup"
        print_success "package.json sauvegardé"
    fi
    
    # Créer une sauvegarde complète
    mkdir -p "$BACKUP_DIR"
    cp -r . "$BACKUP_DIR/" 2>/dev/null || true
    
    print_success "Projet sauvegardé dans $BACKUP_DIR"
}

# Nettoyage du projet
clean_project() {
    print_step "Nettoyage du projet..."
    
    # Nettoyer les anciens builds
    rm -rf dist dist-web build node_modules/.cache
    
    # Nettoyer les plateformes Capacitor
    rm -rf android/app/src/main/assets/public
    rm -rf ios/App/App/public
    
    print_success "Projet nettoyé"
}

# Restructuration des dossiers
restructure_project() {
    print_step "Restructuration du projet..."
    
    # Créer la nouvelle structure
    mkdir -p src/mobile/{apps,components,hooks,utils}
    mkdir -p src/mobile/apps/{postmath,unitflip,budgetcron,ai4kids,multiai}
    mkdir -p src/shared/{types,constants,api,utils}
    mkdir -p src/web
    mkdir -p public/icons
    mkdir -p tests/{web,mobile}
    
    # Déplacer les applications existantes si elles existent
    if [ -d "apps" ]; then
        print_step "Migration des applications existantes..."
        cp -r apps/* src/web/ 2>/dev/null || true
    fi
    
    print_success "Structure du projet créée"
}

# Installation des dépendances
install_dependencies() {
    print_step "Installation des dépendances..."
    
    # Supprimer l'ancien package-lock.json
    rm -f package-lock.json
    
    # Installer les dépendances principales
    npm install \
        @capacitor/android@^6.0.0 \
        @capacitor/app@^6.0.0 \
        @capacitor/core@^6.0.0 \
        @capacitor/haptics@^6.0.0 \
        @capacitor/ios@^6.0.0 \
        @capacitor/keyboard@^6.0.0 \
        @capacitor/splash-screen@^6.0.0 \
        @capacitor/status-bar@^6.0.0 \
        framer-motion@^11.0.0 \
        react@^18.2.0 \
        react-dom@^18.2.0 \
        react-router-dom@^6.8.0
    
    # Installer les dépendances de développement
    npm install -D \
        @capacitor/cli@^6.0.0 \
        @playwright/test@^1.40.0 \
        @types/react@^18.2.0 \
        @types/react-dom@^18.2.0 \
        @typescript-eslint/eslint-plugin@^6.0.0 \
        @typescript-eslint/parser@^6.0.0 \
        @vitejs/plugin-react@^4.2.0 \
        autoprefixer@^10.4.0 \
        eslint@^8.56.0 \
        eslint-plugin-react-hooks@^4.6.0 \
        eslint-plugin-react-refresh@^0.4.5 \
        postcss@^8.4.0 \
        prettier@^3.0.0 \
        rimraf@^5.0.0 \
        tailwindcss@^3.4.0 \
        typescript@^5.3.0 \
        vite@^5.0.0
    
    print_success "Dépendances installées"
}

# Création des fichiers de configuration
create_config_files() {
    print_step "Création des fichiers de configuration..."
    
    # Capacitor config
    cat > capacitor.config.ts << 'EOF'
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.example.multiappsplatform',
  appName: 'Multi-Apps Platform',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: "#667eea",
      showSpinner: false,
      androidSplashResourceName: "splash",
      androidScaleType: "CENTER_CROP",
      iosLaunchAnimation: "fade"
    },
    StatusBar: {
      style: 'light',
      backgroundColor: "#667eea"
    },
    Keyboard: {
      resize: 'body',
      style: 'dark',
      resizeOnFullScreen: true
    },
    App: {
      launchUrl: 'https://multiapps.local'
    }
  },
  ios: {
    contentInset: 'automatic'
  },
  android: {
    allowMixedContent: true,
    captureInput: true
  }
};

export default config;
EOF

    # Vite config
    cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig(({ mode }) => ({
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
      '@shared': resolve(__dirname, 'src/shared'),
      '@mobile': resolve(__dirname, 'src/mobile'),
      '@web': resolve(__dirname, 'src/web'),
    },
  },
  build: {
    outDir: mode === 'mobile' ? 'dist' : 'dist-web',
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom', 'react-router-dom'],
          capacitor: ['@capacitor/core', '@capacitor/app', '@capacitor/haptics', '@capacitor/status-bar']
        }
      }
    }
  },
  server: {
    host: '0.0.0.0',
    port: 3000,
    hmr: {
      host: 'localhost'
    }
  },
  define: {
    __IS_MOBILE__: mode === 'mobile',
    __DEV__: mode === 'development'
  },
  optimizeDeps: {
    include: ['@capacitor/core', '@capacitor/app', '@capacitor/haptics', '@capacitor/status-bar']
  }
}));
EOF

    # Tailwind config
    cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      padding: {
        'safe-top': 'env(safe-area-inset-top)',
        'safe-bottom': 'env(safe-area-inset-bottom)',
        'safe-left': 'env(safe-area-inset-left)',
        'safe-right': 'env(safe-area-inset-right)',
      },
      margin: {
        'safe-top': 'env(safe-area-inset-top)',
        'safe-bottom': 'env(safe-area-inset-bottom)',
      },
      height: {
        'screen-safe': 'calc(100vh - env(safe-area-inset-top) - env(safe-area-inset-bottom))',
      },
      colors: {
        primary: {
          50: '#f0f9ff',
          500: '#667eea',
          600: '#5a67d8',
          700: '#4c51bf',
        }
      },
      animation: {
        'bounce-slow': 'bounce 3s infinite',
        'pulse-slow': 'pulse 3s infinite',
      }
    },
  },
  plugins: [],
  safelist: [
    'pt-safe-top',
    'pb-safe-bottom',
    'pl-safe-left',
    'pr-safe-right',
    'mt-safe-top',
    'mb-safe-bottom'
  ]
}
EOF

    # PostCSS config
    cat > postcss.config.js << 'EOF'
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

    # TypeScript config
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"],
      "@shared/*": ["src/shared/*"],
      "@mobile/*": ["src/mobile/*"],
      "@web/*": ["src/web/*"]
    }
  },
  "include": ["src", "capacitor.config.ts"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

    cat > tsconfig.node.json << 'EOF'
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts", "capacitor.config.ts"]
}
EOF

    # ESLint config
    cat > .eslintrc.cjs << 'EOF'
module.exports = {
  root: true,
  env: { browser: true, es2020: true },
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',
  ],
  ignorePatterns: ['dist', '.eslintrc.cjs', 'android', 'ios'],
  parser: '@typescript-eslint/parser',
  plugins: ['react-refresh'],
  rules: {
    'react-refresh/only-export-components': [
      'warn',
      { allowConstantExport: true },
    ],
    '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    'prefer-const': 'error',
    'no-var': 'error',
  },
}
EOF

    print_success "Fichiers de configuration créés"
}

# Création des fichiers sources
create_source_files() {
    print_step "Création des fichiers sources..."
    
    # Main entry point
    cat > src/main.tsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
EOF

    # App component
    cat > src/App.tsx << 'EOF'
import React, { useEffect, useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { Capacitor } from '@capacitor/core';
import { App as CapacitorApp } from '@capacitor/app';
import { StatusBar } from '@capacitor/status-bar';

import Navigation from './mobile/components/Navigation';
import LoadingScreen from './mobile/components/LoadingScreen';

// Applications
import PostmathApp from './mobile/apps/postmath/PostmathApp';
import UnitFlipApp from './mobile/apps/unitflip/UnitFlipApp';
import BudgetCronApp from './mobile/apps/budgetcron/BudgetCronApp';
import AI4KidsApp from './mobile/apps/ai4kids/AI4KidsApp';
import MultiAIApp from './mobile/apps/multiai/MultiAIApp';

const App: React.FC = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [isNative, setIsNative] = useState(false);
  const [currentApp, setCurrentApp] = useState('postmath');

  useEffect(() => {
    const initialize = async () => {
      setIsNative(Capacitor.isNativePlatform());
      
      if (Capacitor.isNativePlatform()) {
        await StatusBar.setStyle({ style: 'light' });
        await StatusBar.setBackgroundColor({ color: '#667eea' });
        
        CapacitorApp.addListener('backButton', ({ canGoBack }) => {
          if (!canGoBack) {
            CapacitorApp.exitApp();
          } else {
            window.history.back();
          }
        });
      }

      setIsLoading(false);
    };

    initialize();
  }, []);

  if (isLoading) {
    return <LoadingScreen />;
  }

  return (
    <Router>
      <div className={`flex flex-col h-screen ${isNative ? 'pt-safe-top' : ''}`}>
        <main className="flex-1 overflow-hidden">
          <Routes>
            <Route path="/" element={<Navigate to="/postmath" replace />} />
            <Route 
              path="/postmath" 
              element={<PostmathApp isNative={isNative} onAppChange={setCurrentApp} />} 
            />
            <Route 
              path="/unitflip" 
              element={<UnitFlipApp isNative={isNative} onAppChange={setCurrentApp} />} 
            />
            <Route 
              path="/budgetcron" 
              element={<BudgetCronApp isNative={isNative} onAppChange={setCurrentApp} />} 
            />
            <Route 
              path="/ai4kids" 
              element={<AI4KidsApp isNative={isNative} onAppChange={setCurrentApp} />} 
            />
            <Route 
              path="/multiai" 
              element={<MultiAIApp isNative={isNative} onAppChange={setCurrentApp} />} 
            />
          </Routes>
        </main>
        
        <Navigation isNative={isNative} currentApp={currentApp} />
      </div>
    </Router>
  );
};

export default App;
EOF

    # CSS principal
    cat > src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html, body {
  height: 100%;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#root {
  height: 100%;
}

@supports (padding: env(safe-area-inset-top)) {
  .safe-top {
    padding-top: env(safe-area-inset-top);
  }
  
  .safe-bottom {
    padding-bottom: env(safe-area-inset-bottom);
  }
  
  .safe-left {
    padding-left: env(safe-area-inset-left);
  }
  
  .safe-right {
    padding-right: env(safe-area-inset-right);
  }
}

@media (max-width: 768px) {
  button, input, select {
    -webkit-tap-highlight-color: transparent;
    touch-action: manipulation;
  }
  
  input[type="number"],
  input[type="text"],
  select {
    font-size: 16px;
  }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from { 
    opacity: 0;
    transform: translateY(20px);
  }
  to { 
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in {
  animation: fadeIn 0.3s ease-in-out;
}

.slide-up {
  animation: slideUp 0.4s ease-out;
}

.glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}
EOF

    # HTML principal
    cat > index.html << 'EOF'
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover, user-scalable=no" />
    <meta name="theme-color" content="#667eea" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <meta name="apple-mobile-web-app-title" content="Multi-Apps" />
    
    <title>Multi-Apps Platform</title>
    
    <style>
      body {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      }
      
      #root {
        height: 100vh;
        overflow: hidden;
      }
      
      .initial-loader {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        z-index: 9999;
      }
      
      .loader-content {
        text-align: center;
        color: white;
      }
      
      .spinner {
        width: 40px;
        height: 40px;
        border: 4px solid rgba(255, 255, 255, 0.3);
        border-top: 4px solid white;
        border-radius: 50%;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px;
      }
      
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
    </style>
  </head>
  <body>
    <div id="root">
      <div class="initial-loader">
        <div class="loader-content">
          <div class="spinner"></div>
          <h2>Multi-Apps Platform</h2>
          <p>Chargement...</p>
        </div>
      </div>
    </div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

    print_success "Fichiers sources créés"
}

# Création des composants mobile
create_mobile_components() {
    print_step "Création des composants mobile..."
    
    # Navigation component
    cat > src/mobile/components/Navigation.tsx << 'EOF'
import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import { Capacitor } from '@capacitor/core';

interface NavigationProps {
  isNative: boolean;
  currentApp: string;
}

const apps = [
  { id: 'postmath', name: 'Postmath', icon: '🧮', path: '/postmath' },
  { id: 'unitflip', name: 'UnitFlip', icon: '🔄', path: '/unitflip' },
  { id: 'budgetcron', name: 'Budget', icon: '💰', path: '/budgetcron' },
  { id: 'ai4kids', name: 'AI4Kids', icon: '🎨', path: '/ai4kids' },
  { id: 'multiai', name: 'MultiAI', icon: '🤖', path: '/multiai' },
];

const Navigation: React.FC<NavigationProps> = ({ isNative }) => {
  const navigate = useNavigate();
  const location = useLocation();

  const handleNavigation = async (path: string) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Light });
    }
    navigate(path);
  };

  return (
    <nav className={`bg-white border-t border-gray-200 ${isNative ? 'pb-safe-bottom' : ''}`}>
      <div className="flex justify-around items-center py-2">
        {apps.map((app) => (
          <button
            key={app.id}
            onClick={() => handleNavigation(app.path)}
            className={`flex flex-col items-center p-2 rounded-lg transition-all duration-200 ${
              location.pathname === app.path
                ? 'text-indigo-600 bg-indigo-50'
                : 'text-gray-500 hover:text-gray-700'
            }`}
          >
            <span className="text-2xl mb-1">{app.icon}</span>
            <span className="text-xs font-medium">{app.name}</span>
          </button>
        ))}
      </div>
    </nav>
  );
};

export default Navigation;
EOF

    # Loading screen component
    cat > src/mobile/components/LoadingScreen.tsx << 'EOF'
import React from 'react';

const LoadingScreen: React.FC = () => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center">
      <div className="text-center">
        <div className="w-16 h-16 border-4 border-white border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
        <h1 className="text-2xl font-bold text-white mb-2">Multi-Apps Platform</h1>
        <p className="text-white/80">Chargement...</p>
      </div>
    </div>
  );
};

export default LoadingScreen;
EOF

    print_success "Composants mobile créés"
}

# Mise à jour du package.json
update_package_json() {
    print_step "Mise à jour du package.json..."
    
    # Créer le nouveau package.json avec les scripts hybrides
    cat > package.json << 'EOF'
{
  "name": "multi-apps-platform",
  "version": "1.0.0",
  "description": "🚀 Plateforme multi-applications hybride : Web, Android, iOS",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "build:web": "tsc && vite build --mode web",
    "build:mobile": "tsc && vite build --mode mobile",
    "preview": "vite preview",
    "preview:mobile": "vite preview --mode mobile",
    
    "android": "npm run build:mobile && npx cap sync android && npx cap open android",
    "android:build": "npm run build:mobile && npx cap sync android && npx cap build android",
    "android:run": "npm run build:mobile && npx cap sync android && npx cap run android",
    
    "ios": "npm run build:mobile && npx cap sync ios && npx cap open ios",
    "ios:build": "npm run build:mobile && npx cap sync ios && npx cap build ios",
    "ios:run": "npm run build:mobile && npx cap sync ios && npx cap run ios",
    
    "sync": "npx cap sync",
    "copy": "npx cap copy",
    "update": "npx cap update",
    
    "test": "playwright test",
    "test:ui": "playwright test --ui",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:mobile": "playwright test --project=mobile",
    "test:web": "playwright test --project=web",
    
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "lint:fix": "eslint . --ext ts,tsx --fix",
    "format": "prettier --write .",
    "type-check": "tsc --noEmit",
    
    "clean": "rimraf dist dist-web node_modules/.vite",
    "clean:platforms": "rimraf android/app/src/main/assets/public ios/App/App/public",
    "reset": "npm run clean && npm run clean:platforms && npm install"
  },
  "keywords": [
    "nextjs",
    "typescript",
    "capacitor",
    "hybrid-app",
    "multi-tenant",
    "saas",
    "postmath",
    "unitflip",
    "budgetcron",
    "ai4kids",
    "multiai",
    "mobile",
    "web"
  ],
  "author": "Khalid Ksouri <khalid_ksouri@yahoo.fr>",
  "license": "MIT",
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "dependencies": {},
  "devDependencies": {}
}
EOF

    print_success "package.json mis à jour"
}

# Initialisation de Capacitor
init_capacitor() {
    print_step "Initialisation de Capacitor..."
    
    # Installer Capacitor CLI si pas déjà fait
    if ! command -v cap &> /dev/null; then
        npm install -g @capacitor/cli
    fi
    
    # Initialiser Capacitor
    npx cap init "Multi-Apps Platform" "com.example.multiappsplatform" --web-dir=dist
    
    # Ajouter les plateformes
    npx cap add android
    npx cap add ios
    
    print_success "Capacitor initialisé"
}

# Mise à jour du .gitignore
update_gitignore() {
    print_step "Mise à jour du .gitignore..."
    
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.pnp
.pnp.js

# Production builds
/dist
/dist-web
/build

# Environment variables
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# Capacitor
.capacitor/
android/app/src/main/assets/public
ios/App/App/public

# Temporary files
*.tmp
*.temp

# Test results
/coverage
/test-results
/playwright-report

# Backup files
*.backup
backup_*
EOF

    print_success ".gitignore mis à jour"
}

# Build initial
initial_build() {
    print_step "Build initial..."
    
    # Installer les dépendances
    npm install
    
    # Build pour mobile
    npm run build:mobile
    
    # Sync avec Capacitor
    npx cap sync
    
    print_success "Build initial terminé"
}

# Fonction principale
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              🚀 MIGRATION VERS ARCHITECTURE HYBRIDE          ║"
    echo "║                                                              ║"
    echo "║  Ce script va transformer votre projet en application       ║"
    echo "║  hybride compatible Web, Android et iOS                      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    read -p "Voulez-vous continuer ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Migration annulée"
        exit 0
    fi
    
    # Exécution des étapes
    check_prerequisites
    backup_project
    clean_project
    restructure_project
    create_config_files
    update_package_json
    install_dependencies
    create_source_files
    create_mobile_components
    update_gitignore
    init_capacitor
    initial_build
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    ✅ MIGRATION TERMINÉE !                    ║"
    echo "║                                                              ║"
    echo "║  Votre projet est maintenant une application hybride !      ║"
    echo "║                                                              ║"
    echo "║  Commandes disponibles :                                    ║"
    echo "║  • npm run dev           - Développement web                ║"
    echo "║  • npm run android       - Ouvrir Android Studio           ║"
    echo "║  • npm run ios           - Ouvrir Xcode                     ║"
    echo "║  • npm run build:mobile  - Build pour mobile               ║"
    echo "║  • npm run build:web     - Build pour web                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Vérifier si le script est exécuté directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

# Scripts utilitaires séparés pour différentes tâches

# create-app-component.sh - Script pour créer une nouvelle application
create_app_component() {
    local APP_NAME=$1
    local APP_DISPLAY_NAME=$2
    local APP_ICON=$3
    local GRADIENT_COLOR=$4
    
    if [ -z "$APP_NAME" ] || [ -z "$APP_DISPLAY_NAME" ]; then
        echo "Usage: create_app_component <app_name> <display_name> [icon] [gradient_color]"
        echo "Exemple: create_app_component calculator 'Calculatrice' '🧮' 'indigo'"
        exit 1
    fi
    
    APP_ICON=${APP_ICON:-"📱"}
    GRADIENT_COLOR=${GRADIENT_COLOR:-"indigo"}
    
    print_step "Création de l'application $APP_DISPLAY_NAME..."
    
    # Créer le dossier de l'application
    mkdir -p "src/mobile/apps/$APP_NAME"
    
    # Créer le composant principal
    cat > "src/mobile/apps/$APP_NAME/${APP_NAME^}App.tsx" << EOF
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { Haptics, ImpactStyle } from '@capacitor/haptics';

interface ${APP_NAME^}AppProps {
  isNative?: boolean;
  onAppChange?: (app: string) => void;
}

const ${APP_NAME^}App: React.FC<${APP_NAME^}AppProps> = ({ isNative = false, onAppChange }) => {
  const [data, setData] = useState('');

  useEffect(() => {
    onAppChange?.('$APP_NAME');
  }, [onAppChange]);

  const handleAction = async () => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Light });
    }
    
    // Logique de l'application ici
    console.log('Action executed');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-${GRADIENT_COLOR}-500 to-${GRADIENT_COLOR}-600 p-4">
      <div className="max-w-md mx-auto">
        {/* Header */}
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">${APP_ICON} ${APP_DISPLAY_NAME}</h1>
          <p className="text-white/80">Description de l'application</p>
        </div>

        {/* Contenu principal */}
        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
          <div className="mb-6">
            <input
              type="text"
              value={data}
              onChange={(e) => setData(e.target.value)}
              placeholder="Entrez des données"
              className="w-full bg-white/90 rounded-xl p-4 text-gray-800 placeholder-gray-500"
            />
          </div>

          <button
            onClick={handleAction}
            className="w-full bg-${GRADIENT_COLOR}-500 hover:bg-${GRADIENT_COLOR}-600 text-white font-bold py-4 rounded-xl transition-all duration-200 active:scale-95"
          >
            ${APP_ICON} Action
          </button>
        </div>
      </div>
    </div>
  );
};

export default ${APP_NAME^}App;
EOF

    print_success "Application $APP_DISPLAY_NAME créée dans src/mobile/apps/$APP_NAME/"
    print_warning "N'oubliez pas d'ajouter la route dans src/App.tsx et la navigation dans src/mobile/components/Navigation.tsx"
}

# build-and-deploy.sh - Script de build et déploiement
build_and_deploy() {
    print_step "🔧 Build et déploiement..."
    
    # Build web
    print_step "Building web version..."
    npm run build:web
    
    # Build mobile
    print_step "📱 Building mobile version..."
    npm run build:mobile
    
    # Sync avec Capacitor
    print_step "🔄 Syncing with Capacitor..."
    npx cap sync
    
    # Build Android si demandé
    if [[ "$1" == "android" || "$1" == "all" ]]; then
        print_step "🤖 Building Android..."
        npx cap build android
    fi
    
    # Build iOS si demandé et sur macOS
    if [[ ("$1" == "ios" || "$1" == "all") && "$OSTYPE" == "darwin"* ]]; then
        print_step "🍎 Building iOS..."
        npx cap build ios
    fi
    
    print_success "✅ Build completed!"
}

# test-all-platforms.sh - Script de test sur toutes les plateformes
test_all_platforms() {
    print_step "🧪 Testing all platforms..."
    
    # Tests web
    print_step "Testing web version..."
    npm run test:web
    
    # Tests mobile (simulation)
    print_step "Testing mobile version..."
    npm run test:mobile
    
    # Tests de type checking
    print_step "Type checking..."
    npm run type-check
    
    # Linting
    print_step "Linting..."
    npm run lint
    
    print_success "✅ All tests completed!"
}

# Rendre les scripts exécutables si appelés directement
case "${BASH_SOURCE[0]}" in
    *create-app-component.sh)
        create_app_component "$@"
        ;;
    *build-and-deploy.sh)
        build_and_deploy "$@"
        ;;
    *test-all-platforms.sh)
        test_all_platforms "$@"
        ;;
esac