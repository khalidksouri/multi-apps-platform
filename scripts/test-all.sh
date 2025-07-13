#!/bin/bash

echo "🧪 Exécution de tous les tests..."

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les étapes
print_step() {
    echo -e "${YELLOW}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Tests des packages
print_step "Tests des packages partagés..."

# Shared package
if [ -d "packages/shared" ]; then
    cd packages/shared
    if [ -f "package.json" ] && grep -q "test" package.json; then
        npm test
        if [ $? -eq 0 ]; then
            print_success "Tests du package shared réussis"
        else
            print_error "Tests du package shared échoués"
        fi
    else
        echo "Aucun script de test trouvé pour shared"
    fi
    cd ../../
fi

# UI package
if [ -d "packages/ui" ]; then
    cd packages/ui
    if [ -f "package.json" ] && grep -q "test" package.json; then
        npm test
        if [ $? -eq 0 ]; then
            print_success "Tests du package ui réussis"
        else
            print_error "Tests du package ui échoués"
        fi
    else
        echo "Aucun script de test trouvé pour ui"
    fi
    cd ../../
fi

# Build des packages avant les tests E2E
print_step "Build des packages..."
npm run build:packages
if [ $? -eq 0 ]; then
    print_success "Build des packages réussi"
else
    print_error "Build des packages échoué"
    exit 1
fi

# Tests E2E avec Playwright
print_step "Tests E2E avec Playwright..."
npm run test
if [ $? -eq 0 ]; then
    print_success "Tests E2E réussis"
else
    print_error "Tests E2E échoués"
fi

# Tests spécifiques par application
print_step "Tests spécifiques par application..."

# Test PostMath
npm run test:postmath
if [ $? -eq 0 ]; then
    print_success "Tests PostMath réussis"
else
    print_error "Tests PostMath échoués"
fi

echo -e "${GREEN}🎉 Tous les tests terminés!${NC}"