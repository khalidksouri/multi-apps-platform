#!/bin/bash

echo "🏥 Vérification du système de traduction"
echo "======================================="

if [ -f "src/components/language/LanguageDropdown.tsx" ]; then
    echo "✅ Composant LanguageDropdown trouvé"
else
    echo "❌ Composant LanguageDropdown manquant"
fi

if [ -f "src/contexts/LanguageContext.tsx" ]; then
    echo "✅ Contexte de langue trouvé"
else
    echo "❌ Contexte de langue manquant"
fi

if [ -f "tests/translation/translation-basic.spec.ts" ]; then
    echo "✅ Tests de base trouvés"
else
    echo "❌ Tests de base manquants"
fi

echo ""
echo "🎯 Pour tester: npm run test:translation:quick"
echo "🌐 Projet Netlify: https://app.netlify.com/projects/prismatic-sherbet-986159"
