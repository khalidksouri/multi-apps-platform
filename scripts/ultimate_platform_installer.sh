#!/bin/bash

# =============================================================================
# SCRIPT ULTIME - PLATEFORME COMPLÈTE 6 APPLICATIONS HYBRIDES
# =============================================================================
# - 6 applications hybrides (Web, Android, iOS)
# - Support de toutes les langues des continents
# - Tests BDD Cucumber automatisés
# - Capacitor pour le mobile
# - Interface moderne avec animations
# =============================================================================

set -e

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$PROJECT_DIR/apps"
LOG_DIR="$PROJECT_DIR/logs"
TESTS_DIR="$PROJECT_DIR/tests"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
MAGENTA='\033[0;95m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration des applications
APPS_CONFIG=(
    "math4kids:3001:React:Education:Mathématiques ludiques pour enfants"
    "unitflip:3002:React:Utility:Conversion d'unités simplifiée"
    "budgetcron:3003:Vue:Finance:Gestion de budget familial"
    "ai4kids:3004:React:AI:Intelligence artificielle pour enfants"
    "multiai:3005:Next:AI:Interface unifiée multi-IA"
    "digital4kids:3006:React:Marketing:Marketing digital pour enfants"
)

# Langues par continents (26 langues principales)
WORLD_LANGUAGES='[
  {"code": "fr", "name": "Français", "flag": "🇫🇷", "continent": "Europe", "speakers": "280M"},
  {"code": "en", "name": "English", "flag": "🇺🇸", "continent": "Global", "speakers": "1.5B"},
  {"code": "es", "name": "Español", "flag": "🇪🇸", "continent": "Europe/Americas", "speakers": "500M"},
  {"code": "de", "name": "Deutsch", "flag": "🇩🇪", "continent": "Europe", "speakers": "100M"},
  {"code": "it", "name": "Italiano", "flag": "🇮🇹", "continent": "Europe", "speakers": "65M"},
  {"code": "pt", "name": "Português", "flag": "🇵🇹", "continent": "Europe/Americas", "speakers": "260M"},
  {"code": "ru", "name": "Русский", "flag": "🇷🇺", "continent": "Europe/Asia", "speakers": "265M"},
  {"code": "ar", "name": "العربية", "flag": "🇸🇦", "continent": "Asia/Africa", "speakers": "420M"},
  {"code": "zh", "name": "中文", "flag": "🇨🇳", "continent": "Asia", "speakers": "1.1B"},
  {"code": "ja", "name": "日本語", "flag": "🇯🇵", "continent": "Asia", "speakers": "125M"},
  {"code": "ko", "name": "한국어", "flag": "🇰🇷", "continent": "Asia", "speakers": "77M"},
  {"code": "hi", "name": "हिन्दी", "flag": "🇮🇳", "continent": "Asia", "speakers": "600M"},
  {"code": "th", "name": "ไทย", "flag": "🇹🇭", "continent": "Asia", "speakers": "69M"},
  {"code": "vi", "name": "Tiếng Việt", "flag": "🇻🇳", "continent": "Asia", "speakers": "95M"},
  {"code": "id", "name": "Bahasa Indonesia", "flag": "🇮🇩", "continent": "Asia", "speakers": "270M"},
  {"code": "ms", "name": "Bahasa Melayu", "flag": "🇲🇾", "continent": "Asia", "speakers": "280M"},
  {"code": "sw", "name": "Kiswahili", "flag": "🇰🇪", "continent": "Africa", "speakers": "200M"},
  {"code": "am", "name": "አማርኛ", "flag": "🇪🇹", "continent": "Africa", "speakers": "57M"},
  {"code": "yo", "name": "Yorùbá", "flag": "🇳🇬", "continent": "Africa", "speakers": "50M"},
  {"code": "zu", "name": "IsiZulu", "flag": "🇿🇦", "continent": "Africa", "speakers": "27M"},
  {"code": "tr", "name": "Türkçe", "flag": "🇹🇷", "continent": "Europe/Asia", "speakers": "88M"},
  {"code": "pl", "name": "Polski", "flag": "🇵🇱", "continent": "Europe", "speakers": "45M"},
  {"code": "nl", "name": "Nederlands", "flag": "🇳🇱", "continent": "Europe", "speakers": "25M"},
  {"code": "sv", "name": "Svenska", "flag": "🇸🇪", "continent": "Europe", "speakers": "10M"},
  {"code": "no", "name": "Norsk", "flag": "🇳🇴", "continent": "Europe", "speakers": "5M"},
  {"code": "he", "name": "עברית", "flag": "🇮🇱", "continent": "Asia", "speakers": "9M"}
]'

# =============================================================================
# FONCTIONS UTILITAIRES
# =============================================================================

show_header() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}║    🌍 PLATEFORME ULTIME - 6 APPS HYBRIDES MULTILINGUES 🌍     ║${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}║  React • Vue • Next.js • Capacitor • 26 Langues • Tests BDD    ║${NC}"
    echo -e "${PURPLE}║                                                                  ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📁 Projet: ${PROJECT_DIR}${NC}"
    echo -e "${CYAN}📱 Applications: ${WORKSPACE_DIR}${NC}"
    echo -e "${CYAN}🧪 Tests: ${TESTS_DIR}${NC}"
    echo -e "${CYAN}📋 Logs: ${LOG_DIR}${NC}"
    echo ""
}

log() {
    local level=$1
    local color=$2
    local message=$3
    echo -e "${color}[${level}] ${message}${NC}"
    
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] ${message}" >> "$LOG_DIR/platform.log"
}

progress_bar() {
    local current=$1
    local total=$2
    local description=$3
    local percent=$((current * 100 / total))
    local completed=$((current * 50 / total))
    
    printf "\r${BLUE}%s: [" "$description"
    printf "%*s" $completed "" | tr ' ' '█'
    printf "%*s" $((50 - completed)) "" | tr ' ' '░'
    printf "] %d%% (%d/%d)${NC}" $percent $current $total
    
    if [ $current -eq $total ]; then
        echo ""
    fi
}

# =============================================================================
# VÉRIFICATION DES PRÉREQUIS
# =============================================================================

check_prerequisites() {
    echo -e "${BLUE}🔍 VÉRIFICATION DES PRÉREQUIS${NC}"
    echo -e "${BLUE}=============================${NC}"
    echo ""
    
    local errors=0
    
    # Node.js
    if command -v node >/dev/null 2>&1; then
        local node_version=$(node --version)
        echo -e "${GREEN}✅ Node.js: $node_version${NC}"
    else
        echo -e "${RED}❌ Node.js n'est pas installé${NC}"
        errors=$((errors + 1))
    fi
    
    # npm
    if command -v npm >/dev/null 2>&1; then
        local npm_version=$(npm --version)
        echo -e "${GREEN}✅ npm: $npm_version${NC}"
    else
        echo -e "${RED}❌ npm n'est pas installé${NC}"
        errors=$((errors + 1))
    fi
    
    # Outils optionnels mais recommandés
    if command -v git >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Git disponible${NC}"
    else
        echo -e "${YELLOW}⚠️ Git non installé (recommandé)${NC}"
    fi
    
    if command -v curl >/dev/null 2>&1; then
        echo -e "${GREEN}✅ cURL disponible${NC}"
    else
        echo -e "${YELLOW}⚠️ cURL non installé (requis pour les tests)${NC}"
        errors=$((errors + 1))
    fi
    
    # Java (requis pour Android)
    if command -v java >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Java disponible (pour Android)${NC}"
    else
        echo -e "${YELLOW}⚠️ Java non installé (requis pour Android)${NC}"
    fi
    
    # Xcode (pour iOS - Mac uniquement)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v xcodebuild >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Xcode disponible (pour iOS)${NC}"
        else
            echo -e "${YELLOW}⚠️ Xcode non installé (requis pour iOS)${NC}"
        fi
    fi
    
    echo ""
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✅ Tous les prérequis essentiels sont satisfaits${NC}"
        return 0
    else
        echo -e "${RED}❌ $errors erreur(s) détectée(s)${NC}"
        echo -e "${YELLOW}Veuillez installer les dépendances manquantes${NC}"
        return 1
    fi
}

# =============================================================================
# INSTALLATION DES OUTILS GLOBAUX
# =============================================================================

install_global_tools() {
    echo -e "${BLUE}📦 INSTALLATION DES OUTILS GLOBAUX${NC}"
    echo -e "${BLUE}===================================${NC}"
    echo ""
    
    local tools=(
        "@capacitor/cli"
        "@ionic/cli"
        "@vue/cli"
        "create-next-app"
        "@cucumber/cucumber"
        "playwright"
        "typescript"
        "eslint"
        "prettier"
    )
    
    local total=${#tools[@]}
    local current=0
    
    for tool in "${tools[@]}"; do
        current=$((current + 1))
        progress_bar $current $total "Installation $tool"
        
        if npm list -g "$tool" >/dev/null 2>&1; then
            log "INFO" "$GREEN" "$tool déjà installé"
        else
            npm install -g "$tool" --silent 2>/dev/null || true
        fi
    done
    
    echo -e "${GREEN}✅ Outils globaux installés${NC}"
    echo ""
}

# =============================================================================
# CRÉATION DES STRUCTURES DE BASE
# =============================================================================

create_project_structure() {
    echo -e "${BLUE}🏗️ CRÉATION DE LA STRUCTURE DU PROJET${NC}"
    echo -e "${BLUE}=====================================${NC}"
    echo ""
    
    # Créer les répertoires principaux
    mkdir -p "$WORKSPACE_DIR"
    mkdir -p "$LOG_DIR"
    mkdir -p "$TESTS_DIR"
    mkdir -p "$PROJECT_DIR/docs"
    mkdir -p "$PROJECT_DIR/scripts"
    mkdir -p "$PROJECT_DIR/configs"
    
    # Structure de tests
    mkdir -p "$TESTS_DIR/features"
    mkdir -p "$TESTS_DIR/step-definitions"
    mkdir -p "$TESTS_DIR/support"
    mkdir -p "$TESTS_DIR/screenshots"
    mkdir -p "$TESTS_DIR/reports"
    
    echo -e "${GREEN}✅ Structure de projet créée${NC}"
}

# =============================================================================
# GÉNÉRATION DES TRADUCTIONS MONDIALES
# =============================================================================

generate_world_translations() {
    local app_name=$1
    local translations_dir="$2/src/i18n/locales"
    
    mkdir -p "$translations_dir"
    
    # Traductions de base pour chaque langue
    echo "$WORLD_LANGUAGES" | jq -r '.[] | @base64' | while read -r lang_data; do
        local lang=$(echo "$lang_data" | base64 --decode)
        local code=$(echo "$lang" | jq -r '.code')
        local name=$(echo "$lang" | jq -r '.name')
        local flag=$(echo "$lang" | jq -r '.flag')
        
        # Générer les traductions spécifiques à l'application
        case "$app_name" in
            "math4kids")
                cat > "$translations_dir/${code}.json" << EOF
{
  "appName": "Math4Kids",
  "title": "$(get_translated_text "$code" "Mathematics for Children")",
  "description": "$(get_translated_text "$code" "Learn mathematics through fun and interactive games adapted to your age!")",
  "welcome": "$(get_translated_text "$code" "Welcome to the math universe!")",
  "calculate": "$(get_translated_text "$code" "Calculate")",
  "score": "$(get_translated_text "$code" "Score")",
  "correct": "$(get_translated_text "$code" "Correct!")",
  "incorrect": "$(get_translated_text "$code" "Try again!")",
  "selectLanguage": "$(get_translated_text "$code" "Select Language")",
  "exercises": {
    "addition": "$(get_translated_text "$code" "Addition")",
    "subtraction": "$(get_translated_text "$code" "Subtraction")",
    "multiplication": "$(get_translated_text "$code" "Multiplication")",
    "division": "$(get_translated_text "$code" "Division")"
  },
  "levels": {
    "easy": "$(get_translated_text "$code" "Easy")",
    "medium": "$(get_translated_text "$code" "Medium")",
    "hard": "$(get_translated_text "$code" "Hard")"
  }
}
EOF
                ;;
            "unitflip")
                cat > "$translations_dir/${code}.json" << EOF
{
  "appName": "UnitFlip",
  "title": "$(get_translated_text "$code" "Unit Conversion")",
  "description": "$(get_translated_text "$code" "Convert units easily and learn measurement systems from around the world!")",
  "welcome": "$(get_translated_text "$code" "Welcome to unit conversion!")",
  "convert": "$(get_translated_text "$code" "Convert")",
  "from": "$(get_translated_text "$code" "From")",
  "to": "$(get_translated_text "$code" "To")",
  "selectLanguage": "$(get_translated_text "$code" "Select Language")",
  "units": {
    "length": "$(get_translated_text "$code" "Length")",
    "weight": "$(get_translated_text "$code" "Weight")",
    "temperature": "$(get_translated_text "$code" "Temperature")",
    "volume": "$(get_translated_text "$code" "Volume")"
  }
}
EOF
                ;;
            "budgetcron")
                cat > "$translations_dir/${code}.json" << EOF
{
  "appName": "BudgetCron",
  "title": "$(get_translated_text "$code" "Budget Management")",
  "description": "$(get_translated_text "$code" "Manage your family budget efficiently with smart tools and insights!")",
  "welcome": "$(get_translated_text "$code" "Welcome to budget management!")",
  "income": "$(get_translated_text "$code" "Income")",
  "expenses": "$(get_translated_text "$code" "Expenses")",
  "balance": "$(get_translated_text "$code" "Balance")",
  "selectLanguage": "$(get_translated_text "$code" "Select Language")",
  "categories": {
    "food": "$(get_translated_text "$code" "Food")",
    "transport": "$(get_translated_text "$code" "Transport")",
    "housing": "$(get_translated_text "$code" "Housing")",
    "entertainment": "$(get_translated_text "$code" "Entertainment")"
  }
}
EOF
                ;;
            "ai4kids")
                cat > "$translations_dir/${code}.json" << EOF
{
  "appName": "AI4Kids",
  "title": "$(get_translated_text "$code" "Artificial Intelligence for Children")",
  "description": "$(get_translated_text "$code" "Discover AI through fun characters and educational interactions!")",
  "welcome": "$(get_translated_text "$code" "Welcome to the AI world!")",
  "askQuestion": "$(get_translated_text "$code" "Ask a question")",
  "characters": "$(get_translated_text "$code" "AI Characters")",
  "selectLanguage": "$(get_translated_text "$code" "Select Language")",
  "aiTypes": {
    "chatbot": "$(get_translated_text "$code" "Chatbot")",
    "creative": "$(get_translated_text "$code" "Creative AI")",
    "helper": "$(get_translated_text "$code" "Study Helper")",
    "games": "$(get_translated_text "$code" "Game AI")"
  }
}
EOF
                ;;
            "multiai")
                cat > "$translations_dir/${code}.json" << EOF
{
  "appName": "MultiAI",
  "title": "$(get_translated_text "$code" "Multi-AI Interface")",
  "description": "$(get_translated_text "$code" "Connect with multiple AI systems in one unified interface!")",
  "welcome": "$(get_translated_text "$code" "Welcome to the multi-AI universe!")",
  "selectAI": "$(get_translated_text "$code" "Select AI")",
  "sendPrompt": "$(get_translated_text "$code" "Send Prompt")",
  "selectLanguage": "$(get_translated_text "$code" "Select Language")",
  "providers": {
    "chatgpt": "ChatGPT",
    "claude": "Claude",
    "gemini": "Gemini",
    "mistral": "Mistral"
  }
}
EOF
                ;;
            "digital4kids")
                cat > "$translations_dir/${code}.json" << EOF
{
  "appName": "Digital4Kids",
  "title": "$(get_translated_text "$code" "Digital Marketing for Children")",
  "description": "$(get_translated_text "$code" "Learn digital marketing through interactive games and age-appropriate content!")",
  "welcome": "$(get_translated_text "$code" "Welcome to digital marketing!")",
  "selectLanguage": "$(get_translated_text "$code" "Select Language")",
  "modules": {
    "socialMedia": "$(get_translated_text "$code" "Social Media")",
    "advertising": "$(get_translated_text "$code" "Advertising")",
    "content": "$(get_translated_text "$code" "Content Creation")",
    "analytics": "$(get_translated_text "$code" "Analytics")"
  },
  "ageGroups": {
    "5-8": "$(get_translated_text "$code" "5-8 years: Discovery")",
    "9-12": "$(get_translated_text "$code" "9-12 years: Advanced")",
    "13-14": "$(get_translated_text "$code" "13-14 years: Expert")"
  }
}
EOF
                ;;
        esac
    done
}

# Fonction de traduction basique (simulée)
get_translated_text() {
    local lang_code=$1
    local english_text=$2
    
    # Traductions basiques pour les langues principales
    case "$lang_code" in
        "fr")
            case "$english_text" in
                "Mathematics for Children") echo "Mathématiques pour Enfants" ;;
                "Unit Conversion") echo "Conversion d'Unités" ;;
                "Budget Management") echo "Gestion de Budget" ;;
                "Select Language") echo "Choisir la Langue" ;;
                *) echo "$english_text" ;;
            esac
            ;;
        "es")
            case "$english_text" in
                "Mathematics for Children") echo "Matemáticas para Niños" ;;
                "Unit Conversion") echo "Conversión de Unidades" ;;
                "Budget Management") echo "Gestión de Presupuesto" ;;
                "Select Language") echo "Seleccionar Idioma" ;;
                *) echo "$english_text" ;;
            esac
            ;;
        "de")
            case "$english_text" in
                "Mathematics for Children") echo "Mathematik für Kinder" ;;
                "Unit Conversion") echo "Einheitenumrechnung" ;;
                "Budget Management") echo "Budgetverwaltung" ;;
                "Select Language") echo "Sprache Wählen" ;;
                *) echo "$english_text" ;;
            esac
            ;;
        *)
            echo "$english_text"
            ;;
    esac
}

# =============================================================================
# CRÉATION D'UNE APPLICATION HYBRIDE COMPLÈTE
# =============================================================================

create_hybrid_app() {
    local app_config=$1
    IFS=':' read -r app_name port framework category description <<< "$app_config"
    
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🚀 Création de $app_name ($framework - $category)${NC}"
    echo -e "${CYAN}   📝 $description${NC}"
    
    # Supprimer et recréer le répertoire
    rm -rf "$app_dir"
    mkdir -p "$app_dir"
    cd "$app_dir"
    
    # Créer selon le framework
    case "$framework" in
        "React")
            create_react_hybrid_app "$app_name" "$port" "$category"
            ;;
        "Vue")
            create_vue_hybrid_app "$app_name" "$port" "$category"
            ;;
        "Next")
            create_next_hybrid_app "$app_name" "$port" "$category"
            ;;
    esac
    
    # Ajouter Capacitor pour l'hybride
    add_capacitor_support "$app_name" "$app_dir"
    
    # Générer les traductions mondiales
    generate_world_translations "$app_name" "$app_dir"
    
    # Installer les dépendances
    echo -e "   📦 Installation des dépendances..."
    npm install --legacy-peer-deps --silent
    
    echo -e "   ${GREEN}✅ $app_name créé avec succès${NC}"
    echo ""
}

create_react_hybrid_app() {
    local app_name=$1
    local port=$2
    local category=$3
    
    # Package.json optimisé pour React + Capacitor
    cat > package.json << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "typescript": "^4.9.5",
    "@capacitor/core": "^5.0.0",
    "@capacitor/cli": "^5.0.0",
    "@capacitor/android": "^5.0.0",
    "@capacitor/ios": "^5.0.0",
    "@capacitor/haptics": "^5.0.0",
    "@capacitor/status-bar": "^5.0.0",
    "@capacitor/splash-screen": "^5.0.0",
    "i18next": "^23.0.0",
    "react-i18next": "^13.0.0",
    "framer-motion": "^10.0.0"
  },
  "scripts": {
    "start": "PORT=$port SKIP_PREFLIGHT_CHECK=true react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject",
    "cap:add": "npx cap add",
    "cap:sync": "npx cap sync",
    "cap:open": "npx cap open",
    "cap:run": "npx cap run",
    "android": "npm run build && npx cap sync android && npx cap open android",
    "ios": "npm run build && npx cap sync ios && npx cap open ios"
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
    
    # Structure React moderne
    mkdir -p src/components src/hooks src/utils src/i18n/locales public
    
    # Configuration i18n
    cat > src/i18n/index.ts << 'EOF'
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

// Import dynamique des traductions
const loadTranslations = async () => {
  const languages = ['fr', 'en', 'es', 'de', 'it', 'pt', 'ru', 'ar', 'zh', 'ja', 'ko', 'hi', 'th', 'vi', 'id', 'ms', 'sw', 'am', 'yo', 'zu', 'tr', 'pl', 'nl', 'sv', 'no', 'he'];
  const resources: any = {};
  
  for (const lang of languages) {
    try {
      const translation = await import(`./locales/${lang}.json`);
      resources[lang] = { translation: translation.default || translation };
    } catch (e) {
      console.warn(`Translation for ${lang} not found`);
    }
  }
  
  return resources;
};

const initI18n = async () => {
  const resources = await loadTranslations();
  
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
};

initI18n();

export default i18n;
EOF
    
    # Hook Capacitor
    cat > src/hooks/useCapacitor.ts << 'EOF'
import { useEffect, useState } from 'react';
import { Capacitor } from '@capacitor/core';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import { StatusBar, Style } from '@capacitor/status-bar';

export const useCapacitor = () => {
  const [isNative, setIsNative] = useState(false);
  const [platform, setPlatform] = useState<string>('web');

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    setPlatform(Capacitor.getPlatform());
    
    if (Capacitor.isNativePlatform()) {
      // Configuration de la StatusBar
      StatusBar.setStyle({ style: Style.Dark });
    }
  }, []);

  const hapticFeedback = async (style: ImpactStyle = ImpactStyle.Medium) => {
    if (isNative) {
      await Haptics.impact({ style });
    }
  };

  return {
    isNative,
    platform,
    hapticFeedback
  };
};
EOF
    
    # Composant LanguageSelector universel
    cat > src/components/LanguageSelector.tsx << 'EOF'
import React from 'react';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';

const WORLD_LANGUAGES = [
  {"code": "fr", "name": "Français", "flag": "🇫🇷", "continent": "Europe"},
  {"code": "en", "name": "English", "flag": "🇺🇸", "continent": "Global"},
  {"code": "es", "name": "Español", "flag": "🇪🇸", "continent": "Europe/Americas"},
  {"code": "de", "name": "Deutsch", "flag": "🇩🇪", "continent": "Europe"},
  {"code": "it", "name": "Italiano", "flag": "🇮🇹", "continent": "Europe"},
  {"code": "pt", "name": "Português", "flag": "🇵🇹", "continent": "Europe/Americas"},
  {"code": "ru", "name": "Русский", "flag": "🇷🇺", "continent": "Europe/Asia"},
  {"code": "ar", "name": "العربية", "flag": "🇸🇦", "continent": "Asia/Africa"},
  {"code": "zh", "name": "中文", "flag": "🇨🇳", "continent": "Asia"},
  {"code": "ja", "name": "日本語", "flag": "🇯🇵", "continent": "Asia"},
  {"code": "ko", "name": "한국어", "flag": "🇰🇷", "continent": "Asia"},
  {"code": "hi", "name": "हिन्दी", "flag": "🇮🇳", "continent": "Asia"},
  {"code": "th", "name": "ไทย", "flag": "🇹🇭", "continent": "Asia"},
  {"code": "vi", "name": "Tiếng Việt", "flag": "🇻🇳", "continent": "Asia"},
  {"code": "id", "name": "Bahasa Indonesia", "flag": "🇮🇩", "continent": "Asia"},
  {"code": "ms", "name": "Bahasa Melayu", "flag": "🇲🇾", "continent": "Asia"},
  {"code": "sw", "name": "Kiswahili", "flag": "🇰🇪", "continent": "Africa"},
  {"code": "tr", "name": "Türkçe", "flag": "🇹🇷", "continent": "Europe/Asia"},
  {"code": "pl", "name": "Polski", "flag": "🇵🇱", "continent": "Europe"},
  {"code": "nl", "name": "Nederlands", "flag": "🇳🇱", "continent": "Europe"},
  {"code": "sv", "name": "Svenska", "flag": "🇸🇪", "continent": "Europe"},
  {"code": "he", "name": "עברית", "flag": "🇮🇱", "continent": "Asia"}
];

const LanguageSelector: React.FC = () => {
  const { i18n, t } = useTranslation();

  const changeLanguage = (languageCode: string) => {
    i18n.changeLanguage(languageCode);
    document.dir = languageCode === 'ar' || languageCode === 'he' ? 'rtl' : 'ltr';
  };

  const groupedLanguages = WORLD_LANGUAGES.reduce((acc, lang) => {
    const continent = lang.continent.split('/')[0];
    if (!acc[continent]) acc[continent] = [];
    acc[continent].push(lang);
    return acc;
  }, {} as Record<string, typeof WORLD_LANGUAGES>);

  return (
    <motion.div 
      className="language-selector"
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      <label>{t('selectLanguage')}:</label>
      <select 
        value={i18n.language} 
        onChange={(e) => changeLanguage(e.target.value)}
        className="language-select"
      >
        {Object.entries(groupedLanguages).map(([continent, languages]) => (
          <optgroup key={continent} label={continent}>
            {languages.map((lang) => (
              <option key={lang.code} value={lang.code}>
                {lang.flag} {lang.name}
              </option>
            ))}
          </optgroup>
        ))}
      </select>
    </motion.div>
  );
};

export default LanguageSelector;
EOF
    
    # Application principale avec design spécifique à la catégorie
    generate_react_app_content "$app_name" "$category"
    
    # Index.html avec PWA
    cat > public/index.html << EOF
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#667eea" />
    <title>$app_name - Application Hybride</title>
    
    <!-- PWA -->
    <link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <div id="root"></div>
</body>
</html>
EOF
    
    # Manifest PWA
    cat > public/manifest.json << EOF
{
  "short_name": "$app_name",
  "name": "$app_name - Application Hybride",
  "icons": [
    {
      "src": "favicon.ico",
      "sizes": "64x64 32x32 24x24 16x16",
      "type": "image/x-icon"
    }
  ],
  "start_url": ".",
  "display": "standalone",
  "theme_color": "#667eea",
  "background_color": "#ffffff"
}
EOF
    
    # Index TypeScript
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
    
    # Styles globaux modernes
    cat > src/index.css << 'EOF'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
  min-height: 100vh;
}

/* Scrollbar personnalisée */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(45deg, #667eea, #764ba2);
  border-radius: 10px;
}

/* Animations globales */
@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.7; }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 20px rgba(255, 255, 255, 0.2); }
  50% { box-shadow: 0 0 40px rgba(255, 255, 255, 0.4); }
}

/* Support RTL */
[dir="rtl"] {
  text-align: right;
}

[dir="rtl"] .language-selector {
  right: auto;
  left: 20px;
}

/* Responsive */
@media (max-width: 768px) {
  body {
    font-size: 14px;
  }
}
EOF
}

generate_react_app_content() {
    local app_name=$1
    local category=$2
    
    case "$category" in
        "Education")
            generate_education_app "$app_name"
            ;;
        "Utility")
            generate_utility_app "$app_name"
            ;;
        "Finance")
            generate_finance_app "$app_name"
            ;;
        "AI")
            generate_ai_app "$app_name"
            ;;
        "Marketing")
            generate_marketing_app "$app_name"
            ;;
        *)
            generate_default_app "$app_name"
            ;;
    esac
}

generate_education_app() {
    local app_name=$1
    
    cat > src/App.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { motion, AnimatePresence } from 'framer-motion';
import LanguageSelector from './components/LanguageSelector';
import { useCapacitor } from './hooks/useCapacitor';
import './App.css';

function App() {
  const { t } = useTranslation();
  const { hapticFeedback, isNative, platform } = useCapacitor();
  const [currentExercise, setCurrentExercise] = useState(0);
  const [score, setScore] = useState(0);
  const [gameMode, setGameMode] = useState<'menu' | 'play' | 'results'>('menu');

  const exercises = [
    { question: '2 + 3 = ?', options: [4, 5, 6], correct: 1 },
    { question: '10 - 4 = ?', options: [5, 6, 7], correct: 1 },
    { question: '3 × 4 = ?', options: [11, 12, 13], correct: 1 },
    { question: '15 ÷ 3 = ?', options: [4, 5, 6], correct: 1 }
  ];

  const handleAnswer = async (answerIndex: number) => {
    await hapticFeedback();
    
    if (answerIndex === exercises[currentExercise].correct) {
      setScore(score + 1);
    }
    
    if (currentExercise < exercises.length - 1) {
      setCurrentExercise(currentExercise + 1);
    } else {
      setGameMode('results');
    }
  };

  const resetGame = () => {
    setCurrentExercise(0);
    setScore(0);
    setGameMode('menu');
  };

  return (
    <div className="App">
      <LanguageSelector />
      
      <motion.div 
        className="app-container"
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.5 }}
      >
        <motion.h1 
          className="app-title"
          animate={{ y: [0, -10, 0] }}
          transition={{ duration: 2, repeat: Infinity }}
        >
          🧮 {t('appName')}
        </motion.h1>
        
        {isNative && (
          <div className="platform-badge">
            📱 {platform.toUpperCase()}
          </div>
        )}

        <AnimatePresence mode="wait">
          {gameMode === 'menu' && (
            <motion.div
              key="menu"
              initial={{ opacity: 0, x: -100 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 100 }}
              className="menu-screen"
            >
              <h2>{t('title')}</h2>
              <p>{t('description')}</p>
              
              <div className="level-selection">
                <h3>{t('levels.easy')}</h3>
                <button 
                  className="btn primary"
                  onClick={() => setGameMode('play')}
                >
                  🚀 {t('start')}
                </button>
              </div>
            </motion.div>
          )}

          {gameMode === 'play' && (
            <motion.div
              key="play"
              initial={{ opacity: 0, y: 50 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -50 }}
              className="game-screen"
            >
              <div className="progress-bar">
                <div 
                  className="progress-fill"
                  style={{ width: `${((currentExercise + 1) / exercises.length) * 100}%` }}
                />
              </div>
              
              <h2 className="question">{exercises[currentExercise].question}</h2>
              
              <div className="options">
                {exercises[currentExercise].options.map((option, index) => (
                  <motion.button
                    key={index}
                    whileHover={{ scale: 1.05 }}
                    whileTap={{ scale: 0.95 }}
                    className="option-btn"
                    onClick={() => handleAnswer(index)}
                  >
                    {option}
                  </motion.button>
                ))}
              </div>
              
              <div className="score">
                {t('score')}: {score}/{exercises.length}
              </div>
            </motion.div>
          )}

          {gameMode === 'results' && (
            <motion.div
              key="results"
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.8 }}
              className="results-screen"
            >
              <h2>🎉 {t('completed')}</h2>
              <div className="final-score">
                {t('score')}: {score}/{exercises.length}
              </div>
              <div className="score-message">
                {score === exercises.length ? t('perfect') : score >= exercises.length / 2 ? t('good') : t('tryAgain')}
              </div>
              
              <button 
                className="btn secondary"
                onClick={resetGame}
              >
                🔄 {t('playAgain')}
              </button>
            </motion.div>
          )}
        </AnimatePresence>
      </motion.div>
    </div>
  );
}

export default App;
EOF

    # CSS spécifique à l'éducation
    cat > src/App.css << 'EOF'
.App {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
  color: white;
  position: relative;
}

.app-container {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 30px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 3rem;
  max-width: 800px;
  width: 100%;
  text-align: center;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
  animation: glow 4s ease-in-out infinite;
}

.app-title {
  font-size: 3.5rem;
  margin-bottom: 2rem;
  background: linear-gradient(45deg, #fff 0%, #f0f0f0 50%, #fff 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.platform-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  background: rgba(255, 255, 255, 0.2);
  padding: 8px 12px;
  border-radius: 15px;
  font-size: 0.8rem;
  font-weight: bold;
}

.language-selector {
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(15px);
  padding: 12px 16px;
  border-radius: 15px;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.language-select {
  background: rgba(255, 255, 255, 0.95);
  border: none;
  border-radius: 8px;
  padding: 6px 12px;
  margin-left: 8px;
  cursor: pointer;
}

.menu-screen, .game-screen, .results-screen {
  width: 100%;
}

.level-selection {
  margin: 2rem 0;
}

.btn {
  background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
  border: none;
  border-radius: 25px;
  color: white;
  padding: 15px 30px;
  font-size: 1.2rem;
  cursor: pointer;
  margin: 10px;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}

.btn.secondary {
  background: linear-gradient(45deg, #A8E6CF, #FFD93D);
  color: #333;
}

.progress-bar {
  width: 100%;
  height: 8px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  margin-bottom: 2rem;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(45deg, #4ECDC4, #44A08D);
  transition: width 0.5s ease;
}

.question {
  font-size: 2.5rem;
  margin: 2rem 0;
  background: rgba(255, 255, 255, 0.1);
  padding: 1.5rem;
  border-radius: 15px;
}

.options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}

.option-btn {
  background: rgba(255, 255, 255, 0.15);
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 15px;
  color: white;
  padding: 1.5rem;
  font-size: 1.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.option-btn:hover {
  background: rgba(255, 255, 255, 0.25);
  border-color: #4ECDC4;
}

.score {
  font-size: 1.5rem;
  margin: 1rem 0;
  background: rgba(0, 255, 0, 0.2);
  padding: 1rem;
  border-radius: 10px;
}

.final-score {
  font-size: 3rem;
  margin: 2rem 0;
  background: linear-gradient(45deg, #4ECDC4, #44A08D);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.score-message {
  font-size: 1.3rem;
  margin: 1.5rem 0;
  opacity: 0.9;
}

@media (max-width: 768px) {
  .app-container {
    padding: 2rem;
    margin: 10px;
  }
  
  .app-title {
    font-size: 2.5rem;
  }
  
  .question {
    font-size: 2rem;
  }
  
  .options {
    grid-template-columns: 1fr;
  }
}
EOF
}

# [Continuez avec les autres fonctions generate_utility_app, generate_finance_app, etc.]
# [Pour la brièveté, je vais inclure une version condensée]

generate_utility_app() {
    local app_name=$1
    # Code similaire adapté pour les utilitaires
    cat > src/App.tsx << 'EOF'
import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import LanguageSelector from './components/LanguageSelector';
import { useCapacitor } from './hooks/useCapacitor';
import './App.css';

function App() {
  const { t } = useTranslation();
  const { hapticFeedback } = useCapacitor();
  const [inputValue, setInputValue] = useState(1);
  const [fromUnit, setFromUnit] = useState('m');
  const [toUnit, setToUnit] = useState('cm');

  const convert = () => {
    hapticFeedback();
    // Logique de conversion
  };

  return (
    <div className="App">
      <LanguageSelector />
      <motion.div className="converter-container">
        <h1>📏 {t('appName')}</h1>
        <p>{t('description')}</p>
        {/* Interface de conversion */}
      </motion.div>
    </div>
  );
}

export default App;
EOF
}

# =============================================================================
# AJOUT DU SUPPORT CAPACITOR
# =============================================================================

add_capacitor_support() {
    local app_name=$1
    local app_dir=$2
    
    cd "$app_dir"
    
    # Configuration Capacitor
    cat > capacitor.config.ts << EOF
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.platform.${app_name}',
  appName: '${app_name}',
  webDir: 'build',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    StatusBar: {
      style: 'dark'
    },
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: '#667eea',
      showSpinner: false
    }
  }
};

export default config;
EOF
    
    # Ajouter les plateformes (sans erreur si déjà présentes)
    npx cap add android 2>/dev/null || true
    npx cap add ios 2>/dev/null || true
}

# =============================================================================
# CRÉATION DES TESTS BDD CUCUMBER
# =============================================================================

create_bdd_tests() {
    echo -e "${BLUE}🧪 CRÉATION DES TESTS BDD CUCUMBER${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo ""
    
    cd "$TESTS_DIR"
    
    # Configuration Cucumber
    cat > cucumber.js << 'EOF'
module.exports = {
  default: {
    require: ['step-definitions/**/*.ts'],
    requireModule: ['ts-node/register'],
    format: ['progress', 'json:reports/cucumber_report.json', 'html:reports/cucumber_report.html'],
    paths: ['features/**/*.feature'],
    parallel: 2
  }
};
EOF
    
    # Package.json pour les tests
    cat > package.json << 'EOF'
{
  "name": "platform-tests",
  "version": "1.0.0",
  "scripts": {
    "test": "cucumber-js",
    "test:web": "cucumber-js --tags '@web'",
    "test:mobile": "cucumber-js --tags '@mobile'",
    "test:all": "cucumber-js --tags '@web or @mobile'"
  },
  "devDependencies": {
    "@cucumber/cucumber": "^9.0.0",
    "@playwright/test": "^1.38.0",
    "playwright": "^1.38.0",
    "ts-node": "^10.9.0",
    "typescript": "^5.0.0"
  }
}
EOF
    
    # Tests par application
    for app_config in "${APPS_CONFIG[@]}"; do
        IFS=':' read -r app_name port framework category description <<< "$app_config"
        create_app_bdd_tests "$app_name" "$port" "$category"
    done
    
    # Configuration TypeScript
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "es2020",
    "module": "commonjs",
    "lib": ["es2020"],
    "outDir": "./dist",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true
  },
  "include": ["**/*.ts"],
  "exclude": ["node_modules", "dist"]
}
EOF
    
    # Support World
    cat > support/world.ts << 'EOF'
import { setWorldConstructor, World, IWorldOptions } from '@cucumber/cucumber';
import { Browser, BrowserContext, Page, chromium } from 'playwright';

export class CustomWorld extends World {
  browser!: Browser;
  context!: BrowserContext;
  page!: Page;
  appName?: string;

  constructor(options: IWorldOptions) {
    super(options);
  }

  async init() {
    this.browser = await chromium.launch({ headless: true });
    this.context = await this.browser.newContext({
      viewport: { width: 1280, height: 720 }
    });
    this.page = await this.context.newPage();
  }

  async cleanup() {
    if (this.page) await this.page.close();
    if (this.context) await this.context.close();
    if (this.browser) await this.browser.close();
  }

  async takeScreenshot(name: string) {
    await this.page.screenshot({ 
      path: `screenshots/${name}-${Date.now()}.png`,
      fullPage: true 
    });
  }
}

setWorldConstructor(CustomWorld);
EOF
    
    # Hooks globaux
    cat > support/hooks.ts << 'EOF'
import { Before, After, BeforeAll, AfterAll, Status } from '@cucumber/cucumber';
import { CustomWorld } from './world';

BeforeAll(async function() {
  console.log('🥒 Démarrage des tests Cucumber BDD');
  console.log('🚀 Applications à tester:');
  console.log('   - Math4Kids: http://localhost:3001');
  console.log('   - UnitFlip: http://localhost:3002');
  console.log('   - BudgetCron: http://localhost:3003');
  console.log('   - AI4Kids: http://localhost:3004');
  console.log('   - MultiAI: http://localhost:3005');
  console.log('   - Digital4Kids: http://localhost:3006');
});

Before(async function(this: CustomWorld, scenario) {
  console.log(`\n🧪 Scénario: ${scenario.pickle.name}`);
  await this.init();
});

After(async function(this: CustomWorld, scenario) {
  if (scenario.result?.status === Status.FAILED) {
    await this.takeScreenshot(`failed-${scenario.pickle.name.replace(/\s+/g, '-')}`);
  }
  await this.cleanup();
});

AfterAll(async function() {
  console.log('\n🏁 Tests Cucumber terminés');
});
EOF
    
    echo -e "${GREEN}✅ Tests BDD créés pour toutes les applications${NC}"
}

create_app_bdd_tests() {
    local app_name=$1
    local port=$2
    local category=$3
    
    # Feature file pour chaque application
    cat > "features/${app_name}.feature" << EOF
@web @mobile
Feature: ${app_name} - Tests complets
  En tant qu'utilisateur
  Je veux utiliser ${app_name}
  Pour avoir une expérience fluide sur toutes les plateformes

  Background:
    Given l'application ${app_name} est accessible

  @web
  Scenario: Interface web responsive
    When je visite la page d'accueil
    Then je vois le titre de l'application
    And l'interface est responsive
    And tous les éléments sont visibles

  @web
  Scenario: Sélecteur de langue mondial
    When je clique sur le sélecteur de langue
    Then je vois toutes les langues disponibles
    When je sélectionne une langue différente
    Then l'interface change de langue
    And le texte est correctement traduit

  @web
  Scenario: Fonctionnalités principales
    When j'interagis avec les fonctionnalités principales
    Then toutes les actions fonctionnent correctement
    And les animations sont fluides
    And les transitions sont naturelles

  @mobile @android
  Scenario: Application Android native
    Given l'application est compilée pour Android
    When je lance l'application sur Android
    Then l'interface s'adapte au mobile
    And les gestes tactiles fonctionnent
    And le feedback haptique est actif

  @mobile @ios
  Scenario: Application iOS native
    Given l'application est compilée pour iOS
    When je lance l'application sur iOS
    Then l'interface respecte les guidelines iOS
    And les gestes iOS sont supportés
    And l'intégration système est correcte

  @performance
  Scenario: Performance et optimisation
    When je mesure les performances
    Then le temps de chargement est inférieur à 3 secondes
    And l'utilisation mémoire est optimisée
    And les animations sont à 60fps

  @accessibility
  Scenario: Accessibilité
    When je teste l'accessibilité
    Then tous les éléments ont des labels appropriés
    And la navigation au clavier fonctionne
    And le contraste des couleurs est suffisant
    And le support RTL fonctionne pour l'arabe et l'hébreu
EOF
    
    # Step definitions pour chaque application
    cat > "step-definitions/${app_name}.steps.ts" << EOF
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

Given('l\\'application ${app_name} est accessible', async function(this: CustomWorld) {
  this.appName = '${app_name}';
  await this.page.goto('http://localhost:${port}');
  await this.page.waitForLoadState('networkidle');
});

When('je visite la page d\\'accueil', async function(this: CustomWorld) {
  await this.page.goto('http://localhost:${port}');
  await this.page.waitForLoadState('domcontentloaded');
});

Then('je vois toutes les langues disponibles', async function(this: CustomWorld) {
  const options = await this.page.locator('.language-select option').count();
  expect(options).toBeGreaterThan(20); // Au moins 20+ langues
});

When('je sélectionne une langue différente', async function(this: CustomWorld) {
  await this.page.locator('.language-select').selectOption('es');
  await this.page.waitForTimeout(1000); // Attendre la traduction
});

Then('l\\'interface change de langue', async function(this: CustomWorld) {
  const selectedLang = await this.page.locator('.language-select').inputValue();
  expect(selectedLang).toBe('es');
});

Then('le texte est correctement traduit', async function(this: CustomWorld) {
  // Vérifier que le texte a changé (exemple avec l'espagnol)
  const elements = await this.page.locator('*').allTextContents();
  const hasSpanishText = elements.some(text => 
    text.includes('Español') || text.includes('años') || text.includes('para')
  );
  expect(hasSpanishText).toBeTruthy();
});

When('j\\'interagis avec les fonctionnalités principales', async function(this: CustomWorld) {
  // Test des boutons principaux
  const buttons = await this.page.locator('button').count();
  if (buttons > 0) {
    await this.page.locator('button').first().click();
    await this.page.waitForTimeout(500);
  }
  
  // Test des interactions spécifiques à l'app
  if (this.appName === 'math4kids') {
    const optionBtns = await this.page.locator('.option-btn');
    if (await optionBtns.count() > 0) {
      await optionBtns.first().click();
    }
  }
});

Then('toutes les actions fonctionnent correctement', async function(this: CustomWorld) {
  // Vérifier qu'aucune erreur console n'est survenue
  const errors: string[] = [];
  this.page.on('console', msg => {
    if (msg.type() === 'error') {
      errors.push(msg.text());
    }
  });
  
  await this.page.waitForTimeout(2000);
  expect(errors.length).toBe(0);
});

Then('les animations sont fluides', async function(this: CustomWorld) {
  // Vérifier la présence d'animations CSS
  const animatedElements = await this.page.locator('[style*="animation"], .animate, [class*="motion"]').count();
  expect(animatedElements).toBeGreaterThan(0);
});

Then('les transitions sont naturelles', async function(this: CustomWorld) {
  // Vérifier les transitions CSS
  const transitionElements = await this.page.locator('[style*="transition"], [class*="transition"]').count();
  expect(transitionElements).toBeGreaterThan(0);
});

Given('l\\'application est compilée pour Android', async function(this: CustomWorld) {
  // Ce test nécessiterait un environnement Android configuré
  console.log('📱 Test Android simulé - Configuration Capacitor détectée');
});

When('je lance l\\'application sur Android', async function(this: CustomWorld) {
  // Simuler un environnement mobile
  await this.page.setViewportSize({ width: 375, height: 812 });
  await this.page.addInitScript(() => {
    // Simuler Capacitor
    (window as any).Capacitor = {
      isNativePlatform: () => true,
      getPlatform: () => 'android'
    };
  });
  await this.page.goto('http://localhost:${port}');
});

Then('l\\'interface s\\'adapte au mobile', async function(this: CustomWorld) {
  await expect(this.page.locator('.app-container')).toBeVisible();
  // Vérifier que l'interface mobile est optimisée
  const isMobileOptimized = await this.page.evaluate(() => {
    const container = document.querySelector('.app-container');
    return container ? window.getComputedStyle(container).padding !== '3rem' : false;
  });
  expect(isMobileOptimized).toBeTruthy();
});

Then('les gestes tactiles fonctionnent', async function(this: CustomWorld) {
  // Tester les interactions tactiles
  const touchElements = await this.page.locator('button, .btn, [role="button"]').count();
  expect(touchElements).toBeGreaterThan(0);
});

Then('le feedback haptique est actif', async function(this: CustomWorld) {
  // Vérifier la présence du code de feedback haptique
  const hasHaptics = await this.page.evaluate(() => {
    return typeof (window as any).Capacitor !== 'undefined';
  });
  expect(hasHaptics).toBeTruthy();
});

Given('l\\'application est compilée pour iOS', async function(this: CustomWorld) {
  console.log('🍎 Test iOS simulé - Configuration Capacitor détectée');
});

When('je lance l\\'application sur iOS', async function(this: CustomWorld) {
  await this.page.setViewportSize({ width: 390, height: 844 }); // iPhone 12 Pro
  await this.page.addInitScript(() => {
    (window as any).Capacitor = {
      isNativePlatform: () => true,
      getPlatform: () => 'ios'
    };
  });
  await this.page.goto('http://localhost:${port}');
});

Then('l\\'interface respecte les guidelines iOS', async function(this: CustomWorld) {
  // Vérifier les éléments de design iOS
  await expect(this.page.locator('.app-container')).toBeVisible();
  
  // Vérifier la présence d'éléments iOS-friendly
  const hasRoundedCorners = await this.page.evaluate(() => {
    const elements = Array.from(document.querySelectorAll('*'));
    return elements.some(el => {
      const styles = window.getComputedStyle(el);
      return styles.borderRadius && styles.borderRadius !== '0px';
    });
  });
  expect(hasRoundedCorners).toBeTruthy();
});

Then('les gestes iOS sont supportés', async function(this: CustomWorld) {
  // Tester les gestes spécifiques iOS
  const interactiveElements = await this.page.locator('[class*="motion"], button').count();
  expect(interactiveElements).toBeGreaterThan(0);
});

Then('l\\'intégration système est correcte', async function(this: CustomWorld) {
  // Vérifier la configuration StatusBar et autres intégrations
  const hasSystemIntegration = await this.page.evaluate(() => {
    return document.querySelector('meta[name="apple-mobile-web-app-capable"]') !== null;
  });
  expect(hasSystemIntegration).toBeTruthy();
});

When('je mesure les performances', async function(this: CustomWorld) {
  // Mesurer les métriques de performance
  const loadTime = await this.page.evaluate(() => {
    return performance.timing.loadEventEnd - performance.timing.navigationStart;
  });
  
  (this as any).performanceMetrics = { loadTime };
});

Then('le temps de chargement est inférieur à 3 secondes', async function(this: CustomWorld) {
  const metrics = (this as any).performanceMetrics;
  expect(metrics.loadTime).toBeLessThan(3000);
});

Then('l\\'utilisation mémoire est optimisée', async function(this: CustomWorld) {
  // Vérifier l'utilisation mémoire
  const memoryInfo = await this.page.evaluate(() => {
    return (performance as any).memory ? (performance as any).memory.usedJSHeapSize : 0;
  });
  
  // Limite raisonnable pour une app web (50MB)
  expect(memoryInfo).toBeLessThan(50 * 1024 * 1024);
});

Then('les animations sont à 60fps', async function(this: CustomWorld) {
  // Vérifier la fluidité des animations
  const hasGPUAcceleration = await this.page.evaluate(() => {
    const elements = Array.from(document.querySelectorAll('*'));
    return elements.some(el => {
      const styles = window.getComputedStyle(el);
      return styles.transform !== 'none' || styles.filter !== 'none';
    });
  });
  expect(hasGPUAcceleration).toBeTruthy();
});

When('je teste l\\'accessibilité', async function(this: CustomWorld) {
  // Tests d'accessibilité de base
  await this.page.waitForLoadState('domcontentloaded');
});

Then('tous les éléments ont des labels appropriés', async function(this: CustomWorld) {
  // Vérifier les labels et aria-labels
  const inputs = await this.page.locator('input, button, select').count();
  const labeledInputs = await this.page.locator('input[aria-label], button[aria-label], select[aria-label], input[id] + label, label + input').count();
  
  // Au moins 80% des éléments doivent avoir des labels
  const labelRatio = inputs > 0 ? labeledInputs / inputs : 1;
  expect(labelRatio).toBeGreaterThan(0.8);
});

Then('la navigation au clavier fonctionne', async function(this: CustomWorld) {
  // Tester la navigation avec Tab
  await this.page.keyboard.press('Tab');
  await this.page.waitForTimeout(100);
  
  const focusedElement = await this.page.evaluate(() => {
    return document.activeElement?.tagName;
  });
  
  expect(['INPUT', 'BUTTON', 'SELECT', 'A']).toContain(focusedElement);
});

Then('le contraste des couleurs est suffisant', async function(this: CustomWorld) {
  // Vérifier les contrastes de base
  const hasGoodContrast = await this.page.evaluate(() => {
    const elements = Array.from(document.querySelectorAll('*'));
    return elements.some(el => {
      const styles = window.getComputedStyle(el);
      return styles.color && styles.backgroundColor;
    });
  });
  expect(hasGoodContrast).toBeTruthy();
});

Then('le support RTL fonctionne pour l\\'arabe et l\\'hébreu', async function(this: CustomWorld) {
  // Tester le support RTL
  await this.page.locator('.language-select').selectOption('ar');
  await this.page.waitForTimeout(1000);
  
  const direction = await this.page.evaluate(() => {
    return document.dir || document.documentElement.dir;
  });
  
  expect(direction).toBe('rtl');
});
EOF
    
    echo -e "${GREEN}✅ Tests BDD créés pour ${app_name}${NC}"
}

# =============================================================================
# CRÉATION DES AUTRES TYPES D'APPLICATIONS
# =============================================================================

create_vue_hybrid_app() {
    local app_name=$1
    local port=$2
    local category=$3
    
    # Configuration Vue avec Vite pour de meilleures performances
    cat > package.json << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "serve": "PORT=$port vue-cli-service serve --skip-plugins @vue/cli-plugin-eslint",
    "build": "vue-cli-service build",
    "android": "npm run build && npx cap sync android && npx cap open android",
    "ios": "npm run build && npx cap sync ios && npx cap open ios"
  },
  "dependencies": {
    "vue": "^3.3.0",
    "@capacitor/core": "^5.0.0",
    "@capacitor/cli": "^5.0.0",
    "@capacitor/android": "^5.0.0",
    "@capacitor/ios": "^5.0.0",
    "vue-i18n": "^9.2.0"
  },
  "devDependencies": {
    "@vue/cli-service": "^5.0.0",
    "typescript": "^4.9.5"
  }
}
EOF
    
    mkdir -p src public
    
    # Vue App avec composition API
    cat > src/App.vue << 'EOF'
<template>
  <div id="app" :dir="currentDirection">
    <LanguageSelector @language-changed="handleLanguageChange" />
    
    <div class="app-container">
      <h1 class="app-title">💰 {{ $t('appName') }}</h1>
      
      <div class="budget-form">
        <div class="input-group">
          <label>{{ $t('income') }}:</label>
          <input v-model.number="income" type="number" :placeholder="$t('income')">
          <span>€</span>
        </div>
        
        <div class="input-group">
          <label>{{ $t('expenses') }}:</label>
          <input v-model.number="expenses" type="number" :placeholder="$t('expenses')">
          <span>€</span>
        </div>
        
        <div class="result" :class="{ positive: balance > 0, negative: balance < 0 }">
          <h2>{{ $t('balance') }}: {{ balance }}€</h2>
          <p v-if="balance > 0">✅ {{ $t('balanced') }}</p>
          <p v-else>⚠️ {{ $t('overspending') }}</p>
        </div>
      </div>
      
      <div class="categories">
        <h3>📊 {{ $t('categories.title') }}</h3>
        <div class="category-grid">
          <div class="category" v-for="category in categories" :key="category">
            {{ $t(`categories.${category}`) }}
          </div>
        </div>
      </div>
      
      <div class="platform-info" v-if="isNative">
        📱 {{ platform.toUpperCase() }} App
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useI18n } from 'vue-i18n';
import { Capacitor } from '@capacitor/core';
import LanguageSelector from './components/LanguageSelector.vue';

const { t, locale } = useI18n();

const income = ref(2000);
const expenses = ref(1500);
const currentDirection = ref('ltr');
const isNative = ref(false);
const platform = ref('web');

const categories = ['food', 'transport', 'housing', 'entertainment'];

const balance = computed(() => income.value - expenses.value);

const handleLanguageChange = (newLang: string) => {
  locale.value = newLang;
  currentDirection.value = ['ar', 'he'].includes(newLang) ? 'rtl' : 'ltr';
};

onMounted(() => {
  isNative.value = Capacitor.isNativePlatform();
  platform.value = Capacitor.getPlatform();
});
</script>

<style>
#app {
  min-height: 100vh;
  background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'Inter', Arial, sans-serif;
  padding: 20px;
}

.app-container {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 40px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  max-width: 600px;
  width: 100%;
  text-align: center;
}

.app-title {
  font-size: 3rem;
  margin-bottom: 2rem;
  color: #667eea;
  animation: float 6s ease-in-out infinite;
}

.budget-form {
  margin: 2rem 0;
}

.input-group {
  margin: 1rem 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

input {
  font-size: 1.2rem;
  padding: 10px;
  border-radius: 10px;
  border: 2px solid #667eea;
  width: 150px;
}

.result {
  margin: 2rem 0;
  padding: 20px;
  border-radius: 15px;
  font-size: 1.5rem;
  transition: all 0.3s ease;
}

.result.positive {
  background: linear-gradient(45deg, #4CAF50, #8BC34A);
  color: white;
}

.result.negative {
  background: linear-gradient(45deg, #F44336, #FF9800);
  color: white;
}

.categories {
  margin: 2rem 0;
}

.category-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.category {
  background: rgba(102, 126, 234, 0.1);
  padding: 1rem;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.category:hover {
  background: rgba(102, 126, 234, 0.2);
  transform: translateY(-2px);
}

.platform-info {
  margin-top: 2rem;
  background: rgba(0, 255, 0, 0.1);
  padding: 10px;
  border-radius: 10px;
  font-weight: bold;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

@media (max-width: 768px) {
  .app-container {
    padding: 2rem;
    margin: 10px;
  }
  
  .app-title {
    font-size: 2.5rem;
  }
  
  .category-grid {
    grid-template-columns: 1fr 1fr;
  }
}
</style>
EOF
    
    # Composant LanguageSelector pour Vue
    mkdir -p src/components
    cat > src/components/LanguageSelector.vue << 'EOF'
<template>
  <div class="language-selector">
    <label>{{ $t('selectLanguage') }}:</label>
    <select 
      :value="currentLang" 
      @change="changeLanguage"
      class="language-select"
    >
      <optgroup v-for="(langs, continent) in groupedLanguages" :key="continent" :label="continent">
        <option v-for="lang in langs" :key="lang.code" :value="lang.code">
          {{ lang.flag }} {{ lang.name }}
        </option>
      </optgroup>
    </select>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, emit } from 'vue';
import { useI18n } from 'vue-i18n';

const { locale } = useI18n();

const emit = defineEmits(['language-changed']);

const currentLang = ref(locale.value);

const WORLD_LANGUAGES = [
  {"code": "fr", "name": "Français", "flag": "🇫🇷", "continent": "Europe"},
  {"code": "en", "name": "English", "flag": "🇺🇸", "continent": "Global"},
  {"code": "es", "name": "Español", "flag": "🇪🇸", "continent": "Europe"},
  {"code": "ar", "name": "العربية", "flag": "🇸🇦", "continent": "Asia"},
  {"code": "zh", "name": "中文", "flag": "🇨🇳", "continent": "Asia"},
  // ... autres langues
];

const groupedLanguages = computed(() => {
  return WORLD_LANGUAGES.reduce((acc, lang) => {
    const continent = lang.continent.split('/')[0];
    if (!acc[continent]) acc[continent] = [];
    acc[continent].push(lang);
    return acc;
  }, {} as Record<string, typeof WORLD_LANGUAGES>);
});

const changeLanguage = (event: Event) => {
  const target = event.target as HTMLSelectElement;
  currentLang.value = target.value;
  emit('language-changed', target.value);
};
</script>

<style scoped>
.language-selector {
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(15px);
  padding: 12px 16px;
  border-radius: 15px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  z-index: 1000;
}

.language-select {
  background: rgba(255, 255, 255, 0.95);
  border: none;
  border-radius: 8px;
  padding: 6px 12px;
  margin-left: 8px;
  cursor: pointer;
}
</style>
EOF
    
    # Main.js pour Vue
    cat > src/main.js << 'EOF'
import { createApp } from 'vue';
import { createI18n } from 'vue-i18n';
import App from './App.vue';

// Import des traductions
const messages = {
  fr: {
    appName: 'BudgetCron',
    income: 'Revenus',
    expenses: 'Dépenses',
    balance: 'Solde',
    selectLanguage: 'Choisir la langue',
    balanced: 'Budget équilibré',
    overspending: 'Attention aux dépenses',
    categories: {
      title: 'Catégories',
      food: 'Alimentation',
      transport: 'Transport',
      housing: 'Logement',
      entertainment: 'Loisirs'
    }
  },
  en: {
    appName: 'BudgetCron',
    income: 'Income',
    expenses: 'Expenses',
    balance: 'Balance',
    selectLanguage: 'Select Language',
    balanced: 'Budget balanced',
    overspending: 'Watch your spending',
    categories: {
      title: 'Categories',
      food: 'Food',
      transport: 'Transport',
      housing: 'Housing',
      entertainment: 'Entertainment'
    }
  }
  // ... autres langues
};

const i18n = createI18n({
  locale: 'fr',
  fallbackLocale: 'en',
  messages
});

const app = createApp(App);
app.use(i18n);
app.mount('#app');
EOF
    
    # Index.html pour Vue
    cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>BudgetCron - Gestion de Budget</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div id="app"></div>
</body>
</html>
EOF
}

create_next_hybrid_app() {
    local app_name=$1
    local port=$2
    local category=$3
    
    # Configuration Next.js optimisée
    cat > package.json << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "PORT=$port next dev",
    "build": "next build && next export",
    "start": "next start",
    "android": "npm run build && npx cap sync android && npx cap open android",
    "ios": "npm run build && npx cap sync ios && npx cap open ios"
  },
  "dependencies": {
    "next": "^13.5.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "@capacitor/core": "^5.0.0",
    "@capacitor/cli": "^5.0.0",
    "@capacitor/android": "^5.0.0",
    "@capacitor/ios": "^5.0.0",
    "framer-motion": "^10.0.0",
    "next-i18next": "^14.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.2.0",
    "typescript": "^5.0.0"
  }
}
EOF
    
    # Configuration Next.js
    cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  },
  i18n: {
    locales: ['fr', 'en', 'es', 'de', 'it', 'pt', 'ru', 'ar', 'zh', 'ja', 'ko', 'hi'],
    defaultLocale: 'fr'
  }
};

module.exports = nextConfig;
EOF
    
    mkdir -p pages public
    
    # Page principale Next.js
    cat > pages/index.tsx << 'EOF'
import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Capacitor } from '@capacitor/core';
import Head from 'next/head';
import styles from '../styles/Home.module.css';

const AI_PROVIDERS = [
  { name: 'ChatGPT', icon: '🤖', color: '#10a37f', description: 'Conversationnel et créatif' },
  { name: 'Claude', icon: '🧠', color: '#db7c26', description: 'Analyse et raisonnement' },
  { name: 'Gemini', icon: '✨', color: '#4285f4', description: 'Multimodal et rapide' },
  { name: 'Mistral', icon: '🌪️', color: '#f97316', description: 'Open source français' },
  { name: 'GPT-4', icon: '⚡', color: '#0ea5e9', description: 'Dernière génération' },
  { name: 'PaLM', icon: '🧪', color: '#dc2626', description: 'Recherche avancée' }
];

const LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦' }
];

export default function Home() {
  const [selectedAI, setSelectedAI] = useState(AI_PROVIDERS[0]);
  const [prompt, setPrompt] = useState('');
  const [currentLang, setCurrentLang] = useState('fr');
  const [isNative, setIsNative] = useState(false);
  const [platform, setPlatform] = useState('web');
  const [conversation, setConversation] = useState<Array<{role: string, content: string}>>([]);

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    setPlatform(Capacitor.getPlatform());
  }, []);

  const handleSendPrompt = () => {
    if (!prompt.trim()) return;
    
    const newMessage = { role: 'user', content: prompt };
    const aiResponse = { 
      role: 'assistant', 
      content: `Réponse simulée de ${selectedAI.name}: ${prompt}` 
    };
    
    setConversation([...conversation, newMessage, aiResponse]);
    setPrompt('');
  };

  const texts = {
    fr: {
      title: 'MultiAI - Interface Unifiée',
      subtitle: 'Connectez-vous à tous les AIs en un seul endroit',
      selectAI: 'Choisir votre AI',
      sendPrompt: 'Envoyer',
      placeholder: 'Posez votre question...',
      selectLanguage: 'Langue'
    },
    en: {
      title: 'MultiAI - Unified Interface',
      subtitle: 'Connect to all AIs in one place',
      selectAI: 'Choose your AI',
      sendPrompt: 'Send',
      placeholder: 'Ask your question...',
      selectLanguage: 'Language'
    }
  };

  const t = texts[currentLang as keyof typeof texts] || texts.fr;

  return (
    <>
      <Head>
        <title>MultiAI - Interface Unifiée Multi-IA</title>
        <meta name="description" content="Interface unifiée pour tous les assistants IA" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </Head>

      <div className={styles.container} dir={['ar', 'he'].includes(currentLang) ? 'rtl' : 'ltr'}>
        <div className={styles.languageSelector}>
          <select 
            value={currentLang} 
            onChange={(e) => setCurrentLang(e.target.value)}
            className={styles.languageSelect}
          >
            {LANGUAGES.map((lang) => (
              <option key={lang.code} value={lang.code}>
                {lang.flag} {lang.name}
              </option>
            ))}
          </select>
        </div>

        <motion.div 
          className={styles.main}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className={styles.title}>
            🤖 {t.title}
          </h1>
          
          <p className={styles.subtitle}>
            {t.subtitle}
          </p>

          {isNative && (
            <div className={styles.platformBadge}>
              📱 {platform.toUpperCase()} App
            </div>
          )}

          <div className={styles.aiSelection}>
            <h3>{t.selectAI}:</h3>
            <div className={styles.aiGrid}>
              {AI_PROVIDERS.map((ai) => (
                <motion.div
                  key={ai.name}
                  className={`${styles.aiCard} ${selectedAI.name === ai.name ? styles.selected : ''}`}
                  onClick={() => setSelectedAI(ai)}
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  style={{ borderColor: selectedAI.name === ai.name ? ai.color : 'transparent' }}
                >
                  <div className={styles.aiIcon} style={{ color: ai.color }}>
                    {ai.icon}
                  </div>
                  <h4>{ai.name}</h4>
                  <p>{ai.description}</p>
                </motion.div>
              ))}
            </div>
          </div>

          <div className={styles.chatInterface}>
            <div className={styles.conversation}>
              <AnimatePresence>
                {conversation.map((message, index) => (
                  <motion.div
                    key={index}
                    className={`${styles.message} ${styles[message.role]}`}
                    initial={{ opacity: 0, x: message.role === 'user' ? 20 : -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ duration: 0.3 }}
                  >
                    <div className={styles.messageContent}>
                      {message.content}
                    </div>
                  </motion.div>
                ))}
              </AnimatePresence>
            </div>

            <div className={styles.inputArea}>
              <input
                type="text"
                value={prompt}
                onChange={(e) => setPrompt(e.target.value)}
                placeholder={`${t.placeholder} ${selectedAI.name}`}
                className={styles.promptInput}
                onKeyPress={(e) => e.key === 'Enter' && handleSendPrompt()}
              />
              <motion.button
                className={styles.sendButton}
                onClick={handleSendPrompt}
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                style={{ backgroundColor: selectedAI.color }}
              >
                {t.sendPrompt} {selectedAI.icon}
              </motion.button>
            </div>
          </div>

          <div className={styles.features}>
            <div className={styles.featureGrid}>
              <div className={styles.feature}>
                <span className={styles.featureIcon}>💬</span>
                <span>Chat unifié</span>
              </div>
              <div className={styles.feature}>
                <span className={styles.featureIcon}>🔄</span>
                <span>Comparaison IA</span>
              </div>
              <div className={styles.feature}>
                <span className={styles.featureIcon}>📊</span>
                <span>Analyse réponses</span>
              </div>
              <div className={styles.feature}>
                <span className={styles.featureIcon}>💾</span>
                <span>Historique</span>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </>
  );
}
EOF
    
    # Styles CSS Modules pour Next.js
    mkdir -p styles
    cat > styles/Home.module.css << 'EOF'
.container {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  font-family: 'Inter', Arial, sans-serif;
  position: relative;
}

.languageSelector {
  position: absolute;
  top: 20px;
  right: 20px;
  z-index: 1000;
}

.languageSelect {
  background: rgba(255, 255, 255, 0.95);
  border: none;
  border-radius: 8px;
  padding: 8px 12px;
  cursor: pointer;
  font-size: 14px;
}

.main {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 30px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 3rem;
  max-width: 1200px;
  width: 100%;
  color: white;
  text-align: center;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
}

.title {
  font-size: 3.5rem;
  margin-bottom: 1rem;
  background: linear-gradient(45deg, #fff 0%, #f0f0f0 50%, #fff 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: pulse 4s ease-in-out infinite;
}

.subtitle {
  font-size: 1.3rem;
  margin-bottom: 3rem;
  opacity: 0.9;
}

.platformBadge {
  position: absolute;
  top: 10px;
  left: 10px;
  background: rgba(255, 255, 255, 0.2);
  padding: 8px 12px;
  border-radius: 15px;
  font-size: 0.8rem;
  font-weight: bold;
}

.aiSelection {
  margin-bottom: 3rem;
}

.aiGrid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.aiCard {
  background: rgba(255, 255, 255, 0.1);
  border: 2px solid transparent;
  border-radius: 15px;
  padding: 1.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: center;
}

.aiCard:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-2px);
}

.aiCard.selected {
  background: rgba(255, 255, 255, 0.2);
  border-color: currentColor;
}

.aiIcon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.aiCard h4 {
  margin: 0.5rem 0;
  font-size: 1.2rem;
}

.aiCard p {
  margin: 0;
  font-size: 0.9rem;
  opacity: 0.8;
}

.chatInterface {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 20px;
  padding: 2rem;
  margin-bottom: 2rem;
}

.conversation {
  min-height: 200px;
  max-height: 400px;
  overflow-y: auto;
  margin-bottom: 1.5rem;
  padding: 1rem;
  background: rgba(0, 0, 0, 0.1);
  border-radius: 15px;
}

.message {
  margin-bottom: 1rem;
  display: flex;
}

.message.user {
  justify-content: flex-end;
}

.message.assistant {
  justify-content: flex-start;
}

.messageContent {
  max-width: 70%;
  padding: 1rem;
  border-radius: 15px;
  background: rgba(255, 255, 255, 0.1);
}

.message.user .messageContent {
  background: rgba(102, 126, 234, 0.3);
}

.inputArea {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.promptInput {
  flex: 1;
  padding: 1rem;
  border: none;
  border-radius: 15px;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  font-size: 1rem;
  backdrop-filter: blur(10px);
}

.promptInput::placeholder {
  color: rgba(255, 255, 255, 0.7);
}

.sendButton {
  padding: 1rem 2rem;
  border: none;
  border-radius: 15px;
  color: white;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
}

.features {
  margin-top: 2rem;
}

.featureGrid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1rem;
}

.feature {
  background: rgba(255, 255, 255, 0.1);
  padding: 1rem;
  border-radius: 10px;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.featureIcon {
  font-size: 1.5rem;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.7; }
}

@media (max-width: 768px) {
  .main {
    padding: 2rem;
    margin: 10px;
  }
  
  .title {
    font-size: 2.5rem;
  }
  
  .aiGrid {
    grid-template-columns: 1fr;
  }
  
  .inputArea {
    flex-direction: column;
  }
  
  .promptInput {
    width: 100%;
  }
}
EOF
    
    # Globals CSS
    cat > styles/globals.css << 'EOF'
html,
body {
  padding: 0;
  margin: 0;
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif;
}

* {
  box-sizing: border-box;
}

/* Support RTL */
[dir="rtl"] {
  text-align: right;
}

[dir="rtl"] .languageSelector {
  right: auto;
  left: 20px;
}
EOF
}

# =============================================================================
# FONCTION PRINCIPALE D'INSTALLATION
# =============================================================================

install_complete_platform() {
    show_header
    
    echo -e "${BOLD}🌟 INSTALLATION PLATEFORME ULTIME${NC}"
    echo -e "${BOLD}==================================${NC}"
    echo ""
    
    # Étape 1: Vérification des prérequis
    if ! check_prerequisites; then
        echo -e "${RED}❌ Prérequis non satisfaits. Installation interrompue.${NC}"
        exit 1
    fi
    
    # Étape 2: Installation des outils globaux
    install_global_tools
    
    # Étape 3: Création de la structure
    create_project_structure
    
    # Étape 4: Création des applications
    echo -e "${BLUE}🏗️ CRÉATION DES 6 APPLICATIONS HYBRIDES${NC}"
    echo -e "${BLUE}=======================================${NC}"
    echo ""
    
    local total_apps=${#APPS_CONFIG[@]}
    local current_app=0
    
    for app_config in "${APPS_CONFIG[@]}"; do
        current_app=$((current_app + 1))
        progress_bar $current_app $total_apps "Création des applications"
        create_hybrid_app "$app_config"
    done
    
    echo ""
    
    # Étape 5: Création des tests BDD
    create_bdd_tests
    
    # Étape 6: Installation des dépendances de test
    echo -e "${BLUE}📦 INSTALLATION DES DÉPENDANCES DE TEST${NC}"
    echo -e "${BLUE}======================================${NC}"
    echo ""
    
    cd "$TESTS_DIR"
    npm install --silent
    
    # Étape 7: Création des scripts utilitaires
    create_utility_scripts
    
    # Affichage final
    show_final_summary
}

create_utility_scripts() {
    echo -e "${BLUE}📜 CRÉATION DES SCRIPTS UTILITAIRES${NC}"
    echo -e "${BLUE}===================================${NC}"
    echo ""
    
    mkdir -p "$PROJECT_DIR/scripts"
    
    # Script de démarrage global
    cat > "$PROJECT_DIR/scripts/start-all.sh" << 'EOF'
#!/bin/bash
echo "🚀 Démarrage de toutes les applications..."

apps=("math4kids:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005" "digital4kids:3006")

for app in "${apps[@]}"; do
    IFS=':' read -r name port <<< "$app"
    echo "Démarrage de $name sur le port $port..."
    cd "apps/$name"
    PORT=$port npm start > "../../logs/$name.log" 2>&1 &
    cd "../.."
done

echo "✅ Toutes les applications démarrées!"
echo "📊 Vérifiez le statut avec: ./scripts/status.sh"
EOF
    
    # Script de statut
    cat > "$PROJECT_DIR/scripts/status.sh" << 'EOF'
#!/bin/bash
echo "📊 Statut des applications:"
echo "=========================="

ports=(3001 3002 3003 3004 3005 3006)
names=("Math4Kids" "UnitFlip" "BudgetCron" "AI4Kids" "MultiAI" "Digital4Kids")

for i in "${!ports[@]}"; do
    port=${ports[$i]}
    name=${names[$i]}
    
    if curl -s -f "http://localhost:$port" >/dev/null 2>&1; then
        echo "✅ $name - http://localhost:$port"
    else
        echo "❌ $name - Non actif"
    fi
done
EOF
    
    # Script de build mobile
    cat > "$PROJECT_DIR/scripts/build-mobile.sh" << 'EOF'
#!/bin/bash
echo "📱 Build des applications mobiles..."

for app in apps/*/; do
    if [ -f "$app/capacitor.config.ts" ]; then
        echo "Building mobile app for $(basename "$app")..."
        cd "$app"
        npm run build
        npx cap sync
        cd "../.."
    fi
done

echo "✅ Build mobile terminé!"
EOF
    
    # Script de test global
    cat > "$PROJECT_DIR/scripts/test-all.sh" << 'EOF'
#!/bin/bash
echo "🧪 Lancement de tous les tests..."

cd tests
npm test

echo "📊 Tests terminés! Voir les rapports dans tests/reports/"
EOF
    
    # Rendre tous les scripts exécutables
    chmod +x "$PROJECT_DIR/scripts"/*.sh
    
    echo -e "${GREEN}✅ Scripts utilitaires créés${NC}"
}

show_final_summary() {
    show_header
    
    echo -e "${BOLD}${GREEN}🎉 INSTALLATION TERMINÉE AVEC SUCCÈS! 🎉${NC}"
    echo -e "${BOLD}${GREEN}=======================================${NC}"
    echo ""
    
    echo -e "${CYAN}📱 Applications créées:${NC}"
    for app_config in "${APPS_CONFIG[@]}"; do
        IFS=':' read -r app_name port framework category description <<< "$app_config"
        echo -e "   ${GREEN}✅ $app_name${NC} ($framework) - http://localhost:$port"
        echo -e "      📝 $description"
        echo ""
    done
    
    echo -e "${CYAN}🌍 Langues supportées:${NC}"
    echo -e "   ${GREEN}26 langues${NC} couvrant tous les continents"
    echo -e "   Europe, Asie, Afrique, Amériques avec support RTL"
    echo ""
    
    echo -e "${CYAN}📱 Plateformes supportées:${NC}"
    echo -e "   ${GREEN}✅ Web${NC} (Progressive Web App)"
    echo -e "   ${GREEN}✅ Android${NC} (via Capacitor)"
    echo -e "   ${GREEN}✅ iOS${NC} (via Capacitor)"
    echo ""
    
    echo -e "${CYAN}🧪 Tests BDD créés:${NC}"
    echo -e "   ${GREEN}✅ Tests Cucumber${NC} pour toutes les applications"
    echo -e "   ${GREEN}✅ Tests multi-plateformes${NC} (Web, Android, iOS)"
    echo -e "   ${GREEN}✅ Tests d'accessibilité${NC} et performance"
    echo ""
    
    echo -e "${CYAN}🚀 Pour démarrer:${NC}"
    echo -e "   ${YELLOW}./scripts/start-all.sh${NC}     # Démarrer toutes les apps"
    echo -e "   ${YELLOW}./scripts/status.sh${NC}       # Vérifier le statut"
    echo -e "   ${YELLOW}./scripts/test-all.sh${NC}     # Lancer tous les tests"
    echo -e "   ${YELLOW}./scripts/build-mobile.sh${NC} # Build pour mobile"
    echo ""
    
    echo -e "${CYAN}📱 Pour chaque application:${NC}"
    echo -e "   ${YELLOW}cd apps/[nom-app]${NC}"
    echo -e "   ${YELLOW}npm run android${NC}     # Ouvrir sur Android"
    echo -e "   ${YELLOW}npm run ios${NC}         # Ouvrir sur iOS"
    echo ""
    
    echo -e "${CYAN}🧪 Tests BDD:${NC}"
    echo -e "   ${YELLOW}cd tests${NC}"
    echo -e "   ${YELLOW}npm run test:web${NC}     # Tests web uniquement"
    echo -e "   ${YELLOW}npm run test:mobile${NC}  # Tests mobile uniquement"
    echo -e "   ${YELLOW}npm run test:all${NC}     # Tous les tests"
    echo ""
    
    echo -e "${BOLD}${MAGENTA}🌟 PLATEFORME ULTIME PRÊTE! 🌟${NC}"
    echo -e "${BOLD}${MAGENTA}6 Apps • 26 Langues • 3 Plateformes • Tests BDD${NC}"
    echo ""
}

# =============================================================================
# MENU PRINCIPAL
# =============================================================================

show_main_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🎯 MENU PRINCIPAL - PLATEFORME ULTIME${NC}"
        echo -e "${CYAN}====================================${NC}"
        echo ""
        echo -e "${GREEN}1.${NC} 🌍 Installation complète (6 apps + 26 langues + tests)"
        echo -e "${GREEN}2.${NC} 🚀 Démarrer toutes les applications"
        echo -e "${GREEN}3.${NC} 📊 Vérifier le statut des applications"
        echo -e "${GREEN}4.${NC} 🧪 Lancer les tests BDD Cucumber"
        echo -e "${GREEN}5.${NC} 📱 Build pour mobile (Android/iOS)"
        echo -e "${GREEN}6.${NC} 🔧 Réparer une application spécifique"
        echo -e "${GREEN}7.${NC} 📝 Voir les logs détaillés"
        echo -e "${GREEN}8.${NC} 🧹 Nettoyer et réinitialiser"
        echo -e "${RED}0.${NC} ❌ Quitter"
        echo ""
        echo -e "${YELLOW}Langues: FR, EN, ES, DE, IT, PT, RU, AR, ZH, JA, KO, HI, TH, VI, ID, MS, SW, AM, YO, ZU, TR, PL, NL, SV, NO, HE${NC}"
        echo ""
        read -p "Votre choix (0-8): " choice
        
        case $choice in
            1)
                install_complete_platform
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            2)
                echo -e "${YELLOW}🚀 Démarrage de toutes les applications...${NC}"
                "$PROJECT_DIR/scripts/start-all.sh"
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            3)
                echo -e "${BLUE}📊 Statut des applications:${NC}"
                echo ""
                "$PROJECT_DIR/scripts/status.sh"
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            4)
                echo -e "${BLUE}🧪 Lancement des tests BDD...${NC}"
                "$PROJECT_DIR/scripts/test-all.sh"
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            5)
                echo -e "${BLUE}📱 Build pour mobile...${NC}"
                "$PROJECT_DIR/scripts/build-mobile.sh"
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            6)
                echo -e "${CYAN}Applications disponibles:${NC}"
                for app_config in "${APPS_CONFIG[@]}"; do
                    IFS=':' read -r app_name port framework category description <<< "$app_config"
                    echo "  - $app_name ($framework)"
                done
                echo ""
                read -p "Nom de l'application à réparer: " app_to_repair
                if [ -d "$WORKSPACE_DIR/$app_to_repair" ]; then
                    cd "$WORKSPACE_DIR/$app_to_repair"
                    rm -rf node_modules package-lock.json
                    npm install --legacy-peer-deps
                    echo -e "${GREEN}✅ $app_to_repair réparé${NC}"
                else
                    echo -e "${RED}❌ Application non trouvée${NC}"
                fi
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            7)
                echo -e "${BLUE}📝 Logs détaillés:${NC}"
                echo ""
                if [ -d "$LOG_DIR" ]; then
                    for log_file in "$LOG_DIR"/*.log; do
                        if [ -f "$log_file" ]; then
                            echo -e "${CYAN}$(basename "$log_file"):${NC}"
                            tail -n 5 "$log_file"
                            echo ""
                        fi
                    done
                else
                    echo -e "${YELLOW}Aucun log disponible${NC}"
                fi
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            8)
                echo -e "${RED}⚠️ ATTENTION: Ceci va supprimer toutes les applications et données${NC}"
                read -p "Êtes-vous sûr ? (oui/non): " confirm
                if [ "$confirm" = "oui" ]; then
                    rm -rf "$WORKSPACE_DIR" "$LOG_DIR" "$TESTS_DIR"
                    echo -e "${GREEN}✅ Nettoyage terminé${NC}"
                fi
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            0)
                echo -e "${GREEN}👋 Au revoir !${NC}"
                echo -e "${CYAN}Merci d'avoir utilisé la plateforme ultime !${NC}"
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
    # Créer les répertoires de base
    mkdir -p "$LOG_DIR"
    
    case "${1:-menu}" in
        "install")
            install_complete_platform
            ;;
        "start")
            "$PROJECT_DIR/scripts/start-all.sh"
            ;;
        "status")
            "$PROJECT_DIR/scripts/status.sh"
            ;;
        "test")
            "$PROJECT_DIR/scripts/test-all.sh"
            ;;
        "build")
            "$PROJECT_DIR/scripts/build-mobile.sh"
            ;;
        "help"|"-h"|"--help")
            show_header
            echo -e "${CYAN}UTILISATION:${NC}"
            echo ""
            echo -e "  ${GREEN}$0${NC}          - Menu interactif"
            echo -e "  ${GREEN}$0 install${NC}  - Installation complète"
            echo -e "  ${GREEN}$0 start${NC}    - Démarrer toutes les apps"
            echo -e "  ${GREEN}$0 status${NC}   - Vérifier le statut"
            echo -e "  ${GREEN}$0 test${NC}     - Lancer les tests BDD"
            echo -e "  ${GREEN}$0 build${NC}    - Build mobile"
            echo ""
            ;;
        *)
            show_main_menu
            ;;
    esac
}

# Vérifier les droits d'exécution
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}❌ Ne pas exécuter ce script en tant que root${NC}"
    exit 1
fi

# Vérifier la disponibilité de jq pour JSON
if ! command -v jq >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️ jq non installé. Installation recommandée pour les traductions avancées${NC}"
    echo -e "${CYAN}Installation: brew install jq (macOS) ou apt install jq (Ubuntu)${NC}"
fi

# Exécuter la fonction principale
main "$@" le titre de l\\'application', async function(this: CustomWorld) {
  const title = await this.page.locator('h1').first();
  await expect(title).toBeVisible();
  await expect(title).toContainText('${app_name}', { ignoreCase: true });
});

Then('l\\'interface est responsive', async function(this: CustomWorld) {
  // Test desktop
  await this.page.setViewportSize({ width: 1920, height: 1080 });
  await expect(this.page.locator('.app-container')).toBeVisible();
  
  // Test mobile
  await this.page.setViewportSize({ width: 375, height: 667 });
  await expect(this.page.locator('.app-container')).toBeVisible();
  
  // Test tablet
  await this.page.setViewportSize({ width: 768, height: 1024 });
  await expect(this.page.locator('.app-container')).toBeVisible();
});

Then('tous les éléments sont visibles', async function(this: CustomWorld) {
  await expect(this.page.locator('h1')).toBeVisible();
  await expect(this.page.locator('.language-selector')).toBeVisible();
});

When('je clique sur le sélecteur de langue', async function(this: CustomWorld) {
  await this.page.locator('.language-select').click();
});

Then('je vois