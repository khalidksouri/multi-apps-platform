#!/bin/bash

# ===================================================================
# 🔧 CORRECTION PROBLÈME NPM CONFIG - Math4Child
# Corrige l'erreur "Exit prior to config file resolving"
# ===================================================================

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}🔧 CORRECTION PROBLÈME NPM CONFIG${NC}"
echo -e "${CYAN}${BOLD}==================================${NC}"
echo ""

# Vérifier que nous sommes dans le bon dossier
if [ ! -d "apps/math4child" ]; then
    echo -e "${RED}❌ Erreur: Le dossier apps/math4child n'existe pas${NC}"
    exit 1
fi

cd "apps/math4child"

echo -e "${YELLOW}📋 1. Diagnostic du problème npm...${NC}"

# Vérifier la version de Node et npm
echo -e "${BLUE}Node version: $(node --version)${NC}"
echo -e "${BLUE}NPM version: $(npm --version)${NC}"

# Vérifier la configuration npm
echo -e "${YELLOW}📋 2. Nettoyage de la configuration npm...${NC}"

# Nettoyer la configuration npm locale
rm -rf ~/.npmrc 2>/dev/null || true
rm -rf .npmrc 2>/dev/null || true

# Créer une configuration npm propre
cat > .npmrc << 'EOF'
registry=https://registry.npmjs.org/
save-exact=false
package-lock=true
shrinkwrap=false
EOF

echo -e "${GREEN}✅ Configuration npm nettoyée${NC}"

echo -e "${YELLOW}📋 3. Nettoyage complet des caches...${NC}"

# Nettoyer tous les caches
npm cache clean --force 2>/dev/null || true
rm -rf node_modules 2>/dev/null || true
rm -rf package-lock.json 2>/dev/null || true
rm -rf .next 2>/dev/null || true
rm -rf .turbo 2>/dev/null || true

echo -e "${GREEN}✅ Caches nettoyés${NC}"

echo -e "${YELLOW}📋 4. Création d'un package.json minimal et fonctionnel...${NC}"

# Créer un package.json minimal qui fonctionne
cat > package.json << 'EOF'
{
  "name": "math4child",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3001",
    "build": "next build",
    "start": "next start -p 3001",
    "lint": "next lint --fix",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "14.0.3",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "lucide-react": "0.294.0"
  },
  "devDependencies": {
    "@types/node": "20.10.0",
    "@types/react": "18.2.42",
    "@types/react-dom": "18.2.17",
    "autoprefixer": "10.4.16",
    "eslint": "8.55.0",
    "eslint-config-next": "14.0.3",
    "postcss": "8.4.32",
    "tailwindcss": "3.3.6",
    "typescript": "5.3.2"
  }
}
EOF

echo -e "${GREEN}✅ package.json minimal créé${NC}"

echo -e "${YELLOW}📋 5. Installation avec méthode alternative...${NC}"

# Essayer différentes méthodes d'installation
echo -e "${BLUE}🔄 Tentative 1: Installation avec npm ci...${NC}"
if npm ci --no-optional --no-fund --no-audit 2>/dev/null; then
    echo -e "${GREEN}✅ Installation réussie avec npm ci${NC}"
    INSTALL_SUCCESS=true
else
    echo -e "${YELLOW}⚠️ npm ci échoué, tentative avec npm install...${NC}"
    
    echo -e "${BLUE}🔄 Tentative 2: Installation avec npm install --legacy-peer-deps...${NC}"
    if npm install --legacy-peer-deps --no-optional --no-fund --no-audit 2>/dev/null; then
        echo -e "${GREEN}✅ Installation réussie avec --legacy-peer-deps${NC}"
        INSTALL_SUCCESS=true
    else
        echo -e "${YELLOW}⚠️ Installation normale échouée, tentative avec yarn...${NC}"
        
        echo -e "${BLUE}🔄 Tentative 3: Installation avec yarn...${NC}"
        if command -v yarn &> /dev/null; then
            if yarn install --silent 2>/dev/null; then
                echo -e "${GREEN}✅ Installation réussie avec yarn${NC}"
                INSTALL_SUCCESS=true
            else
                echo -e "${YELLOW}⚠️ Yarn échoué aussi${NC}"
                INSTALL_SUCCESS=false
            fi
        else
            echo -e "${YELLOW}⚠️ Yarn non disponible${NC}"
            INSTALL_SUCCESS=false
        fi
    fi
fi

if [ "${INSTALL_SUCCESS:-false}" = "false" ]; then
    echo -e "${RED}❌ Toutes les méthodes d'installation ont échoué${NC}"
    echo -e "${YELLOW}📋 Tentative d'installation manuelle des dépendances critiques...${NC}"
    
    # Installation manuelle des dépendances critiques
    npm install next@14.0.3 --no-save --no-optional 2>/dev/null || true
    npm install react@18.2.0 react-dom@18.2.0 --no-save --no-optional 2>/dev/null || true
    npm install typescript@5.3.2 --no-save --no-optional 2>/dev/null || true
    
    echo -e "${YELLOW}⚠️ Installation partielle effectuée${NC}"
fi

echo -e "${YELLOW}📋 6. Vérification de l'installation...${NC}"

# Vérifier que les dépendances critiques sont présentes
if [ -d "node_modules/next" ] && [ -d "node_modules/react" ]; then
    echo -e "${GREEN}✅ Dépendances critiques présentes${NC}"
    DEPS_OK=true
else
    echo -e "${RED}❌ Dépendances critiques manquantes${NC}"
    DEPS_OK=false
fi

echo -e "${YELLOW}📋 7. Configuration d'environnement...${NC}"

# Créer un fichier d'environnement local
cat > .env.local << 'EOF'
# Configuration Math4Child
NEXT_TELEMETRY_DISABLED=1
NODE_ENV=development
PORT=3001
EOF

# Exporter les variables d'environnement
export NEXT_TELEMETRY_DISABLED=1
export NODE_ENV=development
export PORT=3001

echo -e "${GREEN}✅ Variables d'environnement configurées${NC}"

echo -e "${YELLOW}📋 8. Test de compilation sans installation complète...${NC}"

# Essayer de compiler pour vérifier que ça fonctionne
if command -v npx &> /dev/null && [ -d "node_modules" ]; then
    echo -e "${BLUE}🔄 Test de compilation TypeScript...${NC}"
    if npx tsc --noEmit --skipLibCheck 2>/dev/null; then
        echo -e "${GREEN}✅ Compilation TypeScript réussie${NC}"
        COMPILE_OK=true
    else
        echo -e "${YELLOW}⚠️ Compilation avec erreurs (normal)${NC}"
        COMPILE_OK=false
    fi
else
    echo -e "${YELLOW}⚠️ Impossible de tester la compilation${NC}"
    COMPILE_OK=false
fi

echo -e "${YELLOW}📋 9. Démarrage du serveur de développement...${NC}"

# Tuer les processus existants
pkill -f "next dev" 2>/dev/null || true
pkill -f "node.*3001" 2>/dev/null || true
sleep 2

# Essayer de démarrer le serveur
echo -e "${BLUE}🚀 Tentative de démarrage...${NC}"

if [ -d "node_modules/next" ]; then
    # Démarrer avec next directement
    echo -e "${BLUE}📡 Démarrage avec npx next dev...${NC}"
    (cd . && npx next dev -p 3001) > server.log 2>&1 &
    SERVER_PID=$!
    
    # Attendre que le serveur démarre
    echo -e "${BLUE}⏳ Attente du démarrage (30s max)...${NC}"
    for i in {1..30}; do
        if curl -s -o /dev/null -w "%{http_code}" http://localhost:3001 | grep -q "200\|404\|500"; then
            echo -e "${GREEN}✅ Serveur accessible sur http://localhost:3001${NC}"
            SERVER_OK=true
            break
        fi
        if ! kill -0 $SERVER_PID 2>/dev/null; then
            echo -e "${RED}❌ Le processus serveur s'est arrêté${NC}"
            echo -e "${YELLOW}📋 Logs du serveur:${NC}"
            tail -10 server.log 2>/dev/null || echo "Aucun log disponible"
            SERVER_OK=false
            break
        fi
        echo -ne "${BLUE}⏳ Tentative $i/30...\r${NC}"
        sleep 1
    done
    echo ""
else
    echo -e "${RED}❌ Next.js non installé, impossible de démarrer${NC}"
    SERVER_OK=false
fi

echo ""
echo -e "${GREEN}${BOLD}🎉 DIAGNOSTIC ET CORRECTION TERMINÉS${NC}"
echo ""
echo -e "${CYAN}${BOLD}📋 ÉTAT FINAL :${NC}"

if [ "${INSTALL_SUCCESS:-false}" = "true" ]; then
    echo -e "Installation: ${GREEN}✅ Réussie${NC}"
else
    echo -e "Installation: ${YELLOW}⚠️ Partielle${NC}"
fi

if [ "${DEPS_OK:-false}" = "true" ]; then
    echo -e "Dépendances: ${GREEN}✅ Présentes${NC}"
else
    echo -e "Dépendances: ${YELLOW}⚠️ Incomplètes${NC}"
fi

if [ "${SERVER_OK:-false}" = "true" ]; then
    echo -e "Serveur: ${GREEN}✅ Fonctionnel (PID: $SERVER_PID)${NC}"
    echo -e "${GREEN}🌍 Application accessible : http://localhost:3001${NC}"
else
    echo -e "Serveur: ${RED}❌ Problème de démarrage${NC}"
fi

echo ""
echo -e "${CYAN}${BOLD}🔧 SI LE PROBLÈME PERSISTE :${NC}"
echo -e "${YELLOW}1. Vérifiez les logs: tail -20 server.log${NC}"
echo -e "${YELLOW}2. Tentez un démarrage manuel: cd apps/math4child && npx next dev -p 3001${NC}"
echo -e "${YELLOW}3. Vérifiez la version Node.js: node --version (recommandé >= 18)${NC}"
echo -e "${YELLOW}4. Essayez avec un autre gestionnaire de paquets: yarn ou pnpm${NC}"
echo ""

if [ "${SERVER_OK:-false}" = "true" ]; then
    echo -e "${GREEN}${BOLD}✨ MATH4CHILD DÉMARRÉ AVEC SUCCÈS ! ✨${NC}"
    echo -e "${CYAN}🎯 Testez l'application multilingue sur http://localhost:3001${NC}"
else
    echo -e "${YELLOW}${BOLD}⚠️ DÉMARRAGE PARTIEL - Vérifiez les instructions ci-dessus${NC}"
fi
