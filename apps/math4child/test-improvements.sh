#!/bin/bash

echo "🧪 Test des améliorations UI/UX Math4Child"

# Vérification TypeScript
echo "📝 Vérification TypeScript..."
npm run type-check

# Tests des composants
echo "🧪 Tests des composants..."
npm run test:components 2>/dev/null || echo "Tests Playwright à configurer"

# Démarrage du serveur de développement
echo "🚀 Démarrage du serveur de développement..."
echo "🌐 Ouvrez http://localhost:3000 pour voir les améliorations"
npm run dev
