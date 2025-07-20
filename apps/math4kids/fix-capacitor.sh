#!/bin/bash

cd /Users/khalidksouri/Desktop/multi-apps-platform/apps/math4kids

echo "🔧 Correction de la configuration Capacitor..."

# Supprimer les anciens fichiers
rm -f capacitor.config.ts capacitor.config.js capacitor.config.json

# Réinitialiser Capacitor
npx cap init math4kids com.math4kids.app --web-dir=out

# Créer la configuration optimisée
cat > capacitor.config.ts << 'CONFIG'
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.math4kids.app',
  appName: 'Math4Kids',
  webDir: 'out',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: '#7c3aed'
    }
  }
};

export default config;
CONFIG

echo "✅ Capacitor corrigé ! Vous pouvez maintenant :"
echo "1. npm run build"
echo "2. npx cap add android"
echo "3. npx cap add ios"
echo "4. npm run dev"

