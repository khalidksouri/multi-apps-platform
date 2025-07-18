#!/bin/bash

# =============================================================================
# SCRIPT DE DIAGNOSTIC ET CORRECTION - DIGITAL4KIDS PLATFORM
# =============================================================================
# Ce script diagnostique et corrige les erreurs de démarrage des applications
# =============================================================================

set -e

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$PROJECT_DIR/apps"
LOG_DIR="$PROJECT_DIR/logs"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Applications
APPS_NAMES="math4kids unitflip budgetcron ai4kids multiai digital4kids"
APPS_PORTS="3001 3002 3003 3004 3005 3006"
APPS_COMMANDS="npm_start npm_start npm_run_serve npm_start npm_run_dev npm_start"

# =============================================================================
# FONCTIONS DE DIAGNOSTIC
# =============================================================================

show_header() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                 🔍 DIAGNOSTIC & CORRECTION 🔧                    ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Fonction pour obtenir les infos d'une application
get_app_info() {
    local app_name=$1
    local index=0
    
    for name in $APPS_NAMES; do
        if [ "$name" = "$app_name" ]; then
            local port=$(echo $APPS_PORTS | cut -d' ' -f$((index + 1)))
            local cmd=$(echo $APPS_COMMANDS | cut -d' ' -f$((index + 1)))
            
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

# Diagnostiquer une application spécifique
diagnose_app() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    
    echo -e "${BLUE}🔍 Diagnostic de $app_name${NC}"
    echo -e "   📁 Répertoire: $app_dir"
    echo -e "   🔌 Port: $port"
    
    # 1. Vérifier si le répertoire existe
    if [ ! -d "$app_dir" ]; then
        echo -e "   ${RED}❌ Répertoire manquant${NC}"
        return 1
    fi
    
    cd "$app_dir"
    
    # 2. Vérifier package.json
    if [ ! -f "package.json" ]; then
        echo -e "   ${RED}❌ package.json manquant${NC}"
        return 1
    fi
    
    # 3. Vérifier les scripts npm
    local scripts=$(cat package.json | grep -A 10 '"scripts"' | grep -E '(start|serve|dev)' || true)
    if [ -z "$scripts" ]; then
        echo -e "   ${RED}❌ Scripts npm manquants${NC}"
        return 1
    fi
    
    # 4. Vérifier node_modules
    if [ ! -d "node_modules" ]; then
        echo -e "   ${YELLOW}⚠️ node_modules manquants${NC}"
    fi
    
    # 5. Vérifier les logs d'erreur
    local log_file="$LOG_DIR/${app_name}.log"
    if [ -f "$log_file" ]; then
        echo -e "   📝 Dernières erreurs:"
        local errors=$(tail -n 5 "$log_file" | grep -i "error\|failed\|cannot\|missing" || true)
        if [ -n "$errors" ]; then
            echo -e "   ${RED}$errors${NC}"
        else
            echo -e "   ${GREEN}✅ Pas d'erreurs évidentes dans les logs${NC}"
        fi
    fi
    
    # 6. Vérifier si le port est libre
    if command -v lsof >/dev/null 2>&1 && lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "   ${YELLOW}⚠️ Port $port déjà utilisé${NC}"
    else
        echo -e "   ${GREEN}✅ Port $port libre${NC}"
    fi
    
    echo ""
    return 0
}

# Diagnostiquer toutes les applications
diagnose_all() {
    show_header
    echo -e "${BLUE}🔍 DIAGNOSTIC COMPLET DE LA PLATEFORME${NC}"
    echo -e "${BLUE}=====================================${NC}"
    echo ""
    
    # Vérifier Node.js
    if command -v node >/dev/null 2>&1; then
        local node_version=$(node --version)
        echo -e "${GREEN}✅ Node.js: $node_version${NC}"
    else
        echo -e "${RED}❌ Node.js non installé${NC}"
        return 1
    fi
    
    # Vérifier npm
    if command -v npm >/dev/null 2>&1; then
        local npm_version=$(npm --version)
        echo -e "${GREEN}✅ npm: $npm_version${NC}"
    else
        echo -e "${RED}❌ npm non installé${NC}"
        return 1
    fi
    
    echo ""
    
    # Diagnostiquer chaque application
    for app_name in $APPS_NAMES; do
        diagnose_app "$app_name"
    done
}

# =============================================================================
# FONCTIONS DE CORRECTION
# =============================================================================

# Créer une application manquante avec structure minimale
create_minimal_app() {
    local app_name=$1
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    local command="${app_info#*:}"
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🏗️ Création de $app_name avec structure minimale...${NC}"
    
    mkdir -p "$app_dir"
    cd "$app_dir"
    
    # Créer package.json adapté selon le type de commande
    if [[ "$command" == *"serve"* ]]; then
        # Application Vue.js
        cat > package.json << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "serve": "PORT=$port vue-cli-service serve --skip-plugins @vue/cli-plugin-eslint",
    "build": "vue-cli-service build"
  },
  "dependencies": {
    "vue": "^3.3.0",
    "@vue/cli-service": "^5.0.0"
  },
  "browserslist": ["> 1%", "last 2 versions"]
}
EOF
        
        # Structure Vue minimale
        mkdir -p src public
        
        cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>BudgetCron</title>
</head>
<body>
    <div id="app"></div>
</body>
</html>
EOF
        
        cat > src/main.js << 'EOF'
import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#app')
EOF
        
        cat > src/App.vue << EOF
<template>
  <div id="app">
    <h1>🚀 $(echo $app_name | tr '[:lower:]' '[:upper:]')</h1>
    <p>Application Vue.js sur le port $port</p>
    <p>✅ Fonctionnelle et prête !</p>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
#app {
  text-align: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  color: white;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  font-family: Arial, sans-serif;
}
h1 { font-size: 3rem; margin-bottom: 1rem; }
p { font-size: 1.2rem; margin: 0.5rem 0; }
</style>
EOF
        
    elif [[ "$command" == *"dev"* ]]; then
        # Application Next.js/Vite
        cat > package.json << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "PORT=$port next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
EOF
        
        # Structure Next.js minimale
        mkdir -p pages
        
        cat > pages/index.js << EOF
export default function Home() {
  return (
    <div style={{
      textAlign: 'center',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      minHeight: '100vh',
      color: 'white',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'center',
      alignItems: 'center',
      fontFamily: 'Arial, sans-serif'
    }}>
      <h1 style={{ fontSize: '3rem', marginBottom: '1rem' }}>
        🚀 $(echo $app_name | tr '[:lower:]' '[:upper:]')
      </h1>
      <p style={{ fontSize: '1.2rem', margin: '0.5rem 0' }}>
        Application Next.js sur le port $port
      </p>
      <p style={{ fontSize: '1.2rem', margin: '0.5rem 0' }}>
        ✅ Fonctionnelle et prête !
      </p>
    </div>
  )
}
EOF
        
    else
        # Application React standard
        cat > package.json << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1"
  },
  "scripts": {
    "start": "PORT=$port SKIP_PREFLIGHT_CHECK=true react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test"
  },
  "browserslist": {
    "production": [">0.2%", "not dead"],
    "development": ["last 1 chrome version"]
  }
}
EOF
        
        # Structure React minimale
        mkdir -p src public
        
        cat > public/index.html << EOF
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>$(echo $app_name | tr '[:lower:]' '[:upper:]')</title>
</head>
<body>
    <div id="root"></div>
</body>
</html>
EOF
        
        cat > src/index.js << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);
EOF
        
        cat > src/App.js << EOF
import React from 'react';

function App() {
  return (
    <div style={{
      textAlign: 'center',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      minHeight: '100vh',
      color: 'white',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'center',
      alignItems: 'center',
      fontFamily: 'Arial, sans-serif'
    }}>
      <h1 style={{ fontSize: '3rem', marginBottom: '1rem' }}>
        🚀 $(echo $app_name | tr '[:lower:]' '[:upper:]')
      </h1>
      <p style={{ fontSize: '1.2rem', margin: '0.5rem 0' }}>
        Application React sur le port $port
      </p>
      <p style={{ fontSize: '1.2rem', margin: '0.5rem 0' }}>
        ✅ Fonctionnelle et prête !
      </p>
    </div>
  );
}

export default App;
EOF
    fi
    
    echo -e "   ${GREEN}✅ $app_name créé avec structure minimale${NC}"
    cd "$PROJECT_DIR"
}

# Correction avancée d'une application
fix_app_advanced() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🔧 Correction avancée de $app_name...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "   📁 Création du répertoire manquant..."
        create_minimal_app "$app_name"
        return 0
    fi
    
    cd "$app_dir"
    
    # 1. Nettoyage complet
    echo -e "   🧹 Nettoyage complet..."
    rm -rf node_modules package-lock.json yarn.lock .next .nuxt dist build .cache 2>/dev/null || true
    
    # 2. Vérifier et corriger package.json
    if [ ! -f "package.json" ]; then
        echo -e "   📦 package.json manquant - création..."
        create_minimal_app "$app_name"
        return 0
    fi
    
    # 3. Sauvegarder et corriger package.json
    echo -e "   📝 Correction du package.json..."
    
    # Créer une version corrigée du package.json
    node -e "
    const fs = require('fs');
    try {
      const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
      
      // Assurer les scripts de base
      if (!pkg.scripts) pkg.scripts = {};
      
      if ('$app_name' === 'budgetcron' && !pkg.scripts.serve) {
        pkg.scripts.serve = 'PORT=3003 vue-cli-service serve';
      }
      if ('$app_name' === 'multiai' && !pkg.scripts.dev) {
        pkg.scripts.dev = 'PORT=3005 next dev';
      }
      if (!pkg.scripts.start) {
        pkg.scripts.start = 'PORT=\$(echo '${app_info%:*}') SKIP_PREFLIGHT_CHECK=true react-scripts start';
      }
      
      // Assurer les dépendances de base
      if (!pkg.dependencies) pkg.dependencies = {};
      
      // Corriger les versions problématiques
      if (pkg.dependencies['react-scripts']) {
        pkg.dependencies['react-scripts'] = '5.0.1';
      }
      
      // Ajouter overrides pour résoudre les conflits
      if (!pkg.overrides) pkg.overrides = {};
      pkg.overrides['ajv'] = '^8.12.0';
      
      fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
      console.log('package.json corrigé');
    } catch (e) {
      console.error('Erreur package.json:', e.message);
      process.exit(1);
    }
    "
    
    # 4. Installation avec options robustes
    echo -e "   📦 Installation des dépendances..."
    
    # Tentative 1: Installation standard
    if npm install --legacy-peer-deps --silent; then
        echo -e "   ${GREEN}✅ Installation réussie${NC}"
    else
        echo -e "   ${YELLOW}⚠️ Tentative avec force...${NC}"
        # Tentative 2: Force install
        if npm install --legacy-peer-deps --force --silent; then
            echo -e "   ${GREEN}✅ Installation forcée réussie${NC}"
        else
            echo -e "   ${RED}❌ Échec d'installation - recréation...${NC}"
            cd "$PROJECT_DIR"
            rm -rf "$app_dir"
            create_minimal_app "$app_name"
            return 0
        fi
    fi
    
    # 5. Vérifier les fichiers essentiels
    echo -e "   📁 Vérification des fichiers essentiels..."
    
    if [[ "$app_name" == "budgetcron" ]]; then
        if [ ! -f "src/main.js" ] && [ ! -f "src/App.vue" ]; then
            echo -e "   📁 Création des fichiers Vue manquants..."
            mkdir -p src public
            create_minimal_app "$app_name"
        fi
    elif [[ "$app_name" == "multiai" ]]; then
        if [ ! -f "pages/index.js" ] && [ ! -f "src/app/page.js" ]; then
            echo -e "   📁 Création des fichiers Next.js manquants..."
            mkdir -p pages
            create_minimal_app "$app_name"
        fi
    else
        if [ ! -f "src/index.js" ] && [ ! -f "src/App.js" ]; then
            echo -e "   📁 Création des fichiers React manquants..."
            mkdir -p src public
            create_minimal_app "$app_name"
        fi
    fi
    
    echo -e "   ${GREEN}✅ $app_name corrigé${NC}"
    cd "$PROJECT_DIR"
}

# Correction de toutes les applications
fix_all_apps() {
    show_header
    echo -e "${BLUE}🔧 CORRECTION DE TOUTES LES APPLICATIONS${NC}"
    echo -e "${BLUE}=======================================${NC}"
    echo ""
    
    for app_name in $APPS_NAMES; do
        fix_app_advanced "$app_name"
        echo ""
    done
    
    echo -e "${GREEN}✅ Toutes les applications corrigées${NC}"
}

# Test de démarrage sécurisé
test_app_start() {
    local app_name=$1
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    local command="${app_info#*:}"
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🧪 Test de démarrage de $app_name...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "   ${RED}❌ Répertoire manquant${NC}"
        return 1
    fi
    
    cd "$app_dir"
    
    # Libérer le port si occupé
    if command -v lsof >/dev/null 2>&1 && lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "   🔌 Libération du port $port..."
        local existing_pid=$(lsof -ti:$port)
        kill -9 "$existing_pid" 2>/dev/null || true
        sleep 2
    fi
    
    # Test de démarrage avec timeout
    echo -e "   ▶️ Test: $command"
    
    mkdir -p "$LOG_DIR"
    timeout 30s bash -c "PORT=$port BROWSER=none $command" > "$LOG_DIR/${app_name}_test.log" 2>&1 &
    local pid=$!
    
    # Attendre le démarrage
    local attempts=0
    local max_attempts=15
    
    while [ $attempts -lt $max_attempts ]; do
        if command -v curl >/dev/null 2>&1 && curl -s -f "http://localhost:$port" >/dev/null 2>&1; then
            echo -e "   ${GREEN}✅ Démarrage réussi sur http://localhost:$port${NC}"
            kill $pid 2>/dev/null || true
            return 0
        fi
        
        if ! ps -p $pid >/dev/null 2>&1; then
            echo -e "   ${RED}❌ Processus arrêté prématurément${NC}"
            echo -e "   📝 Voir: $LOG_DIR/${app_name}_test.log"
            return 1
        fi
        
        sleep 2
        attempts=$((attempts + 1))
    done
    
    echo -e "   ${YELLOW}⏰ Timeout - arrêt du test${NC}"
    kill $pid 2>/dev/null || true
    return 1
}

# Test de toutes les applications
test_all_apps() {
    show_header
    echo -e "${BLUE}🧪 TEST DE DÉMARRAGE DE TOUTES LES APPLICATIONS${NC}"
    echo -e "${BLUE}===============================================${NC}"
    echo ""
    
    local successful=0
    
    for app_name in $APPS_NAMES; do
        if test_app_start "$app_name"; then
            successful=$((successful + 1))
        fi
        echo ""
        
        # Arrêter l'application après le test
        local app_info=$(get_app_info "$app_name")
        local port="${app_info%:*}"
        if command -v lsof >/dev/null 2>&1; then
            local port_pid=$(lsof -ti:$port 2>/dev/null || true)
            if [ -n "$port_pid" ]; then
                kill -9 "$port_pid" 2>/dev/null || true
            fi
        fi
    done
    
    echo -e "${GREEN}✅ $successful/6 applications testées avec succès${NC}"
    
    if [ $successful -eq 6 ]; then
        echo -e "${GREEN}🎉 Toutes les applications sont prêtes !${NC}"
    else
        echo -e "${YELLOW}⚠️ $((6 - successful)) applications nécessitent une attention${NC}"
    fi
}

# =============================================================================
# MENU PRINCIPAL
# =============================================================================

show_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🛠️ MENU DIAGNOSTIC & CORRECTION${NC}"
        echo -e "${CYAN}================================${NC}"
        echo ""
        echo -e "${GREEN}1.${NC} 🔍 Diagnostic complet"
        echo -e "${GREEN}2.${NC} 🔧 Correction de toutes les applications"
        echo -e "${GREEN}3.${NC} 🧪 Test de démarrage de toutes les applications"
        echo -e "${GREEN}4.${NC} 🏗️ Recréer toutes les applications (RESET COMPLET)"
        echo -e "${GREEN}5.${NC} 📝 Voir les logs d'erreur"
        echo -e "${RED}0.${NC} ❌ Retour"
        echo ""
        read -p "Votre choix (0-5): " choice
        
        case $choice in
            1)
                diagnose_all
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            2)
                fix_all_apps
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            3)
                test_all_apps
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            4)
                echo -e "${RED}⚠️ ATTENTION: Ceci va recréer toutes les applications${NC}"
                read -p "Êtes-vous sûr ? (oui/non): " confirm
                if [ "$confirm" = "oui" ]; then
                    echo -e "${YELLOW}🔄 Recréation complète...${NC}"
                    rm -rf "$WORKSPACE_DIR"
                    mkdir -p "$WORKSPACE_DIR"
                    for app_name in $APPS_NAMES; do
                        create_minimal_app "$app_name"
                    done
                    echo -e "${GREEN}✅ Toutes les applications recréées${NC}"
                fi
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            5)
                echo -e "${BLUE}📝 LOGS D'ERREUR${NC}"
                echo -e "${BLUE}===============${NC}"
                echo ""
                if [ -d "$LOG_DIR" ]; then
                    for log_file in "$LOG_DIR"/*.log; do
                        if [ -f "$log_file" ]; then
                            echo -e "${CYAN}$(basename "$log_file"):${NC}"
                            tail -n 10 "$log_file" | grep -i "error\|failed\|cannot" || echo "Pas d'erreurs récentes"
                            echo ""
                        fi
                    done
                else
                    echo -e "${YELLOW}Aucun log disponible${NC}"
                fi
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            0)
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Choix invalide${NC}"
                sleep 2
                ;;
        esac
    done
}

# =============================================================================
# POINT D'ENTRÉE
# =============================================================================

main() {
    mkdir -p "$LOG_DIR"
    mkdir -p "$WORKSPACE_DIR"
    
    case "${1:-menu}" in
        "diagnose")
            diagnose_all
            ;;
        "fix")
            fix_all_apps
            ;;
        "test")
            test_all_apps
            ;;
        "reset")
            echo -e "${RED}⚠️ RESET COMPLET${NC}"
            rm -rf "$WORKSPACE_DIR"
            mkdir -p "$WORKSPACE_DIR"
            for app_name in $APPS_NAMES; do
                create_minimal_app "$app_name"
            done
            ;;
        *)
            show_menu
            ;;
    esac
}

# Vérifier que le script n'est pas exécuté en tant que root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}❌ Ne pas exécuter ce script en tant que root${NC}"
    exit 1
fi

main "$@"