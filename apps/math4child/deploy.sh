#!/bin/bash

# Script de déploiement Math4Child
# Usage: ./deploy.sh [web|android|ios|all]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

TARGET=${1:-"web"}

log_info "🚀 Déploiement Math4Child - Target: $TARGET"

# Nettoyage
rm -rf .next out android/app/build ios/build 2>/dev/null || true

# Installation
npm ci --silent

# Tests rapides
npm run type-check
npm run lint

case $TARGET in
    "web")
        npm run build:web
        log_success "✅ Build web terminé"
        ;;
    "android")
        npm run build:capacitor
        npx cap sync android
        log_success "✅ Build Android terminé"
        ;;
    "ios")
        if [[ "$OSTYPE" != "darwin"* ]]; then
            log_error "iOS build nécessite macOS"
            exit 1
        fi
        npm run build:capacitor
        npx cap sync ios
        npx cap open ios
        log_success "✅ Build iOS préparé"
        ;;
    "all")
        npm run build:web
        npm run build:capacitor
        npx cap sync android
        if [[ "$OSTYPE" == "darwin"* ]]; then
            npx cap sync ios
        fi
        log_success "✅ Build complet terminé"
        ;;
    *)
        log_error "Target invalide: $TARGET"
        exit 1
        ;;
esac

log_success "🎉 Déploiement terminé!"
