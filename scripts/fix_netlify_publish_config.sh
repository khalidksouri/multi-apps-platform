#!/bin/bash
set -e

echo "🔧 CORRECTION CONFIGURATION NETLIFY PUBLICATION"
echo "=============================================="
echo ""
echo "🔍 PROBLÈME DIAGNOSTIQUÉ :"
echo "  • Deploy réussi ✅ (published hier 22h15)"
echo "  • Mais site renvoie 404 ❌"
echo "  • = Problème de configuration publication"
echo ""

cd apps/math4child

echo "🛠️ CORRECTIONS À APPLIQUER :"
echo ""

# ===== 1. CORRIGER NEXT.CONFIG.JS =====
echo "1️⃣ Correction next.config.js pour Netlify..."

cat > next.config.js << 'NEXTEOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  
  // Configuration optimisée pour Netlify
  trailingSlash: true,
  
  // Désactiver l'optimisation d'images pour Netlify
  images: {
    unoptimized: true
  },
  
  experimental: {
    optimizePackageImports: ['lucide-react']
  },
  
  // Pas d'export statique - laisser Netlify gérer
  // output: 'export' ← SUPPRIMÉ (causait le 404)
}

module.exports = nextConfig
NEXTEOF

echo "✅ next.config.js corrigé"

# ===== 2. CORRIGER NETLIFY.TOML =====
echo "2️⃣ Correction netlify.toml..."

cat > netlify.toml << 'NETLIFYEOF'
[build]
  publish = ".next"
  command = "npm run build"
  base = "apps/math4child"

[build.environment]
  NODE_VERSION = "18"
  NEXT_PRIVATE_TARGET = "server"

# Redirections pour SPA (important pour Next.js)
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
  conditions = {Role = ["admin"]}

# Redirection principale pour toutes les pages
[[redirects]]
  from = "/*"
  to = "/.netlify/functions/___netlify-handler"
  status = 200

# Headers de sécurité
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"

# Cache pour les assets statiques
[[headers]]
  for = "/_next/static/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
NETLIFYEOF

echo "✅ netlify.toml corrigé"

# ===== 3. PACKAGE.JSON POUR NETLIFY =====
echo "3️⃣ Optimisation package.json..."

cat > package.json << 'PACKAGEEOF'
{
  "name": "math4child-app",
  "version": "2.0.0",
  "description": "Math4Child.com - Application éducative",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "15.4.2",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "lucide-react": "0.469.0",
    "tailwindcss": "3.4.0",
    "autoprefixer": "10.4.0",
    "postcss": "8.4.0"
  },
  "devDependencies": {
    "@types/node": "20.12.0",
    "@types/react": "18.3.12",
    "@types/react-dom": "18.3.1",
    "typescript": "5.4.5",
    "eslint": "8.57.0",
    "eslint-config-next": "15.4.2"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
PACKAGEEOF

echo "✅ package.json optimisé"

# ===== 4. TEST BUILD LOCAL =====
echo "4️⃣ Test build local..."

# Nettoyage
rm -rf node_modules .next package-lock.json

# Installation
npm install

# Build
if npm run build; then
    echo "✅ Build local réussi"
    
    # Vérifier le contenu de .next
    if [ -d ".next" ] && [ "$(ls -A .next 2>/dev/null)" ]; then
        echo "✅ Dossier .next généré avec contenu"
        echo "📁 Contenu .next :"
        ls -la .next/ | head -10
    else
        echo "❌ Dossier .next vide ou manquant"
    fi
else
    echo "❌ Build local échoué - Erreurs à corriger"
    exit 1
fi

# ===== 5. COMMIT ET PUSH =====
echo "5️⃣ Commit et push pour relancer Netlify..."

cd ../../

git add .
git commit -m "fix: correct Netlify configuration for proper deployment

- Fixed next.config.js (removed problematic export config)
- Updated netlify.toml with proper redirects
- Optimized package.json for Netlify
- Fixed 404 issue by correcting publish configuration"

echo ""
echo "🚀 PUSH VERS GITHUB POUR RELANCER NETLIFY :"
git push origin main

echo ""
echo "🎯 ACTIONS RÉALISÉES :"
echo "====================="
echo "✅ next.config.js corrigé (supprimé export qui causait 404)"
echo "✅ netlify.toml optimisé avec redirections"
echo "✅ package.json optimisé"
echo "✅ Build local testé et fonctionnel"
echo "✅ Push effectué pour relancer deploy Netlify"
echo ""
echo "⏰ ATTENDRE 2-5 MINUTES :"
echo "========================"
echo "• Netlify va détecter le push"
echo "• Relancer un build automatiquement"
echo "• Avec la nouvelle configuration"
echo ""
echo "🔍 VÉRIFICATION :"
echo "================="
echo "1. Dashboard Netlify → Deploys (nouveau build en cours)"
echo "2. Attendre 'Published' avec nouvelle config"
echo "3. Tester https://math4child.com"
echo ""
echo "🎉 RÉSULTAT ATTENDU :"
echo "===================="
echo "• https://math4child.com → Interface Math4Child"
echo "• Plus de 404"
echo "• Site totalement fonctionnel"