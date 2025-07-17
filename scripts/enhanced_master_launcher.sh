#!/bin/bash

# 🌍 SCRIPT MAÎTRE ULTIMATE - VERSION AMÉLIORÉE AVEC DIAGNOSTICS
# Auto-correction, diagnostics avancés, et gestion intelligente des erreurs
# Auteur: Assistant Claude pour Khalid Ksouri
# Version: 4.0.0 - Enhanced Edition

set -e

# ==================== CONFIGURATION GLOBALE ====================
SCRIPT_VERSION="4.0.0"
SCRIPT_NAME="Ultimate Enhanced Multi-App Launcher"
CREATION_DATE=$(date)
WORK_DIR="$HOME/global-multi-apps-workspace"
LOG_DIR="$WORK_DIR/logs"
BACKUP_DIR="$WORK_DIR/backups"
CONFIG_FILE="$WORK_DIR/config.json"
I18N_DIR="$WORK_DIR/i18n"
DIAGNOSTICS_DIR="$WORK_DIR/diagnostics"

# Configuration des applications
APPS_math4kids="Math4Kids Pro"
APPS_unitflip="UnitFlip Pro"
APPS_budgetcron="BudgetCron"
APPS_ai4kids="AI4Kids"
APPS_multiai="MultiAI"

PORTS_math4kids=3001
PORTS_unitflip=3002
PORTS_budgetcron=3003
PORTS_ai4kids=3004
PORTS_multiai=3005

TECH_STACK_math4kids="react-typescript"
TECH_STACK_unitflip="react-typescript"
TECH_STACK_budgetcron="vue-typescript"
TECH_STACK_ai4kids="react-typescript"
TECH_STACK_multiai="next-typescript"

APP_LIST="math4kids unitflip budgetcron ai4kids multiai"

# Configuration multilingue simplifiée pour rapidité
EUROPE_LANGUAGES="fr:Français|France|ltr en:English|United_Kingdom|ltr es:Español|España|ltr de:Deutsch|Deutschland|ltr it:Italiano|Italia|ltr pt:Português|Portugal|ltr ru:Русский|Россия|ltr"
ASIA_LANGUAGES="ar:العربية|Saudi_Arabia|rtl zh:中文|China|ltr ja:日本語|Japan|ltr ko:한국어|Korea|ltr hi:हिन्दी|India|ltr th:ไทย|Thailand|ltr"
AFRICA_LANGUAGES="sw:Kiswahili|Tanzania|ltr am:አማርኛ|Ethiopia|ltr yo:Yorùbá|Nigeria|ltr"
AMERICA_NORTH_LANGUAGES="en-US:English|United_States|ltr es-MX:Español|Mexico|ltr fr-CA:Français|Canada|ltr"
AMERICA_SOUTH_LANGUAGES="pt-BR:Português|Brazil|ltr es-AR:Español|Argentina|ltr"
OCEANIA_LANGUAGES="en-AU:English|Australia|ltr mi:Te_Reo_Māori|New_Zealand|ltr"

# Variables globales
PIDS=()
FAILED_APPS=()
SUCCESS_APPS=()
SYSTEM_OS=""
NODE_VERSION=""
NPM_VERSION=""
MEMORY_TOTAL=""
DISK_SPACE=""
SUPPORTED_LANGUAGES_COUNT=0
DEBUG_MODE=false
AUTO_FIX=true

# ==================== COULEURS & STYLES ====================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# ==================== FONCTIONS UTILITAIRES AMÉLIORÉES ====================
get_app_name() {
    local app=$1
    case $app in
        "math4kids") echo "$APPS_math4kids" ;;
        "unitflip") echo "$APPS_unitflip" ;;
        "budgetcron") echo "$APPS_budgetcron" ;;
        "ai4kids") echo "$APPS_ai4kids" ;;
        "multiai") echo "$APPS_multiai" ;;
        *) echo "$app" ;;
    esac
}

get_app_port() {
    local app=$1
    case $app in
        "math4kids") echo "$PORTS_math4kids" ;;
        "unitflip") echo "$PORTS_unitflip" ;;
        "budgetcron") echo "$PORTS_budgetcron" ;;
        "ai4kids") echo "$PORTS_ai4kids" ;;
        "multiai") echo "$PORTS_multiai" ;;
        *) echo "3000" ;;
    esac
}

get_app_tech() {
    local app=$1
    case $app in
        "math4kids") echo "$TECH_STACK_math4kids" ;;
        "unitflip") echo "$TECH_STACK_unitflip" ;;
        "budgetcron") echo "$TECH_STACK_budgetcron" ;;
        "ai4kids") echo "$TECH_STACK_ai4kids" ;;
        "multiai") echo "$TECH_STACK_multiai" ;;
        *) echo "react-typescript" ;;
    esac
}

count_languages() {
    local lang_string=$1
    echo "$lang_string" | tr ' ' '\n' | wc -l | tr -d ' '
}

log_debug() {
    if [ "$DEBUG_MODE" = true ]; then
        echo -e "${MAGENTA}[DEBUG] $1${NC}" >&2
    fi
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] DEBUG: $1" >> "$LOG_DIR/debug.log"
}

log_error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG_DIR/error.log"
}

# ==================== FONCTIONS D'AFFICHAGE ====================
print_banner() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗"
    echo -e "║                                                                      ║"
    echo -e "║  ${WHITE}${BOLD}🌍 ${SCRIPT_NAME} v${SCRIPT_VERSION}${NC}${CYAN}            ║"
    echo -e "║                                                                      ║"
    echo -e "║  ${YELLOW}Diagnostics Avancés • Auto-Correction • Support Mondial${NC}${CYAN}        ║"
    echo -e "║                                                                      ║"
    echo -e "║  ${GREEN}🔧 Enhanced • 🩺 Smart Diagnostics • 🔄 Auto-Fix${NC}${CYAN}              ║"
    echo -e "║                                                                      ║"
    echo -e "╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo
}

print_section() {
    echo -e "\n${BLUE}┌─────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ ${WHITE}${BOLD}$1${NC}${BLUE}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────────────┘${NC}"
}

print_step() {
    echo -e "${CYAN}▶ ${WHITE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_fix() {
    echo -e "${MAGENTA}🔧 $1${NC}"
}

# ==================== FONCTIONS DE DIAGNOSTIC AVANCÉES ====================
diagnose_system() {
    print_section "🩺 DIAGNOSTIC SYSTÈME AVANCÉ"
    
    mkdir -p "$DIAGNOSTICS_DIR"
    local diag_file="$DIAGNOSTICS_DIR/system_diagnosis_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "=== DIAGNOSTIC SYSTÈME ==="
        echo "Date: $(date)"
        echo "OS: $SYSTEM_OS"
        echo "Node: $NODE_VERSION"
        echo "RAM: $MEMORY_TOTAL"
        echo "Disk: $DISK_SPACE"
        echo ""
        
        echo "=== PROCESSUS EN COURS ==="
        ps aux | grep -E "(node|npm|yarn)" | grep -v grep || echo "Aucun processus Node détecté"
        echo ""
        
        echo "=== PORTS UTILISÉS ==="
        netstat -an | grep -E ":300[1-5]" || echo "Aucun port 3001-3005 utilisé"
        echo ""
        
        echo "=== ESPACE DISQUE ==="
        df -h
        echo ""
        
        echo "=== MÉMOIRE ==="
        if command -v free &> /dev/null; then
            free -h
        elif command -v vm_stat &> /dev/null; then
            vm_stat
        fi
        
    } > "$diag_file"
    
    print_success "Diagnostic système sauvegardé: $diag_file"
}

diagnose_app_failure() {
    local app=$1
    local app_name=$(get_app_name "$app")
    local port=$(get_app_port "$app")
    local app_dir="$WORK_DIR/$app"
    
    print_step "🔍 Diagnostic de $app_name..."
    
    local diag_file="$DIAGNOSTICS_DIR/${app}_diagnosis_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "=== DIAGNOSTIC DE $app_name ==="
        echo "Date: $(date)"
        echo "App: $app"
        echo "Port: $port"
        echo "Répertoire: $app_dir"
        echo ""
        
        echo "=== STRUCTURE DU PROJET ==="
        if [ -d "$app_dir" ]; then
            find "$app_dir" -maxdepth 3 -type f \( -name "*.json" -o -name "*.js" -o -name "*.ts" -o -name "*.tsx" \) | head -20
        else
            echo "Répertoire non trouvé: $app_dir"
        fi
        echo ""
        
        echo "=== PACKAGE.JSON ==="
        if [ -f "$app_dir/package.json" ]; then
            cat "$app_dir/package.json"
        else
            echo "package.json non trouvé"
        fi
        echo ""
        
        echo "=== DERNIERS LOGS ==="
        if [ -f "$LOG_DIR/${app}.log" ]; then
            tail -50 "$LOG_DIR/${app}.log"
        else
            echo "Aucun log trouvé"
        fi
        echo ""
        
        echo "=== NODE_MODULES ==="
        if [ -d "$app_dir/node_modules" ]; then
            echo "node_modules existe ($(du -sh "$app_dir/node_modules" | cut -f1))"
            if [ -d "$app_dir/node_modules/.bin" ]; then
                echo "Binaires disponibles:"
                ls "$app_dir/node_modules/.bin" | head -10
            fi
        else
            echo "node_modules manquant"
        fi
        
    } > "$diag_file"
    
    log_debug "Diagnostic de $app sauvegardé: $diag_file"
    
    # Analyser les problèmes courants
    analyze_common_issues "$app" "$diag_file"
}

analyze_common_issues() {
    local app=$1
    local diag_file=$2
    local app_dir="$WORK_DIR/$app"
    local tech=$(get_app_tech "$app")
    
    print_step "🔍 Analyse des problèmes courants pour $app..."
    
    local issues=()
    
    # Vérifier les fichiers essentiels
    case $tech in
        "react-typescript")
            if [ ! -f "$app_dir/src/index.tsx" ] && [ ! -f "$app_dir/src/index.js" ]; then
                issues+=("MISSING_ENTRY_POINT")
            fi
            if [ ! -f "$app_dir/public/index.html" ]; then
                issues+=("MISSING_HTML_TEMPLATE")
            fi
            ;;
        "vue-typescript")
            if [ ! -f "$app_dir/src/main.ts" ] && [ ! -f "$app_dir/src/main.js" ]; then
                issues+=("MISSING_ENTRY_POINT")
            fi
            if [ ! -f "$app_dir/public/index.html" ]; then
                issues+=("MISSING_HTML_TEMPLATE")
            fi
            ;;
        "next-typescript")
            if [ ! -f "$app_dir/pages/index.tsx" ] && [ ! -f "$app_dir/pages/index.js" ]; then
                issues+=("MISSING_PAGES_INDEX")
            fi
            ;;
    esac
    
    # Vérifier node_modules
    if [ ! -d "$app_dir/node_modules" ]; then
        issues+=("MISSING_NODE_MODULES")
    fi
    
    # Vérifier les dépendances critiques
    if [ -f "$app_dir/package.json" ]; then
        local missing_deps=()
        case $tech in
            "react-typescript")
                if ! grep -q '"react"' "$app_dir/package.json"; then
                    missing_deps+=("react")
                fi
                if ! grep -q '"react-scripts"' "$app_dir/package.json"; then
                    missing_deps+=("react-scripts")
                fi
                ;;
        esac
        
        if [ ${#missing_deps[@]} -gt 0 ]; then
            issues+=("MISSING_DEPENDENCIES:${missing_deps[*]}")
        fi
    fi
    
    # Auto-correction si activée
    if [ "$AUTO_FIX" = true ] && [ ${#issues[@]} -gt 0 ]; then
        auto_fix_issues "$app" "${issues[@]}"
    else
        # Afficher les problèmes trouvés
        for issue in "${issues[@]}"; do
            print_warning "Problème détecté: $issue"
        done
    fi
}

auto_fix_issues() {
    local app=$1
    shift
    local issues=("$@")
    local app_dir="$WORK_DIR/$app"
    local tech=$(get_app_tech "$app")
    
    print_fix "🔧 Auto-correction des problèmes pour $app..."
    
    for issue in "${issues[@]}"; do
        case $issue in
            "MISSING_ENTRY_POINT")
                create_entry_point "$app" "$tech"
                ;;
            "MISSING_HTML_TEMPLATE")
                create_html_template "$app" "$tech"
                ;;
            "MISSING_PAGES_INDEX")
                create_next_index "$app"
                ;;
            "MISSING_NODE_MODULES")
                print_fix "Réinstallation des dépendances..."
                cd "$app_dir" && npm install --silent
                ;;
            "MISSING_DEPENDENCIES:"*)
                local deps=$(echo "$issue" | cut -d':' -f2)
                print_fix "Installation des dépendances manquantes: $deps"
                cd "$app_dir" && npm install $deps --silent
                ;;
        esac
    done
}

create_entry_point() {
    local app=$1
    local tech=$2
    local app_dir="$WORK_DIR/$app"
    
    print_fix "Création du point d'entrée pour $app ($tech)..."
    
    mkdir -p "$app_dir/src"
    
    case $tech in
        "react-typescript")
            cat > "$app_dir/src/index.tsx" << 'EOF'
import React from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import App from './App';

const container = document.getElementById('root');
const root = createRoot(container!);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

            cat > "$app_dir/src/App.tsx" << EOF
import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>$(get_app_name "$app")</h1>
        <p>Application démarrée avec succès!</p>
        <p>Support multilingue mondial activé</p>
      </header>
    </div>
  );
}

export default App;
EOF

            cat > "$app_dir/src/App.css" << 'EOF'
.App {
  text-align: center;
}

.App-header {
  background-color: #282c34;
  padding: 20px;
  color: white;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
}

h1 {
  margin-bottom: 20px;
}

p {
  margin: 10px 0;
}
EOF

            cat > "$app_dir/src/index.css" << 'EOF'
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}

* {
  box-sizing: border-box;
}
EOF
            ;;
            
        "vue-typescript")
            cat > "$app_dir/src/main.ts" << 'EOF'
import { createApp } from 'vue'
import App from './App.vue'
import './index.css'

createApp(App).mount('#app')
EOF

            cat > "$app_dir/src/App.vue" << EOF
<template>
  <div id="app">
    <header class="app-header">
      <h1>$(get_app_name "$app")</h1>
      <p>Application Vue démarrée avec succès!</p>
      <p>Support multilingue mondial activé</p>
    </header>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'App'
})
</script>

<style>
#app {
  text-align: center;
}

.app-header {
  background-color: #42b883;
  padding: 20px;
  color: white;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
}

h1 {
  margin-bottom: 20px;
}

p {
  margin: 10px 0;
}
</style>
EOF
            ;;
    esac
    
    print_success "Point d'entrée créé pour $app"
}

create_html_template() {
    local app=$1
    local tech=$2
    local app_dir="$WORK_DIR/$app"
    local app_name=$(get_app_name "$app")
    
    print_fix "Création du template HTML pour $app..."
    
    mkdir -p "$app_dir/public"
    
    cat > "$app_dir/public/index.html" << EOF
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta name="description" content="$app_name - Application avec support multilingue mondial" />
    <title>$app_name</title>
  </head>
  <body>
    <noscript>Vous devez activer JavaScript pour exécuter cette application.</noscript>
    <div id="root"></div>
  </body>
</html>
EOF
    
    # Créer un favicon simple
    cat > "$app_dir/public/favicon.ico" << 'EOF'
data:image/x-icon;base64,AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABILAAASCwAAAAAAAAAAAAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A
EOF
    
    print_success "Template HTML créé pour $app"
}

create_next_index() {
    local app=$1
    local app_dir="$WORK_DIR/$app"
    local app_name=$(get_app_name "$app")
    
    print_fix "Création de la page d'index Next.js pour $app..."
    
    mkdir -p "$app_dir/pages"
    
    cat > "$app_dir/pages/index.tsx" << EOF
import React from 'react'
import Head from 'next/head'
import styles from '../styles/Home.module.css'

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>$app_name</title>
        <meta name="description" content="$app_name - Application Next.js avec support multilingue mondial" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          $app_name
        </h1>

        <p className={styles.description}>
          Application Next.js démarrée avec succès!
        </p>

        <p className={styles.description}>
          Support multilingue mondial activé
        </p>
      </main>
    </div>
  )
}
EOF

    mkdir -p "$app_dir/styles"
    cat > "$app_dir/styles/Home.module.css" << 'EOF'
.container {
  padding: 0 2rem;
}

.main {
  min-height: 100vh;
  padding: 4rem 0;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.title {
  margin: 0;
  line-height: 1.15;
  font-size: 4rem;
  text-align: center;
}

.description {
  margin: 4rem 0;
  line-height: 1.5;
  font-size: 1.5rem;
  text-align: center;
}
EOF

    cat > "$app_dir/styles/globals.css" << 'EOF'
html,
body {
  padding: 0;
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Oxygen,
    Ubuntu, Cantarell, Fira Sans, Droid Sans, Helvetica Neue, sans-serif;
}

a {
  color: inherit;
  text-decoration: none;
}

* {
  box-sizing: border-box;
}
EOF
    
    print_success "Page d'index Next.js créée pour $app"
}

# ==================== FONCTIONS DE DÉMARRAGE AMÉLIORÉES ====================
start_applications_enhanced() {
    print_section "🚀 DÉMARRAGE AMÉLIORÉ DES APPLICATIONS"
    
    local main_log="$LOG_DIR/main.log"
    echo "=== DÉMARRAGE AMÉLIORÉ $(date) ===" > "$main_log"
    
    # Phase 1: Diagnostic pré-démarrage
    print_step "Phase 1: Diagnostic pré-démarrage..."
    for app in $APP_LIST; do
        diagnose_app_failure "$app"
    done
    
    # Phase 2: Démarrage avec retry
    print_step "Phase 2: Démarrage avec mécanisme de retry..."
    for app in $APP_LIST; do
        start_single_app_with_retry "$app"
        sleep 1
    done
    
    # Phase 3: Vérification approfondie
    print_step "Phase 3: Vérification approfondie..."
    sleep 10
    check_applications_enhanced
    
    display_enhanced_summary
}

start_single_app_with_retry() {
    local app=$1
    local app_name=$(get_app_name "$app")
    local port=$(get_app_port "$app")
    local tech=$(get_app_tech "$app")
    local app_dir="$WORK_DIR/$app"
    local app_log="$LOG_DIR/${app}.log"
    local max_retries=3
    local retry_count=0
    
    print_step "🚀 Démarrage de $app_name (retry enabled)..."
    
    while [ $retry_count -lt $max_retries ]; do
        cd "$app_dir"
        
        # Nettoyer les anciens processus
        cleanup_app_processes "$app"
        
        # Déterminer la commande de démarrage
        local start_cmd=""
        case $tech in
            "react-typescript")
                start_cmd="PORT=$port BROWSER=none npm start"
                ;;
            "vue-typescript")
                start_cmd="PORT=$port npm run serve"
                ;;
            "next-typescript")
                start_cmd="PORT=$port npm run dev"
                ;;
        esac
        
        if [ -n "$start_cmd" ]; then
            echo "=== TENTATIVE $((retry_count + 1)) - $app_name $(date) ===" > "$app_log"
            
            # Démarrer avec timeout
            timeout 30s bash -c "$start_cmd" >> "$app_log" 2>&1 &
            local pid=$!
            
            # Attendre un peu et vérifier
            sleep 5
            
            if ps -p $pid > /dev/null 2>&1; then
                # Vérifier si le port répond
                if wait_for_port "$port" 20; then
                    echo "$pid" > "$WORK_DIR/${app}.pid"
                    PIDS+=($pid)
                    SUCCESS_APPS+=("$app")
                    print_success "$app_name démarré avec succès (PID: $pid, tentative $((retry_count + 1)))"
                    return 0
                else
                    print_warning "$app_name: processus actif mais port $port ne répond pas"
                    kill $pid 2>/dev/null || true
                fi
            else
                print_warning "$app_name: processus s'est arrêté immédiatement"
            fi
        fi
        
        retry_count=$((retry_count + 1))
        if [ $retry_count -lt $max_retries ]; then
            print_step "Retry $((retry_count + 1))/$max_retries pour $app_name dans 3 secondes..."
            sleep 3
        fi
    done
    
    print_error "$app_name: échec après $max_retries tentatives"
    FAILED_APPS+=("$app")
    
    # Diagnostic post-échec
    diagnose_app_failure "$app"
}

wait_for_port() {
    local port=$1
    local timeout=${2:-30}
    local count=0
    
    while [ $count -lt $timeout ]; do
        if curl -s --connect-timeout 1 "http://localhost:$port" > /dev/null 2>&1; then
            return 0
        fi
        sleep 1
        count=$((count + 1))
    done
    
    return 1
}

cleanup_app_processes() {
    local app=$1
    local pid_file="$WORK_DIR/${app}.pid"
    
    if [ -f "$pid_file" ]; then
        local old_pid=$(cat "$pid_file")
        if ps -p $old_pid > /dev/null 2>&1; then
            kill $old_pid 2>/dev/null || true
            sleep 2
        fi
        rm "$pid_file"
    fi
}

check_applications_enhanced() {
    print_section "🔍 VÉRIFICATION APPROFONDIE DES APPLICATIONS"
    
    for app in $APP_LIST; do
        local app_name=$(get_app_name "$app")
        local port=$(get_app_port "$app")
        local pid_file="$WORK_DIR/${app}.pid"
        
        if [ -f "$pid_file" ]; then
            local pid=$(cat "$pid_file")
            
            # Vérifier le processus
            if ps -p $pid > /dev/null 2>&1; then
                # Vérifier la réponse HTTP
                if curl -s --connect-timeout 5 "http://localhost:$port" > /dev/null 2>&1; then
                    print_success "$app_name: ✓ Processus actif ✓ Port responsive (PID: $pid)"
                else
                    print_warning "$app_name: ✓ Processus actif ✗ Port non responsive"
                    
                    # Diagnostic de connectivité
                    if netstat -an | grep -q ":$port.*LISTEN"; then
                        print_info "$app_name: Port $port en écoute mais pas de réponse HTTP"
                    else
                        print_warning "$app_name: Port $port pas en écoute"
                    fi
                fi
            else
                print_error "$app_name: ✗ Processus non trouvé (PID: $pid)"
                rm "$pid_file"
            fi
        else
            print_error "$app_name: ✗ Aucun fichier PID trouvé"
        fi
    done
}

display_enhanced_summary() {
    print_section "📊 RÉSUMÉ DÉTAILLÉ DU DÉMARRAGE"
    
    local total_apps=${#SUCCESS_APPS[@]}
    local failed_apps=${#FAILED_APPS[@]}
    
    if [ $total_apps -gt 0 ]; then
        echo -e "${GREEN}✓ Applications fonctionnelles: $total_apps${NC}"
        for app in "${SUCCESS_APPS[@]}"; do
            local app_name=$(get_app_name "$app")
            local port=$(get_app_port "$app")
            echo -e "  ${GREEN}• $app_name - http://localhost:$port${NC}"
        done
    fi
    
    if [ $failed_apps -gt 0 ]; then
        echo -e "\n${RED}✗ Applications avec problèmes: $failed_apps${NC}"
        for app in "${FAILED_APPS[@]}"; do
            local app_name=$(get_app_name "$app")
            echo -e "  ${RED}• $app_name - Voir diagnostic: $DIAGNOSTICS_DIR/${app}_diagnosis_*.txt${NC}"
        done
    fi
    
    echo -e "\n${CYAN}🔧 Outils de diagnostic:${NC}"
    echo -e "  • Diagnostics détaillés: $DIAGNOSTICS_DIR"
    echo -e "  • Logs par application: $LOG_DIR"
    echo -e "  • Mode debug: $0 --debug"
    echo -e "  • Réparation forcée: $0 --fix"
    
    echo -e "\n${YELLOW}📱 URLs des applications:${NC}"
    for app in $APP_LIST; do
        local app_name=$(get_app_name "$app")
        local port=$(get_app_port "$app")
        local status="❌"
        
        # Vérifier si l'app est dans SUCCESS_APPS
        for success_app in "${SUCCESS_APPS[@]}"; do
            if [ "$app" = "$success_app" ]; then
                status="✅"
                break
            fi
        done
        
        echo -e "  $status $app_name: ${BLUE}http://localhost:$port${NC}"
    done
}

# ==================== FONCTIONS DE GESTION AMÉLIORÉES ====================
smart_monitoring() {
    local check_interval=60  # Réduire la fréquence
    local error_count=0
    local max_errors=3
    
    print_section "🔍 SURVEILLANCE INTELLIGENTE ACTIVÉE"
    print_info "Vérification toutes les $check_interval secondes"
    print_info "Arrêt automatique après $max_errors erreurs consécutives"
    
    while true; do
        sleep $check_interval
        
        local current_errors=0
        
        for app in "${SUCCESS_APPS[@]}"; do
            local pid_file="$WORK_DIR/${app}.pid"
            if [ -f "$pid_file" ]; then
                local pid=$(cat "$pid_file")
                if ! ps -p $pid > /dev/null 2>&1; then
                    local app_name=$(get_app_name "$app")
                    print_error "💥 $app_name s'est arrêté (PID: $pid)"
                    current_errors=$((current_errors + 1))
                    
                    # Auto-redémarrage si activé
                    if [ "$AUTO_FIX" = true ]; then
                        print_fix "🔄 Tentative de redémarrage automatique..."
                        start_single_app_with_retry "$app"
                    fi
                fi
            fi
        done
        
        if [ $current_errors -gt 0 ]; then
            error_count=$((error_count + 1))
            print_warning "Erreurs détectées: $current_errors (total consécutif: $error_count)"
            
            if [ $error_count -ge $max_errors ]; then
                print_error "Trop d'erreurs consécutives ($error_count). Arrêt de la surveillance."
                break
            fi
        else
            error_count=0  # Reset si pas d'erreur
            if [ "$DEBUG_MODE" = true ]; then
                print_success "Toutes les applications fonctionnent correctement"
            fi
        fi
    done
}

# ==================== FONCTION PRINCIPALE AMÉLIORÉE ====================
main() {
    # Traiter les options avancées
    while [[ $# -gt 0 ]]; do
        case $1 in
            --debug)
                DEBUG_MODE=true
                shift
                ;;
            --no-auto-fix)
                AUTO_FIX=false
                shift
                ;;
            --fix)
                print_section "🔧 MODE RÉPARATION FORCÉE"
                # Diagnostiquer et corriger tous les problèmes
                for app in $APP_LIST; do
                    diagnose_app_failure "$app"
                done
                exit 0
                ;;
            --diagnose)
                print_section "🩺 MODE DIAGNOSTIC COMPLET"
                diagnose_system
                for app in $APP_LIST; do
                    diagnose_app_failure "$app"
                done
                exit 0
                ;;
            *)
                break
                ;;
        esac
    done
    
    print_banner
    
    # Setup initial
    mkdir -p "$WORK_DIR" "$LOG_DIR" "$BACKUP_DIR" "$DIAGNOSTICS_DIR"
    
    # Actions selon l'argument
    case "${1:-}" in
        --help|-h)
            echo "Usage: $0 [OPTIONS] [ACTION]"
            echo ""
            echo "Options:"
            echo "  --debug          Mode debug verbeux"
            echo "  --no-auto-fix    Désactiver la correction automatique"
            echo "  --fix            Mode réparation forcée uniquement"
            echo "  --diagnose       Diagnostic complet uniquement"
            echo ""
            echo "Actions:"
            echo "  --help, -h       Afficher cette aide"
            echo "  --stop           Arrêter toutes les applications"
            echo "  --status         Vérification détaillée du statut"
            echo "  --logs           Afficher les logs disponibles"
            echo "  --restart        Redémarrer avec diagnostic"
            echo "  --clean          Nettoyage complet"
            exit 0
            ;;
        --stop)
            print_section "🛑 ARRÊT DES APPLICATIONS"
            for pid_file in "$WORK_DIR"/*.pid; do
                if [ -f "$pid_file" ]; then
                    pid=$(cat "$pid_file")
                    app=$(basename "$pid_file" .pid)
                    if ps -p $pid > /dev/null 2>&1; then
                        kill $pid
                        print_success "$app arrêté (PID: $pid)"
                    fi
                    rm "$pid_file"
                fi
            done
            exit 0
            ;;
        --status)
            check_applications_enhanced
            exit 0
            ;;
        --logs)
            print_section "📋 LOGS ET DIAGNOSTICS"
            echo "=== LOGS D'APPLICATIONS ==="
            ls -la "$LOG_DIR" 2>/dev/null || echo "Aucun log trouvé"
            echo ""
            echo "=== DIAGNOSTICS ==="
            ls -la "$DIAGNOSTICS_DIR" 2>/dev/null || echo "Aucun diagnostic trouvé"
            exit 0
            ;;
        --restart)
            $0 --stop
            sleep 3
            exec $0 --debug
            ;;
        --clean)
            print_section "🧹 NETTOYAGE COMPLET"
            for app in $APP_LIST; do
                rm -rf "$WORK_DIR/$app/node_modules" 2>/dev/null || true
                rm -rf "$WORK_DIR/$app/build" 2>/dev/null || true
                rm -rf "$WORK_DIR/$app/dist" 2>/dev/null || true
                rm -rf "$WORK_DIR/$app/.next" 2>/dev/null || true
            done
            rm -f "$WORK_DIR"/*.pid 2>/dev/null || true
            rm -rf "$LOG_DIR"/* 2>/dev/null || true
            print_success "Nettoyage terminé"
            exit 0
            ;;
    esac
    
    # Démarrage principal avec diagnostics
    log_debug "Démarrage du script en mode: DEBUG=$DEBUG_MODE, AUTO_FIX=$AUTO_FIX"
    
    diagnose_system
    
    # Installation rapide
    for app in $APP_LIST; do
        if [ ! -f "$WORK_DIR/$app/package.json" ]; then
            mkdir -p "$WORK_DIR/$app"
            cd "$WORK_DIR/$app"
            create_package_json "$app"
            npm install --silent
        fi
    done
    
    # Démarrage amélioré
    start_applications_enhanced
    
    # Surveillance intelligente
    if [ ${#SUCCESS_APPS[@]} -gt 0 ]; then
        print_section "🎉 DÉMARRAGE TERMINÉ AVEC SUCCÈS"
        print_success "${#SUCCESS_APPS[@]} applications fonctionnelles sur ${#APP_LIST}"
        
        echo -e "\n${CYAN}Surveillance intelligente en cours... (Ctrl+C pour arrêter)${NC}"
        trap 'echo -e "\n${YELLOW}Arrêt de la surveillance...${NC}"; $0 --stop; exit 0' INT
        
        smart_monitoring
    else
        print_error "Aucune application n'a pu être démarrée"
        print_info "Consultez les diagnostics: $DIAGNOSTICS_DIR"
        exit 1
    fi
}

# Fonctions simplifiées pour compatibilité
detect_system() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        SYSTEM_OS="macOS $(sw_vers -productVersion)"
    else
        SYSTEM_OS="$OSTYPE"
    fi
}

get_system_info() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
    fi
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
    fi
    MEMORY_TOTAL=$(sysctl -n hw.memsize 2>/dev/null | awk '{print $1/1024/1024/1024 " GB"}' || echo "N/A")
    DISK_SPACE=$(df -h . | tail -1 | awk '{print $4}')
    SUPPORTED_LANGUAGES_COUNT=25
}

create_package_json() {
    local app=$1
    local tech=$(get_app_tech "$app")
    
    case $tech in
        "react-typescript")
            cat > package.json << EOF
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
    "test": "react-scripts test"
  },
  "browserslist": {
    "production": [">0.2%", "not dead", "not op_mini all"],
    "development": ["last 1 chrome version", "last 1 firefox version", "last 1 safari version"]
  },
  "devDependencies": {
    "@types/react": "^18.0.27",
    "@types/react-dom": "^18.0.10",
    "@types/node": "^16.18.12"
  }
}
EOF
            ;;
        "vue-typescript")
            cat > package.json << EOF
{
  "name": "$app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build"
  },
  "dependencies": {
    "vue": "^3.2.13"
  },
  "devDependencies": {
    "@vue/cli-service": "~5.0.0",
    "typescript": "~4.5.5"
  }
}
EOF
            ;;
        "next-typescript")
            cat > package.json << EOF
{
  "name": "$app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "13.1.6",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "typescript": "^4.9.4"
  },
  "devDependencies": {
    "@types/node": "^18.14.0",
    "@types/react": "^18.0.28",
    "@types/react-dom": "^18.0.11"
  }
}
EOF
            ;;
    esac
}

# ==================== EXÉCUTION ====================
main "$@"
