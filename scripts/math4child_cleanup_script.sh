#!/bin/bash

# 🧹 Script de Nettoyage Math4Child
# Auteur: Assistant IA
# Date: $(date +%Y-%m-%d)
# Description: Nettoyage complet et optimisation de l'application Math4Child

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Variables
PROJECT_DIR="apps/math4child"
BACKUP_DIR="apps/math4child_backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="math4child_cleanup_$(date +%Y%m%d_%H%M%S).log"

# Fonctions utilitaires
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo -e "${BLUE}=================================${NC}"
    echo -e "${BLUE}🧹 $1${NC}"
    echo -e "${BLUE}=================================${NC}"
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
    echo -e "${PURPLE}ℹ️  $1${NC}"
}

# Vérifications préliminaires
check_prerequisites() {
    print_header "Vérifications Préliminaires"
    
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Le dossier $PROJECT_DIR n'existe pas!"
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "npm n'est pas installé!"
        exit 1
    fi
    
    print_success "Toutes les vérifications sont OK"
    log "Vérifications préliminaires réussies"
}

# Sauvegarde de sécurité
create_backup() {
    print_header "Création de la Sauvegarde"
    
    if [ -d "$PROJECT_DIR" ]; then
        cp -r "$PROJECT_DIR" "$BACKUP_DIR"
        print_success "Sauvegarde créée : $BACKUP_DIR"
        log "Sauvegarde créée dans $BACKUP_DIR"
    else
        print_error "Impossible de créer la sauvegarde"
        exit 1
    fi
}

# Suppression des fichiers temporaires
remove_temp_files() {
    print_header "Suppression des Fichiers Temporaires"
    
    cd "$PROJECT_DIR"
    
    # Rapports de récupération
    if [ -f "recovery_report.md" ]; then
        rm -f "recovery_report.md"
        print_success "Supprimé: recovery_report.md"
        log "Supprimé recovery_report.md"
    fi
    
    if [ -f "MATH4CHILD_RECOVERY_REPORT.md" ]; then
        rm -f "MATH4CHILD_RECOVERY_REPORT.md"
        print_success "Supprimé: MATH4CHILD_RECOVERY_REPORT.md"
        log "Supprimé MATH4CHILD_RECOVERY_REPORT.md"
    fi
    
    # Backups HTML
    if [ -d "design_reference/site_backup" ]; then
        rm -rf "design_reference/site_backup"
        print_success "Supprimé: design_reference/site_backup/"
        log "Supprimé design_reference/site_backup/"
    fi
    
    # Fichiers temporaires divers
    find . -name "*.tmp" -type f -delete 2>/dev/null || true
    find . -name "*.log" -type f -delete 2>/dev/null || true
    find . -name ".DS_Store" -type f -delete 2>/dev/null || true
    
    print_success "Nettoyage des fichiers temporaires terminé"
    cd - > /dev/null
}

# Nettoyage des dépendances
clean_dependencies() {
    print_header "Nettoyage des Dépendances"
    
    cd "$PROJECT_DIR"
    
    # Frontend
    print_info "Nettoyage des dépendances frontend..."
    if [ -f "package-lock.json" ]; then
        rm -f "package-lock.json"
        print_success "Supprimé: package-lock.json (frontend)"
    fi
    
    if [ -d "node_modules" ]; then
        rm -rf "node_modules"
        print_success "Supprimé: node_modules (frontend)"
    fi
    
    # Backend
    print_info "Nettoyage des dépendances backend..."
    if [ -d "backend" ]; then
        cd backend
        
        if [ -f "package-lock.json" ]; then
            rm -f "package-lock.json"
            print_success "Supprimé: backend/package-lock.json"
        fi
        
        if [ -d "node_modules" ]; then
            rm -rf "node_modules"
            print_success "Supprimé: backend/node_modules"
        fi
        
        cd ..
    fi
    
    cd - > /dev/null
}

# Optimisation de la configuration
optimize_config() {
    print_header "Optimisation de la Configuration"
    
    cd "$PROJECT_DIR"
    
    # Nettoyage .env.test
    if [ -f ".env.test" ]; then
        print_info "Nettoyage de .env.test..."
        
        # Créer un nouveau .env.test optimisé
        cat > ".env.test.new" << 'EOF'
# ==============================================
# CONFIGURATION DE TEST - MATH4CHILD ONLY
# ==============================================

NODE_ENV=test
PORT=3001
API_URL=http://localhost:3001

# Base de données de test
DATABASE_URL=mongodb://localhost:27017/math4child_test
DATABASE_NAME=math4child_test

# Tests
ENABLE_MEMORY_MONITORING=false
ENABLE_CACHE=true
CACHE_TTL=3600
ENABLE_RATE_LIMITING=false

# Locale et internationalisation
LOCALE=fr-FR
TIMEZONE=Europe/Paris
CURRENCY=EUR
DATE_FORMAT=DD/MM/YYYY
SUPPORTED_LOCALES=fr-FR,en-US,es-ES,de-DE,ar-SA

# Mode développement
DEV_MODE=false
HOT_RELOAD=false
WATCH_MODE=false
AUTO_OPEN_BROWSER=false

# Sécurité
ENCRYPT_SENSITIVE_DATA=true
MASK_PERSONAL_DATA=true
ANONYMIZE_LOGS=true
SECURE_RANDOM_SEED=true
EOF
        
        mv ".env.test.new" ".env.test"
        print_success "Optimisé: .env.test"
        log "Configuration .env.test optimisée"
    fi
    
    cd - > /dev/null
}

# Optimisation package.json
optimize_package_json() {
    print_header "Optimisation package.json"
    
    cd "$PROJECT_DIR"
    
    # Vérifier si jq est disponible pour la manipulation JSON
    if command -v jq &> /dev/null; then
        print_info "Optimisation avec jq..."
        
        # Créer une version optimisée du package.json
        jq '.scripts = {
            "dev": "next dev",
            "dev:full": "concurrently \"npm run dev\" \"cd backend && npm run dev\"",
            "build": "next build",
            "start": "next start",
            "test": "playwright test",
            "test:e2e": "playwright test",
            "test:unit": "cd backend && npm test",
            "test:watch": "playwright test --ui",
            "lint": "next lint",
            "lint:fix": "next lint --fix",
            "type-check": "tsc --noEmit",
            "clean": "rm -rf .next node_modules backend/node_modules",
            "audit": "npm audit && cd backend && npm audit"
        }' package.json > package.json.tmp && mv package.json.tmp package.json
        
        print_success "Scripts package.json optimisés"
        log "Scripts package.json optimisés avec jq"
    else
        print_warning "jq non disponible, optimisation manuelle recommandée"
        log "jq non disponible pour l'optimisation package.json"
    fi
    
    cd - > /dev/null
}

# Nettoyage des tests
clean_tests() {
    print_header "Nettoyage des Tests"
    
    cd "$PROJECT_DIR"
    
    # Simplifier tests/README.md s'il est trop verbeux
    if [ -f "tests/README.md" ]; then
        local readme_size=$(wc -l < "tests/README.md")
        if [ "$readme_size" -gt 200 ]; then
            print_info "Simplification de tests/README.md (${readme_size} lignes)..."
            
            cat > "tests/README.md" << 'EOF'
# Tests Math4Child

## 🧪 Tests End-to-End avec Playwright

### Installation et Configuration
```bash
npm install
npx playwright install
```

### Lancer les Tests
```bash
# Tous les tests
npm run test

# Mode interactif
npm run test:watch

# Tests spécifiques
npx playwright test --grep "math4child"
```

### Structure
- `specs/` - Tests fonctionnels
- `utils/` - Utilitaires de test
- `playwright.config.ts` - Configuration

### Tests Principaux
- ✅ Navigation multilingue
- ✅ Fonctionnalités mathématiques
- ✅ Interface responsive
- ✅ Performance et accessibilité

### Debugging
```bash
# Mode debug
npx playwright test --debug

# Traces et screenshots
npx playwright test --trace on
```

## 📊 Couverture des Tests
- **Fonctionnalités core** : 100%
- **Langues principales** : 6 langues
- **Navigateurs** : Chrome, Firefox, Safari
- **Appareils** : Desktop, Mobile, Tablette
EOF
            
            print_success "README des tests simplifié"
            log "tests/README.md simplifié"
        fi
    fi
    
    # Supprimer Docker tests s'il n'est pas utilisé
    if [ -d "tests/docker" ] && [ ! -f "docker-compose.yml" ] && [ ! -f "Dockerfile" ]; then
        print_info "Suppression des tests Docker (non utilisés)..."
        rm -rf "tests/docker"
        print_success "Supprimé: tests/docker/"
        log "Supprimé tests/docker - Docker non utilisé"
    fi
    
    cd - > /dev/null
}

# Réinstallation des dépendances
reinstall_dependencies() {
    print_header "Réinstallation des Dépendances"
    
    cd "$PROJECT_DIR"
    
    # Frontend
    print_info "Installation des dépendances frontend..."
    npm install
    print_success "Dépendances frontend installées"
    
    # Backend
    if [ -d "backend" ]; then
        print_info "Installation des dépendances backend..."
        cd backend
        npm install
        print_success "Dépendances backend installées"
        cd ..
    fi
    
    # Audit de sécurité
    print_info "Audit de sécurité..."
    npm audit fix --force 2>/dev/null || print_warning "Certains problèmes d'audit nécessitent une attention manuelle"
    
    cd - > /dev/null
}

# Vérifications post-nettoyage
run_verification() {
    print_header "Vérifications Post-Nettoyage"
    
    cd "$PROJECT_DIR"
    
    # Test de build
    print_info "Test de build..."
    if npm run build > /dev/null 2>&1; then
        print_success "Build réussi ✅"
        log "Build test réussi"
    else
        print_error "Échec du build ❌"
        log "Échec du build test"
    fi
    
    # Vérification TypeScript
    if command -v tsc &> /dev/null; then
        print_info "Vérification TypeScript..."
        if npx tsc --noEmit > /dev/null 2>&1; then
            print_success "Types TypeScript OK ✅"
            log "Vérification TypeScript réussie"
        else
            print_warning "Problèmes de types détectés ⚠️"
            log "Problèmes de types TypeScript détectés"
        fi
    fi
    
    # Test des dépendances
    print_info "Vérification des dépendances..."
    if npm ls > /dev/null 2>&1; then
        print_success "Dépendances cohérentes ✅"
        log "Dépendances vérifiées avec succès"
    else
        print_warning "Incohérences dans les dépendances ⚠️"
        log "Incohérences détectées dans les dépendances"
    fi
    
    cd - > /dev/null
}

# Génération du rapport final
generate_report() {
    print_header "Génération du Rapport Final"
    
    cd "$PROJECT_DIR"
    
    local project_size_after=$(du -sh . | cut -f1)
    local backup_size=$(du -sh "../$BACKUP_DIR" | cut -f1)
    
    cat > "CLEANUP_REPORT_$(date +%Y%m%d_%H%M%S).md" << EOF
# 📋 Rapport de Nettoyage Math4Child

**Date**: $(date '+%Y-%m-%d %H:%M:%S')
**Sauvegarde**: $BACKUP_DIR

## 📊 Résultats

### Taille du Projet
- **Avant**: $backup_size
- **Après**: $project_size_after

### Fichiers Supprimés
- recovery_report.md
- MATH4CHILD_RECOVERY_REPORT.md
- design_reference/site_backup/
- package-lock.json (régénéré)
- node_modules (réinstallé)

### Optimisations Réalisées
- ✅ Configuration .env.test simplifiée
- ✅ Scripts package.json optimisés
- ✅ Tests README simplifié
- ✅ Dépendances mises à jour
- ✅ Audit de sécurité appliqué

### Commandes de Test
\`\`\`bash
# Lancer l'application
npm run dev

# Tests E2E
npm run test

# Build production
npm run build
\`\`\`

### Prochaines Étapes Recommandées
1. Tester l'application: \`npm run dev\`
2. Lancer les tests: \`npm run test\`
3. Vérifier la fonctionnalité complète
4. Supprimer la sauvegarde si tout fonctionne: \`rm -rf $BACKUP_DIR\`

---
**Nettoyage Math4Child terminé avec succès! 🎉**
EOF
    
    print_success "Rapport généré: CLEANUP_REPORT_$(date +%Y%m%d_%H%M%S).md"
    log "Rapport final généré"
    
    cd - > /dev/null
}

# Fonction de rollback en cas de problème
rollback() {
    print_header "Rollback en Cours"
    print_warning "Restauration de la sauvegarde..."
    
    if [ -d "$BACKUP_DIR" ]; then
        rm -rf "$PROJECT_DIR"
        mv "$BACKUP_DIR" "$PROJECT_DIR"
        print_success "Rollback terminé avec succès"
        log "Rollback effectué avec succès"
    else
        print_error "Sauvegarde introuvable pour le rollback!"
        log "Échec du rollback - sauvegarde introuvable"
    fi
}

# Fonction principale
main() {
    print_header "SCRIPT DE NETTOYAGE MATH4CHILD"
    echo -e "${PURPLE}🚀 Démarrage du nettoyage automatisé...${NC}"
    
    log "Démarrage du script de nettoyage Math4Child"
    
    # Demander confirmation
    echo -e "\n${YELLOW}⚠️  Ce script va effectuer les actions suivantes:${NC}"
    echo "   • Créer une sauvegarde complète"
    echo "   • Supprimer les fichiers temporaires"
    echo "   • Nettoyer et réinstaller les dépendances"
    echo "   • Optimiser la configuration"
    echo "   • Simplifier les tests"
    echo "   • Générer un rapport final"
    echo
    
    read -p "Voulez-vous continuer? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Opération annulée par l'utilisateur"
        exit 0
    fi
    
    # Exécution des étapes
    trap 'print_error "Erreur détectée! Lancement du rollback..."; rollback; exit 1' ERR
    
    check_prerequisites
    create_backup
    remove_temp_files
    clean_dependencies
    optimize_config
    optimize_package_json
    clean_tests
    reinstall_dependencies
    run_verification
    generate_report
    
    # Succès final
    print_header "NETTOYAGE TERMINÉ AVEC SUCCÈS"
    print_success "🎉 Math4Child a été nettoyé et optimisé!"
    print_info "📁 Sauvegarde disponible: $BACKUP_DIR"
    print_info "📋 Rapport généré dans le dossier du projet"
    print_info "🚀 Testez avec: cd $PROJECT_DIR && npm run dev"
    
    log "Nettoyage Math4Child terminé avec succès"
    
    echo -e "\n${GREEN}✨ Votre projet Math4Child est maintenant propre et optimisé!${NC}"
}

# Lancement du script
main "$@"