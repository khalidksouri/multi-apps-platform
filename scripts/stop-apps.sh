#!/bin/bash

# Script d'arrêt des applications depuis multi-apps-platform
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
LOG_DIR="$WORKSPACE_DIR/logs"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🛑 ARRÊT DU MULTI-APPS-PLATFORM${NC}"
echo -e "${BLUE}===============================${NC}"
echo ""

# Fonction pour arrêter une application
stop_app() {
    local app_name=$1
    local port=$2
    local pid_file="$LOG_DIR/${app_name}.pid"
    
    echo -e "${YELLOW}🛑 Arrêt de $app_name...${NC}"
    
    # Arrêt via fichier PID
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null || kill -9 "$pid" 2>/dev/null
            echo -e "  ✅ Processus arrêté (PID: $pid)"
        fi
        rm -f "$pid_file"
    fi
    
    # Arrêt par port (backup)
    local port_pid=$(lsof -ti:$port 2>/dev/null || true)
    if [ -n "$port_pid" ]; then
        kill -9 "$port_pid" 2>/dev/null || true
        echo -e "  ✅ Port $port libéré"
    fi
    
    echo -e "  ✅ $app_name arrêté"
}

# Arrêt des applications
stop_app "math4kids" 3001
stop_app "unitflip" 3002
stop_app "budgetcron" 3003
stop_app "ai4kids" 3004
stop_app "multiai" 3005

echo ""
echo -e "${GREEN}🎉 ARRÊT TERMINÉ!${NC}"
echo ""
echo -e "${YELLOW}📋 Actions disponibles:${NC}"
echo "  🚀 Redémarrer: ./start-apps.sh"
echo "  📊 Statut:     ./status-apps.sh"
echo ""
