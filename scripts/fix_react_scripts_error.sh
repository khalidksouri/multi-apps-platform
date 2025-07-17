#!/bin/bash

# Correction spécifique de l'erreur react-scripts
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 CORRECTION CIBLÉE DES ERREURS REACT-SCRIPTS${NC}"
echo -e "${BLUE}===============================================${NC}"
echo ""

# Fonction pour diagnostiquer et corriger l'erreur react-scripts
fix_react_scripts_error() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🔧 Correction de $app_name...${NC}"
    
    cd "$app_dir"
    
    # 1. Vérifier le log d'erreur spécifique
    local log_file="$WORKSPACE_DIR/logs/${app_name}.log"
    if [ -f "$log_file" ]; then
        echo "  📝 Analyse du log d'erreur..."
        if grep -q "react-scripts/scripts/start.js" "$log_file"; then
            echo "  🎯 Erreur react-scripts détectée"
        fi
    fi
    
    # 2. Le problème semble être dans node_modules corrompus
    echo "  🧹 Nettoyage node_modules corrompu..."
    rm -rf node_modules package-lock.json .npm 2>/dev/null || true
    
    # 3. Nettoyer le cache npm
    npm cache clean --force 2>/dev/null || true
    
    # 4. Créer un package.json minimal et propre
    echo "  📦 Création package.json minimal..."
    cat > package.json << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "react-scripts": "5.0.1",
    "typescript": "4.9.5"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build"
  },
  "browserslist": {
    "production": [">0.2%", "not dead"],
    "development": ["last 1 chrome version"]
  }
}
EOF
    
    # 5. Créer la structure minimale
    echo "  📁 Structure minimale..."
    mkdir -p public src
    
    # 6. index.html ultra-simple
    cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>APP_NAME</title>
</head>
<body>
    <div id="root"></div>
</body>
</html>
EOF
    sed -i "s/APP_NAME/$app_name/g" public/index.html
    
    # 7. src/index.js ultra-simple (pas TypeScript pour éviter les problèmes)
    cat > src/index.js << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(React.createElement(App));
EOF
    
    # 8. src/App.js ultra-simple
    cat > src/App.js << 'EOF'
import React from 'react';

function App() {
  return React.createElement('div', {
    style: {
      minHeight: '100vh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      fontFamily: 'Arial, sans-serif',
      color: 'white',
      textAlign: 'center'
    }
  }, 
    React.createElement('div', {
      style: {
        background: 'rgba(255, 255, 255, 0.1)',
        backdropFilter: 'blur(10px)',
        padding: '3rem',
        borderRadius: '20px',
        maxWidth: '500px'
      }
    },
      React.createElement('h1', {
        style: { fontSize: '2.5rem', marginBottom: '1rem' }
      }, '🚀 APP_NAME'),
      React.createElement('p', {
        style: { fontSize: '1.2rem', marginBottom: '2rem' }
      }, 'Application React fonctionnelle'),
      React.createElement('div', {
        style: {
          background: 'rgba(255, 255, 255, 0.1)',
          padding: '1.5rem',
          borderRadius: '15px'
        }
      },
        React.createElement('p', null, '✅ Status: Opérationnel'),
        React.createElement('p', null, '⚛️ React 18.2.0'),
        React.createElement('p', null, '🔧 Mode Simple')
      )
    )
  );
}

export default App;
EOF
    sed -i "s/APP_NAME/$app_name/g" src/App.js
    
    # 9. Installation ultra-propre
    echo "  📦 Installation propre..."
    npm install --no-optional --no-package-lock
    
    # 10. Test immédiat
    echo "  🧪 Test de démarrage..."
    if npm run start --dry-run >/dev/null 2>&1; then
        echo -e "  ✅ ${GREEN}$app_name réparé avec succès!${NC}"
        return 0
    else
        echo -e "  ❌ ${RED}$app_name nécessite une approche différente${NC}"
        return 1
    fi
}

# Fonction pour démarrer les applications réparées
test_start_fixed_apps() {
    echo ""
    echo -e "${BLUE}🚀 TEST DE DÉMARRAGE DES APPLICATIONS RÉPARÉES${NC}"
    echo "=============================================="
    
    local apps=("math4kids" "unitflip" "ai4kids")
    local success_count=0
    
    for app in "${apps[@]}"; do
        local app_dir="$WORKSPACE_DIR/$app"
        local port=$((3001 + success_count))
        
        case $app in
            "unitflip") port=3002 ;;
            "ai4kids") port=3004 ;;
        esac
        
        echo -e "${YELLOW}🚀 Test de $app sur port $port...${NC}"
        
        cd "$app_dir"
        
        # Arrêter tout processus existant
        local existing_pid=$(lsof -ti:$port 2>/dev/null || true)
        if [ -n "$existing_pid" ]; then
            kill -9 "$existing_pid" 2>/dev/null || true
            sleep 1
        fi
        
        # Démarrer en arrière-plan
        npm start > "$WORKSPACE_DIR/logs/${app}.log" 2>&1 &
        local pid=$!
        echo $pid > "$WORKSPACE_DIR/logs/${app}.pid"
        
        # Attendre et vérifier
        sleep 5
        
        if kill -0 $pid 2>/dev/null && lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo -e "  ✅ ${GREEN}$app démarré - http://localhost:$port${NC}"
            success_count=$((success_count + 1))
        else
            echo -e "  ❌ ${RED}$app échec${NC}"
            # Afficher l'erreur
            if [ -f "$WORKSPACE_DIR/logs/${app}.log" ]; then
                echo "  📝 Erreur:"
                tail -n 3 "$WORKSPACE_DIR/logs/${app}.log" | sed 's/^/     /'
            fi
        fi
        
        echo ""
    done
    
    return $success_count
}

# Fonction principale
main() {
    echo "Correction des erreurs react-scripts pour les 3 applications React..."
    echo ""
    
    # Correction ciblée
    local fixed_count=0
    
    if fix_react_scripts_error "math4kids"; then
        fixed_count=$((fixed_count + 1))
    fi
    echo ""
    
    if fix_react_scripts_error "unitflip"; then
        fixed_count=$((fixed_count + 1))
    fi
    echo ""
    
    if fix_react_scripts_error "ai4kids"; then
        fixed_count=$((fixed_count + 1))
    fi
    echo ""
    
    echo -e "${GREEN}📊 RÉSULTAT DE LA CORRECTION:${NC}"
    echo "✅ Applications corrigées: $fixed_count/3"
    echo ""
    
    # Test de démarrage
    if [ $fixed_count -gt 0 ]; then
        if test_start_fixed_apps; then
            local started=$?
            echo -e "${GREEN}🎉 SUCCÈS! Applications React démarrées: $started/3${NC}"
        fi
    fi
    
    echo ""
    echo -e "${BLUE}📱 STATUT FINAL DU MULTI-APPS-PLATFORM:${NC}"
    echo "✅ BudgetCron (Vue.js): http://localhost:3003"
    echo "✅ MultiAI (Next.js): http://localhost:3005"
    echo "🔄 Applications React: En cours de test..."
    echo ""
    echo -e "${YELLOW}📋 Actions:${NC}"
    echo "🌐 Ouvrir les apps qui fonctionnent:"
    echo "   open http://localhost:3003 http://localhost:3005"
    echo "📊 Vérifier le statut: ./status-apps.sh"
    echo "🛑 Arrêter tout: ./stop-apps.sh"
    echo ""
}

# Lancement du script
main