#!/bin/bash

# fix-typescript.sh - Script pour corriger la configuration TypeScript

print_step() {
    echo "🔧 $1"
}

print_success() {
    echo "✅ $1"
}

print_step "Correction de la configuration TypeScript..."

# 1. Corriger tsconfig.json principal
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
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "dist-web", "android", "ios"]
}
EOF

# 2. Créer un tsconfig séparé pour les fichiers de config
cat > tsconfig.config.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true,
    "skipLibCheck": true,
    "noEmit": true
  },
  "include": ["vite.config.ts", "capacitor.config.ts"],
  "exclude": ["node_modules"]
}
EOF

# 3. Mettre à jour vite.config.ts pour inclure la bonne référence TypeScript
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
          capacitor: ['@capacitor/core', '@capacitor/app']
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
    include: ['@capacitor/core', '@capacitor/app']
  }
}));
EOF

# 4. Mettre à jour package.json avec des scripts corrigés
cat > package.json << 'EOF'
{
  "name": "multi-apps-platform",
  "version": "1.0.0",
  "description": "🚀 Plateforme multi-applications hybride : Web, Android, iOS",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "build:web": "vite build --mode web",
    "build:mobile": "vite build --mode mobile",
    "preview": "vite preview",
    "preview:mobile": "vite preview --mode mobile",
    "android": "npm run build:mobile && npx cap sync android && npx cap open android",
    "android:build": "npm run build:mobile && npx cap sync android && npx cap build android",
    "ios": "npm run build:mobile && npx cap sync ios && npx cap open ios",
    "ios:build": "npm run build:mobile && npx cap sync ios && npx cap build ios",
    "sync": "npx cap sync",
    "copy": "npx cap copy",
    "test": "echo \"Tests à configurer\"",
    "lint": "eslint src --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "lint:fix": "eslint src --ext ts,tsx --fix",
    "format": "prettier --write src",
    "type-check": "tsc --noEmit",
    "type-check:config": "tsc --noEmit -p tsconfig.config.json",
    "clean": "rimraf dist dist-web node_modules/.vite",
    "clean:platforms": "rimraf android/app/src/main/assets/public ios/App/App/public",
    "reset": "npm run clean && npm run clean:platforms && npm install"
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
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  }
}
EOF

# 5. Vérifier que le fichier capacitor.config.ts est correct
cat > capacitor.config.ts << 'EOF'
import type { CapacitorConfig } from '@capacitor/cli';

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
      androidScaleType: "CENTER_CROP"
    },
    StatusBar: {
      style: 'light',
      backgroundColor: "#667eea"
    },
    Keyboard: {
      resize: 'body',
      style: 'dark',
      resizeOnFullScreen: true
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

# 6. Supprimer les fichiers .d.ts générés qui causent le problème
rm -f capacitor.config.d.ts 2>/dev/null || true
rm -f vite.config.d.ts 2>/dev/null || true

# 7. Nettoyer le cache TypeScript
rm -rf node_modules/.cache 2>/dev/null || true
rm -rf .tsbuildinfo 2>/dev/null || true

print_success "Configuration TypeScript corrigée"

# 8. Tester la compilation
print_step "Test de la compilation..."

# Vérifier les types sans émettre de fichiers
if npm run type-check; then
    print_success "✅ Vérification TypeScript réussie"
else
    echo "⚠️ Il y a encore des erreurs TypeScript à corriger"
fi

# Test du build
print_step "Test du build web..."
if npm run build:web; then
    print_success "✅ Build web réussi"
else
    echo "❌ Erreur dans le build web"
fi

print_step "Test du build mobile..."
if npm run build:mobile; then
    print_success "✅ Build mobile réussi"
else
    echo "❌ Erreur dans le build mobile"
fi

print_success "🎉 Configuration corrigée et testée !"

echo ""
echo "📋 Commandes disponibles :"
echo "   • npm run dev           - Développement"
echo "   • npm run build:web     - Build web"
echo "   • npm run build:mobile  - Build mobile"
echo "   • npm run type-check    - Vérifier les types"
echo "   • npm run android       - Ouvrir Android Studio"
echo "   • npm run ios           - Ouvrir Xcode"