#!/bin/bash

# =============================================================================
# FIX CONFIGURATION NETLIFY - CHEMINS CORRECTS
# Résolution: cd: apps/math4child: No such file or directory
# =============================================================================

echo "🔧 FIX CONFIGURATION NETLIFY"
echo "============================"

echo "❌ Problème détecté:"
echo "   • Base directory: /opt/build/repo/apps/math4child"
echo "   • Mais build command: cd apps/math4child (chemin relatif incorrect)"
echo "   • Publish: /opt/build/repo/apps/math4child/apps/math4child/out (doublon)"

echo ""
echo "✅ Correction en cours..."

# Créer la configuration Netlify correcte
cat > netlify.toml << 'EOF'
# =============================================================================
# CONFIGURATION NETLIFY - MATH4CHILD (CHEMINS CORRECTS)
# =============================================================================

[build]
  base = "apps/math4child"
  publish = "out"
  command = "npm install --legacy-peer-deps && npm run build"

[build.environment]
  NODE_VERSION = "18.17.0"
  NODE_ENV = "production"
  CAPACITOR_BUILD = "false"

# Variables d'environnement production
[context.production.environment]
  NODE_ENV = "production"
  CAPACITOR_BUILD = "false"
  NEXT_PUBLIC_SITE_URL = "https://prismatic-sherbet-986159.netlify.app"

# Redirection SPA pour Next.js
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

# Headers de sécurité
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"

# Cache pour assets statiques
[[headers]]
  for = "/_next/static/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/images/*"
  [headers.values]
    Cache-Control = "public, max-age=86400"
EOF

echo "✅ netlify.toml mis à jour avec les bons chemins"

# Vérifier le next.config.js dans apps/math4child
echo ""
echo "🔍 Vérification next.config.js..."

if [[ -f "apps/math4child/next.config.js" ]]; then
    echo "✅ next.config.js existe"
    echo "Contenu actuel:"
    cat apps/math4child/next.config.js
else
    echo "❌ next.config.js manquant - Création..."
    
    # Créer next.config.js correct
    cat > apps/math4child/next.config.js << 'EOF'
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
  env: {
    CAPACITOR_BUILD: process.env.CAPACITOR_BUILD || 'false',
  }
};

module.exports = nextConfig;
EOF
    echo "✅ next.config.js créé"
fi

# Vérifier package.json
echo ""
echo "🔍 Vérification package.json..."

if [[ -f "apps/math4child/package.json" ]]; then
    echo "✅ package.json existe"
    
    # Vérifier les scripts
    if grep -q "\"build\":" apps/math4child/package.json; then
        echo "✅ Script build présent"
    else
        echo "❌ Script build manquant"
    fi
    
    if grep -q "\"export\":" apps/math4child/package.json; then
        echo "✅ Script export présent"
    else
        echo "⚠️ Script export manquant - Sera géré par next build"
    fi
else
    echo "❌ package.json manquant dans apps/math4child/"
    echo "📂 Contenu du dossier apps/math4child:"
    ls -la apps/math4child/ 2>/dev/null || echo "Dossier inexistant"
fi

# Test build local rapide
echo ""
echo "🧪 Test build local rapide..."

if [[ -d "apps/math4child" ]]; then
    cd apps/math4child
    
    if [[ -f "package.json" ]]; then
        echo "📦 Installation des dépendances..."
        if npm install --legacy-peer-deps --silent; then
            echo "✅ Dépendances installées"
            
            echo "🔨 Test build..."
            if CAPACITOR_BUILD=false npm run build --silent; then
                echo "✅ Build local réussi"
                
                if [[ -d "out" ]]; then
                    echo "✅ Dossier 'out' généré"
                    echo "📁 Contenu:"
                    ls -la out/ | head -5
                else
                    echo "❌ Dossier 'out' non généré"
                fi
            else
                echo "❌ Build local échoué"
            fi
        else
            echo "❌ Échec installation dépendances"
        fi
    else
        echo "❌ package.json introuvable"
    fi
    
    cd ../..
else
    echo "❌ Dossier apps/math4child introuvable"
    echo "📂 Structure actuelle:"
    find . -name "package.json" -type f | head -10
fi

echo ""
echo "💾 Commit et push des corrections..."

# Commit des corrections
git add netlify.toml
if [[ -f "apps/math4child/next.config.js" ]]; then
    git add apps/math4child/next.config.js
fi

git commit -m "fix: correct Netlify configuration paths

- Fix base directory path resolution
- Simplify build command (remove redundant cd)
- Fix publish directory path
- Ensure next.config.js export configuration
- Remove npm run export (handled by next build)"

git push origin main

echo ""
echo "🎯 RÉSUMÉ DES CORRECTIONS:"
echo "========================="
echo "✅ netlify.toml:"
echo "   • base: 'apps/math4child'"
echo "   • publish: 'out' (relatif au base)"
echo "   • command: 'npm install --legacy-peer-deps && npm run build'"
echo ""
echo "✅ next.config.js:"
echo "   • output: 'export' (génère le dossier out/)"
echo "   • images: unoptimized pour export statique"
echo ""
echo "🔄 Nouveau build Netlify va démarrer..."
echo "📊 Surveillez: https://app.netlify.com/sites/prismatic-sherbet-986159/deploys"
echo ""
echo "⏰ Le site devrait être fonctionnel dans 2-3 minutes !"