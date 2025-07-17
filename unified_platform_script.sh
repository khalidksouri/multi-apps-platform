#!/bin/bash

# =============================================================================
# SCRIPT UNIFIÉ MULTI-APPS PLATFORM - TOUT EN UN
# =============================================================================
# Script unique pour gérer 6 applications avec toutes les fonctionnalités
# Basé sur le script compatible qui fonctionne + réparation + diagnostic
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

# Applications - Listes simples (compatible tous shells)
APPS_NAMES="math4kids unitflip budgetcron ai4kids multiai digital4kids"
APPS_PORTS="3001 3002 3003 3004 3005 3006"
APPS_COMMANDS="npm_start npm_start npm_run_serve npm_start npm_run_dev npm_start"

# =============================================================================
# FONCTIONS UTILITAIRES
# =============================================================================

# Fonction pour obtenir les infos d'une application
get_app_info() {
    local app_name=$1
    local index=0
    
    for name in $APPS_NAMES; do
        if [ "$name" = "$app_name" ]; then
            local port=$(echo $APPS_PORTS | cut -d' ' -f$((index + 1)))
            local cmd=$(echo $APPS_COMMANDS | cut -d' ' -f$((index + 1)))
            
            # Convertir le format de commande
            case $cmd in
                "npm_start") echo "$port:npm start" ;;
                "npm_run_serve") echo "$port:npm run serve" ;;
                "npm_run_dev") echo "$port:npm run dev" ;;
                *) echo "$port:npm start" ;;
            esac
            return 0
        fi
        index=$((index + 1))
    done
    
    echo "unknown:unknown"
}

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

# Header unifié
show_header() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}║         🚀 SCRIPT UNIFIÉ MULTI-APPS PLATFORM 🚀                ║${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}║     Gestion • Réparation • Diagnostic • Monitoring              ║${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📁 Projet: ${PROJECT_DIR}${NC}"
    echo -e "${CYAN}📋 Logs: ${LOG_DIR}${NC}"
    echo ""
}

# =============================================================================
# FONCTIONS DE RÉPARATION
# =============================================================================

# Réparation simple d'une application
repair_app() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🔧 Réparation de $app_name...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "  ❌ Répertoire manquant: $app_dir"
        return 1
    fi
    
    cd "$app_dir"
    
    # 1. Nettoyer complètement
    echo -e "  🧹 Nettoyage complet..."
    rm -rf node_modules package-lock.json .npm 2>/dev/null || true
    
    # 2. Vérifier package.json
    if [ ! -f "package.json" ]; then
        echo -e "  📝 Création d'un package.json minimal..."
        local app_info=$(get_app_info "$app_name")
        local port="${app_info%:*}"
        
        cat > package.json << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "typescript": "^4.9.5"
  },
  "scripts": {
    "start": "PORT=$port react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test"
  },
  "browserslist": {
    "production": [">0.2%", "not dead"],
    "development": ["last 1 chrome version"]
  }
}
EOF
    fi
    
    # 3. Créer les dossiers nécessaires
    echo -e "  📁 Création des dossiers..."
    mkdir -p src public
    
    # 4. Créer index.html si manquant
    if [ ! -f "public/index.html" ]; then
        echo -e "  📝 Création de index.html..."
        cat > public/index.html << EOF
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${app_name^}</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
EOF
    fi
    
    # 5. Créer index.tsx si manquant
    if [ ! -f "src/index.tsx" ]; then
        echo -e "  📝 Création de index.tsx..."
        cat > src/index.tsx << EOF
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF
    fi
    
    # 6. Créer App.tsx si manquant
    if [ ! -f "src/App.tsx" ]; then
        echo -e "  📝 Création de App.tsx..."
        cat > src/App.tsx << EOF
import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <div className="glass-card">
          <h1>${app_name^}</h1>
          <p>Application React + TypeScript</p>
          <div className="features">
            <div className="feature">✅ React 18</div>
            <div className="feature">✅ TypeScript</div>
            <div className="feature">✅ Fonctionnel</div>
          </div>
          <div className="status">
            🚀 Application opérationnelle
          </div>
        </div>
      </header>
    </div>
  );
}

export default App;
EOF
    fi
    
    # 7. Créer les CSS si manquants
    if [ ! -f "src/index.css" ]; then
        echo -e "  🎨 Création des styles..."
        cat > src/index.css << EOF
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
}
EOF
        
        cat > src/App.css << EOF
.App {
  text-align: center;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}

.App-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
  color: white;
}

.glass-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 3rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  max-width: 500px;
  width: 90%;
}

.glass-card h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  background: linear-gradient(45deg, #fff, #f0f0f0);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.glass-card p {
  font-size: 1.2rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

.features {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 2rem;
}

.feature {
  background: rgba(255, 255, 255, 0.1);
  padding: 0.8rem;
  border-radius: 10px;
  font-size: 0.9rem;
}

.status {
  font-size: 1rem;
  padding: 1rem;
  background: rgba(0, 255, 0, 0.1);
  border-radius: 10px;
}

@media (max-width: 768px) {
  .features {
    grid-template-columns: 1fr;
  }
}
EOF
    fi
    
    # 8. Créer tsconfig.json si manquant
    if [ ! -f "tsconfig.json" ]; then
        echo -e "  ⚙️ Création de tsconfig.json..."
        cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"]
}
EOF
    fi
    
    # 9. Créer .env
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    cat > .env << EOF
PORT=$port
BROWSER=none
SKIP_PREFLIGHT_CHECK=true
EOF
    
    # 10. Réinstaller les dépendances
    echo -e "  📦 Installation des dépendances..."
    if npm install --legacy-peer-deps --silent; then
        echo -e "  ${GREEN}✅ $app_name réparé avec succès!${NC}"
        return 0
    else
        echo -e "  ${RED}❌ Erreur lors de l'installation pour $app_name${NC}"
        return 1
    fi
}

# Réparation de toutes les applications
repair_all() {
    show_header
    echo -e "${BLUE}🔧 RÉPARATION DE TOUTES LES APPLICATIONS${NC}"
    echo -e "${BLUE}======================================${NC}"
    echo ""
    
    local repaired=0
    local total=0
    
    for app_name in $APPS_NAMES; do
        total=$((total + 1))
        if repair_app "$app_name"; then
            repaired=$((repaired + 1))
        fi
        echo ""
    done
    
    echo -e "${BLUE}📊 RÉSUMÉ DE LA RÉPARATION${NC}"
    echo -e "${BLUE}==========================${NC}"
    echo -e "🎯 Applications réparées: ${GREEN}$repaired/$total${NC}"
    echo ""
    
    if [ $repaired -eq $total ]; then
        echo -e "🏆 ${GREEN}TOUTES LES APPLICATIONS RÉPARÉES !${NC}"
        echo -e "${CYAN}💡 Utilisez '$0 start' pour démarrer la plateforme${NC}"
    else
        echo -e "⚠️ ${YELLOW}$(( total - repaired )) application(s) ont encore des problèmes${NC}"
    fi
    echo ""
}

# =============================================================================
# FONCTIONS DE DIAGNOSTIC
# =============================================================================

# Diagnostic simple d'une application
diagnose_app() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🔍 Diagnostic de $app_name...${NC}"
    
    # Vérifier le répertoire
    if [ ! -d "$app_dir" ]; then
        echo -e "  ❌ Répertoire manquant: $app_dir"
        return 1
    fi
    echo -e "  ✅ Répertoire présent"
    
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
        echo -e "  ⚠️ node_modules manquant"
        return 1
    else
        echo -e "  ✅ node_modules présent"
    fi
    
    # Vérifier les fichiers source
    if [ -d "src" ]; then
        echo -e "  ✅ Dossier src présent"
    else
        echo -e "  ⚠️ Dossier src manquant"
        return 1
    fi
    
    echo -e "  ${GREEN}✅ Diagnostic OK pour $app_name${NC}"
    return 0
}

# Diagnostic de toute la plateforme
diagnose_all() {
    show_header
    echo -e "${BLUE}🔍 DIAGNOSTIC COMPLET DE LA PLATEFORME${NC}"
    echo -e "${BLUE}====================================${NC}"
    echo ""
    
    local valid=0
    local total=0
    
    for app_name in $APPS_NAMES; do
        total=$((total + 1))
        if diagnose_app "$app_name"; then
            valid=$((valid + 1))
        fi
        echo ""
    done
    
    echo -e "${BLUE}📊 RÉSUMÉ DU DIAGNOSTIC${NC}"
    echo -e "${BLUE}=======================${NC}"
    echo -e "🎯 Applications valides: ${GREEN}$valid/$total${NC}"
    echo ""
    
    if [ $valid -eq $total ]; then
        echo -e "🏆 ${GREEN}PLATEFORME ENTIÈREMENT OPÉRATIONNELLE !${NC}"
    else
        echo -e "⚠️ ${YELLOW}$(( total - valid )) application(s) nécessitent une réparation${NC}"
        echo -e "${CYAN}💡 Utilisez '$0 repair-all' pour réparer automatiquement${NC}"
    fi
    echo ""
}

# =============================================================================
# FONCTIONS DE GESTION DES APPLICATIONS (BASÉES SUR LE SCRIPT QUI MARCHE)
# =============================================================================

# Démarrer une application
start_app() {
    local app_name=$1
    local app_info=$(get_app_info "$app_name")
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
    local max_attempts=60
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
            echo -e "  📝 Voir les logs: cat $LOG_DIR/${app_name}.log"
            return 1
        fi
        
        sleep 2
        attempt=$((attempt + 1))
        
        if [ $attempt -eq 15 ]; then
            echo -e "  ⏰ Démarrage en cours..."
        fi
        
        if [ $attempt -eq 30 ]; then
            echo -e "  ⏰ Démarrage toujours en cours..."
        fi
    done
    
    echo -e "  ${RED}❌ Échec du démarrage après $max_attempts tentatives${NC}"
    echo -e "  📝 Voir les logs: cat $LOG_DIR/${app_name}.log"
    return 1
}

# Arrêter une application
stop_app() {
    local app_name=$1
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    
    echo -e "${YELLOW}🛑 Arrêt de $app_name...${NC}"
    
    # Arrêter par PID
    local pid_file="$LOG_DIR/${app_name}.pid"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" >/dev/null 2>&1; then
            echo -e "  📋 Arrêt du processus $pid..."
            kill -TERM "$pid" 2>/dev/null || true
            sleep 3
            
            if ps -p "$pid" >/dev/null 2>&1; then
                echo -e "  💥 Arrêt forcé..."
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
    local app_info=$(get_app_info "$app_name")
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
    local started_apps=0
    
    for app_name in $APPS_NAMES; do
        if start_app "$app_name"; then
            started_apps=$((started_apps + 1))
        fi
        echo ""
        sleep 3  # Petite pause entre les démarrages
    done
    
    # Attendre la stabilisation
    echo -e "${BLUE}⏳ Stabilisation (15 secondes)...${NC}"
    sleep 15
    
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
    
    for app_name in $APPS_NAMES; do
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
    local total_apps=6
    local working_urls=""
    
    for app_name in $APPS_NAMES; do
        if check_app_status "$app_name"; then
            running_apps=$((running_apps + 1))
            local app_info=$(get_app_info "$app_name")
            local port="${app_info%:*}"
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
    echo "🔄 Redémarrer: $0 restart"
    echo "📊 Statut: $0 status"
    echo "🔍 Diagnostic: $0 diagnose"
    echo "🔧 Réparation: $0 repair [app] | $0 repair-all"
    echo "📝 Logs: $0 logs"
    echo ""
}

# Afficher les logs avec analyse
show_logs() {
    show_header
    echo -e "${BLUE}📝 LOGS DES APPLICATIONS${NC}"
    echo -e "${BLUE}========================${NC}"
    echo ""
    
    if [ ! -d "$LOG_DIR" ]; then
        echo -e "${YELLOW}⚠️ Aucun log disponible${NC}"
        return
    fi
    
    echo -e "${YELLOW}📁 Répertoire: $LOG_DIR${NC}"
    echo ""
    
    for app_name in $APPS_NAMES; do
        local log_file="$LOG_DIR/${app_name}.log"
        echo -e "${CYAN}📄 $app_name${NC}"
        
        if [ -f "$log_file" ]; then
            local lines=$(wc -l < "$log_file")
            echo -e "   📊 $lines lignes dans le log"
            
            # Analyser les erreurs
            local errors=$(grep -i "error\|failed\|cannot" "$log_file" 2>/dev/null | wc -l)
            if [ $errors -gt 0 ]; then
                echo -e "   ${RED}❌ $errors erreur(s) détectée(s)${NC}"
                echo -e "   🔍 Dernière erreur:"
                grep -i "error\|failed\|cannot" "$log_file" | tail -1 | head -c 100
                echo "..."
            else
                echo -e "   ${GREEN}✅ Aucune erreur détectée${NC}"
            fi
        else
            echo -e "   ${YELLOW}⚠️ Log non trouvé${NC}"
        fi
        echo ""
    done
    
    echo -e "${CYAN}💡 Commandes utiles :${NC}"
    echo "📖 Voir un log: tail -f $LOG_DIR/{app_name}.log"
    echo "🔍 Chercher des erreurs: grep -i error $LOG_DIR/{app_name}.log"
    echo "🧹 Nettoyer les logs: rm $LOG_DIR/*.log"
    echo ""
}

# Afficher l'aide
show_help() {
    show_header
    echo -e "${CYAN}📚 AIDE - SCRIPT UNIFIÉ MULTI-APPS PLATFORM${NC}"
    echo -e "${CYAN}============================================${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC} $0 [commande] [options]"
    echo ""
    echo -e "${YELLOW}COMMANDES PRINCIPALES:${NC}"
    echo -e "  ${GREEN}start${NC}        - Démarrer toutes les 6 applications"
    echo -e "  ${RED}stop${NC}         - Arrêter toutes les applications"
    echo -e "  ${BLUE}restart${NC}      - Redémarrer toutes les applications"
    echo -e "  ${YELLOW}status${NC}       - Afficher le statut de toutes les applications"
    echo ""
    echo -e "${YELLOW}COMMANDES DE MAINTENANCE:${NC}"
    echo -e "  ${PURPLE}diagnose${NC}     - Diagnostic complet de la plateforme"
    echo -e "  ${CYAN}repair${NC} [app]  - Réparer une application spécifique"
    echo -e "  ${CYAN}repair-all${NC}   - Réparer toutes les applications"
    echo -e "  ${BLUE}logs${NC}         - Afficher l'analyse des logs"
    echo ""
    echo -e "${YELLOW}APPLICATIONS (6):${NC}"
    local index=0
    for app_name in $APPS_NAMES; do
        local port=$(echo $APPS_PORTS | cut -d' ' -f$((index + 1)))
        echo -e "  🔹 ${GREEN}$app_name${NC} (port $port)"
        index=$((index + 1))
    done
    echo ""
    echo -e "${YELLOW}EXEMPLES:${NC}"
    echo -e "  $0 start              # Démarrer toute la plateforme"
    echo -e "  $0 repair-all         # Réparer toutes les applications"
    echo -e "  $0 restart            # Redémarrer après réparation"
    echo -e "  $0 status             # Vérifier le statut"
    echo -e "  $0 repair unitflip    # Réparer UnitFlip uniquement"
    echo -e "  $0 logs               # Analyser les logs"
    echo ""
    echo -e "${YELLOW}STRUCTURE:${NC}"
    echo -e "  📁 ${PROJECT_DIR}/"
    echo -e "  ├── $0    # Ce script unifié"
    echo -e "  └── logs/              # Tous les logs"
    echo -e "      ├── platform.log  # Log principal"
    echo -e "      ├── *.log         # Logs des applications"
    echo -e "      └── *.pid         # PIDs des processus"
    echo ""
}

# =============================================================================
# POINT D'ENTRÉE PRINCIPAL
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
            sleep 5
            start_all_apps
            ;;
        "status")
            show_header
            echo -e "${BLUE}📊 STATUT DE LA PLATEFORME${NC}"
            echo -e "${BLUE}==========================${NC}"
            echo ""
            check_all_status
            ;;
        "diagnose")
            diagnose_all
            ;;
        "repair")
            if [ -n "$2" ]; then
                show_header
                echo -e "${BLUE}🔧 RÉPARATION DE $2${NC}"
                echo -e "${BLUE}==================${NC}"
                echo ""
                if repair_app "$2"; then
                    echo -e "${GREEN}✅ $2 réparé avec succès${NC}"
                else
                    echo -e "${RED}❌ Échec de la réparation de $2${NC}"
                fi
                echo ""
            else
                echo -e "${RED}❌ Veuillez spécifier une application${NC}"
                echo -e "${YELLOW}Usage: $0 repair [app_name]${NC}"
                echo -e "${YELLOW}Apps: math4kids unitflip budgetcron ai4kids multiai digital4kids${NC}"
                echo ""
            fi
            ;;
        "repair-all")
            repair_all
            ;;
        "logs")
            show_logs
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo -e "${RED}❌ Commande inconnue: $1${NC}"
            echo ""
            echo -e "${YELLOW}Commandes disponibles:${NC}"
            echo "  start, stop, restart, status, diagnose, repair, repair-all, logs, help"
            echo ""
            echo -e "${CYAN}Pour voir l'aide complète: $0 help${NC}"
            exit 1
            ;;
    esac
}

# Gestion des erreurs
trap 'echo -e "${RED}❌ Erreur détectée à la ligne $LINENO${NC}"; exit 1' ERR

# Lancement du script
main "$@"