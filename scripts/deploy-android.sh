#!/bin/bash
# Déploiement Android (Google Play Store)

echo "📱 Déploiement Android Math4Child..."

# Vérifications
if [ ! -d "android" ]; then
    echo "📁 Initialisation du projet Android..."
    npx cap add android
fi

# Build
echo "📦 Build Android..."
npm run build
npx cap copy android
npx cap update android

# Ouvrir Android Studio
echo "🔧 Ouverture Android Studio..."
npx cap open android

echo "✅ Projet Android prêt pour Google Play Store"
echo "💡 N'oubliez pas de signer l'APK avant publication"
