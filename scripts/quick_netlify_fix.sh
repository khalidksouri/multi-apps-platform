#!/bin/bash

# ===================================================================
# 🚀 CORRECTION RAPIDE NETLIFY - BASE DIRECTORY
# Fix immédiat du problème de base directory
# ===================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${BLUE}${BOLD}🚀 CORRECTION RAPIDE NETLIFY - MATH4CHILD${NC}"
echo "=================================================="

# Variables
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NETLIFY_TOML="${PROJECT_ROOT}/netlify.toml"

echo -e "${RED}❌ PROBLÈME IDENTIFIÉ:${NC}"
echo "   Netlify cherche dans apps/math4child mais base directory manque"
echo ""

echo -e "${BLUE}🔧 APPLICATION DU FIX...${NC}"

# Sauvegarde
if [ -f "${NETLIFY_TOML}" ]; then
    cp "${NETLIFY_TOML}" "${NETLIFY_TOML}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✅ Sauvegarde netlify.toml créée${NC}"
fi

# Correction avec base directory correct
cat > "${NETLIFY_TOML}" << 'EOF'
[build]
  base = "apps/math4child"
  publish = "out"
  command = "npm install --legacy-peer-deps && npm run build"

[build.environment]
  NODE_VERSION = "18.17.0"
  NODE_ENV = "production"
  NPM_FLAGS = "--legacy-peer-deps"
  DEFAULT_LANGUAGE = "fr"

[context.production.environment]
  NODE_ENV = "production"
  NEXT_PUBLIC_SITE_URL = "https://www.math4child.com"
  DEFAULT_LANGUAGE = "fr"

[context.deploy-preview.environment]
  NODE_ENV = "development"
  NEXT_PUBLIC_SITE_URL = "$DEPLOY_PRIME_URL"

[[redirects]]
  from = "https://math4child.com/*"
  to = "https://www.math4child.com/:splat"
  status = 301
  force = true

[[redirects]]
  from = "https://prismatic-sherbet-986159.netlify.app/*"
  to = "https://www.math4child.com/:splat"
  status = 301
  force = true

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Strict-Transport-Security = "max-age=31536000; includeSubDomains; preload"
    Permissions-Policy = "geolocation=(), microphone=(), camera=()"

[[headers]]
  for = "/_next/static/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/images/*"
  [headers.values]
    Cache-Control = "public, max-age=86400"
EOF

echo -e "${GREEN}✅ netlify.toml corrigé avec base directory${NC}"

# Vérification de l'existence du répertoire
if [ -d "${PROJECT_ROOT}/apps/math4child" ]; then
    echo -e "${GREEN}✅ Répertoire apps/math4child confirmé${NC}"
else
    echo -e "${RED}❌ ERREUR: apps/math4child introuvable${NC}"
    exit 1
fi

# Vérification package.json dans le bon répertoire
if [ -f "${PROJECT_ROOT}/apps/math4child/package.json" ]; then
    echo -e "${GREEN}✅ package.json trouvé dans apps/math4child${NC}"
    
    # Vérifier les dépendances TypeScript
    if grep -q '"typescript"' "${PROJECT_ROOT}/apps/math4child/package.json"; then
        echo -e "${GREEN}✅ TypeScript présent${NC}"
    else
        echo -e "${RED}❌ TypeScript manquant - ajout automatique${NC}"
        
        # Ajouter les dépendances manquantes
        cd "${PROJECT_ROOT}/apps/math4child"
        npm install --save-dev typescript @types/react @types/node --legacy-peer-deps
        echo -e "${GREEN}✅ Dépendances TypeScript ajoutées${NC}"
    fi
else
    echo -e "${RED}❌ ERREUR: package.json manquant dans apps/math4child${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}${BOLD}🎉 CORRECTION TERMINÉE !${NC}"
echo ""
echo -e "${BLUE}📋 PROCHAINES ACTIONS:${NC}"
echo "1. git add netlify.toml"
echo "2. git commit -m 'fix: ajout base directory pour Netlify'"
echo "3. git push origin main"
echo ""
echo -e "${GREEN}🚀 Netlify redéploiera automatiquement avec la correction !${NC}"

# Afficher le diff pour confirmation
echo ""
echo -e "${BLUE}📄 CHANGEMENT PRINCIPAL:${NC}"
echo -e "${GREEN}+ base = \"apps/math4child\"${NC}"
echo ""
echo "Netlify utilisera maintenant le bon répertoire de travail."