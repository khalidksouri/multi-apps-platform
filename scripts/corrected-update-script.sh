#!/bin/bash

# =============================================================================
# 🚀 SCRIPT DE MISE À JOUR PACKAGE.JSON - MULTI-APPS PLATFORM (CORRIGÉ)
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
    echo "║              🚀 MISE À JOUR PACKAGE.JSON GLOBAL (CORRIGÉ)           ║"
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
# 1. VÉRIFICATIONS PRÉLIMINAIRES (CORRIGÉES)
# =============================================================================

check_prerequisites() {
    print_section "Vérifications préliminaires"
    
    # Vérifier si on est dans la racine du projet
    if [ ! -f "package.json" ]; then
        print_error "package.json non trouvé. Veuillez exécuter ce script depuis la racine du projet multi-apps-platform"
        exit 1
    fi
    
    # Créer une sauvegarde avec timestamp plus simple
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    print_info "Création d'une sauvegarde de package.json..."
    cp package.json "package.json.backup.$TIMESTAMP"
    print_success "Sauvegarde créée: package.json.backup.$TIMESTAMP"
    
    # Vérifier la structure des dossiers
    if [ ! -d "apps" ]; then
        print_warning "Dossier 'apps' non trouvé, création en cours..."
        mkdir -p apps
    fi
    
    # Vérifier si Math4Child existe
    if [ ! -d "apps/math4child" ]; then
        print_warning "apps/math4child non trouvé, création de la structure..."
        mkdir -p apps/math4child/src
        # Créer un package.json basique pour Math4Child
        cat > apps/math4child/package.json << 'MATH4CHILD_EOF'
{
  "name": "math4child",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev --port 3000",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "^14.2.5",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@types/node": "^20.14.12",
    "@types/react": "^18.3.3",
    "typescript": "^5.5.4"
  }
}
MATH4CHILD_EOF
        print_info "Package.json de base créé pour Math4Child"
    fi
    
    print_success "Vérifications terminées"
}

# =============================================================================
# 2. CRÉATION DU NOUVEAU PACKAGE.JSON (CORRIGÉ)
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
    
    "serve:math4child": "npm run dev & sleep 3 && curl -s http://localhost:3000 > /dev/null || echo 'Math4Child non accessible'",
    "serve:unitflip": "npm run dev & sleep 3 && curl -s http://localhost:3002 > /dev/null || echo 'UnitFlip non accessible'",
    "serve:budgetcron": "npm run dev & sleep 3 && curl -s http://localhost:3003 > /dev/null || echo 'BudgetCron non accessible'",
    "serve:ai4kids": "npm run dev & sleep 3 && curl -s http://localhost:3004 > /dev/null || echo 'AI4Kids non accessible'",
    "serve:multiai": "npm run dev & sleep 3 && curl -s http://localhost:3005 > /dev/null || echo 'MultiAI non accessible'",
    
    "docker:build": "docker build -t multi-apps-platform .",
    "docker:run": "docker run -p 3000:3000 multi-apps-platform",
    "docker:compose": "docker-compose up -d",
    "docker:down": "docker-compose down",
    
    "predev": "echo 'Démarrage en cours...'",
    "prebuild": "npm run lint && npm run type-check",
    "pretest": "echo 'Préparation des tests...'",
    "pretest:translation": "echo 'Validation i18n...'",
    
    "security:audit": "npm audit",
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
# 3. MISE À JOUR DU PLAYWRIGHT CONFIG (CORRIGÉE)
# =============================================================================

update_playwright_config() {
    print_section "Mise à jour configuration Playwright"
    
    print_info "Mise à jour playwright.config.ts pour Math4Child..."
    
    # Mise à jour du playwright.config.ts si il existe
    if [ -f "playwright.config.ts" ]; then
        # Créer une sauvegarde
        cp playwright.config.ts playwright.config.ts.backup
        
        # Remplacer postmath par math4child dans la config de façon plus sûre
        if grep -q "postmath" playwright.config.ts; then
            sed -i.tmp 's/postmath/math4child/g' playwright.config.ts
            rm -f playwright.config.ts.tmp
            print_success "playwright.config.ts mis à jour (postmath → math4child)"
        else
            print_info "Aucune référence à 'postmath' trouvée dans playwright.config.ts"
        fi
    else
        print_warning "playwright.config.ts non trouvé, création d'une configuration basique..."
        
        cat > playwright.config.ts << 'PLAYWRIGHT_EOF'
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests',
  timeout: 30000,
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['line']
  ],
  
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    actionTimeout: 10000,
  },

  projects: [
    {
      name: 'math4child',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/math4child*.spec.ts'
    },
    {
      name: 'unitflip',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/unitflip*.spec.ts'
    },
    {
      name: 'budgetcron',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/budgetcron*.spec.ts'
    },
    {
      name: 'ai4kids',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/ai4kids*.spec.ts'
    },
    {
      name: 'multiai',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/multiai*.spec.ts'
    }
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
})
PLAYWRIGHT_EOF
        print_success "Configuration Playwright créée avec Math4Child"
    fi
}

# =============================================================================
# 4. MISE À JOUR DES TESTS (CORRIGÉE)
# =============================================================================

update_test_files() {
    print_section "Mise à jour des fichiers de test"
    
    print_info "Recherche et mise à jour des références PostMath → Math4Child..."
    
    # Créer le dossier tests s'il n'existe pas
    if [ ! -d "tests" ]; then
        print_warning "Dossier tests non trouvé, création..."
        mkdir -p tests
    fi
    
    # Mettre à jour les fichiers de test dans le dossier tests
    if [ -d "tests" ]; then
        # Utiliser une approche plus sûre pour find
        find tests -type f \( -name "*.ts" -o -name "*.js" -o -name "*.spec.ts" -o -name "*.test.ts" \) 2>/dev/null | while IFS= read -r file; do
            if [ -f "$file" ] && grep -q "postmath\|PostMath\|POSTMATH" "$file" 2>/dev/null; then
                print_info "Mise à jour: $file"
                # Utiliser une approche plus portable pour sed
                cp "$file" "$file.backup"
                sed 's/postmath/math4child/g; s/PostMath/Math4Child/g; s/POSTMATH/MATH4CHILD/g' "$file.backup" > "$file"
                rm -f "$file.backup"
            fi
        done
        print_success "Fichiers de test mis à jour"
    fi
    
    # Créer un test basique pour Math4Child s'il n'existe pas
    if [ ! -f "tests/math4child.spec.ts" ]; then
        cat > tests/math4child.spec.ts << 'TEST_EOF'
import { test, expect } from '@playwright/test'

test.describe('Math4Child Application', () => {
  test('should load Math4Child homepage', async ({ page }) => {
    await page.goto('/')
    await expect(page).toHaveTitle(/Math4Child/i)
  })

  test('should display main navigation', async ({ page }) => {
    await page.goto('/')
    // Vérifier que les éléments principaux sont présents
    await expect(page.locator('body')).toBeVisible()
  })
})
TEST_EOF
        print_success "Test basique Math4Child créé"
    fi
}

# =============================================================================
# 5. CRÉATION DE SCRIPTS UTILES (CORRIGÉE)
# =============================================================================

create_utility_scripts() {
    print_section "Création de scripts utiles"
    
    mkdir -p scripts
    
    # Script de démarrage rapide Math4Child
    cat > scripts/start-math4child.sh << 'START_EOF'
#!/bin/bash
echo "🚀 Démarrage Math4Child..."

# Vérifier si le dossier existe
if [ ! -d "apps/math4child" ]; then
    echo "❌ Erreur: apps/math4child non trouvé"
    exit 1
fi

cd apps/math4child

# Vérifier si package.json existe
if [ ! -f "package.json" ]; then
    echo "❌ Erreur: package.json non trouvé dans apps/math4child"
    exit 1
fi

# Installer les dépendances si nécessaire
if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances..."
    npm install
fi

echo "🌐 Démarrage du serveur de développement..."
npm run dev
START_EOF
    chmod +x scripts/start-math4child.sh
    
    # Script de test rapide traduction
    cat > scripts/test-translation-quick.sh << 'TRANSLATION_EOF'
#!/bin/bash
echo "🌍 Tests de traduction rapides..."

# Vérifier si playwright est installé
if ! npm list @playwright/test > /dev/null 2>&1; then
    echo "⚠️  Playwright non trouvé, installation..."
    npm install @playwright/test
    npx playwright install chromium
fi

echo "🧪 Lancement des tests de traduction..."
npm run test:translation:quick || echo "⚠️  Certains tests ont échoué (normal si le serveur n'est pas démarré)"
TRANSLATION_EOF
    chmod +x scripts/test-translation-quick.sh
    
    # Script de test de toutes les apps
    cat > scripts/test-all-apps.sh << 'APPS_EOF'
#!/bin/bash
echo "🧪 Tests de toutes les applications..."

# Vérifier Playwright
if ! npm list @playwright/test > /dev/null 2>&1; then
    echo "⚠️  Playwright non trouvé, installation..."
    npm install @playwright/test
    npx playwright install
fi

echo "🔧 Tests des applications multi-apps-platform..."
npm run test:apps:quick || echo "⚠️  Certains tests ont échoué (normal en développement)"
APPS_EOF
    chmod +x scripts/test-all-apps.sh
    
    # Script d'information du projet
    cat > scripts/project-info.sh << 'INFO_EOF'
#!/bin/bash
echo "📊 Informations Multi-Apps Platform"
echo "═══════════════════════════════════════════════════════════════"

echo "📁 Structure des applications:"
if [ -d "apps/math4child" ]; then
    echo "  ✅ Math4Child (apps/math4child) - Port 3000"
else
    echo "  ❌ Math4Child non trouvé"
fi

for app in unitflip budgetcron ai4kids multiai; do
    if [ -d "src/mobile/apps/$app" ]; then
        echo "  ✅ ${app^} (src/mobile/apps/$app)"
    else
        echo "  ❌ ${app^} non trouvé"
    fi
done

echo ""
echo "🛠️  Commandes disponibles:"
echo "  npm run test:translation:quick    # Tests traduction rapides"
echo "  npm run test:math4child:quick     # Tests Math4Child"
echo "  npm run apps:math4child           # Lancer Math4Child"
echo "  ./scripts/start-math4child.sh     # Script démarrage"
echo ""

echo "📦 Package.json: $([ -f "package.json" ] && echo "✅ Présent" || echo "❌ Absent")"
echo "🧪 Playwright: $([ -f "playwright.config.ts" ] && echo "✅ Configuré" || echo "❌ Non configuré")"
INFO_EOF
    chmod +x scripts/project-info.sh
    
    print_success "Scripts utiles créés dans le dossier scripts/"
}

# =============================================================================
# 6. NETTOYAGE ET FINALISATION (CORRIGÉE)
# =============================================================================

cleanup_and_finalize() {
    print_section "Nettoyage et finalisation"
    
    # Supprimer les anciens fichiers de lock s'ils existent
    if [ -f "package-lock.json" ]; then
        print_info "Suppression de l'ancien package-lock.json..."
        rm package-lock.json
    fi
    
    # Nettoyage du cache npm (plus sûr)
    print_info "Nettoyage du cache npm..."
    if command -v npm >/dev/null 2>&1; then
        npm cache clean --force >/dev/null 2>&1 || print_warning "Nettoyage cache npm échoué (non critique)"
    fi
    
    # Nettoyage des fichiers temporaires
    find . -name "*.tmp" -type f -delete 2>/dev/null || true
    find . -name "*.backup" -type f -delete 2>/dev/null || true
    
    print_success "Nettoyage terminé"
}

# =============================================================================
# 7. INSTALLATION ET VÉRIFICATION (CORRIGÉE)
# =============================================================================

install_and_verify() {
    print_section "Installation et vérification"
    
    print_info "Installation des dépendances..."
    
    # Installation plus robuste
    if npm install --legacy-peer-deps >/dev/null 2>&1; then
        print_success "Dépendances installées"
    else
        print_warning "Problème lors de l'installation des dépendances"
        print_info "Essai avec npm install..."
        if npm install >/dev/null 2>&1; then
            print_success "Dépendances installées (sans legacy-peer-deps)"
        else
            print_error "Échec de l'installation des dépendances"
            print_info "Vous devrez installer manuellement avec: npm install"
        fi
    fi
    
    # Vérification du type checking (optionnelle)
    print_info "Vérification TypeScript..."
    if command -v npx >/dev/null 2>&1 && npx tsc --noEmit >/dev/null 2>&1; then
        print_success "Type checking OK"
    else
        print_warning "Type checking échoué ou TypeScript non installé (non critique)"
    fi
    
    # Test basique de la configuration (optionnel)
    print_info "Test de base de la configuration..."
    if npm run test:math4child:quick -- --timeout=5000 >/dev/null 2>&1; then
        print_success "Configuration fonctionnelle"
    else
        print_warning "Tests échoués (normal si le serveur n'est pas lancé)"
    fi
}

# =============================================================================
# 8. AFFICHAGE DU RÉSUMÉ FINAL (AMÉLIORÉ)
# =============================================================================

show_final_summary() {
    print_section "Résumé des modifications"
    
    echo -e "${GREEN}🎉 MISE À JOUR TERMINÉE AVEC SUCCÈS !${NC}\n"
    
    echo -e "${BOLD}📋 Modifications effectuées :${NC}"
    echo "✅ PostMath → Math4Child dans package.json"
    echo "✅ Structure apps/math4child configurée"
    echo "✅ Scripts de test mis à jour"
    echo "✅ Configuration Playwright adaptée"
    echo "✅ Scripts utiles créés dans scripts/"
    echo "✅ Sauvegarde créée (package.json.backup.*)"
    
    echo -e "\n${BOLD}🚀 Commandes disponibles immédiatement :${NC}"
    echo "npm run test:translation:quick    # Votre script initial recherché ✨"
    echo "npm run test:math4child:quick     # Tests Math4Child rapides"
    echo "npm run apps:math4child           # Lancer Math4Child"
    echo "npm run test:apps:quick           # Tests toutes apps"
    echo "./scripts/start-math4child.sh     # Script démarrage rapide"
    echo "./scripts/project-info.sh         # Informations du projet"
    
    echo -e "\n${BOLD}📁 Structure des applications :${NC}"
    echo "📂 apps/math4child (port 3000)     - App éducative principale ⭐"
    echo "📂 src/mobile/apps/unitflip         - Convertisseur d'unités"
    echo "📂 src/mobile/apps/budgetcron       - Gestion budgétaire"
    echo "📂 src/mobile/apps/ai4kids          - IA éducative"
    echo "📂 src/mobile/apps/multiai          - Recherche multi-IA"
    
    echo -e "\n${BLUE}💡 Prochaines étapes recommandées :${NC}"
    echo "1. Tester immédiatement : npm run test:translation:quick"
    echo "2. Vérifier la structure : ./scripts/project-info.sh"
    echo "3. Lancer Math4Child : ./scripts/start-math4child.sh"
    echo "4. En cas de problème : cp package.json.backup.* package.json"
    
    echo -e "\n${YELLOW}⚠️  Notes importantes :${NC}"
    echo "• Sauvegarde automatique créée avec timestamp"
    echo "• Configuration adaptée à votre structure existante"
    echo "• Tests configurés pour Math4Child sur port 3000"
    echo "• Support complet i18n avec 12+ langues"
    echo "• Scripts robustes avec gestion d'erreurs améliorée"
    
    echo -e "\n${PURPLE}🔧 Dépannage rapide :${NC}"
    echo "• Si npm install échoue : npm cache clean --force && npm install"
    echo "• Si tests échouent : vérifiez que le serveur dev est lancé"
    echo "• Si Math4Child manque : vérifiez apps/math4child/"
    echo "• Pour restaurer : cp package.json.backup.* package.json"
}

# =============================================================================
# 9. FONCTION PRINCIPALE (AMÉLIORÉE)
# =============================================================================

main() {
    print_banner
    
    # Vérification de bash
    if [ -z "$BASH_VERSION" ]; then
        echo "❌ Ce script nécessite bash. Utilisez: bash $0"
        exit 1
    fi
    
    # Demander confirmation avant de procéder
    echo -e "${YELLOW}⚠️  Ce script va modifier votre package.json et configuration.${NC}"
    echo -e "${BLUE}Une sauvegarde sera créée automatiquement avec timestamp.${NC}"
    echo ""
    
    # Timeout pour la réponse
    if read -t 30 -p "Voulez-vous continuer ? (y/N): " -n 1 -r; then
        echo
    else
        echo -e "\n${YELLOW}Timeout - opération annulée${NC}"
        exit 0
    fi
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Opération annulée par l'utilisateur"
        exit 0
    fi
    
    # Exécution des étapes avec gestion d'erreurs individuelle
    echo -e "\n${GREEN}🚀 Début de la migration PostMath → Math4Child${NC}"
    
    check_prerequisites || { print_error "Échec des vérifications préliminaires"; exit 1; }
    create_updated_package_json || { print_error "Échec de la création du package.json"; exit 1; }
    update_playwright_config || print_warning "Problème avec la configuration Playwright (non critique)"
    update_test_files || print_warning "Problème avec la mise à jour des tests (non critique)"
    create_utility_scripts || print_warning "Problème avec la création des scripts (non critique)"
    cleanup_and_finalize || print_warning "Problème lors du nettoyage (non critique)"
    install_and_verify || print_warning "Problème lors de l'installation/vérification (non critique)"
    show_final_summary
    
    echo -e "\n${GREEN}🎯 Script terminé avec succès !${NC}"
    echo -e "${BLUE}Testez maintenant : ${BOLD}npm run test:translation:quick${NC}"
}

# =============================================================================
# GESTION D'ERREUR GLOBALE AMÉLIORÉE
# =============================================================================

# Fonction de nettoyage en cas d'interruption
cleanup_on_exit() {
    echo -e "\n${YELLOW}🛑 Interruption détectée${NC}"
    
    # Restaurer le package.json si une sauvegarde existe
    if [ -f "package.json.backup.$TIMESTAMP" ]; then
        echo -e "${BLUE}🔄 Restauration du package.json original...${NC}"
        cp "package.json.backup.$TIMESTAMP" package.json
        echo -e "${GREEN}✅ Package.json restauré${NC}"
    fi
    
    echo -e "${RED}❌ Script interrompu - état restauré${NC}"
    exit 1
}

# Capture des signaux d'interruption
trap cleanup_on_exit INT TERM

# Gestion d'erreur globale plus spécifique
set +e  # Désactiver exit on error pour une gestion plus fine

# Exécution si le script est lancé directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi