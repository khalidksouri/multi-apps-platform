#!/bin/bash

# Script de correction complète des scripts et applications
set -e

echo "🔧 CORRECTION COMPLÈTE DES SCRIPTS ET APPLICATIONS"
echo "=================================================="

# 1. Corriger le script status-apps.sh
echo "🔧 Correction de status-apps.sh..."
cat > status-apps.sh << 'STATUSEOF'
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
STATUSEOF

chmod +x status-apps.sh
echo "✅ status-apps.sh corrigé"

# 2. Améliorer le script start-apps.sh avec diagnostic
echo "🔧 Amélioration de start-apps.sh..."
cat > start-apps.sh << 'STARTEOF'
#!/bin/bash
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
echo "📁 Projet: $PROJECT_DIR"
echo "📁 Workspace: $WORKSPACE_DIR"
echo "📋 Logs: $LOG_DIR"
echo ""

# Fonction de logging
log() {
    echo -e "${2:-$NC}[$1] $3${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $3" >> "$LOG_DIR/startup.log"
}

# Fonction pour diagnostiquer une application
diagnose_app() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🔍 Diagnostic de $app_name...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "  ❌ Répertoire non trouvé: $app_dir"
        return 1
    fi
    
    cd "$app_dir"
    
    # Vérifier package.json
    if [ ! -f "package.json" ]; then
        echo -e "  ❌ package.json manquant"
        return 1
    else
        echo -e "  ✅ package.json présent"
    fi
    
    # Vérifier node_modules
    if [ ! -d "node_modules" ]; then
        echo -e "  ⚠️ node_modules manquant - installation..."
        npm install --legacy-peer-deps --no-audit --silent
        echo -e "  ✅ node_modules installé"
    else
        echo -e "  ✅ node_modules présent"
    fi
    
    # Vérifier les fichiers source
    if [ -d "src" ] && [ -f "src/index.tsx" -o -f "src/index.ts" -o -f "src/main.ts" ]; then
        echo -e "  ✅ Fichiers source présents"
    else
        echo -e "  ⚠️ Fichiers source manquants"
    fi
    
    # Vérifier les scripts npm
    if npm run start --dry-run >/dev/null 2>&1; then
        echo -e "  ✅ Script 'start' valide"
    else
        echo -e "  ❌ Script 'start' invalide"
        return 1
    fi
    
    echo -e "  ✅ Diagnostic OK pour $app_name"
    return 0
}

# Fonction pour démarrer une application
start_app() {
    local app_name=$1
    local port=$2
    local command=$3
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    log "INFO" "$YELLOW" "Démarrage de $app_name sur le port $port..."
    
    # Diagnostic préalable
    if ! diagnose_app "$app_name"; then
        log "ERROR" "$RED" "Diagnostic échoué pour $app_name"
        return 1
    fi
    
    cd "$app_dir"
    
    # Arrêter tout processus existant sur le port
    local existing_pid=$(lsof -ti:$port 2>/dev/null || true)
    if [ -n "$existing_pid" ]; then
        log "WARNING" "$YELLOW" "Arrêt du processus existant sur le port $port (PID: $existing_pid)"
        kill -9 "$existing_pid" 2>/dev/null || true
        sleep 3
    fi
    
    # Démarrer l'application
    log "INFO" "$YELLOW" "Lancement de la commande: $command"
    $command > "$LOG_DIR/${app_name}.log" 2>&1 &
    local pid=$!
    echo $pid > "$LOG_DIR/${app_name}.pid"
    
    # Attendre le démarrage avec timeout
    log "INFO" "$YELLOW" "Attente du démarrage de $app_name (PID: $pid)..."
    local timeout=30
    local elapsed=0
    
    while [ $elapsed -lt $timeout ]; do
        if ! kill -0 $pid 2>/dev/null; then
            log "ERROR" "$RED" "$app_name s'est arrêté prématurément"
            echo -e "${RED}Dernières lignes du log:${NC}"
            tail -n 10 "$LOG_DIR/${app_name}.log" 2>/dev/null || echo "Aucun log disponible"
            return 1
        fi
        
        # Vérifier si le port répond
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            if curl -s --max-time 3 "http://localhost:$port" >/dev/null 2>&1; then
                log "SUCCESS" "$GREEN" "$app_name démarré avec succès! - http://localhost:$port"
                return 0
            fi
        fi
        
        sleep 2
        elapsed=$((elapsed + 2))
    done
    
    # Timeout atteint
    if kill -0 $pid 2>/dev/null; then
        log "WARNING" "$YELLOW" "$app_name processus actif mais port $port ne répond pas encore (timeout $timeout s)"
        return 0
    else
        log "ERROR" "$RED" "$app_name a échoué au démarrage (timeout)"
        return 1
    fi
}

# Vérifications préalables
log "INFO" "$BLUE" "Vérifications préalables..."

if ! command -v node &> /dev/null; then
    log "ERROR" "$RED" "Node.js n'est pas installé"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    log "ERROR" "$RED" "npm n'est pas installé"
    exit 1
fi

if [ ! -d "$WORKSPACE_DIR" ]; then
    log "ERROR" "$RED" "Workspace non trouvé: $WORKSPACE_DIR"
    exit 1
fi

log "SUCCESS" "$GREEN" "Prérequis validés"
echo ""

# Démarrage des applications
log "INFO" "$BLUE" "Démarrage séquentiel des applications..."
echo ""

start_app "math4kids" 3001 "npm start"
sleep 5

start_app "unitflip" 3002 "npm start"
sleep 5

start_app "budgetcron" 3003 "npm run serve"
sleep 5

start_app "ai4kids" 3004 "npm start"
sleep 5

start_app "multiai" 3005 "npm run dev"

echo ""
log "SUCCESS" "$GREEN" "Démarrage terminé!"
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

# Retourner au répertoire du projet
cd "$PROJECT_DIR"
STARTEOF

chmod +x start-apps.sh
echo "✅ start-apps.sh amélioré"

# 3. Créer un script de diagnostic avancé
echo "🔧 Création du script de diagnostic avancé..."
cat > diagnose-apps.sh << 'DIAGEOF'
#!/bin/bash

# Script de diagnostic avancé pour toutes les applications
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 DIAGNOSTIC AVANCÉ DU MULTI-APPS-PLATFORM${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

# Fonction de diagnostic détaillé
diagnose_app_detailed() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🔍 Diagnostic détaillé de $app_name${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "❌ ${RED}Répertoire non trouvé: $app_dir${NC}"
        return 1
    fi
    
    cd "$app_dir"
    
    # 1. Vérifier la structure du projet
    echo -e "${BLUE}📂 Structure du projet:${NC}"
    if [ -f "package.json" ]; then
        echo -e "  ✅ package.json présent"
        local name=$(node -p "require('./package.json').name" 2>/dev/null || echo "N/A")
        local version=$(node -p "require('./package.json').version" 2>/dev/null || echo "N/A")
        echo -e "     Nom: $name, Version: $version"
    else
        echo -e "  ❌ package.json manquant"
    fi
    
    if [ -d "node_modules" ]; then
        local modules_size=$(du -sh node_modules 2>/dev/null | cut -f1 || echo "N/A")
        echo -e "  ✅ node_modules présent ($modules_size)"
    else
        echo -e "  ❌ node_modules manquant"
    fi
    
    if [ -d "src" ]; then
        echo -e "  ✅ Dossier src présent"
        local src_files=$(find src -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.vue" | wc -l | tr -d ' ')
        echo -e "     Fichiers source: $src_files"
    else
        echo -e "  ❌ Dossier src manquant"
    fi
    
    # 2. Vérifier les dépendances
    echo -e "${BLUE}📦 Dépendances:${NC}"
    if [ -f "package.json" ]; then
        local react_version=$(node -p "require('./package.json').dependencies?.react" 2>/dev/null || echo "N/A")
        local vue_version=$(node -p "require('./package.json').dependencies?.vue" 2>/dev/null || echo "N/A")
        local next_version=$(node -p "require('./package.json').dependencies?.next" 2>/dev/null || echo "N/A")
        local ts_version=$(node -p "require('./package.json').dependencies?.typescript || require('./package.json').devDependencies?.typescript" 2>/dev/null || echo "N/A")
        
        [ "$react_version" != "N/A" ] && echo -e "  ⚛️ React: $react_version"
        [ "$vue_version" != "N/A" ] && echo -e "  💚 Vue: $vue_version"
        [ "$next_version" != "N/A" ] && echo -e "  ▲ Next.js: $next_version"
        [ "$ts_version" != "N/A" ] && echo -e "  📘 TypeScript: $ts_version"
    fi
    
    # 3. Tester les scripts npm
    echo -e "${BLUE}📜 Scripts npm:${NC}"
    if [ -f "package.json" ]; then
        local scripts=$(node -p "Object.keys(require('./package.json').scripts || {}).join(', ')" 2>/dev/null || echo "Aucun")
        echo -e "  📋 Scripts disponibles: $scripts"
        
        # Tester le script start
        if npm run start --dry-run >/dev/null 2>&1; then
            echo -e "  ✅ Script 'start' valide"
        else
            echo -e "  ❌ Script 'start' invalide"
        fi
    fi
    
    # 4. Vérifier les fichiers de configuration
    echo -e "${BLUE}⚙️ Configuration:${NC}"
    [ -f "tsconfig.json" ] && echo -e "  ✅ tsconfig.json présent" || echo -e "  ⚠️ tsconfig.json manquant"
    [ -f "next.config.js" ] && echo -e "  ✅ next.config.js présent"
    [ -f "vue.config.js" ] && echo -e "  ✅ vue.config.js présent"
    [ -f ".npmrc" ] && echo -e "  ✅ .npmrc présent"
    
    # 5. Vérifier les logs d'erreur récents
    echo -e "${BLUE}📝 Logs récents:${NC}"
    local log_file="$WORKSPACE_DIR/logs/${app_name}.log"
    if [ -f "$log_file" ]; then
        local log_size=$(du -h "$log_file" | cut -f1)
        echo -e "  📄 Log disponible ($log_size)"
        
        # Vérifier les erreurs récentes
        local errors=$(tail -n 50 "$log_file" 2>/dev/null | grep -i "error\|failed\|exception" | wc -l | tr -d ' ')
        if [ "$errors" -gt 0 ]; then
            echo -e "  ⚠️ $errors erreurs récentes trouvées"
            echo -e "  🔍 Dernières erreurs:"
            tail -n 50 "$log_file" 2>/dev/null | grep -i "error\|failed\|exception" | tail -n 3 | sed 's/^/     /'
        else
            echo -e "  ✅ Aucune erreur récente"
        fi
    else
        echo -e "  ⚠️ Aucun log disponible"
    fi
    
    echo ""
    return 0
}

# Diagnostiquer toutes les applications
apps=("math4kids" "unitflip" "budgetcron" "ai4kids" "multiai")

for app in "${apps[@]}"; do
    diagnose_app_detailed "$app"
done

# Résumé des recommandations
echo -e "${BLUE}💡 RECOMMANDATIONS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}Pour les applications qui ne démarrent pas:${NC}"
echo "1. Vérifiez les logs: ls $WORKSPACE_DIR/logs/"
echo "2. Réinstallez les dépendances: cd app_dir && npm install --legacy-peer-deps"
echo "3. Vérifiez la configuration TypeScript"
echo "4. Testez le build: npm run build"
echo ""
echo -e "${YELLOW}Scripts disponibles:${NC}"
echo "🔧 ./fix-react-apps.sh  - Corriger les apps React"
echo "🚀 ./start-apps.sh      - Démarrer les applications"
echo "📊 ./status-apps.sh     - Vérifier le statut"
echo ""
DIAGEOF

chmod +x diagnose-apps.sh
echo "✅ diagnose-apps.sh créé"

echo ""
echo "🎉 CORRECTION TERMINÉE!"
echo ""
echo "📋 Scripts mis à jour:"
echo "  ✅ status-apps.sh    - Corrigé (erreur 'local' résolue)"
echo "  ✅ start-apps.sh     - Amélioré avec diagnostic"
echo "  ✅ diagnose-apps.sh  - Nouveau script de diagnostic"
echo ""
echo "💡 Prochaines étapes recommandées:"
echo "1. Diagnostic complet: ./diagnose-apps.sh"
echo "2. Correction React:   ./fix-react-apps.sh"
echo "3. Démarrage:         ./start-apps.sh"
echo "4. Statut:            ./status-apps.sh"