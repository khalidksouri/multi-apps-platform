#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🏗️  Math4Child - Build de Production${NC}"
echo "=================================="

# Étape 1: Nettoyage
echo -e "${YELLOW}1. Nettoyage...${NC}"
npm run clean:all

# Étape 2: Vérification TypeScript
echo -e "${YELLOW}2. Vérification TypeScript...${NC}"
if ! npm run type-check; then
    echo -e "${RED}❌ Erreurs TypeScript détectées${NC}"
    exit 1
fi

# Étape 3: Linting
echo -e "${YELLOW}3. Vérification du code...${NC}"
if ! npm run lint; then
    echo -e "${YELLOW}⚠️  Warnings ESLint - continuons${NC}"
fi

# Étape 4: Build
echo -e "${YELLOW}4. Build de production...${NC}"
if npm run build; then
    echo -e "${GREEN}✅ Build réussi!${NC}"
    echo ""
    echo -e "${BLUE}📊 Statistiques du build:${NC}"
    du -sh .next
    echo ""
    echo -e "${GREEN}🚀 Pour démarrer en production:${NC}"
    echo "   npm run start"
else
    echo -e "${RED}❌ Échec du build${NC}"
    exit 1
fi
