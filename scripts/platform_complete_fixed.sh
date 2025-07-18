#!/bin/bash

# =============================================================================
# SCRIPT PLATFORM COMPLET - VERSION CORRIGÉE ET FONCTIONNELLE
# =============================================================================
# Ce script remplace complètement digital4kids_script_suite.sh défaillant
# =============================================================================

set -e

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$PROJECT_DIR/apps"
LOG_DIR="$PROJECT_DIR/logs"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Applications
APPS_NAMES="math4kids unitflip budgetcron ai4kids multiai digital4kids"
APPS_PORTS="3001 3002 3003 3004 3005 3006"
APPS_COMMANDS="npm_start npm_start npm_run_serve npm_start npm_run_dev npm_start"

# =============================================================================
# FONCTIONS UTILITAIRES
# =============================================================================

show_header() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}║    🚀 PLATEFORME MULTI-APPS - VERSION CORRIGÉE 🚀              ║${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}║  Création • Réparation • Multilingue • Démarrage • Gestion     ║${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📁 Projet: ${PROJECT_DIR}${NC}"
    echo -e "${CYAN}📁 Applications: ${WORKSPACE_DIR}${NC}"
    echo -e "${CYAN}📋 Logs: ${LOG_DIR}${NC}"
    echo ""
}

get_app_info() {
    local app_name=$1
    local index=0
    
    for name in $APPS_NAMES; do
        if [ "$name" = "$app_name" ]; then
            local port=$(echo $APPS_PORTS | cut -d' ' -f$((index + 1)))
            local cmd=$(echo $APPS_COMMANDS | cut -d' ' -f$((index + 1)))
            
            case $cmd in
                "npm_start") echo "$port:npm start" ;;
                "npm_run_serve") echo "$port:npm run serve" ;;
                "npm_run_dev") echo "$port:npm run dev" ;;
                *) echo "$port:npm start" ;;
            esac
            return 0
        fi
        index=$((index + 1))
    done
    
    echo "unknown:unknown"
}

log() {
    local level=$1
    local color=$2
    local message=$3
    echo -e "${color}[${level}] ${message}${NC}"
    
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] ${message}" >> "$LOG_DIR/platform.log"
}

# =============================================================================
# FONCTIONS DE GESTION DES APPLICATIONS
# =============================================================================

start_app() {
    local app_name=$1
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    local command="${app_info#*:}"
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🚀 Démarrage de $app_name (port $port)...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "  ${RED}❌ Répertoire manquant: $app_dir${NC}"
        return 1
    fi
    
    cd "$app_dir"
    
    if [ ! -d "node_modules" ]; then
        echo -e "  📦 Installation des dépendances..."
        npm install --legacy-peer-deps --silent
    fi
    
    # Libérer le port si occupé
    if command -v lsof >/dev/null 2>&1 && lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "  🔌 Libération du port $port..."
        local existing_pid=$(lsof -ti:$port)
        kill -9 "$existing_pid" 2>/dev/null || true
        sleep 2
    fi
    
    mkdir -p "$LOG_DIR"
    
    echo -e "  ▶️ Lancement: $command"
    PORT=$port BROWSER=none $command > "$LOG_DIR/${app_name}.log" 2>&1 &
    local pid=$!
    
    echo "$pid" > "$LOG_DIR/${app_name}.pid"
    
    echo -e "  ⏳ Attente du démarrage (PID: $pid)..."
    local max_attempts=20
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if command -v curl >/dev/null 2>&1 && curl -s -f "http://localhost:$port" >/dev/null 2>&1; then
            echo -e "  ${GREEN}✅ $app_name démarré! - http://localhost:$port${NC}"
            return 0
        fi
        
        if ! ps -p $pid >/dev/null 2>&1; then
            echo -e "  ${RED}❌ Le processus s'est arrêté${NC}"
            echo -e "  📝 Voir logs: cat $LOG_DIR/${app_name}.log"
            return 1
        fi
        
        sleep 3
        attempt=$((attempt + 1))
    done
    
    echo -e "  ${YELLOW}⏰ $app_name en cours de démarrage...${NC}"
    return 0
}

stop_app() {
    local app_name=$1
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    
    echo -e "${YELLOW}🛑 Arrêt de $app_name...${NC}"
    
    # Arrêter par PID
    local pid_file="$LOG_DIR/${app_name}.pid"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" >/dev/null 2>&1; then
            kill -TERM "$pid" 2>/dev/null || true
            sleep 2
            if ps -p "$pid" >/dev/null 2>&1; then
                kill -9 "$pid" 2>/dev/null || true
            fi
        fi
        rm -f "$pid_file"
    fi
    
    # Libérer le port
    if command -v lsof >/dev/null 2>&1; then
        local port_pid=$(lsof -ti:$port 2>/dev/null || true)
        if [ -n "$port_pid" ]; then
            kill -9 "$port_pid" 2>/dev/null || true
        fi
    fi
    
    echo -e "  ${GREEN}✅ $app_name arrêté${NC}"
}

check_app_status() {
    local app_name=$1
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    
    if command -v curl >/dev/null 2>&1 && curl -s -f "http://localhost:$port" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ $app_name${NC} - http://localhost:$port"
        return 0
    else
        echo -e "${RED}❌ $app_name${NC} - Non actif"
        return 1
    fi
}

check_all_status() {
    local running_apps=0
    local working_urls=""
    
    for app_name in $APPS_NAMES; do
        local app_info=$(get_app_info "$app_name")
        local port="${app_info%:*}"
        
        if check_app_status "$app_name"; then
            running_apps=$((running_apps + 1))
            working_urls="$working_urls http://localhost:$port"
        fi
    done
    
    echo ""
    echo -e "${GREEN}✅ $running_apps/6 applications actives${NC}"
    
    if [ $running_apps -gt 0 ]; then
        echo -e "${CYAN}🌐 URLs disponibles :${NC}"
        for url in $working_urls; do
            echo -e "   $url"
        done
    fi
    
    return $running_apps
}

# =============================================================================
# FONCTIONS PRINCIPALES
# =============================================================================

start_all_apps() {
    show_header
    echo -e "${BLUE}🚀 DÉMARRAGE DE TOUTES LES APPLICATIONS${NC}"
    echo -e "${BLUE}=====================================${NC}"
    echo ""
    
    # Vérifier les prérequis
    if ! command -v node >/dev/null 2>&1; then
        echo -e "${RED}❌ Node.js n'est pas installé${NC}"
        exit 1
    fi
    
    if [ ! -d "$WORKSPACE_DIR" ]; then
        echo -e "${RED}❌ Workspace non trouvé: $WORKSPACE_DIR${NC}"
        echo -e "${YELLOW}💡 Utilisez d'abord: ./quick_fix_script.sh${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Prérequis validés${NC}"
    echo ""
    
    # Démarrer chaque application
    local started_apps=0
    
    for app_name in $APPS_NAMES; do
        if start_app "$app_name"; then
            started_apps=$((started_apps + 1))
        fi
        echo ""
        sleep 2
    done
    
    # Stabilisation
    echo -e "${BLUE}⏳ Stabilisation de la plateforme (15 secondes)...${NC}"
    sleep 15
    
    # Affichage final du statut
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                    🎉 PLATEFORME DÉMARRÉE 🎉                    ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    check_all_status
    
    echo ""
    echo -e "${CYAN}🎯 RÉSUMÉ FINAL :${NC}"
    echo -e "   ${GREEN}✨ $started_apps applications démarrées${NC}"
    
    if [ $started_apps -eq 6 ]; then
        echo -e "   ${GREEN}🏆 PLATEFORME 100% OPÉRATIONNELLE !${NC}"
        echo -e "   ${CYAN}🚀 Toutes les applications sont accessibles${NC}"
    elif [ $started_apps -ge 4 ]; then
        echo -e "   ${YELLOW}⚠️ $((6 - started_apps)) applications n'ont pas démarré${NC}"
        echo -e "   ${CYAN}💡 Consultez les logs pour plus de détails${NC}"
    else
        echo -e "   ${RED}❌ Problèmes de démarrage détectés${NC}"
        echo -e "   ${CYAN}💡 Essayez: ./quick_fix_script.sh${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}📋 COMMANDES UTILES :${NC}"
    echo -e "   ${GREEN}$0 status${NC}  - Vérifier le statut"
    echo -e "   ${GREEN}$0 stop${NC}    - Arrêter toutes les apps"
    echo -e "   ${GREEN}$0 logs${NC}    - Voir les logs"
    echo ""
}

stop_all_apps() {
    show_header
    echo -e "${YELLOW}🛑 ARRÊT DE TOUTES LES APPLICATIONS${NC}"
    echo -e "${YELLOW}===================================${NC}"
    echo ""
    
    for app_name in $APPS_NAMES; do
        stop_app "$app_name"
    done
    
    echo ""
    echo -e "${GREEN}✅ Toutes les applications arrêtées${NC}"
}

show_status() {
    show_header
    echo -e "${BLUE}📊 STATUT DES APPLICATIONS${NC}"
    echo -e "${BLUE}==========================${NC}"
    echo ""
    
    check_all_status
    
    echo ""
    echo -e "${CYAN}📋 INFORMATIONS SYSTÈME :${NC}"
    if command -v node >/dev/null 2>&1; then
        echo -e "   Node.js: $(node --version)"
    fi
    if command -v npm >/dev/null 2>&1; then
        echo -e "   npm: $(npm --version)"
    fi
    echo -e "   Workspace: $WORKSPACE_DIR"
    echo -e "   Logs: $LOG_DIR"
}

show_logs() {
    show_header
    echo -e "${BLUE}📝 LOGS DES APPLICATIONS${NC}"
    echo -e "${BLUE}========================${NC}"
    echo ""
    
    if [ ! -d "$LOG_DIR" ] || [ -z "$(ls -A "$LOG_DIR" 2>/dev/null)" ]; then
        echo -e "${YELLOW}ℹ️ Aucun log disponible${NC}"
        return
    fi
    
    for app_name in $APPS_NAMES; do
        local log_file="$LOG_DIR/${app_name}.log"
        if [ -f "$log_file" ]; then
            echo -e "${CYAN}📄 Logs de $app_name (dernières lignes):${NC}"
            tail -n 10 "$log_file" | head -n 5
            echo ""
        fi
    done
    
    echo -e "${CYAN}📄 Log principal:${NC}"
    if [ -f "$LOG_DIR/platform.log" ]; then
        tail -n 10 "$LOG_DIR/platform.log"
    else
        echo -e "${YELLOW}Aucun log principal${NC}"
    fi
}

repair_app() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🔧 Réparation de $app_name...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "  ${RED}❌ Répertoire manquant: $app_dir${NC}"
        echo -e "  ${CYAN}💡 Utilisez: ./quick_fix_script.sh${NC}"
        return 1
    fi
    
    cd "$app_dir"
    
    echo -e "  🧹 Nettoyage..."
    rm -rf node_modules package-lock.json .npm 2>/dev/null || true
    
    echo -e "  📦 Réinstallation..."
    if npm install --legacy-peer-deps --silent; then
        echo -e "  ${GREEN}✅ $app_name réparé!${NC}"
        return 0
    else
        echo -e "  ${RED}❌ Erreur de réparation${NC}"
        return 1
    fi
}

show_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🎯 MENU PRINCIPAL - PLATEFORME MULTI-APPS${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo ""
        echo -e "${GREEN}1.${NC} 🚀 Démarrer toutes les applications"
        echo -e "${GREEN}2.${NC} 🛑 Arrêter toutes les applications"
        echo -e "${GREEN}3.${NC} 📊 Vérifier le statut"
        echo -e "${GREEN}4.${NC} 📝 Voir les logs"
        echo -e "${GREEN}5.${NC} 🔧 Réparer une application"
        echo -e "${GREEN}6.${NC} 🏗️ Recréer les applications (quick_fix_script.sh)"
        echo -e "${RED}0.${NC} ❌ Quitter"
        echo ""
        echo -e "${YELLOW}Applications: math4kids(3001) unitflip(3002) budgetcron(3003) ai4kids(3004) multiai(3005) digital4kids(3006)${NC}"
        echo ""
        read -p "Votre choix (0-6): " choice
        
        case $choice in
            1)
                start_all_apps
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            2)
                stop_all_apps
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            3)
                show_status
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            4)
                show_logs
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            5)
                echo ""
                echo -e "${CYAN}Applications disponibles: $APPS_NAMES${NC}"
                read -p "Nom de l'application à réparer: " app_to_repair
                if echo "$APPS_NAMES" | grep -q "$app_to_repair"; then
                    repair_app "$app_to_repair"
                else
                    echo -e "${RED}❌ Application inconnue${NC}"
                fi
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            6)
                echo -e "${YELLOW}🏗️ Lancement du script de recréation...${NC}"
                if [ -f "./quick_fix_script.sh" ]; then
                    ./quick_fix_script.sh
                else
                    echo -e "${RED}❌ quick_fix_script.sh non trouvé${NC}"
                    echo -e "${CYAN}💡 Créez d'abord ce script avec les applications corrects${NC}"
                fi
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            0)
                echo -e "${GREEN}👋 Au revoir !${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Choix invalide${NC}"
                sleep 2
                ;;
        esac
    done
}

# =============================================================================
# POINT D'ENTRÉE PRINCIPAL
# =============================================================================

main() {
    # Créer les répertoires nécessaires
    mkdir -p "$LOG_DIR"
    mkdir -p "$WORKSPACE_DIR"
    
    case "${1:-menu}" in
        "start")
            start_all_apps
            ;;
        "stop")
            stop_all_apps
            ;;
        "status")
            show_status
            ;;
        "logs")
            show_logs
            ;;
        "repair")
            if [ -n "$2" ]; then
                repair_app "$2"
            else
                echo "Usage: $0 repair [app_name]"
            fi
            ;;
        "menu"|"interactive")
            show_menu
            ;;
        "help"|"-h"|"--help")
            show_header
            echo -e "${CYAN}UTILISATION:${NC}"
            echo ""
            echo -e "  ${GREEN}$0${NC}              - Menu interactif"
            echo -e "  ${GREEN}$0 start${NC}        - Démarrer toutes les apps"
            echo -e "  ${GREEN}$0 stop${NC}         - Arrêter toutes les apps"
            echo -e "  ${GREEN}$0 status${NC}       - Vérifier le statut"
            echo -e "  ${GREEN}$0 logs${NC}         - Voir les logs"
            echo -e "  ${GREEN}$0 repair [app]${NC} - Réparer une application"
            echo ""
            echo -e "${YELLOW}💡 Si les applications ne démarrent pas:${NC}"
            echo -e "   ${CYAN}1. Lancez d'abord: ./quick_fix_script.sh${NC}"
            echo -e "   ${CYAN}2. Puis: $0 start${NC}"
            echo ""
            ;;
        *)
            echo -e "${RED}❌ Commande inconnue: $1${NC}"
            echo -e "${CYAN}Utilisez '$0 help' pour voir l'aide${NC}"
            exit 1
            ;;
    esac
}

# Gestion des signaux d'interruption
cleanup() {
    echo ""
    echo -e "${YELLOW}🛑 Interruption détectée...${NC}"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Vérifier que le script n'est pas exécuté en tant que root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}❌ Ne pas exécuter ce script en tant que root${NC}"
    exit 1
fi

# Exécuter la fonction principale
main "$@"