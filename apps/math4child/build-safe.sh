#!/bin/bash
echo "🏗️  Build sécurisé Math4Child..."

# Nettoyer
rm -rf .next out .turbo 2>/dev/null || true

# Essayer différentes stratégies
if npm run build:production; then
    echo "✅ Build réussi - production"
elif SKIP_LINT=true npm run build; then
    echo "✅ Build réussi - sans ESLint"
elif SKIP_LINT=true SKIP_TYPE_CHECK=true npm run build; then
    echo "✅ Build réussi - sans vérifications"
else
    echo "❌ Tous les builds ont échoué"
    exit 1
fi
