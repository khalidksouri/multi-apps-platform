#!/bin/bash
set -e

echo "🚀 Préparation finale pour déploiement Netlify"
echo "============================================="

# ===== VÉRIFICATION FINALE =====
echo "🔍 Vérification finale de la configuration..."

cd apps/math4child

# Vérifier les fichiers essentiels
if [ ! -f "netlify.toml" ]; then
    echo "❌ netlify.toml manquant"
    exit 1
fi

if [ ! -f "next.config.js" ]; then
    echo "❌ next.config.js manquant"  
    exit 1
fi

echo "✅ Fichiers de configuration OK"

# Test build final
echo "🏗️ Test build final..."
npm run build

# Vérifier le dossier de sortie
if [ ! -d ".next" ]; then
    echo "❌ Dossier .next manquant après build"
    exit 1
fi

echo "✅ Build réussi - Dossier .next créé"

# ===== INFORMATIONS DÉPLOIEMENT =====
echo ""
echo "📋 INFORMATIONS POUR NETLIFY"
echo "============================"
echo ""
echo "🔧 Configuration à utiliser dans Netlify :"
echo "   Site name: math4child-app"
echo "   Repository: multi-apps-platform" 
echo "   Base directory: apps/math4child"
echo "   Build command: npm run build"
echo "   Publish directory: .next"
echo ""
echo "🌍 Domaine à configurer :"
echo "   Primary domain: math4child.com"
echo "   Alias: www.math4child.com"
echo ""
echo "⚙️ Variables d'environnement Netlify :"
echo "   NODE_VERSION=18"
echo "   NEXT_PUBLIC_APP_URL=https://math4child.com"
echo "   NEXT_PUBLIC_APP_NAME=Math4Child"
echo ""

# ===== COMMIT FINAL =====
cd ../../

echo "📝 Commit final pour déploiement..."

git add .
git commit -m "🚀 Final deployment: Math4Child ready for Netlify production

- ✅ netlify.toml configured
- ✅ next.config.js optimized for Netlify
- ✅ Build tested and working
- ✅ Environment variables set
- ✅ GitHub Actions workflow ready
- 🌍 Ready for math4child.com deployment"

echo ""
echo "🎉 PRÊT POUR DÉPLOIEMENT NETLIFY !"
echo "================================="
echo ""
echo "📋 Étapes suivantes dans Netlify Dashboard :"
echo ""
echo "1. 🌐 Aller sur : https://app.netlify.com/teams/ksourikhalid/sites"
echo ""
echo "2. ➕ Cliquer 'Add new site' → 'Import an existing project'"
echo ""
echo "3. 🔗 Connect to GitHub → Sélectionner 'multi-apps-platform'"
echo ""
echo "4. ⚙️ Configuration build :"
echo "   Base directory: apps/math4child"
echo "   Build command: npm run build" 
echo "   Publish directory: .next"
echo ""
echo "5. 🚀 Deploy site"
echo ""
echo "6. 🌍 Ajouter domaine custom : math4child.com"
echo ""
echo "7. 🔄 Push pour déclencher auto-deploy :"
echo "   git push origin main"
echo ""
echo "✨ Math4Child sera live sur https://math4child.com !"
echo ""

# ===== GUIDE RAPIDE AFFICHÉ =====
cat << 'QUICKGUIDE'
┌─────────────────────────────────────────┐
│  🚀 GUIDE RAPIDE NETLIFY DEPLOY        │
├─────────────────────────────────────────┤
│                                         │
│  1. Dashboard Netlify :                 │
│     https://app.netlify.com/teams/      │
│     ksourikhalid/sites                  │
│                                         │
│  2. Add new site → Import project       │
│                                         │
│  3. Repository: multi-apps-platform     │
│                                         │
│  4. Base dir: apps/math4child          │
│     Build cmd: npm run build           │
│     Publish dir: .next                  │
│                                         │
│  5. Deploy & add math4child.com         │
│                                         │
│  6. git push origin main                │
│                                         │
│  ✅ Live on https://math4child.com      │
│                                         │
└─────────────────────────────────────────┘
QUICKGUIDE

echo ""
echo "🎯 Prêt pour le déploiement ! Suivez le guide ci-dessus."