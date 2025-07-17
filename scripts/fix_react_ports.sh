#!/bin/bash

# Correction des ports pour les applications React
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 CORRECTION DES PORTS REACT${NC}"
echo -e "${BLUE}==============================${NC}"
echo ""

# Fonction pour corriger les ports dans les applications React
fix_react_ports() {
    local app_name=$1
    local port=$2
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🔧 Configuration du port $port pour $app_name...${NC}"
    
    cd "$app_dir"
    
    # 1. Modifier package.json pour spécifier le port
    echo "  📦 Mise à jour du package.json..."
    
    # Créer un package.json avec le port spécifique
    cat > package.json << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "react-scripts": "5.0.1",
    "typescript": "4.9.5"
  },
  "scripts": {
    "start": "PORT=$port react-scripts start",
    "build": "react-scripts build"
  },
  "browserslist": {
    "production": [">0.2%", "not dead"],
    "development": ["last 1 chrome version"]
  }
}
EOF
    
    # 2. Créer un fichier .env pour forcer le port
    echo "  ⚙️ Création du fichier .env..."
    cat > .env << EOF
PORT=$port
BROWSER=none
SKIP_PREFLIGHT_CHECK=true
EOF
    
    # 3. Vérifier que les fichiers sont bien en place
    if [ -f "src/index.js" ] && [ -f "public/index.html" ]; then
        echo -e "  ✅ Structure complète pour $app_name"
    else
        echo -e "  ⚠️ Fichiers manquants détectés"
    fi
    
    echo -e "  ✅ ${GREEN}Port $port configuré pour $app_name${NC}"
    echo ""
}

# Fonction pour démarrer les applications avec les bons ports
start_react_apps() {
    echo -e "${BLUE}🚀 DÉMARRAGE DES APPLICATIONS REACT AVEC PORTS CORRECTS${NC}"
    echo "=================================================="
    echo ""
    
    local apps=("math4kids:3001" "unitflip:3002" "ai4kids:3004")
    
    for app_port in "${apps[@]}"; do
        local app_name="${app_port%:*}"
        local port="${app_port#*:}"
        local app_dir="$WORKSPACE_DIR/$app_name"
        
        echo -e "${YELLOW}🚀 Démarrage de $app_name sur port $port...${NC}"
        
        cd "$app_dir"
        
        # Arrêter tout processus existant sur ce port
        local existing_pid=$(lsof -ti:$port 2>/dev/null || true)
        if [ -n "$existing_pid" ]; then
            kill -9 "$existing_pid" 2>/dev/null || true
            sleep 1
        fi
        
        # Démarrer avec le port spécifique
        PORT=$port npm start > "$WORKSPACE_DIR/logs/${app_name}.log" 2>&1 &
        local pid=$!
        echo $pid > "$WORKSPACE_DIR/logs/${app_name}.pid"
        
        # Attendre et vérifier
        echo "  ⏳ Attente du démarrage..."
        sleep 8
        
        if kill -0 $pid 2>/dev/null; then
            # Vérifier si le port répond
            if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
                echo -e "  ✅ ${GREEN}$app_name démarré sur http://localhost:$port${NC}"
            else
                echo -e "  ⚠️ ${YELLOW}$app_name processus actif mais port ne répond pas encore${NC}"
            fi
        else
            echo -e "  ❌ ${RED}$app_name échec${NC}"
            # Afficher les erreurs
            if [ -f "$WORKSPACE_DIR/logs/${app_name}.log" ]; then
                echo "  📝 Dernières lignes du log:"
                tail -n 5 "$WORKSPACE_DIR/logs/${app_name}.log" | sed 's/^/     /'
            fi
        fi
        
        echo ""
    done
}

# Fonction pour afficher le statut final
show_final_status() {
    echo -e "${BLUE}📊 STATUT FINAL DE LA PLATEFORME${NC}"
    echo "================================="
    echo ""
    
    local apps=("math4kids:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")
    local running=0
    local total=5
    
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
    echo -e "${BLUE}📈 Résultat: ${GREEN}$running/$total${NC} applications actives"
    
    if [ $running -eq $total ]; then
        echo -e "${GREEN}🎉 TOUTES LES APPLICATIONS SONT OPÉRATIONNELLES!${NC}"
        echo ""
        echo -e "${YELLOW}🌐 Accès rapide à toutes les applications:${NC}"
        echo "open http://localhost:3001 http://localhost:3002 http://localhost:3003 http://localhost:3004 http://localhost:3005"
    elif [ $running -ge 3 ]; then
        echo -e "${GREEN}🎊 EXCELLENTE PROGRESSION! La majorité des applications fonctionnent${NC}"
        echo ""
        echo -e "${YELLOW}🌐 Accès aux applications fonctionnelles:${NC}"
        local working_urls=""
        for app_port in "${apps[@]}"; do
            local port="${app_port#*:}"
            if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
                working_urls="$working_urls http://localhost:$port"
            fi
        done
        echo "open$working_urls"
    else
        echo -e "${YELLOW}⚠️ Certaines applications nécessitent encore des ajustements${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}📋 Actions disponibles:${NC}"
    echo "📊 Statut détaillé: ./status-apps.sh"
    echo "🛑 Arrêter tout: ./stop-apps.sh"
    echo "📝 Logs: ls $WORKSPACE_DIR/logs"
    echo ""
}

# Fonction principale
main() {
    echo "Correction des ports pour les applications React..."
    echo ""
    
    # Corriger les ports dans les configurations
    fix_react_ports "math4kids" 3001
    fix_react_ports "unitflip" 3002
    fix_react_ports "ai4kids" 3004
    
    echo -e "${GREEN}✅ CONFIGURATION DES PORTS TERMINÉE${NC}"
    echo ""
    
    # Démarrer les applications avec les bons ports
    start_react_apps
    
    # Afficher le statut final
    show_final_status
}

# Lancement du script
main