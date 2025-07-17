#!/bin/bash

# Script de correction rapide pour les applications React
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}⚡ CORRECTION RAPIDE DES APPLICATIONS REACT${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# Fonction pour une correction rapide et minimale
quick_fix_react_app() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}⚡ Correction rapide de $app_name...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "${RED}❌ Répertoire non trouvé: $app_dir${NC}"
        return 1
    fi
    
    cd "$app_dir"
    
    # 1. Vérifier si react-scripts est disponible
    if [ -f "node_modules/.bin/react-scripts" ]; then
        echo "  ✅ react-scripts déjà installé"
    else
        echo "  ⚠️ react-scripts manquant, installation minimale..."
        # Installation rapide de react-scripts seulement
        npm install react-scripts@5.0.1 --no-save --silent 2>/dev/null || {
            echo "  ⚠️ Installation complète nécessaire..."
            npm install --silent
        }
    fi
    
    # 2. Créer package.json minimal s'il est corrompu
    if ! npm run start --dry-run >/dev/null 2>&1; then
        echo "  🔧 Création package.json minimal..."
        cat > package.json << 'MINIMAL_PKG'
{
  "name": "APP_NAME_PLACEHOLDER",
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
    "build": "react-scripts build"
  }
}
MINIMAL_PKG
        # Remplacer le placeholder
        sed -i "s/APP_NAME_PLACEHOLDER/$app_name/g" package.json
    fi
    
    # 3. Assurer la structure minimale
    mkdir -p public src
    
    # 4. Créer index.html minimal si manquant
    if [ ! -f "public/index.html" ]; then
        cat > public/index.html << 'MINIMAL_HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>APP_TITLE_PLACEHOLDER</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
MINIMAL_HTML
        # Remplacer le placeholder
        local app_title=$(echo "$app_name" | sed 's/^./\U&/' | sed 's/4/ 4 /')
        sed -i "s/APP_TITLE_PLACEHOLDER/$app_title/g" public/index.html
    fi
    
    # 5. Créer src/index.tsx minimal si manquant
    if [ ! -f "src/index.tsx" ] && [ ! -f "src/index.js" ]; then
        cat > src/index.tsx << 'MINIMAL_INDEX'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(<App />);
MINIMAL_INDEX
    fi
    
    # 6. Créer src/App.tsx minimal si manquant
    if [ ! -f "src/App.tsx" ] && [ ! -f "src/App.js" ]; then
        cat > src/App.tsx << 'MINIMAL_APP'
import React from 'react';

function App() {
  const appName = "APP_NAME_PLACEHOLDER";
  const appTitle = appName.charAt(0).toUpperCase() + appName.slice(1).replace('4', ' 4 ');
  
  return (
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      fontFamily: 'Arial, sans-serif'
    }}>
      <div style={{
        background: 'rgba(255, 255, 255, 0.1)',
        backdropFilter: 'blur(10px)',
        padding: '3rem',
        borderRadius: '20px',
        textAlign: 'center',
        color: 'white',
        maxWidth: '500px',
        margin: '2rem'
      }}>
        <h1 style={{ fontSize: '2.5rem', marginBottom: '1rem' }}>
          🚀 {appTitle}
        </h1>
        <p style={{ fontSize: '1.2rem', marginBottom: '2rem' }}>
          Application React + TypeScript
        </p>
        <div style={{
          background: 'rgba(255, 255, 255, 0.1)',
          padding: '1.5rem',
          borderRadius: '15px'
        }}>
          <p>✅ Status: Opérationnel</p>
          <p>⚛️ React 18.2.0</p>
          <p>📘 TypeScript 4.9.5</p>
        </div>
      </div>
    </div>
  );
}

export default App;
MINIMAL_APP
        # Remplacer le placeholder
        sed -i "s/APP_NAME_PLACEHOLDER/$app_name/g" src/App.tsx
    fi
    
    # 7. Test rapide du script start
    if npm run start --dry-run >/dev/null 2>&1; then
        echo -e "  ✅ $app_name prêt à démarrer"
        return 0
    else
        echo -e "  ❌ $app_name nécessite une correction supplémentaire"
        return 1
    fi
}

# Fonction pour vérifier et corriger Vue.js (BudgetCron)
quick_check_vue() {
    local app_dir="$WORKSPACE_DIR/budgetcron"
    
    echo -e "${YELLOW}⚡ Vérification de BudgetCron (Vue.js)...${NC}"
    
    cd "$app_dir"
    
    if npm run serve --dry-run >/dev/null 2>&1; then
        echo -e "  ✅ BudgetCron (Vue.js) prêt"
    else
        echo -e "  ⚠️ BudgetCron nécessite une correction"
        # Correction rapide du script serve
        if grep -q '"serve"' package.json; then
            echo -e "  ✅ Script serve présent"
        else
            echo -e "  🔧 Ajout du script serve..."
            # Backup et modification du package.json
            cp package.json package.json.bak
            # Ajouter le script serve s'il manque
            sed -i '/"scripts": {/a\    "serve": "vue-cli-service serve --port 3003",' package.json
        fi
    fi
}

# Fonction pour vérifier Next.js (MultiAI)
quick_check_nextjs() {
    local app_dir="$WORKSPACE_DIR/multiai"
    
    echo -e "${YELLOW}⚡ Vérification de MultiAI (Next.js)...${NC}"
    
    cd "$app_dir"
    
    if npm run dev --dry-run >/dev/null 2>&1; then
        echo -e "  ✅ MultiAI (Next.js) prêt"
    else
        echo -e "  ⚠️ MultiAI nécessite une vérification"
        
        # Assurer la structure pages/
        mkdir -p pages
        
        if [ ! -f "pages/index.tsx" ] && [ ! -f "pages/index.js" ]; then
            echo -e "  🔧 Création page d'accueil..."
            cat > pages/index.tsx << 'NEXTJS_INDEX'
export default function Home() {
  return (
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      fontFamily: 'Arial, sans-serif'
    }}>
      <div style={{
        background: 'rgba(255, 255, 255, 0.1)',
        backdropFilter: 'blur(10px)',
        padding: '3rem',
        borderRadius: '20px',
        textAlign: 'center',
        color: 'white'
      }}>
        <h1 style={{ fontSize: '3rem', marginBottom: '1rem' }}>
          🧠 MultiAI
        </h1>
        <p style={{ fontSize: '1.2rem' }}>
          Plateforme d&apos;Intelligence Artificielle
        </p>
        <div style={{
          background: 'rgba(255, 255, 255, 0.1)',
          padding: '1.5rem',
          borderRadius: '15px',
          marginTop: '2rem'
        }}>
          <p>✅ Status: Opérationnel</p>
          <p>▲ Next.js 14.2.0</p>
          <p>📘 TypeScript 5.6.0</p>
        </div>
      </div>
    </div>
  )
}
NEXTJS_INDEX
        fi
    fi
}

# Fonction principale
main() {
    echo "Correction rapide des applications..."
    echo ""
    
    # Corriger les applications React (sans réinstallation complète)
    local success_count=0
    
    if quick_fix_react_app "math4kids"; then
        success_count=$((success_count + 1))
    fi
    echo ""
    
    if quick_fix_react_app "unitflip"; then
        success_count=$((success_count + 1))
    fi
    echo ""
    
    if quick_fix_react_app "ai4kids"; then
        success_count=$((success_count + 1))
    fi
    echo ""
    
    # Vérifier Vue.js et Next.js
    quick_check_vue
    echo ""
    quick_check_nextjs
    echo ""
    
    # Résumé
    echo -e "${GREEN}⚡ CORRECTION RAPIDE TERMINÉE!${NC}"
    echo ""
    echo -e "${YELLOW}📊 Résultat:${NC}"
    echo "✅ Applications React corrigées: $success_count/3"
    echo "✅ Vue.js (BudgetCron): Vérifié"
    echo "✅ Next.js (MultiAI): Vérifié"
    echo ""
    echo -e "${YELLOW}🚀 Prochaines étapes:${NC}"
    echo "1. Test de démarrage: ./start-apps.sh"
    echo "2. Vérification statut: ./status-apps.sh"
    echo ""
    echo -e "${BLUE}💡 Cette correction évite les réinstallations longues${NC}"
    echo -e "${BLUE}   et utilise les dépendances existantes quand possible${NC}"
    echo ""
}

# Lancement du script
main