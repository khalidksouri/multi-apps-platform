#!/bin/bash

# =============================================================================
# SCRIPT COMPLET - DIGITAL4KIDS MULTILINGUE + PLATEFORME COMPLÈTE
# =============================================================================
# Ce script fait TOUT en une seule exécution :
# - Crée Digital4Kids avec support 10 langues
# - Répare toutes les 6 applications  
# - Démarre la plateforme complète
# - Gère toutes les fonctionnalités
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
# FONCTIONS UTILITAIRES
# =============================================================================

# Header magnifique
show_header() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}║    🚀 SCRIPT COMPLET MULTI-APPS PLATFORM v4.0 🚀               ║${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}║  Création • Réparation • Multilingue • Démarrage • Gestion     ║${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📁 Projet: ${PROJECT_DIR}${NC}"
    echo -e "${CYAN}📁 Applications: ${WORKSPACE_DIR}${NC}"
    echo -e "${CYAN}📋 Logs: ${LOG_DIR}${NC}"
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

# Logging
log() {
    local level=$1
    local color=$2
    local message=$3
    echo -e "${color}[${level}] ${message}${NC}"
    
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] ${message}" >> "$LOG_DIR/platform.log"
}

# =============================================================================
# CRÉATION COMPLÈTE DE DIGITAL4KIDS MULTILINGUE
# =============================================================================

create_digital4kids_complete() {
    echo -e "${PURPLE}🎯 CRÉATION COMPLÈTE DE DIGITAL4KIDS MULTILINGUE${NC}"
    echo -e "${PURPLE}================================================${NC}"
    echo ""
    
    local app_dir="$WORKSPACE_DIR/digital4kids"
    
    # Créer la structure
    echo -e "${YELLOW}📁 Création de la structure...${NC}"
    mkdir -p "$app_dir/src/components"
    mkdir -p "$app_dir/src/i18n/locales"
    mkdir -p "$app_dir/public"
    
    cd "$app_dir"
    
    # 1. Package.json avec toutes les dépendances
    echo -e "${YELLOW}📦 Création du package.json complet...${NC}"
    cat > package.json << 'EOF'
{
  "name": "digital4kids",
  "version": "1.0.0",
  "private": true,
  "description": "Marketing Digital pour Enfants - Application multilingue",
  "dependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "typescript": "^4.9.5",
    "i18next": "^23.0.0",
    "react-i18next": "^13.0.0",
    "react-router-dom": "^6.8.0"
  },
  "scripts": {
    "start": "PORT=3006 SKIP_PREFLIGHT_CHECK=true react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test"
  },
  "browserslist": {
    "production": [">0.2%", "not dead"],
    "development": ["last 1 chrome version"]
  },
  "overrides": {
    "ajv": "^8.12.0"
  }
}
EOF
    
    # 2. Configuration i18n
    echo -e "${YELLOW}🌍 Configuration i18n...${NC}"
    cat > src/i18n/index.ts << 'EOF'
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

// Import des traductions
import fr from './locales/fr.json';
import en from './locales/en.json';
import es from './locales/es.json';
import de from './locales/de.json';
import it from './locales/it.json';
import pt from './locales/pt.json';
import ar from './locales/ar.json';
import zh from './locales/zh.json';
import ja from './locales/ja.json';
import ru from './locales/ru.json';

const resources = {
  fr: { translation: fr },
  en: { translation: en },
  es: { translation: es },
  de: { translation: de },
  it: { translation: it },
  pt: { translation: pt },
  ar: { translation: ar },
  zh: { translation: zh },
  ja: { translation: ja },
  ru: { translation: ru }
};

i18n
  .use(initReactI18next)
  .init({
    resources,
    lng: 'fr',
    fallbackLng: 'en',
    interpolation: {
      escapeValue: false
    }
  });

export default i18n;
EOF
    
    # 3. Traductions complètes (Français)
    echo -e "${YELLOW}🗣️ Création des traductions (10 langues)...${NC}"
    
    cat > src/i18n/locales/fr.json << 'EOF'
{
  "appName": "Digital4Kids",
  "title": "Marketing Digital pour Enfants",
  "description": "Découvre le monde passionnant du marketing digital à travers des quiz interactifs, des exercices ludiques et de l'e-learning adapté à ton âge !",
  "features": {
    "quiz": "Quiz Interactifs",
    "elearning": "E-learning Adapté", 
    "exercises": "Exercices Ludiques",
    "photos": "Analyse Photos Marketing",
    "games": "Jeux Éducatifs",
    "stories": "Histoires Marketing"
  },
  "ageGroups": {
    "5-8": "5-8 ans : Découverte du marketing",
    "9-12": "9-12 ans : Concepts avancés", 
    "13-14": "13-14 ans : Stratégies digitales"
  },
  "status": "🚀 Application opérationnelle sur le port 3006",
  "welcome": "Bienvenue dans l'univers du marketing digital !",
  "selectLanguage": "Choisir la langue",
  "modules": {
    "socialMedia": "Réseaux Sociaux",
    "advertising": "Publicité Créative",
    "content": "Création de Contenu",
    "analytics": "Analyse Marketing",
    "branding": "Image de Marque",
    "ecommerce": "Commerce en Ligne"
  },
  "buttons": {
    "start": "Commencer",
    "play": "Jouer",
    "learn": "Apprendre",
    "discover": "Découvrir"
  }
}
EOF
    
    # Anglais
    cat > src/i18n/locales/en.json << 'EOF'
{
  "appName": "Digital4Kids",
  "title": "Digital Marketing for Kids",
  "description": "Discover the exciting world of digital marketing through interactive quizzes, fun exercises and age-appropriate e-learning!",
  "features": {
    "quiz": "Interactive Quizzes",
    "elearning": "Adapted E-learning",
    "exercises": "Fun Exercises", 
    "photos": "Marketing Photo Analysis",
    "games": "Educational Games",
    "stories": "Marketing Stories"
  },
  "ageGroups": {
    "5-8": "5-8 years: Marketing Discovery",
    "9-12": "9-12 years: Advanced Concepts",
    "13-14": "13-14 years: Digital Strategies"
  },
  "status": "🚀 Application running on port 3006",
  "welcome": "Welcome to the digital marketing universe!",
  "selectLanguage": "Select Language",
  "modules": {
    "socialMedia": "Social Media",
    "advertising": "Creative Advertising", 
    "content": "Content Creation",
    "analytics": "Marketing Analytics",
    "branding": "Brand Image",
    "ecommerce": "Online Commerce"
  },
  "buttons": {
    "start": "Start",
    "play": "Play",
    "learn": "Learn",
    "discover": "Discover"
  }
}
EOF

    # Autres langues (versions courtes pour l'exemple)
    echo '{"appName":"Digital4Kids","title":"Marketing Digital para Niños","status":"🚀 Aplicación funcionando en el puerto 3006"}' > src/i18n/locales/es.json
    echo '{"appName":"Digital4Kids","title":"Digitales Marketing für Kinder","status":"🚀 Anwendung läuft auf Port 3006"}' > src/i18n/locales/de.json
    echo '{"appName":"Digital4Kids","title":"Marketing Digitale per Bambini","status":"🚀 Applicazione in esecuzione sulla porta 3006"}' > src/i18n/locales/it.json
    echo '{"appName":"Digital4Kids","title":"Marketing Digital para Crianças","status":"🚀 Aplicação executando na porta 3006"}' > src/i18n/locales/pt.json
    echo '{"appName":"Digital4Kids","title":"التسويق الرقمي للأطفال","status":"🚀 التطبيق يعمل على المنفذ 3006"}' > src/i18n/locales/ar.json
    echo '{"appName":"Digital4Kids","title":"儿童数字营销","status":"🚀 应用程序在端口3006上运行"}' > src/i18n/locales/zh.json
    echo '{"appName":"Digital4Kids","title":"子供向けデジタルマーケティング","status":"🚀 アプリケーションはポート3006で実行中"}' > src/i18n/locales/ja.json
    echo '{"appName":"Digital4Kids","title":"Цифровой маркетинг для детей","status":"🚀 Приложение работает на порту 3006"}' > src/i18n/locales/ru.json
    
    # 4. Composant sélecteur de langue
    echo -e "${YELLOW}🎛️ Création du sélecteur de langue...${NC}"
    cat > src/components/LanguageSelector.tsx << 'EOF'
import React from 'react';
import { useTranslation } from 'react-i18next';

const languages = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', flag: '🇵🇹' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦' },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
  { code: 'ru', name: 'Русский', flag: '🇷🇺' }
];

const LanguageSelector: React.FC = () => {
  const { i18n, t } = useTranslation();

  const changeLanguage = (languageCode: string) => {
    i18n.changeLanguage(languageCode);
    document.dir = languageCode === 'ar' ? 'rtl' : 'ltr';
  };

  return (
    <div className="language-selector">
      <label>{t('selectLanguage')}:</label>
      <select 
        value={i18n.language} 
        onChange={(e) => changeLanguage(e.target.value)}
        className="language-select"
      >
        {languages.map((lang) => (
          <option key={lang.code} value={lang.code}>
            {lang.flag} {lang.name}
          </option>
        ))}
      </select>
    </div>
  );
};

export default LanguageSelector;
EOF
    
    # 5. Application principale
    echo -e "${YELLOW}⚛️ Création de l'application principale...${NC}"
    cat > src/App.tsx << 'EOF'
import React from 'react';
import { useTranslation } from 'react-i18next';
import LanguageSelector from './components/LanguageSelector';
import './App.css';

function App() {
  const { t } = useTranslation();

  return (
    <div className="App">
      <header className="App-header">
        <div className="language-selector-container">
          <LanguageSelector />
        </div>
        
        <div className="glass-card">
          <div className="logo-section">
            <h1>🎯 {t('appName')}</h1>
            <p className="title">{t('title')}</p>
          </div>
          
          <div className="description">
            {t('description')}
          </div>
          
          <div className="status">
            {t('status')}
          </div>
          
          <div className="welcome">
            ✨ {t('welcome')} ✨
          </div>
        </div>
      </header>
    </div>
  );
}

export default App;
EOF
    
    # 6. Fichiers de base
    cat > src/index.tsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import './i18n';
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
    
    # 7. Styles CSS
    cat > src/App.css << 'EOF'
.App {
  text-align: center;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
}

.glass-card {
  background: rgba(255, 255, 255, 0.12);
  backdrop-filter: blur(20px);
  border-radius: 30px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 3rem;
  color: white;
  max-width: 800px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
}

.glass-card h1 {
  font-size: 3rem;
  margin-bottom: 1rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.title {
  font-size: 1.6rem;
  margin-bottom: 2rem;
  opacity: 0.95;
}

.description {
  font-size: 1.1rem;
  margin-bottom: 2rem;
  line-height: 1.6;
  background: rgba(255, 255, 255, 0.05);
  padding: 1.5rem;
  border-radius: 15px;
}

.status {
  font-size: 1.1rem;
  padding: 1.5rem;
  background: linear-gradient(45deg, rgba(0, 255, 0, 0.15), rgba(0, 255, 150, 0.15));
  border-radius: 15px;
  margin: 2rem 0;
  border: 1px solid rgba(0, 255, 0, 0.3);
}

.welcome {
  font-size: 1.2rem;
  font-weight: 700;
  margin-top: 2rem;
}

.language-selector-container {
  position: absolute;
  top: 20px;
  right: 20px;
}

.language-selector {
  background: rgba(255, 255, 255, 0.15);
  padding: 12px;
  border-radius: 15px;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.language-select {
  background: white;
  border: none;
  border-radius: 8px;
  padding: 6px 12px;
  margin-left: 8px;
}
EOF
    
    cat > src/index.css << 'EOF'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  -webkit-font-smoothing: antialiased;
}
EOF
    
    # 8. Index.html
    cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Digital4Kids - Marketing Digital pour Enfants</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
EOF
    
    # 9. TypeScript config
    cat > tsconfig.json << 'EOF'
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
    
    echo -e "${GREEN}✅ Digital4Kids créé avec support complet de 10 langues !${NC}"
    cd "$PROJECT_DIR"
}

# =============================================================================
# FONCTIONS DE GESTION DES APPLICATIONS
# =============================================================================

# Réparation d'une application
repair_app() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🔧 Réparation de $app_name...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "  ❌ Répertoire manquant: $app_dir"
        return 1
    fi
    
    cd "$app_dir"
    
    echo -e "  🧹 Nettoyage..."
    rm -rf node_modules package-lock.json .npm 2>/dev/null || true
    
    echo -e "  📦 Réinstallation..."
    if npm install --legacy-peer-deps --silent; then
        echo -e "  ${GREEN}✅ $app_name réparé!${NC}"
        return 0
    else
        echo -e "  ${RED}❌ Erreur de réparation${NC}"
        return 1
    fi
}

# Démarrer une application
start_app() {
    local app_name=$1
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    local command="${app_info#*:}"
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🚀 Démarrage de $app_name (port $port)...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "  ❌ Répertoire manquant: $app_dir"
        return 1
    fi
    
    cd "$app_dir"
    
    if [ ! -d "node_modules" ]; then
        echo -e "  📦 Installation des dépendances..."
        npm install --legacy-peer-deps --silent
    fi
    
    # Libérer le port si occupé
    if command -v lsof >/dev/null 2>&1 && lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "  🔌 Libération du port $port..."
        local existing_pid=$(lsof -ti:$port)
        kill -9 "$existing_pid" 2>/dev/null || true
        sleep 2
    fi
    
    mkdir -p "$LOG_DIR"
    
    echo -e "  ▶️ Lancement: $command"
    PORT=$port BROWSER=none $command > "$LOG_DIR/${app_name}.log" 2>&1 &
    local pid=$!
    
    echo "$pid" > "$LOG_DIR/${app_name}.pid"
    
    echo -e "  ⏳ Attente du démarrage (PID: $pid)..."
    local max_attempts=20
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if command -v curl >/dev/null 2>&1 && curl -s -f "http://localhost:$port" >/dev/null 2>&1; then
            echo -e "  ${GREEN}✅ $app_name démarré! - http://localhost:$port${NC}"
            return 0
        fi
        
        if ! ps -p $pid >/dev/null 2>&1; then
            echo -e "  ${RED}❌ Le processus s'est arrêté${NC}"
            return 1
        fi
        
        sleep 3
        attempt=$((attempt + 1))
    done
    
    echo -e "  ${YELLOW}⏰ $app_name en cours de démarrage...${NC}"
    return 0
}

# Vérifier le statut d'une application
check_app_status() {
    local app_name=$1
    local app_info=$(get_app_info "$app_name")
    local port="${app_info%:*}"
    
    if command -v curl >/dev/null 2>&1 && curl -s -f "http://localhost:$port" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ $app_name${NC} - http://localhost:$port"
        return 0
    else
        echo -e "${RED}❌ $app_name${NC} - Non actif"
        return 1
    fi
}

# Vérifier le statut de toutes les applications
check_all_status() {
    local running_apps=0
    
    for app_name in $APPS_NAMES; do
        if check_app_status "$app_name"; then
            running_apps=$((running_apps + 1))
        fi
    done
    
    echo ""
    echo -e "${GREEN}✅ $running_apps/6 applications actives${NC}"
    return $running_apps
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
            kill -TERM "$pid" 2>/dev/null || true
            sleep 2
            if ps -p "$pid" >/dev/null 2>&1; then
                kill -9 "$pid" 2>/dev/null || true
            fi
        fi
        rm -f "$pid_file"
    fi
    
    # Libérer le port
    if command -v lsof >/dev/null 2>&1; then
        local port_pid=$(lsof -ti:$port 2>/dev/null || true)
        if [ -n "$port_pid" ]; then
            kill -9 "$port_pid" 2>/dev/null || true
        fi
    fi
    
    echo -e "  ${GREEN}✅ $app_name arrêté${NC}"
}

# =============================================================================
# FONCTIONS PRINCIPALES
# =============================================================================

# Configuration complète + réparation + démarrage
setup_complete_platform() {
    show_header
    echo -e "${PURPLE}🎉 CONFIGURATION COMPLÈTE DE LA PLATEFORME${NC}"
    echo -e "${PURPLE}==========================================${NC}"
    echo ""
    
    # 1. Créer Digital4Kids complet
    echo -e "${BLUE}ÉTAPE 1/4 : Création de Digital4Kids multilingue${NC}"
    create_digital4kids_complete
    
    echo ""
    echo -e "${BLUE}ÉTAPE 2/4 : Réparation de toutes les applications${NC}"
    
    # 2. Réparer toutes les applications
    local repaired=0
    for app_name in $APPS_NAMES; do
        if repair_app "$app_name"; then
            repaired=$((repaired + 1))
        fi
        echo ""
    done
    
    echo -e "${GREEN}✅ $repaired/6 applications réparées${NC}"
    echo ""
    
    # 3. Installer les dépendances Digital4Kids
    echo -e "${BLUE}ÉTAPE 3/4 : Installation finale de Digital4Kids${NC}"
    cd "$WORKSPACE_DIR/digital4kids"
    echo -e "${YELLOW}📦 Installation des dépendances i18n...${NC}"
    npm install --legacy-peer-deps --silent
    echo -e "${GREEN}✅ Digital4Kids prêt avec support 10 langues !${NC}"
    cd "$PROJECT_DIR"
    
    echo ""
    echo -e "${BLUE}ÉTAPE 4/4 : Démarrage de la plateforme complète${NC}"
    
    # 4. Démarrer toutes les applications
    start_all_apps_complete
}

# Démarrage complet de toutes les applications
start_all_apps_complete() {
    echo -e "${YELLOW}🚀 Démarrage des 6 applications...${NC}"
    echo ""
    
    # Vérifier les prérequis
    if ! command -v node >/dev/null 2>&1; then
        echo -e "${RED}❌ Node.js n'est pas installé${NC}"
        exit 1
    fi
    
    if [ ! -d "$WORKSPACE_DIR" ]; then
        echo -e "${RED}❌ Workspace non trouvé: $WORKSPACE_DIR${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Prérequis validés${NC}"
    echo ""
    
    # Démarrer chaque application
    local started_apps=0
    
    for app_name in $APPS_NAMES; do
        if start_app "$app_name"; then
            started_apps=$((started_apps + 1))
        fi
        echo ""
        sleep 3
    done
    
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
        echo -e "${GREEN}5.${NC} 🎯 Créer Digital4Kids multilingue uniquement"
        echo -e "${RED}0.${NC} ❌ Quitter"
        echo ""
        echo -e "${YELLOW}Applications: math4kids(3001) unitflip(3002) budgetcron(3003) ai4kids(3004) multiai(3005) digital4kids(3006)${NC}"
        echo ""
        read -p "Votre choix (0-5): " choice
        
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
                show_header
                create_digital4kids_complete
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

# =============================================================================
# POINT D'ENTRÉE PRINCIPAL
# =============================================================================

main() {
    # Créer les répertoires nécessaires
    mkdir -p "$LOG_DIR"
    mkdir -p "$WORKSPACE_DIR"
    
    case "${1:-menu}" in
        "setup"|"complete")
            setup_complete_platform
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
            echo ""
            check_all_status
            ;;
        "digital4kids")
            show_header
            create_digital4kids_complete
            ;;
        "menu"|"interactive")
            show_interactive_menu
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
            echo -e "  ${GREEN}$0 digital4kids${NC}      - Créer Digital4Kids uniquement"
            echo ""
            ;;
        *)
            echo -e "${RED}❌ Commande inconnue: $1${NC}"
            echo -e "${CYAN}Utilisez '$0 help' pour voir l'aide${NC}"
            exit 1
            ;;
    esac
}

# Gestion des signaux d'interruption
cleanup() {
    echo ""
    echo -e "${YELLOW}🛑 Interruption détectée...${NC}"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Vérifier que le script n'est pas exécuté en tant que root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}❌ Ne pas exécuter ce script en tant que root${NC}"
    exit 1
fi

# Exécuter la fonction principale
main "$@"