#!/bin/bash

# 🚀 Script de démarrage optimisé pour toutes les applications I18n
echo "🌍 Démarrage de toutes les applications multilingues..."

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")
PORTS=(3001 3002 3003 3004 3005)
PIDS=()

# Fonction pour nettoyer les processus en arrière-plan
cleanup() {
    echo -e "\n${YELLOW}🛑 Arrêt des applications...${NC}"
    for pid in "${PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            echo -e "${BLUE}Processus $pid arrêté${NC}"
        fi
    done
    echo -e "${GREEN}✅ Toutes les applications ont été arrêtées${NC}"
    exit 0
}

# Intercepter Ctrl+C
trap cleanup SIGINT SIGTERM

# Fonction pour vérifier si un port est libre
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Port $port déjà utilisé${NC}"
        return 1
    fi
    return 0
}

# Fonction pour démarrer une application
start_app() {
    local app=$1
    local port=$2
    local index=$3
    
    echo -e "${CYAN}🚀 Démarrage de $app sur le port $port...${NC}"
    
    if [ ! -d "apps/$app" ]; then
        echo -e "${RED}❌ Répertoire apps/$app non trouvé${NC}"
        return 1
    fi
    
    # Vérifier si le port est libre
    if ! check_port $port; then
        echo -e "${YELLOW}💡 Tentative d'arrêt du processus sur le port $port...${NC}"
        lsof -ti:$port | xargs kill -9 2>/dev/null || true
        sleep 2
    fi
    
    cd "apps/$app"
    
    # Vérifier si node_modules existe
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}📦 Installation des dépendances pour $app...${NC}"
        npm install --silent
    fi
    
    # Démarrer l'application
    echo -e "${BLUE}▶️  Lancement de $app...${NC}"
    npm run dev > "../logs/$app.log" 2>&1 &
    local pid=$!
    PIDS+=($pid)
    
    cd ../..
    
    # Attendre que l'application démarre
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s "http://localhost:$port" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $app démarré avec succès sur http://localhost:$port${NC}"
            return 0
        fi
        sleep 1
        ((attempt++))
    done
    
    echo -e "${RED}❌ Échec du démarrage de $app${NC}"
    return 1
}

# Créer le répertoire de logs
mkdir -p logs

# Démarrer toutes les applications
echo -e "${BLUE}🔄 Démarrage des applications...${NC}"
for i in "${!APPS[@]}"; do
    start_app "${APPS[$i]}" "${PORTS[$i]}" "$i"
    sleep 3  # Délai entre chaque démarrage
done

echo ""
echo -e "${GREEN}🎉 Toutes les applications sont en cours de démarrage!${NC}"
echo ""
echo -e "${CYAN}📱 URLs des applications:${NC}"
echo -e "  • ${BLUE}PostMath Pro${NC}:  http://localhost:3001"
echo -e "  • ${BLUE}UnitFlip Pro${NC}:  http://localhost:3002"
echo -e "  • ${BLUE}BudgetCron${NC}:    http://localhost:3003"
echo -e "  • ${BLUE}AI4Kids${NC}:       http://localhost:3004"
echo -e "  • ${BLUE}MultiAI${NC}:       http://localhost:3005"
echo ""
echo -e "${YELLOW}🌍 Fonctionnalités I18n disponibles:${NC}"
echo -e "  ✅ ${GREEN}30+ langues${NC} de tous les continents"
echo -e "  ✅ ${GREEN}Persistance automatique${NC} de la langue"
echo -e "  ✅ ${GREEN}Synchronisation inter-onglets${NC}"
echo -e "  ✅ ${GREEN}Support RTL${NC} (Arabe, Hébreu, etc.)"
echo -e "  ✅ ${GREEN}Détection automatique${NC} de langue"
echo ""
echo -e "${BLUE}🎯 Test rapide:${NC}"
echo "1. Ouvrez une des URLs ci-dessus"
echo "2. Changez la langue avec le sélecteur en haut à droite"
echo "3. Naviguez dans l'application → la langue reste active!"
echo "4. Ouvrez un nouvel onglet → même langue partout!"
echo ""
echo -e "${YELLOW}📊 Logs disponibles dans le dossier 'logs/'${NC}"
echo -e "${RED}🛑 Appuyez sur Ctrl+C pour arrêter toutes les applications${NC}"
echo ""

# Attendre indéfiniment
wait
