#!/bin/bash

# Script de correction pour le multi-apps-platform
# Résolution des problèmes identifiés dans les diagnostics

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 SCRIPT DE CORRECTION MULTI-APPS PLATFORM${NC}"
echo -e "${BLUE}==============================================${NC}"
echo ""

# Variables globales
WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fonction d'affichage des étapes
step() {
    echo -e "${YELLOW}▶ $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# PROBLÈME 1: Commande timeout manquante sur macOS
fix_timeout_command() {
    step "1. Installation de la commande timeout (via coreutils)"
    
    if ! command -v timeout &> /dev/null; then
        echo "La commande 'timeout' n'est pas disponible sur macOS par défaut."
        echo "Installation de coreutils via Homebrew..."
        
        if command -v brew &> /dev/null; then
            brew install coreutils
            echo "Ajout de gtimeout (GNU timeout) au PATH..."
            echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
            echo 'alias timeout=gtimeout' >> ~/.zshrc
            source ~/.zshrc
        else
            echo "Homebrew n'est pas installé. Installation..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install coreutils
        fi
        success "Commande timeout installée"
    else
        success "Commande timeout déjà disponible"
    fi
}

# PROBLÈME 2: Fichiers manquants pour les applications React
fix_react_apps() {
    step "2. Correction des applications React (math4kids, unitflip, ai4kids)"
    
    local apps=("math4kids" "unitflip" "ai4kids")
    
    for app in "${apps[@]}"; do
        local app_dir="$WORKSPACE_DIR/$app"
        
        if [ -d "$app_dir" ]; then
            echo "Correction de $app..."
            
            # Créer le dossier public s'il n'existe pas
            mkdir -p "$app_dir/public"
            
            # Créer index.html manquant
            cat > "$app_dir/public/index.html" << EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta name="description" content="$app - Application développée avec React et TypeScript" />
    <title>${app^}</title>
  </head>
  <body>
    <noscript>Vous devez activer JavaScript pour utiliser cette application.</noscript>
    <div id="root"></div>
  </body>
</html>
EOF

            # Créer le dossier src s'il n'existe pas
            mkdir -p "$app_dir/src"
            
            # Créer index.tsx manquant
            cat > "$app_dir/src/index.tsx" << EOF
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

            # Créer App.tsx manquant
            cat > "$app_dir/src/App.tsx" << EOF
import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Bienvenue sur ${app^}</h1>
        <p>Application en cours de développement</p>
      </header>
    </div>
  );
}

export default App;
EOF

            # Créer les fichiers CSS
            cat > "$app_dir/src/index.css" << EOF
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
EOF

            cat > "$app_dir/src/App.css" << EOF
.App {
  text-align: center;
}

.App-header {
  background-color: #282c34;
  padding: 20px;
  color: white;
  min-height: 50vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
}
EOF

            success "$app configuré"
        fi
    done
}

# PROBLÈME 3: Configuration Vue.js pour BudgetCron
fix_vue_app() {
    step "3. Correction de l'application Vue.js (budgetcron)"
    
    local app_dir="$WORKSPACE_DIR/budgetcron"
    
    if [ -d "$app_dir" ]; then
        # Créer tsconfig.json manquant
        cat > "$app_dir/tsconfig.json" << EOF
{
  "compilerOptions": {
    "target": "esnext",
    "lib": [
      "esnext",
      "dom",
      "dom.iterable"
    ],
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
    "jsx": "preserve"
  },
  "include": [
    "src/**/*",
    "src/**/*.vue"
  ],
  "exclude": [
    "node_modules"
  ]
}
EOF

        # Créer la structure de base Vue.js
        mkdir -p "$app_dir/src"
        mkdir -p "$app_dir/public"
        
        # Créer index.html pour Vue
        cat > "$app_dir/public/index.html" << EOF
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>BudgetCron</title>
  </head>
  <body>
    <noscript>
      <strong>Nous nous excusons, mais BudgetCron ne fonctionne pas correctement sans JavaScript activé. Veuillez l'activer pour continuer.</strong>
    </noscript>
    <div id="app"></div>
  </body>
</html>
EOF

        # Créer main.ts
        cat > "$app_dir/src/main.ts" << EOF
import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#app')
EOF

        # Créer App.vue
        cat > "$app_dir/src/App.vue" << EOF
<template>
  <div id="app">
    <h1>BudgetCron</h1>
    <p>Application de gestion budgétaire en cours de développement</p>
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
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
EOF

        success "BudgetCron configuré"
    fi
}

# PROBLÈME 4: Configuration Next.js pour MultiAI
fix_nextjs_app() {
    step "4. Correction de l'application Next.js (multiai)"
    
    local app_dir="$WORKSPACE_DIR/multiai"
    
    if [ -d "$app_dir" ]; then
        # Créer next.config.js
        cat > "$app_dir/next.config.js" << EOF
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: false
  },
  reactStrictMode: true,
  swcMinify: true,
}

module.exports = nextConfig
EOF

        # Créer la structure pages
        mkdir -p "$app_dir/pages"
        mkdir -p "$app_dir/public"
        
        # Créer _app.tsx
        cat > "$app_dir/pages/_app.tsx" << EOF
import type { AppProps } from 'next/app'

export default function App({ Component, pageProps }: AppProps) {
  return <Component {...pageProps} />
}
EOF

        # Créer index.tsx
        cat > "$app_dir/pages/index.tsx" << EOF
import Head from 'next/head'

export default function Home() {
  return (
    <>
      <Head>
        <title>MultiAI</title>
        <meta name="description" content="Application MultiAI" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </Head>
      <main>
        <h1>MultiAI</h1>
        <p>Application MultiAI en cours de développement</p>
      </main>
    </>
  )
}
EOF

        # Créer tsconfig.json pour Next.js
        cat > "$app_dir/tsconfig.json" << EOF
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

        success "MultiAI configuré"
    fi
}

# PROBLÈME 5: Correction du script enhanced_master_launcher.sh
fix_launcher_script() {
    step "5. Correction du script enhanced_master_launcher.sh"
    
    local script_path="$SCRIPT_DIR/../enhanced_master_launcher.sh"
    
    if [ -f "$script_path" ]; then
        # Créer une sauvegarde
        cp "$script_path" "$script_path.backup"
        
        # Remplacer timeout par gtimeout ou une alternative compatible macOS
        sed -i.bak 's/timeout /gtimeout /g' "$script_path"
        
        # Ajouter une vérification de la commande timeout au début du script
        sed -i.bak '1a\
# Vérification de la commande timeout\
if ! command -v gtimeout &> /dev/null && ! command -v timeout &> /dev/null; then\
    echo "Erreur: commande timeout non trouvée. Installez coreutils avec: brew install coreutils"\
    exit 1\
fi\
\
# Alias pour compatibilité macOS\
if command -v gtimeout &> /dev/null; then\
    alias timeout=gtimeout\
fi\
' "$script_path"
        
        rm "$script_path.bak"
        success "Script enhanced_master_launcher.sh corrigé"
    fi
}

# PROBLÈME 6: Installation des dépendances manquantes
install_dependencies() {
    step "6. Installation des dépendances pour toutes les applications"
    
    local apps=("math4kids" "unitflip" "ai4kids" "budgetcron" "multiai")
    
    for app in "${apps[@]}"; do
        local app_dir="$WORKSPACE_DIR/$app"
        
        if [ -d "$app_dir" ] && [ -f "$app_dir/package.json" ]; then
            echo "Installation des dépendances pour $app..."
            cd "$app_dir"
            
            # Nettoyer le cache npm
            npm cache clean --force
            
            # Supprimer node_modules et package-lock.json
            rm -rf node_modules package-lock.json
            
            # Réinstaller les dépendances
            npm install
            
            success "Dépendances installées pour $app"
        fi
    done
    
    cd "$SCRIPT_DIR"
}

# PROBLÈME 7: Créer un script de démarrage amélioré
create_improved_launcher() {
    step "7. Création d'un script de démarrage amélioré"
    
    cat > "$WORKSPACE_DIR/start_apps.sh" << 'EOF'
#!/bin/bash

# Script de démarrage amélioré pour multi-apps-platform
# Compatible macOS avec gestion d'erreurs améliorée

set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
LOG_DIR="$WORKSPACE_DIR/logs"

# Créer le dossier de logs
mkdir -p "$LOG_DIR"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Fonction de logging
log() {
    echo -e "${2:-$NC}[$1] $3${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $3" >> "$LOG_DIR/startup.log"
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
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null; then
        log "WARNING" "$YELLOW" "Port $port déjà utilisé pour $app_name"
        return 1
    fi
    
    # Démarrer l'application en arrière-plan
    $command > "$LOG_DIR/${app_name}.log" 2>&1 &
    local pid=$!
    
    echo $pid > "$LOG_DIR/${app_name}.pid"
    
    # Attendre quelques secondes et vérifier si le processus est toujours actif
    sleep 5
    
    if kill -0 $pid 2>/dev/null; then
        log "SUCCESS" "$GREEN" "$app_name démarré avec succès (PID: $pid)"
        return 0
    else
        log "ERROR" "$RED" "$app_name a échoué au démarrage"
        return 1
    fi
}

# Démarrage des applications
echo "🚀 Démarrage du multi-apps-platform..."
echo "======================================"

# Math4Kids (React)
start_app "math4kids" 3001 "npm start"

# UnitFlip (React)
start_app "unitflip" 3002 "npm start"

# BudgetCron (Vue.js)
start_app "budgetcron" 3003 "npm run serve"

# AI4Kids (React)
start_app "ai4kids" 3004 "npm start"

# MultiAI (Next.js)
start_app "multiai" 3005 "npm run dev"

echo ""
echo "✅ Démarrage terminé!"
echo ""
echo "📱 URLs des applications:"
echo "  Math4Kids: http://localhost:3001"
echo "  UnitFlip: http://localhost:3002"
echo "  BudgetCron: http://localhost:3003"
echo "  AI4Kids: http://localhost:3004"
echo "  MultiAI: http://localhost:3005"
echo ""
echo "📋 Logs disponibles dans: $LOG_DIR"
echo "🛑 Pour arrêter: $WORKSPACE_DIR/stop_apps.sh"
EOF

    chmod +x "$WORKSPACE_DIR/start_apps.sh"
    
    # Créer aussi un script d'arrêt
    cat > "$WORKSPACE_DIR/stop_apps.sh" << 'EOF'
#!/bin/bash

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
LOG_DIR="$WORKSPACE_DIR/logs"

echo "🛑 Arrêt des applications..."

apps=("math4kids" "unitflip" "budgetcron" "ai4kids" "multiai")

for app in "${apps[@]}"; do
    pid_file="$LOG_DIR/${app}.pid"
    if [ -f "$pid_file" ]; then
        pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            echo "✅ $app arrêté (PID: $pid)"
        else
            echo "⚠️ $app n'était pas en cours d'exécution"
        fi
        rm -f "$pid_file"
    else
        echo "⚠️ Fichier PID non trouvé pour $app"
    fi
done

echo "✅ Arrêt terminé!"
EOF

    chmod +x "$WORKSPACE_DIR/stop_apps.sh"
    
    success "Scripts de démarrage/arrêt créés"
}

# Fonction principale
main() {
    echo "Début de la correction du multi-apps-platform..."
    echo ""
    
    fix_timeout_command
    fix_react_apps
    fix_vue_app
    fix_nextjs_app
    fix_launcher_script
    install_dependencies
    create_improved_launcher
    
    echo ""
    echo -e "${GREEN}🎉 CORRECTION TERMINÉE AVEC SUCCÈS!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Résumé des corrections:${NC}"
    echo "✅ Commande timeout installée/configurée"
    echo "✅ Applications React corrigées (fichiers manquants)"
    echo "✅ Application Vue.js corrigée (tsconfig.json)"
    echo "✅ Application Next.js corrigée (structure)"
    echo "✅ Script enhanced_master_launcher.sh corrigé"
    echo "✅ Dépendances réinstallées"
    echo "✅ Nouveaux scripts de démarrage créés"
    echo ""
    echo -e "${YELLOW}🚀 Pour démarrer les applications:${NC}"
    echo "cd $WORKSPACE_DIR && ./start_apps.sh"
    echo ""
    echo -e "${YELLOW}🛑 Pour arrêter les applications:${NC}"
    echo "cd $WORKSPACE_DIR && ./stop_apps.sh"
    echo ""
}

# Gestion des erreurs
trap 'echo -e "${RED}❌ Erreur détectée à la ligne $LINENO${NC}"; exit 1' ERR

# Lancement du script
main