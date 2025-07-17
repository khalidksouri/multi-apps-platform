#!/bin/bash

# Script d'installation simple du gestionnaire de plateforme
# Tout reste dans multi-apps-platform

set -e

PROJECT_DIR="$(pwd)"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}🛠️ INSTALLATION DU GESTIONNAIRE SIMPLE${NC}"
echo -e "${PURPLE}=======================================${NC}"
echo ""
echo -e "${BLUE}📁 Installation dans: $PROJECT_DIR${NC}"
echo ""

# 1. Créer le gestionnaire principal
echo -e "${YELLOW}📝 Création du gestionnaire apps.sh...${NC}"

# Copier le script complet dans apps.sh
cat > apps.sh << 'APPS_EOF'
#!/bin/bash

# =============================================================================
# GESTIONNAIRE SIMPLIFIÉ MULTI-APPS PLATFORM (6 APPLICATIONS)
# =============================================================================
# Tout se passe depuis multi-apps-platform - Logs dans le projet
# =============================================================================

set -e

# Configuration - TOUT dans le projet
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
LOG_DIR="$PROJECT_DIR/logs"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Applications de la plateforme
declare -A APPS=(
    ["math4kids"]="3001:npm start"
    ["unitflip"]="3002:npm start"
    ["budgetcron"]="3003:npm run serve"
    ["ai4kids"]="3004:npm start"
    ["multiai"]="3005:npm run dev"
    ["digital4kids"]="3006:npm start"
)

# =============================================================================
# FONCTIONS DE BASE
# =============================================================================

# Fonction de logging
log() {
    local level=$1
    local color=$2
    local message=$3
    echo -e "${color}[${level}] ${message}${NC}"
    
    # Créer le dossier de logs dans le projet
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] ${message}" >> "$LOG_DIR/platform.log"
}

# Header simplifié
show_header() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║        🚀 MULTI-APPS PLATFORM - 6 APPLICATIONS 🚀               ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📁 Projet: ${PROJECT_DIR}${NC}"
    echo -e "${CYAN}📋 Logs: ${LOG_DIR}${NC}"
    echo ""
}

# =============================================================================
# FONCTIONS DE GESTION DES APPLICATIONS
# =============================================================================

# Démarrer une application
start_app() {
    local app_name=$1
    local app_info="${APPS[$app_name]}"
    local port="${app_info%:*}"
    local command="${app_info#*:}"
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🚀 Démarrage de $app_name (port $port)...${NC}"
    
    # Vérifier que l'application existe
    if [ ! -d "$app_dir" ]; then
        echo -e "  ❌ Répertoire manquant: $app_dir"
        return 1
    fi
    
    cd "$app_dir"
    
    # Vérifier node_modules
    if [ ! -d "node_modules" ]; then
        echo -e "  📦 Installation des dépendances..."
        npm install --legacy-peer-deps --silent
    fi
    
    # Libérer le port si occupé
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "  🔌 Libération du port $port..."
        local existing_pid=$(lsof -ti:$port)
        kill -9 "$existing_pid" 2>/dev/null || true
        sleep 2
    fi
    
    # Créer le dossier de logs dans le projet
    mkdir -p "$LOG_DIR"
    
    # Démarrer l'application
    echo -e "  ▶️ Lancement: $command"
    PORT=$port BROWSER=none $command > "$LOG_DIR/${app_name}.log" 2>&1 &
    local pid=$!
    
    # Sauvegarder le PID dans le projet
    echo "$pid" > "$LOG_DIR/${app_name}.pid"
    
    # Attendre que l'application soit prête
    echo -e "  ⏳ Attente du démarrage (PID: $pid)..."
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s -f "http://localhost:$port" >/dev/null 2>&1; then
            echo -e "  ${GREEN}✅ $app_name démarré! - http://localhost:$port${NC}"
            log "SUCCESS" "$GREEN" "$app_name démarré sur le port $port"
            return 0
        fi
        
        # Vérifier si le processus existe encore
        if ! ps -p $pid >/dev/null 2>&1; then
            echo -e "  ${RED}❌ Le processus s'est arrêté${NC}"
            return 1
        fi
        
        sleep 2
        attempt=$((attempt + 1))
        
        if [ $attempt -eq 15 ]; then
            echo -e "  ⏰ Démarrage en cours..."
        fi
    done
    
    echo -e "  ${RED}❌ Échec du démarrage après $max_attempts tentatives${NC}"
    return 1
}

# Arrêter une application
stop_app() {
    local app_name=$1
    local app_info="${APPS[$app_name]}"
    local port="${app_info%:*}"
    
    echo -e "${YELLOW}🛑 Arrêt de $app_name...${NC}"
    
    # Arrêter par PID
    local pid_file="$LOG_DIR/${app_name}.pid"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" >/dev/null 2>&1; then
            echo -e "  📋 Arrêt du processus $pid..."
            kill -TERM "$pid" 2>/dev/null || true
            sleep 2
            
            if ps -p "$pid" >/dev/null 2>&1; then
                kill -9 "$pid" 2>/dev/null || true
            fi
        fi
        rm -f "$pid_file"
    fi
    
    # Libérer le port
    local port_pid=$(lsof -ti:$port 2>/dev/null || true)
    if [ -n "$port_pid" ]; then
        kill -9 "$port_pid" 2>/dev/null || true
    fi
    
    echo -e "  ${GREEN}✅ $app_name arrêté${NC}"
}

# Vérifier le statut d'une application
check_app_status() {
    local app_name=$1
    local app_info="${APPS[$app_name]}"
    local port="${app_info%:*}"
    
    if curl -s -f "http://localhost:$port" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ $app_name${NC} - http://localhost:$port"
        
        # Afficher le PID si disponible
        local pid_file="$LOG_DIR/${app_name}.pid"
        if [ -f "$pid_file" ]; then
            local pid=$(cat "$pid_file")
            if ps -p "$pid" >/dev/null 2>&1; then
                echo -e "   📋 PID: $pid"
            fi
        fi
        
        return 0
    else
        echo -e "${RED}❌ $app_name${NC} - Non actif"
        return 1
    fi
}

# =============================================================================
# FONCTIONS PRINCIPALES
# =============================================================================

# Démarrer toutes les applications
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
    
    if ! command -v npm >/dev/null 2>&1; then
        echo -e "${RED}❌ npm n'est pas installé${NC}"
        exit 1
    fi
    
    if [ ! -d "$WORKSPACE_DIR" ]; then
        echo -e "${RED}❌ Workspace non trouvé: $WORKSPACE_DIR${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Prérequis validés${NC}"
    echo ""
    
    # Démarrer chaque application dans l'ordre
    local apps_order=("math4kids" "unitflip" "budgetcron" "ai4kids" "multiai" "digital4kids")
    local started_apps=0
    
    for app_name in "${apps_order[@]}"; do
        if start_app "$app_name"; then
            started_apps=$((started_apps + 1))
        fi
        echo ""
        sleep 3  # Petite pause entre les démarrages
    done
    
    # Attendre la stabilisation
    echo -e "${BLUE}⏳ Stabilisation (10 secondes)...${NC}"
    sleep 10
    
    # Vérification finale
    echo ""
    echo -e "${BLUE}🎊 RÉSULTAT FINAL${NC}"
    echo -e "${BLUE}=================${NC}"
    echo ""
    
    check_all_status
}

# Arrêter toutes les applications
stop_all_apps() {
    show_header
    echo -e "${RED}🛑 ARRÊT DE TOUTES LES APPLICATIONS${NC}"
    echo -e "${RED}==================================${NC}"
    echo ""
    
    for app_name in "${!APPS[@]}"; do
        stop_app "$app_name"
    done
    
    # Nettoyage des processus résiduels
    echo ""
    echo -e "${YELLOW}🧹 Nettoyage final...${NC}"
    pkill -f "react-scripts start" 2>/dev/null || true
    pkill -f "next dev" 2>/dev/null || true
    pkill -f "vue-cli-service serve" 2>/dev/null || true
    
    echo -e "${GREEN}🎉 Arrêt complet terminé${NC}"
    echo ""
}

# Vérifier le statut de toutes les applications
check_all_status() {
    local running_apps=0
    local total_apps=${#APPS[@]}
    local working_urls=""
    
    for app_name in math4kids unitflip budgetcron ai4kids multiai digital4kids; do
        if check_app_status "$app_name"; then
            running_apps=$((running_apps + 1))
            local port="${APPS[$app_name]%:*}"
            working_urls="$working_urls http://localhost:$port"
        fi
        echo ""
    done
    
    echo -e "${BLUE}📊 RÉSUMÉ${NC}"
    echo -e "${BLUE}=========${NC}"
    echo -e "🎯 Applications actives: ${GREEN}$running_apps/$total_apps${NC}"
    echo -e "📈 Taux de réussite: ${GREEN}$(( running_apps * 100 / total_apps ))%${NC}"
    echo ""
    
    if [ $running_apps -eq $total_apps ]; then
        echo -e "🏆 ${GREEN}PLATEFORME 100% OPÉRATIONNELLE ! 🎉${NC}"
        echo ""
        echo -e "${BLUE}🌟 TOUTES VOS 6 APPLICATIONS SONT ACTIVES :${NC}"
        echo "📱 Math4Kids - Mathématiques pour enfants"
        echo "🔄 UnitFlip - Conversion d'unités"
        echo "💰 BudgetCron - Gestion budgétaire"
        echo "🤖 AI4Kids - Intelligence artificielle"
        echo "🧠 MultiAI - IA avancée"
        echo "🎯 Digital4Kids - Marketing digital"
        echo ""
        echo -e "${CYAN}🚀 ACCÈS RAPIDE :${NC}"
        echo "open$working_urls"
    elif [ $running_apps -ge 4 ]; then
        echo -e "✨ ${GREEN}Très bien ! $running_apps applications actives${NC}"
        if [ -n "$working_urls" ]; then
            echo ""
            echo -e "${CYAN}🌐 Applications disponibles :${NC}"
            echo "open$working_urls"
        fi
    else
        echo -e "⚠️ ${YELLOW}$running_apps applications seulement${NC}"
        if [ -n "$working_urls" ]; then
            echo ""
            echo -e "${CYAN}🌐 Applications disponibles :${NC}"
            echo "open$working_urls"
        fi
    fi
    
    echo ""
    echo -e "${YELLOW}📋 COMMANDES :${NC}"
    echo "🚀 Démarrer: $0 start"
    echo "🛑 Arrêter: $0 stop"
    echo "📊 Statut: $0 status"
    echo "📝 Logs: ls $LOG_DIR/"
    echo ""
}

# Afficher les logs
show_logs() {
    echo -e "${BLUE}📝 LOGS${NC}"
    echo -e "${BLUE}=======${NC}"
    echo ""
    
    if [ ! -d "$LOG_DIR" ]; then
        echo -e "${YELLOW}⚠️ Aucun log disponible${NC}"
        return
    fi
    
    echo -e "${YELLOW}📁 Répertoire: $LOG_DIR${NC}"
    echo ""
    
    for app_name in "${!APPS[@]}"; do
        local log_file="$LOG_DIR/${app_name}.log"
        if [ -f "$log_file" ]; then
            local lines=$(wc -l < "$log_file")
            echo -e "📄 ${app_name}.log - $lines lignes"
        else
            echo -e "📄 ${app_name}.log - Non trouvé"
        fi
    done
    
    echo ""
    echo -e "${CYAN}💡 Voir un log :${NC} tail -f $LOG_DIR/{app_name}.log"
    echo ""
}

# Afficher l'aide
show_help() {
    show_header
    echo -e "${CYAN}📚 AIDE${NC}"
    echo -e "${CYAN}=======${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC} $0 [commande]"
    echo ""
    echo -e "${YELLOW}Commandes:${NC}"
    echo -e "  ${GREEN}start${NC}   - Démarrer toutes les 6 applications"
    echo -e "  ${RED}stop${NC}    - Arrêter toutes les applications"
    echo -e "  ${BLUE}restart${NC} - Redémarrer toutes les applications"
    echo -e "  ${YELLOW}status${NC}  - Afficher le statut"
    echo -e "  ${CYAN}logs${NC}    - Afficher les logs"
    echo -e "  ${GREEN}help${NC}    - Cette aide"
    echo ""
    echo -e "${YELLOW}Applications (6) :${NC}"
    for app_name in math4kids unitflip budgetcron ai4kids multiai digital4kids; do
        local port="${APPS[$app_name]%:*}"
        echo -e "  🔹 $app_name (port $port)"
    done
    echo ""
    echo -e "${YELLOW}Exemples:${NC}"
    echo -e "  $0 start    # Démarrer tout"
    echo -e "  $0 status   # Voir le statut"
    echo -e "  $0 stop     # Arrêter tout"
    echo ""
}

# =============================================================================
# POINT D'ENTRÉE
# =============================================================================

main() {
    case "${1:-help}" in
        "start")
            start_all_apps
            ;;
        "stop")
            stop_all_apps
            ;;
        "restart")
            stop_all_apps
            sleep 3
            start_all_apps
            ;;
        "status")
            show_header
            echo -e "${BLUE}📊 STATUT DES APPLICATIONS${NC}"
            echo -e "${BLUE}==========================${NC}"
            echo ""
            check_all_status
            ;;
        "logs")
            show_header
            show_logs
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo -e "${RED}❌ Commande inconnue: $1${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Lancement
main "$@"
APPS_EOF

chmod +x apps.sh
echo -e "  ✅ apps.sh créé et rendu exécutable"

# 2. Créer le dossier logs
echo -e "${YELLOW}📁 Création du dossier logs...${NC}"
mkdir -p logs
echo -e "  ✅ Dossier logs/ créé dans le projet"

# 3. Créer un README simple
echo -e "${YELLOW}📚 Création du README...${NC}"

cat > README_APPS.md << 'README_EOF'
# 🚀 Multi-Apps Platform - Gestionnaire Simple

## Usage rapide

### Démarrer toutes les 6 applications
```bash
./apps.sh start
```

### Vérifier le statut
```bash
./apps.sh status
```

### Arrêter toutes les applications
```bash
./apps.sh stop
```

### Voir les logs
```bash
./apps.sh logs
ls logs/
```

## Applications (6)

- **Math4Kids** (3001) - Mathématiques pour enfants
- **UnitFlip** (3002) - Conversion d'unités
- **BudgetCron** (3003) - Gestion budgétaire
- **AI4Kids** (3004) - Intelligence artificielle
- **MultiAI** (3005) - IA avancée
- **Digital4Kids** (3006) - Marketing digital

## Structure

```
multi-apps-platform/
├── apps.sh              # Gestionnaire principal
├── logs/                 # Logs de toutes les applications
│   ├── math4kids.log
│   ├── unitflip.log
│   ├── budgetcron.log
│   ├── ai4kids.log
│   ├── multiai.log
│   ├── digital4kids.log
│   ├── math4kids.pid     # PIDs des processus
│   └── platform.log     # Log principal
└── README_APPS.md        # Cette documentation
```

## Commandes disponibles

- `./apps.sh start` - Démarrer tout
- `./apps.sh stop` - Arrêter tout
- `./apps.sh restart` - Redémarrer tout
- `./apps.sh status` - Voir le statut
- `./apps.sh logs` - Informations sur les logs
- `./apps.sh help` - Aide complète

## Tout se passe dans le projet !

✅ Logs dans `multi-apps-platform/logs/`  
✅ PIDs dans `multi-apps-platform/logs/`  
✅ Gestion depuis `multi-apps-platform/`  
✅ Un seul script `apps.sh` pour tout gérer  

---

**🎯 Simple et efficace !**
README_EOF

echo -e "  ✅ README_APPS.md créé"

# 4. Test de base
echo -e "${YELLOW}🧪 Test de base...${NC}"
if [ -x "apps.sh" ]; then
    echo -e "  ✅ apps.sh est exécutable"
else
    echo -e "  ❌ Problème avec apps.sh"
fi

if [ -d "logs" ]; then
    echo -e "  ✅ Dossier logs créé"
else
    echo -e "  ❌ Problème avec le dossier logs"
fi

# 5. Message final
echo ""
echo -e "${GREEN}🎉 INSTALLATION TERMINÉE !${NC}"
echo ""
echo -e "${BLUE}📋 Ce qui a été créé :${NC}"
echo "✅ apps.sh - Gestionnaire principal"
echo "✅ logs/ - Dossier pour tous les logs"
echo "✅ README_APPS.md - Documentation"
echo ""
echo -e "${YELLOW}🚀 UTILISATION :${NC}"
echo ""
echo -e "${CYAN}1. Démarrer toutes les 6 applications :${NC}"
echo "   ./apps.sh start"
echo ""
echo -e "${CYAN}2. Voir le statut :${NC}"
echo "   ./apps.sh status"
echo ""
echo -e "${CYAN}3. Arrêter tout :${NC}"
echo "   ./apps.sh stop"
echo ""
echo -e "${CYAN}4. Voir l'aide :${NC}"
echo "   ./apps.sh help"
echo ""
echo -e "${PURPLE}🎯 TOUT RESTE DANS LE PROJET multi-apps-platform !${NC}"
echo -e "${PURPLE}   Logs dans: $PROJECT_DIR/logs/${NC}"
echo ""