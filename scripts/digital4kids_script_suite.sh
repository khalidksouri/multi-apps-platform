# Stabilisation
echo -e "${BLUE}⏳ Stabilisation de la plateforme (30 secondes)...${NC}"
sleep 30

# Affichage final du statut
echo ""
echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                    🎉 PLATEFORME DÉMARRÉE 🎉                    ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

check_all_status

echo ""
echo -e "${CYAN}🎯 DIGITAL4KIDS MULTILINGUE DISPONIBLE :${NC}"
echo -e "   ${GREEN}✨ Support de 10 langues (FR, EN, ES, DE, IT, PT, AR, ZH, JA, RU)${NC}"
echo -e "   ${GREEN}✨ Interface responsive avec glassmorphism${NC}"
echo -e "   ${GREEN}✨ 6 modules d'apprentissage marketing${NC}"
echo -e "   ${GREEN}✨ 3 groupes d'âge (5-8, 9-12, 13-14 ans)${NC}"
echo ""
echo -e "${YELLOW}🚀 Applications démarrées: $started_apps/6${NC}"
}

# Arrêter toutes les applications
stop_all_apps() {
    show_header
    echo -e "${YELLOW}🛑 Arrêt de toutes les applications...${NC}"
    echo ""
    
    for app_name in $APPS_NAMES; do
        stop_app "$app_name"
    done
    
    echo ""
    echo -e "${GREEN}✅ Toutes les applications arrêtées${NC}"
}

# Vérifier le statut de toutes les applications
check_all_status() {
    local running_apps=0
    local working_urls=""
    
    for app_name in $APPS_NAMES; do
        local app_info=$(get_app_info "$app_name")
        local port="${app_info%:*}"
        
        if check_app_status "$app_name"; then
            running_apps=$((running_apps + 1))
            working_urls="$working_urls http://localhost:$port"
        fi
    done
    
    echo ""
    if [ $running_apps -gt 0 ]; then
        echo -e "${GREEN}✅ $running_apps applications actives${NC}"
        echo -e "${CYAN}🌐 URLs disponibles :${NC}"
        for url in $working_urls; do
            echo -e "   $url"
        done
    else
        echo -e "${RED}❌ Aucune application active${NC}"
    fi
}

# Réparer toutes les applications
repair_all_apps() {
    show_header
    echo -e "${BLUE}🔧 RÉPARATION DE TOUTES LES APPLICATIONS${NC}"
    echo -e "${BLUE}======================================${NC}"
    echo ""
    
    local repaired=0
    for app_name in $APPS_NAMES; do
        if repair_app "$app_name"; then
            repaired=$((repaired + 1))
        fi
        echo ""
    done
    
    echo -e "${GREEN}✅ $repaired/6 applications réparées${NC}"
    echo ""
}

# Créer toutes les applications manquantes
create_missing_apps() {
    show_header
    echo -e "${BLUE}🏗️ CRÉATION DES APPLICATIONS MANQUANTES${NC}"
    echo -e "${BLUE}=======================================${NC}"
    echo ""
    
    # Créer le workspace si nécessaire
    mkdir -p "$WORKSPACE_DIR"
    
    local created=0
    
    for app_name in $APPS_NAMES; do
        local app_dir="$WORKSPACE_DIR/$app_name"
        
        if [ ! -d "$app_dir" ]; then
            echo -e "${YELLOW}🏗️ Création de $app_name...${NC}"
            
            if [ "$app_name" = "digital4kids" ]; then
                # Digital4Kids déjà créé par create_digital4kids_complete
                echo -e "  ℹ️ Digital4Kids sera créé par la fonction dédiée"
            else
                # Créer une application basique
                create_basic_app "$app_name"
                created=$((created + 1))
            fi
        else
            echo -e "${GREEN}✅ $app_name existe déjà${NC}"
        fi
    done
    
    echo ""
    echo -e "${GREEN}✅ $created applications créées${NC}"
}

# Créer une application basique
create_basic_app() {
    local app_name=$1
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    mkdir -p "$app_dir"
    cd "$app_dir"
    
    # Package.json basique
    cat > package.json << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "description": "Application $app_name",
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
    
    # Structure basique
    mkdir -p src public
    
    # Index.html
    cat > public/index.html << EOF
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>$(echo $app_name | tr '[:lower:]' '[:upper:]')</title>
  </head>
  <body>
    <noscript>Vous devez activer JavaScript.</noscript>
    <div id="root"></div>
  </body>
</html>
EOF
    
    # App.js basique
    cat > src/App.js << EOF
import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>🚀 $(echo $app_name | tr '[:lower:]' '[:upper:]')</h1>
        <p>Application démarrée sur le port $port</p>
        <p>✅ Fonctionnelle et prête à être développée</p>
      </header>
    </div>
  );
}

export default App;
EOF
    
    # CSS basique
    cat > src/App.css << EOF
.App {
  text-align: center;
}

.App-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 2rem;
  color: white;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
}

h1 {
  margin-bottom: 1rem;
  text-shadow: 0 2px 4px rgba(0,0,0,0.3);
}

p {
  margin: 0.5rem 0;
  opacity: 0.9;
}
EOF
    
    # Index.js
    cat > src/index.js << EOF
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF
    
    # index.css
    cat > src/index.css << EOF
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

* {
  box-sizing: border-box;
}
EOF
    
    echo -e "  ${GREEN}✅ $app_name créé${NC}"
    cd "$PROJECT_DIR"
}

# Menu interactif
show_interactive_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🎯 MENU PRINCIPAL - PLATEFORME MULTI-APPS${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo ""
        echo -e "${GREEN}1.${NC} 🚀 Configuration complète (Créer + Réparer + Démarrer)"
        echo -e "${GREEN}2.${NC} ▶️  Démarrer toutes les applications"
        echo -e "${GREEN}3.${NC} 🛑 Arrêter toutes les applications"
        echo -e "${GREEN}4.${NC} 📊 Vérifier le statut"
        echo -e "${GREEN}5.${NC} 🔧 Réparer toutes les applications"
        echo -e "${GREEN}6.${NC} 🏗️  Créer les applications manquantes"
        echo -e "${GREEN}7.${NC} 🎯 Créer Digital4Kids multilingue uniquement"
        echo -e "${GREEN}8.${NC} 📝 Afficher les logs"
        echo -e "${GREEN}9.${NC} 🧹 Nettoyer les logs"
        echo -e "${RED}0.${NC} ❌ Quitter"
        echo ""
        echo -e "${YELLOW}Applications: math4kids(3001) unitflip(3002) budgetcron(3003) ai4kids(3004) multiai(3005) digital4kids(3006)${NC}"
        echo ""
        read -p "Votre choix (0-9): " choice
        
        case $choice in
            1)
                setup_complete_platform
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            2)
                start_all_apps_complete
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            3)
                stop_all_apps
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            4)
                show_header
                echo -e "${BLUE}📊 STATUT DES APPLICATIONS${NC}"
                echo -e "${BLUE}==========================${NC}"
                echo ""
                check_all_status
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            5)
                repair_all_apps
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            6)
                create_missing_apps
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            7)
                show_header
                create_digital4kids_complete
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            8)
                show_logs
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            9)
                clean_logs
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            0)
                echo -e "${GREEN}👋 Au revoir !${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Choix invalide${NC}"
                sleep 2
                ;;
        esac
    done
}

# Afficher les logs
show_logs() {
    show_header
    echo -e "${BLUE}📝 LOGS DES APPLICATIONS${NC}"
    echo -e "${BLUE}========================${NC}"
    echo ""
    
    if [ ! -d "$LOG_DIR" ] || [ -z "$(ls -A "$LOG_DIR" 2>/dev/null)" ]; then
        echo -e "${YELLOW}ℹ️ Aucun log disponible${NC}"
        return
    fi
    
    for app_name in $APPS_NAMES; do
        local log_file="$LOG_DIR/${app_name}.log"
        if [ -f "$log_file" ]; then
            echo -e "${CYAN}📄 Logs de $app_name:${NC}"
            echo -e "${YELLOW}$(tail -n 5 "$log_file")${NC}"
            echo ""
        fi
    done
    
    echo -e "${CYAN}📄 Log principal:${NC}"
    if [ -f "$LOG_DIR/platform.log" ]; then
        echo -e "${YELLOW}$(tail -n 10 "$LOG_DIR/platform.log")${NC}"
    else
        echo -e "${YELLOW}Aucun log principal${NC}"
    fi
}

# Nettoyer les logs
clean_logs() {
    show_header
    echo -e "${BLUE}🧹 NETTOYAGE DES LOGS${NC}"
    echo -e "${BLUE}===================${NC}"
    echo ""
    
    if [ -d "$LOG_DIR" ]; then
        rm -rf "$LOG_DIR"/*
        echo -e "${GREEN}✅ Logs nettoyés${NC}"
    else
        echo -e "${YELLOW}ℹ️ Aucun log à nettoyer${NC}"
    fi
}

# Logging amélioré
log() {
    local level=$1
    local color=$2
    local message=$3
    echo -e "${color}[${level}] ${message}${NC}"
    
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] ${message}" >> "$LOG_DIR/platform.log"
}

# Vérifications système
check_system_requirements() {
    echo -e "${BLUE}🔍 Vérification des prérequis...${NC}"
    
    local errors=0
    
    # Node.js
    if ! command -v node >/dev/null 2>&1; then
        echo -e "${RED}❌ Node.js n'est pas installé${NC}"
        errors=$((errors + 1))
    else
        local node_version=$(node --version)
        echo -e "${GREEN}✅ Node.js: $node_version${NC}"
    fi
    
    # npm
    if ! command -v npm >/dev/null 2>&1; then
        echo -e "${RED}❌ npm n'est pas installé${NC}"
        errors=$((errors + 1))
    else
        local npm_version=$(npm --version)
        echo -e "${GREEN}✅ npm: $npm_version${NC}"
    fi
    
    # curl (pour les tests de santé)
    if ! command -v curl >/dev/null 2>&1; then
        echo -e "${RED}❌ curl n'est pas installé${NC}"
        errors=$((errors + 1))
    else
        echo -e "${GREEN}✅ curl disponible${NC}"
    fi
    
    # lsof (pour la gestion des ports)
    if ! command -v lsof >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️ lsof n'est pas disponible (gestion des ports limitée)${NC}"
    else
        echo -e "${GREEN}✅ lsof disponible${NC}"
    fi
    
    # Espace disque
    local available_space=$(df -h "$PROJECT_DIR" | awk 'NR==2 {print $4}')
    echo -e "${GREEN}✅ Espace disponible: $available_space${NC}"
    
    # Permissions d'écriture
    if [ -w "$PROJECT_DIR" ]; then
        echo -e "${GREEN}✅ Permissions d'écriture: OK${NC}"
    else
        echo -e "${RED}❌ Pas de permissions d'écriture sur $PROJECT_DIR${NC}"
        errors=$((errors + 1))
    fi
    
    echo ""
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✅ Tous les prérequis sont satisfaits${NC}"
        return 0
    else
        echo -e "${RED}❌ $errors erreur(s) détectée(s)${NC}"
        echo -e "${YELLOW}Veuillez installer les dépendances manquantes${NC}"
        return 1
    fi
}

# Point d'entrée principal
main() {
    # Créer les répertoires nécessaires
    mkdir -p "$LOG_DIR"
    mkdir -p "$WORKSPACE_DIR"
    
    # Log du démarrage
    log "INFO" "$GREEN" "Script démarré"
    
    case "${1:-menu}" in
        "setup"|"complete")
            check_system_requirements && setup_complete_platform
            ;;
        "start")
            start_all_apps_complete
            ;;
        "stop")
            stop_all_apps
            ;;
        "status")
            show_header
            echo -e "${BLUE}📊 STATUT DES APPLICATIONS${NC}"
            echo -e "${BLUE}==========================${NC}"
            echo ""
            check_all_status
            ;;
        "repair")
            repair_all_apps
            ;;
        "create")
            create_missing_apps
            ;;
        "digital4kids")
            show_header
            create_digital4kids_complete
            ;;
        "logs")
            show_logs
            ;;
        "clean")
            clean_logs
            ;;
        "check")
            show_header
            check_system_requirements
            ;;
        "menu"|"interactive")
            check_system_requirements && show_interactive_menu
            ;;
        "help"|"-h"|"--help")
            show_header
            echo -e "${CYAN}UTILISATION:${NC}"
            echo ""
            echo -e "  ${GREEN}$0${NC}                    - Menu interactif"
            echo -e "  ${GREEN}$0 setup${NC}             - Configuration complète"
            echo -e "  ${GREEN}$0 start${NC}             - Démarrer toutes les apps"
            echo -e "  ${GREEN}$0 stop${NC}              - Arrêter toutes les apps"
            echo -e "  ${GREEN}$0 status${NC}            - Vérifier le statut"
            echo -e "  ${GREEN}$0 repair${NC}            - Réparer toutes les apps"
            echo -e "  ${GREEN}$0 create${NC}            - Créer les apps manquantes"
            echo -e "  ${GREEN}$0 digital4kids${NC}      - Créer Digital4Kids uniquement"
            echo -e "  ${GREEN}$0 logs${NC}              - Afficher les logs"
            echo -e "  ${GREEN}$0 clean${NC}             - Nettoyer les logs"
            echo -e "  ${GREEN}$0 check${NC}             - Vérifier les prérequis"
            echo ""
            echo -e "${YELLOW}Applications gérées:${NC}"
            echo -e "  math4kids (port 3001), unitflip (port 3002), budgetcron (port 3003)"
            echo -e "  ai4kids (port 3004), multiai (port 3005), digital4kids (port 3006)"
            echo ""
            ;;
        *)
            echo -e "${RED}❌ Commande inconnue: $1${NC}"
            echo -e "${CYAN}Utilisez '$0 help' pour voir l'aide${NC}"
            exit 1
            ;;
    esac
    
    # Log de fin
    log "INFO" "$GREEN" "Script terminé"
}

# =============================================================================
# GESTION DES SIGNAUX
# =============================================================================

# Fonction de nettoyage en cas d'interruption
cleanup() {
    echo ""
    echo -e "${YELLOW}🛑 Interruption détectée...${NC}"
    log "INFO" "$YELLOW" "Interruption du script"
    exit 0
}

# Capturer les signaux d'interruption
trap cleanup SIGINT SIGTERM

# =============================================================================
# EXÉCUTION
# =============================================================================

# Vérifier que le script n'est pas exécuté en tant que root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}❌ Ne pas exécuter ce script en tant que root${NC}"
    exit 1
fi

# Exécuter la fonction principale avec tous les arguments
main "$@"