#!/bin/bash

# Script de test complet pour Math4Child

echo "🧪 Tests Complets Math4Child"
echo "=========================="

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASSED=0
FAILED=0

test_command() {
    local name="$1"
    local command="$2"
    
    echo -e "${BLUE}Testing: $name${NC}"
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $name: PASSED${NC}"
        ((PASSED++))
    else
        echo -e "${RED}❌ $name: FAILED${NC}"
        ((FAILED++))
    fi
}

# Tests
test_command "TypeScript Check" "npm run type-check"
test_command "ESLint Check" "npm run lint"
test_command "Build Production" "npm run build"
test_command "File Structure" "[ -f 'src/app/page.tsx' ] && [ -d 'src/components' ]"

# Résultats
echo ""
echo "=========================="
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 Tous les tests passent! ($PASSED/$((PASSED + FAILED)))${NC}"
    echo -e "${GREEN}Math4Child est prêt pour la production!${NC}"
else
    echo -e "${YELLOW}⚠️  Tests: $PASSED passés, $FAILED échués${NC}"
    echo -e "${YELLOW}Vérifiez les erreurs ci-dessus${NC}"
fi
