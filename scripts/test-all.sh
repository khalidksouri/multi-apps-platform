#!/bin/bash

echo "🧪 Exécution de tous les tests..."

# Tests de sécurité
echo "🔒 Tests de sécurité..."
npm run test:security

# Tests unitaires
echo "🧪 Tests unitaires..."
npm run test

# Validation de la configuration
echo "⚙️ Validation de la configuration..."
./scripts/validate-security.sh

# Tests de build
echo "🏗️ Tests de build..."
npm run build:packages

# Tests de linting
echo "📋 Tests de linting..."
npm run lint:check

echo "✅ Tous les tests terminés!"
