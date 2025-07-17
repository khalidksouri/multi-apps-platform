#!/bin/bash

# Script de correction rapide pour la compatibilité shell
set -e

echo "🔧 CORRECTION RAPIDE DE COMPATIBILITÉ SHELL"
echo "============================================"

# Fonction pour capitaliser le nom
capitalize_name() {
    echo "$1" | sed 's/^./\U&/' | sed 's/4/ 4 /'
}

# Correction rapide du script fix_react_scripts_issue.sh
echo "🔧 Correction du script..."

# Remplacer les erreurs de substitution dans le script
sed -i.bak 's/\${app_name\^}/$(capitalize_name "$app_name")/g' fix_react_scripts_issue.sh

# Ajouter la fonction capitalize_name au début du script
cp fix_react_scripts_issue.sh fix_react_scripts_issue.sh.temp

cat > fix_react_scripts_issue.sh << 'EOF'
#!/bin/bash

# Script de correction du problème react-scripts
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fonction pour capitaliser le nom
capitalize_name() {
    echo "$1" | sed 's/^./\U&/' | sed 's/4/ 4 /'
}

echo -e "${BLUE}🔧 CORRECTION DU PROBLÈME REACT-SCRIPTS${NC}"
echo -e "${BLUE}=======================================${NC}"
echo ""

# Fonction pour corriger une application React
fix_react_app() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    local app_title=$(capitalize_name "$app_name")
    
    echo -e "${YELLOW}🔧 Correction de $app_name...${NC}"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "${RED}❌ Répertoire non trouvé: $app_dir${NC}"
        return 1
    fi
    
    cd "$app_dir"
    
    # 1. Nettoyer complètement l'installation
    echo "  🧹 Nettoyage complet..."
    rm -rf node_modules package-lock.json .npmrc 2>/dev/null || true
    
    # 2. Créer un package.json fonctionnel
    echo "  📦 Création d'un package.json fonctionnel..."
    cat > package.json << PKGEOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "typescript": "^4.9.5",
    "web-vitals": "^2.1.4"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "devDependencies": {
    "@types/react": "^18.0.28",
    "@types/react-dom": "^18.0.11",
    "@types/node": "^16.18.12"
  }
}
PKGEOF
    
    # 3. Recréer les dossiers essentiels
    echo "  📁 Recréation de la structure..."
    mkdir -p public src
    
    # 4. Créer index.html dans public
    cat > public/index.html << HTMLEOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta name="description" content="$app_name - Application React TypeScript" />
    <title>$app_title</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
HTMLEOF
    
    # 5. Créer src/index.tsx
    cat > src/index.tsx << INDEXEOF
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
INDEXEOF
    
    # 6. Créer src/App.tsx
    cat > src/App.tsx << APPEOF
import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>🚀 Bienvenue sur $app_title</h1>
        <p>Application React + TypeScript en développement</p>
        <div className="App-info">
          <p>🔧 Status: Opérationnel</p>
          <p>⚛️ Framework: React 18.2.0</p>
          <p>📘 Language: TypeScript 4.9.5</p>
        </div>
      </header>
    </div>
  );
}

export default App;
APPEOF
    
    # 7. Créer src/index.css
    cat > src/index.css << CSSEOF
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}
CSSEOF
    
    # 8. Créer src/App.css
    cat > src/App.css << APPCSSEOF
.App {
  text-align: center;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}

.App-header {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 3rem;
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
  max-width: 500px;
  margin: 2rem;
}

.App-header h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.App-header p {
  font-size: 1.2rem;
  margin-bottom: 2rem;
  opacity: 0.9;
}

.App-info {
  background: rgba(255, 255, 255, 0.1);
  padding: 1.5rem;
  border-radius: 15px;
  margin-top: 2rem;
}

.App-info p {
  margin: 0.5rem 0;
  font-size: 1rem;
  font-family: 'Courier New', monospace;
}

@media (max-width: 768px) {
  .App-header {
    padding: 2rem;
    margin: 1rem;
  }
  
  .App-header h1 {
    font-size: 2rem;
  }
}
APPCSSEOF
    
    # 9. Créer tsconfig.json
    cat > tsconfig.json << TSCONFIGEOF
{
  "compilerOptions": {
    "target": "es5",
    "lib": [
      "dom",
      "dom.iterable",
      "es6"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": [
    "src"
  ]
}
TSCONFIGEOF
    
    # 10. Installation propre
    echo "  📦 Installation des dépendances..."
    npm install --silent
    
    # 11. Test du script start
    echo "  🧪 Test du script start..."
    if npm run start --dry-run >/dev/null 2>&1; then
        echo -e "  ✅ Script 'start' validé"
    else
        echo -e "  ❌ Script 'start' encore invalide"
        return 1
    fi
    
    echo -e "${GREEN}✅ $app_name corrigé avec succès!${NC}"
    return 0
}

# Fonction principale
main() {
    echo "Correction des problèmes de scripts..."
    echo ""
    
    # Corriger les applications React
    fix_react_app "math4kids"
    echo ""
    fix_react_app "unitflip"
    echo ""
    fix_react_app "ai4kids"
    echo ""
    
    echo -e "${GREEN}🎉 CORRECTION DES APPLICATIONS REACT TERMINÉE!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Résumé:${NC}"
    echo "✅ Math4Kids: Corrigé et prêt"
    echo "✅ UnitFlip: Corrigé et prêt"  
    echo "✅ AI4Kids: Corrigé et prêt"
    echo ""
    echo -e "${YELLOW}🚀 Prochaines étapes:${NC}"
    echo "1. Démarrer: ./start-apps.sh"
    echo "2. Statut: ./status-apps.sh"
    echo ""
}

# Lancement du script
main
EOF

chmod +x fix_react_scripts_issue.sh

echo "✅ Script corrigé!"
echo ""
echo "🚀 Relancez maintenant:"
echo "./fix_react_scripts_issue.sh"