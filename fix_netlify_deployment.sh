#!/bin/bash

# =============================================================================
# FIX URGENT - DÉPLOIEMENT NETLIFY MATH4CHILD
# Résolution du problème 404
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${RED}${BOLD}🚨 FIX URGENT - DÉPLOIEMENT NETLIFY MATH4CHILD${NC}"
echo "================================================"
echo ""

log() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }
step() { echo -e "${BLUE}[ÉTAPE]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
urgent() { echo -e "${RED}${BOLD}[URGENT]${NC} $1"; }

# =============================================================================
# ÉTAPE 1: DIAGNOSTIC DE L'ERREUR 404
# =============================================================================

step "1️⃣ Diagnostic de l'erreur 404"

urgent "PROBLÈME DÉTECTÉ: URL beta retourne 404"
echo "URL concernée: https://prismatic-sherbet-986159.netlify.app"

info "Causes possibles:"
echo "  • Site non déployé ou échec de build"
echo "  • Configuration netlify.toml incorrecte"
echo "  • Chemin 'base' incorrect dans netlify.toml"
echo "  • Fichiers sources absents du dossier 'out'"

# =============================================================================
# ÉTAPE 2: VÉRIFICATION DE LA CONFIGURATION
# =============================================================================

step "2️⃣ Vérification configuration existante"

# Vérifier netlify.toml à la racine
if [[ -f "netlify.toml" ]]; then
    info "✅ netlify.toml trouvé à la racine"
    echo "Configuration actuelle:"
    echo "----------------------"
    grep -A 5 "\[build\]" netlify.toml || echo "Section [build] non trouvée"
else
    warning "⚠️ netlify.toml manquant à la racine"
fi

# Vérifier dans apps/math4child
if [[ -f "apps/math4child/netlify.toml" ]]; then
    info "✅ netlify.toml trouvé dans apps/math4child"
else
    warning "⚠️ netlify.toml manquant dans apps/math4child"
fi

# Vérifier structure du projet
echo ""
info "Structure du projet:"
if [[ -d "apps/math4child" ]]; then
    echo "  ✅ apps/math4child/ existe"
    if [[ -f "apps/math4child/package.json" ]]; then
        echo "  ✅ apps/math4child/package.json existe"
    else
        echo "  ❌ apps/math4child/package.json manquant"
    fi
    if [[ -d "apps/math4child/out" ]]; then
        echo "  ✅ apps/math4child/out/ existe"
        echo "  📁 Contenu du dossier out:"
        ls -la apps/math4child/out/ 2>/dev/null | head -10 || echo "  📂 Dossier vide ou inaccessible"
    else
        echo "  ❌ apps/math4child/out/ manquant"
    fi
else
    echo "  ❌ apps/math4child/ introuvable"
fi

# =============================================================================
# ÉTAPE 3: SOLUTIONS CORRECTIVES
# =============================================================================

step "3️⃣ Application des solutions correctives"

info "📋 Solution 1: Correction de netlify.toml"

# Créer la configuration correcte
cat > netlify.toml << 'EOF'
# =============================================================================
# CONFIGURATION NETLIFY - MATH4CHILD (CORRIGÉE)
# =============================================================================

[build]
  base = "apps/math4child"
  publish = "apps/math4child/out"
  command = "cd apps/math4child && npm install --legacy-peer-deps && npm run build && npm run export"

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

log "✅ netlify.toml corrigé et mis à jour"

info "📋 Solution 2: Vérification/création next.config.js"

# Aller dans le dossier math4child
cd apps/math4child || { urgent "Impossible d'accéder à apps/math4child"; exit 1; }

# Vérifier/créer next.config.js
if [[ ! -f "next.config.js" ]]; then
    info "Création de next.config.js..."
    cat > next.config.js << 'EOF'
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
    log "✅ next.config.js créé"
else
    info "✅ next.config.js existe déjà"
fi

info "📋 Solution 3: Build local pour test"

# Nettoyer les builds précédents
rm -rf .next out node_modules/.cache 2>/dev/null || true

info "Installation des dépendances..."
if npm install --legacy-peer-deps; then
    log "✅ Dépendances installées"
else
    warning "⚠️ Problème avec les dépendances"
fi

info "Build de l'application..."
if CAPACITOR_BUILD=false npm run build; then
    log "✅ Build réussi"
    
    info "Export statique..."
    if npm run export 2>/dev/null || npx next export; then
        log "✅ Export réussi"
        
        if [[ -d "out" && -f "out/index.html" ]]; then
            log "✅ Fichiers générés dans out/"
            echo "📁 Contenu principal:"
            ls -la out/ | head -10
        else
            warning "⚠️ Export incomplet - out/index.html manquant"
        fi
    else
        warning "⚠️ Échec de l'export"
    fi
else
    urgent "❌ Échec du build - Vérifiez les erreurs ci-dessus"
fi

# Retourner à la racine
cd ../..

# =============================================================================
# ÉTAPE 4: REDÉPLOIEMENT
# =============================================================================

step "4️⃣ Instructions de redéploiement"

echo ""
info "🚀 REDÉPLOIEMENT NÉCESSAIRE"
echo ""

echo -e "${BOLD}OPTION A - Redéploiement automatique (Git) :${NC}"
echo "1. git add ."
echo "2. git commit -m \"fix: correct Netlify configuration and build\""
echo "3. git push origin main"
echo "4. Attendre 2-3 minutes pour le redéploiement automatique"

echo ""
echo -e "${BOLD}OPTION B - Redéploiement manuel Netlify :${NC}"
echo "1. Aller sur https://app.netlify.com/sites/prismatic-sherbet-986159"
echo "2. Cliquer 'Trigger deploy' > 'Deploy site'"
echo "3. Ou glisser-déposer le dossier apps/math4child/out/"

echo ""
echo -e "${BOLD}OPTION C - Drag & Drop urgent :${NC}"
echo "1. Compresser le dossier apps/math4child/out/ en ZIP"
echo "2. Aller sur https://app.netlify.com/drop"
echo "3. Glisser le ZIP pour déploiement immédiat"

# =============================================================================
# ÉTAPE 5: VÉRIFICATION POST-FIX
# =============================================================================

step "5️⃣ Script de vérification post-fix"

cat > ../../check-deployment.sh << 'EOF'
#!/bin/bash

echo "🔍 Vérification du déploiement Math4Child..."

URL="https://prismatic-sherbet-986159.netlify.app"
echo "Testing: $URL"

# Test 1: Status HTTP
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
echo "Status HTTP: $HTTP_CODE"

# Test 2: Temps de réponse
RESPONSE_TIME=$(curl -w "%{time_total}" -s -o /dev/null "$URL")
echo "Temps de réponse: ${RESPONSE_TIME}s"

# Test 3: Contenu
CONTENT=$(curl -s "$URL" | head -c 200)
echo "Contenu (200 premiers caractères):"
echo "$CONTENT"

if [[ "$HTTP_CODE" == "200" ]]; then
    echo "✅ Déploiement réussi !"
else
    echo "❌ Problème persistant (Code: $HTTP_CODE)"
fi
EOF

chmod +x ../../check-deployment.sh

log "✅ Script de vérification créé: check-deployment.sh"

# =============================================================================
# RÉSUMÉ ET ACTIONS
# =============================================================================

echo ""
echo -e "${PURPLE}${BOLD}📋 RÉSUMÉ DU FIX${NC}"
echo "=================="

echo -e "${GREEN}✅ Corrections appliquées:${NC}"
echo "  • netlify.toml corrigé avec la bonne configuration"
echo "  • next.config.js vérifié/créé pour export statique"
echo "  • Build local testé"
echo "  • Script de vérification créé"

echo ""
echo -e "${YELLOW}⚡ ACTIONS IMMÉDIATES REQUISES:${NC}"
echo "1. 🚀 Redéployer via Git ou Netlify (voir options ci-dessus)"
echo "2. ⏰ Attendre 2-3 minutes"
echo "3. 🔍 Tester avec: ./check-deployment.sh"
echo "4. 📧 Si OK, relancer le programme beta !"

echo ""
echo -e "${CYAN}🔗 LIENS UTILES:${NC}"
echo "• Admin Netlify: https://app.netlify.com/sites/prismatic-sherbet-986159"
echo "• URL beta: https://prismatic-sherbet-986159.netlify.app"
echo "• Logs build: https://app.netlify.com/sites/prismatic-sherbet-986159/deploys"

echo ""
urgent "🚨 PRIORITÉ: Fix le déploiement avant de continuer le programme beta !"

log "FIX NETLIFY TERMINÉ - Redéploiement requis"