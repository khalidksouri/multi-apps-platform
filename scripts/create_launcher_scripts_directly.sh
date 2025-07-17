#!/bin/bash

# Créer directement les scripts de lancement dans le projet
set -e

PROJECT_DIR="$(pwd)"
WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

echo "🚀 Création des scripts de lancement..."
echo "📁 Projet: $PROJECT_DIR"
echo "📁 Workspace: $WORKSPACE_DIR"

# 1. Créer start-apps.sh
cat > start-apps.sh << 'EOF'
#!/bin/bash

# Script de démarrage des applications depuis multi-apps-platform
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
LOG_DIR="$WORKSPACE_DIR/logs"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$LOG_DIR"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 DÉMARRAGE DU MULTI-APPS-PLATFORM${NC}"
echo -e "${BLUE}===================================${NC}"
echo ""

# Fonction de logging
log() {
    echo -e "${2:-$NC}[$1] $3${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $3" >> "$LOG_DIR/startup.log"
}

# Fonction pour démarrer une application
start_app() {
    local app_name=$1
    local port=$2
    local command=$3
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    log "INFO" "$YELLOW" "Démarrage de $app_name sur le port $port..."
    
    if [ ! -d "$app_dir" ]; then
        log "ERROR" "$RED" "Répertoire $app_name non trouvé: $app_dir"
        return 1
    fi
    
    cd "$app_dir"
    
    # Vérifier si le port est libre
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        log "WARNING" "$YELLOW" "Port $port déjà utilisé, tentative d'arrêt..."
        local pid=$(lsof -ti:$port)
        kill -9 $pid 2>/dev/null || true
        sleep 2
    fi
    
    # Vérifier node_modules
    if [ ! -d "$app_dir/node_modules" ]; then
        log "WARNING" "$YELLOW" "node_modules manquant pour $app_name, installation..."
        npm install --legacy-peer-deps
    fi
    
    # Démarrer l'application
    $command > "$LOG_DIR/${app_name}.log" 2>&1 &
    local pid=$!
    echo $pid > "$LOG_DIR/${app_name}.pid"
    
    # Attendre le démarrage
    sleep 8
    
    if kill -0 $pid 2>/dev/null; then
        log "SUCCESS" "$GREEN" "$app_name démarré (PID: $pid) - http://localhost:$port"
        return 0
    else
        log "ERROR" "$RED" "$app_name a échoué au démarrage"
        return 1
    fi
}

# Démarrage des applications
start_app "math4kids" 3001 "npm start"
sleep 3
start_app "unitflip" 3002 "npm start"
sleep 3
start_app "budgetcron" 3003 "npm run serve"
sleep 3
start_app "ai4kids" 3004 "npm start"
sleep 3
start_app "multiai" 3005 "npm run dev"

echo ""
echo -e "${GREEN}🎉 DÉMARRAGE TERMINÉ!${NC}"
echo ""
echo -e "${YELLOW}📱 URLs des applications:${NC}"
echo "  📚 Math4Kids:  http://localhost:3001"
echo "  🔄 UnitFlip:   http://localhost:3002"
echo "  💰 BudgetCron: http://localhost:3003"
echo "  🤖 AI4Kids:   http://localhost:3004"
echo "  🧠 MultiAI:    http://localhost:3005"
echo ""
echo -e "${YELLOW}📋 Gestion:${NC}"
echo "  🛑 Arrêt:      ./stop-apps.sh"
echo "  📊 Statut:     ./status-apps.sh"
echo "  📝 Logs:       ls $LOG_DIR"
echo ""
EOF

chmod +x start-apps.sh
echo "✅ start-apps.sh créé"

# 2. Créer stop-apps.sh
cat > stop-apps.sh << 'EOF'
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
EOF

chmod +x stop-apps.sh
echo "✅ stop-apps.sh créé"

# 3. Créer status-apps.sh
cat > status-apps.sh << 'EOF'
#!/bin/bash

# Script de statut des applications depuis multi-apps-platform
set -e

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

local apps=("math4kids:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")
local running=0

for app_port in "${apps[@]}"; do
    local port="${app_port#*:}"
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
EOF

chmod +x status-apps.sh
echo "✅ status-apps.sh créé"

# 4. Créer un script de diagnostic pour les applications React
cat > fix-react-apps.sh << 'EOF'
#!/bin/bash

# Script de diagnostic et correction pour les applications React
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

echo "🔧 CORRECTION DES APPLICATIONS REACT"
echo "====================================="

# Applications React avec problèmes de build
react_apps=("math4kids" "unitflip" "ai4kids")

for app in "${react_apps[@]}"; do
    app_dir="$WORKSPACE_DIR/$app"
    
    if [ -d "$app_dir" ]; then
        echo ""
        echo "🔧 Correction de $app..."
        cd "$app_dir"
        
        # Recréer package.json minimal fonctionnel
        cat > package.json << PACKAGE_EOF
{
  "name": "$app",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "typescript": "^4.9.5"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app"
    ]
  },
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
  }
}
PACKAGE_EOF
        
        # Nettoyer et réinstaller
        rm -rf node_modules package-lock.json
        npm install --legacy-peer-deps --no-audit
        
        echo "✅ $app corrigé"
    fi
done

echo ""
echo "🎉 Correction terminée! Les applications React devraient maintenant démarrer."
echo "💡 Testez avec: ./start-apps.sh"
EOF

chmod +x fix-react-apps.sh
echo "✅ fix-react-apps.sh créé"

echo ""
echo "🎉 TOUS LES SCRIPTS CRÉÉS!"
echo ""
echo "📋 Scripts disponibles:"
echo "  🚀 ./start-apps.sh     - Démarrer toutes les applications"
echo "  🛑 ./stop-apps.sh      - Arrêter toutes les applications"
echo "  📊 ./status-apps.sh    - Vérifier le statut"
echo "  🔧 ./fix-react-apps.sh - Corriger les apps React (si problème)"
echo ""
echo "💡 Prochaines étapes:"
echo "1. Corriger les apps React: ./fix-react-apps.sh"
echo "2. Démarrer les applications: ./start-apps.sh"
echo "3. Vérifier le statut: ./status-apps.sh"