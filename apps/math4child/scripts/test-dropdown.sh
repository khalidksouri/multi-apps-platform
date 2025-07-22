#!/bin/bash

echo "🧪 TEST DU DROPDOWN AVANCÉ"
echo "=========================="

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
echo "📦 Dépendances:"
npm list lucide-react > /dev/null 2>&1 && echo "✅ lucide-react" || echo "❌ lucide-react manquant"

echo ""
echo "🎯 Fonctionnalités à tester:"
echo "• Recherche instantanée"
echo "• Navigation clavier (↑↓ Enter Escape)"
echo "• Scroll automatique"
echo "• Interface responsive"
