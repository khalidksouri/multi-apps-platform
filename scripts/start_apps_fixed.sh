#!/bin/bash

# =============================================
# 🚀 Script de démarrage corrigé
# =============================================

echo "🚀 Démarrage des applications MultiApps"
echo "======================================="

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour démarrer une application
start_app() {
    local app_name=$1
    local port=$2
    local base_dir=$(pwd)
    
    echo "🚀 Démarrage de $app_name sur le port $port..."
    
    # Aller dans le dossier de l'application
    cd "$base_dir/apps/$app_name"
    
    # Démarrer l'application en arrière-plan
    npm run dev > "/tmp/$app_name.log" 2>&1 &
    local app_pid=$!
    
    # Revenir au dossier de base
    cd "$base_dir"
    
    # Sauvegarder le PID
    echo $app_pid > "/tmp/$app_name.pid"
    
    # Attendre que l'application soit prête
    echo "⏳ Attente de $app_name..."
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -f -s "http://localhost:$port/api/health" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $app_name: Prêt sur http://localhost:$port${NC}"
            return 0
        fi
        
        sleep 2
        attempt=$((attempt + 1))
        echo -n "."
    done
    
    echo -e "${RED}❌ $app_name: Timeout après ${max_attempts} tentatives${NC}"
    return 1
}

# Démarrer toutes les applications
echo "🌟 Démarrage des 5 applications..."
start_app "postmath" 3001
start_app "unitflip" 3002
start_app "budgetcron" 3003
start_app "ai4kids" 3004
start_app "multiai" 3005

echo ""
echo "📊 Statut final des applications :"
echo "=================================="
apps=("postmath:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")
ready_count=0

for app_port in "${apps[@]}"; do
    IFS=':' read -r app port <<< "$app_port"
    if curl -f -s "http://localhost:$port/api/health" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $app: http://localhost:$port${NC}"
        ready_count=$((ready_count + 1))
    else
        echo -e "${RED}❌ $app: Non disponible${NC}"
    fi
done

echo ""
echo "🎯 Applications prêtes: $ready_count/5"

if [ $ready_count -eq 5 ]; then
    echo -e "${GREEN}🎉 Toutes les applications sont prêtes !${NC}"
    echo ""
    echo "🧪 Lancement des tests..."
    npm run test
else
    echo -e "${YELLOW}⚠️ Certaines applications ne sont pas prêtes${NC}"
fi
