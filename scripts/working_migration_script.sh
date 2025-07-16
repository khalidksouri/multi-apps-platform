#!/bin/bash

# migrate-to-hybrid.sh - Script de migration complet vers architecture hybride
# Usage: chmod +x migrate-to-hybrid.sh && ./migrate-to-hybrid.sh

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Fonctions d'affichage
print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    printf "║%-62s║\n" "$1"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}🔧 $1${NC}"
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
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js n'est pas installé"
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "npm n'est pas installé"
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        print_error "Node.js version 18+ requis. Version actuelle: $(node -v)"
        exit 1
    fi
    
    print_success "Prérequis validés"
}

# Sauvegarde du projet
backup_project() {
    print_step "Sauvegarde du projet actuel..."
    
    BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Sauvegarder les fichiers importants
    [ -f "package.json" ] && cp package.json "$BACKUP_DIR/"
    [ -f "tsconfig.json" ] && cp tsconfig.json "$BACKUP_DIR/"
    [ -f "vite.config.ts" ] && cp vite.config.ts "$BACKUP_DIR/"
    
    print_success "Projet sauvegardé dans $BACKUP_DIR"
}

# Nettoyage du projet
clean_project() {
    print_step "Nettoyage du projet..."
    
    rm -rf dist dist-web build node_modules/.cache 2>/dev/null || true
    rm -rf android/app/src/main/assets/public 2>/dev/null || true
    rm -rf ios/App/App/public 2>/dev/null || true
    
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
    mkdir -p scripts
    
    print_success "Structure du projet créée"
}

# Installation des dépendances
install_dependencies() {
    print_step "Installation des dépendances..."
    
    rm -f package-lock.json
    
    # Créer le nouveau package.json
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
    "android": "npm run build:mobile && npx cap sync android && npx cap open android",
    "ios": "npm run build:mobile && npx cap sync ios && npx cap open ios",
    "sync": "npx cap sync",
    "test": "echo \"Tests à configurer\"",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "lint:fix": "eslint . --ext ts,tsx --fix",
    "format": "prettier --write .",
    "type-check": "tsc --noEmit",
    "clean": "rimraf dist dist-web node_modules/.vite"
  },
  "dependencies": {
    "@capacitor/android": "^6.0.0",
    "@capacitor/app": "^6.0.0",
    "@capacitor/core": "^6.0.0",
    "@capacitor/haptics": "^6.0.0",
    "@capacitor/ios": "^6.0.0",
    "@capacitor/keyboard": "^6.0.0",
    "@capacitor/splash-screen": "^6.0.0",
    "@capacitor/status-bar": "^6.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0"
  },
  "devDependencies": {
    "@capacitor/cli": "^6.0.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "@vitejs/plugin-react": "^4.2.0",
    "autoprefixer": "^10.4.0",
    "eslint": "^8.56.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.4.5",
    "postcss": "^8.4.0",
    "prettier": "^3.0.0",
    "rimraf": "^5.0.0",
    "tailwindcss": "^3.4.0",
    "typescript": "^5.3.0",
    "vite": "^5.0.0"
  }
}
EOF
    
    npm install
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
      showSpinner: false
    },
    StatusBar: {
      style: 'light',
      backgroundColor: "#667eea"
    }
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
    sourcemap: true
  },
  server: {
    host: '0.0.0.0',
    port: 3000
  },
  define: {
    __IS_MOBILE__: mode === 'mobile'
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
      },
    },
  },
  plugins: [],
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
  },
}
EOF

    print_success "Fichiers de configuration créés"
}

# Création des fichiers sources principaux
create_source_files() {
    print_step "Création des fichiers sources..."
    
    # index.html
    cat > index.html << 'EOF'
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
    <meta name="theme-color" content="#667eea" />
    <title>Multi-Apps Platform</title>
    <style>
      body {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      }
      #root {
        height: 100vh;
      }
    </style>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
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
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
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
}
EOF

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

    # App principal
    cat > src/App.tsx << 'EOF'
import React, { useEffect, useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { Capacitor } from '@capacitor/core';
import { App as CapacitorApp } from '@capacitor/app';

import Navigation from './mobile/components/Navigation';
import LoadingScreen from './mobile/components/LoadingScreen';
import PostmathApp from './mobile/apps/postmath/PostmathApp';

const App: React.FC = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [isNative, setIsNative] = useState(false);

  useEffect(() => {
    const initialize = async () => {
      setIsNative(Capacitor.isNativePlatform());
      
      if (Capacitor.isNativePlatform()) {
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
        <main className="flex-1">
          <Routes>
            <Route path="/" element={<Navigate to="/postmath" replace />} />
            <Route path="/postmath" element={<PostmathApp isNative={isNative} />} />
          </Routes>
        </main>
        <Navigation isNative={isNative} />
      </div>
    </Router>
  );
};

export default App;
EOF

    print_success "Fichiers sources principaux créés"
}

# Création des composants
create_components() {
    print_step "Création des composants..."
    
    # Loading Screen
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

    # Navigation
    cat > src/mobile/components/Navigation.tsx << 'EOF'
import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';

interface NavigationProps {
  isNative: boolean;
}

const apps = [
  { id: 'postmath', name: 'Postmath', icon: '🧮', path: '/postmath' },
];

const Navigation: React.FC<NavigationProps> = ({ isNative }) => {
  const navigate = useNavigate();
  const location = useLocation();

  return (
    <nav className={`bg-white border-t border-gray-200 ${isNative ? 'pb-safe-bottom' : ''}`}>
      <div className="flex justify-around items-center py-2">
        {apps.map((app) => (
          <button
            key={app.id}
            onClick={() => navigate(app.path)}
            className={`flex flex-col items-center p-2 rounded-lg transition-all ${
              location.pathname === app.path
                ? 'text-indigo-600 bg-indigo-50'
                : 'text-gray-500'
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

    # Application Postmath simple
    cat > src/mobile/apps/postmath/PostmathApp.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';

interface PostmathAppProps {
  isNative?: boolean;
}

const PostmathApp: React.FC<PostmathAppProps> = ({ isNative = false }) => {
  const [num1, setNum1] = useState('');
  const [num2, setNum2] = useState('');
  const [result, setResult] = useState<number | null>(null);

  const calculate = () => {
    const a = parseFloat(num1);
    const b = parseFloat(num2);

    if (isNaN(a) || isNaN(b)) {
      alert('Veuillez entrer des nombres valides');
      return;
    }

    setResult(a + b);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-500 to-purple-600 p-4">
      <div className="max-w-md mx-auto">
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">🧮 Postmath</h1>
          <p className="text-white/80">Calculatrice Simple</p>
        </div>

        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
          <div className="space-y-4 mb-6">
            <input
              type="number"
              value={num1}
              onChange={(e) => setNum1(e.target.value)}
              placeholder="Premier nombre"
              className="w-full bg-white/90 rounded-xl p-3 text-gray-800"
            />
            
            <input
              type="number"
              value={num2}
              onChange={(e) => setNum2(e.target.value)}
              placeholder="Second nombre"
              className="w-full bg-white/90 rounded-xl p-3 text-gray-800"
            />
          </div>

          <button
            onClick={calculate}
            className="w-full bg-green-500 hover:bg-green-600 text-white font-bold py-4 rounded-xl transition-all"
          >
            ➕ Additionner
          </button>

          {result !== null && (
            <div className="mt-6 bg-green-500/30 rounded-xl p-4 text-center">
              <p className="text-2xl font-bold text-white">
                Résultat: {result}
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default PostmathApp;
EOF

    # Types
    mkdir -p src/shared/types
    cat > src/shared/types/index.ts << 'EOF'
export interface AppProps {
  isNative?: boolean;
  onAppChange?: (app: string) => void;
}
EOF

    print_success "Composants créés"
}

# Initialisation de Capacitor
init_capacitor() {
    print_step "Initialisation de Capacitor..."
    
    # Vérifier si Capacitor CLI est installé globalement
    if ! command -v cap &> /dev/null; then
        print_step "Installation de Capacitor CLI..."
        npm install -g @capacitor/cli
    fi
    
    # Initialiser Capacitor si pas déjà fait
    if [ ! -f "capacitor.config.ts" ]; then
        npx cap init "Multi-Apps Platform" "com.example.multiappsplatform" --web-dir=dist
    fi
    
    # Ajouter les plateformes si elles n'existent pas
    if [ ! -d "android" ]; then
        npx cap add android
    fi
    
    if [ ! -d "ios" ]; then
        npx cap add ios
    fi
    
    print_success "Capacitor initialisé"
}

# Mise à jour du .gitignore
update_gitignore() {
    print_step "Mise à jour du .gitignore..."
    
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/

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
*.log

# Editor
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store

# Capacitor
.capacitor/
android/app/src/main/assets/public
ios/App/App/public

# Temporary files
*.tmp
*.temp

# Backup files
backup_*
EOF

    print_success ".gitignore mis à jour"
}

# Build initial
initial_build() {
    print_step "Build initial..."
    
    # Build pour web
    npm run build:web
    
    # Build pour mobile
    npm run build:mobile
    
    # Sync avec Capacitor
    npx cap sync
    
    print_success "Build initial terminé"
}

# Création des scripts utiles
create_utility_scripts() {
    print_step "Création des scripts utiles..."
    
    # Script de développement
    cat > scripts/dev.sh << 'EOF'
#!/bin/bash
echo "🚀 Démarrage du serveur de développement..."
npm run dev
EOF

    # Script Android
    cat > scripts/android.sh << 'EOF'
#!/bin/bash
echo "🤖 Préparation Android..."
npm run build:mobile
npx cap sync android
npx cap open android
EOF

    # Script iOS
    cat > scripts/ios.sh << 'EOF'
#!/bin/bash
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ iOS uniquement disponible sur macOS"
    exit 1
fi
echo "🍎 Préparation iOS..."
npm run build:mobile
npx cap sync ios
npx cap open ios
EOF

    chmod +x scripts/*.sh
    
    print_success "Scripts utiles créés"
}

# Fonction principale
main() {
    print_header "        🚀 MIGRATION VERS ARCHITECTURE HYBRIDE"
    echo ""
    echo "Ce script va transformer votre projet en application hybride"
    echo "compatible Web, Android et iOS avec Capacitor et React."
    echo ""
    read -p "Voulez-vous continuer ? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Migration annulée"
        exit 0
    fi
    
    echo ""
    print_header "        📋 DÉBUT DE LA MIGRATION"
    
    # Exécution des étapes
    check_prerequisites
    backup_project
    clean_project
    restructure_project
    install_dependencies
    create_config_files
    create_source_files
    create_components
    update_gitignore
    init_capacitor
    create_utility_scripts
    initial_build
    
    print_header "        ✅ MIGRATION TERMINÉE AVEC SUCCÈS !"
    echo ""
    echo "🎉 Votre projet est maintenant une application hybride !"
    echo ""
    echo "📋 Commandes disponibles :"
    echo "   • npm run dev           - Développement web"
    echo "   • npm run android       - Ouvrir Android Studio"
    echo "   • npm run ios           - Ouvrir Xcode (macOS)"
    echo "   • npm run build:web     - Build web"
    echo "   • npm run build:mobile  - Build mobile"
    echo ""
    echo "📱 Scripts rapides :"
    echo "   • ./scripts/dev.sh      - Démarrer le dev"
    echo "   • ./scripts/android.sh  - Préparer Android"
    echo "   • ./scripts/ios.sh      - Préparer iOS"
    echo ""
    echo "🔧 Prochaines étapes :"
    echo "   1. Tester: npm run dev"
    echo "   2. Android: npm run android"
    echo "   3. iOS: npm run ios (sur macOS)"
    echo ""
    print_success "Migration hybride terminée ! 🚀"
}

# Exécuter le script
main "$@"