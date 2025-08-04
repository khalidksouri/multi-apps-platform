#!/bin/bash

# =============================================================================
# FIX D'URGENCE IMMÉDIAT - 30 SECONDES
# Résolution rapide du submodule corrompu
# =============================================================================

echo "🚨 FIX D'URGENCE - SUBMODULE CORROMPU"
echo "====================================="

# 1. Supprimer .gitmodules immédiatement
echo "1️⃣ Suppression .gitmodules..."
rm -f .gitmodules

# 2. Supprimer le dossier .git/modules
echo "2️⃣ Suppression .git/modules..."
rm -rf .git/modules

# 3. Supprimer le dossier problématique
echo "3️⃣ Suppression dossier temp..."
rm -rf temp_math4child_1753401932

# 4. Nettoyer l'index Git
echo "4️⃣ Nettoyage index Git..."
git rm --cached temp_math4child_1753401932 2>/dev/null || true
git rm --cached .gitmodules 2>/dev/null || true

# 5. Nettoyage config Git
echo "5️⃣ Nettoyage config Git..."
git config --remove-section submodule.temp_math4child_1753401932 2>/dev/null || true

# 6. Commit et push immédiat
echo "6️⃣ Commit et push..."
git add -A
git commit -m "fix: remove corrupted submodule - emergency fix"
git push origin main

echo ""
echo "✅ FIX TERMINÉ !"
echo "🔄 Nouveau build Netlify va démarrer automatiquement"
echo "⏰ Attendre 2-3 minutes..."
echo ""
echo "📊 Surveillez: https://app.netlify.com/sites/prismatic-sherbet-986159/deploys"