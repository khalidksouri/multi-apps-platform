#!/bin/bash

# Script pour créer les lanceurs dans le projet multi-apps-platform

set -e

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 CRÉATION DES SCRIPTS DE LANCEMENT DANS LE PROJET${NC}"
echo -e "${BLUE}=================================================${NC}"

# Déterminer le répertoire du projet
PROJECT_DIR="$(pwd)"
WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

echo "📁 Répertoire du projet: $PROJECT_DIR"
echo "📁 Workspace des apps: $WORKSPACE_DIR"
echo ""

# 1. Créer start-apps.sh dans le projet
echo -e "${YELLOW}▶ Création de start-apps.sh${NC}"
cat > "$PROJECT_DIR/start-apps.sh" << 'EOF'
#!/bin/bash

# Script de démarrage des applications depuis multi-apps-platform
# Usage: ./start-apps.sh

set -e

# Configuration
WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
LOG_DIR="$WORKSPACE_DIR/logs"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Créer le dossier de logs
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

# Fonction pour vérifier les prérequis
check_prerequisites() {
    log "INFO" "$YELLOW" "Vérification des prérequis..."
    
    # Vérifier Node.js
    if ! command -v node &> /dev/null; then
        log "ERROR" "$RED" "Node.js n'est pas installé"
        exit 1
    fi
    
    # Vérifier npm
    if ! command -v npm &> /dev/null; then
        log "ERROR" "$RED" "npm n'est pas installé"
        exit 1
    fi
    
    # Vérifier le workspace
    if [ ! -d "$WORKSPACE_DIR" ]; then
        log "ERROR" "$RED" "Workspace non trouvé: $WORKSPACE_DIR"
        exit 1
    fi
    
    log "SUCCESS" "$GREEN" "Prérequis validés"
}

# Fonction pour démarrer une application
start_app() {
    local app_name=$1
    local port=$2
    local command=$3
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    if [ ! -d "$app_dir" ]; then
        log "ERROR" "$RED" "Répertoire $app_name non trouvé: $app_dir"
        return 1
    fi
    
    log "INFO" "$YELLOW" "Démarrage de $app_name sur le port $port..."
    
    cd "$app_dir"
    
    # Vérifier si le port est libre
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        log "WARNING" "$YELLOW" "Port $port déjà utilisé pour $app_name"
        
        # Proposer d'arrêter le processus existant
        echo -e "${YELLOW}Voulez-vous arrêter le processus existant sur le port $port ? (y/N)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            local pid=$(lsof -ti:$port)
            kill -9 $pid 2>/dev/null || true
            log "INFO" "$YELLOW" "Processus arrêté sur le port $port"
            sleep 2
        else
            return 1
        fi
    fi
    
    # Vérifier que package.json existe
    if [ ! -f "$app_dir/package.json" ]; then
        log "ERROR" "$RED" "package.json manquant pour $app_name"
        return 1
    fi
    
    # Vérifier que node_modules existe
    if [ ! -d "$app_dir/node_modules" ]; then
        log "WARNING" "$YELLOW" "node_modules manquant pour $app_name, installation..."
        npm install
    fi
    
    # Démarrer l'application en arrière-plan
    $command > "$LOG_DIR/${app_name}.log" 2>&1 &
    local pid=$!
    
    echo $pid > "$LOG_DIR/${app_name}.pid"
    
    # Attendre que l'application démarre
    log "INFO" "$YELLOW" "Attente du démarrage de $app_name (PID: $pid)..."
    sleep 8
    
    # Vérifier si le processus est toujours actif
    if kill -0 $pid 2>/dev/null; then
        # Vérifier si le port répond
        local retries=0
        local max_retries=10
        
        while [ $retries -lt $max_retries ]; do
            if curl -s "http://localhost:$port" >/dev/null 2>&1; then
                log "SUCCESS" "$GREEN" "$app_name démarré avec succès sur http://localhost:$port (PID: $pid)"
                return 0
            fi
            
            retries=$((retries + 1))
            sleep 2
        done
        
        log "WARNING" "$YELLOW" "$app_name processus actif mais port $port ne répond pas encore"
        return 0
    else
        log "ERROR" "$RED" "$app_name a échoué au démarrage"
        
        # Afficher les dernières lignes du log pour diagnostic
        if [ -f "$LOG_DIR/${app_name}.log" ]; then
            echo -e "${RED}Dernières lignes du log:${NC}"
            tail -n 5 "$LOG_DIR/${app_name}.log"
        fi
        
        return 1
    fi
}

# Fonction pour afficher le statut
show_status() {
    echo ""
    echo -e "${BLUE}📊 STATUT DES APPLICATIONS${NC}"
    echo -e "${BLUE}=========================${NC}"
    
    local apps=("math4kids:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")
    local running=0
    local total=5
    
    for app_port in "${apps[@]}"; do
        local app_name="${app_port%:*}"
        local port="${app_port#*:}"
        local pid_file="$LOG_DIR/${app_name}.pid"
        
        if [ -f "$pid_file" ]; then
            local pid=$(cat "$pid_file")
            if kill -0 "$pid" 2>/dev/null; then
                echo -e "  ✅ $app_name: ${GREEN}Running${NC} (PID: $pid, Port: $port)"
                running=$((running + 1))
            else
                echo -e "  ❌ $app_name: ${RED}Stopped${NC} (Port: $port)"
            fi
        else
            echo -e "  ❌ $app_name: ${RED}Not started${NC} (Port: $port)"
        fi
    done
    
    echo ""
    echo -e "${BLUE}Résumé: $running/$total applications en cours d'exécution${NC}"
}

# Fonction principale
main() {
    # Vérifications préalables
    check_prerequisites
    
    echo ""
    echo -e "${YELLOW}🚀 Démarrage des applications...${NC}"
    echo ""
    
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
    
    # Afficher le statut final
    show_status
    
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
    echo "  📊 Statut:     ./status-apps.sh"
    echo "  📝 Logs:       ls $LOG_DIR"
    echo "  🛑 Arrêt:      ./stop-apps.sh"
    echo ""
    
    # Retourner au répertoire du projet
    cd "$PROJECT_DIR"
}

# Gestion des erreurs
trap 'echo -e "${RED}❌ Erreur détectée${NC}"; cd "$PROJECT_DIR"; exit 1' ERR

# Lancement du script
main "$@"
EOF

chmod +x "$PROJECT_DIR/start-apps.sh"
echo -e "${GREEN}✅ start-apps.sh créé${NC}"

# 2. Créer stop-apps.sh dans le projet
echo -e "${YELLOW}▶ Création de stop-apps.sh${NC}"
cat > "$PROJECT_DIR/stop-apps.sh" << 'EOF'
#!/bin/bash

# Script d'arrêt des applications depuis multi-apps-platform
# Usage: ./stop-apps.sh

set -e

# Configuration
WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
LOG_DIR="$WORKSPACE_DIR/logs"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
    
    # Méthode 1: Utiliser le fichier PID
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null || kill -9 "$pid" 2>/dev/null
            echo -e "  ✅ Processus arrêté (PID: $pid)"
        else
            echo -e "  ⚠️ Processus déjà arrêté"
        fi
        rm -f "$pid_file"
    else
        echo -e "  ⚠️ Fichier PID non trouvé"
    fi
    
    # Méthode 2: Arrêter par port (backup)
    local port_pid=$(lsof -ti:$port 2>/dev/null || true)
    if [ -n "$port_pid" ]; then
        kill "$port_pid" 2>/dev/null || kill -9 "$port_pid" 2>/dev/null
        echo -e "  ✅ Processus sur port $port arrêté (PID: $port_pid)"
    fi
    
    echo -e "  ✅ $app_name arrêté"
}

# Fonction pour arrêter tous les processus Node.js du workspace
stop_all_node_processes() {
    echo -e "${YELLOW}🔍 Recherche de processus Node.js dans le workspace...${NC}"
    
    # Trouver tous les processus Node.js liés au workspace
    local node_pids=$(ps aux | grep node | grep "$WORKSPACE_DIR" | grep -v grep | awk '{print $2}' || true)
    
    if [ -n "$node_pids" ]; then
        echo -e "${YELLOW}📝 Processus Node.js trouvés:${NC}"
        echo "$node_pids" | while read -r pid; do
            if [ -n "$pid" ]; then
                echo -e "  🛑 Arrêt du processus $pid"
                kill "$pid" 2>/dev/null || kill -9 "$pid" 2>/dev/null || true
            fi
        done
    else
        echo -e "  ℹ️ Aucun processus Node.js trouvé"
    fi
}

# Fonction pour nettoyer les fichiers temporaires
cleanup() {
    echo -e "${YELLOW}🧹 Nettoyage des fichiers temporaires...${NC}"
    
    # Nettoyer les fichiers PID
    rm -f "$LOG_DIR"/*.pid 2>/dev/null || true
    
    # Nettoyer les ports (méthode agressive)
    local ports=(3001 3002 3003 3004 3005)
    for port in "${ports[@]}"; do
        local pid=$(lsof -ti:$port 2>/dev/null || true)
        if [ -n "$pid" ]; then
            kill -9 "$pid" 2>/dev/null || true
            echo -e "  🛑 Port $port libéré"
        fi
    done
    
    echo -e "${GREEN}✅ Nettoyage terminé${NC}"
}

# Fonction pour afficher le statut après arrêt
show_final_status() {
    echo ""
    echo -e "${BLUE}📊 STATUT FINAL${NC}"
    echo -e "${BLUE}===============${NC}"
    
    local apps=("math4kids:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")
    local stopped=0
    local total=5
    
    for app_port in "${apps[@]}"; do
        local app_name="${app_port%:*}"
        local port="${app_port#*:}"
        
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo -e "  ⚠️ $app_name: ${YELLOW}Encore actif${NC} (Port: $port)"
        else
            echo -e "  ✅ $app_name: ${GREEN}Arrêté${NC} (Port: $port)"
            stopped=$((stopped + 1))
        fi
    done
    
    echo ""
    if [ $stopped -eq $total ]; then
        echo -e "${GREEN}🎉 Toutes les applications sont arrêtées ($stopped/$total)${NC}"
    else
        echo -e "${YELLOW}⚠️ $stopped/$total applications arrêtées${NC}"
    fi
}

# Fonction principale
main() {
    echo "📁 Projet: $PROJECT_DIR"
    echo "📁 Workspace: $WORKSPACE_DIR"
    echo "📋 Logs: $LOG_DIR"
    echo ""
    
    # Arrêt des applications par nom
    stop_app "math4kids" 3001
    stop_app "unitflip" 3002
    stop_app "budgetcron" 3003
    stop_app "ai4kids" 3004
    stop_app "multiai" 3005
    
    echo ""
    
    # Arrêt de tous les processus Node.js restants
    stop_all_node_processes
    
    echo ""
    
    # Nettoyage final
    cleanup
    
    # Statut final
    show_final_status
    
    echo ""
    echo -e "${GREEN}🎉 ARRÊT TERMINÉ!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Actions disponibles:${NC}"
    echo "  🚀 Redémarrer: ./start-apps.sh"
    echo "  📊 Statut:     ./status-apps.sh"
    echo "  📝 Logs:       ls $LOG_DIR"
    echo ""
    
    # Retourner au répertoire du projet
    cd "$PROJECT_DIR"
}

# Gestion des erreurs
trap 'echo -e "${RED}❌ Erreur lors de l arrêt${NC}"; cd "$PROJECT_DIR"; exit 1' ERR

# Lancement du script
main "$@"
EOF

chmod +x "$PROJECT_DIR/stop-apps.sh"
echo -e "${GREEN}✅ stop-apps.sh créé${NC}"

# 3. Créer status-apps.sh dans le projet
echo -e "${YELLOW}▶ Création de status-apps.sh${NC}"
cat > "$PROJECT_DIR/status-apps.sh" << 'EOF'
#!/bin/bash

# Script de statut des applications depuis multi-apps-platform
# Usage: ./status-apps.sh

set -e

# Configuration
WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
LOG_DIR="$WORKSPACE_DIR/logs"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}📱 $app_name (Port: $port)${NC}"
    
    # Vérifier le répertoire
    if [ ! -d "$app_dir" ]; then
        echo -e "  ❌ Répertoire: ${RED}Non trouvé${NC}"
        return 1
    else
        echo -e "  ✅ Répertoire: ${GREEN}$app_dir${NC}"
    fi
    
    # Vérifier le processus
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            echo -e "  ✅ Processus: ${GREEN}Actif (PID: $pid)${NC}"
        else
            echo -e "  ❌ Processus: ${RED}Arrêté (PID obsolète: $pid)${NC}"
            rm -f "$pid_file"
        fi
    else
        echo -e "  ❌ Processus: ${RED}Non démarré${NC}"
    fi
    
    # Vérifier le port
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        local port_pid=$(lsof -ti:$port)
        echo -e "  ✅ Port $port: ${GREEN}Utilisé (PID: $port_pid)${NC}"
        
        # Test de connectivité HTTP
        if curl -s --max-time 5 "http://localhost:$port" >/dev/null 2>&1; then
            echo -e "  ✅ HTTP: ${GREEN}Répond${NC} - http://localhost:$port"
        else
            echo -e "  ⚠️ HTTP: ${YELLOW}Port ouvert mais ne répond pas${NC}"
        fi
    else
        echo -e "  ❌ Port $port: ${RED}Libre${NC}"
    fi
    
    # Vérifier les dépendances
    if [ -f "$app_dir/package.json" ]; then
        echo -e "  ✅ Package.json: ${GREEN}Présent${NC}"
        if [ -d "$app_dir/node_modules" ]; then
            echo -e "  ✅ Node_modules: ${GREEN}Installé${NC}"
        else
            echo -e "  ⚠️ Node_modules: ${YELLOW}Manquant${NC}"
        fi
    else
        echo -e "  ❌ Package.json: ${RED}Manquant${NC}"
    fi
    
    # Vérifier les logs récents
    local log_file="$LOG_DIR/${app_name}.log"
    if [ -f "$log_file" ]; then
        local log_size=$(du -h "$log_file" | cut -f1)
        local last_modified=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$log_file" 2>/dev/null || echo "Inconnu")
        echo -e "  📝 Log: ${GREEN}$log_size${NC} (Modifié: $last_modified)"
        
        # Vérifier s'il y a des erreurs récentes
        local recent_errors=$(tail -n 20 "$log_file" 2>/dev/null | grep -i "error\|failed\|exception" | wc -l | tr -d ' ')
        if [ "$recent_errors" -gt 0 ]; then
            echo -e "  ⚠️ Erreurs récentes: ${YELLOW}$recent_errors${NC}"
        fi
    else
        echo -e "  ❌ Log: ${RED}Aucun${NC}"
    fi
    
    echo ""
}

# Fonction pour afficher le résumé global
show_global_summary() {
    echo -e "${BLUE}📋 RÉSUMÉ GLOBAL${NC}"
    echo -e "${BLUE}===============${NC}"
    
    local apps=("math4kids:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")
    local running=0
    local total=5
    local ports_used=0
    
    for app_port in "${apps[@]}"; do
        local app_name="${app_port%:*}"
        local port="${app_port#*:}"
        local pid_file="$LOG_DIR/${app_name}.pid"
        
        # Compter les applications en cours
        if [ -f "$pid_file" ]; then
            local pid=$(cat "$pid_file")
            if kill -0 "$pid" 2>/dev/null; then
                running=$((running + 1))
            fi
        fi
        
        # Compter les ports utilisés
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            ports_used=$((ports_used + 1))
        fi
    done
    
    echo -e "🚀 Applications actives: ${GREEN}$running/$total${NC}"
    echo -e "🌐 Ports utilisés: ${GREEN}$ports_used/5${NC}"
    
    # Vérifier l'utilisation du système
    echo -e "💾 Utilisation mémoire Node.js:"
    ps aux | grep node | grep -v grep | awk '{print "  " $2 ": " $4"% - " $11}' || echo "  Aucun processus Node.js"
    
    echo -e "📊 Espace disque (logs):"
    if [ -d "$LOG_DIR" ]; then
        local log_size=$(du -sh "$LOG_DIR" 2>/dev/null | cut -f1 || echo "0")
        echo -e "  📝 Logs: ${GREEN}$log_size${NC}"
    fi
    
    echo ""
    
    # Recommandations
    if [ $running -eq $total ]; then
        echo -e "${GREEN}🎉 Toutes les applications fonctionnent correctement!${NC}"
    elif [ $running -eq 0 ]; then
        echo -e "${YELLOW}💡 Aucune application en cours. Lancez: ./start-apps.sh${NC}"
    else
        echo -e "${YELLOW}⚠️ Certaines applications ne fonctionnent pas.${NC}"
        echo -e "${YELLOW}💡 Actions suggérées:${NC}"
        echo -e "  🔄 Redémarrer toutes: ./stop-apps.sh && ./start-apps.sh"
        echo -e "  📝 Vérifier les logs: ls $LOG_DIR"
    fi
}

# Fonction principale
main() {
    echo "📁 Projet: $PROJECT_DIR"
    echo "📁 Workspace: $WORKSPACE_DIR"
    echo "📋 Logs: $LOG_DIR"
    echo ""
    
    # Vérifier chaque application
    check_app_status "math4kids" 3001
    check_app_status "unitflip" 3002
    check_app_status "budgetcron" 3003
    check_app_status "ai4kids" 3004
    check_app_status "multiai" 3005
    
    # Afficher le résumé
    show_global_summary
    
    echo -e "${YELLOW}📋 Actions disponibles:${NC}"
    echo "  🚀 Démarrer: ./start-apps.sh"
    echo "  🛑 Arrêter:  ./stop-apps.sh"
    echo "  📊 Statut:   ./status-apps.sh"
    echo "  📝 Logs:     ls $LOG_DIR"
    echo ""
}

# Lancement du script
main "$@"
EOF

chmod +x "$PROJECT_DIR/status-apps.sh"
echo -e "${GREEN}✅ status-apps.sh créé${NC}"

# 4. Créer un README pour les scripts
echo -e "${YELLOW}▶ Création du README${NC}"
cat > "$PROJECT_DIR/LAUNCHER_README.md" << 'EOF'
# 🚀 Scripts de Gestion Multi-Apps Platform

## 📋 Scripts disponibles

### 🚀 `./start-apps.sh`
Démarre toutes les applications du multi-apps-platform
- Vérifie les prérequis (Node.js, npm, workspace)
- Démarre les 5 applications sur leurs ports respectifs
- Gère les conflits de ports
- Affiche les URLs d'accès

### 🛑 `./stop-apps.sh`
Arrête toutes les applications en cours
- Arrêt propre via fichiers PID
- Nettoyage des ports occupés
- Suppression des fichiers temporaires
- Vérification de l'arrêt complet

### 📊 `./status-apps.sh`
Affiche le statut détaillé de toutes les applications
- État des processus
- Utilisation des ports
- Test de connectivité HTTP
- Vérification des dépendances
- Analyse des logs

## 🌐 Applications et Ports

| Application | Port | URL | Technology |
|-------------|------|-----|------------|
| Math4Kids   | 3001 | http://localhost:3001 | React + TypeScript |
| UnitFlip    | 3002 | http://localhost:3002 | React + TypeScript |
| BudgetCron  | 3003 | http://localhost:3003 | Vue.js + TypeScript |
| AI4Kids     | 3004 | http://localhost:3004 | React + TypeScript |
| MultiAI     | 3005 | http://localhost:3005 | Next.js + TypeScript |

## 📝 Logs et Diagnostic

### Localisation des logs
```bash
/Users/khalidksouri/global-multi-apps-workspace/logs/
├── startup.log          # Log global de démarrage
├── math4kids.log        # Logs de Math4Kids
├── unitflip.log         # Logs de UnitFlip
├── budgetcron.log       # Logs de BudgetCron
├── ai4kids.log          # Logs de AI4Kids
├── multiai.log          # Logs de MultiAI
├── math4kids.pid        # PID de Math4Kids
├── unitflip.pid         # PID de UnitFlip
├── budgetcron.pid       # PID de BudgetCron
├── ai4kids.pid          # PID de AI4Kids
└── multiai.pid          # PID de MultiAI
```

### Diagnostic des problèmes
```bash
# Voir les logs en temps réel
tail -f /Users/khalidksouri/global-multi-apps-workspace/logs/math4kids.log

# Vérifier tous les logs d'erreurs
grep -i error /Users/khalidksouri/global-multi-apps-workspace/logs/*.log

# Voir les processus Node.js actifs
ps aux | grep node

# Vérifier les ports utilisés
lsof -i :3001-3005
```

## 🔧 Résolution de Problèmes

### Port déjà utilisé
```bash
# Identifier le processus sur un port
lsof -ti:3001

# Arrêter le processus
kill -9 $(lsof -ti:3001)
```

### Application ne démarre pas
```bash
# Vérifier les dépendances
cd /Users/khalidksouri/global-multi-apps-workspace/math4kids
npm install

# Tester le démarrage manuel
npm start
```

### Nettoyage complet
```bash
# Arrêt brutal de tous les processus
./stop-apps.sh

# Nettoyage des ports
for port in 3001 3002 3003 3004 3005; do
  kill -9 $(lsof -ti:$port) 2>/dev/null || true
done

# Redémarrage propre
./start-apps.sh
```

## 📚 Workflow Recommandé

### Développement quotidien
```bash
# 1. Vérifier le statut
./status-apps.sh

# 2. Démarrer si nécessaire
./start-apps.sh

# 3. Développer...

# 4. Arrêter en fin de journée
./stop-apps.sh
```

### En cas de problème
```bash
# 1. Statut détaillé
./status-apps.sh

# 2. Arrêt complet
./stop-apps.sh

# 3. Vérification des logs
ls -la /Users/khalidksouri/global-multi-apps-workspace/logs/

# 4. Redémarrage
./start-apps.sh
```

## ⚡ Tips & Astuces

### Raccourcis utiles
```bash
# Alias recommandés pour ~/.zshrc ou ~/.bashrc
alias mstart='./start-apps.sh'
alias mstop='./stop-apps.sh'
alias mstatus='./status-apps.sh'

# Variables d'environnement utiles
export MULTI_APPS_WORKSPACE="/Users/khalidksouri/global-multi-apps-workspace"
export MULTI_APPS_LOGS="$MULTI_APPS_WORKSPACE/logs"
```

### Surveillance automatique
```bash
# Surveiller tous les logs
watch -n 2 './status-apps.sh | tail -n 20'

# Alerte si une app s'arrête
while true; do
  if ! ./status-apps.sh | grep -q "5/5"; then
    echo "⚠️ Une application s'est arrêtée!"
  fi
  sleep 30
done
```

## 🆘 Support

En cas de problème persistant :
1. Vérifiez les logs dans `/Users/khalidksouri/global-multi-apps-workspace/logs/`
2. Exécutez `./status-apps.sh` pour un diagnostic complet
3. Consultez la documentation des frameworks (React, Vue.js, Next.js)
4. Vérifiez que Node.js et npm sont à jour

---
*Dernière mise à jour: $(date)*
EOF

echo -e "${GREEN}✅ LAUNCHER_README.md créé${NC}"

echo ""
echo -e "${GREEN}🎉 SCRIPTS DE LANCEMENT CRÉÉS AVEC SUCCÈS!${NC}"
echo ""
echo -e "${YELLOW}📋 Scripts disponibles dans le projet:${NC}"
echo "  🚀 ./start-apps.sh   - Démarrer toutes les applications"
echo "  🛑 ./stop-apps.sh    - Arrêter toutes les applications"
echo "  📊 ./status-apps.sh  - Vérifier le statut des applications"
echo "  📚 LAUNCHER_README.md - Documentation complète"
echo ""
echo -e "${YELLOW}🌐 URLs d'accès après démarrage:${NC}"
echo "  📚 Math4Kids:  http://localhost:3001"
echo "  🔄 UnitFlip:   http://localhost:3002" 
echo "  💰 BudgetCron: http://localhost:3003"
echo "  🤖 AI4Kids:   http://localhost:3004"
echo "  🧠 MultiAI:    http://localhost:3005"
echo ""
echo -e "${BLUE}💡 Pour commencer:${NC}"
echo "  ./start-apps.sh"