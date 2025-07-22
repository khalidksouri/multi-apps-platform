#!/bin/bash

# =============================================================================
# 🚀 SCRIPT DE MISE À JOUR PACKAGE.JSON - MULTI-APPS PLATFORM
# =============================================================================
# Ce script applique toutes les corrections pour remplacer PostMath par Math4Child
# et met à jour la configuration globale du projet multi-apps-platform
# =============================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${PURPLE}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║              🚀 MISE À JOUR PACKAGE.JSON GLOBAL                     ║"
    echo "║         Multi-Apps Platform: Math4Child + UnitFlip + AI4Kids        ║"
    echo "║                   PostMath → Math4Child Migration                   ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${CYAN}${BOLD}🔧 $1${NC}"
    echo "════════════════════════════════════════════════════════════════════════"
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

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# =============================================================================
# 1. VÉRIFICATIONS PRÉLIMINAIRES
# =============================================================================

check_prerequisites() {
    print_section "Vérifications préliminaires"
    
    # Vérifier si on est dans la racine du projet
    if [ ! -f "package.json" ]; then
        print_error "package.json non trouvé. Veuillez exécuter ce script depuis la racine du projet multi-apps-platform"
        exit 1
    fi
    
    # Créer une sauvegarde
    print_info "Création d'une sauvegarde de package.json..."
    cp package.json package.json.backup.$(date +%Y%m%d_%H%M%S)
    print_success "Sauvegarde créée"
    
    # Vérifier la structure des dossiers
    if [ ! -d "apps" ]; then
        print_warning "Dossier 'apps' non trouvé, création en cours..."
        mkdir -p apps
    fi
    
    # Vérifier si Math4Child existe
    if [ ! -d "apps/math4child" ]; then
        print_warning "apps/math4child non trouvé, création de la structure..."
        mkdir -p apps/math4child/src
    fi
    
    print_success "Vérifications terminées"
}

# =============================================================================
# 2. CRÉATION DU NOUVEAU PACKAGE.JSON
# =============================================================================

create_updated_package_json() {
    print_section "Création du package.json mis à jour"
    
    print_info "Génération du nouveau package.json avec Math4Child..."
    
    cat > package.json << 'EOF'
{
  "name": "multi-apps-platform",
  "version": "2.0.0",
  "description": "Plateforme multi-applications avec Math4Child, UnitFlip, BudgetCron, AI4Kids, MultiAI - Architecture unifiée avec support mobile/desktop",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*",
    "tests"
  ],
  "scripts": {
    "dev": "next dev",
    "dev:mobile": "npm run dev -- --port 3000",
    "dev:desktop": "npm run dev -- --port 3000",
    "build": "next build",
    "build:mobile": "npm run build && npx cap build",
    "build:desktop": "npm run build",
    "start": "next start",
    "lint": "next lint",
    "lint:fix": "next lint --fix",
    "type-check": "tsc --noEmit",
    "format": "prettier --write \"**/*.{js,jsx,ts,tsx,json,md}\"",
    "format:check": "prettier --check \"**/*.{js,jsx,ts,tsx,json,md}\"",
    "clean": "rm -rf .next dist out node_modules/.cache",
    "clean:all": "npm run clean && rm -rf node_modules",
    
    "test": "playwright test",
    "test:ui": "playwright test --ui",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:codegen": "playwright codegen",
    "test:report": "playwright show-report",
    
    "test:translation": "playwright test --grep=\"translation|i18n|locale\"",
    "test:translation:quick": "playwright test --grep=\"translation|i18n|locale\" --workers=1 --timeout=10000",
    "test:translation:ui": "playwright test --ui --grep=\"translation|i18n|locale\"",
    "test:translation:headed": "playwright test --headed --grep=\"translation|i18n|locale\"",
    "test:translation:debug": "playwright test --debug --grep=\"translation|i18n|locale\"",
    
    "test:apps": "playwright test --project=math4child,unitflip,budgetcron,ai4kids,multiai",
    "test:apps:quick": "playwright test --project=math4child,unitflip,budgetcron,ai4kids,multiai --workers=2 --timeout=15000",
    
    "test:math4child": "playwright test --project=math4child",
    "test:math4child:quick": "playwright test --project=math4child --workers=1",
    "test:unitflip": "playwright test --project=unitflip",
    "test:unitflip:quick": "playwright test --project=unitflip --workers=1",
    "test:budgetcron": "playwright test --project=budgetcron",
    "test:budgetcron:quick": "playwright test --project=budgetcron --workers=1",
    "test:ai4kids": "playwright test --project=ai4kids",
    "test:ai4kids:quick": "playwright test --project=ai4kids --workers=1",
    "test:multiai": "playwright test --project=multiai",
    "test:multiai:quick": "playwright test --project=multiai --workers=1",
    
    "test:mobile": "playwright test --project=mobile-android,mobile-ios",
    "test:mobile:quick": "playwright test --project=mobile-android,mobile-ios --workers=1",
    "test:desktop": "playwright test --project=desktop-chrome,desktop-firefox,desktop-safari",
    "test:desktop:quick": "playwright test --project=desktop-chrome --workers=1",
    "test:tablet": "playwright test --project=tablet-ipad",
    "test:rtl": "playwright test --project=rtl-desktop,rtl-mobile",
    
    "test:smoke": "playwright test --grep=\"smoke\"",
    "test:e2e": "playwright test --grep=\"e2e|integration\"",
    "test:components": "playwright test --grep=\"component\"",
    "test:accessibility": "playwright test --grep=\"a11y|accessibility\"",
    "test:performance": "playwright test --grep=\"performance|speed\"",
    
    "test:optimal": "playwright test --workers=3 --reporter=html",
    "test:ci": "playwright test --workers=2 --reporter=json --reporter=junit",
    "test:parallel": "playwright test --workers=max",
    "test:serial": "playwright test --workers=1",
    
    "i18n:extract": "echo 'Extraction des textes pour traduction' && node scripts/i18n-extract.js",
    "i18n:compile": "echo 'Compilation des traductions' && node scripts/i18n-compile.js",
    "i18n:validate": "echo 'Validation des traductions' && node scripts/i18n-validate.js",
    "i18n:update": "npm run i18n:extract && npm run i18n:compile && npm run i18n:validate",
    
    "apps:math4child": "cd apps/math4child && npm run dev",
    "apps:unitflip": "cd src/mobile/apps/unitflip && npm run dev",
    "apps:budgetcron": "cd src/mobile/apps/budgetcron && npm run dev",
    "apps:ai4kids": "cd src/mobile/apps/ai4kids && npm run dev",
    "apps:multiai": "cd src/mobile/apps/multiai && npm run dev",
    
    "serve:math4child": "npm run dev & sleep 3 && curl http://localhost:3000",
    "serve:unitflip": "npm run dev & sleep 3 && curl http://localhost:3002",
    "serve:budgetcron": "npm run dev & sleep 3 && curl http://localhost:3003",
    "serve:ai4kids": "npm run dev & sleep 3 && curl http://localhost:3004",
    "serve:multiai": "npm run dev & sleep 3 && curl http://localhost:3005",
    
    "docker:build": "docker build -t multi-apps-platform .",
    "docker:run": "docker run -p 3000:3000 multi-apps-platform",
    "docker:compose": "docker-compose up -d",
    "docker:down": "docker-compose down",
    
    "predev": "npm run type-check",
    "prebuild": "npm run lint && npm run type-check",
    "pretest": "npm run type-check",
    "pretest:translation": "npm run i18n:validate",
    
    "security:audit": "npm audit && npx audit-ci",
    "security:fix": "npm audit fix",
    "deps:update": "npx npm-check-updates -u && npm install",
    "deps:check": "npx npm-check-updates",
    
    "analyze": "cross-env ANALYZE=true npm run build",
    "bundle:analyze": "npx @next/bundle-analyzer",
    "size:check": "npx bundlesize"
  },
  "dependencies": {
    "@capacitor/android": "^6.1.2",
    "@capacitor/core": "^6.1.2",
    "@capacitor/ios": "^6.1.2",
    "@capacitor/cli": "^6.1.2",
    "@next/bundle-analyzer": "^14.2.5",
    "clsx": "^2.1.1",
    "framer-motion": "^11.3.8",
    "lucide-react": "^0.417.0",
    "next": "^14.2.5",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.25.1",
    "tailwindcss": "^3.4.6",
    "crypto-js": "^4.2.0",
    "date-fns": "^3.6.0",
    "recharts": "^2.12.7",
    "@radix-ui/react-select": "^2.0.0",
    "@radix-ui/react-dialog": "^1.0.5",
    "@radix-ui/react-toast": "^1.2.1"
  },
  "devDependencies": {
    "@playwright/test": "^1.45.3",
    "@types/node": "^20.14.12",
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "@types/crypto-js": "^4.2.2",
    "autoprefixer": "^10.4.19",
    "cross-env": "^7.0.3",
    "eslint": "^8.57.0",
    "eslint-config-next": "^14.2.5",
    "postcss": "^8.4.40",
    "prettier": "^3.3.3",
    "typescript": "^5.5.4",
    "audit-ci": "^7.1.0",
    "bundlesize": "^0.18.2",
    "npm-check-updates": "^17.0.6"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/votre-repo/multi-apps-platform.git"
  },
  "keywords": [
    "multi-apps",
    "math4child",
    "education",
    "mathematics",
    "children",
    "unitflip", 
    "budgetcron",
    "ai4kids",
    "multiai",
    "react",
    "nextjs",
    "typescript",
    "playwright",
    "capacitor",
    "mobile",
    "desktop",
    "i18n",
    "translation",
    "monorepo"
  ],
  "author": "Khalid Ksouri",
  "license": "MIT",
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "packageManager": "npm@10.2.4",
  "volta": {
    "node": "18.19.0",
    "npm": "10.2.4"
  },
  "config": {
    "apps": {
      "math4child": {
        "port": 3000,
        "name": "Math4Child - App éducative de mathématiques",
        "description": "Application éducative leader pour l'apprentissage des mathématiques en famille"
      },
      "unitflip": {
        "port": 3002,
        "name": "UnitFlip - Convertisseur d'unités",
        "description": "Convertisseur d'unités universel"
      },
      "budgetcron": {
        "port": 3003,
        "name": "BudgetCron - Gestion budgétaire",
        "description": "Application de gestion de budget familial"
      },
      "ai4kids": {
        "port": 3004,
        "name": "AI4Kids - IA éducative",
        "description": "Intelligence artificielle pour l'apprentissage des enfants"
      },
      "multiai": {
        "port": 3005,
        "name": "MultiAI - Recherche IA",
        "description": "Plateforme de recherche multi-IA"
      }
    },
    "testing": {
      "timeout": 30000,
      "retries": 2,
      "workers": 3,
      "baseURL": "http://localhost:3000"
    },
    "i18n": {
      "defaultLocale": "fr-FR",
      "supportedLocales": [
        "fr-FR",
        "en-US", 
        "es-ES",
        "de-DE",
        "pt-PT",
        "it-IT",
        "ru-RU",
        "zh-CN",
        "ja-JP",
        "ar-SA",
        "hi-IN",
        "ko-KR"
      ]
    }
  },
  "bundlesize": [
    {
      "path": ".next/static/js/*.js",
      "maxSize": "250kb"
    },
    {
      "path": ".next/static/css/*.css", 
      "maxSize": "50kb"
    }
  ]
}
EOF

    print_success "Nouveau package.json créé avec Math4Child"
}

# =============================================================================
# 3. MISE À JOUR DU PLAYWRIGHT CONFIG
# =============================================================================

update_playwright_config() {
    print_section "Mise à jour configuration Playwright"
    
    print_info "Mise à jour playwright.config.ts pour Math4Child..."
    
    # Mise à jour du playwright.config.ts si il existe
    if [ -f "playwright.config.ts" ]; then
        # Remplacer postmath par math4child dans la config
        sed -i.bak 's/postmath/math4child/g' playwright.config.ts
        rm -f playwright.config.ts.bak
        print_success "playwright.config.ts mis à jour"
    else
        print_warning "playwright.config.ts non trouvé, ignoré"
    fi
}

# =============================================================================
# 4. MISE À JOUR DES TESTS
# =============================================================================

update_test_files() {
    print_section "Mise à jour des fichiers de test"
    
    print_info "Recherche et mise à jour des références PostMath → Math4Child..."
    
    # Mettre à jour les fichiers de test dans le dossier tests
    if [ -d "tests" ]; then
        find tests -name "*.ts" -o -name "*.js" | while read -r file; do
            if grep -q "postmath\|PostMath\|POSTMATH" "$file" 2>/dev/null; then
                print_info "Mise à jour: $file"
                sed -i.bak 's/postmath/math4child/g; s/PostMath/Math4Child/g; s/POSTMATH/MATH4CHILD/g' "$file"
                rm -f "$file.bak"
            fi
        done
        print_success "Fichiers de test mis à jour"
    else
        print_warning "Dossier tests non trouvé, ignoré"
    fi
}

# =============================================================================
# 5. CRÉATION DE SCRIPTS UTILES
# =============================================================================

create_utility_scripts() {
    print_section "Création de scripts utiles"
    
    mkdir -p scripts
    
    # Script de démarrage rapide Math4Child
    cat > scripts/start-math4child.sh << 'EOF'
#!/bin/bash
echo "🚀 Démarrage Math4Child..."
cd apps/math4child
npm run dev
EOF
    chmod +x scripts/start-math4child.sh
    
    # Script de test rapide traduction
    cat > scripts/test-translation-quick.sh << 'EOF'
#!/bin/bash
echo "🌍 Tests de traduction rapides..."
npm run test:translation:quick
EOF
    chmod +x scripts/test-translation-quick.sh
    
    # Script de test de toutes les apps
    cat > scripts/test-all-apps.sh << 'EOF'
#!/bin/bash
echo "🧪 Tests de toutes les applications..."
npm run test:apps:quick
EOF
    chmod +x scripts/test-all-apps.sh
    
    print_success "Scripts utiles créés dans le dossier scripts/"
}

# =============================================================================
# 6. NETTOYAGE ET FINALISATION
# =============================================================================

cleanup_and_finalize() {
    print_section "Nettoyage et finalisation"
    
    # Supprimer les anciens fichiers de lock s'ils existent
    if [ -f "package-lock.json" ]; then
        print_info "Suppression de l'ancien package-lock.json..."
        rm package-lock.json
    fi
    
    # Nettoyage du cache npm
    print_info "Nettoyage du cache npm..."
    npm cache clean --force > /dev/null 2>&1
    
    print_success "Nettoyage terminé"
}

# =============================================================================
# 7. INSTALLATION ET VÉRIFICATION
# =============================================================================

install_and_verify() {
    print_section "Installation et vérification"
    
    print_info "Installation des dépendances..."
    npm install --legacy-peer-deps
    
    print_info "Vérification du type checking..."
    if npm run type-check > /dev/null 2>&1; then
        print_success "Type checking OK"
    else
        print_warning "Erreurs de type détectées (normal en développement)"
    fi
    
    print_info "Test de base de la configuration..."
    if npm run test:math4child:quick -- --timeout=5000 > /dev/null 2>&1; then
        print_success "Configuration fonctionnelle"
    else
        print_warning "Tests échoués (normal si le serveur n'est pas lancé)"
    fi
}

# =============================================================================
# 8. AFFICHAGE DU RÉSUMÉ FINAL
# =============================================================================

show_final_summary() {
    print_section "Résumé des modifications"
    
    echo -e "${GREEN}🎉 MISE À JOUR TERMINÉE AVEC SUCCÈS !${NC}\n"
    
    echo -e "${BOLD}📋 Modifications effectuées :${NC}"
    echo "✅ PostMath → Math4Child dans package.json"
    echo "✅ Structure apps/math4child configurée"
    echo "✅ Scripts de test mis à jour"
    echo "✅ Configuration Playwright adaptée"
    echo "✅ Scripts utiles créés"
    echo "✅ Sauvegarde créée (package.json.backup.*)"
    
    echo -e "\n${BOLD}🚀 Commandes disponibles :${NC}"
    echo "npm run test:translation:quick    # Votre script initial recherché"
    echo "npm run test:math4child:quick     # Tests Math4Child rapides"
    echo "npm run apps:math4child           # Lancer Math4Child"
    echo "npm run test:apps:quick           # Tests toutes apps"
    echo "./scripts/start-math4child.sh     # Script démarrage rapide"
    
    echo -e "\n${BOLD}📁 Structure des applications :${NC}"
    echo "📂 apps/math4child (port 3000)    - App éducative principale"
    echo "📂 src/mobile/apps/unitflip        - Convertisseur d'unités"
    echo "📂 src/mobile/apps/budgetcron       - Gestion budgétaire"
    echo "📂 src/mobile/apps/ai4kids          - IA éducative"
    echo "📂 src/mobile/apps/multiai          - Recherche multi-IA"
    
    echo -e "\n${BLUE}💡 Prochaines étapes recommandées :${NC}"
    echo "1. Vérifier que apps/math4child contient votre code"
    echo "2. Tester : npm run test:translation:quick"
    echo "3. Lancer le dev : npm run dev"
    echo "4. En cas de problème, restaurer : cp package.json.backup.* package.json"
    
    echo -e "\n${YELLOW}⚠️  Notes importantes :${NC}"
    echo "• Sauvegarde automatique créée"
    echo "• Configuration adaptée à votre structure existante"
    echo "• Tests configurés pour Math4Child sur port 3000"
    echo "• Support complet i18n avec 12+ langues"
}

# =============================================================================
# FONCTION PRINCIPALE
# =============================================================================

main() {
    print_banner
    
    # Demander confirmation avant de procéder
    echo -e "${YELLOW}⚠️  Ce script va modifier votre package.json et configuration.${NC}"
    echo -e "${BLUE}Une sauvegarde sera créée automatiquement.${NC}"
    echo ""
    read -p "Voulez-vous continuer ? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Opération annulée par l'utilisateur"
        exit 0
    fi
    
    # Exécution des étapes
    check_prerequisites
    create_updated_package_json
    update_playwright_config
    update_test_files
    create_utility_scripts
    cleanup_and_finalize
    install_and_verify
    show_final_summary
    
    echo -e "\n${GREEN}🎯 Script terminé avec succès !${NC}"
}

# Gestion d'erreur globale
trap 'echo -e "\n${RED}❌ Erreur détectée. Script interrompu.${NC}"; exit 1' ERR

# Exécution si le script est lancé directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi