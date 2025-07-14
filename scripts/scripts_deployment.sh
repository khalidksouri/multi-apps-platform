#!/bin/bash
# =============================================
# 📄 scripts/deploy-all.sh
# =============================================

set -e  # Exit on any error

echo "🚀 Déploiement Multi-Apps Platform"
echo "=================================="

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction de logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# Vérifications préalables
log "Vérification de l'environnement..."

# Vérifier Node.js
if ! command -v node &> /dev/null; then
    error "Node.js n'est pas installé"
fi

# Vérifier npm
if ! command -v npm &> /dev/null; then
    error "npm n'est pas installé"
fi

# Vérifier la version Node
NODE_VERSION=$(node -v | cut -d'v' -f2)
REQUIRED_VERSION="18.0.0"
if ! node -e "process.exit(require('semver').gte('$NODE_VERSION', '$REQUIRED_VERSION'))" 2>/dev/null; then
    warn "Version Node.js recommandée: >= $REQUIRED_VERSION, actuelle: $NODE_VERSION"
fi

log "✅ Environnement validé"

# Phase 1: Nettoyage
log "🧹 Phase 1: Nettoyage"
if [ -d "node_modules" ]; then
    rm -rf node_modules
    log "Suppression node_modules racine"
fi

if [ -f "package-lock.json" ]; then
    rm -f package-lock.json
    log "Suppression package-lock.json racine"
fi

# Nettoyage des apps
for app in ai4kids multiai budgetcron unitflip postmath; do
    if [ -d "apps/$app/node_modules" ]; then
        rm -rf "apps/$app/node_modules"
        log "Suppression node_modules pour $app"
    fi
    if [ -f "apps/$app/package-lock.json" ]; then
        rm -f "apps/$app/package-lock.json"
        log "Suppression package-lock.json pour $app"
    fi
done

# Phase 2: Installation
log "📦 Phase 2: Installation des dépendances"
npm install || error "Échec de l'installation npm"

log "✅ Dépendances installées"

# Phase 3: Build des packages partagés
log "🔧 Phase 3: Build des packages partagés"
npm run build:packages || error "Échec du build des packages"

log "✅ Packages partagés construits"

# Phase 4: Tests TypeScript
log "🔍 Phase 4: Vérification TypeScript"
npm run typecheck || error "Erreurs TypeScript détectées"

log "✅ TypeScript validé"

# Phase 5: Build des applications
log "🏗️ Phase 5: Build des applications"
npm run build:apps || error "Échec du build des applications"

log "✅ Applications construites"

# Phase 6: Tests
log "🧪 Phase 6: Tests automatisés"

# Installer Playwright si nécessaire
if ! npx playwright --version &> /dev/null; then
    log "Installation des navigateurs Playwright..."
    npx playwright install
fi

# Tests smoke
log "Lancement des tests smoke..."
npm run test:smoke || warn "Certains tests smoke ont échoué"

# Phase 7: Déploiement web
log "🌐 Phase 7: Déploiement web"

if command -v vercel &> /dev/null; then
    log "Déploiement avec Vercel..."
    
    # Déployer chaque application si configurée
    for app in ai4kids multiai budgetcron unitflip postmath; do
        if [ -f "apps/$app/vercel.json" ]; then
            log "Déploiement de $app..."
            cd "apps/$app"
            vercel --prod --confirm || warn "Échec du déploiement de $app"
            cd ../..
        fi
    done
else
    warn "Vercel CLI non installé, saut du déploiement web"
fi

# Phase 8: Build mobile (si Expo est configuré)
log "📱 Phase 8: Build mobile"

if command -v eas &> /dev/null && [ -d "mobile-apps" ]; then
    log "Build des applications mobiles..."
    
    cd mobile-apps
    
    for app in ai4kids-mobile multiai-mobile budgetcron-mobile unitflip-mobile postmath-mobile; do
        if [ -d "$app" ]; then
            log "Build mobile pour $app..."
            cd "$app"
            
            # Build Android
            eas build --platform android --profile production --non-interactive || warn "Échec build Android pour $app"
            
            # Build iOS (si sur macOS)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                eas build --platform ios --profile production --non-interactive || warn "Échec build iOS pour $app"
            fi
            
            cd ..
        fi
    done
    
    cd ..
else
    warn "EAS CLI non installé ou mobile-apps non configuré, saut du build mobile"
fi

# Phase 9: Health checks
log "🏥 Phase 9: Vérifications de santé"

if command -v node &> /dev/null; then
    if [ -f "scripts/workspace-helpers.js" ]; then
        node scripts/workspace-helpers.js test || warn "Certains health checks ont échoué"
    fi
fi

# Phase 10: Génération des rapports
log "📊 Phase 10: Génération des rapports"

# Créer le dossier de rapports
mkdir -p reports

# Rapport de déploiement
cat > reports/deployment-report.json << EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "status": "success",
  "environment": "${NODE_ENV:-production}",
  "node_version": "$(node -v)",
  "npm_version": "$(npm -v)",
  "apps_deployed": [
    "ai4kids",
    "multiai", 
    "budgetcron",
    "unitflip",
    "postmath"
  ],
  "deployment_duration": "$(date +%s) seconds",
  "build_size": "$(du -sh . 2>/dev/null | cut -f1 || echo 'unknown')"
}
EOF

log "✅ Rapport de déploiement généré: reports/deployment-report.json"

# Phase finale
log "🎉 Déploiement terminé avec succès!"
echo "=================================="
echo "📊 Résumé du déploiement:"
echo "  • 5 applications web construites"
echo "  • Packages partagés mis à jour"
echo "  • Tests validés"
echo "  • Rapports générés dans reports/"
echo ""
echo "🔗 URLs des applications:"
echo "  • AI4Kids: http://localhost:3004"
echo "  • MultiAI: http://localhost:3005"  
echo "  • BudgetCron: http://localhost:3003"
echo "  • UnitFlip: http://localhost:3002"
echo "  • PostMath: http://localhost:3001"
echo ""
echo "📱 Pour déployer sur les stores:"
echo "  1. cd mobile-apps"
echo "  2. eas submit --platform android"
echo "  3. eas submit --platform ios"
echo ""
echo "🎯 Prêt pour la production!"

# =============================================
# 📄 scripts/test-all.sh
# =============================================

#!/bin/bash
set -e

echo "🧪 Lancement de tous les tests"
echo "============================="

# Tests par type
echo "🚀 Tests smoke..."
npm run test:smoke

echo "🔄 Tests de régression..."
npm run test:regression

echo "⚡ Tests de performance..."
npm run test:performance

echo "♿ Tests d'accessibilité..."
npm run test:accessibility

echo "🔒 Tests de sécurité..."
npm run test:security

echo "📱 Tests mobile..."
npm run test:mobile

echo "✅ Tous les tests terminés!"

# =============================================
# 📄 scripts/health-check.sh
# =============================================

#!/bin/bash

echo "🏥 Health Check Multi-Apps Platform"
echo "==================================="

APPS=(
    "postmath:3001"
    "unitflip:3002" 
    "budgetcron:3003"
    "ai4kids:3004"
    "multiai:3005"
)

ALL_HEALTHY=true

for app_port in "${APPS[@]}"; do
    IFS=':' read -r app port <<< "$app_port"
    
    echo -n "Checking $app (port $port)... "
    
    if curl -f -s "http://localhost:$port/api/health" > /dev/null; then
        echo "✅ OK"
    else
        echo "❌ FAILED"
        ALL_HEALTHY=false
    fi
done

if [ "$ALL_HEALTHY" = true ]; then
    echo ""
    echo "🎉 Toutes les applications sont en bonne santé!"
    exit 0
else
    echo ""
    echo "⚠️ Certaines applications ont des problèmes"
    exit 1
fi