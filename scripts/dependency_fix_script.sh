#!/bin/bash
set -e

# =============================================================================
# 🔧 SCRIPT DE CORRECTION DES DÉPENDANCES MATH4CHILD
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}              ${YELLOW}🔧 CORRECTEUR DE DÉPENDANCES${NC}                   ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}          ${GREEN}Résolution automatique des conflits npm${NC}           ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Fonction de diagnostic
diagnose_dependencies() {
    echo -e "${BLUE}▶ DIAGNOSTIC DES DÉPENDANCES${NC}"
    echo "═══════════════════════════════════════════════════════════════════"
    
    if [ ! -f "package.json" ]; then
        print_error "package.json non trouvé dans le répertoire courant"
        exit 1
    fi
    
    print_info "Analyse des conflits de dépendances..."
    
    # Vérifier la version de Node.js
    NODE_VERSION=$(node --version | grep -o '[0-9]*' | head -1)
    print_info "Version Node.js détectée: v$NODE_VERSION"
    
    if [ "$NODE_VERSION" -lt 18 ]; then
        print_warning "Node.js v18+ recommandé pour une meilleure compatibilité"
    fi
    
    # Vérifier les conflits connus
    if grep -q "@capacitor/core.*6\." package.json && grep -q "@revenuecat/purchases-capacitor" package.json; then
        print_warning "Conflit détecté: Capacitor v6 incompatible avec RevenueCat"
        return 1
    fi
    
    print_success "Analyse terminée"
    return 0
}

# Correction automatique
fix_dependencies() {
    echo -e "${BLUE}▶ CORRECTION DES DÉPENDANCES${NC}"
    echo "═══════════════════════════════════════════════════════════════════"
    
    print_info "Sauvegarde de package.json..."
    cp package.json package.json.backup
    
    print_info "Nettoyage complet..."
    rm -rf node_modules package-lock.json
    npm cache clean --force
    
    print_info "Correction des versions dans package.json..."
    
    # Créer un package.json corrigé
    cat > package.json << 'EOF'
{
  "name": "math4child",
  "version": "2.0.0",
  "description": "Math4Child.com - App éducative leader avec système de paiement optimal",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "lint:fix": "next lint --fix",
    "type-check": "tsc --noEmit",
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:optimal": "playwright test --project=chromium-optimal",
    "test:mobile": "playwright test --project=mobile-ios-revenuecat",
    "test:conversion": "playwright test optimal-system.spec.ts",
    "clean": "rm -rf .next out dist node_modules/.cache"
  },
  "dependencies": {
    "next": "14.2.13",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "lucide-react": "0.469.0",
    "@revenuecat/purchases-capacitor": "7.7.1",
    "@paddle/paddle-js": "1.2.3",
    "@lemonsqueezy/lemonsqueezy.js": "2.2.0",
    "@stripe/stripe-js": "4.7.0",
    "stripe": "16.12.0",
    "recharts": "2.12.7",
    "date-fns": "3.6.0",
    "crypto-js": "4.2.0"
  },
  "devDependencies": {
    "@types/node": "20.14.8",
    "@types/react": "18.3.12",
    "@types/react-dom": "18.3.1",
    "@types/crypto-js": "4.2.2",
    "typescript": "5.4.5",
    "eslint": "8.57.0",
    "eslint-config-next": "14.2.13",
    "tailwindcss": "3.4.13",
    "autoprefixer": "10.4.20",
    "postcss": "8.4.47",
    "@playwright/test": "1.48.0",
    "@capacitor/core": "5.7.8",
    "@capacitor/cli": "5.7.8",
    "@capacitor/ios": "5.7.8",
    "@capacitor/android": "5.7.8"
  },
  "overrides": {
    "@capacitor/core": "5.7.8"
  },
  "resolutions": {
    "@capacitor/core": "5.7.8"
  }
}
EOF

    print_success "package.json corrigé créé"
    
    print_info "Installation avec résolution forcée..."
    npm install --legacy-peer-deps --force
    
    print_success "Dépendances installées avec succès"
}

# Installation spécifique RevenueCat
install_revenuecat() {
    print_info "Installation spécifique RevenueCat..."
    
    # Vérifier si RevenueCat est compatible
    if npm ls @capacitor/core 2>/dev/null | grep -q "5\."; then
        npm install @revenuecat/purchases-capacitor --legacy-peer-deps
        print_success "RevenueCat installé avec Capacitor v5"
    else
        print_error "Capacitor v5 requis pour RevenueCat"
        return 1
    fi
}

# Test de la configuration
test_configuration() {
    echo -e "${BLUE}▶ TEST DE LA CONFIGURATION${NC}"
    echo "═══════════════════════════════════════════════════════════════════"
    
    print_info "Vérification TypeScript..."
    if npm run type-check 2>/dev/null; then
        print_success "TypeScript OK"
    else
        print_warning "Erreurs TypeScript détectées"
    fi
    
    print_info "Test de build..."
    if npm run build 2>/dev/null; then
        print_success "Build réussi"
    else
        print_warning "Build échoué - vérifiez les logs"
    fi
}

# Nettoyage d'urgence
emergency_cleanup() {
    print_info "Nettoyage d'urgence en cours..."
    
    rm -rf node_modules package-lock.json .next out dist
    npm cache clean --force
    
    if [ -f "package.json.backup" ]; then
        cp package.json.backup package.json
        print_info "package.json restauré depuis la sauvegarde"
    fi
    
    print_success "Nettoyage terminé"
}

# Menu principal
show_menu() {
    echo ""
    echo -e "${YELLOW}Que souhaitez-vous faire ?${NC}"
    echo "1) Diagnostic complet"
    echo "2) Correction automatique"
    echo "3) Installation RevenueCat uniquement"
    echo "4) Test de configuration"
    echo "5) Nettoyage d'urgence"
    echo "6) Tout corriger automatiquement"
    echo "0) Quitter"
    echo ""
    read -p "Votre choix (0-6): " choice
    
    case $choice in
        1) diagnose_dependencies ;;
        2) fix_dependencies ;;
        3) install_revenuecat ;;
        4) test_configuration ;;
        5) emergency_cleanup ;;
        6) 
            print_info "Correction complète en cours..."
            diagnose_dependencies || true
            fix_dependencies
            install_revenuecat
            test_configuration
            print_success "Correction complète terminée !"
            ;;
        0) exit 0 ;;
        *) 
            print_error "Choix invalide"
            show_menu
            ;;
    esac
}

# Point d'entrée principal
main() {
    print_header
    
    # Si argument fourni, exécution directe
    if [ "$1" = "auto" ]; then
        print_info "Mode automatique activé"
        diagnose_dependencies || true
        fix_dependencies
        install_revenuecat || true
        test_configuration
    else
        show_menu
    fi
}

# Gestion des erreurs
trap 'print_error "Erreur détectée. Utilisez option 5 pour nettoyer."; exit 1' ERR

# Exécution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi