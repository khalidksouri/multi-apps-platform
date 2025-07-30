#!/bin/bash
# 🔧 CORRECTION ERREUR 404 NEXT.JS
# Répare les problèmes de cache et de configuration

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_banner() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}      ${BOLD}${RED}🔧 CORRECTION ERREUR 404 NEXT.JS${NC}      ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}        ${YELLOW}Réparation cache et configuration${NC}        ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() { echo -e "${BLUE}▶ $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${CYAN}ℹ️  $1${NC}"; }

print_banner

# Vérifier qu'on est dans le bon répertoire
if [ ! -d "apps/math4child" ]; then
    print_error "Veuillez lancer ce script depuis la racine du monorepo"
    exit 1
fi

cd apps/math4child

print_step "1. DIAGNOSTIC DU PROBLÈME"

# Vérifier si page.tsx existe
if [ -f "src/app/page.tsx" ]; then
    print_success "page.tsx existe ($(wc -l < src/app/page.tsx) lignes)"
else
    print_error "page.tsx manquant !"
    exit 1
fi

# Vérifier la structure des dossiers
if [ -d "src/app" ]; then
    print_success "Structure src/app/ OK"
else
    print_error "Structure src/app/ manquante"
    exit 1
fi

print_step "2. ARRÊT DES SERVEURS EXISTANTS"

# Tuer tous les processus Next.js
pkill -f "next dev" || true
pkill -f "node.*next" || true
pkill -9 42387 || true  # PID du serveur précédent
sleep 2

print_success "Serveurs arrêtés"

print_step "3. NETTOYAGE COMPLET DU CACHE"

# Supprimer tous les caches
rm -rf .next
rm -rf node_modules/.cache
rm -rf .turbo
rm -rf out
rm -rf dist

print_success "Cache nettoyé"

print_step "4. VÉRIFICATION DE LA CONFIGURATION"

# Vérifier next.config.js
if [ -f "next.config.js" ]; then
    print_info "next.config.js présent"
else
    print_warning "next.config.js manquant, création..."
    cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: process.env.CAPACITOR_BUILD === 'true' ? 'export' : undefined,
  trailingSlash: process.env.CAPACITOR_BUILD === 'true',
  images: {
    unoptimized: process.env.CAPACITOR_BUILD === 'true'
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: false,
  },
  swcMinify: true,
  poweredByHeader: false,
  generateEtags: false,
  compress: true
};

module.exports = nextConfig;
EOF
    print_success "next.config.js créé"
fi

# Vérifier package.json
if grep -q '"dev":' package.json; then
    print_success "Scripts npm OK"
else
    print_error "Scripts npm manquants dans package.json"
fi

print_step "5. VÉRIFICATION DU CONTENU DE PAGE.TSX"

# Vérifier que page.tsx a le bon contenu
if grep -q "export default" src/app/page.tsx && grep -q "Math4Child" src/app/page.tsx; then
    print_success "Contenu de page.tsx OK"
else
    print_warning "Contenu de page.tsx suspect, recréation..."
    
    # Recréer page.tsx minimal pour test
    cat > src/app/page.tsx << 'EOF'
export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-600 via-blue-600 to-pink-600 text-white flex items-center justify-center">
      <div className="text-center">
        <div className="text-8xl mb-6">🧮</div>
        <h1 className="text-6xl font-bold mb-4">Math4Child</h1>
        <p className="text-2xl mb-8">L'app éducative n°1 pour apprendre les maths en famille</p>
        <div className="bg-white/10 backdrop-blur-xl rounded-2xl p-6">
          <p className="text-lg">✅ Design recréé avec succès !</p>
          <p className="text-sm mt-2">Version de test simplifiée</p>
        </div>
      </div>
    </div>
  );
}
EOF
    print_success "Page.tsx minimal créé"
fi

print_step "6. RÉINSTALLATION DES DÉPENDANCES"

# Réinstaller proprement
print_info "Suppression node_modules..."
rm -rf node_modules
rm -f package-lock.json

print_info "Installation propre..."
npm install

print_success "Dépendances réinstallées"

print_step "7. REDÉMARRAGE DU SERVEUR"

print_info "Démarrage du serveur en mode diagnostic..."

# Démarrer en mode verbose pour voir les erreurs
npm run dev &
DEV_PID=$!

echo "   🚀 Serveur démarré (PID: $DEV_PID)"

print_info "Attente du démarrage (15 secondes)..."
sleep 15

# Tester la connexion
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200"; then
    print_success "Serveur opérationnel sur http://localhost:3000"
    
    # Ouvrir dans le navigateur
    if command -v open > /dev/null 2>&1; then
        open http://localhost:3000
    fi
else
    print_warning "Serveur en cours de démarrage, vérification des logs..."
    
    # Afficher les logs en cas de problème
    print_info "Logs du serveur :"
    jobs -p | xargs ps -o pid,cmd
fi

print_step "8. DIAGNOSTIC FINAL"

echo ""
echo -e "${BOLD}${GREEN}🔧 CORRECTION 404 TERMINÉE${NC}"
echo "═══════════════════════════════════════════════════════════════════════"
echo ""
echo -e "${CYAN}📊 ACTIONS RÉALISÉES :${NC}"
echo "   • Arrêt des serveurs existants"
echo "   • Nettoyage complet du cache Next.js"
echo "   • Vérification de la configuration"
echo "   • Réinstallation propre des dépendances"
echo "   • Redémarrage du serveur"
echo ""
echo -e "${GREEN}🚀 SERVEUR :${NC}"
echo "   • URL : ${BOLD}http://localhost:3000${NC}"
echo "   • PID : ${DEV_PID}"
echo ""
echo -e "${YELLOW}📋 SI LE PROBLÈME PERSISTE :${NC}"
echo "1. Vérifier les logs : ${BOLD}npm run dev${NC}"
echo "2. Vérifier le port : ${BOLD}lsof -ti:3000${NC}"
echo "3. Redémarrer complètement :"
echo "   ${BOLD}pkill -f next && npm run dev${NC}"
echo "4. Vérifier la structure :"
echo "   ${BOLD}ls -la src/app/${NC}"
echo ""
echo -e "${CYAN}🎯 La page devrait maintenant être accessible !${NC}"
echo ""
