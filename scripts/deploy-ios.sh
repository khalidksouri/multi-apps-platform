#!/bin/bash
# Déploiement iOS (App Store)

echo "🍎 Déploiement iOS Math4Child..."

# Vérifications macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ iOS nécessite macOS"
    exit 1
fi

# Vérifications
if [ ! -d "ios" ]; then
    echo "📁 Initialisation du projet iOS..."
    npx cap add ios
fi

# Build
echo "📦 Build iOS..."
npm run build
npx cap copy ios
npx cap update ios

# Ouvrir Xcode
echo "🔧 Ouverture Xcode..."
npx cap open ios

echo "✅ Projet iOS prêt pour App Store"
echo "💡 Configurez les certificats dans Xcode avant soumission"
