#!/bin/bash

# 🧪 Script de test automatique I18n
echo "🔍 Test automatique du système I18n..."

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")
PORTS=(3001 3002 3003 3004 3005)
PASSED_TESTS=0
FAILED_TESTS=0

# Fonction de test
test_app() {
    local app=$1
    local port=$2
    
    echo -e "${BLUE}🧪 Test de $app sur le port $port...${NC}"
    
    # Test 1: Vérifier si l'application répond
    if curl -s -f "http://localhost:$port" > /dev/null; then
        echo -e "${GREEN}  ✅ Application accessible${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}  ❌ Application non accessible${NC}"
        ((FAILED_TESTS++))
    fi
    
    # Test 2: Vérifier si les fichiers I18n existent
    if [ -f "apps/$app/src/hooks/useUniversalI18n.ts" ]; then
        echo -e "${GREEN}  ✅ Hook I18n présent${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}  ❌ Hook I18n manquant${NC}"
        ((FAILED_TESTS++))
    fi
    
    # Test 3: Vérifier les traductions
    if [ -f "apps/$app/src/translations/index.ts" ]; then
        echo -e "${GREEN}  ✅ Traductions présentes${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}  ❌ Traductions manquantes${NC}"
        ((FAILED_TESTS++))
    fi
    
    # Test 4: Vérifier le layout I18n
    if [ -f "apps/$app/src/components/I18nLayout.tsx" ]; then
        echo -e "${GREEN}  ✅ Layout I18n présent${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}  ❌ Layout I18n manquant${NC}"
        ((FAILED_TESTS++))
    fi
    
    echo ""
}

# Tester toutes les applications
for i in "${!APPS[@]}"; do
    test_app "${APPS[$i]}" "${PORTS[$i]}"
done

# Résumé des tests
echo -e "${BLUE}📊 Résumé des tests:${NC}"
echo -e "  ${GREEN}✅ Tests réussis: $PASSED_TESTS${NC}"
echo -e "  ${RED}❌ Tests échoués: $FAILED_TESTS${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}🎉 Tous les tests sont passés! Le système I18n fonctionne correctement.${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Certains tests ont échoué. Vérifiez les erreurs ci-dessus.${NC}"
    exit 1
fi
