#!/bin/bash

# ===================================================================
# SCRIPT DE NETTOYAGE COMPLET - ÉLIMINATION DES CACHES
# Résout les problèmes de cache Next.js, Node.js, et navigateur
# ===================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${BLUE} ♻️  NETTOYAGE COMPLET DES CACHES${NC}"
echo "=================================="
echo ""

# Aller dans le dossier Math4Child
if [ -d "apps/math4child" ]; then
    cd apps/math4child
    echo -e "${GREEN}✅ Positionnement: apps/math4child${NC}"
elif [ -d "math4child" ]; then
    cd math4child
    echo -e "${GREEN}✅ Positionnement: math4child${NC}"
elif [ -f "package.json" ] && grep -q "math4child" package.json; then
    echo -e "${GREEN}✅ Positionnement: dossier actuel${NC}"
else
    echo -e "${RED}❌ Math4Child non trouvé${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}🧹 ÉTAPE 1: ARRÊT DES PROCESSUS${NC}"
echo "================================"

# Arrêter tous les processus Next.js et Playwright
echo -e "${BLUE}🛑 Arrêt des serveurs Next.js...${NC}"
pkill -f "next dev" 2>/dev/null || true
pkill -f "npm run dev" 2>/dev/null || true
pkill -f "node.*next" 2>/dev/null || true

echo -e "${BLUE}🛑 Arrêt des serveurs Playwright...${NC}"
pkill -f "playwright show-report" 2>/dev/null || true
pkill -f "npx playwright" 2>/dev/null || true

# Attendre que les processus se terminent
sleep 3

echo ""
echo -e "${YELLOW}🧹 ÉTAPE 2: NETTOYAGE CACHES NEXT.JS${NC}"
echo "====================================="

# Supprimer les caches Next.js
echo -e "${BLUE}🗑️  Suppression .next/...${NC}"
rm -rf .next/

echo -e "${BLUE}🗑️  Suppression out/...${NC}"
rm -rf out/

echo -e "${BLUE}🗑️  Suppression build/...${NC}"
rm -rf build/

echo -e "${BLUE}🗑️  Suppression dist/...${NC}"
rm -rf dist/

echo ""
echo -e "${YELLOW}🧹 ÉTAPE 3: NETTOYAGE CACHES NODE.JS${NC}"
echo "====================================="

# Supprimer les caches Node.js
echo -e "${BLUE}🗑️  Suppression node_modules/.cache/...${NC}"
rm -rf node_modules/.cache/

echo -e "${BLUE}🗑️  Nettoyage cache npm...${NC}"
npm cache clean --force 2>/dev/null || true

echo -e "${BLUE}🗑️  Suppression .tsbuildinfo...${NC}"
rm -f *.tsbuildinfo

echo ""
echo -e "${YELLOW}🧹 ÉTAPE 4: NETTOYAGE CACHES PLAYWRIGHT${NC}"
echo "========================================"

# Supprimer les caches Playwright
echo -e "${BLUE}🗑️  Suppression test-results/...${NC}"
rm -rf test-results/

echo -e "${BLUE}🗑️  Suppression playwright-report/...${NC}"
rm -rf playwright-report/

echo -e "${BLUE}🗑️  Suppression blob-report/...${NC}"
rm -rf blob-report/

echo -e "${BLUE}🗑️  Suppression .playwright/...${NC}"
rm -rf .playwright/

echo ""
echo -e "${YELLOW}🧹 ÉTAPE 5: NETTOYAGE SYSTÈME${NC}"
echo "=============================="

# Supprimer les fichiers temporaires système
echo -e "${BLUE}🗑️  Suppression fichiers temporaires...${NC}"
rm -rf .DS_Store
rm -rf .env.local.bak
rm -rf *.log
rm -rf npm-debug.log*
rm -rf yarn-debug.log*
rm -rf yarn-error.log*

# Nettoyer les ports potentiellement bloqués
echo -e "${BLUE}🧹 Libération des ports 3000 et 9323...${NC}"
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
lsof -ti:9323 | xargs kill -9 2>/dev/null || true

echo ""
echo -e "${YELLOW}🔄 ÉTAPE 6: REINSTALLATION PROPRE${NC}"
echo "=================================="

# Réinstaller les dépendances
echo -e "${BLUE}📦 Réinstallation des dépendances...${NC}"
npm install

# Réinstaller Playwright si nécessaire
if ! npx playwright --version &> /dev/null; then
    echo -e "${BLUE}🎭 Réinstallation de Playwright...${NC}"
    npm install -D @playwright/test@latest
    npx playwright install --with-deps
else
    echo -e "${GREEN}✅ Playwright déjà installé${NC}"
fi

echo ""
echo -e "${YELLOW}🔄 ÉTAPE 7: REDÉMARRAGE SERVEUR${NC}"
echo "==============================="

# Forcer un redémarrage propre
echo -e "${BLUE}🚀 Démarrage du serveur Next.js...${NC}"

# Démarrer en arrière-plan
npm run dev &
SERVER_PID=$!

# Attendre que le serveur démarre
echo -e "${BLUE}⏳ Attente du démarrage (peut prendre jusqu'à 30s)...${NC}"
for i in {1..30}; do
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Serveur démarré !${NC}"
        break
    fi
    sleep 1
    echo -n "."
done

if [ $i -eq 30 ]; then
    echo -e "${RED}❌ Timeout - le serveur met du temps à démarrer${NC}"
    echo -e "${YELLOW}⚠️  Essayez manuellement: npm run dev${NC}"
else
    echo ""
    echo -e "${YELLOW}🧪 ÉTAPE 8: TEST DE VALIDATION${NC}"
    echo "============================="
    
    # Attendre un peu plus pour que tout soit stable
    sleep 5
    
    # Lancer les tests
    echo -e "${BLUE}🧪 Lancement des tests de validation...${NC}"
    if npm run test:quick; then
        echo -e "${GREEN}✅ Tests réussis !${NC}"
    else
        echo -e "${YELLOW}⚠️  Tests partiels - mais le serveur fonctionne${NC}"
    fi
fi

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}     NETTOYAGE TERMINÉ !                ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${GREEN}🎉 CACHES NETTOYÉS ET SERVEUR REDÉMARRÉ !${NC}"
echo ""
echo -e "${BLUE}🌐 APPLICATION DISPONIBLE :${NC}"
echo "URL: http://localhost:3000"
echo "PID du serveur: $SERVER_PID"
echo ""
echo -e "${BLUE}🧪 COMMANDES DE TEST :${NC}"
echo "npm run test:quick           # Validation rapide"
echo "npm run test:headed          # Tests avec interface"
echo "npm run test:report          # Voir le rapport"
echo ""
echo -e "${BLUE}📝 EN CAS DE PROBLÈME :${NC}"
echo "1. Ctrl+C pour arrêter le serveur"
echo "2. npm run dev pour redémarrer manuellement"
echo "3. Vérifier que le port 3000 est libre"
echo ""
echo -e "${GREEN}🎯 Le cache est maintenant propre !${NC}"