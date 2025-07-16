#!/bin/bash

# 🔍 Script de diagnostic I18n
echo "🔍 Diagnostic du système I18n..."

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")

echo -e "${BLUE}🖥️  Informations système:${NC}"
echo "  Node.js: $(node --version 2>/dev/null || echo 'Non installé')"
echo "  npm: $(npm --version 2>/dev/null || echo 'Non installé')"
echo "  Système: $(uname -s)"
echo ""

echo -e "${BLUE}📁 Structure des applications:${NC}"
for app in "${APPS[@]}"; do
    echo -e "${YELLOW}Application: $app${NC}"
    
    if [ -d "apps/$app" ]; then
        echo -e "  ${GREEN}✅ Répertoire principal${NC}"
        
        # Vérifier les fichiers essentiels
        files=(
            "src/hooks/useUniversalI18n.ts"
            "src/components/I18nLayout.tsx"
            "src/translations/index.ts"
            "src/app/layout.tsx"
            "src/app/page.tsx"
            "package.json"
            "tsconfig.json"
            "next.config.js"
            "tailwind.config.js"
        )
        
        for file in "${files[@]}"; do
            if [ -f "apps/$app/$file" ]; then
                echo -e "  ${GREEN}✅ $file${NC}"
            else
                echo -e "  ${RED}❌ $file${NC}"
            fi
        done
        
        # Vérifier node_modules
        if [ -d "apps/$app/node_modules" ]; then
            echo -e "  ${GREEN}✅ node_modules${NC}"
        else
            echo -e "  ${YELLOW}⚠️  node_modules (pas installé)${NC}"
        fi
        
    else
        echo -e "  ${RED}❌ Répertoire non trouvé${NC}"
    fi
    
    echo ""
done

echo -e "${BLUE}🌐 Vérification des ports:${NC}"
PORTS=(3001 3002 3003 3004 3005)
for i in "${!APPS[@]}"; do
    port="${PORTS[$i]}"
    app="${APPS[$i]}"
    
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅ Port $port ($app) - En cours d'utilisation${NC}"
    else
        echo -e "  ${YELLOW}⚠️  Port $port ($app) - Libre${NC}"
    fi
done

echo ""
echo -e "${BLUE}🔧 Recommandations:${NC}"
echo "1. Si des fichiers manquent, relancez le script d'installation"
echo "2. Si node_modules manque, exécutez: ./install-all-dependencies.sh"
echo "3. Si les ports sont libres, démarrez les apps: ./start-all-apps.sh"
echo "4. Si des erreurs persistent, consultez les logs dans le dossier 'logs/'"
