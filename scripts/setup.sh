#!/bin/bash

echo "🚀 Configuration initiale du projet multiapps..."

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${YELLOW}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

# Vérifier Node.js
print_step "Vérification de Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_success "Node.js trouvé: $NODE_VERSION"
else
    print_error "Node.js n'est pas installé"
    exit 1
fi

# Vérifier npm
print_step "Vérification de npm..."
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_success "npm trouvé: $NPM_VERSION"
else
    print_error "npm n'est pas installé"
    exit 1
fi

# Installation des dépendances racine
print_step "Installation des dépendances racine..."
npm install
if [ $? -eq 0 ]; then
    print_success "Dépendances racine installées"
else
    print_error "Échec de l'installation des dépendances racine"
    exit 1
fi

# Installation des dépendances des packages
print_step "Installation des dépendances des packages..."

# Package shared
print_step "Installation des dépendances shared..."
cd packages/shared
npm install
if [ $? -eq 0 ]; then
    print_success "Dépendances shared installées"
else
    print_error "Échec de l'installation des dépendances shared"
    exit 1
fi
cd ../../

# Package ui
print_step "Installation des dépendances ui..."
cd packages/ui
npm install
if [ $? -eq 0 ]; then
    print_success "Dépendances ui installées"
else
    print_error "Échec de l'installation des dépendances ui"
    exit 1
fi
cd ../../

# Installation des dépendances des applications
print_step "Installation des dépendances des applications..."

apps=("ai4kids" "budgetcron" "postmath" "unitflip" "multiai")

for app in "${apps[@]}"; do
    print_step "Installation des dépendances de $app..."
    cd "apps/$app"
    npm install
    if [ $? -eq 0 ]; then
        print_success "Dépendances $app installées"
    else
        print_error "Échec de l'installation des dépendances $app"
        cd ../../
        exit 1
    fi
    cd ../../
done

# Build des packages
print_step "Build initial des packages..."
npm run build:packages
if [ $? -eq 0 ]; then
    print_success "Build des packages réussi"
else
    print_error "Build des packages échoué"
    exit 1
fi

# Installation de Playwright
print_step "Installation de Playwright..."
npx playwright install
if [ $? -eq 0 ]; then
    print_success "Playwright installé"
else
    print_error "Échec de l'installation de Playwright"
fi

# Rendre les scripts exécutables
print_step "Configuration des permissions des scripts..."
chmod +x scripts/*.sh
print_success "Permissions configurées"

# Résumé final
echo ""
print_success "🎉 Configuration terminée avec succès!"
echo ""
print_info "Applications disponibles:"
echo "  - AI4Kids (port 3004): Interface IA pour enfants"
echo "  - BudgetCron (port 3003): Gestion budgétaire"
echo "  - PostMath (port 3001): Calculateur d'expédition"
echo "  - UnitFlip (port 3002): Convertisseur d'unités"
echo "  - MultiAI (port 3005): Hub services IA"
echo ""
print_info "Commandes utiles:"
echo "  npm run dev              - Démarrer toutes les apps"
echo "  npm run build            - Build toutes les apps"
echo "  npm run test             - Lancer tous les tests"
echo "  scripts/dev-all.sh       - Démarrer avec concurrently"
echo "  scripts/test-all.sh      - Tests complets"
echo ""