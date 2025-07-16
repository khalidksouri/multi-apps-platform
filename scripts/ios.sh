#!/bin/bash
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ iOS uniquement disponible sur macOS"
    exit 1
fi
echo "🍎 Préparation iOS..."
npm run build:mobile
npx cap sync ios
npx cap open ios
