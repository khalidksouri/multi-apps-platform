#!/bin/bash

echo "🏗️ Build de toutes les applications..."

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

# Build des packages d'abord
print_step "Build des packages partagés..."

# Shared package
print_step "Build du package shared..."
cd packages/shared
npm run build
if [ $? -eq 0 ]; then
    print_success "Build shared réussi"
else
    print_error "Build shared échoué"
    exit 1
fi
cd ../../

# UI package
print_step "Build du package ui..."
cd packages/ui
npm run build
if [ $? -eq 0 ]; then
    print_success "Build ui réussi"
else
    print_error "Build ui échoué"
    exit 1
fi
cd ../../

# Build des applications
print_step "Build des applications..."

apps=("ai4kids" "budgetcron" "postmath" "unitflip" "multiai")

for app in "${apps[@]}"; do
    print_step "Build de $app..."
    cd "apps/$app"
    npm run build
    if [ $? -eq 0 ]; then
        print_success "Build $app réussi"
    else
        print_error "Build $app échoué"
        cd ../../
        exit 1
    fi
    cd ../../
done

print_success "🎉 Tous les builds terminés avec succès!"

# Affichage des tailles des builds
print_step "Taille des builds:"
for app in "${apps[@]}"; do
    if [ -d "apps/$app/.next" ]; then
        size=$(du -sh "apps/$app/.next" | cut -f1)
        echo "$app: $size"
    fi
done