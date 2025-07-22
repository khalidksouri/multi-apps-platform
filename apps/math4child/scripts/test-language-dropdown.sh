#!/bin/bash

echo "🧪 TEST DU DROPDOWN DE LANGUES"
echo "==============================="

# Vérifier que les fichiers existent
files=(
    "src/components/language/LanguageDropdown.tsx"
    "src/contexts/LanguageContext.tsx"
    "src/examples/LanguageDropdownExample.tsx"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file manquant"
    fi
done

echo ""
echo "📦 Vérification des dépendances:"
npm list lucide-react > /dev/null 2>&1 && echo "✅ lucide-react" || echo "❌ lucide-react manquant"

echo ""
echo "🧪 Test de compilation TypeScript:"
if npx tsc --noEmit --skipLibCheck > /dev/null 2>&1; then
    echo "✅ Compilation TypeScript OK"
else
    echo "❌ Erreurs TypeScript détectées"
fi

echo ""
echo "📝 Pour tester le composant:"
echo "1. Importez LanguageDropdown dans votre layout"
echo "2. Entourez votre app avec LanguageProvider"
echo "3. Ou utilisez l'exemple: src/examples/LanguageDropdownExample.tsx"
