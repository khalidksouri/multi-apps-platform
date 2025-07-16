#!/bin/bash

# Script de validation AI4KIDS
echo "🔍 Validation de l'installation AI4KIDS..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
AI4KIDS_DIR="$PROJECT_ROOT/apps/ai4kids"

errors=0

# Vérifier la structure des fichiers
echo "📁 Vérification de la structure..."
required_files=(
    "src/components/AI4KidsLogo.tsx"
    "src/components/Header.tsx"
    "src/components/ui/Button.tsx"
    "src/components/ui/Card.tsx"
    "src/styles/ai4kids.css"
    "src/app/page.tsx"
    "src/app/layout.tsx"
    "src/app/globals.css"
    "public/favicon.svg"
    "public/site.webmanifest"
    "package.json"
    "tsconfig.json"
    "tailwind.config.js"
    "next.config.js"
)

for file in "${required_files[@]}"; do
    if [ ! -f "$AI4KIDS_DIR/$file" ]; then
        echo "❌ Fichier manquant: $file"
        errors=$((errors + 1))
    else
        echo "✅ Trouvé: $file"
    fi
done

# Vérifier les dépendances
echo "📦 Vérification des dépendances..."
cd "$AI4KIDS_DIR"
if [ -f "package.json" ]; then
    if npm list --depth=0 >/dev/null 2>&1; then
        echo "✅ Dépendances OK"
    else
        echo "❌ Problème avec les dépendances"
        errors=$((errors + 1))
    fi
fi

# Vérifier TypeScript
echo "🔧 Vérification TypeScript..."
if npm run type-check >/dev/null 2>&1; then
    echo "✅ TypeScript OK"
else
    echo "❌ Erreurs TypeScript détectées"
    errors=$((errors + 1))
fi

# Résultat final
echo ""
if [ $errors -eq 0 ]; then
    echo "🎉 Validation réussie ! AI4KIDS est prêt."
else
    echo "❌ $errors erreur(s) détectée(s)."
fi

exit $errors
