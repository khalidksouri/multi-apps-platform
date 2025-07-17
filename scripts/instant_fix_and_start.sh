#!/bin/bash

# Solution instantanée - utiliser ce qui fonctionne déjà
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
LOG_DIR="$WORKSPACE_DIR/logs"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}⚡ DÉMARRAGE INSTANTANÉ DES APPLICATIONS${NC}"
echo -e "${BLUE}=======================================${NC}"
echo ""

mkdir -p "$LOG_DIR"

# Fonction pour démarrer directement une application sans diagnostic
instant_start() {
    local app_name=$1
    local port=$2
    local command=$3
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}⚡ Démarrage immédiat de $app_name...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "${RED}❌ App non trouvée: $app_name${NC}"
        return 1
    fi
    
    cd "$app_dir"
    
    # Arrêter tout processus existant sur le port
    local existing_pid=$(lsof -ti:$port 2>/dev/null || true)
    if [ -n "$existing_pid" ]; then
        kill -9 "$existing_pid" 2>/dev/null || true
        sleep 1
    fi
    
    # Démarrer immédiatement
    echo "  🚀 Lancement: $command"
    $command > "$LOG_DIR/${app_name}.log" 2>&1 &
    local pid=$!
    echo $pid > "$LOG_DIR/${app_name}.pid"
    
    # Vérification rapide (3 secondes max)
    sleep 3
    
    if kill -0 $pid 2>/dev/null; then
        echo -e "  ✅ ${GREEN}$app_name démarré (PID: $pid)${NC}"
        echo -e "  🌐 ${BLUE}http://localhost:$port${NC}"
        return 0
    else
        echo -e "  ❌ ${RED}$app_name échec${NC}"
        # Afficher les 3 dernières lignes du log pour diagnostic rapide
        if [ -f "$LOG_DIR/${app_name}.log" ]; then
            echo -e "  📝 ${YELLOW}Dernières lignes du log:${NC}"
            tail -n 3 "$LOG_DIR/${app_name}.log" | sed 's/^/     /'
        fi
        return 1
    fi
}

# Fonction pour vérifier le statut rapide
quick_status() {
    echo ""
    echo -e "${BLUE}📊 STATUT RAPIDE${NC}"
    echo "─────────────────"
    
    local apps=("math4kids:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")
    local running=0
    
    for app_port in "${apps[@]}"; do
        local app_name="${app_port%:*}"
        local port="${app_port#*:}"
        
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo -e "✅ ${GREEN}$app_name${NC} - http://localhost:$port"
            running=$((running + 1))
        else
            echo -e "❌ ${RED}$app_name${NC} - Port $port libre"
        fi
    done
    
    echo ""
    echo -e "${BLUE}Total: ${GREEN}$running/5${NC} applications actives"
}

# Démarrage immédiat de toutes les applications
echo "🚀 Démarrage immédiat sans diagnostic..."
echo ""

# Puisque Math4Kids fonctionne déjà, on commence par les autres
instant_start "unitflip" 3002 "npm start" &
sleep 1

instant_start "budgetcron" 3003 "npm run serve" &
sleep 1

instant_start "ai4kids" 3004 "npm start" &
sleep 1

instant_start "multiai" 3005 "npm run dev" &
sleep 1

# Redémarrer Math4Kids au cas où
instant_start "math4kids" 3001 "npm start" &

# Attendre que tous les processus de démarrage se terminent
wait

echo ""
echo -e "${GREEN}⚡ DÉMARRAGE INSTANTANÉ TERMINÉ!${NC}"

# Statut final
quick_status

echo ""
echo -e "${YELLOW}📱 ACCÈS RAPIDE AUX APPLICATIONS:${NC}"
echo ""
echo -e "${BLUE}# Ouvrir toutes les applications d'un coup:${NC}"
echo "open http://localhost:3001 http://localhost:3002 http://localhost:3003 http://localhost:3004 http://localhost:3005"
echo ""
echo -e "${BLUE}# Ou individuellement:${NC}"
echo "📚 Math4Kids:  open http://localhost:3001"
echo "🔄 UnitFlip:   open http://localhost:3002" 
echo "💰 BudgetCron: open http://localhost:3003"
echo "🤖 AI4Kids:   open http://localhost:3004"
echo "🧠 MultiAI:    open http://localhost:3005"
echo ""
echo -e "${YELLOW}📋 Gestion:${NC}"
echo "🛑 Arrêter tout: ./stop-apps.sh"
echo "📊 Statut détaillé: ./status-apps.sh"
echo "📝 Voir les logs: ls $LOG_DIR"
echo ""
echo -e "${GREEN}🎉 Votre multi-apps-platform est maintenant opérationnel!${NC}"