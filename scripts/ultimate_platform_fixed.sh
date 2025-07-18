#!/bin/bash

# =============================================================================
# SCRIPT ULTIME - PLATEFORME COMPLÈTE 6 APPS HYBRIDES - VERSION CORRIGÉE
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
BOLD='\033[1m'
NC='\033[0m'

# Configuration des applications
declare -a APPS_CONFIG=(
    "math4kids:3001:React:Education"
    "unitflip:3002:React:Utility"
    "budgetcron:3003:Vue:Finance"
    "ai4kids:3004:React:AI"
    "multiai:3005:Next:AI"
    "digital4kids:3006:React:Marketing"
)

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
    echo ""
}

log_message() {
    local level=$1
    local color=$2
    local message=$3
    echo -e "${color}[${level}] ${message}${NC}"
    
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] ${message}" >> "$LOG_DIR/platform.log"
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
    
    # curl
    if command -v curl >/dev/null 2>&1; then
        echo -e "${GREEN}✅ cURL disponible${NC}"
    else
        echo -e "${RED}❌ cURL non installé${NC}"
        errors=$((errors + 1))
    fi
    
    echo ""
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✅ Tous les prérequis sont satisfaits${NC}"
        return 0
    else
        echo -e "${RED}❌ $errors erreur(s) détectée(s)${NC}"
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
        "typescript"
    )
    
    for tool in "${tools[@]}"; do
        echo -e "${YELLOW}📦 Installation de $tool...${NC}"
        npm install -g "$tool" --silent 2>/dev/null || echo -e "${YELLOW}⚠️ $tool déjà installé ou erreur${NC}"
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
    mkdir -p "$PROJECT_DIR/scripts"
    
    # Structure de tests
    mkdir -p "$TESTS_DIR/features"
    mkdir -p "$TESTS_DIR/step-definitions"
    mkdir -p "$TESTS_DIR/support"
    mkdir -p "$TESTS_DIR/reports"
    
    echo -e "${GREEN}✅ Structure de projet créée${NC}"
}

# =============================================================================
# CRÉATION D'UNE APPLICATION HYBRIDE
# =============================================================================

create_hybrid_app() {
    local app_config=$1
    IFS=':' read -r app_name port framework category <<< "$app_config"
    
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🚀 Création de $app_name ($framework - $category)${NC}"
    
    # Supprimer et recréer le répertoire
    rm -rf "$app_dir"
    mkdir -p "$app_dir"
    cd "$app_dir"
    
    case "$framework" in
        "React")
            create_react_app "$app_name" "$port" "$category"
            ;;
        "Vue")
            create_vue_app "$app_name" "$port" "$category"
            ;;
        "Next")
            create_next_app "$app_name" "$port" "$category"
            ;;
    esac
    
    # Installer les dépendances
    echo -e "   📦 Installation des dépendances..."
    npm install --legacy-peer-deps --silent
    
    echo -e "   ${GREEN}✅ $app_name créé avec succès${NC}"
    echo ""
}

# =============================================================================
# CRÉATION DES APPLICATIONS REACT
# =============================================================================

create_react_app() {
    local app_name=$1
    local port=$2
    local category=$3
    
    # Package.json optimisé
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
    "@capacitor/ios": "^5.0.0"
  },
  "scripts": {
    "start": "PORT=$port SKIP_PREFLIGHT_CHECK=true react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
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
    
    # Structure React
    mkdir -p src public
    
    # Index.html
    cat > public/index.html << EOF
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>$app_name - Application Hybride</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div id="root"></div>
</body>
</html>
EOF
    
    # Application selon la catégorie
    case "$category" in
        "Education")
            create_education_react_app "$app_name"
            ;;
        "Utility")
            create_utility_react_app "$app_name"
            ;;
        "AI")
            create_ai_react_app "$app_name"
            ;;
        "Marketing")
            create_marketing_react_app "$app_name"
            ;;
        *)
            create_default_react_app "$app_name"
            ;;
    esac
    
    # Configuration Capacitor
    cat > capacitor.config.ts << EOF
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.platform.${app_name}',
  appName: '${app_name}',
  webDir: 'build',
  server: {
    androidScheme: 'https'
  }
};

export default config;
EOF
    
    # Index TypeScript
    cat > src/index.tsx << 'EOF'
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
    
    # Styles globaux
    cat > src/index.css << 'EOF'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
  min-height: 100vh;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.7; }
}
EOF
}

create_education_react_app() {
    local app_name=$1
    
    cat > src/App.tsx << 'EOF'
import React, { useState } from 'react';
import './App.css';

const LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦' },
  { code: 'zh', name: '中文', flag: '🇨🇳' },
];

function App() {
  const [currentLang, setCurrentLang] = useState('fr');
  const [score, setScore] = useState(0);
  const [currentQuestion, setCurrentQuestion] = useState(0);
  
  const questions = [
    { question: '2 + 3 = ?', options: [4, 5, 6], correct: 1 },
    { question: '10 - 4 = ?', options: [5, 6, 7], correct: 1 },
    { question: '3 × 4 = ?', options: [11, 12, 13], correct: 1 },
  ];

  const texts = {
    fr: {
      title: 'Math4Kids - Mathématiques pour Enfants',
      score: 'Score',
      question: 'Question'
    },
    en: {
      title: 'Math4Kids - Mathematics for Children',
      score: 'Score',
      question: 'Question'
    },
    es: {
      title: 'Math4Kids - Matemáticas para Niños',
      score: 'Puntuación',
      question: 'Pregunta'
    }
  };

  const t = texts[currentLang as keyof typeof texts] || texts.fr;

  const handleAnswer = (answerIndex: number) => {
    if (answerIndex === questions[currentQuestion].correct) {
      setScore(score + 1);
    }
    
    if (currentQuestion < questions.length - 1) {
      setCurrentQuestion(currentQuestion + 1);
    } else {
      alert(`Terminé! Score: ${score + (answerIndex === questions[currentQuestion].correct ? 1 : 0)}/${questions.length}`);
    }
  };

  return (
    <div className="App" dir={['ar', 'he'].includes(currentLang) ? 'rtl' : 'ltr'}>
      <div className="language-selector">
        <select 
          value={currentLang} 
          onChange={(e) => setCurrentLang(e.target.value)}
        >
          {LANGUAGES.map((lang) => (
            <option key={lang.code} value={lang.code}>
              {lang.flag} {lang.name}
            </option>
          ))}
        </select>
      </div>

      <div className="app-container">
        <h1>🧮 {t.title}</h1>
        
        <div className="score-display">
          {t.score}: {score}/{questions.length}
        </div>

        <div className="question-container">
          <h2>{questions[currentQuestion].question}</h2>
          
          <div className="options">
            {questions[currentQuestion].options.map((option, index) => (
              <button
                key={index}
                className="option-btn"
                onClick={() => handleAnswer(index)}
              >
                {option}
              </button>
            ))}
          </div>
        </div>

        <div className="progress-bar">
          <div 
            className="progress-fill"
            style={{ width: `${((currentQuestion + 1) / questions.length) * 100}%` }}
          />
        </div>
      </div>
    </div>
  );
}

export default App;
EOF
    
    cat > src/App.css << 'EOF'
.App {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: white;
  padding: 20px;
  position: relative;
}

.language-selector {
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.15);
  padding: 10px;
  border-radius: 10px;
}

.language-selector select {
  background: white;
  border: none;
  padding: 5px 10px;
  border-radius: 5px;
  cursor: pointer;
}

.app-container {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 3rem;
  text-align: center;
  max-width: 600px;
  width: 100%;
  animation: float 6s ease-in-out infinite;
}

.app-container h1 {
  font-size: 2.5rem;
  margin-bottom: 2rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.score-display {
  font-size: 1.5rem;
  margin-bottom: 2rem;
  background: rgba(0, 255, 0, 0.2);
  padding: 1rem;
  border-radius: 10px;
}

.question-container h2 {
  font-size: 2rem;
  margin-bottom: 2rem;
  background: rgba(255, 255, 255, 0.1);
  padding: 1rem;
  border-radius: 10px;
}

.options {
  display: flex;
  gap: 1rem;
  justify-content: center;
  margin-bottom: 2rem;
}

.option-btn {
  background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
  border: none;
  border-radius: 15px;
  color: white;
  padding: 1rem 2rem;
  font-size: 1.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.option-btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}

.progress-bar {
  width: 100%;
  height: 10px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 5px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(45deg, #4ECDC4, #44A08D);
  transition: width 0.5s ease;
}

[dir="rtl"] .language-selector {
  right: auto;
  left: 20px;
}

@media (max-width: 768px) {
  .app-container {
    padding: 2rem;
    margin: 10px;
  }
  
  .options {
    flex-direction: column;
  }
}
EOF
}

create_utility_react_app() {
    local app_name=$1
    
    cat > src/App.tsx << 'EOF'
import React, { useState } from 'react';
import './App.css';

const LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
];

function App() {
  const [currentLang, setCurrentLang] = useState('fr');
  const [inputValue, setInputValue] = useState(1);
  const [fromUnit, setFromUnit] = useState('m');
  const [toUnit, setToUnit] = useState('cm');
  const [result, setResult] = useState(100);

  const texts = {
    fr: {
      title: 'UnitFlip - Conversion d\'Unités',
      from: 'De',
      to: 'Vers',
      convert: 'Convertir'
    },
    en: {
      title: 'UnitFlip - Unit Conversion',
      from: 'From',
      to: 'To',
      convert: 'Convert'
    },
    es: {
      title: 'UnitFlip - Conversión de Unidades',
      from: 'De',
      to: 'A',
      convert: 'Convertir'
    }
  };

  const t = texts[currentLang as keyof typeof texts] || texts.fr;

  const units = [
    { code: 'm', name: 'Mètres' },
    { code: 'cm', name: 'Centimètres' },
    { code: 'km', name: 'Kilomètres' },
    { code: 'ft', name: 'Pieds' },
  ];

  const convert = () => {
    let factor = 1;
    
    // Conversion simple (mètres comme base)
    const toMeters = {
      'm': 1,
      'cm': 0.01,
      'km': 1000,
      'ft': 0.3048
    };
    
    const fromMeters = {
      'm': 1,
      'cm': 100,
      'km': 0.001,
      'ft': 3.28084
    };
    
    const valueInMeters = inputValue * toMeters[fromUnit as keyof typeof toMeters];
    const convertedValue = valueInMeters * fromMeters[toUnit as keyof typeof fromMeters];
    
    setResult(Math.round(convertedValue * 100) / 100);
  };

  return (
    <div className="App">
      <div className="language-selector">
        <select 
          value={currentLang} 
          onChange={(e) => setCurrentLang(e.target.value)}
        >
          {LANGUAGES.map((lang) => (
            <option key={lang.code} value={lang.code}>
              {lang.flag} {lang.name}
            </option>
          ))}
        </select>
      </div>

      <div className="app-container">
        <h1>📏 {t.title}</h1>
        
        <div className="converter">
          <div className="input-group">
            <label>{t.from}:</label>
            <input
              type="number"
              value={inputValue}
              onChange={(e) => setInputValue(Number(e.target.value))}
            />
            <select 
              value={fromUnit} 
              onChange={(e) => setFromUnit(e.target.value)}
            >
              {units.map((unit) => (
                <option key={unit.code} value={unit.code}>
                  {unit.name}
                </option>
              ))}
            </select>
          </div>

          <button className="convert-btn" onClick={convert}>
            🔄 {t.convert}
          </button>

          <div className="input-group">
            <label>{t.to}:</label>
            <div className="result">{result}</div>
            <select 
              value={toUnit} 
              onChange={(e) => setToUnit(e.target.value)}
            >
              {units.map((unit) => (
                <option key={unit.code} value={unit.code}>
                  {unit.name}
                </option>
              ))}
            </select>
          </div>
        </div>

        <div className="quick-conversions">
          <h3>Conversions rapides:</h3>
          <div className="conversion-grid">
            <div>1m = 100cm</div>
            <div>1km = 1000m</div>
            <div>1ft = 30.48cm</div>
            <div>1m = 3.28ft</div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
EOF
    
    cat > src/App.css << 'EOF'
.App {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: white;
  padding: 20px;
  position: relative;
}

.language-selector {
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.15);
  padding: 10px;
  border-radius: 10px;
}

.language-selector select {
  background: white;
  border: none;
  padding: 5px 10px;
  border-radius: 5px;
  cursor: pointer;
}

.app-container {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 3rem;
  text-align: center;
  max-width: 700px;
  width: 100%;
  animation: float 6s ease-in-out infinite;
}

.app-container h1 {
  font-size: 2.5rem;
  margin-bottom: 2rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.converter {
  margin: 2rem 0;
}

.input-group {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin: 1.5rem 0;
}

.input-group label {
  font-weight: bold;
  min-width: 60px;
}

.input-group input {
  padding: 10px;
  border: none;
  border-radius: 8px;
  font-size: 1.2rem;
  width: 120px;
  text-align: center;
}

.input-group select {
  padding: 10px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
}

.result {
  background: linear-gradient(45deg, #4ECDC4, #44A08D);
  color: white;
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 1.2rem;
  font-weight: bold;
  min-width: 120px;
}

.convert-btn {
  background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
  border: none;
  border-radius: 15px;
  color: white;
  padding: 1rem 2rem;
  font-size: 1.2rem;
  cursor: pointer;
  margin: 1rem;
  transition: all 0.3s ease;
}

.convert-btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}

.quick-conversions {
  margin-top: 2rem;
  background: rgba(255, 255, 255, 0.05);
  padding: 1.5rem;
  border-radius: 15px;
}

.conversion-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-top: 1rem;
}

.conversion-grid div {
  background: rgba(255, 255, 255, 0.1);
  padding: 0.8rem;
  border-radius: 8px;
}

@media (max-width: 768px) {
  .app-container {
    padding: 2rem;
    margin: 10px;
  }
  
  .input-group {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .conversion-grid {
    grid-template-columns: 1fr;
  }
}
EOF
}

create_ai_react_app() {
    local app_name=$1
    
    cat > src/App.tsx << 'EOF'
import React, { useState } from 'react';
import './App.css';

const LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
];

const AI_CHARACTERS = [
  { id: 'robo', name: 'RobotIA', icon: '🤖', color: '#4ECDC4' },
  { id: 'brain', name: 'CerveauBot', icon: '🧠', color: '#45B7D1' },
  { id: 'magic', name: 'MagieAI', icon: '✨', color: '#F39C12' },
  { id: 'unicorn', name: 'LicorneIA', icon: '🦄', color: '#E74C3C' },
];

function App() {
  const [currentLang, setCurrentLang] = useState('fr');
  const [selectedCharacter, setSelectedCharacter] = useState(AI_CHARACTERS[0]);
  const [question, setQuestion] = useState('');
  const [conversation, setConversation] = useState<Array<{role: string, content: string}>>([]);

  const texts = {
    fr: {
      title: 'AI4Kids - Intelligence Artificielle pour Enfants',
      askQuestion: 'Pose une question',
      send: 'Envoyer',
      placeholder: 'Pose une question à ton assistant IA...'
    },
    en: {
      title: 'AI4Kids - Artificial Intelligence for Children',
      askQuestion: 'Ask a question',
      send: 'Send',
      placeholder: 'Ask your AI assistant a question...'
    },
    es: {
      title: 'AI4Kids - Inteligencia Artificial para Niños',
      askQuestion: 'Hacer una pregunta',
      send: 'Enviar',
      placeholder: 'Haz una pregunta a tu asistente IA...'
    }
  };

  const t = texts[currentLang as keyof typeof texts] || texts.fr;

  const handleSendQuestion = () => {
    if (!question.trim()) return;
    
    const userMessage = { role: 'user', content: question };
    const aiResponse = { 
      role: 'assistant', 
      content: `${selectedCharacter.name} répond: C'est une excellente question ! ${question}` 
    };
    
    setConversation([...conversation, userMessage, aiResponse]);
    setQuestion('');
  };

  return (
    <div className="App">
      <div className="language-selector">
        <select 
          value={currentLang} 
          onChange={(e) => setCurrentLang(e.target.value)}
        >
          {LANGUAGES.map((lang) => (
            <option key={lang.code} value={lang.code}>
              {lang.flag} {lang.name}
            </option>
          ))}
        </select>
      </div>

      <div className="app-container">
        <h1>🤖 {t.title}</h1>
        
        <div className="character-selection">
          <h3>Choisis ton assistant IA:</h3>
          <div className="characters-grid">
            {AI_CHARACTERS.map((character) => (
              <div
                key={character.id}
                className={`character-card ${selectedCharacter.id === character.id ? 'selected' : ''}`}
                onClick={() => setSelectedCharacter(character)}
                style={{ borderColor: selectedCharacter.id === character.id ? character.color : 'transparent' }}
              >
                <div className="character-icon" style={{ color: character.color }}>
                  {character.icon}
                </div>
                <div className="character-name">{character.name}</div>
              </div>
            ))}
          </div>
        </div>

        <div className="chat-interface">
          <div className="conversation">
            {conversation.map((message, index) => (
              <div key={index} className={`message ${message.role}`}>
                <div className="message-content">
                  {message.content}
                </div>
              </div>
            ))}
            {conversation.length === 0 && (
              <div className="welcome-message">
                Salut ! Je suis {selectedCharacter.name} {selectedCharacter.icon}. Pose-moi une question !
              </div>
            )}
          </div>

          <div className="input-area">
            <input
              type="text"
              value={question}
              onChange={(e) => setQuestion(e.target.value)}
              placeholder={t.placeholder}
              onKeyPress={(e) => e.key === 'Enter' && handleSendQuestion()}
            />
            <button 
              onClick={handleSendQuestion}
              style={{ backgroundColor: selectedCharacter.color }}
            >
              {t.send} {selectedCharacter.icon}
            </button>
          </div>
        </div>

        <div className="features">
          <h3>✨ Fonctionnalités:</h3>
          <div className="features-grid">
            <div>🎓 Aide aux devoirs</div>
            <div>🎨 Créativité assistée</div>
            <div>🧩 Résolution de problèmes</div>
            <div>📚 Apprentissage ludique</div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
EOF
    
    cat > src/App.css << 'EOF'
.App {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: white;
  padding: 20px;
  position: relative;
}

.language-selector {
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.15);
  padding: 10px;
  border-radius: 10px;
}

.language-selector select {
  background: white;
  border: none;
  padding: 5px 10px;
  border-radius: 5px;
  cursor: pointer;
}

.app-container {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 3rem;
  text-align: center;
  max-width: 900px;
  width: 100%;
  animation: float 6s ease-in-out infinite;
}

.app-container h1 {
  font-size: 2.5rem;
  margin-bottom: 2rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.character-selection {
  margin: 2rem 0;
}

.characters-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.character-card {
  background: rgba(255, 255, 255, 0.1);
  border: 2px solid transparent;
  border-radius: 15px;
  padding: 1.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.character-card:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-3px);
}

.character-card.selected {
  background: rgba(255, 255, 255, 0.2);
  border-color: currentColor;
}

.character-icon {
  font-size: 3rem;
  margin-bottom: 0.5rem;
}

.character-name {
  font-weight: bold;
}

.chat-interface {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 15px;
  padding: 1.5rem;
  margin: 2rem 0;
}

.conversation {
  min-height: 200px;
  max-height: 300px;
  overflow-y: auto;
  margin-bottom: 1rem;
  text-align: left;
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

.message-content {
  max-width: 70%;
  padding: 1rem;
  border-radius: 15px;
  background: rgba(255, 255, 255, 0.1);
}

.message.user .message-content {
  background: rgba(102, 126, 234, 0.3);
}

.welcome-message {
  text-align: center;
  font-style: italic;
  opacity: 0.8;
  padding: 2rem;
}

.input-area {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.input-area input {
  flex: 1;
  padding: 1rem;
  border: none;
  border-radius: 15px;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  font-size: 1rem;
}

.input-area input::placeholder {
  color: rgba(255, 255, 255, 0.7);
}

.input-area button {
  padding: 1rem 1.5rem;
  border: none;
  border-radius: 15px;
  color: white;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
}

.input-area button:hover {
  transform: translateY(-2px);
}

.features {
  margin-top: 2rem;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.features-grid div {
  background: rgba(255, 255, 255, 0.1);
  padding: 1rem;
  border-radius: 10px;
}

@media (max-width: 768px) {
  .app-container {
    padding: 2rem;
    margin: 10px;
  }
  
  .characters-grid {
    grid-template-columns: 1fr 1fr;
  }
  
  .input-area {
    flex-direction: column;
  }
  
  .input-area input {
    width: 100%;
  }
}
EOF
}

create_marketing_react_app() {
    local app_name=$1
    
    cat > src/App.tsx << 'EOF'
import React, { useState } from 'react';
import './App.css';

const LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
];

function App() {
  const [currentLang, setCurrentLang] = useState('fr');
  const [currentModule, setCurrentModule] = useState(0);

  const texts = {
    fr: {
      title: 'Digital4Kids - Marketing Digital pour Enfants',
      subtitle: 'Découvre le marketing digital de façon ludique !',
      modules: [
        '📱 Réseaux Sociaux',
        '🎯 Publicité Créative',
        '🎨 Création de Contenu',
        '📊 Analyse Marketing',
        '✨ Image de Marque',
        '🛒 Commerce en Ligne'
      ],
      ageGroups: [
        '5-8 ans : Découverte du marketing',
        '9-12 ans : Concepts avancés',
        '13-14 ans : Stratégies digitales'
      ]
    },
    en: {
      title: 'Digital4Kids - Digital Marketing for Children',
      subtitle: 'Discover digital marketing in a fun way!',
      modules: [
        '📱 Social Media',
        '🎯 Creative Advertising',
        '🎨 Content Creation',
        '📊 Marketing Analytics',
        '✨ Brand Image',
        '🛒 Online Commerce'
      ],
      ageGroups: [
        '5-8 years: Marketing Discovery',
        '9-12 years: Advanced Concepts',
        '13-14 years: Digital Strategies'
      ]
    },
    es: {
      title: 'Digital4Kids - Marketing Digital para Niños',
      subtitle: '¡Descubre el marketing digital de forma divertida!',
      modules: [
        '📱 Redes Sociales',
        '🎯 Publicidad Creativa',
        '🎨 Creación de Contenido',
        '📊 Análisis de Marketing',
        '✨ Imagen de Marca',
        '🛒 Comercio en Línea'
      ],
      ageGroups: [
        '5-8 años: Descubrimiento del marketing',
        '9-12 años: Conceptos avanzados',
        '13-14 años: Estrategias digitales'
      ]
    }
  };

  const t = texts[currentLang as keyof typeof texts] || texts.fr;

  return (
    <div className="App">
      <div className="language-selector">
        <select 
          value={currentLang} 
          onChange={(e) => setCurrentLang(e.target.value)}
        >
          {LANGUAGES.map((lang) => (
            <option key={lang.code} value={lang.code}>
              {lang.flag} {lang.name}
            </option>
          ))}
        </select>
      </div>

      <div className="app-container">
        <h1>🎯 {t.title}</h1>
        <p className="subtitle">{t.subtitle}</p>
        
        <div className="age-groups">
          <h3>👥 Groupes d'âge :</h3>
          {t.ageGroups.map((group, index) => (
            <div key={index} className={`age-group age-${index}`}>
              {group}
            </div>
          ))}
        </div>

        <div className="modules-carousel">
          <h3>📚 Modules d'apprentissage :</h3>
          <div className="module-display">
            <button 
              className="nav-btn prev"
              onClick={() => setCurrentModule((currentModule - 1 + t.modules.length) % t.modules.length)}
            >
              ←
            </button>
            
            <div className="current-module">
              {t.modules[currentModule]}
            </div>
            
            <button 
              className="nav-btn next"
              onClick={() => setCurrentModule((currentModule + 1) % t.modules.length)}
            >
              →
            </button>
          </div>
          
          <div className="module-indicators">
            {t.modules.map((_, index) => (
              <div 
                key={index}
                className={`indicator ${index === currentModule ? 'active' : ''}`}
                onClick={() => setCurrentModule(index)}
              />
            ))}
          </div>
        </div>

        <div className="features">
          <h3>🌟 Fonctionnalités :</h3>
          <div className="features-grid">
            <div className="feature">🧠 Quiz Interactifs</div>
            <div className="feature">📚 E-learning Adapté</div>
            <div className="feature">🎮 Exercices Ludiques</div>
            <div className="feature">📸 Analyse Photos</div>
            <div className="feature">🎲 Jeux Éducatifs</div>
            <div className="feature">📖 Histoires Marketing</div>
          </div>
        </div>

        <div className="action-buttons">
          <button className="btn primary">🚀 Commencer</button>
          <button className="btn secondary">🎮 Jouer</button>
          <button className="btn tertiary">📚 Apprendre</button>
        </div>
      </div>
    </div>
  );
}

export default App;
EOF
    
    cat > src/App.css << 'EOF'
.App {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: white;
  padding: 20px;
  position: relative;
}

.language-selector {
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.15);
  padding: 10px;
  border-radius: 10px;
}

.language-selector select {
  background: white;
  border: none;
  padding: 5px 10px;
  border-radius: 5px;
  cursor: pointer;
}

.app-container {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 3rem;
  text-align: center;
  max-width: 1000px;
  width: 100%;
  animation: float 6s ease-in-out infinite;
}

.app-container h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.subtitle {
  font-size: 1.3rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

.age-groups {
  margin: 2rem 0;
}

.age-group {
  margin: 1rem 0;
  padding: 1rem;
  border-radius: 15px;
  font-weight: 600;
  transition: all 0.3s ease;
  cursor: pointer;
}

.age-group:hover {
  transform: translateX(10px);
}

.age-0 {
  background: linear-gradient(45deg, rgba(255, 107, 107, 0.3), rgba(78, 205, 196, 0.3));
}

.age-1 {
  background: linear-gradient(45deg, rgba(69, 183, 209, 0.3), rgba(149, 225, 211, 0.3));
}

.age-2 {
  background: linear-gradient(45deg, rgba(186, 85, 211, 0.3), rgba(255, 140, 122, 0.3));
}

.modules-carousel {
  margin: 2rem 0;
  background: rgba(255, 255, 255, 0.05);
  padding: 2rem;
  border-radius: 20px;
}

.module-display {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 2rem;
  margin: 1.5rem 0;
}

.nav-btn {
  background: linear-gradient(45deg, #4ECDC4, #44A08D);
  border: none;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  color: white;
  font-size: 1.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.nav-btn:hover {
  transform: scale(1.1);
}

.current-module {
  font-size: 2rem;
  font-weight: bold;
  min-width: 300px;
  padding: 1rem;
  background: linear-gradient(45deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
  border-radius: 15px;
  transition: all 0.5s ease;
}

.module-indicators {
  display: flex;
  justify-content: center;
  gap: 0.5rem;
  margin-top: 1rem;
}

.indicator {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  cursor: pointer;
  transition: all 0.3s ease;
}

.indicator.active {
  background: #4ECDC4;
  transform: scale(1.2);
}

.features {
  margin: 2rem 0;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.feature {
  background: rgba(255, 255, 255, 0.08);
  padding: 1.2rem;
  border-radius: 15px;
  transition: all 0.3s ease;
  cursor: pointer;
}

.feature:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-3px);
}

.action-buttons {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-top: 2rem;
  flex-wrap: wrap;
}

.btn {
  padding: 12px 24px;
  border: none;
  border-radius: 25px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}

.btn.primary {
  background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
  color: white;
}

.btn.secondary {
  background: linear-gradient(45deg, #45B7D1, #96CEB4);
  color: white;
}

.btn.tertiary {
  background: linear-gradient(45deg, #FECA57, #FF9FF3);
  color: white;
}

@media (max-width: 768px) {
  .app-container {
    padding: 2rem;
    margin: 10px;
  }
  
  .module-display {
    flex-direction: column;
    gap: 1rem;
  }
  
  .current-module {
    min-width: auto;
    font-size: 1.5rem;
  }
  
  .features-grid {
    grid-template-columns: 1fr;
  }
  
  .action-buttons {
    flex-direction: column;
    align-items: center;
  }
}
EOF
}

create_default_react_app() {
    local app_name=$1
    
    cat > src/App.tsx << 'EOF'
import React, { useState } from 'react';
import './App.css';

function App() {
  const [currentLang, setCurrentLang] = useState('fr');

  return (
    <div className="App">
      <div className="language-selector">
        <select 
          value={currentLang} 
          onChange={(e) => setCurrentLang(e.target.value)}
        >
          <option value="fr">🇫🇷 Français</option>
          <option value="en">🇺🇸 English</option>
          <option value="es">🇪🇸 Español</option>
        </select>
      </div>

      <div className="app-container">
        <h1>🚀 APPLICATION HYBRIDE</h1>
        <p>Application créée avec succès !</p>
        <div className="status">✅ Prêt pour Web, Android et iOS</div>
      </div>
    </div>
  );
}

export default App;
EOF
    
    cat > src/App.css << 'EOF'
.App {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: white;
  position: relative;
}

.app-container {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 3rem;
  text-align: center;
  max-width: 600px;
}

.app-container h1 {
  font-size: 2.5rem;
  margin-bottom: 2rem;
}

.status {
  background: rgba(0, 255, 0, 0.2);
  padding: 1rem;
  border-radius: 10px;
  margin-top: 2rem;
}

.language-selector {
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.15);
  padding: 10px;
  border-radius: 10px;
}
EOF
}

# =============================================================================
# CRÉATION DES APPLICATIONS VUE.JS
# =============================================================================

create_vue_app() {
    local app_name=$1
    local port=$2
    local category=$3
    
    # Package.json Vue
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
    "@capacitor/ios": "^5.0.0"
  },
  "devDependencies": {
    "@vue/cli-service": "^5.0.0"
  }
}
EOF
    
    mkdir -p src public
    
    # Configuration Capacitor
    cat > capacitor.config.ts << EOF
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.platform.${app_name}',
  appName: '${app_name}',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  }
};

export default config;
EOF
    
    # App.vue
    cat > src/App.vue << 'EOF'
<template>
  <div id="app">
    <div class="language-selector">
      <select v-model="currentLang">
        <option value="fr">🇫🇷 Français</option>
        <option value="en">🇺🇸 English</option>
        <option value="es">🇪🇸 Español</option>
      </select>
    </div>
    
    <div class="app-container">
      <h1>💰 BudgetCron</h1>
      <p>Gestion de budget familial</p>
      
      <div class="budget-form">
        <div class="input-group">
          <label>Revenus:</label>
          <input v-model.number="income" type="number" placeholder="2000">
          <span>€</span>
        </div>
        
        <div class="input-group">
          <label>Dépenses:</label>
          <input v-model.number="expenses" type="number" placeholder="1500">
          <span>€</span>
        </div>
        
        <div class="result" :class="{ positive: balance > 0, negative: balance < 0 }">
          <h2>Solde: {{ balance }}€</h2>
          <p v-if="balance > 0">✅ Budget équilibré !</p>
          <p v-else>⚠️ Attention aux dépenses</p>
        </div>
      </div>
      
      <div class="categories">
        <h3>📊 Catégories:</h3>
        <div class="category-grid">
          <div class="category">🍔 Alimentation</div>
          <div class="category">🚗 Transport</div>
          <div class="category">🏠 Logement</div>
          <div class="category">🎮 Loisirs</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      currentLang: 'fr',
      income: 2000,
      expenses: 1500
    }
  },
  computed: {
    balance() {
      return this.income - this.expenses;
    }
  }
}
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
  position: relative;
}

.language-selector {
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.15);
  padding: 10px;
  border-radius: 10px;
}

.language-selector select {
  background: white;
  border: none;
  padding: 5px 10px;
  border-radius: 5px;
  cursor: pointer;
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
  animation: float 6s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

.app-container h1 {
  font-size: 3rem;
  margin-bottom: 1rem;
  color: #667eea;
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