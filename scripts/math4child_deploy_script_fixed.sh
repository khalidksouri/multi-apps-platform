#!/bin/bash

#===============================================================================
# MATH4CHILD - SCRIPT DE DÉPLOIEMENT COMPLET
# Version: 4.0.0
# Description: Script automatisé pour le setup, développement et déploiement
# Auteur: Math4Child Development Team  
# Date: $(date +%Y-%m-%d)
# Domaine: www.math4child.com
# Tech Stack: Next.js + TypeScript + Playwright + PostgreSQL + Docker
#===============================================================================

set -euo pipefail  # Exit on error, undefined vars, pipe failures

#===============================================================================
# CONFIGURATION GLOBALE
#===============================================================================

# Couleurs pour l'output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Configuration du projet
readonly PROJECT_NAME="math4child"
readonly PROJECT_VERSION="4.0.0"
readonly DOMAIN="www.math4child.com"
readonly REPO_URL="https://github.com/your-org/math4child.git"
readonly NODE_VERSION="20.10.0"
readonly DOCKER_IMAGE="math4child/app"

# Répertoires
readonly PROJECT_ROOT="$(pwd)"
readonly SCRIPTS_DIR="${PROJECT_ROOT}/scripts"
readonly LOGS_DIR="${PROJECT_ROOT}/logs"
readonly BACKUP_DIR="${PROJECT_ROOT}/backups"
readonly BUILD_DIR="${PROJECT_ROOT}/build"
readonly DIST_DIR="${PROJECT_ROOT}/dist"
readonly APPS_DIR="${PROJECT_ROOT}/apps"
readonly TESTS_DIR="${PROJECT_ROOT}/tests"

# Environnements
readonly ENVIRONMENTS=("development" "staging" "production")
readonly DEFAULT_ENV="development"

# Bases de données
readonly DB_NAME="math4child_db"
readonly DB_USER="math4child_user"
readonly TEST_DB_NAME="math4child_test_db"

# Services externes
readonly STRIPE_API_URL="https://api.stripe.com"
readonly ANALYTICS_API="https://analytics.math4child.com"

#===============================================================================
# FONCTIONS UTILITAIRES
#===============================================================================

# Affichage de bannière
show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    ███╗   ███╗ █████╗ ████████╗██╗  ██╗██╗  ██╗ ██████╗██╗  ██╗██╗██╗     ██╗║
║    ████╗ ████║██╔══██╗╚══██╔══╝██║  ██║██║  ██║██╔════╝██║  ██║██║██║     ██║║
║    ██╔████╔██║███████║   ██║   ███████║███████║██║     ███████║██║██║     ██║║
║    ██║╚██╔╝██║██╔══██║   ██║   ██╔══██║╚════██║██║     ██╔══██║██║██║     ██║║
║    ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║     ██║╚██████╗██║  ██║██║███████╗██║║
║    ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚══════╝╚═╝║
║                                                                              ║
║                    🚀 SCRIPT DE DÉPLOIEMENT COMPLET v4.0.0                  ║
║                    📚 Application éducative révolutionnaire                 ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Logging avec couleurs et timestamps (renommé pour éviter conflit avec log système)
log_message() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "INFO")  echo -e "${GREEN}[${timestamp}] ℹ️  INFO: ${message}${NC}" ;;
        "WARN")  echo -e "${YELLOW}[${timestamp}] ⚠️  WARN: ${message}${NC}" ;;
        "ERROR") echo -e "${RED}[${timestamp}] ❌ ERROR: ${message}${NC}" ;;
        "DEBUG") echo -e "${BLUE}[${timestamp}] 🔍 DEBUG: ${message}${NC}" ;;
        "SUCCESS") echo -e "${GREEN}[${timestamp}] ✅ SUCCESS: ${message}${NC}" ;;
    esac
    
    # Log vers fichier
    mkdir -p "${LOGS_DIR}"
    echo "[${timestamp}] ${level}: ${message}" >> "${LOGS_DIR}/math4child.log"
}

# Vérification des prérequis
check_prerequisites() {
    log_message "INFO" "🔍 Vérification des prérequis système..."
    
    local missing_deps=()
    
    # Vérification Node.js
    if ! command -v node &> /dev/null; then
        missing_deps+=("node")
    else
        local node_version=$(node --version | sed 's/v//')
        if [[ $(echo "$node_version $NODE_VERSION" | tr " " "\n" | sort -V | head -n1) != "$NODE_VERSION" ]]; then
            log_message "WARN" "Node.js version $node_version détectée, $NODE_VERSION recommandée"
        fi
    fi
    
    # Vérification des outils essentiels
    local tools=("npm" "git" "docker" "docker-compose" "curl" "jq" "zip" "unzip")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_deps+=("$tool")
        fi
    done
    
    # Vérification PostgreSQL (optionnel pour Docker)
    if ! command -v psql &> /dev/null; then
        log_message "WARN" "PostgreSQL non détecté - utilisation de Docker recommandée"
    fi
    
    # Vérification TypeScript
    if ! npm list -g typescript &> /dev/null 2>&1; then
        log_message "WARN" "TypeScript global non installé - installation recommandée"
    fi
    
    # Vérification Playwright
    if ! npm list -g @playwright/test &> /dev/null 2>&1; then
        log_message "WARN" "Playwright non installé globalement"
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_message "ERROR" "Dépendances manquantes: ${missing_deps[*]}"
        log_message "INFO" "Installez les dépendances manquantes et relancez le script"
        exit 1
    fi
    
    log_message "SUCCESS" "✅ Tous les prérequis sont satisfaits"
}

# Création de la structure de répertoires
create_directory_structure() {
    log_message "INFO" "📁 Création de la structure de répertoires Math4Child..."
    
    local dirs=(
        "apps/math4child/src"
        "apps/math4child/src/app"
        "apps/math4child/src/components"
        "apps/math4child/src/hooks"
        "apps/math4child/src/utils"
        "apps/math4child/src/stores"
        "apps/math4child/src/types"
        "apps/math4child/src/styles"
        "apps/math4child/public"
        "apps/math4child/public/icons"
        "apps/math4child/public/sounds"
        "apps/math4child/public/images"
        "tests"
        "tests/specs"
        "tests/utils"
        "tests/fixtures"
        "scripts"
        "scripts/deployment"
        "scripts/database"
        "scripts/monitoring"
        "scripts/backup"
        "docs"
        "docs/api"
        "docs/deployment"
        "docs/testing"
        "logs"
        "backups"
        "backups/database"
        "backups/files"
        "build"
        "dist"
        "infrastructure"
        "infrastructure/docker"
        "infrastructure/k8s"
        "infrastructure/terraform"
        "infrastructure/nginx"
        "monitoring"
        "monitoring/grafana"
        "monitoring/prometheus"
        "database"
        "database/migrations"
        "database/seeds"
        "assets"
        "assets/images"
        "assets/sounds"
        "assets/videos"
        "locales"
        "certificates"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        log_message "DEBUG" "Créé: $dir"
    done
    
    log_message "SUCCESS" "✅ Structure de répertoires créée"
}

# Initialisation du projet
init_project() {
    log_message "INFO" "🚀 Initialisation du projet Math4Child..."
    
    # Package.json racine (monorepo)
    if [[ ! -f "package.json" ]]; then
        log_message "INFO" "Création du package.json racine..."
        cat > package.json << 'EOF'
{
  "name": "math4child-monorepo",
  "version": "4.0.0",
  "description": "Math4Child - Application éducative révolutionnaire pour l'apprentissage des mathématiques",
  "private": true,
  "workspaces": [
    "apps/*",
    "tests"
  ],
  "type": "module",
  "scripts": {
    "dev": "npm run dev --workspace=apps/math4child",
    "dev:all": "concurrently \"npm run dev --workspace=apps/math4child\" \"npm run test:ui --workspace=tests\"",
    "build": "npm run build --workspace=apps/math4child",
    "build:all": "npm run build --workspace=apps/math4child",
    "start": "npm run start --workspace=apps/math4child",
    "test": "npm run test --workspace=tests",
    "test:headed": "npm run test:headed --workspace=tests",
    "test:ui": "npm run test:ui --workspace=tests",
    "test:mobile": "npm run test:mobile --workspace=tests",
    "test:i18n": "npm run test:i18n --workspace=tests",
    "lint": "npm run lint --workspace=apps/math4child",
    "format": "prettier --write \"**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "typecheck": "npm run typecheck --workspace=apps/math4child",
    "clean": "npm run clean --workspace=apps/math4child && npm run clean --workspace=tests",
    "install:all": "npm install && npm install --workspace=apps/math4child && npm install --workspace=tests"
  },
  "devDependencies": {
    "prettier": "^3.1.0",
    "concurrently": "^8.2.0",
    "rimraf": "^5.0.0"
  },
  "engines": {
    "node": ">=20.0.0",
    "npm": ">=10.0.0"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/your-org/math4child.git"
  },
  "keywords": [
    "education",
    "mathematics",
    "children",
    "learning",
    "multilingual",
    "adaptive",
    "gamification",
    "typescript",
    "nextjs",
    "playwright"
  ],
  "author": "Math4Child Team",
  "license": "MIT"
}
EOF
        
        log_message "SUCCESS" "✅ Package.json racine créé"
    fi
    
    # Initialisation Git si nécessaire
    if [[ ! -d ".git" ]]; then
        git init
        log_message "SUCCESS" "✅ Repository Git initialisé"
    fi
}

# Configuration de l'application Next.js avec TypeScript
setup_nextjs_app() {
    log_message "INFO" "⚛️ Configuration de l'application Next.js Math4Child avec TypeScript..."
    
    cd "${APPS_DIR}/math4child"
    
    # Package.json pour l'app Math4Child
    cat > package.json << 'EOF'
{
  "name": "math4child-app",
  "version": "4.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "typecheck": "tsc --noEmit",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "analyze": "ANALYZE=true next build",
    "clean": "rm -rf .next dist coverage node_modules"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "typescript": "^5.3.0",
    "@types/node": "^20.10.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "tailwindcss": "^3.4.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "lucide-react": "^0.300.0",
    "framer-motion": "^10.16.0",
    "zustand": "^4.4.0",
    "@tanstack/react-query": "^5.0.0",
    "axios": "^1.6.0",
    "zod": "^3.22.0",
    "react-hook-form": "^7.48.0",
    "@hookform/resolvers": "^3.3.0",
    "recharts": "^2.8.0",
    "react-confetti": "^6.1.0",
    "howler": "^2.2.0",
    "@types/howler": "^2.2.0",
    "@stripe/stripe-js": "^2.1.0",
    "i18next": "^23.7.0",
    "react-i18next": "^13.5.0",
    "i18next-browser-languagedetector": "^7.2.0",
    "jose": "^5.1.0",
    "bcryptjs": "^2.4.0",
    "@types/bcryptjs": "^2.4.0",
    "prisma": "^5.7.0",
    "@prisma/client": "^5.7.0",
    "clsx": "^2.0.0",
    "class-variance-authority": "^0.7.0",
    "tailwind-merge": "^2.0.0"
  },
  "devDependencies": {
    "eslint": "^8.55.0",
    "eslint-config-next": "^14.0.0",
    "@typescript-eslint/eslint-plugin": "^6.13.0",
    "@typescript-eslint/parser": "^6.13.0",
    "@testing-library/react": "^14.1.0",
    "@testing-library/jest-dom": "^6.1.0",
    "jest": "^29.7.0",
    "jest-environment-jsdom": "^29.7.0",
    "@next/bundle-analyzer": "^14.0.0",
    "@types/jest": "^29.5.0"
  }
}
EOF
    
    # Configuration Next.js optimisée
    cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  experimental: {
    typedRoutes: true,
  },
  typescript: {
    tsconfigPath: './tsconfig.json',
  },
  images: {
    domains: ['cdn.math4child.com', 'assets.math4child.com'],
    formats: ['image/webp', 'image/avif'],
    minimumCacheTTL: 60,
  },
  i18n: {
    locales: ['fr', 'en', 'es', 'de', 'ar', 'zh', 'ja', 'ko', 'hi', 'pt', 'ru', 'it', 'nl', 'pl'],
    defaultLocale: 'fr',
    localeDetection: true,
  },
  async rewrites() {
    return [
      {
        source: '/api/analytics/:path*',
        destination: 'https://analytics.math4child.com/:path*',
      },
    ];
  },
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
          {
            key: 'Strict-Transport-Security',
            value: 'max-age=31536000; includeSubDomains',
          },
        ],
      },
    ];
  },
  webpack: (config, { isServer, dev }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
      };
    }
    
    // Optimisations pour la production
    if (!dev) {
      config.optimization.splitChunks = {
        chunks: 'all',
        cacheGroups: {
          default: false,
          vendors: false,
          vendor: {
            chunks: 'all',
            test: /node_modules/,
            name: 'vendor',
          },
          common: {
            minChunks: 2,
            chunks: 'all',
            name: 'common',
          },
        },
      };
    }
    
    return config;
  },
  output: 'standalone',
  poweredByHeader: false,
  compress: true,
};

const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
});

module.exports = withBundleAnalyzer(nextConfig);
EOF
    
    # Configuration TypeScript stricte
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "ES2022"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/hooks/*": ["./src/hooks/*"],
      "@/utils/*": ["./src/utils/*"],
      "@/stores/*": ["./src/stores/*"],
      "@/types/*": ["./src/types/*"],
      "@/styles/*": ["./src/styles/*"]
    },
    "forceConsistentCasingInFileNames": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitOverride": true,
    "exactOptionalPropertyTypes": true
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF
    
    cd ../..
    log_message "SUCCESS" "✅ Application Next.js configurée avec TypeScript"
}

# Menu principal et aide
show_help() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                    📚 MATH4CHILD - AIDE DU SCRIPT DE DÉPLOIEMENT            ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo "Usage: $0 [COMMANDE] [OPTIONS]"
    echo ""
    echo "🚀 COMMANDES PRINCIPALES:"
    echo "  setup                    Configuration initiale complète du projet"
    echo "  init                     Initialisation basique du projet"
    echo "  start                    Démarrage en mode développement"
    echo ""
    echo "🔧 COMMANDES DE DÉVELOPPEMENT:"
    echo "  deps                     Installation des dépendances"
    echo "  build                    Construction de l'application"
    echo "  test                     Exécution de tous les tests"
    echo "  clean                    Nettoyage des fichiers temporaires"
    echo ""
    echo "ℹ️  INFORMATIONS:"
    echo "  help                     Afficher cette aide"
    echo "  version                  Version du script"
    echo "  info                     Informations système"
    echo ""
    echo "💡 EXEMPLES D'UTILISATION:"
    echo "  $0 setup                 # Configuration initiale complète"
    echo "  $0 start                 # Démarrer en mode développement"
    echo "  $0 build                 # Construire l'application"
    echo ""
    echo "📖 Documentation complète: https://docs.math4child.com/deployment"
}

# Informations système
show_info() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                           ℹ️  INFORMATIONS SYSTÈME                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo "📦 Projet: $PROJECT_NAME v$PROJECT_VERSION"
    echo "🌐 Domaine: $DOMAIN"
    echo "📅 Date: $(date)"
    echo "👤 Utilisateur: $(whoami)"
    echo "💻 Système: $(uname -s) $(uname -r)"
    echo "🏠 Répertoire: $PROJECT_ROOT"
    echo ""
    
    if command -v node &> /dev/null; then
        echo "🟢 Node.js: $(node --version)"
    else
        echo "🔴 Node.js: Non installé"
    fi
    
    if command -v npm &> /dev/null; then
        echo "🟢 npm: $(npm --version)"
    else
        echo "🔴 npm: Non installé"
    fi
    
    if command -v docker &> /dev/null; then
        echo "🟢 Docker: $(docker --version | cut -d' ' -f3 | tr -d ',')"
    else
        echo "🔴 Docker: Non installé"
    fi
    
    if command -v git &> /dev/null; then
        echo "🟢 Git: $(git --version | cut -d' ' -f3)"
        if [ -d ".git" ]; then
            echo "🌿 Branche: $(git branch --show-current)"
            echo "📝 Commit: $(git rev-parse --short HEAD)"
        fi
    else
        echo "🔴 Git: Non installé"
    fi
    echo ""
}

# Version du script
show_version() {
    echo "Math4Child Deployment Script v$PROJECT_VERSION"
    echo "Build date: $(date)"
    echo "Author: Math4Child Development Team"
}

# Installation des dépendances
install_dependencies() {
    log_message "INFO" "📦 Installation des dépendances..."
    
    # Installation des dépendances racine
    log_message "INFO" "Installation des dépendances racine..."
    npm install
    
    # Installation des dépendances de l'application
    if [ -d "apps/math4child" ]; then
        log_message "INFO" "Installation des dépendances de l'application..."
        cd apps/math4child
        npm install
        cd ../..
    fi
    
    # Installation des dépendances des tests
    if [ -d "tests" ]; then
        log_message "INFO" "Installation des dépendances des tests..."
        cd tests
        npm install
        cd ..
    fi
    
    log_message "SUCCESS" "✅ Toutes les dépendances installées"
}

# Construction de l'application
build_application() {
    log_message "INFO" "🔨 Construction de l'application..."
    
    if [ -d "apps/math4child" ]; then
        cd apps/math4child
        npm run build
        cd ../..
        log_message "SUCCESS" "✅ Application construite avec succès"
    else
        log_message "ERROR" "Répertoire de l'application non trouvé"
        exit 1
    fi
}

# Démarrage en mode développement
start_development() {
    log_message "INFO" "🚀 Démarrage en mode développement..."
    
    if [ -d "apps/math4child" ]; then
        cd apps/math4child
        log_message "INFO" "🌐 Application accessible sur: http://localhost:3000"
        npm run dev
        cd ../..
    else
        log_message "ERROR" "Répertoire de l'application non trouvé"
        exit 1
    fi
}

# Nettoyage
clean_project() {
    log_message "INFO" "🧹 Nettoyage du projet..."
    
    # Nettoyage des modules node
    find . -name "node_modules" -type d -prune -exec rm -rf {} +
    
    # Nettoyage des builds
    find . -name ".next" -type d -prune -exec rm -rf {} +
    find . -name "dist" -type d -prune -exec rm -rf {} +
    find . -name "build" -type d -prune -exec rm -rf {} +
    
    # Nettoyage des logs
    rm -rf logs/*.log
    
    log_message "SUCCESS" "✅ Nettoyage terminé"
}

#===============================================================================
# POINT D'ENTRÉE PRINCIPAL
#===============================================================================

main() {
    # Vérifier les arguments
    if [[ $# -eq 0 ]]; then
        show_banner
        show_help
        exit 0
    fi
    
    local command="$1"
    shift || true
    
    # Router les commandes
    case "$command" in
        # Commandes principales
        "setup")
            show_banner
            check_prerequisites
            create_directory_structure
            init_project
            setup_nextjs_app
            install_dependencies
            log_message "SUCCESS" "🎉 Setup complet de Math4Child terminé!"
            log_message "INFO" "📖 Exécutez '$0 start' pour démarrer en développement"
            ;;
        "init")
            check_prerequisites
            create_directory_structure
            init_project
            ;;
        "deps"|"install")
            install_dependencies
            ;;
        "build")
            build_application
            ;;
        "start"|"dev")
            start_development
            ;;
        "clean")
            clean_project
            ;;
            
        # Informations
        "help"|"-h"|"--help")
            show_help
            ;;
        "version"|"-v"|"--version")
            show_version
            ;;
        "info")
            show_info
            ;;
            
        # Commande inconnue
        *)
            log_message "ERROR" "Commande inconnue: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Gestion des signaux
trap 'log_message "WARN" "Script interrompu par l'\''utilisateur"; exit 130' INT
trap 'log_message "ERROR" "Script terminé de manière inattendue"; exit 1' ERR

# Exécution du script principal
main "$@"