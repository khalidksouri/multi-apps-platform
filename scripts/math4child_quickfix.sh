#!/bin/bash

#===============================================================================
# MATH4CHILD - SCRIPT DE CORRECTION RAPIDE
# Corrige les problèmes courants et libère les ports
#===============================================================================

set -euo pipefail

# Couleurs
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_message() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%H:%M:%S')
    
    case $level in
        "INFO")  echo -e "${GREEN}[${timestamp}] ℹ️  INFO: ${message}${NC}" ;;
        "WARN")  echo -e "${YELLOW}[${timestamp}] ⚠️  WARN: ${message}${NC}" ;;
        "ERROR") echo -e "${RED}[${timestamp}] ❌ ERROR: ${message}${NC}" ;;
        "SUCCESS") echo -e "${GREEN}[${timestamp}] ✅ SUCCESS: ${message}${NC}" ;;
    esac
}

# Libérer le port 3000 et 3001
free_ports() {
    log_message "INFO" "🔍 Libération des ports 3000 et 3001..."
    
    for port in 3000 3001; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            local pid=$(lsof -Pi :$port -sTCP:LISTEN -t)
            log_message "WARN" "Port $port utilisé par PID $pid, arrêt..."
            kill $pid 2>/dev/null || true
            sleep 1
            
            # Force kill si nécessaire
            if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
                kill -9 $pid 2>/dev/null || true
            fi
            
            log_message "SUCCESS" "Port $port libéré"
        else
            log_message "INFO" "Port $port déjà libre"
        fi
    done
}

# Corriger la configuration Next.js
fix_nextjs_config() {
    log_message "INFO" "🔧 Correction de la configuration Next.js..."
    
    if [ -d "apps/math4child" ]; then
        cd apps/math4child
        
        # Corriger le package.json
        if [ -f "package.json" ]; then
            # Remplacer le port dans package.json
            sed -i '' 's/"dev": "next dev -p 3001"/"dev": "next dev -p 3000"/g' package.json 2>/dev/null || \
            sed -i 's/"dev": "next dev -p 3001"/"dev": "next dev -p 3000"/g' package.json 2>/dev/null || true
            
            log_message "SUCCESS" "Package.json corrigé"
        fi
        
        # Supprimer les fichiers problématiques
        rm -f .env.local
        rm -f next.config.js
        
        # Créer une configuration Next.js basique
        cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
}

module.exports = nextConfig
EOF
        
        cd ../..
        log_message "SUCCESS" "Configuration Next.js corrigée"
    fi
}

# Installer Docker Desktop sur macOS
install_docker_macos() {
    log_message "INFO" "🐳 Installation de Docker Desktop pour macOS..."
    
    if command -v brew &> /dev/null; then
        log_message "INFO" "Installation via Homebrew..."
        brew install --cask docker
        log_message "SUCCESS" "Docker Desktop installé via Homebrew"
        log_message "INFO" "Lancez Docker Desktop depuis les Applications"
    else
        log_message "WARN" "Homebrew non installé"
        log_message "INFO" "Téléchargez Docker Desktop manuellement depuis:"
        echo "https://www.docker.com/products/docker-desktop/"
    fi
}

# Menu principal
show_menu() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                    🔧 MATH4CHILD - CORRECTION RAPIDE                        ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo "Que voulez-vous corriger ?"
    echo ""
    echo "1. Libérer les ports 3000/3001"
    echo "2. Corriger la configuration Next.js"
    echo "3. Installer Docker Desktop (macOS)"
    echo "4. Tout corriger automatiquement"
    echo "5. Quitter"
    echo ""
    echo -n "Votre choix (1-5): "
}

# Correction automatique complète
auto_fix() {
    log_message "INFO" "🚀 Correction automatique en cours..."
    
    free_ports
    fix_nextjs_config
    
    # Vérifier si Docker est installé
    if ! command -v docker &> /dev/null; then
        log_message "WARN" "Docker non installé"
        echo -e "${YELLOW}Voulez-vous installer Docker Desktop ? (y/n): ${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            install_docker_macos
        fi
    fi
    
    log_message "SUCCESS" "🎉 Corrections terminées !"
    log_message "INFO" "Vous pouvez maintenant exécuter: ./math4child_deploy_script_fixed.sh start"
}

# Script principal
main() {
    if [[ $# -eq 0 ]]; then
        while true; do
            show_menu
            read -r choice
            
            case $choice in
                1)
                    free_ports
                    ;;
                2)
                    fix_nextjs_config
                    ;;
                3)
                    install_docker_macos
                    ;;
                4)
                    auto_fix
                    break
                    ;;
                5)
                    log_message "INFO" "Au revoir !"
                    exit 0
                    ;;
                *)
                    log_message "ERROR" "Choix invalide"
                    ;;
            esac
            
            echo ""
            echo "Appuyez sur Entrée pour continuer..."
            read -r
        done
    else
        case "$1" in
            "ports")
                free_ports
                ;;
            "config")
                fix_nextjs_config
                ;;
            "docker")
                install_docker_macos
                ;;
            "auto")
                auto_fix
                ;;
            *)
                log_message "ERROR" "Option inconnue: $1"
                echo "Options: ports, config, docker, auto"
                exit 1
                ;;
        esac
    fi
}

main "$@"