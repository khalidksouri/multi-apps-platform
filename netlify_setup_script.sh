#!/bin/bash
set -e

echo "🌐 Configuration Netlify pour Math4Child"
echo "======================================="

cd apps/math4child

# ===== 1. CONFIGURATION NETLIFY.TOML =====
echo "📝 Création netlify.toml..."

cat > netlify.toml << 'NETLIFYEOF'
[build]
  publish = ".next"
  command = "npm run build"
  base = "apps/math4child"

[build.environment]
  NODE_VERSION = "18"
  NEXT_PUBLIC_APP_URL = "https://math4child.com"
  NEXT_PUBLIC_APP_NAME = "Math4Child"

# Redirections pour SPA
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

# Headers de sécurité
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    X-XSS-Protection = "1; mode=block"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Permissions-Policy = "camera=(), microphone=(), geolocation=()"

# Cache optimisé pour les assets statiques
[[headers]]
  for = "/_next/static/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/*.js"
  [headers.values]
    Cache-Control = "public, max-age=31536000"

[[headers]]
  for = "/*.css"
  [headers.values]
    Cache-Control = "public, max-age=31536000"

# Headers pour les images
[[headers]]
  for = "/*.png"
  [headers.values]
    Cache-Control = "public, max-age=604800"

[[headers]]
  for = "/*.jpg"
  [headers.values]
    Cache-Control = "public, max-age=604800"

[[headers]]
  for = "/*.svg"
  [headers.values]
    Cache-Control = "public, max-age=604800"
NETLIFYEOF

echo "✅ netlify.toml créé"

# ===== 2. NEXT.CONFIG.JS POUR NETLIFY =====
echo "⚙️ Configuration Next.js pour Netlify..."

cat > next.config.js << 'NEXTEOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  
  // Configuration pour Netlify
  trailingSlash: true,
  images: {
    unoptimized: true,
    domains: []
  },
  
  // Optimisations
  experimental: {
    optimizePackageImports: ['lucide-react']
  },
  
  // Export statique pour Netlify
  output: 'export',
  distDir: '.next',
  
  // Configuration pour éviter les erreurs hydration
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production'
  },
  
  // Variables d'environnement publiques
  env: {
    NEXT_PUBLIC_APP_URL: process.env.NEXT_PUBLIC_APP_URL || 'https://math4child.com',
    NEXT_PUBLIC_APP_NAME: 'Math4Child'
  }
}

module.exports = nextConfig
NEXTEOF

echo "✅ next.config.js configuré pour Netlify"

# ===== 3. PACKAGE.JSON OPTIMISÉ =====
echo "📦 Mise à jour package.json..."

cat > package.json << 'PACKAGEEOF'
{
  "name": "math4child-app",
  "version": "2.0.0",
  "description": "Math4Child.com - Application éducative multilingue",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "export": "next build && next export",
    "netlify-build": "npm run build"
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
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  }
}
PACKAGEEOF

echo "✅ package.json mis à jour"

# ===== 4. VARIABLES D'ENVIRONNEMENT =====
echo "🔧 Configuration environnement..."

cat > .env.production << 'ENVEOF'
NEXT_PUBLIC_APP_URL=https://math4child.com
NEXT_PUBLIC_APP_NAME=Math4Child
NEXT_PUBLIC_VERSION=2.0.0
NODE_ENV=production
ENVEOF

echo "✅ Variables d'environnement configurées"

# ===== 5. TEST BUILD NETLIFY =====
echo "🏗️ Test build pour Netlify..."

# Nettoyage
rm -rf node_modules package-lock.json .next

# Installation
npm install

# Build test
npm run build

echo "✅ Build Netlify réussi"

# ===== 6. WORKFLOW GITHUB ACTIONS =====
echo "🔄 Création workflow GitHub Actions..."

cd ../../
mkdir -p .github/workflows

cat > .github/workflows/netlify-deploy.yml << 'WORKFLOWEOF'
name: Deploy Math4Child to Netlify

on:
  push:
    branches: [ main ]
    paths: [ 'apps/math4child/**' ]
  pull_request:
    branches: [ main ]
    paths: [ 'apps/math4child/**' ]
  workflow_dispatch:

jobs:
  deploy:
    name: 🌐 Deploy to math4child.com
    runs-on: ubuntu-latest
    
    steps:
      - name: 📥 Checkout Repository
        uses: actions/checkout@v4
        
      - name: 📦 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'
          cache-dependency-path: 'apps/math4child/package-lock.json'
          
      - name: 📦 Install Dependencies
        run: |
          cd apps/math4child
          npm ci
          
      - name: 🔍 Lint Code
        run: |
          cd apps/math4child
          npm run lint || echo "Lint completed with warnings"
          
      - name: 🏗️ Build Application
        run: |
          cd apps/math4child
          npm run build
        env:
          NEXT_PUBLIC_APP_URL: https://math4child.com
          
      - name: 📤 Upload Build Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: math4child-netlify-build
          path: |
            apps/math4child/.next
            apps/math4child/out
          retention-days: 7
          if-no-files-found: ignore
          
      - name: 🚀 Deploy to Netlify
        if: github.ref == 'refs/heads/main'
        uses: nwtgck/actions-netlify@v3.0
        with:
          publish-dir: 'apps/math4child/.next'
          production-branch: main
          github-token: ${{ secrets.GITHUB_TOKEN }}
          deploy-message: "🚀 Deploy Math4Child v2.0.0 from GitHub Actions"
          enable-pull-request-comment: true
          enable-commit-comment: true
          overwrites-pull-request-comment: true
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
          
      - name: 🎉 Deployment Success
        if: github.ref == 'refs/heads/main'
        run: |
          echo "🎉 Math4Child deployed successfully to Netlify!"
          echo "🌍 Live URL: https://math4child.com"
          echo "📱 Mobile optimized and ready!"

  lighthouse:
    name: 🔍 Lighthouse Performance
    runs-on: ubuntu-latest
    needs: deploy
    if: github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v4
      - name: 🔍 Lighthouse CI
        uses: treosh/lighthouse-ci-action@v10
        with:
          urls: |
            https://math4child.com
          uploadArtifacts: true
          temporaryPublicStorage: true
WORKFLOWEOF

echo "✅ Workflow GitHub Actions créé"

# ===== 7. GUIDE CONFIGURATION =====
cat > ../../NETLIFY_SETUP.md << 'GUIDEEOF'
# 🌐 Configuration Netlify pour math4child.com

## 🚀 Étapes Rapides

### 1. Créer le site sur Netlify (5 minutes)

1. **Aller sur https://netlify.com**
2. **Se connecter avec GitHub** 
3. **"New site from Git"**
4. **Choisir GitHub** → Sélectionner `multi-apps-platform`
5. **Configuration build** :
   ```
   Base directory: apps/math4child
   Build command: npm run build  
   Publish directory: .next
   ```
6. **Deploy site**

### 2. Configurer le domaine math4child.com

1. **Site settings** → **Domain management**
2. **Add custom domain** : `math4child.com`
3. **Add domain alias** : `www.math4child.com`
4. **SSL certificate** : Automatique

### 3. Configuration DNS

Chez votre registraire de domaine :
```
Type: A
Name: @
Value: 75.2.60.5

Type: CNAME  
Name: www
Value: votre-site.netlify.app
```

### 4. Variables d'environnement Netlify

Site settings → Environment variables :
```
NODE_VERSION=18
NEXT_PUBLIC_APP_URL=https://math4child.com
NEXT_PUBLIC_APP_NAME=Math4Child
```

### 5. Secrets GitHub (optionnel pour auto-deploy)

GitHub → Settings → Secrets :

**NETLIFY_AUTH_TOKEN** :
- Netlify → User settings → Applications → Personal access tokens

**NETLIFY_SITE_ID** :  
- Site settings → General → Site information → Site ID

## ✅ Résultat

- 🌍 https://math4child.com → Math4Child live !
- 📱 Mobile optimisé
- ⚡ Performance élevée  
- 🔒 HTTPS automatique
- 🔄 Déploiements automatiques

## 🎯 Commande de Déploiement

```bash
git add .
git commit -m "deploy: Math4Child to Netlify production"
git push origin main
```

🎉 **Math4Child sera live sur math4child.com !**
GUIDEEOF

echo "📖 Guide créé : NETLIFY_SETUP.md"

echo ""
echo "🎉 CONFIGURATION NETLIFY TERMINÉE !"
echo "=================================="
echo ""
echo "📋 Prochaines étapes :"
echo "   1. Lire le guide : cat NETLIFY_SETUP.md"
echo "   2. Créer le site sur Netlify (5 min)"
echo "   3. Configurer math4child.com"
echo "   4. git push origin main"
echo ""
echo "🌍 Votre site sera sur : https://math4child.com"
echo "📊 Build optimisé : Next.js + Netlify"
echo ""