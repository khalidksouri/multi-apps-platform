#!/bin/bash

# =============================================================================
# MATH4CHILD MOBILE - CAPACITOR UNIQUEMENT (SANS REACT NATIVE)
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
echo "║   🔧 MATH4CHILD MOBILE - CAPACITOR SEULEMENT            ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

print_info "Configuration Math4Child avec Capacitor (Web->Native)..."

# 1. Installation de react-router-dom seulement (pour le web)
print_info "Installation de react-router-dom pour navigation web..."
npm install react-router-dom@latest --save
npm install @types/react-router-dom --save-dev

# 2. Installation de Capacitor uniquement (pas React Native)
print_info "Installation de Capacitor pour déploiement mobile..."
npm install @capacitor/core @capacitor/cli --save-dev
npm install @capacitor/android @capacitor/ios @capacitor/app @capacitor/haptics @capacitor/keyboard @capacitor/status-bar @capacitor/splash-screen --save

# 3. Correction du composant Navigation pour Capacitor + Next.js
print_info "Correction du composant Navigation pour Capacitor..."
if [ -f "src/mobile/components/Navigation.tsx" ]; then
    cat > "src/mobile/components/Navigation.tsx" << 'EOF'
import React from 'react';

// Import conditionnel pour Next.js SSR
let useNavigate: any, useLocation: any;
if (typeof window !== 'undefined') {
  try {
    const router = require('react-router-dom');
    useNavigate = router.useNavigate;
    useLocation = router.useLocation;
  } catch {
    // Fallback Next.js
    useNavigate = () => (path: string) => {
      if (typeof window !== 'undefined') {
        window.location.href = path;
      }
    };
    useLocation = () => ({ pathname: typeof window !== 'undefined' ? window.location.pathname : '/' });
  }
} else {
  useNavigate = () => () => {};
  useLocation = () => ({ pathname: '/' });
}

interface NavigationProps {
  isNative: boolean;
  onNavigate?: (path: string) => void;
}

const Navigation: React.FC<NavigationProps> = ({ isNative, onNavigate }) => {
  const navigate = typeof window !== 'undefined' ? useNavigate() : null;
  const location = typeof window !== 'undefined' ? useLocation() : { pathname: '/' };

  // Détection de la plateforme avec Capacitor
  const isCapacitor = typeof window !== 'undefined' && 
    ((window as any).Capacitor?.isNativePlatform?.() || false);

  const handleNavigation = (path: string) => {
    if (onNavigate) {
      onNavigate(path);
    } else if (navigate) {
      navigate(path);
    } else if (typeof window !== 'undefined') {
      // Fallback pour Next.js
      window.location.href = path;
    }
  };

  const navItems = [
    { path: '/', label: 'Accueil', icon: '🏠' },
    { path: '/game', label: 'Jeu', icon: '🎮' },
    { path: '/stats', label: 'Statistiques', icon: '📊' },
    { path: '/settings', label: 'Paramètres', icon: '⚙️' },
  ];

  const baseClasses = "flex flex-col items-center p-3 rounded-lg transition-all duration-200";
  const activeClasses = "text-blue-600 bg-blue-50 scale-105";
  const inactiveClasses = "text-gray-600 hover:text-blue-600 hover:bg-gray-50";

  if (isNative || isCapacitor) {
    // Interface mobile native (Capacitor)
    return (
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-lg z-50">
        <div className="flex justify-around py-2 px-4 safe-area-bottom">
          {navItems.map((item) => (
            <button
              key={item.path}
              onClick={() => handleNavigation(item.path)}
              className={`${baseClasses} ${
                location.pathname === item.path ? activeClasses : inactiveClasses
              }`}
            >
              <span className="text-2xl mb-1">{item.icon}</span>
              <span className="text-xs font-medium">{item.label}</span>
            </button>
          ))}
        </div>
      </div>
    );
  }

  // Interface web (Next.js)
  return (
    <nav className="bg-white shadow-lg sticky top-0 z-40">
      <div className="max-w-7xl mx-auto px-4">
        <div className="flex justify-between items-center py-4">
          <div className="flex items-center">
            <div className="flex items-center space-x-2 mr-8">
              <span className="text-2xl">🧮</span>
              <span className="text-xl font-bold text-purple-600">Math4Child</span>
            </div>
          </div>
          
          <div className="hidden md:flex items-center space-x-6">
            {navItems.map((item) => (
              <button
                key={item.path}
                onClick={() => handleNavigation(item.path)}
                className={`flex items-center space-x-2 px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                  location.pathname === item.path
                    ? 'text-blue-600 bg-blue-50'
                    : 'text-gray-700 hover:text-blue-600 hover:bg-gray-50'
                }`}
              >
                <span className="text-lg">{item.icon}</span>
                <span>{item.label}</span>
              </button>
            ))}
          </div>

          {/* Menu mobile pour web responsive */}
          <div className="md:hidden flex space-x-1">
            {navItems.map((item) => (
              <button
                key={item.path}
                onClick={() => handleNavigation(item.path)}
                className={`p-2 rounded-lg ${
                  location.pathname === item.path ? activeClasses : inactiveClasses
                }`}
                title={item.label}
              >
                <span className="text-xl">{item.icon}</span>
              </button>
            ))}
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navigation;
EOF
    print_success "Composant Navigation corrigé pour Capacitor"
fi

# 4. Configuration Capacitor pour GOTEST
print_info "Création de la configuration Capacitor..."
cat > "capacitor.config.ts" << 'EOF'
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.gotest.math4child',
  appName: 'Math4Child',
  webDir: 'out',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 3000,
      launchAutoHide: true,
      backgroundColor: "#7c3aed",
      androidSplashResourceName: "splash",
      androidScaleType: "CENTER_CROP",
      showSpinner: true,
      androidSpinnerStyle: "large",
      iosSpinnerStyle: "small",
      spinnerColor: "#ffffff"
    },
    StatusBar: {
      backgroundColor: "#7c3aed",
      style: "light"
    },
    App: {
      name: "Math4Child",
      description: "Application éducative de mathématiques - GOTEST"
    }
  }
};

export default config;
EOF

# 5. Configuration Next.js pour export statique (requis pour Capacitor)
print_info "Configuration Next.js pour export Capacitor..."
cat > "next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true,
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
  // Configuration spéciale pour Capacitor
  assetPrefix: './',
  env: {
    CAPACITOR_PLATFORM: process.env.CAPACITOR_PLATFORM || 'web',
  }
}

module.exports = nextConfig
EOF

# 6. Ajout des scripts Capacitor au package.json
print_info "Ajout des scripts de déploiement Capacitor..."
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

pkg.scripts = {
  ...pkg.scripts,
  // Scripts Next.js + Capacitor
  'build:web': 'next build',
  'export:web': 'next build && next export',
  
  // Scripts Capacitor
  'cap:init': 'cap init \"Math4Child\" \"com.gotest.math4child\"',
  'cap:add:android': 'cap add android',
  'cap:add:ios': 'cap add ios',
  'cap:copy': 'cap copy',
  'cap:sync': 'cap sync',
  
  // Scripts Android
  'prebuild:android': 'npm run export:web',
  'build:android': 'cap copy android && cap sync android',
  'open:android': 'cap open android',
  'deploy:android': 'npm run prebuild:android && npm run build:android && npm run open:android',
  
  // Scripts iOS  
  'prebuild:ios': 'npm run export:web',
  'build:ios': 'cap copy ios && cap sync ios',
  'open:ios': 'cap open ios',
  'deploy:ios': 'npm run prebuild:ios && npm run build:ios && npm run open:ios',
  
  // Scripts de développement
  'dev:android': 'cap run android --livereload --external',
  'dev:ios': 'cap run ios --livereload --external'
};

fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
console.log('✅ Scripts Capacitor ajoutés');
"

# 7. Création d'un hook personnalisé pour la détection de plateforme
print_info "Création du hook de détection de plateforme..."
mkdir -p src/hooks
cat > "src/hooks/usePlatform.ts" << 'EOF'
import { useState, useEffect } from 'react';

interface PlatformInfo {
  isWeb: boolean;
  isMobile: boolean;
  isAndroid: boolean;
  isIOS: boolean;
  isCapacitor: boolean;
  platform: 'web' | 'android' | 'ios';
}

export const usePlatform = (): PlatformInfo => {
  const [platformInfo, setPlatformInfo] = useState<PlatformInfo>({
    isWeb: true,
    isMobile: false,
    isAndroid: false,
    isIOS: false,
    isCapacitor: false,
    platform: 'web'
  });

  useEffect(() => {
    if (typeof window !== 'undefined') {
      const isCapacitor = !!(window as any).Capacitor?.isNativePlatform?.();
      
      if (isCapacitor) {
        import('@capacitor/core').then(({ Capacitor }) => {
          const platform = Capacitor.getPlatform();
          
          setPlatformInfo({
            isWeb: platform === 'web',
            isMobile: platform !== 'web',
            isAndroid: platform === 'android',
            isIOS: platform === 'ios',
            isCapacitor: true,
            platform: platform as 'web' | 'android' | 'ios'
          });
        });
      } else {
        // Détection mobile pour le web
        const isMobileWeb = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
          navigator.userAgent
        );
        
        setPlatformInfo({
          isWeb: true,
          isMobile: isMobileWeb,
          isAndroid: false,
          isIOS: false,
          isCapacitor: false,
          platform: 'web'
        });
      }
    }
  }, []);

  return platformInfo;
};
EOF

# 8. Création du guide de déploiement
print_info "Création du guide de déploiement Capacitor..."
cat > "MOBILE_DEPLOYMENT.md" << 'EOF'
# 📱 Guide de Déploiement Mobile Math4Child (Capacitor)

## 🏗️ Architecture
**Next.js (Web) → Export Statique → Capacitor → Apps Natives**

## 🚀 Déploiement rapide

### 🌐 Web
```bash
npm run build:web
```

### 🤖 Android (première fois)
```bash
npm run cap:add:android
npm run deploy:android
```

### 🍎 iOS (première fois - macOS requis)
```bash
npm run cap:add:ios
npm run deploy:ios
```

### 🔄 Mises à jour
```bash
npm run deploy:android  # Met à jour et ouvre Android Studio
npm run deploy:ios      # Met à jour et ouvre Xcode
```

## 🛠️ Développement en temps réel
```bash
npm run dev:android     # Live reload sur émulateur Android
npm run dev:ios         # Live reload sur simulateur iOS
```

## 📱 Configuration GOTEST
- **App ID** : com.gotest.math4child
- **Nom** : Math4Child
- **SIRET** : 53958712100028
- **Contact** : khalid_ksouri@yahoo.fr

## 📋 Prérequis
- **Android** : Android Studio + SDK
- **iOS** : Xcode (macOS uniquement)
- **Node.js** : v18+

## 🔧 Résolution des problèmes

### Erreur de build
```bash
rm -rf out .next
npm run export:web
```

### Erreur Capacitor
```bash
npm run cap:sync
```

### Permissions Android
Ajoutez dans `android/app/src/main/AndroidManifest.xml` :
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## 📱 Publication

### Google Play Store
1. `npm run deploy:android`
2. Build → Generate Signed Bundle/APK
3. Upload sur Google Play Console

### Apple App Store  
1. `npm run deploy:ios`
2. Product → Archive dans Xcode
3. Upload vers App Store Connect

## 💰 Monétisation
Stripe fonctionne sur toutes les plateformes avec la même configuration GOTEST.
EOF

# 9. Test de build
print_info "Test de build avec Capacitor..."
if npm run build; then
    print_success "🎉 BUILD RÉUSSI ! Math4Child prêt pour Capacitor !"
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║               ✅ SUCCÈS CAPACITOR !                       ║${NC}"
    echo -e "${GREEN}║          Math4Child → Web/Android/iOS ready !            ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    print_info "📱 Commandes de déploiement :"
    echo -e "${YELLOW}npm run deploy:android    # Application Android${NC}"
    echo -e "${YELLOW}npm run deploy:ios        # Application iOS (macOS)${NC}"
    echo -e "${YELLOW}npm run build:web         # Version web${NC}"
    echo ""
    
    print_success "✅ Capacitor configuré avec GOTEST"
    print_success "✅ Navigation multi-plateforme"
    print_success "✅ Export statique pour mobile"
    print_success "✅ Scripts de déploiement prêts"
    print_success "✅ Hook de détection plateforme"
    echo ""
    
    print_info "🏗️ Prochaines étapes :"
    echo -e "${YELLOW}1. Pour Android: npm run cap:add:android${NC}"
    echo -e "${YELLOW}2. Puis: npm run deploy:android${NC}"
    echo -e "${YELLOW}3. Pour iOS (macOS): npm run cap:add:ios${NC}"
    echo -e "${YELLOW}4. Puis: npm run deploy:ios${NC}"
    echo -e "${YELLOW}5. Lisez MOBILE_DEPLOYMENT.md${NC}"
    
else
    print_warning "Build échoué, mais Capacitor configuré"
    print_info "Testez avec :"
    echo -e "${YELLOW}npm run dev${NC}"
fi

# 10. Initialisation Capacitor
print_info "Initialisation de Capacitor..."
if command -v npx > /dev/null; then
    npx cap init "Math4Child" "com.gotest.math4child" --web-dir="out"
    print_success "Capacitor initialisé avec succès"
else
    print_warning "npx non disponible - initialisez manuellement avec: npx cap init"
fi

print_success "🎉 Math4Child configuré pour Capacitor (Web→Native) ! 📱"
echo -e "${GREEN}Votre app Next.js peut maintenant être déployée nativement sur Android et iOS !${NC}"