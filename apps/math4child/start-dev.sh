#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 Math4Child - Démarrage Sécurisé${NC}"
echo "=================================="

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Erreur: Exécutez ce script depuis apps/math4child${NC}"
    exit 1
fi

# Vérifier Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js n'est pas installé${NC}"
    exit 1
fi

# Nettoyer si demandé
if [ "$1" = "--clean" ]; then
    echo -e "${YELLOW}🧹 Nettoyage complet...${NC}"
    rm -rf .next node_modules/.cache
    npm cache clean --force
fi

# Vérification rapide TypeScript
echo -e "${BLUE}🔍 Vérification TypeScript...${NC}"
if npm run type-check > /dev/null 2>&1; then
    echo -e "${GREEN}✅ TypeScript OK${NC}"
else
    echo -e "${YELLOW}⚠️  Erreurs TypeScript détectées${NC}"
    echo "Continuons quand même..."
fi

# Vérifier que le port 3001 est libre
if lsof -Pi :3001 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Port 3001 occupé - arrêt du processus...${NC}"
    lsof -ti:3001 | xargs kill -9 2>/dev/null || true
    sleep 2
fi

echo ""
echo -e "${GREEN}🔥 Démarrage du serveur...${NC}"
echo -e "${BLUE}📡 URL: http://localhost:3001${NC}"
echo -e "${YELLOW}💡 Utilisez Ctrl+C pour arrêter${NC}"
echo ""

# Démarrer avec gestion d'erreur
if npm run dev; then
    echo -e "${GREEN}✅ Serveur arrêté proprement${NC}"
else
    echo -e "${RED}❌ Erreur lors du démarrage${NC}"
    echo "Essayez: ./start-dev.sh --clean"
fi
