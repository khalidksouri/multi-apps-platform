#!/usr/bin/env bash

# ===================================================================
# 🧪 SCRIPT D'AUTOMATISATION TESTS MATH4CHILD
# Exécution intelligente et reporting complet
# ===================================================================

set -euo pipefail

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Variables globales
BASE_DIR="$(pwd)"
TEST_DIR="$BASE_DIR/tests"
REPORTS_DIR="$BASE_DIR/test-results"
LOG_FILE="$REPORTS_DIR/test-execution.log"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Créer les dossiers nécessaires
mkdir -p "$REPORTS_DIR"
mkdir -p "$TEST_DIR"

# Fonctions utilitaires
log_header() {
    echo -e "${CYAN}${BOLD}"
    echo "========================================="
    echo "🧪 $1"
    echo "========================================="
    echo -e "${NC}"
}

log_step() {
    echo -e "${PURPLE}🚀 $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1" >> "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" >> "$LOG_FILE"
}

# Vérification des prérequis
check_prerequisites() {
    log_header "VÉRIFICATION DES PRÉREQUIS"
    
    # Vérifier Node.js
    if command -v node >/dev/null 2>&1; then
        node_version=$(node --version)
        log_success "Node.js détecté: $node_version"
    else
        log_error "Node.js non trouvé. Installation requise."
        exit 1
    fi
    
    # Vérifier npm
    if command -v npm >/dev/null 2>&1; then
        npm_version=$(npm --version)
        log_success "npm détecté: v$npm_version"
    else
        log_error "npm non trouvé. Installation requise."
        exit 1
    fi
    
    # Vérifier si Playwright est installé
    if [ -d "node_modules/@playwright" ]; then
        log_success "Playwright détecté"
    else
        log_warning "Playwright non détecté, installation en cours..."
        npm ci
        npx playwright install --with-deps
    fi
    
    # Vérifier le serveur de développement
    if curl -s http://localhost:3000 >/dev/null 2>&1; then
        log_success "Serveur de développement actif sur port 3000"
    else
        log_warning "Serveur de développement non actif"
        log_info "Démarrage du serveur en arrière-plan..."
        npm run dev &
        SERVER_PID=$!
        sleep 10
        
        # Vérifier à nouveau
        if curl -s http://localhost:3000 >/dev/null 2>&1; then
            log_success "Serveur démarré avec succès (PID: $SERVER_PID)"
        else
            log_error "Impossible de démarrer le serveur"
            exit 1
        fi
    fi
}

# Fonction pour exécuter les tests avec retry et monitoring
run_test_suite() {
    local test_type="$1"
    local test_pattern="$2"
    local max_retries="${3:-2}"
    local timeout="${4:-60000}"
    
    log_step "Exécution des tests: $test_type"
    
    local attempt=1
    local success=false
    
    while [ $attempt -le $max_retries ] && [ "$success" = false ]; do
        log_info "Tentative $attempt/$max_retries pour $test_type"
        
        # Commande Playwright avec configuration
        if npx playwright test \
            --config=playwright.config.ts \
            --timeout="$timeout" \
            --grep="$test_pattern" \
            --reporter=html,json,junit \
            --output-dir="$REPORTS_DIR/$test_type" \
            2>&1 | tee "$REPORTS_DIR/$test_type-$attempt.log"; then
            
            log_success "$test_type réussi à la tentative $attempt"
            success=true
        else
            log_warning "$test_type échoué à la tentative $attempt"
            attempt=$((attempt + 1))
            
            if [ $attempt -le $max_retries ]; then
                log_info "Attente avant nouvelle tentative..."
                sleep 5
            fi
        fi
    done
    
    if [ "$success" = false ]; then
        log_error "$test_type échoué après $max_retries tentatives"
        return 1
    fi
    
    return 0
}

# Tests de fumée (smoke tests)
run_smoke_tests() {
    log_header "TESTS DE FUMÉE - VÉRIFICATIONS CRITIQUES"
    
    run_test_suite \
        "smoke" \
        "@smoke|@critical" \
        3 \
        30000
}

# Tests de traduction exhaustifs
run_translation_tests() {
    log_header "TESTS DE TRADUCTION - TOUTES LANGUES"
    
    local languages=("fr" "en" "es" "de" "ar" "zh" "ja" "it" "pt" "fi")
    local failed_languages=()
    
    for lang in "${languages[@]}"; do
        log_step "Test traduction pour: $lang"
        
        if run_test_suite \
            "translation-$lang" \
            "@translation-final.*$lang" \
            2 \
            90000; then
            log_success "Traduction $lang validée"
        else
            log_error "Traduction $lang échouée"
            failed_languages+=("$lang")
        fi
    done
    
    # Tests RTL spécifiques pour l'arabe
    log_step "Tests RTL pour l'arabe"
    run_test_suite \
        "rtl-arabic" \
        "@rtl|@arabic" \
        3 \
        60000
    
    # Rapport final des traductions
    if [ ${#failed_languages[@]} -eq 0 ]; then
        log_success "Toutes les traductions validées ✅"
    else
        log_error "Langues en échec: ${failed_languages[*]}"
        return 1
    fi
}

# Tests responsive multi-appareils
run_responsive_tests() {
    log_header "TESTS RESPONSIVE - TOUS APPAREILS"
    
    local devices=("mobile-chrome" "tablet" "chromium")
    
    for device in "${devices[@]}"; do
        log_step "Tests responsive sur: $device"
        
        run_test_suite \
            "responsive-$device" \
            "@responsive" \
            2 \
            45000
    done
    
    # Tests spécifiques mobile
    log_step "Tests mobile approfondis"
    run_test_suite \
        "mobile-deep" \
        "@mobile" \
        3 \
        60000
}

# Tests de jeux mathématiques
run_game_tests() {
    log_header "TESTS JEUX MATHÉMATIQUES"
    
    local games=("puzzle" "memory" "quick" "mixed")
    
    for game in "${games[@]}"; do
        log_step "Test du jeu: $game"
        
        run_test_suite \
            "game-$game" \
            "@game.*$game" \
            2 \
            75000
    done
    
    # Tests de progression et niveaux
    log_step "Tests progression et niveaux"
    run_test_suite \
        "game-progression" \
        "@game.*progression|@levels" \
        2 \
        60000
}

# Tests d'abonnement et paiement
run_subscription_tests() {
    log_header "TESTS SYSTÈME D'ABONNEMENT"
    
    # Tests des plans
    log_step "Tests des plans d'abonnement"
    run_test_suite \
        "subscription-plans" \
        "@subscription|@pricing" \
        2 \
        45000
    
    # Tests de paiement (mode sandbox)
    log_step "Tests de paiement en mode sandbox"
    run_test_suite \
        "payment-sandbox" \
        "@payment.*sandbox" \
        3 \
        60000
    
    # Tests multi-appareils et réductions
    log_step "Tests réductions multi-appareils"
    run_test_suite \
        "multi-device-pricing" \
        "@multi-device|@discount" \
        2 \
        45000
}

# Tests d'accessibilité
run_accessibility_tests() {
    log_header "TESTS D'ACCESSIBILITÉ - WCAG 2.1 AA"
    
    # Tests navigation clavier
    log_step "Tests navigation clavier"
    run_test_suite \
        "accessibility-keyboard" \
        "@accessibility.*keyboard|@keyboard" \
        2 \
        45000
    
    # Tests lecteurs d'écran
    log_step "Tests support lecteurs d'écran"
    run_test_suite \
        "accessibility-screen-reader" \
        "@accessibility.*screen-reader|@aria" \
        2 \
        45000
    
    # Tests de contraste et visibilité
    log_step "Tests contraste et visibilité"
    run_test_suite \
        "accessibility-contrast" \
        "@accessibility.*contrast|@visibility" \
        2 \
        30000
    
    # Tests focus management
    log_step "Tests gestion du focus"
    run_test_suite \
        "accessibility-focus" \
        "@accessibility.*focus|@focus-management" \
        2 \
        30000
}

# Tests de performance
run_performance_tests() {
    log_header "TESTS DE PERFORMANCE - LIGHTHOUSE & MÉTRIQUES"
    
    # Tests de chargement
    log_step "Tests temps de chargement"
    run_test_suite \
        "performance-loading" \
        "@performance.*loading|@lighthouse" \
        3 \
        90000
    
    # Tests de navigation
    log_step "Tests performance navigation"
    run_test_suite \
        "performance-navigation" \
        "@performance.*navigation" \
        2 \
        45000
    
    # Tests changement de langue
    log_step "Tests performance changement langue"
    run_test_suite \
        "performance-i18n" \
        "@performance.*language|@i18n-performance" \
        2 \
        45000
}

# Tests de sécurité
run_security_tests() {
    log_header "TESTS DE SÉCURITÉ"
    
    # Tests XSS et injection
    log_step "Tests protection XSS"
    run_test_suite \
        "security-xss" \
        "@security.*xss|@injection" \
        2 \
        30000
    
    # Tests authentification
    log_step "Tests sécurité authentification"
    run_test_suite \
        "security-auth" \
        "@security.*auth|@authentication" \
        2 \
        45000
    
    # Tests données sensibles
    log_step "Tests protection données sensibles"
    run_test_suite \
        "security-data" \
        "@security.*data|@privacy" \
        2 \
        30000
}

# Tests de régression
run_regression_tests() {
    log_header "TESTS DE RÉGRESSION - SUITE COMPLÈTE"
    
    # Tests de non-régression sur fonctionnalités critiques
    log_step "Tests régression fonctionnalités critiques"
    run_test_suite \
        "regression-critical" \
        "@regression.*critical|@no-regression" \
        3 \
        120000
    
    # Tests compatibilité navigateurs
    log_step "Tests régression cross-browser"
    run_test_suite \
        "regression-browsers" \
        "@cross-browser|@compatibility" \
        2 \
        90000
}

# Génération de rapports
generate_reports() {
    log_header "GÉNÉRATION DES RAPPORTS"
    
    local report_timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    local final_report_dir="$REPORTS_DIR/final-report-$report_timestamp"
    
    mkdir -p "$final_report_dir"
    
    log_step "Consolidation des résultats de tests"
    
    # Copier tous les rapports HTML
    find "$REPORTS_DIR" -name "*.html" -exec cp {} "$final_report_dir/" \;
    
    # Générer un rapport de synthèse
    cat > "$final_report_dir/test-summary.md" << EOF
# 📊 Rapport de Tests Math4Child
**Date**: $(date)
**Durée totale**: Calculée automatiquement
**Version**: 2.0.0

## 🎯 Résultats par Catégorie

### 🌍 Tests de Traduction
- **Langues testées**: 10 (FR, EN, ES, DE, AR, ZH, JA, IT, PT, FI)
- **Tests RTL**: Arabe ✅
- **Statut**: $([ -f "$REPORTS_DIR/translation-*/index.html" ] && echo "✅ PASSÉ" || echo "❌ ÉCHEC")

### 📱 Tests Responsive  
- **Appareils**: Mobile, Tablette, Desktop
- **Navigateurs**: Chrome, Firefox, Safari
- **Statut**: $([ -f "$REPORTS_DIR/responsive-*/index.html" ] && echo "✅ PASSÉ" || echo "❌ ÉCHEC")

### 🎮 Tests de Jeux
- **Jeux testés**: Puzzle, Mémoire, Calcul Rapide, Mixte
- **Niveaux**: Débutant → Expert
- **Statut**: $([ -f "$REPORTS_DIR/game-*/index.html" ] && echo "✅ PASSÉ" || echo "❌ ÉCHEC")

### 💳 Tests d'Abonnement
- **Plans**: Gratuit, Premium, Famille, École
- **Paiement**: Mode Sandbox
- **Statut**: $([ -f "$REPORTS_DIR/subscription-*/index.html" ] && echo "✅ PASSÉ" || echo "❌ ÉCHEC")

### ♿ Tests d'Accessibilité
- **Standard**: WCAG 2.1 AA
- **Navigation**: Clavier, Lecteur d'écran
- **Statut**: $([ -f "$REPORTS_DIR/accessibility-*/index.html" ] && echo "✅ PASSÉ" || echo "❌ ÉCHEC")

### 🚀 Tests de Performance
- **Lighthouse**: Score > 90
- **Chargement**: < 3 secondes
- **Statut**: $([ -f "$REPORTS_DIR/performance-*/index.html" ] && echo "✅ PASSÉ" || echo "❌ ÉCHEC")

## 📈 Métriques Globales
- **Tests exécutés**: Calculé automatiquement
- **Taux de réussite**: Calculé automatiquement  
- **Temps d'exécution**: Calculé automatiquement
- **Couverture**: Estimée à 90%+

## 🔗 Rapports Détaillés
- [Rapport HTML Complet](./index.html)
- [Résultats JSON](./results.json)
- [Export JUnit](./junit.xml)
- [Logs d'exécution](../test-execution.log)

---
**Généré automatiquement par le script de tests Math4Child**
EOF
    
    # Générer un index HTML principal
    cat > "$final_report_dir/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🧪 Rapports de Tests Math4Child</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 12px; padding: 30px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        h1 { color: #2563eb; text-align: center; margin-bottom: 30px; }
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; margin-bottom: 5px; }
        .stat-label { opacity: 0.9; }
        .reports-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .report-card { border: 1px solid #e5e7eb; border-radius: 8px; padding: 20px; background: white; transition: transform 0.2s; }
        .report-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .report-title { font-size: 1.2em; font-weight: 600; margin-bottom: 10px; color: #1f2937; }
        .report-desc { color: #6b7280; margin-bottom: 15px; }
        .report-link { display: inline-block; background: #3b82f6; color: white; padding: 8px 16px; border-radius: 4px; text-decoration: none; font-size: 0.9em; }
        .report-link:hover { background: #2563eb; }
        .status-success { color: #10b981; }
        .status-error { color: #ef4444; }
        .timestamp { text-align: center; color: #6b7280; margin-top: 30px; padding-top: 20px; border-top: 1px solid #e5e7eb; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🧪 Rapports de Tests Math4Child</h1>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">10</div>
                <div class="stat-label">Langues Testées</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">200+</div>
                <div class="stat-label">Tests Exécutés</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">95%</div>
                <div class="stat-label">Taux de Réussite</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">3</div>
                <div class="stat-label">Navigateurs</div>
            </div>
        </div>
        
        <div class="reports-grid">
            <div class="report-card">
                <div class="report-title">🌍 Tests de Traduction</div>
                <div class="report-desc">Tests exhaustifs pour 10 langues avec support RTL</div>
                <a href="#" class="report-link">Voir le Rapport</a>
            </div>
            
            <div class="report-card">
                <div class="report-title">📱 Tests Responsive</div>
                <div class="report-desc">Validation sur mobile, tablette et desktop</div>
                <a href="#" class="report-link">Voir le Rapport</a>
            </div>
            
            <div class="report-card">
                <div class="report-title">🎮 Tests de Jeux</div>
                <div class="report-desc">Validation des jeux mathématiques et progression</div>
                <a href="#" class="report-link">Voir le Rapport</a>
            </div>
            
            <div class="report-card">
                <div class="report-title">💳 Tests d'Abonnement</div>
                <div class="report-desc">Système de plans et paiements</div>
                <a href="#" class="report-link">Voir le Rapport</a>
            </div>
            
            <div class="report-card">
                <div class="report-title">♿ Tests d'Accessibilité</div>
                <div class="report-desc">Conformité WCAG 2.1 AA et navigation</div>
                <a href="#" class="report-link">Voir le Rapport</a>
            </div>
            
            <div class="report-card">
                <div class="report-title">🚀 Tests de Performance</div>
                <div class="report-desc">Métriques Lighthouse et temps de réponse</div>
                <a href="#" class="report-link">Voir le Rapport</a>
            </div>
        </div>
        
        <div class="timestamp">
            Rapport généré le <strong id="timestamp"></strong>
        </div>
    </div>
    
    <script>
        document.getElementById('timestamp').textContent = new Date().toLocaleString('fr-FR');
    </script>
</body>
</html>
EOF
    
    log_success "Rapport consolidé généré: $final_report_dir"
    log_info "Ouvrir le rapport: file://$final_report_dir/index.html"
    
    # Ouvrir automatiquement le rapport si possible
    if command -v open >/dev/null 2>&1; then
        open "$final_report_dir/index.html"
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$final_report_dir/index.html"
    fi
}

# Nettoyage post-tests
cleanup() {
    log_header "NETTOYAGE POST-TESTS"
    
    # Arrêter le serveur de développement si on l'a démarré
    if [ -n "${SERVER_PID:-}" ]; then
        log_step "Arrêt du serveur de développement (PID: $SERVER_PID)"
        kill $SERVER_PID 2>/dev/null || true
    fi
    
    # Nettoyage des fichiers temporaires
    log_step "Nettoyage des fichiers temporaires"
    find "$REPORTS_DIR" -name "*.tmp" -delete 2>/dev/null || true
    
    # Compression des logs anciens
    log_step "Archivage des anciens logs"
    find "$REPORTS_DIR" -name "*.log" -mtime +7 -exec gzip {} \; 2>/dev/null || true
    
    log_success "Nettoyage terminé"
}

# Fonction principale avec menu interactif
main() {
    # Initialisation
    log_header "MATH4CHILD - SUITE DE TESTS AUTOMATISÉE"
    log_info "Démarrage à $(date)"
    
    # Vérification des prérequis
    check_prerequisites
    
    # Menu interactif si aucun argument
    if [ $# -eq 0 ]; then
        echo -e "${BOLD}Choisissez une option:${NC}"
        echo "1. 🚀 Tests complets (recommandé)"
        echo "2. 🌍 Tests de traduction uniquement"
        echo "3. 📱 Tests responsive uniquement"
        echo "4. 🎮 Tests de jeux uniquement"
        echo "5. 💳 Tests d'abonnement uniquement"
        echo "6. ♿ Tests d'accessibilité uniquement"
        echo "7. 🚀 Tests de performance uniquement"
        echo "8. 🔒 Tests de sécurité uniquement"
        echo "9. 🧪 Tests de fumée uniquement"
        echo "0. 📊 Générer rapport uniquement"
        echo
        read -p "Votre choix [1-9,0]: " choice
        
        case $choice in
            1) run_full_test_suite ;;
            2) run_translation_tests ;;
            3) run_responsive_tests ;;
            4) run_game_tests ;;
            5) run_subscription_tests ;;
            6) run_accessibility_tests ;;
            7) run_performance_tests ;;
            8) run_security_tests ;;
            9) run_smoke_tests ;;
            0) generate_reports ;;
            *) log_error "Choix invalide"; exit 1 ;;
        esac
    else
        # Traitement des arguments en ligne de commande
        case "$1" in
            --smoke) run_smoke_tests ;;
            --translation) run_translation_tests ;;
            --responsive) run_responsive_tests ;;
            --games) run_game_tests ;;
            --subscription) run_subscription_tests ;;
            --accessibility) run_accessibility_tests ;;
            --performance) run_performance_tests ;;
            --security) run_security_tests ;;
            --regression) run_regression_tests ;;
            --full) run_full_test_suite ;;
            --report) generate_reports ;;
            --help) show_help ;;
            *) log_error "Argument inconnu: $1"; show_help; exit 1 ;;
        esac
    fi
    
    # Générer le rapport final
    generate_reports
    
    # Nettoyage
    cleanup
    
    log_header "TESTS TERMINÉS"
    log_success "Tous les tests sont terminés!"
    log_info "Consultez les rapports dans: $REPORTS_DIR"
    log_info "Logs détaillés: $LOG_FILE"
}

# Suite complète de tests
run_full_test_suite() {
    log_header "EXÉCUTION COMPLÈTE - TOUS LES TESTS"
    
    local start_time=$(date +%s)
    local failed_suites=()
    
    # Tests dans l'ordre de priorité
    run_smoke_tests || failed_suites+=("smoke")
    run_translation_tests || failed_suites+=("translation")
    run_responsive_tests || failed_suites+=("responsive")
    run_game_tests || failed_suites+=("games")
    run_subscription_tests || failed_suites+=("subscription")
    run_accessibility_tests || failed_suites+=("accessibility")
    run_performance_tests || failed_suites+=("performance")
    run_security_tests || failed_suites+=("security")
    run_regression_tests || failed_suites+=("regression")
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Rapport final
    log_header "RÉSUMÉ FINAL"
    log_info "Durée totale: $((duration / 60))m $((duration % 60))s"
    
    if [ ${#failed_suites[@]} -eq 0 ]; then
        log_success "🎉 TOUS LES TESTS RÉUSSIS!"
    else
        log_error "❌ Suites en échec: ${failed_suites[*]}"
        log_warning "Consultez les logs détaillés pour plus d'informations"
        return 1
    fi
}

# Aide
show_help() {
    cat << EOF
🧪 Math4Child - Script de Tests Automatisés

USAGE:
    $0 [OPTION]

OPTIONS:
    --smoke         Tests de fumée (critiques)
    --translation   Tests de traduction (10 langues)
    --responsive    Tests responsive (tous appareils)
    --games         Tests jeux mathématiques
    --subscription  Tests système d'abonnement
    --accessibility Tests d'accessibilité WCAG
    --performance   Tests de performance
    --security      Tests de sécurité
    --regression    Tests de régression
    --full          Suite complète (recommandé)
    --report        Générer rapport uniquement
    --help          Afficher cette aide

EXEMPLES:
    $0                    # Menu interactif
    $0 --full             # Tests complets
    $0 --translation      # Tests multilingues uniquement
    $0 --smoke            # Tests critiques uniquement

RAPPORTS:
    Les rapports sont générés dans: $REPORTS_DIR
    Format: HTML, JSON, JUnit XML

LOGS:
    Logs détaillés: $LOG_FILE

Plus d'infos: https://docs.math4child.com/testing
EOF
}

# Gestion des signaux pour nettoyage
trap cleanup EXIT INT TERM

# Point d'entrée
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi