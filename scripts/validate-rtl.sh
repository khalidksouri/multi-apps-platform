#!/bin/bash

echo "🌍 Validation Interface RTL Math4Child"
echo "====================================="

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Vérifications
echo -e "${BLUE}📋 Vérification des fichiers RTL...${NC}"

# Vérifier la présence des fichiers critiques
if [ -f "src/components/pricing/PricingPlansRTL.tsx" ]; then
    echo -e "${GREEN}✅ Composant Pricing RTL présent${NC}"
else
    echo -e "${YELLOW}⚠️ Composant Pricing RTL manquant${NC}"
fi

if [ -f "src/app/pricing/page.tsx" ]; then
    echo -e "${GREEN}✅ Page Pricing présente${NC}"
else
    echo -e "${YELLOW}⚠️ Page Pricing manquante${NC}"
fi

if [ -f "tests/specs/rtl/pricing-rtl.spec.ts" ]; then
    echo -e "${GREEN}✅ Tests RTL présents${NC}"
else
    echo -e "${YELLOW}⚠️ Tests RTL manquants${NC}"
fi

# Vérifier les styles RTL dans globals.css
echo -e "${BLUE}📋 Vérification des styles RTL...${NC}"
if grep -q "\[dir=\"rtl\"\]" "src/app/globals.css"; then
    echo -e "${GREEN}✅ Styles RTL détectés dans globals.css${NC}"
else
    echo -e "${YELLOW}⚠️ Styles RTL non détectés${NC}"
fi

# Tests rapides
echo -e "${BLUE}🧪 Tests RTL rapides...${NC}"
npx playwright test tests/specs/rtl/pricing-rtl.spec.ts --project=smoke || echo -e "${YELLOW}⚠️ Certains tests RTL ont échoué${NC}"

echo ""
echo -e "${GREEN}🎉 Validation RTL terminée !${NC}"
echo -e "${BLUE}💡 Pour tester manuellement :${NC}"
echo -e "1. make dev-rtl"
echo -e "2. Aller sur http://localhost:3000/pricing"
echo -e "3. Vérifier l'affichage RTL"
