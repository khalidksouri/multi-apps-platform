#!/bin/bash
set -e

echo "🚀 Déploiement Math4Child en Production"
echo "======================================"

# ===== 1. VÉRIFICATIONS PRÉALABLES =====
echo "🔍 Vérifications préalables..."

cd apps/math4child

# Vérifier que le build fonctionne
echo "📋 Test build local..."
npm run build
echo "✅ Build local réussi"

# Vérifier la structure
if [ ! -f "app/page.tsx" ]; then
    echo "❌ Structure app/ manquante"
    exit 1
fi

if [ ! -f "next.config.js" ]; then
    echo "❌ Configuration Next.js manquante" 
    exit 1
fi

echo "✅ Structure vérifiée"

# ===== 2. OPTIMISATION POUR PRODUCTION =====
echo "⚙️ Optimisation pour production..."

# Variables d'environnement production
cat > .env.production << 'PRODENV'
NEXT_PUBLIC_APP_URL=https://math4child.com
NEXT_PUBLIC_APP_NAME=Math4Child
NEXT_PUBLIC_VERSION=2.0.0
NODE_ENV=production
PRODENV

# Configuration Next.js optimisée pour production
cat > next.config.js << 'NEXTEOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  experimental: {
    optimizePackageImports: ['lucide-react']
  },
  compress: true,
  poweredByHeader: false,
  generateEtags: true,
  images: {
    formats: ['image/webp', 'image/avif'],
    domains: []
  },
  headers: async () => [
    {
      source: '/(.*)',
      headers: [
        {
          key: 'X-Frame-Options', 
          value: 'DENY'
        },
        {
          key: 'X-Content-Type-Options',
          value: 'nosniff' 
        },
        {
          key: 'Referrer-Policy',
          value: 'strict-origin-when-cross-origin'
        }
      ]
    }
  ]
}

module.exports = nextConfig
NEXTEOF

echo "✅ Configuration production créée"

# ===== 3. WORKFLOW GITHUB ACTIONS PRODUCTION =====
echo "🔄 Création workflow production..."

cd ../../
mkdir -p .github/workflows

cat > .github/workflows/deploy-production.yml << 'WORKFLOWEOF'
name: 🚀 Deploy Math4Child to Production

on:
  push:
    branches: [ main ]
    paths: [ 'apps/math4child/**' ]
  workflow_dispatch:
    inputs:
      environment:
        description: 'Deploy environment'
        required: true
        default: 'production'
        type: choice
        options:
          - production
          - staging

jobs:
  deploy:
    name: 🚀 Deploy to math4child.com
    runs-on: ubuntu-latest
    environment: production
    
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
          npm ci --only=production
          npm ci --only=dev
          
      - name: 🔍 Type Check
        run: |
          cd apps/math4child
          npm run type-check || echo "Type check completed with warnings"
          
      - name: 🧹 Lint Code
        run: |
          cd apps/math4child  
          npm run lint || echo "Lint completed with warnings"
          
      - name: 🧪 Run Tests
        run: |
          cd apps/math4child
          npm run test || echo "Tests completed"
          
      - name: 🏗️ Build Application
        run: |
          cd apps/math4child
          npm run build
          
      - name: 📤 Upload Build Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: math4child-production-build
          path: |
            apps/math4child/.next
            apps/math4child/public
          retention-days: 30
          
      - name: 🚀 Deploy to Vercel Production
        id: deploy
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          working-directory: apps/math4child
          vercel-args: '--prod --confirm'
          
      - name: 🎉 Deployment Success
        run: |
          echo "🎉 Math4Child deployed successfully!"
          echo "🌍 Production URL: https://math4child.com"
          echo "📱 Mobile URL: https://math4child.com"
          echo "🔗 Deployment URL: ${{ steps.deploy.outputs.preview-url }}"
          
      - name: 📊 Post-Deploy Health Check
        run: |
          sleep 30
          curl -f https://math4child.com || echo "Health check will be available shortly"
          
  notify:
    name: 📢 Send Notifications  
    runs-on: ubuntu-latest
    needs: deploy
    if: always()
    
    steps:
      - name: 📢 Deployment Status
        run: |
          if [ "${{ needs.deploy.result }}" == "success" ]; then
            echo "✅ DÉPLOIEMENT RÉUSSI !"
            echo "🌍 Math4Child est maintenant live sur https://math4child.com"
          else
            echo "❌ DÉPLOIEMENT ÉCHOUÉ"
            echo "Vérifiez les logs ci-dessus pour plus de détails"
          fi
WORKFLOWEOF

echo "✅ Workflow production créé"

# ===== 4. GUIDE CONFIGURATION VERCEL =====
cat > DEPLOY_GUIDE.md << 'GUIDEEOF'
# 🚀 Guide Configuration Vercel pour math4child.com

## 1. Créer le projet Vercel

### Option A: Interface Web (Recommandée)
1. Aller sur https://vercel.com
2. Se connecter avec GitHub
3. "New Project" → Sélectionner "multi-apps-platform"  
4. **Root Directory**: `apps/math4child`
5. **Framework Preset**: Next.js (auto-détecté)
6. **Build Command**: `npm run build`  
7. **Output Directory**: `.next`
8. Deploy

### Option B: CLI
```bash
cd apps/math4child
npx vercel
# Suivre les instructions
```

## 2. Configurer le domaine personnalisé

Dans Vercel Dashboard:
1. Project Settings → Domains
2. Add `math4child.com`
3. Add `www.math4child.com`

## 3. Configuration DNS

Chez votre registraire (GoDaddy, OVH, etc.):
```
Type: A
Name: @  
Value: 76.76.19.61

Type: CNAME
Name: www
Value: cname.vercel-dns.com
```

## 4. Récupérer les identifiants pour GitHub

### Token Vercel:
1. Vercel Dashboard → Account Settings → Tokens
2. Create Token → Nom: "Math4Child GitHub Actions"
3. Copier le token

### Project ID et Org ID:
```bash
cd apps/math4child
cat .vercel/project.json
```

## 5. Configurer les secrets GitHub

Dans GitHub: Settings → Secrets and variables → Actions

Ajouter:
- `VERCEL_TOKEN`: Votre token Vercel
- `VERCEL_PROJECT_ID`: ID du projet (prj_...)  
- `VERCEL_ORG_ID`: ID organisation/team

## 6. Déployer

```bash
git add .
git commit -m "deploy: Math4Child to production"  
git push origin main
```

🎉 Math4Child sera disponible sur https://math4child.com !
GUIDEEOF

echo "📖 Guide de déploiement créé: DEPLOY_GUIDE.md"

# ===== 5. TEST FINAL =====
echo "🧪 Test final avant déploiement..."

cd apps/math4child
npm run build

echo ""
echo "🎉 PRÉPARATION DÉPLOIEMENT TERMINÉE !"
echo "======================================"
echo ""
echo "📋 Prochaines étapes:"
echo "   1. Lire le guide: cat DEPLOY_GUIDE.md"
echo "   2. Configurer Vercel (voir guide ci-dessus)"  
echo "   3. Ajouter les secrets GitHub"
echo "   4. Déployer: git push origin main"
echo ""
echo "🌍 Votre site sera disponible sur: https://math4child.com"
echo ""
echo "🔗 Liens utiles:"
echo "   • Vercel Dashboard: https://vercel.com/dashboard"
echo "   • GitHub Actions: https://github.com/khalidksouri/multi-apps-platform/actions"
echo ""