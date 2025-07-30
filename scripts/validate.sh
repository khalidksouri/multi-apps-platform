#!/bin/bash

echo "✅ Validation Math4Child"
echo "======================"

# Vérifier la configuration
echo "🔧 Vérification configuration..."
if [ ! -f "playwright.config.ts" ]; then
    echo "❌ playwright.config.ts manquant"
    exit 1
fi

if [ ! -f "package.json" ]; then
    echo "❌ package.json manquant"
    exit 1
fi

# Vérifier les dépendances
echo "📦 Vérification dépendances..."
if [ ! -d "node_modules" ]; then
    echo "⚠️ node_modules manquant - installation..."
    npm install
fi

# Tests rapides
echo "🧪 Tests de validation..."
npx playwright test --project=smoke --reporter=line || echo "⚠️ Certains tests ont échoué"

echo "✅ Validation terminée"
