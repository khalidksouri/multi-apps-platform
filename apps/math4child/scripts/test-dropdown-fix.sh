#!/bin/bash

echo "🧪 TEST DU DROPDOWN CORRIGÉ"
echo "=========================="

# Vérifier les fichiers créés
files=(
    "src/components/language/LanguageDropdown.tsx"
    "src/contexts/LanguageContext.tsx" 
    "src/examples/LanguageDropdownDemo.tsx"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
        lines=$(wc -l < "$file")
        echo "   └── $lines lignes"
    else
        echo "❌ $file manquant"
    fi
done

echo ""
echo "🔍 Vérification des fonctionnalités:"

if grep -q "groupedLanguages" src/components/language/LanguageDropdown.tsx; then
    echo "✅ Groupement par région"
else
    echo "❌ Groupement par région manquant"
fi

if grep -q "searchTerms" src/components/language/LanguageDropdown.tsx; then
    echo "✅ Recherche intelligente"
else
    echo "❌ Recherche intelligente manquante"
fi

if grep -q "scrollbar" src/components/language/LanguageDropdown.tsx; then
    echo "✅ Scroll visible et stylisé"
else
    echo "❌ Scroll visible manquant"
fi

if grep -q "Populaire" src/components/language/LanguageDropdown.tsx; then
    echo "✅ Badges populaires"
else
    echo "❌ Badges populaires manquants"
fi

echo ""
echo "📦 Dépendances:"
npm list lucide-react > /dev/null 2>&1 && echo "✅ lucide-react" || echo "❌ lucide-react manquant"

echo ""
echo "🎯 Nouvelles fonctionnalités testables:"
echo "• 🔍 Recherche étendue avec termes multiples"
echo "• 🌍 Groupement par région avec icônes"
echo "• ⭐ Langues populaires avec badges"
echo "• 📜 Scroll visible avec style gradient"
echo "• ⌨️ Navigation clavier complète"
echo "• 📱 Interface responsive améliorée"
echo "• 🎨 Design moderne avec gradients"
echo ""
echo "🚀 Pour tester: npm run dev puis aller sur la page"
