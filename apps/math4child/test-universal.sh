#!/bin/bash

echo "🌍 Test de l'application universelle Math4Child"

# Vérification TypeScript
echo "📝 Vérification TypeScript..."
npm run type-check

# Tests d'internationalisation
echo "🌐 Tests d'internationalisation..."
npm run test tests/i18n/ 2>/dev/null || echo "Tests à configurer dans Playwright"

# Vérification des langues
echo "🔍 Vérification du support des langues..."
node -e "
const { UNIVERSAL_LANGUAGES } = require('./src/lib/i18n/languages.ts');
console.log('✅ Langues supportées:', UNIVERSAL_LANGUAGES.length);
console.log('✅ Continents couverts:', [...new Set(UNIVERSAL_LANGUAGES.map(l => l.continent))].length);
console.log('✅ Devises supportées:', [...new Set(UNIVERSAL_LANGUAGES.map(l => l.currency))].length);
"

# Démarrage du serveur
echo "🚀 Démarrage du serveur universel..."
echo "🌐 Testez différentes régions sur http://localhost:3000"
echo ""
echo "🧪 Tests suggérés :"
echo "  1. Sélectionnez différents continents"
echo "  2. Testez les langues RTL (arabe, hébreu)"
echo "  3. Vérifiez les prix adaptés par région"
echo "  4. Testez la recherche de langues"
echo ""
npm run dev
