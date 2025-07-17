#!/bin/bash

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
LOG_DIR="$WORKSPACE_DIR/logs"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📊 STATUT DU MULTI-APPS-PLATFORM${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""

# Fonction pour vérifier le statut d'une application
check_app_status() {
    local app_name=$1
    local port=$2
    local pid_file="$LOG_DIR/${app_name}.pid"
    
    echo -e "${YELLOW}📱 $app_name (Port: $port)${NC}"
    
    # Vérifier le processus
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            echo -e "  ✅ Processus: ${GREEN}Actif (PID: $pid)${NC}"
        else
            echo -e "  ❌ Processus: ${RED}Arrêté${NC}"
            rm -f "$pid_file"
        fi
    else
        echo -e "  ❌ Processus: ${RED}Non démarré${NC}"
    fi
    
    # Vérifier le port
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "  ✅ Port $port: ${GREEN}Utilisé${NC}"
        
        # Test HTTP
        if curl -s --max-time 5 "http://localhost:$port" >/dev/null 2>&1; then
            echo -e "  ✅ HTTP: ${GREEN}Répond${NC} - http://localhost:$port"
        else
            echo -e "  ⚠️ HTTP: ${YELLOW}Port ouvert mais ne répond pas${NC}"
        fi
    else
        echo -e "  ❌ Port $port: ${RED}Libre${NC}"
    fi
    
    echo ""
}

# Vérifier chaque application
check_app_status "math4kids" 3001
check_app_status "unitflip" 3002
check_app_status "budgetcron" 3003
check_app_status "ai4kids" 3004
check_app_status "multiai" 3005

# Résumé global
echo -e "${BLUE}📋 RÉSUMÉ GLOBAL${NC}"
echo -e "${BLUE}===============${NC}"

apps=("math4kids:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")
running=0

for app_port in "${apps[@]}"; do
    port="${app_port#*:}"
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        running=$((running + 1))
    fi
done

echo -e "🚀 Applications actives: ${GREEN}$running/5${NC}"

if [ $running -eq 5 ]; then
    echo -e "${GREEN}🎉 Toutes les applications fonctionnent!${NC}"
elif [ $running -eq 0 ]; then
    echo -e "${YELLOW}💡 Démarrez avec: ./start-apps.sh${NC}"
else
    echo -e "${YELLOW}⚠️ Redémarrage complet recommandé: ./stop-apps.sh && ./start-apps.sh${NC}"
fi

echo ""
echo -e "${YELLOW}📋 Actions disponibles:${NC}"
echo "  🚀 Démarrer: ./start-apps.sh"
echo "  🛑 Arrêter:  ./stop-apps.sh"
echo "  📝 Logs:     ls $LOG_DIR"
echo ""
