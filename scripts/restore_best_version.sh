#!/bin/bash

echo "🔄 RESTAURATION DE LA MEILLEURE VERSION IDENTIFIÉE"

# La version la plus volumineuse = la plus complète
BEST_VERSION="apps/math4child/src/app/page.tsx.backup-final-20250726-003835"

# Sauvegarde de l'actuel
cp apps/math4child/src/app/page.tsx apps/math4child/src/app/page.tsx.current_buggy_$(date +%H%M%S)

echo "✅ Restauration de la version finale (36K - la plus complète)"
cp "$BEST_VERSION" apps/math4child/src/app/page.tsx

echo "�� Vérification de la version restaurée..."
head -10 apps/math4child/src/app/page.tsx

echo "🧹 Nettoyage cache complet"
rm -rf .next

echo "📦 Réinstallation des dépendances"
npm install --force

echo "✅ MEILLEURE VERSION RESTAURÉE (36K - finale)"
