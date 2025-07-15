#!/bin/bash

echo "🔍 Validation de la sécurité..."

# Vérifier les fichiers essentiels
files=(
    ".env"
    "prisma/schema.prisma"
    "packages/shared/src/validation/index.ts"
    "packages/shared/src/utils/logger.ts"
)

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file présent"
    else
        echo "❌ $file manquant"
    fi
done

# Vérifier les mots de passe faibles
if grep -r "password123\|admin123\|secret123" . --exclude-dir=node_modules --exclude-dir=.git 2>/dev/null; then
    echo "❌ Mots de passe faibles détectés"
else
    echo "✅ Pas de mots de passe faibles détectés"
fi

# Vérifier les permissions
if [[ -f ".env" ]]; then
    perm=$(stat -c %a .env 2>/dev/null || stat -f %OLp .env 2>/dev/null)
    if [[ "$perm" == "644" ]] || [[ "$perm" == "600" ]]; then
        echo "✅ Permissions .env correctes"
    else
        echo "⚠️ Permissions .env à vérifier"
    fi
fi

echo "✅ Validation terminée!"
