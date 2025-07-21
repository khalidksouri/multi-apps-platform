#!/bin/bash

# ===================================================================
# INSTALLATION RAPIDE TESTS MATH4CHILD
# Script d'installation en une commande
# ===================================================================

set -e

echo "🚀 Installation rapide des tests Math4Child..."

# Vérifier Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js requis. Installez Node.js >= 18.0.0"
    exit 1
fi

# Installation des dépendances
echo "📦 Installation des dépendances..."
npm install

# Installation des navigateurs Playwright
echo "🌐 Installation des navigateurs Playwright..."
npx playwright install --with-deps

# Test de validation
echo "✅ Test de validation..."
if npx playwright --version > /dev/null 2>&1; then
    echo "✅ Installation réussie !"
    echo ""
    echo "🎯 Commandes principales :"
    echo "  make test          # Tous les tests"
    echo "  make test-headed   # Tests avec interface"
    echo "  make test-mobile   # Tests mobile"
    echo "  make help          # Aide complète"
    echo ""
    echo "📚 Voir README.md pour plus d'informations"
else
    echo "❌ Problème avec l'installation"
    exit 1
fi
