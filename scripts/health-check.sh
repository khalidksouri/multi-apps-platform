#!/bin/bash

echo "🏥 Vérification de santé Math4Child"
echo "===================================="

# Vérifications des fichiers essentiels
checks=(
    "src/lib/optimal-payments.ts:✅ OptimalPayments"
    "src/components/language/LanguageDropdown.tsx:✅ LanguageDropdown"
    "src/contexts/LanguageContext.tsx:✅ LanguageContext"
    "src/translations/index.ts:✅ Translations"
    "src/app/layout.tsx:✅ App Layout"
    "tailwind.config.js:✅ TailwindCSS"
    "next.config.js:✅ Next.js Config"
    "netlify.toml:✅ Netlify Config"
)

for check in "${checks[@]}"; do
    file="${check%%:*}"
    message="${check##*:}"
    
    if [ -f "$file" ]; then
        echo "$message trouvé"
    else
        echo "❌ $file manquant"
    fi
done

echo ""
echo "🎯 Tests recommandés:"
echo "  - Build local: npm run build"
echo "  - Test traduction: npm run test:translation:quick"
echo ""
echo "🌐 Déploiement Netlify:"
echo "  - git add . && git commit -m 'fix: resolve build errors' && git push"
