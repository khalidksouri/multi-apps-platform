#!/bin/bash

# =============================================================================
# SCRIPT DE DEBUG BUILD - Math4Child
# =============================================================================

echo "🔍 DIAGNOSTIC DU PROBLÈME DE BUILD NETLIFY"
echo "==========================================="

# Naviguer vers le bon répertoire
if [ -d "apps/math4child" ]; then
    cd apps/math4child
    echo "✅ Dans le répertoire: $(pwd)"
else
    echo "❌ Impossible de trouver apps/math4child"
    exit 1
fi

echo ""
echo "📋 VÉRIFICATION DE LA CONFIGURATION NEXT.JS:"
echo "============================================="

# Vérifier next.config.js
echo "▶ Contenu de next.config.js:"
if [ -f "next.config.js" ]; then
    cat next.config.js
else
    echo "❌ next.config.js manquant"
fi

echo ""
echo "📋 VÉRIFICATION DU PACKAGE.JSON:"
echo "================================"

# Vérifier les scripts package.json
echo "▶ Scripts dans package.json:"
if [ -f "package.json" ]; then
    node -e "console.log(JSON.stringify(JSON.parse(require('fs').readFileSync('package.json', 'utf8')).scripts, null, 2))"
else
    echo "❌ package.json manquant"
fi

echo ""
echo "🧪 TEST BUILD LOCAL:"
echo "==================="

# Test build local pour voir ce qui est généré
echo "▶ Lancement du build local..."
if npm run build; then
    echo "✅ Build local réussi"
    
    echo ""
    echo "📁 ANALYSE DES RÉPERTOIRES GÉNÉRÉS:"
    echo "==================================="
    
    # Vérifier les répertoires générés
    if [ -d ".next" ]; then
        echo "✅ Répertoire .next trouvé"
        echo "   Contenu de .next:"
        ls -la .next/ | head -10
        echo "   Taille: $(du -sh .next 2>/dev/null | cut -f1 || echo 'N/A')"
    else
        echo "❌ Répertoire .next non trouvé"
    fi
    
    if [ -d "out" ]; then
        echo "✅ Répertoire out trouvé"
        echo "   Contenu de out:"
        ls -la out/ | head -10
        echo "   Taille: $(du -sh out 2>/dev/null | cut -f1 || echo 'N/A')"
    else
        echo "❌ Répertoire out non trouvé"
    fi
    
    if [ -d "dist" ]; then
        echo "✅ Répertoire dist trouvé"
        echo "   Contenu de dist:"
        ls -la dist/ | head -10
    else
        echo "❌ Répertoire dist non trouvé"
    fi
    
else
    echo "❌ Build local échoué"
    exit 1
fi

echo ""
echo "📝 RECOMMANDATIONS NETLIFY.TOML:"
echo "================================"

# Déterminer la bonne configuration selon ce qui est généré
if [ -d "out" ]; then
    echo "✅ Configuration recommandée (export statique):"
    cat << 'EOF'
[build]
  base = "apps/math4child"
  publish = "out"
  command = "npm install --legacy-peer-deps --force && npm run build"
EOF
elif [ -d ".next" ]; then
    echo "✅ Configuration recommandée (SSR/SSG):"
    cat << 'EOF'
[build]
  base = "apps/math4child"
  publish = ".next"
  command = "npm install --legacy-peer-deps --force && npm run build"
EOF
else
    echo "❌ Aucun répertoire de build valide trouvé"
    echo "🔧 Configuration next.config.js suggérée pour export statique:"
    cat << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
}

module.exports = nextConfig
EOF
fi

echo ""
echo "🎯 PROCHAINES ÉTAPES:"
echo "===================="
echo "1. Utilisez la configuration netlify.toml recommandée ci-dessus"
echo "2. Si aucun répertoire trouvé, remplacez next.config.js par la config suggérée"
echo "3. Testez à nouveau le build local: npm run build"
echo "4. Commitez et poussez les changements"